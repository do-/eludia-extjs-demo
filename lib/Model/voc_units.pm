label => 'Номенклатура: Единицы измерения (ЕИ)',

columns => {	
	code      => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'Код ЕИ'},
	label     => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'Наименование ЕИ'},
	note      => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'Комментарии'},
	id_log    => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользователь и дата последнего редактирования'},
	code_okei => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'код по ОКЕИ'},
},

static => 1,
