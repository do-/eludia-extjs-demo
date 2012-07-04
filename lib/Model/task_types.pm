label => '������: ���� �����',

columns => {
	label                              => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�������� ����'},
	prefix                             => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, __no_update => 1, label => '������� ������ �����'},
	order_type                         => {TYPE_NAME => 'int', label => '���������: 0 - ��������, 1 - � �������� ����'},
	is_global                          => 'checkbox', # ���������� �� ��� ������

#{id => 0, label => '�������� ��� ���������'},
#{id => 1, label => '����������� ��� ����������'},
#{id => 2, label => '���������� ��� ���������'},
#{id => 3, label => '�� ������������'},

	field_id_voc_agent                 => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '���� ����������: 0 - �������� ��� ����������, 1 - ����������� ��� ����������, 3 - �� ����������'},
	field_id_task_importance           => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '���� ��������: 0 - �������� ��� ����������, 1 - ����������� ��� ����������, 3 - �� ����������'},
	field_doc_files	                   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '���� �����: 0 - �������� ��� ����������, 1 - ����������� ��� ����������, 3 - �� ����������'},

	is_need_confirm                    => 'checkbox', # ���������� �������������<br>���������� �����������

	is_multiple_executors              => 'checkbox', # �����������: 0 - ������������, 1 - ������ �������������, 2 - ������ �������������, 3 - ����� ��������� �� ������

	is_system                          => 'checkbox', # ��� ����� �������������
#	is_can_inspector_change_dt_plan_to              => 'checkbox', # ��������� ���������� ��������<br>�������� ���� ����������
	is_can_insp_chng_dt_plan_to                     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # ��������� ���������� ��������<br>�������� ���� ����������
#	is_can_inspector_change_id_user_executor	=> 'checkbox', # ��������� ����������<br>������ ����������� ������
	is_can_insp_chng_id_user_exec   => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # ��������� ����������<br>������ ����������� ������
	is_done_after_children          => 'checkbox', # ������ ��������� ������<br>��� ���������� �������� �����
	is_used_only_in_task_routes     => 'checkbox', # ������������ ������<br>��� �������� ���������
	is_done_after_children          => 'checkbox', # ������ ��������� ������ ��� ���������� �������� �����

	is_dt_to_limits_child_dt_to     => 'checkbox', # ���������� �������� ���� �������� ������ ����� ������� ������
	is_cant_create_children         => 'checkbox', # ��������� ��������� �������� ������

	is_can_child_view_parents                       => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # �������� ��������<br>�� �������� �����
#	is_create_task_on_second_status                 => 'checkbox', # �� ������������<br>������ ������
	is_crte_tsk_on_second_status                    => 'checkbox', # �� ������������<br>������ ������
	is_messaging_denied                             => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # ��������� ��<br>������ ���������
	is_dont_show_reminders                          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # �� ���������� ���� "���������.."
	is_status_changes_in_msgng                      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1}, # ��������� � ���������<br>��������� ������� ������

#	is_used_by_schedules               => 'checkbox',

	duration_days                      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1, label => '����������� ������������ ����������, ����'},
	duration_hours                     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, __no_update => 1,  label => '����������� ������������ ����������, �����'},

	id_doc                             => {TYPE_NAME => 'int', label => '��������, � �������� �������� ��� �����'},

	id_log  => {TYPE_NAME => 'int', ref => $conf -> {systables} -> {log}, label => '���� � ����� ���������'},

	fake    => {TYPE_NAME => 'bigint', __no_update => 1}, # ����� �� ���������� fake � �� ����������������� ��������� ������
},

static => 1,


data => [
	{
		id                       => 10_000,
		fake                     => -1,
		label                    => '',
		prefix                   => '',
		order_type               => $ORDER_TYPE_SEQUENTAL,
		is_global                => 0,
		field_id_voc_agent       => 3,
		field_id_task_importance => 3,
		field_doc_files          => 3,
		is_need_confirm          => 1,
		is_multiple_executors    => 0,
		is_system                => 1,

		is_can_insp_chng_dt_plan_to   => 0,
		is_can_insp_chng_id_user_exec => 0,
		is_done_after_children        => 0,
		is_used_only_in_task_routes   => 0,
		is_can_child_view_parents     => 0,
		is_crte_tsk_on_second_status  => 0,
		is_messaging_denied           => 0,
		is_dont_show_reminders        => 0,
		duration_days                 => 0,
		duration_hours                => 0,
		($preconf -> {peer_name} ? (uuid => '12BDF92C-2A17-11E0-98DC-5B2248ADA781') : ()),
	},
	{
		id                       => 10_001,
		fake                     => 0,
		label                    => '������ ���������',
		prefix                   => '',
		order_type               => $ORDER_TYPE_SEQUENTAL,
		is_global                => 0,
		field_id_voc_agent       => 3,
		field_id_task_importance => 0,
		field_doc_files          => 0,
		is_need_confirm          => 0,
		is_multiple_executors    => 2,
		is_system                => 1,

		is_can_insp_chng_dt_plan_to   => 0,
		is_can_insp_chng_id_user_exec => 0,
		is_done_after_children        => 0,
		is_used_only_in_task_routes   => 0,
		is_can_child_view_parents     => 0,
		is_crte_tsk_on_second_status  => 0,
		is_messaging_denied           => 0,
		is_dont_show_reminders        => 0,
#		is_used_by_schedules          => 1,
		duration_days                 => 0,
		duration_hours                => 0,
		($preconf -> {peer_name} ? (uuid => '81E647BE-3B5A-11E1-A532-B9A5570702AB') : ()),
	},

	{
		id => 100_000,
		fake => -1,
		label => '',
		($preconf -> {peer_name} ? (uuid => '12C0B46E-2A17-11E0-98DC-5B2248ADA781') : ()),
	},
],

