function ajax (url, handler, form) {

	if (/type=_boot/.test (url)) return alert ('Session expired');
	
	if (url.charAt (0) === '/') url = url.substr (1);

	if (sid && !/\bsid=[0-9]/.test (url)) url += ('&sid=' + sid);

	Ext.Ajax.request ({

		url: '/handler' + url,
		
		method: 'GET',

		scope: {handler: handler, form: form},

		callback: function (options, success, response) {

			if (!success) return ajax_failure (response, options);
			
			try {

				var data = Ext.decode (response.responseText, true);
				
				if (data.success === 'redirect') return ajax (data.url, this.handler, this.form);

				if (!data.success) return ajax_failure (response, options);
								
			}
			catch (e) {
			
				return ajax_failure (response, options);
			
			}

			return this.handler (data, form);

		}
		
	});

}

function closeContainingWindow (button) {

	button.up ('window').close ();
	
}

function refreshParentGridAndCloseThisWindow (page, form) {
	var win = form.owner.up ('window');
	win.grid.store.load ();
	win.close ();
}

function saveRefreshParentGridAndCloseThisWindow (button) {
    
	submit (button.up ('window').down ('form').getForm (), refreshParentGridAndCloseThisWindow);
	
}

function openAndLoadFormForTheGridRecord (grid, record) {

	var type = typeBehindTheGrid (grid);

        var win = Ext.widget (type + '_edit');
        
        win.grid = grid;
        
        var form = win.down ('form').getForm ();

        loadItem ('?type=' + type + '&id=' + record.get ('id'), form);

}


function loadItem (url, form, fn) {

	ajax (url, function (data, form) {
		form.setValues (data.content);
	}, form)

}

function fakeSelect () {

	return Ext.create('Ext.form.ComboBox', {
						name: 'fake',
						width: 90,
						displayField: 'label',
						valueField: 'id',
						forceSelection: true,
						value: '0',
						queryMode: 'local',
						allowBlank: false,
						editable: false,
						typeAhead: false,						    												
						store: Ext.create ('Ext.data.ArrayStore', {
						    autoDestroy: true,
						    idIndex: 0,
						    fields: ['id','label'],
						    data: [
						    	['0', 'Активные'],
						    	['-1', 'Удалённые'],
						    	['0,-1', 'Все']
						    ]
			})
						
		});

					
	

}

function standardGetRowClass (record, rowIndex, rp, ds) {
		
	return record.get ('fake') == -1 ? 'deleted-record' : '';
        
}

function loadFirstGrid (win) {
    
	win.down ('gridpanel').store.load ();
	
}

function changeSearchFieldValue (field, value) {

	if (field.name == 'inputItem') return;

	var tb = field.up ('pagingtoolbar');
    
    	var store = tb.store;
    	
    	store.proxy.extraParams [field.name] = value;

	tb.moveFirst ();
    
}

function showNewObjectEditForm () {

        var win = Ext.widget (typeBehindTheGrid (this) + '_edit');

        win.grid = this;

}

function showMenuOnTableBody (grid, record, item, index, event, options) { 
	
	showMenuOffTableBody (grid, event) 

}

function showMenuOnToolbarButton (button, event) {

	button.menu = createPopupMenu (button.up ('window').down ('gridpanel'));

	button.showMenu ();

	button.menu = undefined;

}

function russianNRecords (n) {

	var s = n + ' запис';
	
	if ((n > 4 && n < 21)) return s + 'ей';
	
	var r = n % 10;
	
	if (r == 0) return s + 'ей';
	if (r == 1) return s + 'ь';
	if (r <  5) return s + 'и';

	return s + 'ей';
	
}

function showMenuOffTableBody (grid, event) {

    	event.stopEvent ();
		
    	createPopupMenu (grid).showAt (event.xy);

}

