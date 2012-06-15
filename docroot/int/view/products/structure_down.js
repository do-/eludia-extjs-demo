Ext.define ('UI.view.products.structure_down', {

	extend: 'Ext.window.Window',
	closeAction: 'hide',
	maximizable : true,
	width:  '95%',
	height: '95%',
	layout: 'fit',
	constrainHeader: true,
	autoShow: true,

	initComponent: function () {

		var me = this;

		me.items = [

			Ext.create ('UI.view.products.structure_down_tree')

		];

		this.callParent (arguments);

	}


});