function store (options, modelOptions) {

    var modelName = options.type;

    if (modelOptions && !Ext.ModelManager.isRegistered (modelName)) {
        modelOptions.extend = 'Ext.data.Model';
        Ext.define (modelName, modelOptions);
    }

    return new Ext.data.Store ({
        model: modelName,
        remoteSort : true,
        proxy: {
        type: 'ajax',
        url: '/handler',
        extraParams: options,
        reader: {
            type: 'json',
            useSimpleAccessors: false,
            root: 'content.' + options.type,
            totalProperty: 'content.cnt'
        }
        }
    });

}

function noOff (a) {

    var b = [];

    for (var i = 0; i < a.length; i ++) {

        var x = a [i];
        if (Ext.isEmpty (x)) continue;
        if (x.off) continue;
        b.push (x);

    }

    return b;

}

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

    var win = button.up ('window');
    
    var fp = win.down ('form');
    
    if (fp && fp.getForm ().isDirty ()) {

        Ext.Msg.show ({
             title:'Предупреждение',
             msg: 'Значения некоторых полей изменены. Вы действительно хотите закрыть форму без сохранения данных?',
             buttons: Ext.Msg.YESNO,
             scope: win,
             fn: function (choice) {if (choice == 'yes') win.close ()}
        });

    }
    else {

        win.close ();

    }

}

function storeOf (grid) {

    var className = Ext.getClassName (grid);

    var r =
        className == 'Ext.tree.View' ? grid.getTreeStore () :
        className == 'Ext.grid.View' ? grid.getStore () :
        grid.store;

    return r;

}

function refreshParentGridAndCloseThisWindow (page, form) {

    var win = form.owner.up ('window');

    var store = storeOf (win.grid);

    if (Ext.getClassName (win.grid) == 'Ext.tree.View') {

        var id = page.content.parent;

        var node = store.getNodeById (id);

        store.load ({node: node});

    }
    else {

        store.load ();

    }

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

function standardGetRowClass (record, rowIndex, rp, ds) {

    return record.get ('fake') == -1 ? 'deleted-record' : '';

}

function loadFirstGrid (win) {

    win.down ('gridpanel').store.load ();

}

function changeSearchFieldValue (field, value) {

    if (field.name == 'inputItem') return;

    var tb = field.up ('window').down ('pagingtoolbar');
    
    if (Ext.isBoolean (value)) value = value ? 1 : 0;

    tb.store.proxy.extraParams [field.name] = value;

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

function bringThisWindowToFront () {
    Ext.WindowManager.bringToFront (this)
}

function showWindowListMenu (event) {

        event.stopEvent ();
        
        var items = [];
        var yet   = {};
        
        Ext.WindowManager.each (function (i) {
            
            if (i.isHidden ()) return;
            if (!i.isVisible ()) return;
            if (i.title == null) return;
            title = new String (i.title);
            if (!title.match (/\S/)) return;
            if (yet [title]) return;
                        
            items.push ({
                text: title,
                handler: bringThisWindowToFront,
                scope: i
            });
            
            yet [title] = true;
            
        });
        
        new Ext.menu.Menu ({items: items}).showAt (event.getXY ());

}

function showMenuOffTableBody (grid, event) {

        event.stopEvent ();

        createPopupMenu (grid).showAt (event.xy);

}

function createPopupMenu (grid) {

    var selected = grid.getSelectionModel ().selected;
    var cnt = {'0': 0, '-1': 0};
    for (var i = 0; i < selected.getCount (); i ++) cnt ['' + selected.getAt (i).get ('fake')] ++;

    return new Ext.menu.Menu ({
        floating: true,
        items: noOff (grid.getPopupMenuItems (cnt))
    });

}

function typeBehindTheGrid (grid) {

    return storeOf (grid).getProxy ().extraParams.type;

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

function clickButton (b) { b.handler (b) }

function def (o, d) {

    for (i in d) {

        if (o [i]) {

            if (Ext.isObject (d [i]) && !Ext.isArray (d [i])) def (o [i], d [i])

        }
        else {

            if (Ext.isEmpty (o [i])) o [i] = d [i];

        }

    }

    return o;

}

Ext.require ('Ext.app.Application');

Ext.Loader.setPath ('Ext.ux.daom', '/int/lib/ux/daom');
Ext.require ('Ext.ux.daom.LastModifiedFieldSet');

Ext.Loader.setPath ('Ext.ux.ludi', '/ludi');
Ext.require ('Ext.ux.ludi.PagedCheckedGridPanel');
Ext.require ('Ext.ux.ludi.SearchSelectField');
Ext.require ('Ext.ux.ludi.SearchSelectFieldFake');
Ext.require ('Ext.ux.ludi.SearchTextField');
Ext.require ('Ext.ux.ludi.SearchCheckboxField');
Ext.require ('Ext.ux.ludi.StaticVocField');
Ext.require ('Ext.ux.ludi.DynamicVocField');
Ext.require ('Ext.ux.ludi.DisplayDateTimeField');
Ext.require ('Ext.ux.ludi.CancelButton');
Ext.require ('Ext.ux.ludi.SaveButton');
Ext.require ('Ext.ux.ludi.FormWindow');
Ext.require ('Ext.ux.ludi.BooleanBoxField');

Ext.define ('voc', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id',    type: 'int'   },
        {name: 'label', type: 'string'},
    ]
});

Ext.onReady (function () {

    Ext.application ({

        name: 'UI',
        appFolder: 'int',

        launch: function () {

            document.body.innerHTML = '';

            Ext.create ('UI.view.main.list');
            Ext.create ('UI.view.sessions.edit');

        }

    });

});