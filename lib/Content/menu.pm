################################################################################

sub select_menu {

	unless ($DB_MODEL -> {static_dumped}) {
	
		my @params = ();
		
		while (my ($name, $table) = each %{$DB_MODEL -> {tables}}) {	
			my $options = $table -> {static} or next;
			ref $options eq HASH or $options = {};
			push @params, $name, $options;	
		}

		voc_static (@params);
		
		$DB_MODEL -> {static_dumped} = 1;
		
	}
	
	return [];

}

1;
