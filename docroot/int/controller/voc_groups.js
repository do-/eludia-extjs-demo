Ext.define('UI.controller.voc_groups', {

    extend: 'Ext.app.Controller',

    views: [
        'voc_groups.list'
        , 'voc_groups.edit'
    ],

    init: function () {
    
        this.control ({
        
 		'voc_groups_edit button[action=save]': {
			click: saveRefreshParentGridAndCloseThisWindow
		},
		
 		'voc_groups_edit button[action=close]': {
			click: closeContainingWindow
		}
		
        
        });
                
    },
        
});