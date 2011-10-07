Ext.define ('UI.view.users.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.users_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,
    renderTo: 'center',

    title : 'Список пользователей системы',
    layout: 'fit',
    autoShow: true,

    initComponent: function () {
    
	var theStore = store ({'type': 'users'});

        this.items = [
        
		{
            
			xtype: 'grid',

			store : theStore,

			columns : [
			    {header: 'ФИО',  dataIndex: 'label', flex: 1},
			    {header: 'Login', dataIndex: 'login',  flex: 1}
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
						xtype: 'textfield',
						name: 'q',
						fieldLabel: 'Поиск',
						labelWidth: 50
					},
					
					fakeSelect (),
					
				]

			}]		

		}

	];
      
        this.callParent (arguments);
        
    }





    
});