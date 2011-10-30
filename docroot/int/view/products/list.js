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

        me.grid = Ext.widget ('pagedcheckedgridpanel', {

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

        });

        var tb    = me.grid.down ('pagingtoolbar');
        var store = me.grid.store;

        var changeSearchFieldValue = function (field, value) {
            store.proxy.extraParams [field.name] = value;
            tb.moveFirst ();
        }

        var listeners = {change: {fn: changeSearchFieldValue}};

        me.items = [

            me.grid,

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
                    labelAlign: 'top'
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
                                xtype:      'textfield',
                                fieldLabel: 'Наименование',
                                name:       'name',
                                listeners:  listeners,
                                anchor:     '96%'
                            },
                            {
                                xtype:      'textfield',
                                fieldLabel: 'Обозначение чертежа, марка',
                                name:       'short_label',
                                listeners:  listeners,
                                anchor:     '96%'
                            },
                            {
                                xtype:      'textfield',
                                fieldLabel: 'ГОСТ, ОСТ, ТУ',
                                name:       'gost_ost_tu',
                                listeners:  listeners,
                                anchor:     '96%'
                            },
                            {
                                xtype:      'textfield',
                                fieldLabel: 'Сорт, размер',
                                name:       'part_size',
                                listeners:  listeners,
                                anchor:     '96%'
                            },
                            {
                                xtype:      'textfield',
                                fieldLabel: 'Первичное применение',
                                name:       'primary_application',
                                listeners:  listeners,
                                anchor:     '96%'
                            }
                        ]
                    },
                    {
                        xtype: 'container',
                        columnWidth:.5,
                        layout: 'anchor',
                        items: [
                            {
                                xtype:'staticvocfield',
                                fieldLabel: 'Статус',
                                name: 'id_voc_product_status',
                                type: 'voc_product_status',
                                listeners: listeners,
                                anchor:'100%'
                            },
                            {
                                xtype:'staticvocfield',
                                fieldLabel: 'Тип номенклатуры',
                                name: 'id_voc_product_type',
                                type: 'voc_product_types',
                                listeners: listeners,
                                anchor:'100%'
                            },
                            {
                                xtype:'staticvocfield',
                                fieldLabel: 'ЕИ',
                                name: 'id_voc_unit',
                                type: 'voc_units',
                                listeners: listeners,
                                anchor:'100%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Масса',
                                name: 'email',
                                vtype:'email',
                                anchor:'100%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Изделие',
                                name: 'email',
                                vtype:'email',
                                anchor:'100%'
                            }
                        ]
                    }]
                },



                            {
                                xtype:'textfield',
                                fieldLabel: 'Входит в ограничительный перечень:',
                                name: 'company',
                                anchor:'100%'
                            },
                            {
                                xtype:'textfield',
                                fieldLabel: 'Код группы',
                                name: 'company',
                                anchor:'100%'
                            },







                ]

            }

        ];

        this.callParent (arguments);

    }

});