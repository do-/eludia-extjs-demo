label => '������������: ������� ��������� (��)',

columns => {	
	code      => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => '��� ��'},
	label     => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => '������������ ��'},
	note      => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => '�����������'},
	id_log    => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '������������ � ���� ���������� ��������������'},
	code_okei => {TYPE_NAME => 'varchar', COLUMN_SIZE  => 255, label => '��� �� ����'},
},

static => 1,
