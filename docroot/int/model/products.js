Ext.define('UI.model.products', {
    extend: 'Ext.data.Model',
    fields: ['id',
        , 'fake'
        , 'label'
        , 'name'
        , 'voc_product_type.label'
        , 'voc_unit.label'
        , 'voc_group.label'
        , 'voc_product_status.label'
    ]
});