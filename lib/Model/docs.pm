label	=> '���������: ���������',

columns => {

	id_doc_folder     => {TYPE_NAME => 'int', label => '�������'},

	id_doc_type       => {TYPE_NAME => 'int', label => '��� ���������'},
	id_doc_kind       => {TYPE_NAME => 'int', label => '��� ���������'},
	id_task_route     => {TYPE_NAME => 'int', label => '��������������� �������'},

	prefix            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������� ������'},
	no                => 'string', # �����
	
	no_ext            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������� �����'},
	dt                => {TYPE_NAME => 'date', label => '���� ���������'},
	dt_ext            => {TYPE_NAME => 'date', label => '���� �������� ��������� ���������'},
	dt_register       => {TYPE_NAME => 'datetime', label => '���� ����������� ���������'},
	dt_process_finish => {TYPE_NAME => 'datetime', label => '���� ���������� �������� �� ���������'},

	label             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},
	code              => 'string', # ���������� ��� � �������� ����������������� ����������� (����� ��� ��������)
	source_name       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��� ����� (��� ������� � FTP)'},
	description       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},
	id_doc_status     => {TYPE_NAME => 'int', label => '������'},
	id_user	          => {TYPE_NAME => 'int', label => '�������� ���������'},

	id_log            => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '������������ � ���� ���������� ��������������'},

	id_workgroup      => {TYPE_NAME => 'int', label => '������� ������'},

	id_task            => {TYPE_NAME => 'int', label => '������� ������ �� ��������� � ������ ��������'},
	id_task_route_item => {TYPE_NAME => 'int', label => '���������� ������� �� ���������'},
	
	label_href         => {TYPE_NAME => 'text', label => '����� ������ �� ��������'},
	
	id_merged_to       => 'select(docs)',             # ������ ����������������� �����������, � ������� ����� ������

	base_label         => 'string',                   # ������������ ������� �������, ������ ������� ��������
	acc_code           => 'string',                   # ��� ����������� � ������� �������, ������ ������� ��������
},

keys => {
	id_doc_folder	=> 'id_doc_folder',
	id_doc_type	=> 'id_doc_type',
	dt		=> 'dt, id_doc_type, prefix',
},
