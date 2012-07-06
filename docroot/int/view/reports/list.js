Ext.define ('UI.view.reports.list', {

	extend: 'Ext.tree.Panel',

	title: 'Отчёты',
	rootVisible: false,
	store: Ext.create ('Ext.data.TreeStore', {
		root: {
			expanded: true,
			children: [
				{ text: "Выполнение проектов", id: 'reports.projects_execution',           leaf: true},
				{ text: "Выполнение задач",    id: 'http://77.240.157.42:8080/jasperserver-pro/flow.html?_flowId=viewReportFlow&reportUnit=/reports/projects_tasks_report&j_username=jasperadmin&j_password=jasperadmin',               leaf: true},
				{ text: "Выполнение задач по проектам (комплекс)",    id: 'http://77.240.157.42:8080/jasperserver-pro/flow.html?_flowId=adhocFlow&_eventId=initForExistingReport&_flowExecutionKey=e67s1&viewReport=&j_username=jasperadmin&j_password=jasperadmin',               leaf: true},
				{ text: "Задачи по проектам (дни задержки по изделиям)",  id: 'http://77.240.157.42:8080/jasperserver-pro/flow.html?_flowId=viewReportFlow&reportUnit=%2Freports%2F%D0%97%D0%B0%D0%B4%D0%B0%D1%87%D0%B8_%D0%BF%D0%BE_%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B0%D0%BC__%D0%B4%D0%BD%D0%B8_%D0%B7%D0%B0%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D0%B8_%D0%BF%D0%BE_%D0%B8%D0%B7%D0%B4%D0%B5%D0%BB%D0%B8%D1%8F%D0%BC_&j_username=jasperadmin&j_password=jasperadmin',               leaf: true},
				{ text: "Задачи по проектам (дни задержки по исполнителям)",  id: 'http://77.240.157.42:8080/jasperserver-pro/flow.html?_flowId=viewReportFlow&reportUnit=%2Freports%2F%D0%92%D1%8B%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5_%D0%B7%D0%B0%D0%B4%D0%B0%D1%87_%D0%BF%D0%BE_%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B0%D0%BC__%D0%B4%D0%BD%D0%B8_%D0%B7%D0%B0%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D0%B8_&j_username=jasperadmin&j_password=jasperadmin',               leaf: true}
			]
		}
	}),

	listeners: {
		itemdblclick: {
			fn: function (me, record, item, index, event, options) {
//debugger;
				if (index > 0) {
					window.open (record.internalId, '_blank');
				} else {
					Ext.create ('UI.view.' + record.get ('id') + '.list', {});
				}
			}
		}
	}

});