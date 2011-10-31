Ext.define ('Ext.ux.ludi.SearchSelectField', {

    extend: 'Ext.form.ComboBox',
    alias : 'widget.searchselectfield',

    initComponent: function () {
    
        this.displayField = 'label';
        this.editable = false;

        def (this, {
            width: 90,          
            valueField: 'id',
            forceSelection: true,
            queryMode: 'local',
            allowBlank: false,
            listeners: {change: {fn: changeSearchFieldValue}}
        });

        this.callParent (arguments);

    }

});