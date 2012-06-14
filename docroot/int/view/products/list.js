Ext.require ('UI.view.products.search');

Ext.define ('UI.view.products.list', {

	extend: 'Ext.window.Window',
	alias : 'widget.products_list',
	closeAction: 'hide',
	maximizable : true,
	width: 800,
	height: 700,
	layout: 'border',
	constrainHeader: true,
	autoShow: true,

	initComponent: function () {

		var me = this;

		me.title = me.voc_group.get ('text');

		me.grid = Ext.widget ('pagedcheckedgridpanel', {

				region: 'center',

				parameters: {type: 'products', id_voc_group: this.voc_group.get ('id')},

				search: [
					{
						xtype: 'searchcheckfield',
						fieldLabel: 'С подрубриками',
						name: 'tree',
						off: me.voc_group.get ('leaf')
					}
				],

				columns : [
					  {header: 'Номер',         dataIndex: 'label',                    width: 50}
					, {header: 'Наименование',  dataIndex: 'name',                     flex: 1}
					, {header: 'Тип',           dataIndex: 'voc_product_type.label',   flex: 1}
					, {header: 'ЕИ',            dataIndex: 'voc_unit.label',           width: 60}
					, {header: 'Группа',        dataIndex: 'voc_group.label',          flex: 1}
					, {header: 'Статус',        dataIndex: 'voc_product_status.label', flex: 1}
				],

				setFormData: function (data, form) {
					form.owner.up ('window').query ('form').forEach (function (f) {setFormData (data, f.getForm());});
					form.owner.up ('window').down('#product_structures').store.proxy.extraParams.id = data.content.id;
					form.owner.up ('window').down('#product_structures').store.load ();
				}


		});

		me.items = [
			me.grid
			, Ext.create ('UI.view.products.search')
		];

		this.callParent (arguments);

	}

});