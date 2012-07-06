
################################################################################

sub do_download_doc_files {

	eval {
		sql_download_file ({
			table            => 'doc_files',
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

sub get_item_of_doc_files {



	return $data;

}


################################################################################

sub select_doc_files {

	my $data = {
		id_doc     => $_REQUEST {id_doc},
	};


	$_REQUEST {limit} += 0;

	sql ($data,
		'doc_files' => [
			[id_doc => $data -> {id_doc} || -1],
			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => 'id'],

			[ LIMIT => "start, $_REQUEST{limit}"],

		],
		'log()',
		'users(label)'
	);


	return $data;

}

