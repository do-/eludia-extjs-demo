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
				, {header: 'Дата создания',         dataIndex: 'dt',                    flex: 1, renderer: Ext.util.Format.dateRenderer('d.m.Y')}
				, {header: 'Дата оконч. (план)',    dataIndex: 'dt_to_plan',            flex: 1, renderer: Ext.util.Format.dateRenderer('d.m.Y')}
				, {header: 'Важность',              dataIndex: 'task_importance.label', flex: 1}
				, {header: 'Задача',                dataIndex: 'label',                 flex: 1, width: 400}
				, {header: 'Исполнитель',           dataIndex: 'user_executor.label',   flex: 1}
				, {header: 'Контролер',             dataIndex: 'user_inspector.label',  flex: 1}
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