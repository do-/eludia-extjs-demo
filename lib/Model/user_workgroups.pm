label => 'Администрирование: Привязка пользователей к рабочим группам',

columns => {
	id_user       => {TYPE_NAME => 'int', label => 'Ссылка на пользователя'},
	id_workgroup  => {TYPE_NAME => 'int', label => 'Ссылка на рабочую группу'},
	is_admin      => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, NULLABLE => 0, label => 'Пользователь является администратором группы'},
	
	id_log        => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}}, # Пользователь и дата создания
},

keys => {
	id_user      => 'id_user',
	id_workgroup => 'id_workgroup',
},

