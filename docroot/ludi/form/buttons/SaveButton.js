Ext.define ('Ext.ux.ludi.form.buttons.SaveButton', {
    extend: 'Ext.button.Button',
    alias: 'widget.savebutton',
    text: 'Сохранить',
    handler: saveRefreshParentGridAndCloseThisWindow
});