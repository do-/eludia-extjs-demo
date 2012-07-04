label => 'Администрирование: Пользователи. Замещения',

columns => {
	id_user      => {TYPE_NAME => 'int', ref => 'users', label => 'Замещаемый пользователь'},
	dt_from      => {TYPE_NAME => 'date', label => 'Дата начала действия замещенеия'},
	dt_to        => {TYPE_NAME => 'date', label => 'Дата окончания действия замещения'},
	id_assistant => {TYPE_NAME => 'int', ref => 'users', label => 'Заместитель'},
	comments     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 100, NULLABLE => 1, label => 'Основание'},
	is_tasks     => 'checkbox', # Заместитель имеет права замещаемого в задачах
	is_docs      => 'checkbox', # Заместитель имеет права замещаемого в документном хранилище
},

keys => {
	id_user      => 'id_user',
	id_assistant => 'id_assistant',
	dt           => 'dt_from, dt_to',
},

