
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
		['name  LIKE %?%'  => $_REQUEST {name}],
				
		['short_label          LIKE %?%' => $_REQUEST {short_label}],
		['gost_ost_tu          LIKE %?%' => $_REQUEST {gost_ost_tu}],
		['part_size            LIKE %?%' => $_REQUEST {part_size}],
		['primary_application  LIKE %?%' => $_REQUEST {primary_application}],
					
		[ LIMIT => 'start, 25'],
		
	], 'voc_product_types', 'voc_units', 'voc_groups', 'voc_product_status');

}


1;
