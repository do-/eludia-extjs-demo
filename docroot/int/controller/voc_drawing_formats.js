Ext.define('UI.controller.voc_drawing_formats', {

    extend: 'Ext.app.Controller',

    views: [
        'voc_drawing_formats.list'
        , 'voc_drawing_formats.edit'
    ],

    models: ['voc_drawing_formats'],

    init: function () {
    
        this.control ({
        
            'voc_drawing_formats_list': {
                  show: loadFirstGrid
            },

            'voc_drawing_formats_list pagingtoolbar textfield': {
                change: changeSearchFieldValue
            },

            'voc_drawing_formats_list gridpanel': {
            	  containercontextmenu: showMenuOffTableBody,
            	  itemcontextmenu: showMenuOnTableBody,
                  itemdblclick: openAndLoadFormForTheGridRecord
            },
            
 		'voc_drawing_formats_list button[action=edit]': {
			click: showMenuOnToolbarButton
		},
		
 		'voc_drawing_formats_edit button[action=save]': {
			click: saveRefreshParentGridAndCloseThisWindow
		},
		
 		'voc_drawing_formats_edit button[action=close]': {
			click: closeContainingWindow
		}
                                   
        });
                
    },


	getPopupMenuItems: function (cnt) {
	
		return [
			{
				text    : 'Создать...', 
				handler : showNewObjectEditForm
			}
			, {
				xtype   : 'menuseparator',
				off     : (cnt [0] == 0 && cnt [-1] == 0)
			}
			, {
				text    : 'Удалить ' + russianNRecords (cnt [0]), 
				handler : askToKillRecords, 
				off     : (cnt [0] == 0 || cnt [-1] > 0)
			}
			, {
				text    : 'Слить ' + russianNRecords (cnt [0]), 
				handler : askToMergeRecords, 
				off     : (cnt [0] == 0 || cnt [-1] > 0)
			}
			, {
				text    : 'Восстановить ' + russianNRecords (cnt [-1]), 
				handler : askToMergeRecords, 
				off     : (cnt [0] > 0 || cnt [-1] == 0)
			}
			
		];
	
	}
    
});