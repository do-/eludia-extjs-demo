Ext.define('UI.controller.users', {

    extend: 'Ext.app.Controller',

    views: [
        'users.list'
        , 'users.edit'
    ],

    models: ['users'],

    init: function () {
    
        this.control ({
        
            'users_list': {
                  show: loadFirstGrid
            },

            'users_list pagingtoolbar textfield': {
                change: changeSearchFieldValue
            },

            'users_list gridpanel': {
            	  containercontextmenu: showMenuOffTableBody,
            	  itemcontextmenu: showMenuOnTableBody,
                  itemdblclick: this.editUser
            }
                                    
        });
                
    },
    
    editUser: function (grid, record) {
    
        var win = Ext.widget ('users_edit');
        
        win.grid = grid;
        
        win.down ('form').loadRecord (record);        
    
    }
    
});