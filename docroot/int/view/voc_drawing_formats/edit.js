Ext.define ('UI.view.voc_drawing_formats.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_drawing_formats_edit',
    closeAction: 'hide',

    title : 'Формат чертежей',
    layout: 'fit',
    autoShow: true,
    width: 300,
    height: 210,
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
			type: 'voc_drawing_formats',
			action: 'update'
		},
		
                items: [
                    {
                        xtype : 'hiddenfield',
                        name  : 'id',
                        hidden: true,
                        value : ':NEW'
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
                        xtype: 'checkboxfield',
                        name: 'is_multiple_pages',
                        fieldLabel: 'Много листов',
                        boxLabel: '',
			inputValue: '1',
			uncheckedValue: '1'
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