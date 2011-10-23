Ext.define ('UI.view.products.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.products_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,
    layout: 'fit',
    autoShow: true,

    initComponent: function () {

        this.title = this.voc_group.get ('text');

        this.items = [

            {

                xtype: 'pagedcheckedgridpanel',

                parameters: {type: 'products', id_voc_group: this.voc_group.get ('id')},

                columns : [
                      {header: 'Номер',         dataIndex: 'label',                    flex: 1}
                    , {header: 'Наименование',  dataIndex: 'name',                     flex: 1}
                    , {header: 'Тип',           dataIndex: 'voc_product_type.label',   flex: 1}
                    , {header: 'ЕИ',            dataIndex: 'voc_unit.label',           flex: 1}
                    , {header: 'Группа',        dataIndex: 'voc_group.label',          flex: 1}
                    , {header: 'Статус',        dataIndex: 'voc_product_status.label', flex: 1}
                ]

            }

        ];

        this.callParent (arguments);

    }

});