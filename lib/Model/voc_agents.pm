label => 'Контрагенты: Контрагенты',

columns => {
	id_voc_agents_tree      => {TYPE_NAME => 'int'},
	id_voc_olf              => {TYPE_NAME => 'int', NULLABLE => 0},
	label                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, NULLABLE => 0},
	label_full              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, NULLABLE => 0},
	is_jur_pers             => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 1},
	is_resident             => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0},
	inn                     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 20},
	kpp                     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 9},
	okpo                    => {TYPE_NAME => 'varchar', COLUMN_SIZE => 20},
	no_pension_doc          => {TYPE_NAME => 'varchar', COLUMN_SIZE => 11},
	ser_pass                => {TYPE_NAME => 'varchar', COLUMN_SIZE => 4},

	no_pass                 => {TYPE_NAME => 'varchar', COLUMN_SIZE => 6},
	dt_pass                 => {TYPE_NAME => 'date'},
	code_pass               => {TYPE_NAME => 'varchar', COLUMN_SIZE => 6},
	place_pass              => {TYPE_NAME => 'text'},

#	id_dep                  => {TYPE_NAME => 'int'},
	is_internal             => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0},
	state                   => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0},  # 0 => Не проверено, 1 => Проверить, 2 => Проверено, -1 => Создано (только в локальной базе)
	id_voc_agent_type       => {TYPE_NAME => 'int'},
#	railways_state          => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0},
	address                 => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	address_jur             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	phone                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
#	id_voc_agent_activity   => {TYPE_NAME => 'int'},

	id_inspector            => {TYPE_NAME => 'int', ref => 'users'},
	dt_inspected            => {TYPE_NAME => 'datetime'},

	id_registrar            => {TYPE_NAME => 'int', ref => 'users'},
	dt_registered           => {TYPE_NAME => 'datetime'},

	id_voc_agent_src        => {TYPE_NAME => 'int', ref => 'voc_agents'},
	voc_agent_label         => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	base_label              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	acc_code                => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},

	code                    => {TYPE_NAME => 'varchar', COLUMN_SIZE => 20},

#	id_voc_project          => {TYPE_NAME => 'int'},
	subproject              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},

#	id_voc_federal_district => {TYPE_NAME => 'int'},
	id_voc_region           => {TYPE_NAME => 'int'},
	id_voc_bank             => {TYPE_NAME => 'int'},
	id_employee_top_dep     => {TYPE_NAME => 'int', ref => 'deps'}, # Предприятие сотрудника
#	id_voc_city             => {TYPE_NAME => 'int'},
#	id_voc_client_type      => {TYPE_NAME => 'int'},

	is_removed              => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # Удаление из локальной базы

	id_merged_to            => {TYPE_NAME => 'int', ref => 'voc_agents'},

},

keys => {
	id_voc_agents_tree	=> 'id_voc_agents_tree',
	id_voc_bank => 'id_voc_bank',
	code => 'code',
},

