Ext.define('UI.controller.users', {

    extend: 'Ext.app.Controller',

    views: [
        'users.list'
        , 'users.edit'
    ],

    stores: ['users'],
    models: ['users'],

    init: function () {
    
        this.control ({
        
            'users_list gridpanel': {
                  itemdblclick: this.editUser
            },
            
            'users_list button[action=edit]': {
                click: this.newUser
            },
            
            'users_edit button[action=save]': {
                click: this.updateUser
            }
            
        });
        
    },

    updateUser: function (button) {

	submit (button.up ('window').down('form').getForm (), function (data, form) {
	
		var win = form.owner.up ('window');
	
		win.grid.store.load ();

		win.close ();
	
	});
	    
    },
    
    newUser: function (button) {
    
        var win = Ext.widget ('users_edit');

        win.grid = button.up ('window').down('gridpanel');

    },
    
    editUser: function (grid, record) {
    
        var win = Ext.widget ('users_edit');
        
        win.grid = grid;
        
        win.down ('form').loadRecord (record);        
    
    }
    
});