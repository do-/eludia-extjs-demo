Ext.require ('Ext.ux.ludi.grid.PagedCheckedGridPanel');
Ext.require ('Ext.ux.ludi.SearchSelectField');
Ext.require ('Ext.ux.ludi.SearchSelectFieldFake');
Ext.require ('Ext.ux.ludi.SearchTextField');
Ext.require ('Ext.ux.ludi.SearchCheckboxField');
Ext.require ('Ext.ux.ludi.StaticVocField');
Ext.require ('Ext.ux.ludi.DynamicVocField');
Ext.require ('Ext.ux.ludi.DisplayDateTimeField');
Ext.require ('Ext.ux.ludi.form.buttons.CancelButton');
Ext.require ('Ext.ux.ludi.form.buttons.SaveButton');
Ext.require ('Ext.ux.ludi.form.FormWindow');
Ext.require ('Ext.ux.ludi.BooleanBoxField');

Ext.define ('voc', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',    type: 'int'   },
        {name: 'label', type: 'string'},
    ]
});
