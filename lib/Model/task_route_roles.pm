label => 'Процессы: Описание процесса. Роли',

columns => {

	id_task_route => 'select(task_routes)', # Ссылка на процесс
	label         => 'string', # Роль
	description   => 'string', # Описание
	
	id_task_route_role_subordinate  => '(task_route_roles)', # Является руководителем для роли
	
	is_can_cancel_route_item => 'checkbox', # Может прерывать процесс
	is_can_edit_doc_files    => 'checkbox', # Может изменять файлы в документе

	ord                     => 'int', # (не используется) Порядковый номер
},

keys => {
	id_task_route => 'id_task_route',
},

