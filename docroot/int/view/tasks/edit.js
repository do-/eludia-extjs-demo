Ext.define ('UI.view.tasks.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.tasks_edit',
    closeAction: 'hide',

    title : 'Задача',
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
					Ext.create ('UI.view.tasks.edit_main')
					, Ext.create ('UI.view.tasks.files')
				]
			}

		];

		this.callParent (arguments);

	}

});
