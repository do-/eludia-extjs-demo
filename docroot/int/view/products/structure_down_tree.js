Ext.define ('UI.view.products.structure_down_tree', {

	extend: 'Ext.tree.Panel',

	title : 'Структура изделия',
	rootVisible : false,

	initComponent: function () {

		var me = this;

		me.columns = [{
				xtype: 'treecolumn',
				text: 'Структура',
				flex: 2,
				sortable: true,
				dataIndex: 'ord'
			}, {
				text: 'Раздел',
				flex: 1,
				dataIndex: 'voc_product_type_label',
				sortable: true
			}, {
				text: 'Позиция',
				flex: 1,
				dataIndex: 'position',
				sortable: true
			}, {
				text: 'Компонент',
				columns: [
					{
						header:    'Номер',
						width:     50,
						dataIndex: 'subproduct_label'
					},
					{
						header:    'Наименование',
						width:     300,
						dataIndex: 'subproduct_name'
					},
					{
						header:    'СИ',
						dataIndex: 'pp_label'
					},
					{
						header:    '№ оп.',
						dataIndex: 'operation'
					}
				]
			}, {
				text: 'Кол-во',
				flex: 1,
				dataIndex: 'quantity',
				sortable: true
			},{
				text: 'ЕИ',
				flex: 1,
				dataIndex: 'voc_unit_label',
				sortable: true
			}, {
				text: 'КИ',
				flex: 1,
				dataIndex: 'quantity_total',
				sortable: true
			},{
				text: 'ЕИ',
				flex: 1,
				dataIndex: 'product_voc_unit_label',
				sortable: true
			},{
				text: 'Примечание',
				flex: 1,
				dataIndex: 'note',
				sortable: true
			},{
				text: 'Дата начала',
				flex: 1,
				dataIndex: 'dt_from',
				sortable: true
			},{
				text: 'Дата окончания',
				flex: 1,
				dataIndex: 'dt_to',
				sortable: true
			},{
				text: 'Замена',
				flex: 1,
				dataIndex: 'have_alts',
				sortable: true
			},{
				text: 'СИ',
				flex: 1,
				dataIndex: 'no_route',
				sortable: true
			},{
				text: 'Цикл',
				flex: 1,
				dataIndex: 'cycle_pp',
				sortable: true
			},{
				text: 'СЦВ',
				flex: 1,
				dataIndex: 'cycle',
				sortable: true
			}
		];

        if (!Ext.ModelManager.isRegistered ('product_structures_down')) {
            var fields  = ['id', 'fake'];
            getFieldsFromColumns (fields, me.columns);
            Ext.define ('product_structures_down', {fields: fields, extend: 'Ext.data.Model'});
        }

		me.store = Ext.create('Ext.data.TreeStore', {

			model: 'product_structures_down',

			proxy: {
				type: 'ajax',
				url: '/handler',
				extraParams: {type: 'product_structures_down'},
				reader: {
					type: 'json',
					root: 'content'
				}
			},

			defaultRootId : 0

		});


		me.callParent (arguments);

	}

});