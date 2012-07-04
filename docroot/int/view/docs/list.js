Ext.require ('UI.view.docs.search');

Ext.define ('UI.view.docs.list', {

    extend: 'Ext.window.Window',
    alias : 'widget.docs_list',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 700,
    layout: 'border',
    constrainHeader: true,
    autoShow: true,

    initComponent: function () {

        var me = this;

        me.title = me.doc_folder.get ('text');

        me.grid = Ext.widget ('pagedcheckedgridpanel', {

                region: 'center',

                parameters: {type: 'docs', id_doc_folder: this.doc_folder.get ('id')},

                search: [
                    {
                        xtype: 'searchcheckfield',
                        fieldLabel: 'С подрубриками',
                        name: 'tree',
                        off: me.doc_folder.get ('leaf')
                    }
                ],

                columns : [
                      {header: 'Номер',            dataIndex: 'no',                width: 50}
                    , {header: 'Изделие',          dataIndex: 'product.full_name', flex: 1}
                    , {header: 'Категория товара', dataIndex: 'voc_group.label',   flex: 1}
                    , {header: 'Отв. менеджер',    dataIndex: 'user.label',        flex: 1}
                ],

				setFormData: function (data, form) {
					form.owner.up ('window').query ('form').forEach (function (f) {setFormData (data, f.getForm());});
					form.owner.up ('window').down('#doc_tasks').store.proxy.extraParams.id_type = data.content.id;
					form.owner.up ('window').down('#doc_tasks').store.load ();
				}


        });

        me.items = [
            me.grid
            , Ext.create ('UI.view.docs.search')
        ];

        this.callParent (arguments);

    }

});