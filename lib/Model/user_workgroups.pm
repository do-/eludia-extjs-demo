label => '�����������������: �������� ������������� � ������� �������',

columns => {
	id_user       => {TYPE_NAME => 'int', label => '������ �� ������������'},
	id_workgroup  => {TYPE_NAME => 'int', label => '������ �� ������� ������'},
	is_admin      => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, NULLABLE => 0, label => '������������ �������� ��������������� ������'},
	
	id_log        => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}}, # ������������ � ���� ��������
},

keys => {
	id_user      => 'id_user',
	id_workgroup => 'id_workgroup',
},

