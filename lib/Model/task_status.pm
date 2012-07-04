label => 'Задачи: Статусы',

columns => {
	label   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Название'},
},

static => 1,

data => [
	{id => 1, fake => 0, label => 'Взять в работу'},
	{id => 2, fake => 0, label => 'Выполнить'},
	{id => 3, fake => 0, label => 'Подтвердить выполнение'},
	{id => 4, fake => 0, label => 'Завершена'},
	{id => 5, fake => 0, label => 'Отменена'},
],

