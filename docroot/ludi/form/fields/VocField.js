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
        
        this.callParent (arguments);

    }

});