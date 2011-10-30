Ext.define ('UI.view.voc_groups.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_groups_edit',
    closeAction: 'hide',

    title : 'Номенклатурная группа',
    layout: 'fit',
    autoShow: true,
    width: 300,
    defaultFocus : 'label',

    initComponent: function () {

        var me = this;

        me.items = [

            {
                xtype: 'form',
                layout: 'fit',
                bodyPadding: 10,
                waitMsgTarget: true,
                trackResetOnLoad: true,

                baseParams: {
                    type: 'voc_groups',
                    action: 'update'
                },

                items: [

                    {
                        xtype : 'hiddenfield',
                        name  : 'id',
                        hidden: true
                    },
                    {
                        xtype : 'hiddenfield',
                        name  : 'id_rights_holder',
                        hidden: true
                    },

                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'label',
                        itemId: 'label',
                        allowBlank : false,
                        msgTarget : 'side',
                        fieldLabel: 'Наименование',
                        blankText: 'Вы забыли ввести наименование'
                    },
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'vkg_okp',
                        itemId: 'vkg_okp',
                        msgTarget : 'side',
                        fieldLabel: 'ОКП'
                    },
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'no_1c',
                        itemId: 'no_1c',
                        msgTarget : 'side',
                        fieldLabel: '1С'
                    },
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'code_SKMTR',
                        itemId: 'code_SKMTR',
                        msgTarget : 'side',
                        fieldLabel: 'СКМТР'
                    },
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        name : 'note',
                        itemId: 'note',
                        msgTarget : 'side',
                        fieldLabel: 'Примечание'
                    },
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        size: 23,
                        readOnly : true,
                        name : 'rights_holder.label',
                        itemId: 'note',
                        msgTarget : 'side',
                        fieldLabel: 'Источник права'
                    },

                    {
                        xtype: 'lastmodifiedfieldset'
                    }

                ],

                buttons: [

                    {

                        text: 'Сохранить',
                        listeners: {click: {fn:

                            function (button) {

                                submit (button.up ('window').down ('form').getForm (), function (page, form) {

                                    var store      = me.grid.store;
                                    var id         = page.content.id;
                                    var parent     = page.content.parent;
                                    var parentNode = store.getNodeById (parent);

                                    if (parentNode.get ('leaf')) {

                                        ajax ('?type=voc_groups&id=' + parent, function (data, form) {

                                            store.load ({

                                                node: store.getNodeById (data.content.parent),
                                                callback: function () {

                                                    store.load ({

                                                        node: parentNode,
                                                        callback: function () {

                                                            var v = me.grid.getView ();

                                                            v.expand (store.getNodeById (parent), false, function () {

                                                                v.select ([store.getNodeById (id)]);

                                                            });

                                                        }
                                                    });

                                                }
                                            });

                                        })

                                    }
                                    else {

                                        store.load ({node: parentNode});

                                    }

                                    me.close ();

                                });

                            }

                        }}

                    },

                    {
                        xtype: 'cancelbutton'
                    }

                ],

                listeners : {

                    afterlayout: {

                        fn: function (cont, lay, o) {

                            var formPanelDropTarget = Ext.create ('Ext.dd.DropTarget', cont.body.dom, {

                                ddGroup: 'TreeDD',

                                notifyEnter: function(ddSource, e, data) {

                                    cont.body.stopAnimation ();
                                    cont.body.highlight ();

                                },

                                notifyDrop  : function(ddSource, e, data) {

                                    var selectedRecord = ddSource.dragData.records [0];

                                    cont.down ("hiddenfield[name='id_rights_holder']" ).setValue (selectedRecord.get ('id'));
                                    cont.down ("textfield[name='rights_holder.label']").setValue (selectedRecord.get ('text'));

                                    return true;

                                }

                            });

                        }

                    }

                }

            }

        ];

        this.callParent (arguments);

    }

});