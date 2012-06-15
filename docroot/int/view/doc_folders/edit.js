Ext.define ('UI.view.doc_folders.edit', {

    extend: 'Ext.ux.ludi.form.FormWindow',
    alias : 'widget.doc_folders_edit',
    closeAction: 'hide',

    title : 'Папка',
    layout: 'fit',
    autoShow: true,
    width: 500,
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
                    type: 'doc_folders',
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
						xtype:'combovocfield',
						fieldLabel: 'Тип',
						name: 'is_global',
						data: [
							['0', 'Локальный'],
							['1', 'Глобальный (доступен в других базах)'],
							['2', 'Глобальный (из другой базы)']
						]
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
//                    {
//                       xtype: 'lastmodifiedfieldset'
//                    }

                ],

                buttons: [

                    {

                        text: 'Сохранить',
                        handler:

                            function (button) {

                                submit (button.up ('window').down ('form').getForm (), function (page, form) {

                                    var store      = me.grid.store;
                                    var id         = page.content.id;
                                    var parent     = page.content.parent;
                                    var parentNode = store.getNodeById (parent);

                                    if (parentNode.get ('leaf')) {

                                        ajax ('?type=doc_folders&id=' + parent, function (data, form) {

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