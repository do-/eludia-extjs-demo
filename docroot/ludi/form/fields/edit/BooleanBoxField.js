Ext.define ('Ext.ux.ludi.form.fields.edit.BooleanBoxField', {

    extend: 'Ext.form.Checkbox',
    alias : 'widget.booleanbox',

    initComponent: function () {
   
        var me = this;
        
        me.inputValue = 1;
        me.uncheckedValue = 0;
   
        def (me, {
            boxLabel: '',
        });

        me.callParent (arguments);

    }

});