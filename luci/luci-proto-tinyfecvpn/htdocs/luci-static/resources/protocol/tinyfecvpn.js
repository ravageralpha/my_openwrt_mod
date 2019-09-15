'use strict';
'require rpc';
'require form';
'require network';

var callGetPostScript = rpc.declare({
	object: 'luci.tinyfecvpn',
	method: 'getScript',
	params: [ 'interface' ],
	expect: { '': {} }
});

var callSetPostScript = rpc.declare({
	object: 'luci.tinyfecvpn',
	method: 'setScript',
	params: [ 'interface', 'ifup', 'ifdown' ],
	expect: { '': {} }
});

return network.registerProtocol('tinyfecvpn', {
	getI18n: function() {
		return _('tinyFecVPN');
	},

	getIfname: function() {
		return this._ubus('l3_device') || 'vpn-%s'.format(this.sid);
	},

	getOpkgPackage: function() {
		return 'tinyfecvpn';
	},

	isFloating: function() {
		return true;
	},

	isVirtual: function() {
		return true;
	},

	getDevices: function() {
		return null;
	},

	containsDevice: function(ifname) {
		return (network.getIfnameOf(ifname) == this.getIfname());
	},

	renderFormOptions: function(s) {
		var dev = this.getDevice().getName(),
			LoadScript = null,
		    o;

		o = s.taboption('general', form.Value, 'server', _('VPN Server'));
		o.optional = false;
		o.placeholder = "123.123.123.123:123"

		o = s.taboption('general', form.Value, 'passwd', _('Password'));
		o.password = true;
		o.optional = false;

		o = s.taboption('general', form.Value, 'fec', _('FEC'));
		o.default = "20:10"
		o.placeholder = "20:10"

		o = s.taboption('general', form.Value, 'subnet', _('Subnet'));
		o.default = "10.0.0.0"
		o.placeholder = "10.0.0.0"
		o.optional = false

		o = s.taboption('general', form.Value, 'extra', _('Extra Options'));
		o.placeholder = "--keep-reconnect 1";

		o = s.taboption('general', form.TextValue, 'ifup', _('Post Connection Script'));
		o.rows = 15;
		o.monospace = true;
		o.load = function(section_id) {
			LoadScript = LoadScript || callGetPostScript(section_id);
			return LoadScript.then(function(script) { return script.ifup });
		};
		o.write = function(section_id, value) {
			return callSetPostScript(section_id, value, null);
		};

		o = s.taboption('general', form.TextValue, 'ifdown', _('Post Disconnection Script'));
		o.rows = 15;
		o.monospace = true;
		o.load = function(section_id) {
			LoadScript = LoadScript || callGetPostScript(section_id);
			return LoadScript.then(function(script) { return script.ifdown });
		};
		o.write = function(section_id, value) {
			return callSetPostScript(section_id, null, value);
		};
	}
});
