Ext.define ('UI.view.products.structure', {

	extend: 'Ext.panel.Panel',

	autoScroll: true,

	title: 'Спецификация',

	bodyStyle:'padding:5px 5px 0',

	initComponent: function () {

		var me = this;

        me.grid = Ext.widget ('pagedcheckedgridpanel', {

			itemId: 'product_structures',

			parameters: {type: 'product_structures'},

			columns : [
				  {header: 'Раздел',   dataIndex: 'product_type_spec_label', flex: 1}
				, {header: 'Позиция',  dataIndex: 'position',                flex: 1}
				, {
					header: 'Номенклатура',
					columns: [
						{
							header:    'Номер',
							width:      50,
							dataIndex: 'product_label'
						},
						{
							header: 'Наименование',
							width:      300,
							dataIndex: 'product_name'
						}
					]
				}
				, {header: 'Количество',    dataIndex: 'quantity',           flex: 1}
				, {header: 'ЕИ',            dataIndex: 'voc_unit_label',     flex: 1}
				, {header: 'Примечание',    dataIndex: 'note',      flex: 2}
			],

			listeners: {
				containercontextmenu: {fn: function () {}},
				itemcontextmenu:      {fn: function () {}},
				itemdblclick:         {fn: function () {}}
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
								name:       'name',
								xtype:      'displayfield'
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
								xtype:      'combovocfield',
								fieldLabel: 'Тип номенклатуры',
								name:       'id_voc_product_type',
								table:      'voc_product_types'
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