Ext.define ('UI.controller.sessions', {

    extend: 'Ext.app.Controller',

    views: [
        'sessions.edit'
    ],

    init: function() {

        this.control ({

		'sessions_edit button[action=save]': {
			click: this.tryLogon
		},

		'textfield': { 
		
			specialkey: function (field, e) {
				if (e.getKey () == e.ENTER) this.tryLogon (field); 
        		}
        		
        	}

        });
        
    },

    tryLogon: function (button) {
    
	submit (button.up ('window').down ('form').getForm (), function (page, form) {

		var data = page.content;

		Ext.Ajax.extraParams = {sid: sid = data.id};

		var menu = Ext.getCmp ('main_menu');

		menu.removeAll ();

		for (var i = 0; i < page.menu_data.length; i ++) {

			var m = page.menu_data [i];

			menu.add ({
				text: m.label,
				scope: m,
				handler: function () {Ext.widget (this.name + '_list')}
			});

		}

		menu.add ('->', 'Пользователь: ' + data.user.label);

		menu.show ();

		form.owner.up ('window').close ();

	    });
	
    }

});