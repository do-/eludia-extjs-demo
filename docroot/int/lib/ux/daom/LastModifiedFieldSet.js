Ext.define ('Ext.ux.daom.LastModifiedFieldSet', {

    extend: 'Ext.form.FieldSet',
    alias: 'widget.lastmodifiedfieldset',    

    initComponent: function () {
    
        var me = this;
        
        def (me,        
                            {
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
                                        xtype: 'displaydatetimefield',
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
        );
        
        me.callParent (arguments);

    }

});