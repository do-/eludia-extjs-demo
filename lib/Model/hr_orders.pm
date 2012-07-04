label => '�����������������: ������������. �����������',

columns => {

	id_user        => {TYPE_NAME => 'int', label => '������ �� ������������'},
	id_dep         => {TYPE_NAME => 'int', label => '������ �� ��������������'},
	id_top_dep     => {TYPE_NAME => 'int', ref => 'deps', label => '������ �� �����������'},
	dt             => {TYPE_NAME => 'date', label => '���� ������ �� ���������'},
	dt_to          => {TYPE_NAME => 'date', label => '���� ���������� � ���������'},

	id_voc_post    => {TYPE_NAME => 'int', label => '���������'},
	
# ����������� � id_voc_post �� ��� ��� ������������
# ���� NULL, �� ������ �� ����������, ����� � ��������/������ �� ������
	position_label => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������� ���������'},
	
	is_boss        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '���������'},
	base           => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������� (������, etc.)'},

	dt_id_id_dep   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, COLUMN_DEF => '1970-01-01', label => '��������������� ���� ��� ������������� ����� �������� ���������� �� ����'},

	id_log         => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '������������ � ���� ��������� ������'},

},

keys => {
	id_user => 'id_user,dt',
	dt	=> 'dt',
	dt_id_id_dep => 'id_user,dt_id_id_dep',
	id_dep       => 'id_dep',
},

data => [
#	{id => 1, fake => 0, id_user => 1, id_dep => 1, id_top_dep => 1, dt => '2008-01-01', position_label => '�����', is_boss => 0, dt_id_id_dep => '2008-01-01 1_1'},
],

