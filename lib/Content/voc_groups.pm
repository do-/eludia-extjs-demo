################################################################################

sub do_update_voc_groups {

darn \%_REQUEST;

	$_REQUEST {"_$_"} ||= $_REQUEST {$_} foreach keys %_REQUEST;

	$_REQUEST {label} or die '#label#:������������ ������������';
	
	do_update_DEFAULT ();

}

################################################################################

sub do_delete_voc_groups {

	sql_do ('UPDATE voc_groups SET fake = -1 WHERE id = ?', $_REQUEST {id});

}

################################################################################

sub get_item_of_voc_groups {

	my $data = sql (voc_groups => $_REQUEST {id}, 'log(dt)', 'users(label)');

	return $data;

}

################################################################################

sub select_voc_groups {

	my @nodes = ();

	sql (voc_groups => [	
	
		[parent => $_REQUEST {node} || 0],	
	
		[ORDER  => 'ord_src'],		
	
	], sub {
	
		push @nodes, {		
			id   => $i -> {id},
			text => "$i->{ord_parent}$i->{ord_src} $i->{label}",			
			cls  => 'file',	
			leaf => \1,
		} 
	
	});
	
	my ($ids, $idx) = ids (\@nodes);
	
	sql ('voc_groups (parent, COUNT(*))' => [
	
		['parent IN   ' => $ids],
		
	], sub {

		my $node = $idx -> {$i -> {parent}};
	
		$node -> {cls}  = 'folder';
		
		$node -> {leaf} = \0;
		
	});
	
	return \@nodes;

}
