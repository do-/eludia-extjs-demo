Ext.define('UI.store.users', {
    extend: 'Ext.data.Store',
    model: 'UI.model.users',
    proxy: {
        type: 'ajax',
        url: '/handler',
        extraParams: {'type': 'users'},
        reader: {
            type: 'json',
            root: 'content.users'
        }
    }
});