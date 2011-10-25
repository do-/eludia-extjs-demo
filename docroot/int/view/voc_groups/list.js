Ext.define ('UI.view.voc_groups.list', {

    extend: 'Ext.tree.Panel',

    title : 'Номенклатура',
    id: 'voc_groups',
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
                extraParams: {type: 'voc_groups'},
                reader: {
                    type: 'json',
                    root: 'content'
                }
            },

            defaultRootId : 0

        });

        me.openEditForm = function (params) {
            var url  = '?type=voc_groups&' + params;
            var win  = Ext.create ('UI.view.voc_groups.edit');
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
                    text: 'Создать подрубрику...',
                    handler: function () {me.openEditForm ('action=create&_parent=' + id)}
                },

                {
                    text: 'Удалить',
                    off: !record.get ('leaf'),
                    handler: function () {
                        if (!confirm ('Вы уверены, что хотите удалить группу "' + record.get ('text') + '"?')) return;
                        ajax ('/?type=voc_groups&action=delete&id=' + id, function (data, form) {
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
                fn: function (grid, record, item, index, event, options) {Ext.create ('UI.view.products.list', {voc_group: record})}
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