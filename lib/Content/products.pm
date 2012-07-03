################################################################################

sub get_item_of_products {

	my $data = sql (products => $_REQUEST {id}, 'log(dt)', 'users(label)');

	_add_user_fields_products ($data);

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

################################################################################

sub _add_user_fields_products {

        my ($data) = @_;

        my $id_voc_group = $data -> {id_voc_group};
        $data -> {groups} = [$id_voc_group];

        while (TRUE) {
                $id_voc_group = sql_select_scalar (
                        'SELECT parent FROM voc_groups WHERE id = ?'
                        , $id_voc_group
                );

                last unless $id_voc_group;

                push @{$data -> {groups}}, $id_voc_group;
        }

        my $ids_product_field_groups = sql('voc_groups_product_field_groups(id_product_field_group)' => [
                [id_voc_group => $data -> {groups}],
        ]);

	# TODO: прив€зать только доп пол€ групп номенклатуры

        add_vocabularies ($data
                , voc_brands     => {}
                , voc_good_kinds => {}
                , voc_good_types => {}
        );
}

1;
