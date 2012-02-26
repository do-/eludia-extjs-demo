Ext.define ('Ext.ux.ludi.SaveButton', {
    extend: 'Ext.button.Button',
    alias: 'widget.savebutton',
    text: 'Сохранить',
    handler: saveRefreshParentGridAndCloseThisWindow
});