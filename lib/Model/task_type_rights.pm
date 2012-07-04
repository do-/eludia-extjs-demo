label => '������: ��� ������. ����� �������',

columns => {
	id_task_type  => {TYPE_NAME => 'int', __no_update => 1, label => '��� ������'},
	id_workgroup  => {TYPE_NAME => 'int', __no_update => 1, label => '������'},
	
	is_admin      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => '������ - ������������� ���� �����'},
	is_create     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => '������������ ������ ����� ��������� ������ ����'},
	is_execute    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => '������������ ������ ����� ���� ������������� ����� ����'},
	is_inspector  => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => '������������ ������ ����� ���� ������������ ����� ����'},
	is_can_view   => 'checkbox',
	
	id_log        => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}, label => '������������ � ���� ���������� ��������������'},

	fake          => {TYPE_NAME => 'bigint', __no_update => 1}, # ����� �� ���������� fake � �� ����������������� ��������� ������
},

keys => {
	id_task_type => 'id_task_type',
},

