label => '��������: �������� ��������. ����� ����� ����������� � ����������� �����',

columns => {
	id_task_route_task_src    => 'select(task_route_tasks)', # ������ �� ������ ����������� ������/�����
	id_task_route_task_result => 'select(task_route_task_results)', # ������ �� ���������
	is_results_is_different   => 'checkbox', # 0 - �� ��� ������ ����������� � id_task_route_task_result, 1 - ��� ������ ������ ����������� � id_task_route_task_result
	id_task_route_task_dst    => 'select(task_route_tasks)', # ������ �� ������ ����������� ������/�����

	# ��� ��������� ����� ��������
	input   => 'string', # endpoint, � ������� ������ ����������
	output  => 'string',# endpoint, �� ������� ������� ����������
},

keys => {
	id_task_route_task_src	=> 'id_task_route_task_src, id_task_route_task_result',
	id_task_route_task_dst	=> 'id_task_route_task_dst, id_task_route_task_result',
},

