label => 'Процессы: Описание процесса. Шаблоны задач',

columns => {

	id_task_route    => {TYPE_NAME => 'int', label => 'Ссылка на процесс'},

	no               => {TYPE_NAME => 'int', label => 'Номер задачи'},
	id_task_type     => {TYPE_NAME => 'int', label => 'Тип задачи'},

	label            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Текст'},
	description      => {TYPE_NAME => 'text', label => 'Примечание'},

	is_executor_is_role             => {TYPE_NAME => 'int', label => 'Исполняет задачу: 0 - исполнитель, 1 - роль, 2 - группа пользователей'},
	id_user_executor                => {TYPE_NAME => 'int', label => 'Пользователь - исполнитель задачи'},
	
	id_task_route_role_initiator => 'select(task_route_roles)', # Роль - инициатор задачи (если не указана, берется из описания процесса)
	
	id_task_route_role_executor     => {TYPE_NAME => 'int', ref => 'task_route_roles', label => 'Роль - исполнитель задачи'},
	id_workgroup_executor           => {TYPE_NAME => 'int', label => 'Рабочая группа - исполнитель задачи'},
	is_execute_in_consec_order      => {TYPE_NAME => 'tinyint', 
		NULLABLE   => 0, 
		COLUMN_DEF => 0, 
		label      => 'Тип согласования: 0 - одновременное согласование, 1 - последовательное согласование'
	},

	duration_days           => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0, label => 'Длительность, дней'},
	duration_hours          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Длительность, часов'},
	
	is_inspector_is_role            => {TYPE_NAME => 'int', label => 'Контролер задачи: 0 - пользователь, 1 - роль'},
	id_task_route_role_inspector    => {TYPE_NAME => 'int', ref => 'task_route_roles', label => 'Роль - контролер задачи'},
	id_workgroup_inspector          => {TYPE_NAME => 'int', label => 'Рабочая группа контролера задачи'},
	id_user_inspector               => {TYPE_NAME => 'int', label => 'Пользователь - контролер задачи'},

	is_used_in_agreement_sheet      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Участвует в формировании листа согласования'},
	
# Изначально было "Разрешить инициатору изменять параметры задачи" да/нет
	is_initiator_can_update_task    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOT},
Редактирование полей задачи: 
	0 - запретить инициатору изменять параметры задачи (исполнитель и контролер будет иметь возможность редактирования, в пределах их прав).
	1 - разрешить изменять параметры задачи (инициатору, исполнителю и контролеру, в пределах их прав)
	2 - запретить изменять параметры задач (никто не сможет редактировать)
EOT

	is_cant_create_children         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Запретить создавать дочерние задачи'},
	is_done_after_children          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Нельзя завершить задачу без завершения дочерних задач'},
	is_dt_to_limits_child_dt_to     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Ограничить плановую дату дочерней задачи датой текущей задачи'},
	
	is_can_inspector_cancel_task    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Контролер имеет право отменить выполнение задачи'},

	is_grp_tsks_done_before_next    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Вся группа задач должна быть завершена до инициации следующей задачи'},
	is_cncl_tsks_after_fst_done     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Завершать невыполненные задачи в группе пользователей'},
	is_prev_tsks_done_bfre_this     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'До инициации ожидать завершения всех предыдущих по процессу задач'},
	is_cncl_othr_prev_tsks          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'При завершении одной задачи из предыдущих веток – задачи других предыдущих по процессу веток отменяются'},

	is_chng_doc_agmt_items_right    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Разрешить добавлять согласующих лиц'},
	is_print_doc_agmt_allowed       => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Разрешить печатать Лист визирования/замечаний'},

	is_crte_tsk_on_second_status    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Не подтверждать начало работы'},

	# координаты и размеры в редакторе задач
	position_left   => {TYPE_NAME => 'int', label => 'Позиция фигуры шаблона в редакторе процессов: x'},
	position_top    => {TYPE_NAME => 'int', label => 'Позиция фигуры шаблона в редакторе процессов: y'},
	position_height => {TYPE_NAME => 'int', label => 'Позиция фигуры шаблона в редакторе процессов: высота'},
	position_width  => {TYPE_NAME => 'int', label => 'Позиция фигуры шаблона в редакторе процессов: ширина'},
},

keys => {
	id_task_route   => 'id_task_route',
},

