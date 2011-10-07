label => 'Номенклатура: Единицы измерения (ЕИ)',

columns => {	
	code      => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'Код ЕИ'},
	label     => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'Наименование ЕИ'},
	note      => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'Комментарии'},
	id_log    => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Пользователь и дата последнего редактирования'},
	code_okei => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => 'код по ОКЕИ'},
},

#data => [
#  	{id => 1,  fake => 0, code => '796', label => 'ШТ',     uuid => '4B5EF876-F139-11DD-993C-A3A214415C56'},
#  	{id => 2,  fake => 0, code => '715', label => 'ПАРА',   uuid => '4B5F049C-F139-11DD-AB15-CAE9D8262487'},
#  	{id => 3,  fake => 0, code => '000', label => 'КОМПЛ',  uuid => '4B5F0B72-F139-11DD-9AE4-FD96E92802D3'},
#  	{id => 4,  fake => 0, code => '006', label => 'П/М',    uuid => '4B5F1252-F139-11DD-983A-8083350F9463'},
#  	{id => 5,  fake => 0, code => '000', label => 'М',      uuid => '4B5F1914-F139-11DD-B006-FA46FA134073'},
#  	{id => 6,  fake => 0, code => '008', label => 'КМ',     uuid => '4B5F1FD6-F139-11DD-92AB-AB87B0257601'},
#  	{id => 7,  fake => 0, code => '053', label => 'ДМ2',    uuid => '4B5F2684-F139-11DD-95B7-89E5F3764283'},
#  	{id => 8,  fake => 0, code => '055', label => 'М2',     uuid => '4B5F2D46-F139-11DD-9214-E48FFB3E58F0'},
#  	{id => 9,  fake => 0, code => '113', label => 'М3',     uuid => '4B5F33FE-F139-11DD-8676-FEFF73F68AEA'},
#  	{id => 10, fake => 0, code => '112', label => 'Л',      uuid => '4B5F3AF2-F139-11DD-88A8-BB84C62CDFD4'},
#  	{id => 11, fake => 0, code => '163', label => 'Г',      uuid => '4B5F41A0-F139-11DD-89E9-B2A86F155B3F'},
#  	{id => 12, fake => 0, code => '166', label => 'КГ',     uuid => '4B5F484E-F139-11DD-AA88-DC33CDE5526E'},
#  	{id => 13, fake => 0, code => '168', label => 'Т',      uuid => '4B5F4EFC-F139-11DD-8AFE-918A174AC0E9'},
#  	{id => 14, fake => 0, code => '355', label => 'Минута', uuid => '4B5F55A0-F139-11DD-8D03-BD02E1D114F4'},
#  	{id => 15, fake => 0, code => '356', label => 'Час',    uuid => '4B5F5C4E-F139-11DD-A7A6-95FBC21A973C'},
#  	{id => 16, fake => 0, code => '359', label => 'День',   uuid => '4B5F6310-F139-11DD-8024-C82431F4CF85'},
#],

