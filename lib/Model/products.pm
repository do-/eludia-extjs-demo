label => 'Номенклатура: Номенклатура',

columns => {

	label                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => 'Номенклатурный номер'},

	name                    => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => 'Наименование'},
	short_label             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => 'Обозначение чертежа, марка материала'},
	gost_ost_tu             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => 'ГОСТ, ОСТ, ТУ'},
	part_size               => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => 'Сорт, размер'},
	full_name               => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Полное наименование'},

	id_voc_unit             => {TYPE_NAME => 'int', ref => 'voc_units', label => 'Основная ЕИ'},
	id_voc_product_type     => {TYPE_NAME => 'int', ref => 'voc_product_types', label => 'Тип номенклатуры'},
	id_voc_product_status   => {TYPE_NAME => 'int', ref => 'voc_product_status', COLUMN_DEF => 1, label => 'Статус номенклатуры'},
	id_voc_preparation_kind => {TYPE_NAME => 'int', COLUMN_DEF => 0, label => 'Вид заготовки'},
	weight                  => {TYPE_NAME => 'decimal', COLUMN_SIZE => 15, DECIMAL_DIGITS => 2, label => 'Вес'},
	id_voc_group            => {TYPE_NAME => 'int', ref => 'voc_groups', label => 'Группа номенклатуры'},
	dt                      => {TYPE_NAME => 'date', label => 'Дата создания'},
	precision_production    => {TYPE_NAME => 'int', label => 'Количество знаков после запятой в количестве'},	
	
	id_voc_drawing_format   => {TYPE_NAME => 'int', label => 'Формат чертежа'},

	id_log                  => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользовтель и дата последнего изменения'},
	id_log_check            => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользовтель и дата проверки номенклатуры'},

	is_rolled_metal         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Прокат'},
	in_list                 => {TYPE_NAME => 'tinyint', COLUMN_DEF => 1, label => 'Входит в ограничительный перечень'},

	# пока не отправили на проверку в Холдинг номенклатуру нельзя использовать в спецификации и прочих местах
	is_actual               => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, label => 'Проверена'},

	primary_application     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Первичное применение'},
	product                 => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Изделие'},
	material                => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Материал'},
	litera                  => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Литера'},
	
	article                 => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Артикул'},

	is_used_by_ecn_design   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Под контролем КИ'},
	is_used_by_ecn_tech     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Под контролем ТИ'},
},

keys => {
	id_voc_product_type => 'id_voc_product_type',
	id_voc_group        => 'id_voc_group',
	id_product_parent   => 'id_product_parent',
	label               => 'label',
},


