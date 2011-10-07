
label => 'Номенклатура: Справочники. Форматы чертежей',

columns => {
	label              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},               # Название
	is_multiple_pages  => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0},   # Много листов
	id_log             => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}},     # Кто и когда изменил
},

