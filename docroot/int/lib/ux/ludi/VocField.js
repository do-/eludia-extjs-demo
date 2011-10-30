Ext.define ('Ext.ux.ludi.VocField', {

    extend: 'Ext.form.ComboBox',

    initComponent: function () {
    
        var me = this;
        
        me.displayField = 'label';
        me.valueField   = 'id';
        
        if (!me.listeners) me.listeners = {};
        me.listeners.change = {fn: changeSearchFieldValue};

        def (me, {
            forceSelection: false,
            allowBlank: true,
            editable: false,
            typeAhead: false,
            multiSelect: true
        });
        
        this.callParent (arguments);

    }

});