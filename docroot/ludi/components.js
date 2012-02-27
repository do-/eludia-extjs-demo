Ext.require ('Ext.ux.ludi.grid.PagedCheckedGridPanel');

Ext.require ('Ext.ux.ludi.form.FormWindow');
Ext.require ('Ext.ux.ludi.form.buttons.CancelButton');
Ext.require ('Ext.ux.ludi.form.buttons.SaveButton');
Ext.require ('Ext.ux.ludi.form.fields.edit.BooleanBoxField');
Ext.require ('Ext.ux.ludi.form.fields.search.SearchCheckboxField');
Ext.require ('Ext.ux.ludi.form.fields.search.SearchTextField');
Ext.require ('Ext.ux.ludi.form.fields.search.SearchVocField');
Ext.require ('Ext.ux.ludi.form.fields.search.SearchVocFieldFake');
Ext.require ('Ext.ux.ludi.form.fields.show.DisplayDateTimeField');

Ext.define ('voc', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',    type: 'int'   },
        {name: 'label', type: 'string'},
    ]
});
