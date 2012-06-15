Ext.define ('UI.view.doc_folders.list', {

    extend: 'Ext.tree.Panel',

    title : 'Документы',
    id: 'doc_folders',
    rootVisible : false,
    viewConfig: {
        plugins: {
            ptype: 'treeviewdragdrop',
            enableDrop : false
        }
    },

    initComponent: function () {

        var me = this;

        me.store = Ext.create('Ext.data.TreeStore', {

            proxy: {
                type: 'ajax',
                url: '/handler',
                extraParams: {type: 'doc_folders'},
                reader: {
                    type: 'json',
                    root: 'content'
                }
            },

            defaultRootId : 0

        });

        me.openEditForm = function (params) {
            var url  = '?type=doc_folders&' + params;
            var win  = Ext.create ('UI.view.doc_folders.edit');
            win.grid = me;
            ajax (url, me.setFormData, win.down ('form').getForm ());
        };

        me.setFormData = function (data, form) {form.setValues (data.content)};

        me.getPopupMenuItems = function (record) {

            var id = record.get ('id');

            return noOff ([

                {
                    text: 'Свойства...',
                    handler: function () {me.openEditForm ('id=' + id)}
                },

                {
                    xtype: 'menuseparator'
                },

                {
                    text: 'Создать подпапку...',
                    handler: function () {me.openEditForm ('action=create&_parent=' + id)}
                },

                {
                    text: 'Удалить',
                    off: !record.get ('leaf'),
                    handler: function () {
                        if (!confirm ('Вы уверены, что хотите удалить папку "' + record.get ('text') + '"?')) return;
                        ajax ('/?type=doc_folders&action=delete&id=' + id, function (data, form) {
                            me.store.load ({
                                node: me.store.getNodeById (data.content.parent),
                                callback: function () {
                                    var v = me.getView ();
                                    var n = me.store.getNodeById (data.content.id);
                                    v.expand (n, false, function () {v.select ([n])});
                                }
                            });
                        });
                    }

                }

            ])

        };

        me.listeners = {

            itemdblclick: {
                fn: function (grid, record, item, index, event, options) {Ext.create ('UI.view.docs.list', {doc_folder: record})}
            },

            itemcontextmenu: {
                fn: function (grid, record, item, index, event, options) {
                    event.stopEvent ();
                    new Ext.menu.Menu ({floating: true, items: me.getPopupMenuItems (record)}).showAt (event.xy)
                }
            }

        };

        me.callParent (arguments);

    }

});