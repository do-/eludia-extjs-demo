Ext.define ('UI.view.products.edit_main', {

	extend: 'Ext.form.Panel',
	layout:'column',

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
					fieldLabel: 'Номенклатурный номер',
					name:       'label',
					xtype:      'displayfield'
				}
				, {
					fieldLabel: 'Наименование',
					name:       'name'
				}
				, {
					fieldLabel: 'Обозначение чертежа, марка материала',
					name:       'short_label'
				}
				, {
					fieldLabel: 'НД, ГОСТ, ОСТ, ТУ',
					name:       'gost_ost_tu'
				}
				, {
					fieldLabel: 'Сорт, размер',
					name:       'part_size'
				}
				, {
					fieldLabel: 'Первичное применение',
					name:       'primary_application'
				}
				, {
					xtype:      'combovocfield',
					fieldLabel: 'Материал',
					name:       'id_product_material',
					type:       'products',
					params:     {
							type: 'products'
//							, in_list: 2
					},
		            queryParam: 'q'
				}
				, {
					fieldLabel: 'Код группы',
					name:       'ord_src'
				}
				, {
					xtype:      'combovocfield',
					fieldLabel: 'Формат чертежа',
					name:       'id_voc_drawing_format',
					table:      'voc_drawing_formats'

				}
				, {
					xtype:      'checkbox',
					name:       'in_list',
					fieldLabel: 'Входит в ограничительный перечень'
				}


			]

		}
		, {
			xtype: 'container',
			columnWidth: .5,
			layout: 'anchor',
			defaults: {
					anchor:     '100%',
					xtype:      'textfield'
			},

			items: [

				{
					xtype:'combovocfield',


					forceSelection: true,
					allowBlank: false,
					editable: false,
					typeAhead: false,
					multiSelect: false,


					fieldLabel: 'Статус',
					name: 'id_voc_product_status',
					table: 'voc_product_status',
					readOnly: true
				}
				, {
					xtype:'combovocfield',
					fieldLabel: 'Тип номенклатуры',
					name: 'id_voc_product_type',
					table: 'voc_product_types'
				}
				, {
					xtype:'combovocfield',
					fieldLabel: 'Основная ЕИ',
					name: 'id_voc_unit',
					table: 'voc_units'
				}
				, {
					fieldLabel: 'Количество знаков после запятой',
					name:       'precision_production',
				}
				, {
					fieldLabel: 'Масса',
					name: 'weight',
					afterSubTpl: 'кг'
				}
				, {
					xtype:'combovocfield',
					fieldLabel: 'Входит в ограничительный перечень',
					name: 'in_list',
					data: [
						['',  'Не важно'],
						['1', 'Входит'],
						['0', 'Не входит']
					]
				}
				, {
					fieldLabel: 'Изделие',
					name:       'product'
				}
				, {
					xtype:      'combovocfield',
					fieldLabel: 'Вид заготовки',
					name:       'id_voc_preparation_kind',
					table:      'voc_preparation_kinds'

				}
				, {
					xtype:      'combovocfield',
					fieldLabel: 'Литера',
					name:       'litera',
					data: [
						['',  ''],
						['И',  'И'],
						['Б',  'Б'],
						['О',  'О'],
						['О1', 'О1'],
						['А',  'А']
					]
				}
				, {
					xtype: 'lastmodifiedfieldset'
				}
			]

		},
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