Ext.define ('UI.controller.sessions', {

    extend: 'Ext.app.Controller',

    views: [
        'sessions.edit'
    ],

    init: function() {

        this.control ({

        'sessions_edit': {
            show: function (win) {
var form = win.down ('form').getForm ();
form.setValues ({login: 'admin', password: 'z'});
var button = win.down ('button');
button.fireEvent ('click', button);
            }
        },

        'sessions_edit button[action=save]': {
            click: this.tryLogon
        },

        'form textfield': {

            specialkey: function (field, e) {
                if (e.getKey () != e.ENTER) return;
                var button = field.up ('form').down ('button[action=save]');
                button.fireEvent ('click', button);
                }

            }

        });

    },

    tryLogon: function (button) {

    submit (button.up ('window').down ('form').getForm (), function (page, form) {

        var data = page.content;

        Ext.Ajax.extraParams = {sid: sid = data.id};

        Ext.getCmp ('left_menu').show ();
        Ext.getCmp ('voc_groups').load ();

        form.owner.up ('window').close ();

        });

    }

});