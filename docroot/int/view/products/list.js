Ext.define ('UI.view.products.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.products_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,
    renderTo: 'center',

    title : 'Номенклатура',
    layout: 'fit',
    autoShow: true,

    initComponent: function () {

        this.title = this.voc_group.get ('text');
    
        var theStore = store ({type: 'products', id_voc_group: this.voc_group.get ('id')}, {fields: [        
            'id',
            , 'fake'
            , 'label'
            , 'name'
            , 'voc_product_type.label'
            , 'voc_unit.label'
            , 'voc_group.label'
            , 'voc_product_status.label'
        ]});

        this.items = [
        
        {
            
            xtype: 'grid',

            store : theStore,

            columns : [
                {header: 'Номер',  dataIndex: 'label', flex: 1}
                , {header: 'Наименование',  dataIndex: 'name', flex: 1}
                , {header: 'Тип',  dataIndex: 'voc_product_type.label', flex: 1}
                , {header: 'ЕИ',  dataIndex: 'voc_unit.label', flex: 1}
                , {header: 'Группа',  dataIndex: 'voc_group.label', flex: 1}
                , {header: 'Статус',  dataIndex: 'voc_product_status.label', flex: 1}
            ],
            
            viewConfig: {
                forceFit: true,
                getRowClass: standardGetRowClass,
                multiSelect: true
            },

            selModel: Ext.create('Ext.selection.CheckboxModel', {
                allowDeselect: true,
                checkOnly: true,
                mode: 'MULTI'
            }),
            
            dockedItems: [{

                xtype: 'pagingtoolbar',
                store : theStore,
                dock: 'bottom',
                displayInfo: true,

                items: [
                
                    {
                        icon: '/ext/examples/desktop/images/gears.gif',
                        action: 'edit'
                    },
                    {
                        xtype: 'textfield',
                        name: 'q',
                        fieldLabel: 'Поиск',
                        labelWidth: 50
                    },
                    
                    fakeSelect ()
                    
                ]

            }]      

        }

    ];
      
        this.callParent (arguments);
        
    }





    
});