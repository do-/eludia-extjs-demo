Ext.define ('UI.view.reports.projects_execution.list', {

	extend: 'Ext.window.Window',
	closeAction: 'hide',

	title : 'Выполнение проектов',
	layout: 'fit',
	constrainHeader: true,
	autoShow: true,
	width: '95%',
	height: '95%',
	defaultFocus : 'dt_from',

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
                    type: 'projects_status_report',
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
						xtype:  'fieldcontainer',
						layout: 'hbox',
						style: 'border: 0;',
						fieldLabel: 'Период',
//						width:  400,
						items:  [
							{
								xtype     : 'datefield',
								name      : 'dt_from',
								fieldLabel: 'с',
								style:      'margin: 0 10;',
								format:     'd.m.Y',
								width:      300
							},
							{
								xtype     : 'datefield',
								name      : 'dt_to',
								fieldLabel: 'по',
								style:      'margin: 0 10;',
								format:     'd.m.Y',
								width:      300
							}
						]
					},
					{
						fieldLabel: 'Изделие',
						name:       'product_ids',
						multiSelect: true,
//						width:      350,
						xtype:      'combovocfield',
						type:       'products',
						pageSize:   true,

						params:     {
								type: 'products',
								as_voc: 1
						}

					},
					{
						fieldLabel: 'Бренд',
						name:       'voc_brand_ids',
						multiSelect: true,
//						width:      350,
						xtype:      'combovocfield',
						table:       'voc_brands'
					},
					{
						fieldLabel: 'Тип товара',
						name:       'voc_good_type_ids',
						multiSelect: true,
						xtype:      'combovocfield',
						table:       'voc_good_types'
					},
					{
						fieldLabel: 'Категория',
						name:       'voc_good_kind_ids',
						multiSelect: true,
						xtype:      'combovocfield',
						table:       'voc_good_kinds'
					},
					{
						fieldLabel: 'Отв. менеджер',
						name:       'id_user_executor_manager',
						xtype:      'combovocfield',
						type:       'users',
						pageSize:   true
					},
					// {
					// 	fieldLabel: 'Исполнитель',
					// 	name:       'id_user_executor',
					// 	xtype:      'combovocfield',
					// 	type:       'users',
					// 	pageSize:   true
					// },
					{
						fieldLabel: 'Статус проекта',
						name:       'id_task_route_item_status',
						xtype:      'combovocfield',
						table:       'task_route_item_status'
					}
					//, {
					// 	fieldLabel: 'Статус задачи',
					// 	name:       'id_task_status',
					// 	xtype:      'combovocfield',
					// 	table:       'task_status'
					// },



					// {
					// 	xtype:'textfield',
					// 	fieldLabel: 'Задержка исполнения',
					// 	name: 'delay'
					// }

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
					})
				}
			}
		];

		this.callParent (arguments);

	}

});
