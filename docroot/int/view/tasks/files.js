Ext.define ('UI.view.tasks.files', {

	extend: 'Ext.panel.Panel',

	autoScroll: true,

	title: 'Файлы',

	bodyStyle:'padding:5px 5px 0',

	initComponent: function () {

		var me = this;

		me.grid = Ext.widget ('pagedcheckedgridpanel', {

			itemId: 'task_files',

			parameters: {type: 'task_files'},

			columns : [
				{header: 'Наименование',         dataIndex: 'label',                    flex: 4}
				, {header: 'Версия',             dataIndex: 'version',                  flex: 1}
				, {header: 'Актуально',          dataIndex: 'is_actual',                flex: 1, renderer: function (is_actual) {return is_actual ? 'Да' : 'Нет';}}
				, {header: 'Файл',               dataIndex: 'file_name',                flex: 2}
				, {header: 'Примечание',         dataIndex: 'notes',                    flex: 2}
				, {header: 'Зарегистрировал',    dataIndex: 'user.label',               flex: 2}
				, {header: 'Дата регистрации',   dataIndex: 'dt',                       flex: 1, renderer: Ext.util.Format.dateRenderer('d.m.Y')}
				, {header: 'Размер',             dataIndex: 'file_size',                flex: 1, renderer: Ext.util.Format.numberRenderer('0,000.0')}
			],

			listeners: {

				itemdblclick:         {
					fn: function (grid, record) {

						var downloader = Ext.getCmp('FileDownloader');

						downloader.load({
							url: '?type=task_files&action=download&id=' + record.get('id')
						});

					}
				},

				containercontextmenu: {fn: function () {}},
				itemcontextmenu:      {fn: function () {}}
			}

		});

		me.items = [

			{
				xtype: 'form',
				layout:'column',
				border: 0,
				items:
					[
						{
							xtype: 'FileDownloader',
							id: 'FileDownloader'
						},
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
							width:      400,

							readOnly:   true
						}
					]
			},

			me.grid

		];

		this.callParent (arguments);

	}


});