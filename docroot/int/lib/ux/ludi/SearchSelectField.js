Ext.define ('Ext.ux.ludi.SearchSelectField', {

    extend: 'Ext.form.ComboBox',
    alias : 'widget.searchselectfield',

    initComponent: function () {

        def (this, {
            width: 90,
            displayField: 'label',
            valueField: 'id',
            forceSelection: true,
            value: '0',
            queryMode: 'local',
            allowBlank: false,
            editable: false,
            typeAhead: false,
            listeners: {change: {fn: changeSearchFieldValue}}
        });

        this.callParent (arguments);

    }

});