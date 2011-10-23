Ext.define ('UI.view.voc_groups.list', {

    extend: 'Ext.panel.Panel',
    alias : 'widget.voc_groups_list',

    title : 'Номенклатура',
    layout: 'fit',
    autoShow: true,
    region: 'west',
    width: 200,
    collapsible: true,
    id:     'left_menu',
    hidden: true,
    split: true,

    initComponent: function () {

    var store = Ext.create('Ext.data.TreeStore', {

        autoLoad: true,

        proxy: {
            type: 'ajax',
            url: '/handler',
            extraParams: {type: 'voc_groups'},
            reader: {
                type: 'json',
                root: 'content'
            }
        },

        defaultRootId : 0

        });

        this.items = [

        {
            xtype: 'treepanel',
            rootVisible : false,
            store: store,




            viewConfig: {
                plugins: {
                ptype: 'treeviewdragdrop',
                enableDrop : false
                }
            },



            listeners: {

                itemdblclick: {

                    fn: function (me, record, item, index, event, options) {

                        Ext.create ('UI.view.products.list', {voc_group: record});

                    }

                },

                itemcontextmenu: {

                    fn: function (grid, record, item, index, event, options) {

                        event.stopEvent ();

                        new Ext.menu.Menu ({

                            floating: true,

                            items: noOff ([

                                {
                                    text: 'Свойства...',

                                    handler: function () {

                                    openAndLoadFormForTheGridRecord (grid, record);

                                    }

                                },
                                {
                                    xtype: 'menuseparator'
                                },

                                {
                                    text: 'Создать подрубрику...',

                                    handler: function () {

                                        ajax ('/?type=voc_groups&action=create&_parent=' + record.get ('id'), function (data, grid) {

                                        openAndLoadFormForTheGridRecord (grid, {get: function () {return data.content.id}});

                                        }, grid);

                                    }

                                },

                                {
                                    text: 'Удалить',

                                    off: !record.get ('leaf'),

                                    handler: function () {

                                        if (!confirm ('Вы уверены, что хотите удалить группу "' + record.get ('text') + '"?')) return;

                                        var id = record.get ('id');

                                        ajax ('/?type=voc_groups&action=delete&id=' + id, function (data, store) {

                                            store.getNodeById (id).remove ()

                                        }, store);

                                    }

                                }

                            ])

                        }).showAt (event.xy);

                    }

                }

            }

        }

    ];

    this.load = function () {
        store.load ();
    };

        this.callParent (arguments);

    }






});