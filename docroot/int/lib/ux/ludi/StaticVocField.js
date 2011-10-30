Ext.require ('Ext.ux.ludi.VocField');

Ext.define ('Ext.ux.ludi.StaticVocField', {

    extend: 'Ext.ux.ludi.VocField',
    alias : 'widget.staticvocfield',

    initComponent: function () {
    
        var me = this;
        
        me.store = new Ext.data.Store ({
            model: 'voc',
            proxy: {
                type: 'ajax',
                url: '/voc/' + me.type + '.json',
                reader: {
                    type: 'array',
                    root: 'content'
                }
            }
        });

        me.callParent (arguments);

    }

});