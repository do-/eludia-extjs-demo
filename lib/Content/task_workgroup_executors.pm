
################################################################################

sub select_task_workgroup_executors {

	my $data = {
		id_task_type     => $_REQUEST {id_task_type},
	};


	$_REQUEST {limit} += 0;
	$_REQUEST {_id} += 0;
	$_REQUEST {_id} ||= -1;

	sql ($data,

		'workgroups(id, label)' => [
			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => "id <> $_REQUEST{_id}, label"],

			[ LIMIT => "start, $_REQUEST{limit}"],

		],
		[
			'-task_type_rights()             ON task_type_rights.id_workgroup = workgroups.id AND task_type_rights.fake = 0 AND task_type_rights.is_execute = 1' => [
				[id_task_type => $data -> {id_task_type} || -1]
			]
		]
	);

	$data -> {task_workgroup_executors} = delete $data -> {workgroups};



	return $data;


}