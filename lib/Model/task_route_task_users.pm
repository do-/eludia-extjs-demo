label => '��������: �������� ��������. ������ ������. ������ ������������ ������',

columns => {
	id_user_executor	=> 'select(users)', # ������ �� ����������� ������
	id_task_route_task	=> 'select(task_route_tasks)', # ������ �� ������ ������
},

keys => {
	id_task_route_task => 'id_task_route_task',
},


