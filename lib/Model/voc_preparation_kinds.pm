
label => 'Номенклатура: Справочники. Виды заготовок',

columns => {
	label   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	id_log  => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}},
},

