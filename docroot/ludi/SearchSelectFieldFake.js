Ext.define ('Ext.ux.ludi.SearchSelectFieldFake', {

    extend: 'Ext.ux.ludi.SearchSelectField',
    alias : 'widget.searchselectfieldfake',

    initComponent: function () {
    
        var me = this;

        def (me, {

            name: 'fake',
            store: Ext.create ('Ext.data.ArrayStore', {
                autoDestroy: true,
                idIndex: 0,
                fields: ['id','label'],
                data: [
                    ['0', 'Активные'],
                    ['-1', 'Удалённые'],
                    ['0,-1', 'Все']
                ]
            })

        });

        me.displayField = 'label';
        me.valueField   = 'id';

        me.store.load ();

        me.callParent (arguments);

    }

});