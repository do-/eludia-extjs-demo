Ext.define ('UI.view.voc_units.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_units_edit',
    closeAction: 'hide',

    title : 'Единица измерения',
    layout: 'border',
    autoShow: true,
    width: 350,
    height: 500,
    defaultFocus : 'label',

    initComponent: function() {
    
        this.items = [
        
            {
                xtype: 'form',            
                region: 'north',
		layout: 'fit',
		    height: 220,
                bodyPadding: 10,
//		bodyStyle: 'padding:5px; border:0px; _border-bottom:1px;',
		waitMsgTarget: true,
		
		baseParams: {
			type: 'voc_units',
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
                        width: 320,
                        name : 'label',
                        itemId: 'label',
			allowBlank : false,
                        msgTarget : 'side',
                        fieldLabel: 'Наименование',
	                blankText: 'Вы забыли ввести наименование'
                    },
                    {
                        xtype: 'textfield',
                        width: 320,
                        name: 'note',
                        fieldLabel: 'Примечание'
                    },
                    {
                        xtype: 'textfield',
                        width: 150,
                        name: 'code_okei',
                        fieldLabel: 'Код по ОКЕИ',
                        maskRe: /[0-9]/,
                        regex: /^[0-9]{3}$/,
                        regexText: 'Код ОКЕИ должен состять ровно из 3 арабских цифр',
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
            
           
            
            
            
            ,{
                xtype: 'gridpanel',
                title: 'Эквиваленты в других единицах',
                
                store: new Ext.data.Store ({

			data: [],
                
		    model: 'UI.model.voc_unit_coeffs',
//			remoteSort : true,
			proxy: {
			type: 'memory',
			reader: {
			    type: 'json'
//			    root: 'content.voc_unit_coeffs',
			}
		    }
	    
	}),
                
                forceFit: true,
                hideHeaders: true,
                region: 'center',
                columns: [
                    {
                        xtype: 'numbercolumn',
                        dataIndex: 'voc_unit_coeff.coeff',
                        text: 'сколько',
			    editor: {
				xtype:'numberfield',
			    }                        
                    },
                    {
                        xtype: 'gridcolumn',
                        dataIndex: 'label',
                        text: 'чего'
                    }
                ],
                plugins: [
                    Ext.create('Ext.grid.plugin.CellEditing', {

                    })
                ],
                dockedItems: [
                    {
                        xtype: 'toolbar',
                        dock: 'bottom',
                        layout: {
                            pack: 'end',
                            type: 'hbox'
                        },
                        items: [
                            {
                                xtype: 'textfield',
                                name: 'q',
                                fieldLabel: 'Искать',
                                labelWidth: 50
                            }
                        ]
                    }
                ]
            }
                        
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        ];

        this.callParent(arguments);
        
    }
    
});