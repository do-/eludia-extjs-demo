
################################################################################

sub get_item_of_users {

	my $data = sql (users => $_REQUEST {id});

	return $data;

}

################################################################################

sub select_users {

	$_REQUEST {_id} += 0;
	$_REQUEST {_id} ||= -1;

	sql ({},

		users => [

			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => "id <> $_REQUEST{_id}, label" ],

			[ LIMIT => 'start, 25'],

		],

	);

}

1;
