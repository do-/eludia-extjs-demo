Ext.define ('UI.view.users.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.users_edit',
    closeAction: 'hide',

    title : 'Edit User',
    layout: 'fit',
    autoShow: true,
    width: 300,
//    height: 200,

    initComponent: function() {
    
        this.items = [
        
            {
                xtype: 'form',                
		bodyStyle: 'padding:5px; border:0px; _border-bottom:1px;',
		waitMsgTarget: true,
		
		baseParams: {
			type: 'users',
			action: 'update'
		},
		
                items: [
                    {
                        xtype : 'hiddenfield',
                        name  : 'id',
                        value : ':NEW'
                    },
                    {
                        xtype: 'textfield',
                        name : 'label',
			allowBlank : false,
                        msgTarget : 'side',
                        fieldLabel: 'ФИО'
                    },
                    {
                        xtype: 'textfield',
                        name : 'login',
			allowBlank : false,
                        msgTarget : 'side',
                        fieldLabel: 'Login'
                    },
                    {
                        xtype: 'textfield',
                        name : 'password',
                        inputType: 'password',
                        fieldLabel: 'Пароль'
                    }
                ],
                
        	buttons: [
        	
        		{                
				text: 'Сохранить',
				action: 'save'
			},

            		{
                		text: 'Закрыть',
                		scope: this,
                		handler: this.close
            		}
            
        	]
        
            }
            
        ];

        this.callParent(arguments);
        
    }
    
});