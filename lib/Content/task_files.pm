
################################################################################

sub do_download_task_files {

	eval {
		sql_download_file ({
			table            => 'task_files',
			file_name_column => 'file_name',
			size_column      => 'file_size',
			type_column      => 'file_type',
			path_column      => 'file_path',
		});
	};

	if ($@) {

		out_html ({}, '404');

	}

	return $data;

}

################################################################################

sub get_item_of_task_files {



	return $data;

}


################################################################################

sub select_task_files {

	my $data = {
		id_task     => $_REQUEST {id_task},
	};


	$_REQUEST {limit} += 0;

	sql ($data,
		'task_files' => [
			[id_task => $data -> {id_task} || -1],
			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => 'id'],

			[ LIMIT => "start, $_REQUEST{limit}"],

		],
		'log()',
		'users(label)'
	);


	return $data;

}

