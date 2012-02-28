Ext.define ('Ext.ux.ludi.form.fields.search.SearchVocField', {

    extend: 'Ext.ux.ludi.form.fields.VocField',
    alias : 'widget.searchvocfield',

    initComponent: function () {
    
        var me = this;
               
        if (!me.listeners) me.listeners = {};
        me.listeners.change = {fn: changeSearchFieldValue};

        suggest (me, {
            queryMode: 'local',
            forceSelection: false,
            allowBlank: true,
            editable: false,
            typeAhead: false,
            multiSelect: true
        });

        me.callParent (arguments);

    }

});