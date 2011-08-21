Ext.application({

    name: 'UI',
    appFolder: 'int',

    launch: function() {
    
    	document.body.innerHTML = '';

        Ext.create ('Ext.container.Viewport', {

		layout: 'border',

		items: [
            
			{
				xtype:  'toolbar',
				region: 'north',
				id:     'main_menu',
				height: 30,
				items:  ['Аутентификация'],
				hidden: true
			},
			{
				xtype:  'panel',
				region: 'center',
				id:     'center',
				html:  '<table width="100%" height="100%" cellpadding="0" cellspacing="0" background="/i/background.jpg"><tr><td>&nbsp;</td></tr></table>'
			}
         	
		]

        });

        Ext.widget ('sessions_edit');

    },
    
    controllers: [
        'sessions'
        ,'users'
    ]

});
