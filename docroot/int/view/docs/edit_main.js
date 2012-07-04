Ext.define ('UI.view.docs.edit_main', {

	extend: 'Ext.form.Panel',
	layout:'fit',

	autoScroll: true,

	title: 'Общие',

	bodyStyle:'padding:5px 5px 0',

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
					xtype:      'textfield'
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
					items: [{
						fieldLabel: 'Изделие',
						name:       'product.label',
						flex:       1,
						width:      350,
						xtype:      'combovocfield',
						type:       'products',
						params:     {
								type: 'products'
						},
						queryParam: 'q'
					}, {
						xtype: 'splitter'
					}, {
						fieldLabel: 'Категория товара',
						name:       'voc_group.label',
						flex:       1,
						width:      250,
						xtype:      'displayfield'
					}]
				} , {
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
									width:      250,
									xtype:      'datefield'
								}, {
									fieldLabel: 'Желаемая дата получения результатов',
									name:       'dfd_dt_get.dt',
									flex:       1,
									width:      250,
									labelWidth: 500,
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
									width:      250,
									xtype:      'datefield'
								}, {
									fieldLabel: 'Желаемая дата получения результатов',
									name:       'dfd_dt_get2.dt',
									flex:       1,
									width:      250,
									labelWidth: 500,
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
						},
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
	],
	buttons: [
		{
			xtype: 'savebutton'
		},
		{
			xtype: 'cancelbutton'
		}
	]


});
