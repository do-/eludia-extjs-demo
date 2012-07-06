label => 'Процессы: Описание процесса. Щаблон задачи. Список исполнителей задачи',

columns => {
	id_user_executor	=> 'select(users)', # Ссылка на исполнителя задачи
	id_task_route_task	=> 'select(task_route_tasks)', # Ссылка на шаблон задачи
},

keys => {
	id_task_route_task => 'id_task_route_task',
},


