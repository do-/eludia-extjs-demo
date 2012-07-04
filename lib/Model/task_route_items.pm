label => 'Процессы: Экземпляры процессов',

columns => {

	id_task_route_item_status => 'select(task_route_item_status)', # Статус экземпляра процесса

	id_task_route   => 'select(task_routes)', # Ссылка на шаблон процесса
	
	id_doc_type     => 'select(doc_types)', # Тип документа, по которому запущен процесс
	id_type         => {TYPE_NAME => 'int', label => 'Ссылка на документ, к которому призязан экземпляр процесса'},
	
	id_user         => 'select(users)', # Инициатор
	no              => 'int', # Номер
	
	dt_start        => {TYPE_NAME => 'datetime', label => 'Дата и время запуска'},
	dt_finish       => {TYPE_NAME => 'datetime', label => 'Дата и время завершения'},

	id_task_route_agreement_list  => 'select(task_route_agreement_lists)', # Группа согласующих лиц
	id_voc_contract_task_route    => 'select(voc_contract_task_routes)',   # Процесс согласования договора (специфично для Vitek)

},

keys => {
	id_task_route   => 'id_task_route',
	no      => 'no',
},

