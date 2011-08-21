################################################################################

sub get_item_of_sessions {

	my $data = sql (sessions => $_REQUEST {id}, 'users');

	return $data;

}

1;
