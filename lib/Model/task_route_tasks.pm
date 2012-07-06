label => '��������: �������� ��������. ������� �����',

columns => {

	id_task_route    => {TYPE_NAME => 'int', label => '������ �� �������'},

	no               => {TYPE_NAME => 'int', label => '����� ������'},
	id_task_type     => {TYPE_NAME => 'int', label => '��� ������'},

	label            => {TYPE_NAME => 'varchar', COLUMN_SIZE => 255, label => '�����'},
	description      => {TYPE_NAME => 'text', label => '����������'},

	is_executor_is_role             => {TYPE_NAME => 'int', label => '��������� ������: 0 - �����������, 1 - ����, 2 - ������ �������������'},
	id_user_executor                => {TYPE_NAME => 'int', label => '������������ - ����������� ������'},
	
	id_task_route_role_initiator => 'select(task_route_roles)', # ���� - ��������� ������ (���� �� �������, ������� �� �������� ��������)
	
	id_task_route_role_executor     => {TYPE_NAME => 'int', ref => 'task_route_roles', label => '���� - ����������� ������'},
	id_workgroup_executor           => {TYPE_NAME => 'int', label => '������� ������ - ����������� ������'},
	is_execute_in_consec_order      => {TYPE_NAME => 'tinyint', 
		NULLABLE   => 0, 
		COLUMN_DEF => 0, 
		label      => '��� ������������: 0 - ������������� ������������, 1 - ���������������� ������������'
	},

	duration_days           => {TYPE_NAME => 'int', NULLABLE => 0, COLUMN_DEF => 0, label => '������������, ����'},
	duration_hours          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '������������, �����'},
	
	is_inspector_is_role            => {TYPE_NAME => 'int', label => '��������� ������: 0 - ������������, 1 - ����'},
	id_task_route_role_inspector    => {TYPE_NAME => 'int', ref => 'task_route_roles', label => '���� - ��������� ������'},
	id_workgroup_inspector          => {TYPE_NAME => 'int', label => '������� ������ ���������� ������'},
	id_user_inspector               => {TYPE_NAME => 'int', label => '������������ - ��������� ������'},

	is_used_in_agreement_sheet      => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� � ������������ ����� ������������'},
	
# ���������� ���� "��������� ���������� �������� ��������� ������" ��/���
	is_initiator_can_update_task    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => <<EOT},
�������������� ����� ������: 
	0 - ��������� ���������� �������� ��������� ������ (����������� � ��������� ����� ����� ����������� ��������������, � �������� �� ����).
	1 - ��������� �������� ��������� ������ (����������, ����������� � ����������, � �������� �� ����)
	2 - ��������� �������� ��������� ����� (����� �� ������ �������������)
EOT

	is_cant_create_children         => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� ��������� �������� ������'},
	is_done_after_children          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '������ ��������� ������ ��� ���������� �������� �����'},
	is_dt_to_limits_child_dt_to     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '���������� �������� ���� �������� ������ ����� ������� ������'},
	
	is_can_inspector_cancel_task    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� ����� ����� �������� ���������� ������'},

	is_grp_tsks_done_before_next    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��� ������ ����� ������ ���� ��������� �� ��������� ��������� ������'},
	is_cncl_tsks_after_fst_done     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� ������������� ������ � ������ �������������'},
	is_prev_tsks_done_bfre_this     => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '�� ��������� ������� ���������� ���� ���������� �� �������� �����'},
	is_cncl_othr_prev_tsks          => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��� ���������� ����� ������ �� ���������� ����� � ������ ������ ���������� �� �������� ����� ����������'},

	is_chng_doc_agmt_items_right    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� ��������� ����������� ���'},
	is_print_doc_agmt_allowed       => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '��������� �������� ���� �����������/���������'},

	is_crte_tsk_on_second_status    => {TYPE_NAME => 'tinyint', NULLABLE => 0, COLUMN_DEF => 0, label => '�� ������������ ������ ������'},

	# ���������� � ������� � ��������� �����
	position_left   => {TYPE_NAME => 'int', label => '������� ������ ������� � ��������� ���������: x'},
	position_top    => {TYPE_NAME => 'int', label => '������� ������ ������� � ��������� ���������: y'},
	position_height => {TYPE_NAME => 'int', label => '������� ������ ������� � ��������� ���������: ������'},
	position_width  => {TYPE_NAME => 'int', label => '������� ������ ������� � ��������� ���������: ������'},
},

keys => {
	id_task_route   => 'id_task_route',
},

