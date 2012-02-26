Ext.define ('Ext.ux.ludi.VocSearchField', {

    extend: 'Ext.ux.ludi.VocField',

    initComponent: function () {
    
        var me = this;
               
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