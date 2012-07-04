label => 'Процессы: Описание процесса. Права доступа к процессам',

columns => {

	id_task_route   => 'select(task_routes)', # Ссылка на процесс
	id_workgroup    => 'select(workgroups)', # Ссылка на рабочую группу
	is_admin        => 'checkbox', # Рабочая группа  - администратор процесса
	is_create       => 'checkbox', # Рабочая группа - инициатор процесса

},

keys => {
	id_task_route => 'id_task_route, id_workgroup',
},

