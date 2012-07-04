label => '������: ������� ��������� �����',

columns => {

	id_task            => {TYPE_NAME => 'int', , label => '������ �� ������'},
	id_user            => {TYPE_NAME => 'int', , label => '����� ���������'},
	dt                 => {TYPE_NAME => 'datetime', label => '���� ���������'},

	# ������� ��������� ���� ����� ������ �������� � ����� �������: � ������ ������ �� NULL ������ ���� �� �����
	id_user_initiator         => {TYPE_NAME => 'int', ref => 'users', label => '���������'},

	id_workgroup_executor     => {TYPE_NAME => 'int', ref => 'workgroups', label => '������ ������������'},
	id_user_executor          => {TYPE_NAME => 'int', ref => 'users', label => '�����������'},

	dt_from_plan              => {TYPE_NAME => 'datetime', label => '���� ������ ��������'},
	dt_to_plan                => {TYPE_NAME => 'datetime', label => '���� ���������� ��������'},

	dt_from_fact              =>  {TYPE_NAME => 'datetime', label => '���� ������ ����������'},
	dt_to_fact                => {TYPE_NAME => 'datetime', label => '���� ���������� ����������'},

	id_task_type_result       => {TYPE_NAME => 'int', label => '���������'},
	id_task_route_task_result => {TYPE_NAME => 'int', label => '��������� (��� ����� �� ���������)'},
	result                    => {TYPE_NAME => 'text', label => '��������� ��������'},

	id_workgroup_inspector    => {TYPE_NAME => 'int', ref => 'workgroups', label => '������ ����������'},
	id_user_inspector         => {TYPE_NAME => 'int', ref => 'users', label => '���������'},
	
	id_actual_user_inspector => {TYPE_NAME => 'int', ref => 'users', label => '���������, ��������� ���������� ������ (����� ��������� �� ���������� � ������)'},
	id_user_who_cancelled    => {TYPE_NAME => 'int', ref => 'users', label => '������������, ���������� ���������� ������'},

},

keys => {
	id_task		=> 'id_task',
},

