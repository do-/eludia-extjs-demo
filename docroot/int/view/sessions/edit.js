Ext.define ('UI.view.sessions.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.sessions_edit',
    closeAction: 'hide',

    title : 'Вход в систему',
    layout: 'fit',
    autoShow: true,
    closable : false,
    resizable : false,
    defaultFocus : 'login',
    width: 278,

    initComponent: function() {
  
  	this.items = [
        
            {
                xtype: 'form',                
		bodyStyle: 'padding:5px; border:0px; _border-bottom:1px;',
		waitMsgTarget: true,
		
		baseParams: {
			type: 'logon',
			action: 'execute'
		},
		
                items: [
                    {
                        xtype: 'textfield',
                        name : 'login',
                        itemId: 'login',
                        fieldLabel: 'Логин',
			allowBlank : false,
                        msgTarget : 'side'
		    },
                    {
                        xtype: 'textfield',
                        name : 'password',
                        inputType: 'password',
                        fieldLabel: 'Пароль',
			allowBlank : false,
                        msgTarget : 'side'
                    }
                ],
                
        	buttons: [
        	
        		{                
				text: 'Вход',
				action: 'save'
			}
			
        	]
        	        
            }
            
        ];

        this.callParent (arguments);
        
    }
    
});