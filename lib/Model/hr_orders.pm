label => 'Администрирование: Пользователи. Перемещения',

columns => {

	id_user        => {TYPE_NAME => 'int', label => 'Ссылка на пользователя'},
	id_dep         => {TYPE_NAME => 'int', label => 'Ссылка на подразделениее'},
	id_top_dep     => {TYPE_NAME => 'int', ref => 'deps', label => 'Ссылка на предприятие'},
	dt             => {TYPE_NAME => 'date', label => 'Дата приема на должность'},
	dt_to          => {TYPE_NAME => 'date', label => 'Дата увольнения с должности'},

	id_voc_post    => {TYPE_NAME => 'int', label => 'Должность'},
	
# мигрировало в id_voc_post но все еще используется
# если NULL, то запись об увольнении, иначе о переводе/приеме на работу
	position_label => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название должности'},
	
	is_boss        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Начальник'},
	base           => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Основание (приказ, etc.)'},

	dt_id_id_dep   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, COLUMN_DEF => '1970-01-01', label => 'Вспомогательное поля для осуществления среза штатного расписания на дату'},

	id_log         => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользователь и дата изменнеия записи'},

},

keys => {
	id_user => 'id_user,dt',
	dt	=> 'dt',
	dt_id_id_dep => 'id_user,dt_id_id_dep',
	id_dep       => 'id_dep',
},

data => [
#	{id => 1, fake => 0, id_user => 1, id_dep => 1, id_top_dep => 1, dt => '2008-01-01', position_label => 'Админ', is_boss => 0, dt_id_id_dep => '2008-01-01 1_1'},
],

