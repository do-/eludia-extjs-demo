
################################################################################

sub get_item_of_tasks {

	my $data = sql (tasks => ['id'], 'users(label) AS user_initiators');

	check_task_rights ($data);

	__d ($data);

	$data -> {no} = prefix_no ($data);

	if ($data -> {id_doc_type}) {

		$data -> {doc_type} = sql_select_hash ('doc_types', $data -> {id_doc_type});

		$data -> {base_doc_type_label} = $data -> {doc_type} -> {label};

		$data -> {base_doc_table} = get_doc_type_table ($data -> {doc_type});

		$data -> {base_doc_label} = get_base_doc_label ($data);


	}

	return $data;

}


################################################################################

sub select_tasks {

	my $data = {
		id_type     => $_REQUEST {id_type},
		id_doc_type => sql_select_scalar ('SELECT id_doc_type FROM docs WHERE id = ?', $_REQUEST {id_type}),
	};


	$_REQUEST {limit} += 0;

	sql ($data,
		'tasks(id, label, prefix, no, dt, dt_to_plan, id_task_status)' => [
			[id_doc_type => $data -> {id_doc_type} || -1],
			[id_type     => $data -> {id}],
			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => 'dt'],

			[ LIMIT => "start, $_REQUEST{limit}"],

		],
		'task_importances                  ON tasks.id_task_importance',
		'users      AS user_executors      ON tasks.id_user_executor',
		'users      AS user_inspectors     ON tasks.id_user_inspector',
		'users      AS user_initiators     ON tasks.id_user_initiator',
		'workgroups AS workgroup_executors ON tasks.id_workgroup_executor',
	);

	$data -> {doc_tasks} = $data -> {tasks};



	return $data;

}


