label => '��������: �������� ��������. ����',

columns => {

	id_task_route => 'select(task_routes)', # ������ �� �������
	label         => 'string', # ����
	description   => 'string', # ��������
	
	id_task_route_role_subordinate  => '(task_route_roles)', # �������� ������������� ��� ����
	
	is_can_cancel_route_item => 'checkbox', # ����� ��������� �������
	is_can_edit_doc_files    => 'checkbox', # ����� �������� ����� � ���������

	ord                     => 'int', # (�� ������������) ���������� �����
},

keys => {
	id_task_route => 'id_task_route',
},

