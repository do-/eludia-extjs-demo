label => "�����������������: ������������. ���� ������������",

columns => {

	parent        => {TYPE_NAME => 'int', ref => 'deps', label => '������ �� ������������ ������� ���������',},
	code          => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '����� �������������',},
	label         => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������������', __no_update => 1},
	short_label   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������� ������������'},
	id_dep_status => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, label => '��� �������� ���������: 0 - �������������, 1 - ��������, 2 - ������, 3 - ������ ������'},
	id_top_dep    => {TYPE_NAME => 'int', ref => 'deps', label => '��� ������������� ������ �� ������ ��� ��������'},							#

	note          => {TYPE_NAME => 'text', label => '�����������',},

	peer_name     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������������ ������� ������ ��������'},
	
},

keys => {
	parent	=> 'parent',
},

data => [
#	{id => 1, fake => 0, parent => 0, id_dep_status => 3, id_top_dep => 1, uuid => '87549CF2-E151-11DD-89C4-C8EE85590461'},
],

