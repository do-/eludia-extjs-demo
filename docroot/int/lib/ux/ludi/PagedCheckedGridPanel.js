Ext.define ('Ext.ux.ludi.PagedCheckedGridPanel', {

    extend: 'Ext.grid.Panel',
    alias : 'widget.pagedcheckedgridpanel',

    initComponent: function () {

        var columns = this.columns = noOff (this.columns);

        var type = this.parameters.type;
        var editFormClassName = 'UI.view.' + type + '.edit';
        Ext.require (editFormClassName);

        if (!Ext.ModelManager.isRegistered (type)) {
            var fields  = ['id', 'fake'];
            for (var i = 0; i < columns.length; i ++) fields.push (columns [i].dataIndex);
            Ext.define (type, {fields: fields, extend: 'Ext.data.Model'});
        }

        this.store = store (this.parameters);

        if (!this.viewConfig) this.viewConfig = {
            forceFit: true,
            getRowClass: standardGetRowClass,
            multiSelect: true
        };

        if (!this.selModel) this.selModel = Ext.create('Ext.selection.CheckboxModel', {
            allowDeselect: true,
            checkOnly: true,
            mode: 'MULTI'
        });
        
        var search = [
            {
                icon: '/ext/examples/desktop/images/gears.gif',
                action: 'edit',
                listeners: {click: {fn: showMenuOnToolbarButton}}
            },
            {
                xtype: 'searchtextfield'
            },
        ];
        
        if (this.search) search = search.concat (this.search);

        search.push ([
            {
                xtype: 'searchselectfieldfake'
            }
        ]);

        this.dockedItems = [{

            xtype: 'pagingtoolbar',
            store : this.store,
            dock: 'bottom',
            displayInfo: true,
            items: search
        }];

        if (!this.listeners) this.listeners = {};

        var me = this;

        me.showMenu = function (event) {
            event.stopEvent ();
            createPopupMenu (me).showAt (event.xy);
        };

        me.doBatch = function (action) {

            var href     = '?type=' + type + '&action=' + action;
            var selected = me.getSelectionModel ().selected;
            var cnt      = selected.getCount ();

            for (var i = 0; i < cnt; i ++) href += '&_' + type + '_' + selected.getAt (i).get ('id') + '=1';

            ajax (href, me.doLoad);

        };

        me.doLoad = function () {me.store.load ()};

        me.confirmBatch = function (action, label) {

            Ext.Msg.show ({
                 title:'Предупреждение',
                 msg: 'Вы действительно хотите ' + label + ' ' + russianNRecords (me.getSelectionModel ().selected.getCount ()) + '?',
                 buttons: Ext.Msg.YESNO,
                 scope: me,
                 fn: function (choice) {if (choice == 'yes') me.doBatch (action)}
            });

        };

        me.openEditForm = function (params) {
            var url  = '?type=' + type + '&' + params;
            var win  = Ext.create (editFormClassName);
            win.grid = me;
            ajax (url, me.setFormData, win.down ('form').getForm ());
        };

        if (!me.setFormData) me.setFormData = function (data, form) {form.setValues (data.content)};

        def (this.listeners, {
            afterlayout:          {fn: me.doLoad},
            containercontextmenu: {fn: function (grid, event)                               {me.showMenu (event)}},
            itemcontextmenu:      {fn: function (grid, record, item, index, event, options) {me.showMenu (event)}},
            itemdblclick:         {fn: function (grid, record)                              {me.openEditForm ('id=' + record.get ('id'))}}
        });

        if (!this.getPopupMenuItems) this.getPopupMenuItems = function (cnt) {

            return [

                {
                    text    : 'Создать...',
                    handler : function () {me.openEditForm ('action=create')}
                }

                , {
                    xtype   : 'menuseparator',
                    off     : (cnt [0] == 0 && cnt [-1] == 0)
                }

                , {
                    text    : 'Удалить ' + russianNRecords (cnt [0]),
                    handler : function () {me.confirmBatch ('kill', 'удалить')},
                    off     : (cnt [0] == 0 || cnt [-1] > 0)
                }

                , {
                    text    : 'Слить ' + russianNRecords (cnt [0]),
                    handler : function () {me.confirmBatch ('merge', 'слить')},
                    off     : (cnt [0] <  2 || cnt [-1] > 0)
                }

                , {
                    text    : 'Восстановить ' + russianNRecords (cnt [-1]),
                    handler : function () {me.doBatch ('unkill')},
                    off     : (cnt [0] > 0 || cnt [-1] == 0)
                }

            ];

        }

        this.callParent (arguments);

    }

});