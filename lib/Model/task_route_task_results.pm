label => '��������: �������� ��������. ������ ������. ���������� ���������� ������',

columns => {

	id_task_route_task              => 'select(task_route_tasks)', # ������ (������ �� ������ ������)

	no                              => 'int',      # ���������� �����
	label                           => 'string',   # �������� ����������
	is_need_description             => 'checkbox', # ����������� ����������
	is_not_require_mandatory_flds   => 'checkbox', # �� ��������� ���������� ����� ���������
	is_default_result               => 'checkbox', # ����������� �� ��������� ���������
},

keys => {
	id_task_route_task	=> 'id_task_route_task',
},

