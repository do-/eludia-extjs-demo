Ext.define ('UI.view.calendar.list', {

	extend: 'Ext.tree.Panel',

	title: 'Календарь',
	rootVisible: false,
	store: Ext.create ('Ext.data.TreeStore', {
		root: {
			expanded: true,
			children: [
				{ text: "Календарь", id: 'calendar',           leaf: true}
			]
		}
	}),

	listeners: {
		itemdblclick: {
			fn: function (me, record, item, index, event, options) {

					window.open (
						'/i/myCalendar/web-app/index.html?sid=' + Ext.Ajax.extraParams.sid,
						'fake_' + Math.round(Math.random() * 1000) + '_iframe'
					);
			}
		}
	}

});