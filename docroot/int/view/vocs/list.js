Ext.define ('UI.view.vocs.list', {


    extend: 'Ext.tree.Panel',

    title: 'Справочники',
    store: store,
    rootVisible: false,
    store: Ext.create ('Ext.data.TreeStore', {
        root: {
            expanded: true,
            children: [
                { text: "Единицы измерения", id: 'voc_units',           leaf: true},
                { text: "Форматы чертежей",  id: 'voc_drawing_formats', leaf: true}
            ]
        }
    }),
    listeners: {
        itemdblclick: {
            fn: function (me, record, item, index, event, options) {
                Ext.create ('UI.view.' + record.get ('id') + '.list', {});
            }
        }
    }


/*
    extend: 'Ext.panel.Panel',
    title : 'Справочники',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {

        this.items = [



                {
                    xtype: 'button',
                    cls: 'x-btn-flat',
                    text: 'Единицы измерения',
                    handler: function () {Ext.create ('UI.view.voc_units.list', {})}
                },
                {
                    xtype: 'button',
                    cls: 'x-btn-flat',
                    text: 'Форматы чертежей',
                    handler: function () {Ext.create ('UI.view.voc_drawing_formats.list', {})}
                }

        ];

        this.callParent (arguments);

    }
*/
});