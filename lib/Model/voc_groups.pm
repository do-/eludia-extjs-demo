
label => 'Íîìåíêëàòóğà: Ñïğàâî÷íèêè. Ãğóïïû êëàññèôèêàòîğîâ',

columns => {
	label              => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255},
	ord_src            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	ord_parent         => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	parent             => {TYPE_NAME => 'int', COLUMN_DEF => 0},
	id_voc_group_type  => {TYPE_NAME => 'int'},
	vkg_okp            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	no_1c              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	note               => {TYPE_NAME => 'text'},
	code_SKMTR         => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	id_voc_group       => {TYPE_NAME => 'int'}, # ññûëêà íà íàçâàíèå êëàññèôèêàòîğà (íà çàïèñü ñ parent = 0)
	id_log             => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}},
	id_rights_holder   => {TYPE_NAME => 'int', ref => 'voc_groups'},
},

data => [
	{id =>  1, ord_src => '', label => 'Íîìåíêëàòóğà èçäåëèé',parent => 0, id_voc_group_type => 1, id_voc_group => 1, fake => 0, uuid => '16F5AC70-F1BF-11DD-BAF3-C87E0733F9FD'},
],

keys => {
    id_voc_group_type => 'id_voc_group_type',
    parent            => 'parent',
},

