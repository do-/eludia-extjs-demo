################################################################################

sub select_voc_groups {

	my @nodes = ();

	sql (voc_groups => [	
	
		[parent => $_REQUEST {node} || 0],	
	
		[ORDER  => 'ord_src'],		
	
	], sub {
	
		push @nodes, {		
			id   => $i -> {id},
			text => $i -> {label},			
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
