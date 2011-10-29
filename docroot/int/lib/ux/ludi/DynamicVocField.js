Ext.require ('Ext.ux.ludi.VocField');

Ext.define ('Ext.ux.ludi.DynamicVocField', {

    extend: 'Ext.ux.ludi.VocField',
    alias : 'widget.dynamicvocfield',

    initComponent: function () {

        var me = this;

        me.store = new Ext.data.Store ({
            model: 'voc',
            remoteSort : true,
                proxy: {
                type: 'ajax',
                url: '/handler',
                extraParams: {type: me.type, xls: 1},
                reader: {
                    type: 'json',
                    useSimpleAccessors: false,
                    root: 'content.' + me.type
                }
            }
        });

        me.callParent (arguments);

    }

});