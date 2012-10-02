label	=> 'Документы: Дополнительные поля. Описания дополнительных полей, описания групповых дополнителных полей',

columns => {

# К какому типу объектов назначается доп. поле (документы, задачи, etc.). NULL - docs.
	id_doc_type_bind    => {TYPE_NAME => 'int', ref => 'doc_types', NULLABLE => 0, COLUMN_DEF => 0, label => 'Раздел системы, к которому принадлежит доп. поле'},
	
	id_doc_field_folder => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0, label => 'Каталог справочника доп. полей'},

	label             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название'},
	
	description       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Описание'},

	field_type        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOT},
Тип: 
	0 - Строка
	1 - Число
	2 - Денежный
	3 - Дата
	4 - Справочное значение
	5 - Чекбокс
	6 - Многострочный текст
	7 - Файл
	8 - Групповое доп. поле
EOT

	select_type       => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOT },
Способ выбора значения (для полей типа "Справочное значение"):
	0 - выпадающий список
	1 - чекбоксы
	2 - радиокнопка
	3 - множественный выбор
Для полей типа "Групповое поле":
	0 - в общем списке
	1 - в общем списке с заголовком
	2 - в новом окне
EOT
	digits            => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Точность числа'},

# field_type = 4. ссылка на справочник.
	id_doc_type       => {TYPE_NAME => 'int', label => 'Тип документа, который используется как справочник (для полей типа "Справочное значение")'},
	
#	size              => {TYPE_NAME => 'int'}, Oracle - SUXXXX
	size_             => {TYPE_NAME => 'int', label => 'Размер поля (для полей типа "Строка")'},
	max_len           => {TYPE_NAME => 'int', label => 'Максимальное количество символов (для полей типа "Строка")'},
	cols              => {TYPE_NAME => 'int', label => 'Размер поля (для полей типа "Многострочный текст")'},
#	rows              => {TYPE_NAME => 'int'}, Oracle - SUXXXX
	rows_             => {TYPE_NAME => 'int', label => 'Число строк (для полей типа "Многострочный текст")'},
	
	order_field       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Порядок сортировки (для полей типа "Справочное значение")'},

	is_system         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Предопределено'},
	
	# вложенность дерева рисуется отступами, на момент написнаия комментария использовалось для доп. поля - справочника папок документов
	is_tree           => {
		TYPE_NAME  => 'tinyint',
		NULLABLE   => 0,
		COLUMN_DEF => 0,
		label      => 'Выбор значения использует дерево (для полей типа "Справочное значение")',
	},

	cnt               => {
		TYPE_NAME => 'int',
		label     => 'Максимальное количество значений, которое будет показано в выпадающем списке (для полей типа "Справочное значение" - "Выпадающий список")',
	},

	id_doc_type_unit  => {TYPE_NAME => 'int', ref => 'doc_types'}, # ссылка на тип-справочник ИЕ
	id_type_unit      => {TYPE_NAME => 'int'},                     # ЕИ по-умолчанию

	is_period         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # Значения доп. поля имеют период действия
	is_history        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # Сохранять историю изменения значений доп. поля
	access_by_workgroups => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # предоставлять доступ через группы пользователей
	
	id_log            => {TYPE_NAME => 'int', label => 'Пользователь и дата последнего изменения'},

	name              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '(не используется)'},
},

data	=> [
# Резерв
	{id =>   10_000, fake => -1, label => '', description => '', name => '', is_system => 0, id_doc_type => 0, select_type => 0, field_type => 0, cnt => 0, max_len => 0, size_ => 0, uuid => ''},
	{id =>   100_000, fake => -1,},

	{id	=> 10, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'no',            label => 'Номер',          uuid => 'BE726780-1EA7-11DE-A5A0-48ABB9395060', field_type => 0},
	{id	=> 11, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'dt',            label => 'Дата',           uuid => 'BE777BC6-1EA7-11DE-A5A0-48ABB9395060', field_type => 3},
	{id	=> 12, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'id_doc_type',   label => 'Тип документа',  uuid => 'BE7C91B0-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
	{id	=> 13, fake => 0, is_system => 1, id_doc_type => 10_012,                        name => 'id_doc_kind',   label => 'Вид документа',  uuid => 'BE81A5A6-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
	{id	=> 14, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'no_ext',        label => 'Номер входящий', uuid => 'BE87FF5A-1EA7-11DE-A5A0-48ABB9395060', field_type => 0, size_ => 20, max_len => 255},
	{id	=> 15, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'dt_ext',        label => 'Дата входящая',  uuid => 'BE8D171A-1EA7-11DE-A5A0-48ABB9395060', field_type => 3},
	{id	=> 16, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'label',         label => 'Содержание',     uuid => 'BE922CA0-1EA7-11DE-A5A0-48ABB9395060', field_type => 0, size_ => 80, max_len => 255},
	{id	=> 17, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'id_user',       label => 'Автор',          uuid => 'BE988622-1EA7-11DE-A5A0-48ABB9395060', field_type => 4},
	{id	=> 18, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'dt_register',   label => 'Дата создания',  uuid => 'BEA3F48A-1EA7-11DE-A5A0-48ABB9395060', field_type => 3},
	{id	=> 19, fake => 0, is_system => 1, id_doc_type => $ID_DOC_TYPE_DOC_FOLDERS,      name => 'id_doc_folder', label => 'Каталог',        uuid => 'BEACD28A-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
	{id	=> 20, fake => 0, is_system => 1, id_doc_type => 10_011,                        name => 'id_doc_status', label => 'Статус',         uuid => 'BEBC0AE8-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
#			# Фиктивное поле для управления доступом к файлам документов
	{id	=> 21, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'doc_files',     label => 'Файлы',          uuid => 'BEC120B4-1EA7-11DE-A5A0-48ABB9395060', field_type => 7,},
	{id	=> 22, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'code',          label => 'Код',            uuid => 'A6DBA778-AA35-11E0-8F46-A07059DB4074', field_type => 0,},
	{id	=> 23, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'prefix',        label => 'Префикс',        uuid => '38FE5C4A-AA36-11E0-BB17-DD7259DB4074', field_type => 0,},
	{id	=> 24, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'prefix_no',     label => 'Номер с префиксом',uuid => '19817CB2-AA36-11E0-913A-737259DB4074', field_type => 0,},

],
