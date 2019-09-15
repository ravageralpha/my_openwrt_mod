'use strict';
'require rpc';
'require form';
'require network';

var callGetPostScript = rpc.declare({
	object: 'luci.shadowvpn',
	method: 'getScript',
	params: [ 'interface' ],
	expect: { '': {} }
});

var callSetPostScript = rpc.declare({
	object: 'luci.shadowvpn',
	method: 'setScript',
	params: [ 'interface', 'ifup', 'ifdown' ],
	expect: { '': {} }
});

return network.registerProtocol('shadowvpn', {
	getI18n: function() {
		return _('ShadowVPN');
	},

	getIfname: function() {
		return this._ubus('l3_device') || 'vpn-%s'.format(this.sid);
	},

	getOpkgPackage: function() {
		return 'ShadowVPN';
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
		o.datatype = 'host(0)';
		o.optional = false;

		o = s.taboption('general', form.Value, 'port', _('VPN Server port'));
		o.datatype = 'port';
		o.optional = false;

		o = s.taboption('general', form.Value, 'password', _('Password'));
		o.password = true;
		o.optional = false;

		o = s.taboption('general', form.Value, 'usertoken', _('User Token'));
		o.optional = true;

		o = s.taboption('general', form.Value, 'mtu', _('Override MTU'));
		o.default = 1432;
		o.placeholder = 1432;
		o.datatype = 'range(68, 1500)';

		o = s.taboption('general', form.Value, 'concurrency', _('Concurrency'));
		o.default = 1;
		o.placeholder = 1;

		o = s.taboption('general', form.Value, 'localnet', _('Local Address'));
		o.default = "10.7.0.2/24"
		o.placeholder = "10.7.0.2/24"
		o.optional = false

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
