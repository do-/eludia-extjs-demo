label => 'Процессы: Описание процесса. Шаблон задачи. Результаты исполнения задачи',

columns => {

	id_task_route_task              => 'select(task_route_tasks)', # Задача (ссылка на шаблон задачи)

	no                              => 'int',      # Порядковый номер
	label                           => 'string',   # Название результата
	is_need_description             => 'checkbox', # Комментарий обязателен
	is_not_require_mandatory_flds   => 'checkbox', # Не требовать заполнения полей документа
	is_default_result               => 'checkbox', # Действующий по умолчанию результат
},

keys => {
	id_task_route_task	=> 'id_task_route_task',
},

