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
                        xtype : 'hiddenfield',
                        name  : 'id_rights_holder',
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
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        readOnly : true,
                        name : 'rights_holder.label',
                        itemId: 'note',
                        msgTarget : 'side',
                        fieldLabel: 'Источник права',
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
                        ],
                        
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
            
        	],
        	
        	
        	
                listeners : {
                
                	afterlayout: {
                	
                		fn: function (cont, lay, o) {
				
				    var formPanelDropTarget = Ext.create('Ext.dd.DropTarget', cont.body.dom, {

					ddGroup: 'TreeDD',

					notifyEnter: function(ddSource, e, data) {
					    cont.body.stopAnimation();
					    cont.body.highlight();
					},

					notifyDrop  : function(ddSource, e, data){

					    var selectedRecord = ddSource.dragData.records [0];

					    cont.down ("hiddenfield[name='id_rights_holder']" ).setValue (selectedRecord.get ('id'));
					    cont.down ("textfield[name='rights_holder.label']").setValue (selectedRecord.get ('text'));

					    return true;

					}
				    });

                		}
                	
                	}
                
                }
        	
        	
        	
        
            }
            
        ];

        this.callParent(arguments);
        
//alert (this.items.getAt(0).body.dom);

    }
    
});