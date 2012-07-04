label => '��������: ���������� ���������',

columns => {

	id_task_route_item_status => 'select(task_route_item_status)', # ������ ���������� ��������

	id_task_route   => 'select(task_routes)', # ������ �� ������ ��������
	
	id_doc_type     => 'select(doc_types)', # ��� ���������, �� �������� ������� �������
	id_type         => {TYPE_NAME => 'int', label => '������ �� ��������, � �������� �������� ��������� ��������'},
	
	id_user         => 'select(users)', # ���������
	no              => 'int', # �����
	
	dt_start        => {TYPE_NAME => 'datetime', label => '���� � ����� �������'},
	dt_finish       => {TYPE_NAME => 'datetime', label => '���� � ����� ����������'},

	id_task_route_agreement_list  => 'select(task_route_agreement_lists)', # ������ ����������� ���
	id_voc_contract_task_route    => 'select(voc_contract_task_routes)',   # ������� ������������ �������� (���������� ��� Vitek)

},

keys => {
	id_task_route   => 'id_task_route',
	no      => 'no',
},

