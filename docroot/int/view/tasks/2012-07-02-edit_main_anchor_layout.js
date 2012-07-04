Ext.define ('UI.view.tasks.edit_main', {

	extend: 'Ext.ux.ludi.form.FormPanel',

//	layout: 'eludia',

	layout: {

		type : 'eludia'

		, tableAttrs: {

			style: {
				width: '100%'
			}

		}
	},


	autoScroll: true,

	title: 'Общие',

	bodyStyle:'padding:5px 5px 0',

	fieldDefaults: {
//		labelAlign: 'top',
		border: 0
	},

	initComponent: function () {

		var me = this;

		me.items = [
			[
				{
					// layout: "anchor",
					// border: 0,
					// items: [{
							xtype:      'displayfield',
							anchor:     '100%',

							fieldLabel: 'Номер',
							name:       'no'
					// 	}
					// ]
				},
				{
					// layout: "anchor",
					// border: 0,
					// items: [{
							xtype:      'displayfield',
							anchor:     '100%',

							fieldLabel: 'от',
							name:       'dt'
					// 	}
					// ]
				}
			],

			{
				layout: "anchor",
				border: 0,
				items: [{
					xtype:      'combovocfield',
					anchor:     '100%',

					fieldLabel: 'Важность',
					name:       'id_task_importance',
					table:      'task_importances'
				}]
			},
			{
				layout: "anchor",
				border: 0,
				items: [{
					xtype:      'combovocfield',
					anchor:     '100%',

					fieldLabel: 'Тип задачи',
					name:       'id_task_type',
					table:      'task_types',
					readOnly:   true
				}]
			}

			// {
			// 	fieldLabel: 'Номер',
			// 	name:       'no',
			// 	xtype:      'displayfield'
			// }
			// , {
			// 	xtype:      'combovocfield',
			// 	fieldLabel: 'Важность',
			// 	name:       'id_task_importance',
			// 	table:      'task_importances'

			// }
			// , {
			// 	xtype:      'combovocfield',

			// 	fieldLabel: 'Тип задачи',
			// 	name:       'id_task_type',
			// 	table:      'task_types',
			// 	readOnly:   true
			// }

		];

		this.callParent (arguments);

	},

	buttons: [
		{
			xtype: 'savebutton'
		},
		{
			xtype: 'cancelbutton'
		}
	]


});
