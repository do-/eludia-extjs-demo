label	=> '���������: ����������� ���������. �����',

columns => {

	parent                  => '(doc_folders)', # ������ �� ������������� ������
	
	label                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������� ��������'},
	
	id_doc_type             => {TYPE_NAME => 'int', label => '��� ����������'},

	id_doc_type_group       => {TYPE_NAME => 'int', label => '������ ����� ����������'},

	id_workgroup            => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0, label => '������� ������'},

	id_rights_holder        => {TYPE_NAME => 'int', ref	=> 'doc_folders', label => '������ �� ����� - ��������� ����'},
	
	is_source_ftp           => 'checkbox', # ������������� � FTP
	
	source_url              => 'string',  # ����� FTP

	peer_name               => 'string', # ��� ������� ����������, ��� ������������ ����������������� ���������

	uuid_linked_doc_folder  => {TYPE_NAME => 'varchar', COLUMN_SIZE => 36, label => 'uuid ��������, � ������� ���������������� ������'},
	
	is_global               => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOS },
������������ ��������:
	0 - ���������
	1 - ���������� (�������� � ������ �����)
	2 - ���������� (�� ������ ����)
EOS
},

keys => {
	parent	=> 'parent',
},

data => [
	{
		id => 1, fake => 0, parent => 0, label => '���������', id_doc_type => 0,
		($preconf -> {peer_name} ? (uuid => 'BE018786-1EA7-11DE-A5A0-48ABB9395060') : ()),
	},
	{
		id => 10_000,  fake => -1, parent => 1, id_doc_type => 0, label => '',
		($preconf -> {peer_name} ? (uuid => '384D8970-0F7A-11E1-A6B4-064AE696E3A2') : ()),
	},
	{
		id => 100_000, fake => -1, parent => 1, id_doc_type => 0, label => '',
		($preconf -> {peer_name} ? (uuid => '3D6E84A4-0F7A-11E1-A388-494AE696E3A2') : ()),
	},
],

