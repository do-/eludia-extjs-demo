################################################################################

sub select_task_route_task_results {

	my $data = {
		id_task_route_task     => $_REQUEST {id_task_route_task},
	};


	$_REQUEST {limit} += 0;

	sql ($data,
		'task_route_task_results(id, label)' => [
			[id_task_route_task => $data -> {id_task_route_task} || -1],
			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => 'no'],

			[ LIMIT => "start, $_REQUEST{limit}"],

		],
	);


	return $data;

}

