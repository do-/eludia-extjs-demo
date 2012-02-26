Ext.define ('UI.view.products.search', {

    extend: 'Ext.form.Panel',
    height:323,
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
                    xtype:      'searchtextfield',
                    fieldLabel: 'Наименование',
                    name:       'name',
                    anchor:     '96%'
                },
                {
                    xtype:      'searchtextfield',
                    fieldLabel: 'Обозначение чертежа, марка',
                    name:       'short_label',
                    anchor:     '96%'
                },
                {
                    xtype:      'searchtextfield',
                    fieldLabel: 'ГОСТ, ОСТ, ТУ',
                    name:       'gost_ost_tu',
                    anchor:     '96%'
                },
                {
                    xtype:      'searchtextfield',
                    fieldLabel: 'Сорт, размер',
                    name:       'part_size',
                    anchor:     '96%'
                },
                {
                    xtype:      'searchtextfield',
                    fieldLabel: 'Первичное применение',
                    name:       'primary_application',
                    anchor:     '96%'
                },
                {
                    xtype:      'searchtextfield',
                    fieldLabel: 'Код группы',
                    name:       'ord_src',
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
                    anchor:'100%'
                },
                {
                    xtype:'staticvocfield',
                    fieldLabel: 'Тип номенклатуры',
                    name: 'id_voc_product_type',
                    type: 'voc_product_types',
                    anchor:'100%'
                },
                {
                    xtype:'staticvocfield',
                    fieldLabel: 'ЕИ',
                    name: 'id_voc_unit',
                    type: 'voc_units',
                    anchor:'100%'
                },
                {
                    xtype:'searchselectfield',
                    fieldLabel: 'Входит в ограничительный перечень',
                    name: 'in_list',
                    anchor:'100%',
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
                },
                {
                    xtype:'textfield',
                    fieldLabel: 'Изделие',
                    name: 'email',
                    vtype:'email',
                    anchor:'100%'
                },
                {
                    xtype: 'fieldcontainer',
                    fieldLabel: 'Масса',
                    anchor:'100%',
                    layout: 'column',
                    items: [
                        {
                            xtype:      'searchtextfield',
                            fieldLabel: 'от',
                            name:       'weight_from',
                            labelWidth: 20,
                            columnWidth:.5
                        },
                        {
                            xtype:      'searchtextfield',
                            fieldLabel: '&nbsp;до',
                            name:       'weight_to',
                            labelWidth: 20,
                            columnWidth:.5
                        }
                    ]                    
                }
            ]
        }]
    }]
    
/*
    initComponent: function() {

        this.items = [

        ];

        this.callParent(arguments);

    }
*/    

});