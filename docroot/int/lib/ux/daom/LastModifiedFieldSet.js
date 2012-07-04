Ext.define ('Ext.ux.daom.LastModifiedFieldSet', {

	extend: 'Ext.form.FieldSet',
	alias: 'widget.lastmodifiedfieldset',
	layout: {
		type:   'table',
		columns: 2
	},

	initComponent: function () {

		var me = this;

		def (me,
			{
				autoRender: true,
				title: 'Последнее изменение',
				weight: 1,
				items: [
					{
						xtype: 'displaydatetimefield',
						name: 'log.dt',
						fieldLabel: 'Дата',
						width: 250
					},
					{
						xtype: 'displayfield',
						name: 'user.label',
						fieldLabel: 'Автор',
						width: 500
					}
				]
			}
		);

		me.callParent (arguments);

	}

});