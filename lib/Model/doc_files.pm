label	=> '���������: �����',

columns => {
	id_doc          => {TYPE_NAME => 'int', label => '������ �� ��������'},

	parent          => '(doc_files)', # ������ �� ������������ ������ �����

	version         => 'string', # ������
	label           => 'string', # ������������

	is_actual       => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, label => '����������'},
	notes           => {TYPE_NAME => 'varchar', COLUMN_SIZE => 4000, label => '����������'},

	id_log          => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '������������ � ���� �����������'},

	content_index   => {TYPE_NAME => 'longtext', label => 'C��������� ����� ��� ��������������� ������'},

	file_name       => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => '��� �����'},
	file_type       => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => '��� �����'},
	file_path       => {TYPE_NAME    => 'varchar', COLUMN_SIZE  => 255, label => '���� � �����'},
	file_size       => {TYPE_NAME    => 'int', label => '������ �����'},
},

keys => {
	id_doc => 'id_doc',
},

