Ext.define ('Ext.ux.ludi.form.fields.search.SearchCheckboxField', {

    extend: 'Ext.form.field.Checkbox',
    alias : 'widget.searchcheckfield',

    initComponent: function () {

        def (this, {
            listeners: {change: {fn: changeSearchFieldValue}}
        });

        this.callParent (arguments);

    }

});
