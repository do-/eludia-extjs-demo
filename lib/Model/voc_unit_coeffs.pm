label => 'Номенклатура: Единицы измерения (ЕИ). Коэффициенты перевода единиц измерений',

columns => {
	id_unit_from => 'select(voc_units)', # Какую ЕИ переводим
	id_unit_to   => 'select(voc_units)', # В какую ЕИ переводим
	coeff        => {TYPE_NAME => 'decimal', COLUMN_SIZE => 15, DECIMAL_DIGITS => 8, label => 'Коэффициент перевода'},
	
	# если не пуст, коэффициент имеет смысл только для указанной номенклатуры. Пример: перевод литры - килограммы
	id_product   => 'select(products)', # Номенклатура, для которой коэффициент имеет смысл
	
	id_log       => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользователь и дата редактирования карточки'},
},

keys => {
	id_unit    => 'id_unit_from, id_unit_to',
	id_product => 'id_product',
},


