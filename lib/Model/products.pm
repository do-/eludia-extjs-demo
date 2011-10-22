label => '������������: ������������',

columns => {

	label                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => '�������������� �����'},

	name                    => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => '������������'},
	short_label             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => '����������� �������, ����� ���������'},
	gost_ost_tu             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => '����, ���, ��'},
	part_size               => {TYPE_NAME => 'varchar', COLUMN_SIZE => 200, label => '����, ������'},
	full_name               => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������ ������������'},

	id_voc_unit             => {TYPE_NAME => 'int', ref => 'voc_units', label => '�������� ��'},
	id_voc_product_type     => {TYPE_NAME => 'int', ref => 'voc_product_types', label => '��� ������������'},
	id_voc_product_status   => {TYPE_NAME => 'int', ref => 'voc_product_status', COLUMN_DEF => 1, label => '������ ������������'},
	id_voc_preparation_kind => {TYPE_NAME => 'int', COLUMN_DEF => 0, label => '��� ���������'},
	weight                  => {TYPE_NAME => 'decimal', COLUMN_SIZE => 15, DECIMAL_DIGITS => 2, label => '���'},
	id_voc_group            => {TYPE_NAME => 'int', ref => 'voc_groups', label => '������ ������������'},
	dt                      => {TYPE_NAME => 'date', label => '���� ��������'},
	precision_production    => {TYPE_NAME => 'int', label => '���������� ������ ����� ������� � ����������'},	
	
	id_voc_drawing_format   => {TYPE_NAME => 'int', label => '������ �������'},

	id_log                  => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '����������� � ���� ���������� ���������'},
	id_log_check            => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '����������� � ���� �������� ������������'},

	is_rolled_metal         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '������'},
	in_list                 => {TYPE_NAME => 'tinyint', COLUMN_DEF => 1, label => '������ � ��������������� ��������'},

	# ���� �� ��������� �� �������� � ������� ������������ ������ ������������ � ������������ � ������ ������
	is_actual               => {TYPE_NAME => 'tinyint', COLUMN_DEF => 0, label => '���������'},

	primary_application     => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������� ����������'},
	product                 => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������'},
	material                => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��������'},
	litera                  => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������'},
	
	article                 => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������'},

	is_used_by_ecn_design   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��� ��������� ��'},
	is_used_by_ecn_tech     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��� ��������� ��'},
},

keys => {
	id_voc_product_type => 'id_voc_product_type',
	id_voc_group        => 'id_voc_group',
	id_product_parent   => 'id_product_parent',
	label               => 'label',
},


