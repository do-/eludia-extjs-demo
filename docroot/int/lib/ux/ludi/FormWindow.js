Ext.define ('Ext.ux.ludi.FormWindow', {
    extend: 'Ext.window.Window',
    alias: 'widget.formwindow',
    onEsc: Ext.emptyFn,
    listeners: {afterrender: {fn: function (me) {
    
        new Ext.util.KeyMap (me.getEl (), [
            {
                key: [27],
                fn: function (key, event) {
                    event.stopEvent ();
                    clickButton (me.down ('cancelbutton'));
                }
            }, 
            {
                key: [13],
                ctrl:true,
                fn: function (key, event) { 
                    event.stopEvent ();
                    clickButton (me.down ('button'));
                }
            } 
        ]);
        
    }}}
    
});