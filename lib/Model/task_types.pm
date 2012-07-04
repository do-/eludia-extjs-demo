label => 'Задачи: Типы задач',

columns => {
	label                              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название типа'},
	prefix                             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, __no_update => 1, label => 'Префикс номера задач'},
	order_type                         => {TYPE_NAME => 'int', label => 'Нумерация: 0 - сквозная, 1 - в пределах года'},
	is_global                          => 'checkbox', # Глобальный ли тип задачи

#{id => 0, label => 'Доступно для изменения'},
#{id => 1, label => 'Обязательно для заполнения'},
#{id => 2, label => 'Недоступно для изменения'},
#{id => 3, label => 'Не отображается'},

	field_id_voc_agent                 => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Поле контрагент: 0 - доступно для заполнения, 1 - обязательно для заполнения, 3 - не отображать'},
	field_id_task_importance           => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Поле важность: 0 - доступно для заполнения, 1 - обязательно для заполнения, 3 - не отображать'},
	field_doc_files	                   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Поле файлы: 0 - доступно для заполнения, 1 - обязательно для заполнения, 3 - не отображать'},

	is_need_confirm                    => 'checkbox', # Необходимо подтверждение<br>исполнения контролером

	is_multiple_executors              => 'checkbox', # Исполнитель: 0 - пользователь, 1 - Группа пользователей, 2 - Список пользователей, 3 - Любой сотрудник из группы

	is_system                          => 'checkbox', # Тип задач предопределен
#	is_can_inspector_change_dt_plan_to              => 'checkbox', # Разрешить контролеру изменять<br>плановый срок выполнения
	is_can_insp_chng_dt_plan_to                     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # Разрешить контролеру изменять<br>плановый срок выполнения
#	is_can_inspector_change_id_user_executor	=> 'checkbox', # Разрешить контролеру<br>менять исполнителя задачи
	is_can_insp_chng_id_user_exec   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # Разрешить контролеру<br>менять исполнителя задачи
	is_done_after_children          => 'checkbox', # Нельзя завершить задачу<br>без завершения дочерних задач
	is_used_only_in_task_routes     => 'checkbox', # Использовать только<br>для описания процессов
	is_done_after_children          => 'checkbox', # Нельзя завершить задачу без завершения дочерних задач

	is_dt_to_limits_child_dt_to     => 'checkbox', # Ограничить плановую дату дочерней задачи датой текущей задачи
	is_cant_create_children         => 'checkbox', # Запретить создавать дочерние задачи

	is_can_child_view_parents                       => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # Разрешён просмотр<br>из дочерних задач
#	is_create_task_on_second_status                 => 'checkbox', # Не подтверждать<br>начало работы
	is_crte_tsk_on_second_status                    => 'checkbox', # Не подтверждать<br>начало работы
	is_messaging_denied                             => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # Переписка по<br>задаче запрещена
	is_dont_show_reminders                          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # Не показывать поля "Напомнить.."
	is_status_changes_in_msgng                      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # Добавлять в переписку<br>изменение статуса задачи

#	is_used_by_schedules               => 'checkbox',

	duration_days                      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => 'Нормативная длительность исполнения, дней'},
	duration_hours                     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1,  label => 'Нормативная длительность исполнения, часов'},

	id_doc                             => {TYPE_NAME => 'int', label => 'Документ, к которому привязан тип задач'},

	id_log  => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}, label => 'Дата и автор изменения'},

	fake    => {TYPE_NAME => 'bigint', __no_update => 1}, # Чтобы не обновлялся fake и не восстанавливалась удаленная запись
},

static => 1,


data => [
	{
		id                       => 10_000,
		fake                     => -1,
		label                    => '',
		prefix                   => '',
		order_type               => $ORDER_TYPE_SEQUENTAL,
		is_global                => 0,
		field_id_voc_agent       => 3,
		field_id_task_importance => 3,
		field_doc_files          => 3,
		is_need_confirm          => 1,
		is_multiple_executors    => 0,
		is_system                => 1,

		is_can_insp_chng_dt_plan_to   => 0,
		is_can_insp_chng_id_user_exec => 0,
		is_done_after_children        => 0,
		is_used_only_in_task_routes   => 0,
		is_can_child_view_parents     => 0,
		is_crte_tsk_on_second_status  => 0,
		is_messaging_denied           => 0,
		is_dont_show_reminders        => 0,
		duration_days                 => 0,
		duration_hours                => 0,
		($preconf -> {peer_name} ? (uuid => '12BDF92C-2A17-11E0-98DC-5B2248ADA781') : ()),
	},
	{
		id                       => 10_001,
		fake                     => 0,
		label                    => 'Личный календарь',
		prefix                   => '',
		order_type               => $ORDER_TYPE_SEQUENTAL,
		is_global                => 0,
		field_id_voc_agent       => 3,
		field_id_task_importance => 0,
		field_doc_files          => 0,
		is_need_confirm          => 0,
		is_multiple_executors    => 2,
		is_system                => 1,

		is_can_insp_chng_dt_plan_to   => 0,
		is_can_insp_chng_id_user_exec => 0,
		is_done_after_children        => 0,
		is_used_only_in_task_routes   => 0,
		is_can_child_view_parents     => 0,
		is_crte_tsk_on_second_status  => 0,
		is_messaging_denied           => 0,
		is_dont_show_reminders        => 0,
#		is_used_by_schedules          => 1,
		duration_days                 => 0,
		duration_hours                => 0,
		($preconf -> {peer_name} ? (uuid => '81E647BE-3B5A-11E1-A532-B9A5570702AB') : ()),
	},

	{
		id => 100_000,
		fake => -1,
		label => '',
		($preconf -> {peer_name} ? (uuid => '12C0B46E-2A17-11E0-98DC-5B2248ADA781') : ()),
	},
],

