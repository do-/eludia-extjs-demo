
################################################################################

sub get_item_of_users {

	my $data = sql (users => $_REQUEST {id});

	return $data;

}

################################################################################

sub select_users {

	darn sql ({},

		users => [

			['label LIKE %?%'  => $_REQUEST {q}],

			[ LIMIT => 'start, 25'],

		],

	);

}

1;
