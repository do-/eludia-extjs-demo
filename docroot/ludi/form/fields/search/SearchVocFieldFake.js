Ext.define ('Ext.ux.ludi.form.fields.search.SearchVocFieldFake', {

    extend: 'Ext.ux.ludi.form.fields.search.SearchVocField',
    alias : 'widget.searchselectfieldfake',

    initComponent: function () {
    
        var me = this;

        def (me, {

            name: 'fake',
            data: [
                ['0', 'Активные'],
                ['-1', 'Удалённые'],
                ['0,-1', 'Все']
            ]

        });

        me.callParent (arguments);

    }

});