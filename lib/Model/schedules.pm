 label => '��������� �������������',

columns => {
	id_user       => 'select (users)', # �������� ���������
	label         => 'string',         # ������������
	id___query    => "select ($conf->{systables}->{__queries})", # ������ ���������
	color         => 'string',         # ���� �����
	is_personal   => 'checkbox',       # ������ ���������
	description   => 'text',
	is_hidden     => 'checkbox',       # ������ ���������
},

keys => {
	id_user => 'id_user',
},


