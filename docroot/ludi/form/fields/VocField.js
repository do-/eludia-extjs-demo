Ext.define ('Ext.ux.ludi.form.fields.VocField', {

    extend: 'Ext.form.ComboBox',

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

        this.callParent (arguments);

    }

});