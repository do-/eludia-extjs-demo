Ext.define ('Ext.ux.ludi.form.fields.search.SearchVocField', {

    extend: 'Ext.ux.ludi.form.fields.VocField',
    alias : 'widget.searchselectfield',

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