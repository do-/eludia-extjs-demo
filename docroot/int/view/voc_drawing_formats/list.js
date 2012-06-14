Ext.define ('UI.view.voc_drawing_formats.list', {

    extend: 'Ext.window.Window',
    closeAction: 'hide',
    maximizable : true,
    width: 800,
    height: 687,

    title : 'Список форматов чертежей',
    layout: 'fit',
    constrainHeader: true,
    autoShow: true,

    initComponent: function () {

        this.items = [

            {

                xtype: 'pagedcheckedgridpanel',

                parameters: {type: 'voc_drawing_formats'},

                columns : [

                    {header: 'Наименование', dataIndex: 'label', flex: 1}

                ]

            }

        ];

        this.callParent (arguments);

    }

});