label => 'Çàäà÷è: Ôàéëû',

columns => {

	id_task     => {TYPE_NAME => 'int', label => 'Çàäà÷à'},
	
	is_actual   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => 'Àêòóàëüíûé'},
	label       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Íàçâàíèå'},
	version     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => 'Âåğñèÿ'},
	parent      => '(task_files)', # Ññûëêà íà ğîäèòåëüñêóş âåğñèş ôàéëà
	
	notes       => {TYPE_NAME => 'text', label => 'Ïğèìå÷àíèå'},

	id_log      => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => 'Ïîëüçîâàòåëü è äàòà èçìåíåíèÿ'},
	dt          => {TYPE_NAME => 'date', label => 'Äàòà ñîçäàíèÿ'},

	file_name => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => 'Èìÿ ôàéëà'},
	file_type => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => 'Òèï ôàéëà'},
	file_path => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => 'Ïóòü ê ôàéëó'},
	file_size => {TYPE_NAME    => 'int', label => 'Ğàçìåğ ôàéëà'},

},

keys => {
	id_task => 'id_task',
},

