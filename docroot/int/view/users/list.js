Ext.define ('UI.view.users.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.users_list',
    closeAction: 'hide',
    maximizable : true,
    width: 500,
    height: 200,
    renderTo: 'center',

    title : 'Список пользователей системы',
    layout: 'fit',
    autoShow: true,

    initComponent: function () {
    
        this.items = [
        
		{
            
			xtype: 'grid',

			store : 'users',

			columns : [
			    {header: 'ФИО',  dataIndex: 'label', flex: 1},
			    {header: 'Login', dataIndex: 'login',  flex: 1}
			],

			dockedItems: [{

				xtype: 'pagingtoolbar',
				store: 'users', 
				dock: 'bottom',
				displayInfo: true,

				items: [
					{
						icon: '/ext/examples/toolbar/images/add16.gif',
						action: 'edit'
					}
				]

			}]		

		}

	];
                
        this.on	('show', function () {
        	
		this.down ('gridpanel').store.load ();        	
        	        		
	});
      
        this.callParent (arguments);
        
    }





    
});