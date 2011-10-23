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




                        , name: 'fake'
                        , store: Ext.create ('Ext.data.ArrayStore', {
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

        this.callParent (arguments);

    }

});