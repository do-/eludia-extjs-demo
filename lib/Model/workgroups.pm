label => '�����������������: ������ �������������',

columns => {

	id_workgroup_folder => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 1, label => '�������'},
	
	label            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},
	comments         => {TYPE_NAME => 'text', label => '����������'},
	is_have_homepage => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� �������� � ������� (�� ������������)'},
	is_system        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������������'},
	is_global        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '�������� ������: 0 - ���������, 1 - ����������, 2 - ������������ � ������ ����������� ������ � �������� ����'},
	
	voc_store_ids    => {TYPE_NAME => 'text', label => '������ � �������'},
	
	id_workgroup     => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0}, # ������ �� ������ �������� ��� ����������� ������
	id_type          => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0}, # ������ �� ������������ ��� ��� ����������� ������

	id_log           => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}}, # ������������ � ���� ���������� ��������

},

keys => {
	id_workgroup	=> 'id_workgroup',
},

data => [
	{id => 1, label => '��� ������������', fake => 0, is_system => 1, is_global => 1, uuid => 'DAC2B880-E866-11DD-BDF8-BA67C8E92ED2'},
],

