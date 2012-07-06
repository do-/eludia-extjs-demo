label => 'Процессы: Описание процесса. Связи между завершением и порождением задач',

columns => {
	id_task_route_task_src    => 'select(task_route_tasks)', # Ссылка на шаблон завершенной задачи/задач
	id_task_route_task_result => 'select(task_route_task_results)', # Ссылка на результат
	is_results_is_different   => 'checkbox', # 0 - не все задачи завершились с id_task_route_task_result, 1 - все задачи пакета завершились с id_task_route_task_result
	id_task_route_task_dst    => 'select(task_route_tasks)', # Ссылка на шаблон порождаемой задачи/задач

	# для редактора схемы процесса
	input   => 'string', # endpoint, в которую входит соедеинеие
	output  => 'string',# endpoint, из которой выходит соедеинеие
},

keys => {
	id_task_route_task_src	=> 'id_task_route_task_src, id_task_route_task_result',
	id_task_route_task_dst	=> 'id_task_route_task_dst, id_task_route_task_result',
},

