label => '������������: ������� ��������� (��). ������������ �������� ������ ���������',

columns => {
	id_unit_from => 'select(voc_units)', # ����� �� ���������
	id_unit_to   => 'select(voc_units)', # � ����� �� ���������
	coeff        => {TYPE_NAME => 'decimal', COLUMN_SIZE => 15, DECIMAL_DIGITS => 8, label => '����������� ��������'},
	
	# ���� �� ����, ����������� ����� ����� ������ ��� ��������� ������������. ������: ������� ����� - ����������
	id_product   => 'select(products)', # ������������, ��� ������� ����������� ����� �����
	
	id_log       => {TYPE_NAME => 'int', ref => $conf->{systables}->{log}, label => '������������ � ���� �������������� ��������'},
},

keys => {
	id_unit    => 'id_unit_from, id_unit_to',
	id_product => 'id_product',
},


