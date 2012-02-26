Ext.define ('Ext.ux.ludi.VocField', {

    extend: 'Ext.form.ComboBox',

    initComponent: function () {
    
        var me = this;
        
        me.displayField = 'label';
        me.valueField   = 'id';

        this.callParent (arguments);

    }

});