Ext.define ('UI.view.docs.edit_main', {

	extend: 'Ext.form.Panel',
	layout:'column',

	autoScroll: true,

	tabConfig: {
			title: 'Общие',
			tooltip: 'A button tooltip'
	},

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
					fieldLabel: '<b>Номер</b>',
					name:       'no',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Каталог</b>',
					name:       'doc_folder.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Изделие</b>',
					name:       'product.full_name',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Категория товара</b>',
					name:       'voc_group.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Производитель, адрес<br>и контактное лицо</b>',
					name:       'dfd_prod.notes',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Маркировка образца</b>',
					name:       'dfd_mark.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Отв. менеджер</b>',
					name:       'man_user.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Основные функции</b>',
					name:       'dfd_func.notes',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Лицензии</b>',
					name:       'licenses',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Продакт-директор товарной категории</b>',
					name:       'dir_user.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>РЕЗУЛЬТАТЫ ПЕРВИЧНЫХ ИСПЫТАНИЙ ОБРАЗЦА</b>',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Дата передачи образцов в работу</b>',
					name:       'dfd_dt_set.dt',
					xtype:      'displaydatetimefield'
				}
				, {
					fieldLabel: '<b>Желаемая дата получения результатов</b>',
					name:       'dfd_dt_get.dt',
					xtype:      'displaydatetimefield'
				}
				, {
					fieldLabel: '<b>Заключение отдела качества (первичные испытания)</b>',
					flex:       1,
					xtype:      'displayfield'
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Кол-во замечаний на (1)</b>',
						name:       'com1.label_href',
						flex:       1,
						width:      250,
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>Серьезных</b>',
						name:       'dfd_serious1.sum',
						flex:       1,
						width:      250,
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>Незначительных</b>',
						labelWidth: 150,
						name:       'dfd_minor1.sum',
						flex:       1,
						width:      250,
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>Рекомендации</b>',
						name:       'dfd_recom1.label',
						flex:       1,
						width:      250,
						xtype:      'displayfield'
					}]
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Кол-во замечаний на (2)</b>',
						name:       'com2.label_href',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Серьезных</b>',
						name:       'dfd_serious2.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Незначительных</b>',
						labelWidth: 150,
						name:       'dfd_minor2.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Рекомендации</b>',
						name:       'dfd_recom2.label',
						flex:       1,
						xtype:      'displayfield'
					}]
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Кол-во замечаний на (3)</b>',
						name:       'com3.label_href',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Серьезных</b>',
						name:       'dfd_serious3.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Незначительных</b>',
						labelWidth: 150,
						name:       'dfd_minor3.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Рекомендации</b>',
						name:       'dfd_recom3.label',
						flex:       1,
						xtype:      'displayfield'
					}]
				}
				, {
					fieldLabel: '<b>Руководитель отдела качества</b>',
					name:       'boss_user.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>РЕЗУЛЬТАТЫ ИСПЫТАНИЙ ДОРАБОТАННОГО ОБРАЗЦА</b>',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Дата передачи образцов в работу</b>',
					name:       'dfd_dt_set2.dt',
					xtype:      'displaydatetimefield'
				}
				, {
					fieldLabel: '<b>Желаемая дата получения результатов</b>',
					name:       'dfd_dt_get2.dt',
					xtype:      'displaydatetimefield'
				}
				, {
					fieldLabel: '<b>Заключение отдела качества (испытания доработанного образца)</b>',
					xtype:      'displayfield'
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Кол-во замечаний на (1)</b>',
						name:       'com12.label_href',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>Серьезных</b>',
						name:       'dfd_serious12.sum',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>Незначительных</b>',
						labelWidth: 150,
						name:       'dfd_minor12.sum',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>Рекомендации</b>',
						name:       'dfd_recom12.label',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}]
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Кол-во замечаний на (2)</b>',
						name:       'com22.label_href',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Серьезных</b>',
						name:       'dfd_serious22.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Незначительных</b>',
						labelWidth: 150,
						name:       'dfd_minor22.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Рекомендации</b>',
						name:       'dfd_recom22.label',
						flex:       1,
						xtype:      'displayfield'
					}]
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Кол-во замечаний на (3)</b>',
						name:       'com32.label_href',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Серьезных</b>',
						name:       'dfd_serious32.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Незначительных</b>',
						labelWidth: 150,
						name:       'dfd_minor32.sum',
						flex:       1,
						xtype:      'displayfield'
					}, {
						fieldLabel: '<b>Рекомендации</b>',
						name:       'dfd_recom32.label',
						flex:       1,
						xtype:      'displayfield'
					}]
				}
				, {
					fieldLabel: '<b>Вывод</b>',
					name:       'dfd_output.notes',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Руководитель отдела качества</b>',
					name:       'boss_users2.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>ПРИНЯТЬ МОДЕЛЬ В АССОРТИМЕНТ</b>',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Присвоить номер модели</b>',
					name:       'dfd_no.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Планируемая дата первой отгрузки</b>',
					name:       'dfd_dt_first_ship.dt',
					xtype:      'displaydatetimefield'
				}
				, {
					fieldLabel: '<b>Коммерческий директор</b>',
					name:       'com_dir_users.label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: '<b>Цвета модели в заказах</b>',
					xtype:      'displayfield'
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Код цвета (1)</b>',
						name:       'dfd_color1.label',
						flex:       1,
						width:      300,
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>% в контейнере (1)</b>',
						labelWidth: 150,
						name:       'dfd_percent1.sum',
						flex:       1,
						width:      300,
						xtype:      'displayfield'
					}]
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Код цвета (2)</b>',
						name:       'dfd_color2.label',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>% в контейнере (2)</b>',
						labelWidth: 150,
						name:       'dfd_percent2.sum',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}]
				}
				, {
					xtype:      'fieldcontainer',
					layout:     'hbox',
					items: [{
						fieldLabel: '<b>Код цвета (3)</b>',
						name:       'dfd_color3.label',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}, {
    		  	      xtype: 'splitter'
    			    }, {
						fieldLabel: '<b>% в контейнере (3)</b>',
						labelWidth: 150,
						name:       'dfd_percent3.sum',
						flex:       1,
						width:      '300',
						xtype:      'displayfield'
					}]
				}

				, {
					xtype: 'lastmodifiedfieldset'
				}

			]

		}
//		, {
//			xtype: 'container',
//			columnWidth: .5,
//			layout: 'anchor',
//			defaults: {
//					anchor:     '100%',
//					xtype:      'textfield'
//			},
//
//			items: [
//
//				{
//					xtype:'combovocfield',
//					forceSelection: true,
//					allowBlank: false,
//					editable: false,
//					typeAhead: false,
//					multiSelect: false,
//					fieldLabel: 'Статус',
//					name: 'id_voc_product_status',
//					table: 'voc_product_status',
//					readOnly: true
//				}
//				, {
//					xtype:'combovocfield',
//					fieldLabel: 'Тип номенклатуры',
//					name: 'id_voc_product_type',
//					table: 'voc_product_types'
//				}
//				, {
//					fieldLabel: 'Масса',
//					name: 'weight',
//					afterSubTpl: 'кг'
//				}
//				, {
//					xtype:'combovocfield',
//					fieldLabel: 'Входит в ограничительный перечень',
//					name: 'in_list',
//					data: [
//						['',  'Не важно'],
//						['1', 'Входит'],
//						['0', 'Не входит']
//					]
//				}
//			]
//
//		},
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