label	=> 'Документы: Файлы',

columns => {
	id_doc          => {TYPE_NAME => 'int', label => 'Ссылка на документ'},

	parent          => '(doc_files)', # Ссылка на родительскую версию файла

	version         => 'string', # Версия
	label           => 'string', # Наименование

	is_actual       => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, label => 'Актуальный'},
	notes           => {TYPE_NAME => 'varchar', COLUMN_SIZE => 4000, label => 'Примечание'},

	id_log          => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользователь и дата регистрации'},

	content_index   => {TYPE_NAME => 'longtext', label => 'Cодержимое файла для полнотекстового поиска'},

	file_name       => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => 'Имя файла'},
	file_type       => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => 'Тип файла'},
	file_path       => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => 'Путь к файлу'},
	file_size       => {TYPE_NAME    => 'int', label => 'Размер файла'},
},

keys => {
	id_doc => 'id_doc',
},

