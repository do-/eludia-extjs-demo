label => '������: ������',

columns => {

# ������������ ������
	parent                      => {TYPE_NAME => 'int', ref => 'tasks', label => '������������ ������'},
# ���������� ������ � ��������
	id_preceding_task           => {TYPE_NAME => 'int', ref => 'tasks', label => '���������� ������ � ��������'},

# ��� ��������� - ���������� �������� � �������� ����������� ���������
	group_task_no               => {TYPE_NAME => 'int', label => '������������� ������ �����, ���������� ������������ (����������� - ������ ������������� ��� ������ �������������)'},


	id_task_route_item          => {TYPE_NAME => 'int', label => '��������� �������� (��� ����� �� ���������)'},
# ������� ������, ���������� ��������� ����� �� �������� (���� ��������� ��� ��� id_task_route_item, �� ���������� ������� ���������� �������)
	is_parent_is_task_route     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '������� �� ���������� ������'},
	id_task_route_task          => {TYPE_NAME => 'int', label => '������ ������ (��� ����� �� ���������)'},


# ���������� ������������� �������� (���������� ���������� ������)
	is_need_create_confirm      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� �� ������������� ��� ��������'},

	id_task_type                => {TYPE_NAME => 'int', label => '���'},
	id_task_status              => {TYPE_NAME => 'int', label => '������'},

	id_user_initiator           => {TYPE_NAME => 'int', ref => 'users', label => '���������'},

	prefix                      => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '������� ������'},
	no                          => {TYPE_NAME => 'int', label => '�����'},
	dt                          => {TYPE_NAME => 'datetime', label => '���� ��������'},

	label                       => {TYPE_NAME => 'text', label => '����� ������'},

	id_doc_type                 => {TYPE_NAME => 'int', label => '��� ���������, � �������� ��������� ������'},
	id_type                     => {TYPE_NAME => 'int', label => '������ �� ��������, � �������� ��������� ������'},

# ��� ����������, � ������� ��������� ������, ���������� ��� ����������� ���������-��������� � ������������ ����������
	peer_name                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '��� ����������, � ������� ������� ������'},

# ��� ����������� � ������ ����������
	uuid_type                   => {TYPE_NAME => 'varchar', COLUMN_SIZE => 36, label => 'uuid ���������'},
	base_doc_label              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������� ���������'},

	id_voc_agent                => {TYPE_NAME => 'int', label => '����������'},
	id_task_importance          => {TYPE_NAME => 'int', label => '��������'},

	id_workgroup_executor       => {TYPE_NAME => 'int', ref	=> 'workgroups', label => '������ ������������'},
	id_workgroup_inspector      => {TYPE_NAME => 'int', ref	=> 'workgroups', label => '���������'},

	id_user_executor            => {TYPE_NAME => 'int', ref	=> 'users', label => '�����������'},

# �������� ������������ ��� �������� ������, ��� ����������� - �������� �����������.
# ����� ������������� �������� ��������� ��������� ������, ��� ����������� - � id_user_executor
	user_executor_ids           => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������� ������������'},

	id_user_inspector           => {TYPE_NAME => 'int', ref => 'users', label => '���������'},

	dt_from_plan                => {TYPE_NAME => 'datetime', label => '���� ������ ��������'},
	dt_to_plan                  => {TYPE_NAME => 'datetime', label => '���� ���������� ��������'},

	dt_remind_executor          => {TYPE_NAME => 'date', label => '��������� �����������'},
	dt_remind_inspector         => {TYPE_NAME => 'date', label => '��������� ����������'},

	dt_from_fact                => {TYPE_NAME => 'datetime', label => '���� ������ �����������'},
	dt_to_fact                  => {TYPE_NAME => 'datetime', label => '���� ���������� �����������'},

	id_task_type_result         => {TYPE_NAME => 'int', label => '���������'},
	id_task_route_task_result   => {TYPE_NAME => 'int', label => '��������� �� ������� �������� (��� ����� �� ���������)'},

	dt_accepted                 => {TYPE_NAME => 'datetime', label => '���� ������������'},

	result                      => {TYPE_NAME => 'text', label => '��������� ��������'},
	abort_reason                => {TYPE_NAME => 'text', label => '������� ������'},
	rework_reason               => {TYPE_NAME => 'text', label => '������� �������� �� ���������'},

},

keys => {
	dt                  => 'dt',
	id_user_executor    => 'id_user_executor',
	id_user_inspector   => 'id_user_inspector',
	id_task_route_item  => 'id_task_route_item, id_task_route_task',
	group_task_no       => 'group_task_no',
	id_type             => 'id_doc_type, id_type',
	parent              => 'parent',
},
