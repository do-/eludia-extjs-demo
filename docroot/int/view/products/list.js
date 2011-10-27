Ext.define ('UI.view.products.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.products_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,
    layout: 'border',
    autoShow: true,

    initComponent: function () {

        var me = this;

        me.title = me.voc_group.get ('text');

        me.items = [

            {

                xtype: 'pagedcheckedgridpanel',

                region: 'center',

                parameters: {type: 'products', id_voc_group: this.voc_group.get ('id')},

                columns : [
                      {header: 'Номер',         dataIndex: 'label',                    flex: 1}
                    , {header: 'Наименование',  dataIndex: 'name',                     flex: 1}
                    , {header: 'Тип',           dataIndex: 'voc_product_type.label',   flex: 1}
                    , {header: 'ЕИ',            dataIndex: 'voc_unit.label',           flex: 1}
                    , {header: 'Группа',        dataIndex: 'voc_group.label',          flex: 1}
                    , {header: 'Статус',        dataIndex: 'voc_product_status.label', flex: 1}
                ]

            },

            {

                xtype: 'form',
                height:400,
//                split:       true,
                collapsible: true,
                collapsed: true,
                region: 'south',
                title: 'Фильтр',
                bodyStyle:'padding:5px 5px 0',

                fieldDefaults: {
                    labelAlign: 'top',
                    msgTarget: 'side'
                },

                items: [{

                    xtype: 'container',
                    anchor: '100%',
                    layout:'column',
                    items:[{
                        xtype: 'container',
                        columnWidth:.5,
                        layout: 'anchor',
                        items: [
                            {
                                xtype:'textfield',
                                fieldLabel: 'Номенклатурный номер',
                                name: 'first',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Наименование',
                                name: 'company',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Обозначение чертежа, марка',
                                name: 'company',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'ГОСТ, ОСТ, ТУ',
                                name: 'company',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Сорт, размер',
                                name: 'company',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Первичное применение',
                                name: 'company',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Входит в ограничительный перечень:',
                                name: 'company',
                                anchor:'96%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Код группы',
                                name: 'company',
                                anchor:'96%'
                            }
                        ]
                    },
                    {
                        xtype: 'container',
                        columnWidth:.5,
                        layout: 'anchor',
                        items: [{
                            xtype:'textfield',
                            fieldLabel: 'Last Name',
                            name: 'last',
                            anchor:'100%'
                        },{
                            xtype:'textfield',
                            fieldLabel: 'Email',
                            name: 'email',
                            vtype:'email',
                            anchor:'100%'
                        }]
                    }]
                }]

            }

        ];

        this.callParent (arguments);

    }

});