#!/bin/sh
# ============================================================
# WS3006 断网问题一键取证脚本
#
# 使用方法（给现场）：
#   1. 断网发生时，在路由器 SSH/LuCI 终端执行：
#        sh ws3006-capture.sh
#   2. 设备恢复正常（重启）后，再执行一次（正常基线对照）
#   3. 把生成的 /tmp/ws3006-debug-*.txt 发回来（两个都要）
#
# 全程只读采集，不改任何配置、不影响现场。
# ============================================================

OUT="/tmp/ws3006-debug-$(date +%Y%m%d-%H%M%S).txt"

section() { echo; echo "==================== $* ===================="; }
run_sh()  { echo "--- \$ $*"; sh -c "$*" 2>&1; echo; }

# ---------- 自制超时（部分固件 busybox 无 timeout 命令） ----------
run_tmo() {
    secs="$1"; shift
    "$@" &
    pid=$!
    ( sleep "$secs"; kill -9 $pid 2>/dev/null ) &
    watcher=$!
    wait $pid 2>/dev/null
    ret=$?
    kill -9 $watcher 2>/dev/null
    wait $watcher 2>/dev/null
    return $ret
}

# ---------- AT 口探测：优先 qmodem 配置，再逐个试 ttyUSB ----------
AT_PORT=""
find_at_port() {
    local p r
    for p in $(uci -q show qmodem 2>/dev/null | grep "at_port=" | cut -d"'" -f2); do
        [ -c "$p" ] && { AT_PORT="$p"; return 0; }
    done
    for p in /dev/ttyUSB0 /dev/ttyUSB1 /dev/ttyUSB2 /dev/ttyUSB3; do
        [ -c "$p" ] || continue
        r=$(run_tmo 5 tom_modem "$p" ATI 2>/dev/null || run_tmo 5 at "$p" ATI 2>/dev/null)
        case "$r" in
            *Revision*|*Quectel*|*OK*) AT_PORT="$p"; return 0 ;;
        esac
    done
    return 1
}

atcmd() {
    echo "--- AT: $1"
    if [ -n "$AT_PORT" ]; then
        run_tmo 8 tom_modem "$AT_PORT" "$1" 2>&1 || run_tmo 8 at "$AT_PORT" "$1" 2>&1
    else
        echo "(!! AT 口未找到)"
    fi
    echo
}

# ---------- 模组网口探测（ping 强制出口用） ----------
WAN_DEV=$(ifstatus 5g1 2>/dev/null | jsonfilter -q -e '@.device' 2>/dev/null)
[ -z "$WAN_DEV" ] && for d in wwan0_1 wwan0; do
    ip link show "$d" >/dev/null 2>&1 && WAN_DEV="$d" && break
done

main() {
section "1. 基本信息"
run_sh "date; uptime"
run_sh "cat /tmp/sysinfo/board_name 2>/dev/null"
run_sh "cat /etc/openwrt_release 2>/dev/null | grep -E 'DISTRIB_DESCRIPTION|DISTRIB_REVISION'"

section "2. 网络接口与路由"
run_sh "ifconfig -a"
run_sh "ip -s link"
run_sh "ip rule 2>/dev/null"
run_sh "ip route show table all 2>/dev/null"
run_sh "ifstatus 5g1 2>/dev/null"
run_sh "ifstatus 5g2 2>/dev/null"
run_sh "uci -q show qmodem"

section "3. 连通性测试（强制走模组口，排除路由策略干扰）"
echo "模组网口自动识别为: ${WAN_DEV:-未找到}"
run_sh "ping -c 3 -W 2 223.5.5.5"
run_sh "ping -c 3 -W 2 -I ${WAN_DEV:-wwan0} 223.5.5.5"
run_sh "ping -c 3 -W 2 -I ${WAN_DEV:-wwan0} 8.8.8.8"

section "4. 模组网口计数器（间隔 5 秒采两次，看是否冻结）"
run_sh "ip -s link show ${WAN_DEV:-wwan0}"
echo "--- sleep 5 后第二次采样 ---"
sleep 5
run_sh "ip -s link show ${WAN_DEV:-wwan0}"

section "5. 模组 AT 取证"
if find_at_port; then
    echo "AT 口: $AT_PORT"
else
    echo "(!! AT 口探测失败，逐口重试结果如下)"
fi
atcmd "ATI"
atcmd "AT+CGMR"
atcmd "AT+CPIN?"
atcmd "AT+CSQ"
atcmd "AT+QNWINFO"
atcmd "AT+CEREG?"
atcmd "AT+CGREG?"
atcmd "AT+CGATT?"
atcmd "AT+CGACT?"
atcmd 'AT+QENG="servingcell"'
atcmd "AT+QNETDEVSTATUS=1"
atcmd 'AT+QNWCFG="up/down"'

section "6. USB 层状态"
run_sh "lsusb"
run_sh "lsusb -t"
run_sh "ls /sys/bus/usb/devices/ 2>/dev/null"
for u in 2-1.2 2-1.4; do
    run_sh "cat /sys/bus/usb/devices/$u/power/control 2>/dev/null && cat /sys/bus/usb/devices/$u/power/runtime_status 2>/dev/null || echo \"$u 不存在\""
done

section "7. 内核与系统日志（尾部）"
run_sh "dmesg | tail -n 80"
run_sh "logread | tail -n 150"

section "8. 完成"
echo "取证文件: $OUT"
}

main 2>&1 | tee "$OUT"
