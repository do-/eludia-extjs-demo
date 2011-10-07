Ext.define ('UI.view.voc_units.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_units_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,
    renderTo: 'center',

    title : 'Единицы измерения (ЕИ)',
    layout: 'fit',
    autoShow: true,

    initComponent: function () {
    
	var theStore = store ({'type': 'voc_units'});

        this.items = [
        
		{
            
			xtype: 'grid',

			store : theStore,

			columns : [
			    {header: 'Код',  dataIndex: 'code_okei', width: 40}
			    , {header: 'Наименование',  dataIndex: 'label', flex: 1}
			    , {header: 'Примечание',  dataIndex: 'note', flex: 2}
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