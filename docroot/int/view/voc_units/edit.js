Ext.define ('UI.view.voc_units.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.voc_units_edit',
    closeAction: 'hide',

    title : 'Единица измерения',
    layout: 'border',
    autoShow: true,
    width: 350,
    height: 500,
    defaultFocus : 'label',

    initComponent: function() {

        this.items = [

            {
                xtype: 'form',
                region: 'north',
                layout: 'fit',
                height: 220,
                bodyPadding: 10,
                waitMsgTarget: true,
                trackResetOnLoad: true,

                baseParams: {
                    type: 'voc_units',
                    action: 'update'
                },

                items: [
                    {
                        xtype : 'hiddenfield',
                        name  : 'id',
                        hidden: true,
                        value : ':NEW'
                    },
                    {
                        xtype: 'textfield',
                        tabIndex: 0,
                        width: 320,
                        name : 'label',
                        itemId: 'label',
                        allowBlank : false,
                        msgTarget : 'side',
                        fieldLabel: 'Наименование',
                        blankText: 'Вы забыли ввести наименование'
                    },
                    {
                        xtype: 'textfield',
                        width: 320,
                        name: 'note',
                        fieldLabel: 'Примечание'
                    },
                    {
                        xtype: 'textfield',
                        width: 150,
                        name: 'code_okei',
                        fieldLabel: 'Код по ОКЕИ',
                        maskRe: /[0-9]/,
                        regex: /^[0-9]{3}$/,
                        regexText: 'Код ОКЕИ должен состять ровно из 3 арабских цифр'
                    },

                    {
                        xtype: 'lastmodifiedfieldset'
                    }

                ],

                buttons: [

                    {
                        text: 'Сохранить',
                        listeners: {click: {fn: function (button) {

                            var win = button.up ('window');

                            var form  = win.down ('form').getForm ();
                            var store = win.down ('gridpanel').store;

                            for (var i = 0; i < store.getCount (); i ++) {
                                var r = store.getAt (i);
                                var v = r.get ('voc_unit_coeff.coeff');
                                form.baseParams ['unit_' + r.get ('id')] = v > 0 ? v : '';
                            }

                            submit (form, function (page, form) {
                                var win = form.owner.up ('window');
                                win.grid.store.load ();
                                win.close ();
                            });

                        }}}

                    },

                    {
                        xtype: 'cancelbutton'
                    }

                ]

            },

            {
                xtype: 'gridpanel',
                title: 'Эквиваленты в других единицах',

                store: new Ext.data.Store ({
                    data: [],
                    fields: ['id', 'label', 'voc_unit_coeff.coeff'],
                    proxy: {
                        type: 'memory',
                        reader: {type: 'json'}
                    }
                }),

                forceFit: true,
                hideHeaders: true,
                region: 'center',
                columns: [
                    {
                        xtype: 'numbercolumn',
                        dataIndex: 'voc_unit_coeff.coeff',
                        text: 'сколько',
                        editor: {
                            xtype:'numberfield'
                        }
                    },
                    {
                        xtype: 'gridcolumn',
                        dataIndex: 'label',
                        text: 'чего'
                    }
                ],

                plugins: [Ext.create('Ext.grid.plugin.CellEditing', {})],

                dockedItems: [

                    {
                        xtype: 'toolbar',
                        dock: 'bottom',
                        layout: {
                            pack: 'end',
                            type: 'hbox'
                        },
                        items: [
                            {
                                xtype: 'textfield',
                                name: 'q',
                                fieldLabel: 'Искать',
                                labelWidth: 50
                            }
                        ]
                    }
                ]
            }

        ];

        this.callParent(arguments);

    }

});