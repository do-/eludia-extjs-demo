label => 'Задачи: Задачи',

columns => {

# Родительская задача
	parent                      => {TYPE_NAME => 'int', ref => 'tasks', label => 'Родительская задача'},
# Предыдущая задача в процессе
	id_preceding_task           => {TYPE_NAME => 'int', ref => 'tasks', label => 'Предыдущая задача в процессе'},

# Для процессов - уникальные значения в пределах экземпляров процессов
	group_task_no               => {TYPE_NAME => 'int', label => 'Идентификатор группы задач, запущенных одновременно (исполнители - группа пользователей или список пользователей)'},


	id_task_route_item          => {TYPE_NAME => 'int', label => 'Экземпляр процесса (для задач по процессам)'},
# Обычные задачи, являющиеся потомками задач по процессу (если прописать для них id_task_route_item, то произойдет попытка продолжить процесс)
	is_parent_is_task_route     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Потомок ли процессной задачи'},
	id_task_route_task          => {TYPE_NAME => 'int', label => 'Шаблон задачи (для задач по процессам)'},


# Требование подтверждения создания (заполнение параметров задачи)
	is_need_create_confirm      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Требуется ли подтверждения при создании'},

	id_task_type                => {TYPE_NAME => 'int', label => 'Тип'},
	id_task_status              => {TYPE_NAME => 'int', label => 'Статус'},

	id_user_initiator           => {TYPE_NAME => 'int', ref => 'users', label => 'Инициатор'},

	prefix                      => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Префикс номера'},
	no                          => {TYPE_NAME => 'int', label => 'Номер'},
	dt                          => {TYPE_NAME => 'datetime', label => 'Дата создания'},

	label                       => {TYPE_NAME => 'text', label => 'Текст задачи'},

	id_doc_type                 => {TYPE_NAME => 'int', label => 'Тип документа, к которому призязана задача'},
	id_type                     => {TYPE_NAME => 'int', label => 'Ссылка на документ, к которому призязана задача'},

# Имя приложения, в котором создалась задача, необходимо для отображения документа-основания в родительском приложении
	peer_name                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Имя приложения, в котором создана задача'},

# Для отображения в другом приложении
	uuid_type                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 36, label => 'uuid документа'},
	base_doc_label              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название документа'},

	id_voc_agent                => {TYPE_NAME => 'int', label => 'Контрагент'},
	id_task_importance          => {TYPE_NAME => 'int', label => 'Важность'},

	id_workgroup_executor       => {TYPE_NAME => 'int', ref	=> 'workgroups', label => 'Группа исполнителей'},
	id_workgroup_inspector      => {TYPE_NAME => 'int', ref	=> 'workgroups', label => 'Контролер'},

	id_user_executor            => {TYPE_NAME => 'int', ref	=> 'users', label => 'Исполнитель'},

# Перечень исполнителей при создании задачи, где исполнители - перечень сотрудников.
# После подтверждения создания создаются отдельные задачи, где исполнитель - в id_user_executor
	user_executor_ids           => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Перечень исполнителей'},

	id_user_inspector           => {TYPE_NAME => 'int', ref => 'users', label => 'Контролер'},

	dt_from_plan                => {TYPE_NAME => 'datetime', label => 'Дата начала плановая'},
	dt_to_plan                  => {TYPE_NAME => 'datetime', label => 'Дата завершения плановая'},

	dt_remind_executor          => {TYPE_NAME => 'date', label => 'Напомнить исполнителю'},
	dt_remind_inspector         => {TYPE_NAME => 'date', label => 'Напомнить контролеру'},

	dt_from_fact                => {TYPE_NAME => 'datetime', label => 'Дата начала фактическая'},
	dt_to_fact                  => {TYPE_NAME => 'datetime', label => 'Дата завершения фактическая'},

	id_task_type_result         => {TYPE_NAME => 'int', label => 'Результат'},
	id_task_route_task_result   => {TYPE_NAME => 'int', label => 'Результат из шаблона процесса (для задач по процессам)'},

	dt_accepted                 => {TYPE_NAME => 'datetime', label => 'Дата подтвержения'},

	result                      => {TYPE_NAME => 'text', label => 'Результат подробно'},
	abort_reason                => {TYPE_NAME => 'text', label => 'Причина отмены'},
	rework_reason               => {TYPE_NAME => 'text', label => 'Причина возврата на доработку'},

},

keys => {
	dt                  => 'dt',
	id_user_executor    => 'id_user_executor',
	id_user_inspector   => 'id_user_inspector',
	id_task_route_item  => 'id_task_route_item, id_task_route_task',
	group_task_no       => 'group_task_no',
	id_type             => 'id_doc_type, id_type',
	parent              => 'parent',
},
