Ext.define ('UI.view.sessions.edit', {

	extend: 'Ext.window.Window',
	closeAction: 'hide',

	title : 'Вход в систему',
	layout: 'fit',
	autoShow: true,
	closable : false,
	resizable : false,
	defaultFocus : 'login',
	width: 278,

	initComponent: function () {

		var me = this;

		this.items = [

			{
				xtype: 'form',
				bodyStyle: 'padding:5px; border:0px; _border-bottom:1px;',
				waitMsgTarget: true,

				baseParams: {
					type: 'logon',
					action: 'execute'
				},

				items: [
					{
						value: 'admin',
						xtype: 'textfield',
						name : 'login',
						itemId: 'login',
						fieldLabel: 'Логин',
						allowBlank : false,
						msgTarget : 'side'
					},
					{
						value: 'z',
						xtype: 'textfield',
						name : 'password',
						inputType: 'password',
						fieldLabel: 'Пароль',
						allowBlank : false,
						msgTarget : 'side'
					}
				],

				buttons: [

					{
						listeners: {
//							afterrender: {fn: function (b) {b.handler ()}}
						},
						text: 'Вход',
						handler: function (button) {

							submit (me.down ('form').getForm (), function (page, form) {

								Ext.Ajax.extraParams = {sid: sid = page.content.id};

								Ext.getCmp ('left_menu').show ();

					            var url  = '?type=tasks&id=193775';
								var win  = Ext.create ('UI.view.tasks.edit');
								ajax (
									url,
									function (data, form) {
										form.owner.up ('window').query ('form').forEach (function (f) {setFormData (data, f.getForm());});
										form.owner.up ('window').down('#task_files').store.proxy.extraParams.id_task = data.content.id;
										form.owner.up ('window').down('#task_files').store.load ();
									},
									win.down ('form').getForm ()
								);



								Ext.getCmp ('doc_folders').store.load ({
									callback: function () {
//										Ext.create ('UI.view.docs.list', {doc_folder: {get: function (){return 100188}}});
									}
								});

								Ext.getCmp ('voc_groups').store.load ({
									callback: function () {
//										Ext.create ('UI.view.products.list', {voc_group: {get: function (){return 3}}});
									}
								});

								me.close ();

							});

						}

					}

				]

			}

		];

		this.callParent (arguments);

	}

});