label	=> 'Документы: Документы',

columns => {

	id_doc_folder     => {TYPE_NAME => 'int', label => 'Каталог'},

	id_doc_type       => {TYPE_NAME => 'int', label => 'Тип документа'},
	id_doc_kind       => {TYPE_NAME => 'int', label => 'Вид документа'},
	id_task_route     => {TYPE_NAME => 'int', label => 'Ассоциированный процесс'},

	prefix            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Префикс номера'},
	no                => 'string', # Номер
	
	no_ext            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Входящий номер'},
	dt                => {TYPE_NAME => 'date', label => 'Дата документа'},
	dt_ext            => {TYPE_NAME => 'date', label => 'Дата создания входящего документа'},
	dt_register       => {TYPE_NAME => 'datetime', label => 'Дата регистрации документа'},
	dt_process_finish => {TYPE_NAME => 'datetime', label => 'Дата завершения процесса по документу'},

	label             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название'},
	code              => 'string', # Уникальный код в пределах пользовательского справочника (нужен при экспорте)
	source_name       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Имя файла (при импорте с FTP)'},
	description       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Описание'},
	id_doc_status     => {TYPE_NAME => 'int', label => 'Статус'},
	id_user	          => {TYPE_NAME => 'int', label => 'Владелец документа'},

	id_log            => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользователь и дата последнего редактирования'},

	id_workgroup      => {TYPE_NAME => 'int', label => 'Рабочая группа'},

	id_task            => {TYPE_NAME => 'int', label => 'Текущая задача по документу в рамках процесса'},
	id_task_route_item => {TYPE_NAME => 'int', label => 'Запущенный процесс по документу'},
	
	label_href         => {TYPE_NAME => 'text', label => 'Текст ссылки на документ'},
	
	id_merged_to       => 'select(docs)',             # запись пользовательского справочника, с которой слили данную

	base_label         => 'string',                   # Наименование учётной системы, откуда получен документ
	acc_code           => 'string',                   # Код контрагента в учётной системе, откуда получен документ
},

keys => {
	id_doc_folder	=> 'id_doc_folder',
	id_doc_type	=> 'id_doc_type',
	dt		=> 'dt, id_doc_type, prefix',
},
