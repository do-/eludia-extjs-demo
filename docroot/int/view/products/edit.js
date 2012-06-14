Ext.define ('UI.view.products.edit', {

	extend: 'Ext.window.Window',
	alias : 'widget.products_edit',
	closeAction: 'hide',

	title : 'Номенклатурная единица',
	layout: 'fit',
	constrainHeader: true,
	autoShow: true,
	width: '95%',
	height: '95%',
	defaultFocus : 'label',

	initComponent: function () {

		var me = this;

		me.items = [

			{
				xtype: 'tabpanel',
				layout: 'hbox',
				items: [
					Ext.create ('UI.view.products.edit_main')
					, Ext.create ('UI.view.products.structure')
				]
			}

		];

		this.callParent (arguments);

	}


});
