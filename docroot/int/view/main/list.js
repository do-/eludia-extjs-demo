Ext.define ('UI.view.main.list', {

	extend: 'Ext.container.Viewport',
	layout: 'border',

	initComponent: function () {

		var me = this;

		me.items = [

			{
				xtype:       'panel',
				region:      'west',
				title :      'Меню',
				margins:     '5 0 5 5',
				split:       true,
				width:       210,
				layout:      'accordion',
				collapsible: true,
				hidden:      true,
				id:          'left_menu',
				items: [
					Ext.create ('UI.view.doc_folders.list', {}),
					Ext.create ('UI.view.voc_groups.list',  {}),
					Ext.create ('UI.view.vocs.list',        {})
				]
			},
			{
				xtype:  'panel',
				region: 'center',
				id:     'center',
				html:  '<table width="100%" height="100%" cellpadding="0" cellspacing="0" _background="/i/background.jpg"><tr><td>&nbsp;</td></tr></table>'
			}

		];

		me.listeners = {afterrender: {fn: function () {

			me.getEl().on ('contextmenu', showWindowListMenu);

		}}};

		this.callParent (arguments);

	}

});