Ext.define ('UI.view.voc_drawing_formats.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_drawing_formats_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,
    renderTo: 'center',

    title : 'Список форматов чертежей',
    layout: 'fit',
    autoShow: true,

    initComponent: function () {
    
	var theStore = store ({'type': 'voc_drawing_formats'});

        this.items = [
        
		{
            
			xtype: 'grid',

			store : theStore,

			columns : [
			    {header: 'Наименование',  dataIndex: 'label', flex: 1}
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