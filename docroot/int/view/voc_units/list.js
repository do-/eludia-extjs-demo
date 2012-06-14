Ext.define ('UI.view.voc_units.list', {

	extend: 'Ext.window.Window',
	alias : 'widget.voc_units_list',
	closeAction: 'hide',
	maximizable : true,
	width: 800,
	height: 687,

	title : 'Единицы измерения (ЕИ)',
	layout: 'fit',
	constrainHeader: true,
	autoShow: true,

	initComponent: function () {

		this.items = [

			{

				xtype: 'pagedcheckedgridpanel',

				parameters: {type: 'voc_units'},

				columns : [
					  {header: 'Код',           dataIndex: 'code_okei', width: 40}
					, {header: 'Наименование',  dataIndex: 'label',     flex: 1}
					, {header: 'Примечание',    dataIndex: 'note',      flex: 2}
				],

				setFormData: function (data, form) {
					setFormData (data, form);
					var store = form.owner.up ('window').down ('gridpanel').getStore ().loadRawData (data.content.voc_units);
				}

			}

		];

		this.callParent (arguments);

	}

});