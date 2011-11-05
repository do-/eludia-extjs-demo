
################################################################################

sub get_item_of_products {

	my $data = sql (products => $_REQUEST {id}, 'log(dt)', 'users(label)');

	return $data;

}

################################################################################

sub select_products {

	sql ({},
	
		products => [
		
			'in_list',
	
			['id_voc_group IN' => $_REQUEST {tree} ? [sql_select_subtree (voc_groups => $_REQUEST {id_voc_group})] : $_REQUEST {id_voc_group}],
			['label LIKE %?%'  => $_REQUEST {q}],			
			['name  LIKE %?%'  => $_REQUEST {name}],
			
			['id_voc_product_status' => $_REQUEST {'id_voc_product_status[]'}],
			['id_voc_product_type'   => $_REQUEST {'id_voc_product_type[]'}],
			['id_voc_unit'           => $_REQUEST {'id_voc_unit[]'}],
					
			['short_label          LIKE %?%' => $_REQUEST {short_label}],
			['gost_ost_tu          LIKE %?%' => $_REQUEST {gost_ost_tu}],
			['part_size            LIKE %?%' => $_REQUEST {part_size}],
			['primary_application  LIKE %?%' => $_REQUEST {primary_application}],
			['product              LIKE %?%' => $_REQUEST {product}],

			['weight BETWEEN ? AND ?' => [$_REQUEST {weight_from}, $_REQUEST {weight_to}]],
						
			[ LIMIT => 'start, 25'],
		
		], [-voc_groups => ['ord_src']], 'voc_product_types', 'voc_units', 'voc_product_status'
		
	);

}


1;
