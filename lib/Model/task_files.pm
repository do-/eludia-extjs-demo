label => '������: �����',

columns => {

	id_task     => {TYPE_NAME => 'int', label => '������'},
	
	is_actual   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '����������'},
	label       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},
	version     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������'},
	parent      => '(task_files)', # ������ �� ������������ ������ �����
	
	notes       => {TYPE_NAME => 'text', label => '����������'},

	id_log      => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '������������ � ���� ���������'},
	dt          => {TYPE_NAME => 'date', label => '���� ��������'},

	file_name => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => '��� �����'},
	file_type => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => '��� �����'},
	file_path => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => '���� � �����'},
	file_size => {TYPE_NAME    => 'int', label => '������ �����'},

},

keys => {
	id_task => 'id_task',
},