function createPopupMenu (grid) {

    	var selected = grid.getSelectionModel ().selected;

    	var cnt = {'0': 0, '-1': 0};
    	for (var i = 0; i < selected.getCount (); i ++) cnt ['' + selected.getAt (i).get ('fake')] ++;

/*	
	var a = [['Создать', showNewObjectEditForm]];
	if (cnt [0] >  0 && cnt [-1] == 0) a.push (['Удалить '      + russianNRecords (cnt [ 0]), askToKillRecords]);
	if (cnt [0] >  0 && cnt [-1] == 0) a.push (['Слить '        + russianNRecords (cnt [ 0]), askToMergeRecords]);
	if (cnt [0] == 0 && cnt [-1] >  0) a.push (['Восстановить ' + russianNRecords (cnt [-1]), askToUnKillRecords]);
*/

	var a = theApplication.getController (typeBehindTheGrid (grid)).getPopupMenuItems (cnt);

	items = [];
//	for (var i = 0; i < a.length; i ++) items.push ({text: a[i][0]});
	for (var i = 0; i < a.length; i ++) {
		if (a[i].off) continue;
		items.push (a[i]);
	}
	
	popupMenu = new Ext.menu.Menu ({
	    floating: true,
	    items: items                       
	}); 

//	for (var i = 0; i < a.length; i ++) popupMenu.items.getAt(i).on ('click', a[i][1], grid);	
	
	return popupMenu;

}

function typeBehindTheGrid (grid) {

	var store = grid.store;
	
	if (!store) store = grid.getStore ();
	
	return store.getProxy ().extraParams.type;
	
}

function askToUnKillRecords () {

	performBatchOperation (this, 'unkill');

}

function askToKillRecords () {

	Ext.Msg.show ({
	     title:'Предупреждение',
	     msg: 'Вы действительно хотите удалить ' + russianNRecords (this.getSelectionModel ().selected.getCount ()) + '?',
	     buttons: Ext.Msg.YESNO,
	     scope: this,
	     fn: function (choice) {if (choice == 'yes') performBatchOperation (this, 'kill')}
	});	
	
}

function askToMergeRecords () {

	Ext.Msg.show ({
	     title:'Предупреждение',
	     msg: 'Вы действительно хотите слить ' + russianNRecords (this.getSelectionModel ().selected.getCount ()) + '? Вы уверены что они все описывают один и тот же объект?',
	     buttons: Ext.Msg.YESNO,
	     scope: this,
	     fn: function (choice) {if (choice == 'yes') performBatchOperation (this, 'merge')}
	});	
	
}

function performBatchOperation (grid, action) {

	var type     = typeBehindTheGrid (grid);
     	var href     = '?type=' + type + '&action=' + action;
	var selected = grid.getSelectionModel ().selected;
	var cnt      = selected.getCount ();
	
     	for (var i = 0; i < cnt; i ++) href += '&_' + type + '_' + selected.getAt (i).get ('id') + '=1';

     	ajax (href, function (data, grid) {grid.store.load ()}, grid);

}







var theApplication;

Ext.require('Ext.app.Application');

Ext.onReady(function() {

	theApplication = Ext.create('Ext.app.Application', 
	




{

    name: 'UI',
    appFolder: 'int',

    launch: function() {
    
    	document.body.innerHTML = '';

	Ext.create ('Ext.container.Viewport', {

		layout: 'border',

		items: [
            
//			{
//				xtype:  'toolbar',
//				region: 'north',
//				id:     'main_menu',
//				height: 30,
//				items:  ['Аутентификация'],
//				hidden: true
//			},
			

			{
			    xtype: 'toolbar',
				region: 'north',
				id:     'main_menu',
				height: 30,
				hidden: true,
			    items: [
				{
				    xtype: 'button',
				    text: 'Номенклатура'
				},
				{
				    xtype: 'button',
				    text: 'Справочники',
				    menu: {
					xtype: 'menu',
					items: [
					    {
						xtype: 'menuitem',
						text: 'Единицы измерения',
						handler: function () {Ext.widget ('voc_units_list')}
					    },
					    {
						xtype: 'menuitem',
						text: 'Форматы чертежей',
						handler: function () {Ext.widget ('voc_drawing_formats_list')}
					    }
					]
				    }
				}
//				,{
//				    xtype: 'button',
//				    text: 'Пользователи',
//					handler: function () {Ext.widget ('users_list')},
//				}
			    ]
			},			
			
			
			
			
			{
				xtype:  'panel',
				region: 'center',
				id:     'center',
				html:  '<table width="100%" height="100%" cellpadding="0" cellspacing="0" _background="/i/background.jpg"><tr><td>&nbsp;</td></tr></table>'
			}
         	
		]

        });

        Ext.widget ('sessions_edit');

    },
    
    controllers: [
        'sessions'
        , 'users'
        , 'voc_drawing_formats'
        , 'voc_units'
    ]

}

	
	
	);
});






