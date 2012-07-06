Ext.define ('UI.view.docs.edit_main', {

	extend: 'Ext.form.Panel',
	layout:'border',

	title: 'Общие',

	bodyStyle:'padding:5px 5px 0',


	initComponent: function () {

		var me = this;

		me.grid = Ext.widget ('pagedcheckedgridpanel', {

			region:    'south',
			padding:   '10 0 0 0',
			title:     'Файлы',
			maxHeight: 200,
//    		cmargins: '5 5 0 0',
//			top: 10,

			itemId: 'doc_files',

			parameters: {type: 'doc_files'},

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
							url: '?type=doc_files&action=download&id=' + record.get('id')
						});

					}
				},

				containercontextmenu: {fn: function () {}},
				itemcontextmenu:      {fn: function () {}}
			}

		});

		me.listeners = {
			formDataLoaded:   function () {
				me.grid.store.proxy.extraParams.id_doc = me.data.id;
				me.grid.store.load ();
			}
		};



		me.items = [

			{
				xtype:  'container',
				region: 'center',
				margins: '5 0 0 0',
				autoScroll: true,


				layout: 'anchor',
				columnWidth: .5,
				defaults: {
						anchor:     '96%',
						xtype:      'textfield'
				},
				fieldDefaults: {
					labelAlign: 'top'
				},


				items: [
					{
						xtype:      'fieldcontainer',
						layout:     'hbox',
						items: [{
							fieldLabel: 'Номер',
							name:       'no',
							flex:       1,
							width:      350,
							xtype:      'displayfield'
						}, {
							xtype: 'splitter'
						}, {
							fieldLabel: 'Каталог',
							name:       'doc_folder.label',
							flex:       1,
							width:      250,
							xtype:      'combovocfield',
							type:       'doc_folders',
							params:     {
									type: 'doc_folders'
							},
							queryParam: 'q'
						}]
					} , {
						xtype:      'fieldcontainer',
						layout:     'hbox',
						items: [
							{
								fieldLabel: 'Изделие',
								name:       'product.id',
								flex:       1,
								width:      350,
								xtype:      'combovocfield',
								type:       'products',
								pageSize:   true,

								params:     {
										type: 'products',
										as_voc: 1
								}

							}, {
								xtype: 'splitter'
							},
							{
								xtype:    'box'
								, anchor: ''
								,autoEl:{
									 tag:    'img'
									, src:   '/i/upload/1470.jpg'
									, style: 'max-height: 250px; max-width: 250px'
								}
							},
						]
					} ,
					{
						fieldLabel: 'Категория товара',
						name:       'voc_group.label',
						flex:       1,
						width:      250,
						xtype:      'displayfield'
					},
					{
						fieldLabel: 'Производитель, адрес<br>и контактное лицо',
						name:       'dfd_prod.notes'
					} , {
						xtype:      'fieldcontainer',
						layout:     'hbox',
						items: [{
							fieldLabel: 'Маркировка образца',
							name:       'dfd_mark.label',
							flex:       1,
							xtype:      'textfield'
						}, {
							xtype: 'splitter'
						}, {
							fieldLabel: 'Отв. менеджер',
							name:       'man_user.label',
							flex:       1,
							width:      250,
							xtype:      'combovocfield',
							type:       'users'
						}]
					} , {
						fieldLabel: 'Основные функции',
						name:       'dfd_func.notes',
						xtype:      'textarea'
					} , {
						fieldLabel: 'Лицензии',
						name:       'licenses',
						xtype:      'displayfield'
					} ,
					{
						xtype:      'fieldset',
						title:      'ПРИНЯТЬ ДИЗАЙН, ЦВЕТ, ФУНКЦИИ МОДЕЛИ',
						items: [
							{
								fieldLabel: 'Продакт-директор товарной категории',
								name:       'dir_user.label',
								xtype:      'combovocfield',
								type:       'users'
							} ,
							{
								xtype:      'fieldset',
								title:      'РЕЗУЛЬТАТЫ ПЕРВИЧНЫХ ИСПЫТАНИЙ ОБРАЗЦА',
								items: [
									{
										fieldLabel: 'Дата передачи образцов в работу',
										name:       'dfd_dt_set.dt',
										flex:       1,
										width:      500,
										labelWidth: 300,
										xtype:      'datefield'
									}, {
										fieldLabel: 'Желаемая дата получения результатов',
										name:       'dfd_dt_get.dt',
										flex:       1,
										width:      500,
										labelWidth: 300,
										xtype:      'datefield'
									},

									{
										xtype:      'fieldset',
										title:      'Заключение отдела качества',
										layout:     {
											type: 'table',
											columns: 4
										},
										defaults: {
											bodyStyle: 'padding:5px;',
			//								height: '40',
											border: 0
										},
										items: [
											{
												html: '',
												rowspan: 2
											},
											{
												html: 'Кол-во замечаний',
												colspan: 2
											},
											{
												html: 'Рекомендации',
												rowspan: 2
											},
											{
												html: 'серьезн.'
											},
											{
												html: 'незнач.'
											},
											{
												html: 'Изделие'
											},
											{
												name:       'dfd_serious1.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_minor1.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_recom1.label',
												width:      500,
												xtype:      'textfield'
											},
											{
												html: 'Документация'
											},
											{
												name:       'dfd_serious2.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_minor2.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_recom2.label',
												width:      500,
												xtype:      'textfield'
											},
											{
												html: 'Предприятие'
											},
											{
												name:       'dfd_serious3.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_minor3.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_recom3.label',
												width:      500,
												xtype:      'textfield'
											}

										]
									}




								]
							},



							{
								xtype:      'fieldset',
								title:      'РЕЗУЛЬТАТЫ ИСПЫТАНИЙ ДОРАБОТАННОГО ОБРАЗЦА',
								items: [
									{
										fieldLabel: 'Дата передачи образцов в работу',
										name:       'dfd_dt_set2.dt',
										flex:       1,
										width:      500,
										labelWidth: 300,
										xtype:      'datefield'
									}, {
										fieldLabel: 'Желаемая дата получения результатов',
										name:       'dfd_dt_get2.dt',
										flex:       1,
										width:      500,
										labelWidth: 300,
										xtype:      'datefield'
									},

									{
										xtype:      'fieldset',
										title:      'Заключение отдела качества',
										layout:     {
											type: 'table',
											columns: 4
										},
										defaults: {
											bodyStyle: 'padding:5px;',
			//								height: '40',
											border: 0
										},
										items: [
											{
												html: '',
												rowspan: 2
											},
											{
												html: 'Кол-во замечаний',
												colspan: 2
											},
											{
												html: 'Рекомендации',
												rowspan: 2
											},
											{
												html: 'серьезн.'
											},
											{
												html: 'незнач.'
											},
											{
												html: 'Изделие'
											},
											{
												name:       'dfd_serious12.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_minor12.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_recom12.label',
												width:      500,
												xtype:      'textfield'
											},
											{
												html: 'Документация'
											},
											{
												name:       'dfd_serious22.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_minor22.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_recom22.label',
												width:      500,
												xtype:      'textfield'
											},
											{
												html: 'Предприятие'
											},
											{
												name:       'dfd_serious32.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_minor32.sum',
												width:      50,
												xtype:      'textfield'
											},
											{
												name:       'dfd_recom32.label',
												width:      500,
												xtype:      'textfield'
											}

										]
									}




								]
							}
							// {
							// 	fieldLabel: 'Вывод',
							// 	name:       'dfd_output.notes',
							// 	xtype:      'textarea'
							// },
							// {
							// 	fieldLabel: 'Руководитель отдела качества',
							// 	name:       'boss_users2.label',
							// 	xtype:      'combovocfield',
							// 	type:       'users'
							// }




						]
					},













					{
						xtype:      'fieldset',
						layout:     'column',
						title:      'ПРИНЯТЬ МОДЕЛЬ В АССОРТИМЕНТ',
						items: [
							{
								xtype: 'container',
								layout: 'anchor',
								columnWidth: .5,
								defaults: {
										anchor:     '96%',
										xtype:      'textfield'
								},

								items: [
									{
										fieldLabel: 'Присвоить номер модели',
										labelWidth: 250,
										name:       'dfd_no.label',
										flex:       1,
										width:      350,
										xtype:      'textfield'
									} , {
										fieldLabel: 'Коммерческий директор',
										name:       'com_dir_users.label',
										xtype:      'combovocfield',
										type:       'users'
									}
								]
							},


							{
								fieldLabel: 'Планируемая дата первой отгрузки',
								labelWidth: 250,
								name:       'dfd_dt_first_ship.dt',
								flex:       1,
								width:      250,
								xtype:      'datefield'
							}
						]
					},











					{
						xtype:      'fieldset',
						layout:     'column',
						title:      'ЦВЕТА МОДЕЛИ В ЗАКАЗАХ',
						items: [
							{
								xtype: 'container',
								layout: 'anchor',
								columnWidth: .5,
								defaults: {
										anchor:     '96%',
										xtype:      'textfield'
								},

								items: [

									{
										fieldLabel: 'Код цвета (1)',
										name:       'dfd_color1.label',
										flex:       1,
										width:      300,
										xtype:      'textfield'
									},
									{
										fieldLabel: 'Код цвета (2)',
										name:       'dfd_color2.label',
										flex:       1,
										width:      '300',
										xtype:      'textfield'
									},
									{
										fieldLabel: 'Код цвета (3)',
										name:       'dfd_color3.label',
										flex:       1,
										width:      '300',
										xtype:      'textfield'
									}
								]
							},
							{
								xtype: 'container',
								layout: 'anchor',
								columnWidth: .5,
								defaults: {
										anchor:     '96%',
										xtype:      'textfield'
								},

								items: [

									{
										fieldLabel: '% в контейнере (1)',
										labelWidth: 150,
										name:       'dfd_percent1.sum',
										flex:       1,
										width:      300,
										xtype:      'textfield'
									} , {
											fieldLabel: '% в контейнере (2)',
											labelWidth: 150,
											name:       'dfd_percent2.sum',
											flex:       1,
											width:      '300',
											xtype:      'textfield'
									} , {
											fieldLabel: '% в контейнере (3)',
											labelWidth: 150,
											name:       'dfd_percent3.sum',
											flex:       1,
											width:      '300',
											xtype:      'textfield'
									}
								]
							}

						]
					} , {
						xtype: 'lastmodifiedfieldset'
					}

				]

			}
			,
			me.grid
		];


		this.callParent (arguments);

	},

	buttons: [
		{
			xtype: 'savebutton'
		},
		{
			xtype: 'cancelbutton'
		}
	]


});
