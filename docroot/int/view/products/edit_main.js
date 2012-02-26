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
        
            items: [
                {
                    xtype:      'textfield',
                    fieldLabel: 'Наименование',
                    name:       'name',
                    anchor:     '96%'
                }
                , {
                    xtype:      'textfield',
                    fieldLabel: 'Обозначение чертежа, марка',
                    name:       'short_label',
                    anchor:     '96%'
                }
                , {
                    xtype:      'textfield',
                    fieldLabel: 'ГОСТ, ОСТ, ТУ',
                    name:       'gost_ost_tu',
                    anchor:     '96%'
                }
                , {
                    xtype:      'textfield',
                    fieldLabel: 'Сорт, размер',
                    name:       'part_size',
                    anchor:     '96%'
                }
                , {
                    xtype:      'textfield',
                    fieldLabel: 'Первичное применение',
                    name:       'primary_application',
                    anchor:     '96%'
                }
                , {
                    xtype:      'textfield',
                    fieldLabel: 'Код группы',
                    name:       'ord_src',
                    anchor:     '96%'
                }
            ]           

        }
        , {
            xtype: 'container',
            columnWidth: .5,
        
            items: [
            
                {
                    xtype:'staticvocfield',
                    
                    
            forceSelection: true,
            allowBlank: false,
            editable: false,
            typeAhead: false,
            multiSelect: false,
                    
                    
                    fieldLabel: 'Статус',
                    name: 'id_voc_product_status',
                    type: 'voc_product_status',
                    anchor:'100%'
                }
                , {
                    xtype:'combobox',
                    fieldLabel: 'Тип номенклатуры',
                    name: 'id_voc_product_type',
                    type: 'voc_product_types',
                    anchor:'100%'
                }
                , {
                    xtype:'combobox',
                    fieldLabel: 'ЕИ',
                    name: 'id_voc_unit',
                    type: 'voc_units',
                    anchor:'100%'
                }
                , {
                    xtype:'combobox',
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
                }
                , {
                    xtype:'textfield',
                    fieldLabel: 'Изделие',
                    name: 'email',
                    vtype:'email',
                    anchor:'100%'
                }
                , {
                    xtype:      'textfield',
                    fieldLabel: 'Масса',
                    name:       'weight',
                    anchor:'100%'
                }

            ]           

        }
    
    ]
    
});