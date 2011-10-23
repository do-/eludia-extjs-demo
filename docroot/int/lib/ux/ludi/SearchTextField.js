Ext.define ('Ext.ux.ludi.SearchTextField', {

    extend: 'Ext.form.field.Text',
    alias : 'widget.searchtextfield',

    initComponent: function () {

        def (this, {
            name: 'q',
            fieldLabel: 'Поиск',
            labelWidth: 50,
            listeners: {change: {fn: changeSearchFieldValue}}
        });

        this.callParent (arguments);

    }

});
