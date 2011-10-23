
################################################################################

sub get_item_of_products {

	my $data = sql (products => $_REQUEST {id}, 'log(dt)', 'users(label)');

	return $data;

}

################################################################################

sub select_products {

	sql ({}, products => [
		['id_voc_group IN' => $_REQUEST {id_voc_group}],
		['label LIKE %?%'  => $_REQUEST {q}],			
		[ LIMIT => 'start, 25'],		
	], 'voc_product_types', 'voc_units', 'voc_groups', 'voc_product_status');

}


1;
