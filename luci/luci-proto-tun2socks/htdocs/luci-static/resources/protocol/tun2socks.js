'use strict';
'require rpc';
'require form';
'require network';

var callGetPostScript = rpc.declare({
	object: 'luci.tun2socks',
	method: 'getScript',
	params: [ 'interface' ],
	expect: { '': {} }
});

var callSetPostScript = rpc.declare({
	object: 'luci.tun2socks',
	method: 'setScript',
	params: [ 'interface', 'ifup', 'ifdown' ],
	expect: { '': {} }
});

return network.registerProtocol('tun2socks', {
	getI18n: function() {
		return _('tun2socks');
	},

	getIfname: function() {
		return this._ubus('l3_device') || 'vpn-%s'.format(this.sid);
	},

	getOpkgPackage: function() {
		return 'tun2socks';
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

		o = s.taboption('general', form.Value, 'server', _('Socks Server'));
		o.placeholder = "127.0.0.1:1080"
		o.optional = false;

		o = s.taboption('general', form.Value, 'remote', _('Remote Server Address'));
		o.datatype = 'host(0)';
		o.optional = false;

		o = s.taboption('general', form.Value, 'localnet', _('Subnet'));
		o.default = "10.0.0.2/24"
		o.placeholder = "10.0.0.2/24"
		o.optional = false;

		o = s.taboption('general', form.Value, 'localdns', _('Local DNS(Direct Connect)'));
		o.optional = true;

		o = s.taboption('general', form.Value, 'opts', _('Extra Options'));
		o.optional = true;

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
