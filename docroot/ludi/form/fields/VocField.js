Ext.define ('Ext.ux.ludi.form.fields.VocField', {

    extend: 'Ext.form.ComboBox',
    alias : 'widget.combovocfield',

    initComponent: function () {

        var me = this;

        me.displayField = 'label';
        me.valueField   = 'id';

        if (me.data && !me.store) {

            me.store = Ext.create ('Ext.data.ArrayStore', {
                autoDestroy: true,
                idIndex: 0,
                fields: ['id','label'],
                data: me.data
            });

            me.store.load ();

        }

        if (me.table && !me.store) {

            me.store = new Ext.data.Store ({
                model: 'voc',
                proxy: {
                    type: 'ajax',
                    url: '/voc/' + me.table + '.json',
                    reader: {
                        type: 'array',
                        root: 'content'
                    }
                }
            });

            me.store.load ();

        }

        if (me.type && !me.store) {

            if (!me.params) me.params = {type: me.type};
//            me.params.xls = 1;

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

            me.store.load ();

        }

        this.callParent (arguments);

    }

});