Ext.require ('Ext.ux.ludi.VocField');

Ext.define ('Ext.ux.ludi.DynamicVocField', {

    extend: 'Ext.ux.ludi.VocField',
    alias : 'widget.dynamicvocfield',

    initComponent: function () {

        var me = this;
        
        if (!me.params) me.params = {type: me.type};
        me.params.xls = 1;

        me.store = new Ext.data.Store ({
            model: 'voc',
            remoteSort : true,
                proxy: {
                    type: 'ajax',
                    url: '/handler',
                    extraParams: me.params,
                    reader: {
                        type: 'json',
                        root: 'content.' + me.type
                    }
                }
            }
        );

        me.callParent (arguments);

    }

});