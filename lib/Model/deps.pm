label => "Администрирование: Оргструктура. Узлы оргструктуры",

columns => {

	parent        => {TYPE_NAME => 'int', ref => 'deps', label => 'Ссылка на родительский элемент структуры',},
	code          => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Номер подразделения',},
	label         => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Наименование', __no_update => 1},
	short_label   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Краткое наименование'},
	id_dep_status => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, label => 'Тип элемента структуры: 0 - подразделение, 1 - компания, 2 - филиал, 3 - корень дерева'},
	id_top_dep    => {TYPE_NAME => 'int', ref => 'deps', label => 'Для подразделений ссылка на филиал или компанию'},							#

	note          => {TYPE_NAME => 'text', label => 'Комментарии',},

	peer_name     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Наименование системы данной компании'},
	
},

keys => {
	parent	=> 'parent',
},

data => [
#	{id => 1, fake => 0, parent => 0, id_dep_status => 3, id_top_dep => 1, uuid => '87549CF2-E151-11DD-89C4-C8EE85590461'},
],

