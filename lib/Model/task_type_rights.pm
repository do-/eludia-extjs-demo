label => 'Задачи: Тип задачи. Права доступа',

columns => {
	id_task_type  => {TYPE_NAME => 'int', __no_update => 1, label => 'Тип задачи'},
	id_workgroup  => {TYPE_NAME => 'int', __no_update => 1, label => 'Группа'},
	
	is_admin      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => 'Группа - администратор типа задач'},
	is_create     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => 'Пользователи группы могут создавать задачи типа'},
	is_execute    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => 'Пользователи группы могут быть исполнителями задач типа'},
	is_inspector  => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => 'Пользователи группы могут быть контролерами задач типа'},
	is_can_view   => 'checkbox',
	
	id_log        => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}, label => 'Пользователь и дата последнего редактирования'},

	fake          => {TYPE_NAME => 'bigint', __no_update => 1}, # Чтобы не обновлялся fake и не восстанавливалась удаленная запись
},

keys => {
	id_task_type => 'id_task_type',
},

