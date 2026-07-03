'use strict';
'require view';
'require fs';
'require form';
'require uci';
'require tools.widgets as widgets';

return view.extend({
	load: function () {
		return Promise.all([
			uci.load('fancontrol')
		]);
	},
	render: function (data) {
		var m, s, o;

		m = new form.Map('fancontrol', _('Fan General Control'));
		s = m.section(form.TypedSection, 'fancontrol', _('Settings'));
		s.anonymous = true;

		o = s.option(form.Flag, 'enabled', _('Enabled'), _('Enabled'));
		o.rmempty = false;

		o = s.option(form.Value, 'thermal_file', _('Thermal File'), _('Thermal File'));
		o.placeholder = '/sys/class/thermal/thermal_zone0/temp';

		// Safe read: don't crash if sysfs path doesn't exist
		var thermal_path = uci.get('fancontrol', 'settings', 'thermal_file') || o.placeholder;
		fs.read_direct(thermal_path).then(function (raw) {
			var temp_div = uci.get('fancontrol', 'settings', 'temp_div') || 1000;
			var temp = parseInt(raw);
			if (temp_div > 0 && temp > 0) {
				o.description = _('Current temperature:') + ' <b>' + (temp / temp_div) + '°C</b>';
			}
		}).catch(function () {
			o.description = _('Thermal File (sensor not available)');
		});

		o = s.option(form.Value, 'fan_file', _('Fan File'), _('Fan Speed File'));
		o.placeholder = '/sys/class/hwmon/hwmon1/pwm1';

		// Safe read: don't crash if sysfs path doesn't exist
		var fan_path = uci.get('fancontrol', 'settings', 'fan_file') || o.placeholder;
		fs.read_direct(fan_path).then(function (raw) {
			var speed = parseInt(raw);
			o.description = _('Current speed:') + ' <b>' + speed + '</b>';
		}).catch(function () {
			o.description = _('Fan Speed File (device not available)');
		});

		o = s.option(form.Value, 'start_speed', _('Initial Speed'), _('Please enter the initial speed for fan startup.'));
		o.placeholder = '35';

		o = s.option(form.Value, 'max_speed', _('Max Speed'), _('Please enter maximum fan speed.'));
		o.placeholder = '255';

		o = s.option(form.Value, 'start_temp', _('Start Temperature'), _('Please enter the fan start temperature.'));
		o.placeholder = '45';

		return m.render();
	}
});
