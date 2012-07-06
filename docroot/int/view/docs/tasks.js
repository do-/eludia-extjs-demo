Ext.define ('UI.view.docs.tasks', {

	extend: 'Ext.panel.Panel',

	autoScroll: true,

	title: 'Задачи',

	bodyStyle:'padding:5px 5px 0',

	renderTaskStatus: function (id_task_status) {

		var path = '/buttons/status_';

		path += id_task_status == 1 ? 100 :
			id_task_status == 2 ? 101 :
			id_task_status == 3 ? 200 :
			id_task_status == 4 ? 300 : 301;

		path += '.gif';

		return '<img src="' + path + '" class="x-action-col-icon">';
	},

	initComponent: function () {

		var me = this;

		me.grid = Ext.widget ('pagedcheckedgridpanel', {

			itemId: 'doc_tasks',

			parameters: {type: 'tasks'},

			columns : [
				  {header: '',                      dataIndex: 'id_task_status',        width: 20, renderer: me.renderTaskStatus}
				, {header: '№',                     dataIndex: 'no',                    flex: 1, renderer: me.renderTaskNo}
				, {header: 'Статус',                dataIndex: 'task_status.label',     flex: 1}
				, {header: 'Дата создания',         dataIndex: 'dt',                    flex: 1, renderer: Ext.util.Format.dateRenderer('d.m.Y')}
				, {header: 'Дата оконч. (план)',    dataIndex: 'dt_to_plan',            flex: 1, renderer: Ext.util.Format.dateRenderer('d.m.Y')}
				, {header: 'Дата оконч. (факт)',    dataIndex: 'dt_to_fact',            flex: 1, renderer: Ext.util.Format.dateRenderer('d.m.Y')}
				, {header: 'Задача',                dataIndex: 'label',                 flex: 3, width: 400}
				, {header: 'Исполнитель',           dataIndex: 'user_executor.label',   flex: 2}
				, {header: 'Контролер',             dataIndex: 'user_inspector.label',  flex: 2}
			],

			search : [
	            {
	                text:   'Гант',
	                xtype:  'button',
	                icon:   '/ext/examples/desktop/images/gears.gif',
	                handler: function () {
	                	var params = me.down('#doc_tasks').store.proxy.extraParams;
	                	window.open (
	                		'/handler?__tree=1&type=task_route_item_gantt_js2&id_doc_type=' + params.id_doc_type + '&id_type=' + params.id_type + '&sid=' + Ext.Ajax.extraParams.sid,
	                		'fake_' + Math.round(Math.random() * 1000) + '_iframe'
	                	);
	                }
	            }
			],

			setFormData: function (data, form) {
				form.owner.up ('window').query ('form').forEach (function (f) {setFormData (data, f.getForm());});
				form.owner.up ('window').down('#task_files').store.proxy.extraParams.id_task = data.content.id;
				form.owner.up ('window').down('#task_files').store.load ();
			},

			listeners: {
				containercontextmenu: {fn: function () {}},
				itemcontextmenu:      {fn: function () {}}
			}

		});

		me.items = [

			{
				xtype: 'form',
				layout:'column',
				border: 0,
				fieldDefaults: {
					labelAlign: 'top'
				},
				items: [
					{
						xtype: 'container',
						layout: 'anchor',
						columnWidth: .5,
						defaults: {
								anchor:     '96%',
								xtype:      'displayfield'
						},

						items: [
							{
								xtype : 'hiddenfield',
								name  : 'id',
								hidden: true
							},
							{
								fieldLabel: 'Номер',
								name:       'no'
							},
							{
								fieldLabel: 'Изделие',
								name:       'product.label'
							}
						]

					}
					, {
						xtype: 'container',
						columnWidth: .5,
						layout: 'anchor',
						defaults: {
								anchor:     '100%',
								xtype:      'displayfield'
						},

						items: [
							{
								fieldLabel: 'Каталог',
								name:       'doc_folder.label'
							},
							{
								fieldLabel: 'Категория товара',
								name:       'voc_group.label'
							}
						]

					}
				]
			},

			me.grid

		];

		this.callParent (arguments);

	}


});