label => '��������: �������� ��������. ����� ������� � ���������',

columns => {

	id_task_route   => 'select(task_routes)', # ������ �� �������
	id_workgroup    => 'select(workgroups)', # ������ �� ������� ������
	is_admin        => 'checkbox', # ������� ������  - ������������� ��������
	is_create       => 'checkbox', # ������� ������ - ��������� ��������

},

keys => {
	id_task_route => 'id_task_route, id_workgroup',
},

