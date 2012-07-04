Ext.define ('UI.view.docs.edit', {

	extend: 'Ext.window.Window',
	alias : 'widget.docs_edit',
	closeAction: 'hide',

	title : 'Документ',
	layout: 'fit',
	constrainHeader: true,
	autoShow: true,
	width: '90%',
	height: '90%',

	initComponent: function () {

		var me = this;

		me.items = [

			{
				xtype: 'tabpanel',
				items: [
					Ext.create ('UI.view.docs.edit_main')
					, Ext.create ('UI.view.docs.tasks')
				]
			}

		];

		this.callParent (arguments);

	}

});
