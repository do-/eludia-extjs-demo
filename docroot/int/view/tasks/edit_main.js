Ext.define ('UI.view.tasks.edit_main', {

	extend: 'Ext.ux.ludi.form.FormPanel',

	autoScroll: true,

	title: 'Общие',

	bodyStyle:'padding:5px 5px 0',

	fieldDefaults: {
//		labelAlign: 'top',
//		border: 0
		flex: 1
	},

	initComponent: function () {

		var me = this;

		me.layout = 'eludia';

		me.items = [
			{
				xtype : 'hiddenfield',
				name  : 'id',
				hidden: true
			},
			{
				xtype : 'hiddenfield',
				name  : '_id_type',
				hidden: true
			},
			{
				xtype : 'hiddenfield',
				name  : '_id_task_route_task',
				hidden: true
			},
			[
				{
					xtype:  'fieldcontainer',
					layout: 'hbox',
					style: 'border: 0;padding: 0;',
					width:  400,
					items:  [
						{
							xtype:      'displayfield',
							flex:       2,

							fieldLabel: 'Номер',
							name:       'no'
						}
						, {
							xtype:      'displayfield',
							flex:       3,

							fieldLabel: 'от',
							name:       'dt'
						}
					]
				},
				{
					xtype:      'combovocfield',

					fieldLabel: 'Статус',
					name:       'id_task_status',
					table:      'task_status',

					readOnly:   true
				}
			],

			{
				xtype:      'combovocfield',

				fieldLabel: 'Важность',
				name:       'id_task_importance',
				table:      'task_importances'
			},
			[
				{
					xtype:      'combovocfield',

					fieldLabel: 'Тип задачи',
					name:       'id_task_type',
					table:      'task_types',
					width:      400,

					readOnly:   true
				},
				{
					xtype:      'displayfield',

					fieldLabel: 'Инициатор',
					name:       'user_initiator.label',
					width:      400
				}
			],
			{
				xtype: 'textarea',

				fieldLabel: 'Описание',
				name:       'label',
				cols:       120,
				rows:       5,
				grow:       true
			}
			,
			{
				xtype:  'fieldcontainer',
				layout: 'hbox',
				width:  800,
//				style: 'border: 0;padding: 0;',
//					width:  400,
				items:  [
					{
						xtype:      'displayfield',

						fieldLabel: 'Документ-основание',
						name:       'base_doc_label',
						flex:       4
					}
					, {
						xtype:      'button',

						text:       'открыть',

						handler:    function () {

							var url  = '?type=docs&id=' + this.up('form').getForm().findField ('_id_type').getValue();
							var win  = Ext.create ('UI.view.docs.edit');

							ajax (
								url,
								function (data, form) {
									setFormData (data, form);
									win.down('#doc_tasks').store.proxy.extraParams.id_type = data.content.id;
									win.down('#doc_tasks').store.load ();
								},
								win.down ('form').getForm ()
							);

						}
					}
				]
			},
			{
				fieldLabel: 'Исполнитель',
				name:       'id_user_executor',
				width:      500,
				xtype:      'combovocfield',
				type:       'users',
				pageSize:   true
			},
			{
				fieldLabel: 'Контролер',
				name:       'id_user_inspector',
				width:      500,
				xtype:      'combovocfield',
				type:       'users',
				pageSize:   true
			},
			[
				{
					xtype     : 'displaydatetimefield',
					name      : 'dt_from_plan',
					fieldLabel: 'Дата начала плановая',
					width:      400
				},
				{
					xtype     : 'displaydatetimefield',
					name      : 'dt_to_plan',
					fieldLabel: 'Дата завершения плановая',
					width:      400
				}
			],
			[
				{
					xtype     : 'displaydatetimefield',
					name      : 'dt_from_fact',
					fieldLabel: 'Дата начала фактическая',
					width:      400
				},
				{
					xtype     : 'displaydatetimefield',
					name      : 'dt_to_fact',
					fieldLabel: 'Дата завершения плановая',
					width:      400
				}
			],
			{
				xtype:      'combovocfield',
				type:       'task_route_task_results',

				fieldLabel: 'Результат задачи',
				name:       'id_task_route_task_result',
				emptyText:  '[Укажите результат выполнения задачи]',
				width:      500,
				readOnly:   1,
				listeners:  {
					change: {
						fn : function () {this.store.proxy.extraParams.id_task_route_task = this.up('form').getForm().findField ('_id_task_route_task').getValue(); this.doLoad ();}
					}
				}
			}
			,
			{
				xtype: 'displayfield',

				fieldLabel: 'Результат подробно',
				name:       'result',
				width:      500,
				listeners:  {
					change: {
						fn : function () {if (this.getValue() == '') this.hide (); else this.show ()}
					}
				}

			}



		];


		this.callParent (arguments);

	},

	buttons: [
		{
			xtype: 'savebutton'
		},
		{
			xtype: 'button',
			text: 'Взять в работу'
		},
		{
			xtype: 'button',
			text: 'Взять на исполнение'
		},
		{
			xtype: 'button',
			text: 'Создать дочернюю задачу'
		},
		{
			xtype: 'button',
			text: 'Выполнено'
		},
		{
			xtype: 'button',
			text: 'Подтвердить выполнение'
		},
		{
			xtype: 'button',
			text: 'Вернуть на доработку'
		},
		{
			xtype: 'button',
			text: 'Вернуть в работу'
		},
		{
			xtype: 'button',
			text: 'Отменить'
		},
		{
			xtype: 'cancelbutton'
		}
	]


});
