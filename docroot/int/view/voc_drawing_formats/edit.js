Ext.define ('UI.view.voc_drawing_formats.edit', {

    extend: 'Ext.ux.ludi.FormWindow',
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
//              bodyStyle: 'padding:5px; border:0px; _border-bottom:1px;',
                waitMsgTarget: true,                
                trackResetOnLoad: true,

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
                        xtype: 'booleanbox',
                        name: 'is_multiple_pages',
                        fieldLabel: 'Много листов',
                    },
                    {
                        xtype: 'lastmodifiedfieldset'
                    }

                ],

                buttons: [
                    {
                        xtype: 'savebutton'
                    },
                    {
                        xtype: 'cancelbutton'
                    }
                ]

            }

        ];

        this.callParent(arguments);

    }

});