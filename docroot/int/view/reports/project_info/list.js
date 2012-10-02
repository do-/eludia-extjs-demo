Ext.define ('UI.view.reports.project_info.list', {

	extend: 'Ext.window.Window',
	closeAction: 'hide',

	title : 'Проект (основные сведения)',
	layout: 'fit',
	constrainHeader: true,
	autoShow: true,
	width: '95%',
	height: '95%',
	defaultFocus : 'id_product_sheet',

	initComponent: function () {

		var me = this;

		me.items = [

			{
				xtype: 'formpanel',
				bodyStyle:'padding:5px 5px 0',
				layout: 'anchor',
				standardSubmit: true,
				fieldDefaults: {
					anchor: '100%'
				},
                baseParams: {
                    type: 'project_report',
                    action: 'update'
                },
				items: [
					{
						xtype : 'hiddenfield',
						name  : 'sid',
						value : Ext.Ajax.extraParams.sid,
						hidden: true
					},
					{
						xtype: 'FileDownloader',
						id: 'FileDownloader'
					},
					{
						fieldLabel: 'Проект',
						name:       '_id_product_sheet',
//						width:      350,
						xtype:      'combovocfield',
						type:       'docs',
						pageSize:   true,

						params:     {
								type: 'docs',
								as_voc: 1,
								id_doc_type: 100078
						}

					}

				]
			}

		];

		me.buttons = [
			{
				text: 'Сформировать',
				handler: function () {
//					submit (me.down ('form').getForm ());

					me.down ('form').getForm ().submit ({
						url:   '/handler',
						target:'downloadIframe',
						method:'POST'
					});
				}
			}
		];

		this.callParent (arguments);

	}

});
