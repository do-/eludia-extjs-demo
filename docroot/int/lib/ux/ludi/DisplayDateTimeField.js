Ext.define ('Ext.ux.ludi.DisplayDateTimeField', {

    extend: 'Ext.form.field.Display',
    alias: 'widget.displaydatetimefield',
    
    valueToRaw: function (value) {
        if (Ext.isEmpty (value)) value = '';
        return value.replace (/^(\d\d\d\d)\-(\d\d)\-(\d\d)(.*)/, "$3.$2.$1$4");
    },

    rawToValue: function (value) {
        if (Ext.isEmpty (value)) value = '';
        return value.replace (/^(\d\d)\.(\d\d)\.(\d\d\d\d)(.*)/, "$3-$2-$1$4");
    }    

});