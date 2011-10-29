
label => 'Номенклатура: Справочники. Типы номенклатуры',

columns => { 
	label => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255},
	ord   => {TYPE_NAME => 'int'},	# != 0 для описания строки спецификации
},

data => [
	{id => 1,  fake => 0, label => 'Услуга',              ord => 24, uuid => '70272DE2-A5CC-11DF-91BD-1A2F1284F079'},
	{id => 2,  fake => 0, label => 'Детали',              ord =>  4, uuid => '74C4D9E4-A5CC-11DF-8F35-232F1284F079'},
#	{id => 3,  fake => 0, label => 'Изделие',             ord =>  0, uuid => '78547628-A5CC-11DF-BAF1-2A2F1284F079'}, все изделия приравнены к оснастке
	{id => 4,  fake => 0, label => 'Приспособление',      ord => 15, uuid => '7CC82DC6-A5CC-11DF-9776-322F1284F079'},
	{id => 5,  fake => 0, label => 'Материалы',           ord =>  7, uuid => '7CEE5F28-A5CC-11DF-8BEF-342F1284F079'},
	{id => 6,  fake => 0, label => 'Оснастка',            ord => 14, uuid => '7D117BAC-A5CC-11DF-B373-352F1284F079'},
	{id => 7,  fake => 0, label => 'Сборочные единицы',   ord =>  3, uuid => '7D34A654-A5CC-11DF-BA0D-362F1284F079'},
	{id => 8,  fake => 0, label => 'Документация',        ord =>  1, uuid => '7D5AC33E-A5CC-11DF-8171-372F1284F079'},
	{id => 9,  fake => 0, label => 'Стандартные изделия', ord =>  5, uuid => '7D77B55C-A5CC-11DF-903C-392F1284F079'},
	{id => 10, fake => 0, label => 'Прочие изделия',      ord =>  6, uuid => '7D9AD5DC-A5CC-11DF-81EE-3A2F1284F079'},
	{id => 11, fake => 0, label => 'Комплекты',           ord =>  8, uuid => '9ADDD9FA-A5CC-11DF-B7BE-A82F1284F079'},
	{id => 12, fake => 0, label => 'РИ',                  ord => 16, uuid => '9B00E788-A5CC-11DF-8C36-A92F1284F079'},
	{id => 13, fake => 0, label => 'Заготовка',           ord => 11, uuid => '9B20EAE2-A5CC-11DF-ABF8-AA2F1284F079'},
	{id => 14, fake => 0, label => 'Тара',                ord => 13, uuid => '9B40EB58-A5CC-11DF-9BDD-AB2F1284F079'},
	{id => 15, fake => 0, label => 'Техн.комплект',       ord => 12, uuid => '9B60F1F0-A5CC-11DF-965A-AD2F1284F079'},
	{id => 16, fake => 0, label => 'Комплексы',           ord =>  2, uuid => '9B84071C-A5CC-11DF-B51C-AE2F1284F079'},

#	{id => 17, fake =>-1, label => 'РИ',                  ord => 17, uuid => '9BA4053A-A5CC-11DF-A40C-AF2F1284F079'},
	{id => 18, fake => 0, label => 'ВИ',                  ord => 18, uuid => '9BC0EF2E-A5CC-11DF-8052-B02F1284F079'},
	{id => 19, fake => 0, label => 'СИ',                  ord => 19, uuid => 'B6A11DAA-A5CC-11DF-AF27-17301284F079'},
	{id => 20, fake => 0, label => 'СИЗ',                 ord => 20, uuid => 'B6C75434-A5CC-11DF-83F0-18301284F079'},
	{id => 21, fake => 0, label => 'ГП оборудование',     ord => 21, uuid => 'B6EA6AC8-A5CC-11DF-8DBC-1A301284F079'},
	{id => 23, fake => 0, label => 'Прочее оборудование', ord => 22, uuid => 'B70D804E-A5CC-11DF-A980-1B301284F079'},
	{id => 22, fake => 0, label => 'Транспорт',           ord => 23, uuid => 'B736D444-A5CC-11DF-8959-1C301284F079'},

	# АВВА-РУС

	{id => 24, fake => $preconf -> {peer_name} ? -1 : 0, label => 'АФС',                ord => 25, uuid => '43C53DD8-FEB0-11DF-89A9-35DE47ADA781'},
	{id => 25, fake => $preconf -> {peer_name} ? -1 : 0, label => 'Вспомогат. вещ-ва',  ord => 26, uuid => '46F1B0A4-FEB0-11DF-9BCE-42DE47ADA781'},
	{id => 26, fake => $preconf -> {peer_name} ? -1 : 0, label => 'Фасовка и упаковка', ord => 27, uuid => '4A6D24E8-FEB0-11DF-A8EE-47DE47ADA781'},
	{id => 27, fake => $preconf -> {peer_name} ? -1 : 0, label => 'Дезинфиц. вещ-ва',   ord => 28, uuid => '4AF1FF1A-FEB0-11DF-9498-48DE47ADA781'},
	{id => 28, fake => $preconf -> {peer_name} ? -1 : 0, label => 'Готовая продукция',  ord => 29, uuid => '4B38EFC4-FEB0-11DF-8250-4ADE47ADA781'},
	{id => 29, fake => $preconf -> {peer_name} ? -1 : 0, label => 'Полупродукт',        ord => 30, uuid => '4B57D664-FEB0-11DF-8949-4BDE47ADA781'},

	{id => 30, fake => -1, label => 'foo', ord => 99999, uuid => ''},

],

static => 1,

