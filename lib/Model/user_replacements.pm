label => '�����������������: ������������. ���������',

columns => {
	id_user      => {TYPE_NAME => 'int', ref => 'users', label => '���������� ������������'},
	dt_from      => {TYPE_NAME => 'date', label => '���� ������ �������� ����������'},
	dt_to        => {TYPE_NAME => 'date', label => '���� ��������� �������� ���������'},
	id_assistant => {TYPE_NAME => 'int', ref => 'users', label => '�����������'},
	comments     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 100, NULLABLE => 1, label => '���������'},
	is_tasks     => 'checkbox', # ����������� ����� ����� ����������� � �������
	is_docs      => 'checkbox', # ����������� ����� ����� ����������� � ����������� ���������
},

keys => {
	id_user      => 'id_user',
	id_assistant => 'id_assistant',
	dt           => 'dt_from, dt_to',
},

