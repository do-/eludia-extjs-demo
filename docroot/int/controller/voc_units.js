Ext.define('UI.controller.voc_units', {

    extend: 'Ext.app.Controller',

    views: [
        'voc_units.list'
        , 'voc_units.edit'
    ],

    models: ['voc_units', 'voc_unit_coeffs'],

    init: function () {
    
        this.control ({
        
            'voc_units_list': {
                  show: loadFirstGrid
            },

            'voc_units_list pagingtoolbar textfield': {
                change: changeSearchFieldValue
            },

            'voc_units_list gridpanel': {
            	  containercontextmenu: showMenuOffTableBody,
            	  itemcontextmenu: showMenuOnTableBody,
                  itemdblclick: this.open
            },
            
 		'voc_units_list button[action=edit]': {
			click: showMenuOnToolbarButton
		},
		
 		'voc_units_edit button[action=save]': {
			click: this.save
		},
		
 		'voc_units_edit button[action=close]': {
			click: closeContainingWindow
		}
                                   
        });
                
    },    
    
    save: function (button) {
    
    	var win = button.up ('window');
    
    	var form  = win.down ('form').getForm ();
    	var store = win.down ('gridpanel').store;

	for (var i = 0; i < store.getCount (); i ++) {
		var r = store.getAt (i);
		var v = r.get ('voc_unit_coeff.coeff');
		form.baseParams ['unit_' + r.get ('id')] = v > 0 ? v : '';
	}    	
    	
    	submit (form, function (page, form) {

		var win = form.owner.up ('window');
		win.grid.store.load ();
		win.close ();

	});

    },    
    
    open: function (grid, record) {

    	var type = typeBehindTheGrid (grid);
    
            var win = Ext.widget (type + '_edit');
            
            win.grid = grid;
            
            var form = win.down ('form');
            
		ajax ('?type=' + type + '&id=' + record.get ('id'), function (data, form) {

			form.getForm ().setValues (data.content);

			var store = form.up ('window').down ('gridpanel').store;

			store.add (data.content.voc_units);

		}, form)

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
				off     : (cnt [0] <  2 || cnt [-1] > 0)
			}
			, {
				text    : 'Восстановить ' + russianNRecords (cnt [-1]), 
				handler : askToMergeRecords, 
				off     : (cnt [0] > 0 || cnt [-1] == 0)
			}
			
		];
	
	}
    
});