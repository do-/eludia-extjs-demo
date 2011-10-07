Ext.define ('UI.view.voc_units.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_units_edit',
    closeAction: 'hide',

    height: 376,
    width: 352,
    layout: {
        type: 'border'
    },
    title: 'Единица измерения',

    initComponent: function() {
        var me = this;
        me.items = [
            {
                xtype: 'form',
                height: 130,
                bodyPadding: 10,
                region: 'north',
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
                                xtype: 'button',
                                text: 'Сохранить'
                            },
                            {
                                xtype: 'button',
                                text: 'Закрыть'
                            }
                        ]
                    }
                ],
                items: [
                    {
                        xtype : 'hiddenfield',
                        name  : 'id',
                        hidden: true,
                        value : ':NEW'
                    },
                    {
                        xtype: 'textfield',
                        width: 320,
                        name: 'label',
                        fieldLabel: 'Наименование'
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
                        fieldLabel: 'Код по ОКЕИ'
                    }
                ]
            },
            {
                xtype: 'gridpanel',
                title: 'Эквиваленты в других единицах',
                
                store: store ({type: 'voc_unit__voc_unit_coeffs', id: -1}),
                
                forceFit: true,
                hideHeaders: true,
                region: 'center',
                columns: [
                    {
                        xtype: 'numbercolumn',
                        dataIndex: 'number',
                        text: 'Number'
                    },
                    {
                        xtype: 'gridcolumn',
                        dataIndex: 'string',
                        text: 'String'
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
        me.callParent(arguments);
    }    
    
});