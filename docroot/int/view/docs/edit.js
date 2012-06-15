Ext.define ('UI.view.docs.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.docs_edit',
    closeAction: 'hide',

    title : 'Документ',
    layout: 'fit',
    constrainHeader: true,
    autoShow: true,
    width: '95%',
    height: '95%',
    defaultFocus : 'label',

	initComponent: function () {

		var me = this;

		me.items = [

			Ext.create ('UI.view.docs.edit_main')

		];

		this.callParent (arguments);

	}

});
