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

		me.addEvents( 'changeTaskStatus',  'formDataLoaded', 'changeTaskType' );

		me.eventSubscribers = {};

		me.subscribeToEvent = function (event, component) {

			if (!Ext.isArray (me.eventSubscribers [event]))
				me.eventSubscribers[event] = [];

			me.eventSubscribers[event].push (component);

		};

		me.listeners = {
			formDataLoaded:   function () {
				me.fireEvent ('changeTaskStatus');
				me.fireEvent ('changeTaskType');
			},
			changeTaskStatus: function () {
				Ext.Array.each( me.eventSubscribers.changeTaskStatus, function (component) {
					component.fireEvent ('changeTaskStatus', {
						id_task_status: me.getForm().findField ('id_task_status').getValue(),
						is_initiator  : me.getForm().findField ('_is_initiator').getValue(),
						is_executor   : me.getForm().findField ('_is_executor').getValue(),
						is_inspector  : me.getForm().findField ('_is_inspector').getValue(),
						is_admin      : me.getForm().findField ('_is_admin').getValue()
					});
				});
			},
			changeTaskType : function () {
				Ext.Array.each( me.eventSubscribers.changeTaskType, function (component) {
					component.fireEvent ('changeTaskType', {
						is_multiple_executors: me.getForm().findField ('_task_type.is_multiple_executors').getValue()
					});
				});
			}
		};




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
			{
				xtype : 'hiddenfield',
				name  : '_is_executor',
				hidden: true
			},
			{
				xtype : 'hiddenfield',
				name  : '_is_inspector',
				hidden: true
			},
			{
				xtype : 'hiddenfield',
				name  : '_is_initiator',
				hidden: true
			},
			{
				xtype : 'hiddenfield',
				name  : '_is_admin',
				hidden: true
			},
			{
				xtype : 'hiddenfield',
				name  : '_task_type.is_multiple_executors'
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
									win.down('#doc_tasks').store.proxy.extraParams.id_doc_type = data.content.id_doc_type;
									win.down('#doc_tasks').store.load ();
								},
								win.down ('form').getForm ()
							);

						}
					}
				]
			},
			[

				{
					fieldLabel: 'Группа исполнителей',
					name:       'id_workgroup_executor',
					width:      500,
					xtype:      'combovocfield',
					type:       'task_workgroup_executors'

					, listeners: {

						afterrender:      function() {me.subscribeToEvent ('changeTaskType', this);},

						changeTaskType: function(values) {

							if (values.is_multiple_executors == false)
								this.hide ();
							else {
								this.store.proxy.extraParams.id_task_type = me.data.id_task_type;
								this.doLoad ();
								this.show ();
							}

						}
					}


				},

				{
					fieldLabel: 'Исполнитель',
					name:       'id_user_executor',
					width:      500,
					xtype:      'combovocfield',
					type:       'users',
					pageSize:   true
				}
			],
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
					fieldLabel: 'Дата завершения фактическая',
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
						fn : function () {if (this.getValue() == '') this.hide (); else this.show ();}
					}
				}

			}



		];

		this.buttons = [
			{
				xtype: 'savebutton'
				, listeners: {

					afterrender:      function() {me.subscribeToEvent ('changeTaskStatus', this);},

					changeTaskStatus: function(values) {

						var is_hidden = values.id_task_status > 3 ||
							values.id_task_status == 1 && (values.is_initiator || values.is_inspector || values.is_admin) ||
							values.id_task_status == 2 && values.is_admin ||
							values.id_task_status == 3 && (values.is_admin || values.is_inspector);


						if (is_hidden) this.hide (); else this.show ();
					}
				}
			},
			{
				xtype: 'button',
				text: 'Взять в работу'
				, listeners: {

					afterrender:      function() {me.subscribeToEvent ('changeTaskStatus', this);},

					changeTaskStatus: function(values) {

						var is_showed = values.id_task_status == 1 && values.is_executor;

						if (is_showed == false) this.hide (); else this.show ();
					}
				}
			},
			{
				xtype: 'button',
				text: 'Создать дочернюю задачу'
				, listeners: {

					afterrender:      function() {me.subscribeToEvent ('changeTaskStatus', this);},

					changeTaskStatus: function(values) {

						var is_showed = values.id_task_status < 5 && (values.is_executor || values.is_inspector);

						if (is_showed == false)
							this.hide ();
						else
							this.show ();

					}
				}
			},
			{
				xtype: 'button',
				text: 'Выполнено'

				, listeners: {

					afterrender:      function() {me.subscribeToEvent ('changeTaskStatus', this);},

					changeTaskStatus: function(values) {

						var is_showed = values.id_task_status == 2 && values.is_executor;

						if (is_showed == false)
							this.hide ();
						else
							this.show ();

					}
				}

			},
			{
				xtype: 'button',
				text: 'Подтвердить выполнение'
				, listeners: {

					afterrender:      function() {me.subscribeToEvent ('changeTaskStatus', this);},

					changeTaskStatus: function(values) {

						var is_showed = values.id_task_status == 3 && (values.is_inspector || values.is_admin);

						if (is_showed == false)
							this.hide ();
						else
							this.show ();

					}
				}
			},
			{
				xtype: 'button',
				text: 'Вернуть на доработку'
				, listeners: {

					afterrender:      function() {me.subscribeToEvent ('changeTaskStatus', this);},

					changeTaskStatus: function(values) {

						var is_showed = values.id_task_status == 3 && (values.is_inspector || values.is_admin);

						if (is_showed == false)
							this.hide ();
						else
							this.show ();

					}
				}
			},
			// {
			// 	xtype: 'button',
			// 	text: 'Вернуть в работу'
			// },
			// {
			// 	xtype: 'button',
			// 	text: 'Отменить'
			// },
			{
				xtype: 'cancelbutton'
			}
		];



		this.callParent (arguments);

	}


});
