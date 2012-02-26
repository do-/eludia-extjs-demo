Ext.require ('UI.view.products.edit_main', function () {

Ext.define ('UI.view.products.edit', {

    extend: 'Ext.window.Window',
    alias : 'widget.products_edit',
    closeAction: 'hide',

    title : 'Номенклатурная единица',
    layout: 'fit',
    autoShow: true,
    width: 600,
    height: 400,
    defaultFocus : 'label',

    items: [{
        xtype: 'tabpanel',
        items: [
            Ext.create ('UI.view.products.edit_main')
//            , Ext.create ('UI.view.products.search')
        ]
    }]

});

});