label	=> '���������: �������������� ����. �������� �������������� �����, �������� ��������� ������������� �����',

columns => {

# � ������ ���� �������� ����������� ���. ���� (���������, ������, etc.). NULL - docs.
	id_doc_type_bind    => {TYPE_NAME => 'int', ref => 'doc_types', NULLABLE => 0, COLUMN_DEF => 0, label => '������ �������, � �������� ����������� ���. ����'},
	
	id_doc_field_folder => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0, label => '������� ����������� ���. �����'},

	label             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},
	
	description       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},

	field_type        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOT},
���: 
	0 - ������
	1 - �����
	2 - ��������
	3 - ����
	4 - ���������� ��������
	5 - �������
	6 - ������������� �����
	7 - ����
	8 - ��������� ���. ����
EOT

	select_type       => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOT },
������ ������ �������� (��� ����� ���� "���������� ��������"):
	0 - ���������� ������
	1 - ��������
	2 - �����������
	3 - ������������� �����
��� ����� ���� "��������� ����":
	0 - � ����� ������
	1 - � ����� ������ � ����������
	2 - � ����� ����
EOT
	digits            => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '�������� �����'},

# field_type = 4. ������ �� ����������.
	id_doc_type       => {TYPE_NAME => 'int', label => '��� ���������, ������� ������������ ��� ���������� (��� ����� ���� "���������� ��������")'},
	
#	size              => {TYPE_NAME => 'int'}, Oracle - SUXXXX
	size_             => {TYPE_NAME => 'int', label => '������ ���� (��� ����� ���� "������")'},
	max_len           => {TYPE_NAME => 'int', label => '������������ ���������� �������� (��� ����� ���� "������")'},
	cols              => {TYPE_NAME => 'int', label => '������ ���� (��� ����� ���� "������������� �����")'},
#	rows              => {TYPE_NAME => 'int'}, Oracle - SUXXXX
	rows_             => {TYPE_NAME => 'int', label => '����� ����� (��� ����� ���� "������������� �����")'},
	
	order_field       => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������� ���������� (��� ����� ���� "���������� ��������")'},

	is_system         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������������'},
	
	# ����������� ������ �������� ���������, �� ������ ��������� ����������� �������������� ��� ���. ���� - ����������� ����� ����������
	is_tree           => {
		TYPE_NAME  => 'tinyint',
		NULLABLE   => 0,
		COLUMN_DEF => 0,
		label      => '����� �������� ���������� ������ (��� ����� ���� "���������� ��������")',
	},

	cnt               => {
		TYPE_NAME => 'int',
		label     => '������������ ���������� ��������, ������� ����� �������� � ���������� ������ (��� ����� ���� "���������� ��������" - "���������� ������")',
	},

	id_doc_type_unit  => {TYPE_NAME => 'int', ref => 'doc_types'}, # ������ �� ���-���������� ��
	id_type_unit      => {TYPE_NAME => 'int'},                     # �� ��-���������

	is_period         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # �������� ���. ���� ����� ������ ��������
	is_history        => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # ��������� ������� ��������� �������� ���. ����
	access_by_workgroups => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0}, # ������������� ������ ����� ������ �������������
	
	id_log            => {TYPE_NAME => 'int', label => '������������ � ���� ���������� ���������'},

	name              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '(�� ������������)'},
},

data	=> [
# ������
	{id =>   10_000, fake => -1, label => '', description => '', name => '', is_system => 0, id_doc_type => 0, select_type => 0, field_type => 0, cnt => 0, max_len => 0, size_ => 0, uuid => ''},
	{id =>   100_000, fake => -1,},

	{id	=> 10, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'no',            label => '�����',          uuid => 'BE726780-1EA7-11DE-A5A0-48ABB9395060', field_type => 0},
	{id	=> 11, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'dt',            label => '����',           uuid => 'BE777BC6-1EA7-11DE-A5A0-48ABB9395060', field_type => 3},
	{id	=> 12, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'id_doc_type',   label => '��� ���������',  uuid => 'BE7C91B0-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
	{id	=> 13, fake => 0, is_system => 1, id_doc_type => 10_012,                        name => 'id_doc_kind',   label => '��� ���������',  uuid => 'BE81A5A6-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
	{id	=> 14, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'no_ext',        label => '����� ��������', uuid => 'BE87FF5A-1EA7-11DE-A5A0-48ABB9395060', field_type => 0, size_ => 20, max_len => 255},
	{id	=> 15, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'dt_ext',        label => '���� ��������',  uuid => 'BE8D171A-1EA7-11DE-A5A0-48ABB9395060', field_type => 3},
	{id	=> 16, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'label',         label => '����������',     uuid => 'BE922CA0-1EA7-11DE-A5A0-48ABB9395060', field_type => 0, size_ => 80, max_len => 255},
	{id	=> 17, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'id_user',       label => '�����',          uuid => 'BE988622-1EA7-11DE-A5A0-48ABB9395060', field_type => 4},
	{id	=> 18, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'dt_register',   label => '���� ��������',  uuid => 'BEA3F48A-1EA7-11DE-A5A0-48ABB9395060', field_type => 3},
	{id	=> 19, fake => 0, is_system => 1, id_doc_type => $ID_DOC_TYPE_DOC_FOLDERS,      name => 'id_doc_folder', label => '�������',        uuid => 'BEACD28A-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
	{id	=> 20, fake => 0, is_system => 1, id_doc_type => 10_011,                        name => 'id_doc_status', label => '������',         uuid => 'BEBC0AE8-1EA7-11DE-A5A0-48ABB9395060', field_type => 4, select_type => 0},
#			# ��������� ���� ��� ���������� �������� � ������ ����������
	{id	=> 21, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'doc_files',     label => '�����',          uuid => 'BEC120B4-1EA7-11DE-A5A0-48ABB9395060', field_type => 7,},
	{id	=> 22, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'code',          label => '���',            uuid => 'A6DBA778-AA35-11E0-8F46-A07059DB4074', field_type => 0,},
	{id	=> 23, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'prefix',        label => '�������',        uuid => '38FE5C4A-AA36-11E0-BB17-DD7259DB4074', field_type => 0,},
	{id	=> 24, fake => 0, is_system => 1, id_doc_type => 0,                             name => 'prefix_no',     label => '����� � ���������',uuid => '19817CB2-AA36-11E0-913A-737259DB4074', field_type => 0,},

],
