Ext.define ('UI.view.products.structure', {

	extend: 'Ext.panel.Panel',

	autoScroll: true,

	title: 'Спецификация',

	bodyStyle:'padding:5px 5px 0',

	initComponent: function () {

		var me = this;

		me.checkStructureDown = function (content) {

			if (me.structureItemsCnt == content.cnt) {

				Ext.MessageBox.hide();
				me.runningStructureDown = 0;

				Ext.create ('UI.view.products.structure_down');

			} else {

				me.structureItemsCnt = content.cnt;
				setTimeout (
						function(){ajax (me.checkStructureDownHref, me.checkStructureDown)}
						, 1000
				);
			}
		};

		me.openStructureDown = function () {
			var id_product = me.down('form').getForm().findField ('id').getValue();
			var href = '?type=product_structures_down&action=update&id_product=' + id_product;
			me.checkStructureDownHref = '?type=product_structures_down&action=check_state&id_product=' + id_product;

			Ext.MessageBox.show({
				msg: 'Формирование спецификации, пожалуйста подождите...',
				progressText: 'Saving...',
				width:300,
				wait:true,
				waitConfig: {interval:200}
			});

			ajax (
				href, 
				function () {
					setTimeout (
						function(){ajax (me.checkStructureDownHref, me.checkStructureDown)}
						, 1000
					)
				}
			);
			me.runningStructureDown = 1;
			me.structureItemsCnt = 0;
		}

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
			},

			getPopupMenuItems: function (cnt) {
				return [

					{
						text     : 'Структура изделия',
						handler  : function () {me.openStructureDown ()},
						disabled : me.runningStructureDown
					}


				];

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
								xtype : 'hiddenfield',
								name  : 'id',
								hidden: true
							},
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