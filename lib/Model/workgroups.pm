label => 'Администрирование: Группы пользователей',

columns => {

	id_workgroup_folder => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 1, label => 'Каталог'},
	
	label            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название'},
	comments         => {TYPE_NAME => 'text', label => 'Примечание'},
	is_have_homepage => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Формирует страницу в портале (не используется)'},
	is_system        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Предопределена'},
	is_global        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Действие группы: 0 - локальная, 1 - глобальная, 2 - пользователи в группу добавляются только в головной базе'},
	
	voc_store_ids    => {TYPE_NAME => 'text', label => 'Доступ к складам'},
	
	id_workgroup     => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0}, # Ссылка на группу родителя для виртуальной группы
	id_type          => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0}, # Ссылка на определяющий тип для виртуальной группы

	id_log           => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}}, # Пользователь и дата последнего действия

},

keys => {
	id_workgroup	=> 'id_workgroup',
},

data => [
	{id => 1, label => 'Все пользователи', fake => 0, is_system => 1, is_global => 1, uuid => 'DAC2B880-E866-11DD-BDF8-BA67C8E92ED2'},
],

