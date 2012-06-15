Ext.define ('UI.view.products.edit_main', {

	extend: 'Ext.form.Panel',
	layout:'column',

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
					fieldLabel: 'Код группы',
					name:       'ord_src'
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
					xtype:'combobox',
					fieldLabel: 'Входит в ограничительный перечень',
					name: 'in_list',
					store: Ext.create ('Ext.data.ArrayStore', {
						autoDestroy: true,
						idIndex: 0,
						fields: ['id','label'],
						data: [
							['',  'Не важно'],
							['1', 'Входит'],
							['0', 'Не входит']
						]
					})
				}
				, {
					xtype:'textfield',
					fieldLabel: 'Изделие',
					name: 'email',
					vtype:'email'
				}
				, {
					xtype:      'textfield',
					fieldLabel: 'Масса',
					name:       'weight'
				}

			]

		}

	]

});