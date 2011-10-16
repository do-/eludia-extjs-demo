Ext.define ('UI.view.voc_groups.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_groups_edit',
    closeAction: 'hide',

    title : 'Номенклатурная группа',
    layout: 'fit',
    autoShow: true,
    width: 300,
//    height: 210,
    defaultFocus : 'label',

    initComponent: function() {
    
        this.items = [
        
            {
                xtype: 'form',            
		layout: 'fit',
                bodyPadding: 10,
//		bodyStyle: 'padding:5px; border:0px; _border-bottom:1px;',
		waitMsgTarget: true,
		
		baseParams: {
			type: 'voc_groups',
			action: 'update'
		},
		
                items: [
    
                    {
                        xtype : 'hiddenfield',
                        name  : 'id',
                        hidden: true,
                    },
                    
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'label',
                        itemId: 'label',
			allowBlank : false,
                        msgTarget : 'side',
                        fieldLabel: 'Наименование',
	                blankText: 'Вы забыли ввести наименование'
                    },		    
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'vkg_okp',
                        itemId: 'vkg_okp',
                        msgTarget : 'side',
                        fieldLabel: 'ОКП',
                    },		    
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'no_1c',
                        itemId: 'no_1c',
                        msgTarget : 'side',
                        fieldLabel: '1С',
                    },		    
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'code_SKMTR',
                        itemId: 'code_SKMTR',
                        msgTarget : 'side',
                        fieldLabel: 'СКМТР',
                    },	
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'note',
                        itemId: 'note',
                        msgTarget : 'side',
                        fieldLabel: 'Примечание',
                    },	
		    
                    {
                        xtype: 'fieldset',
                        autoRender: true,
                        layout: {
                            type: 'anchor'
                        },
//                        collapsed: true,
//                        collapsible: true,
                        title: 'Последнее изменение',
                        weight: 1,
                        items: [
                            {
                                xtype: 'displayfield',
                                name: 'log.dt',
                                fieldLabel: 'Дата'
                            },
                            {
                                xtype: 'displayfield',
                                name: 'user.label',
                                fieldLabel: 'Автор'
                            }
                        ]
                    }		    
		    		    


                ],
                
        	buttons: [
        	
        		{                
				text: 'Сохранить',
				action: 'save'
			},

            		{
                		text: 'Закрыть',
                		action: 'close'
            		}
            
        	]
        
            }
            
        ];

        this.callParent(arguments);
        
    }
    
});