
################################################################################

sub get_item_of_product_structures {

	my $data = {
		id => $_REQUEST {id},
	};
	my $filter = '';
	my @params = ();


	if ($_REQUEST {q}) {
		$filter .= " AND (product_specs.position LIKE ? OR products.full_name LIKE ? OR products.label LIKE ?)";
		push @params, '%' . $_REQUEST {q} . '%', '%' . $_REQUEST {q} . '%', '%' . $_REQUEST {q} . '%';
	}

 	my ($dy, $dm, $dd) = Date::Calc::Today;
	my $today = sprintf ("%02d.%02d.%04d", $dd, $dm, $dy);
	$_REQUEST {dt} ||= $today;

	if ($_REQUEST {to_dt} && $_REQUEST {dt} =~ /(\d{1,2})\.(\d\d)\.(\d\d\d\d)/) {
		my $dt = sprintf ("%4d-%02d-%02d", $3, $2, $1);
		$filter .= " AND ('$dt' < product_specs.dt_to OR product_specs.dt_to IS NULL)";
		$filter .= " AND product_specs.dt_from <= '$dt' ";
	}

	if ($_REQUEST {id_voc_product_type}) {
		$filter .= " AND products.id_voc_product_type = ? ";
		push @params, $_REQUEST {id_voc_product_type};
	}

	if ($_REQUEST {id_voc_product_type_specs}) {
		$filter .= " AND product_specs.id_voc_product_type = ? ";
		push @params, $_REQUEST {id_voc_product_type_specs};
	}

	my $start = $_REQUEST {start} + 0;
	$data -> {portion} = $_REQUEST {limit} + 0;

	($data -> {product_structures}, $data -> {cnt}) = sql_select_all_cnt (<<EOS, $data -> {id}, @params, {fake => 'product_specs'});
		SELECT
			product_specs.*
			, products.id AS id_label
			, products.precision_production
  			, products.short_label
  			, products.is_rolled_metal
  			, products.name
  			, products.part_size
  			, products.gost_ost_tu
			, voc_product_types.label AS product_type_label
			, products.label AS product_label
			, products.full_name AS product_name
			, voc_units.label AS voc_unit_label
			, voc_product_type_spec.label AS product_type_spec_label
			, voc_drawing_formats.label AS voc_drawing_format_label
			, voc_drawing_formats.is_multiple_pages AS voc_drawing_format_is_multiple_pages
			, product_structures_doc_types.id AS id_product_structures_doc_type
			, voc_product_type_kit_kinds.label AS voc_product_type_kit_kind_label
		FROM
			product_specs
			INNER JOIN products ON products.id = product_specs.id_product_subproduct
			LEFT JOIN voc_units ON voc_units.id = product_specs.id_voc_unit
			LEFT JOIN voc_product_types ON products.id_voc_product_type = voc_product_types.id
			LEFT JOIN voc_drawing_formats ON products.id_voc_drawing_format = voc_drawing_formats.id
			LEFT JOIN voc_product_types voc_product_type_spec ON voc_product_type_spec.id = product_specs.id_voc_product_type
			LEFT JOIN product_structures_doc_types ON
				LENGTH(products.short_label) > 1
				AND
				(product_specs.id_voc_product_type = 8 OR product_specs.id_voc_product_type = 11 AND products.id_voc_product_type = 8)
				AND
				RIGHT(products.short_label, LENGTH(product_structures_doc_types.code)) LIKE product_structures_doc_types.code
				AND
				IF(RIGHT(product_structures_doc_types.code, 1) = '_', RIGHT(products.short_label, 1) + 0 LIKE RIGHT(products.short_label, 1), 1)
			LEFT JOIN voc_product_type_kit_kinds ON product_specs.id_voc_product_type_kit_kind = voc_product_type_kit_kinds.id
		WHERE
			product_specs.id_product_parent = ?
			AND IFNULL(product_specs.id_product_production, 0) = 0
			$filter
		ORDER BY
			voc_product_type_spec.ord, product_specs.position
		LIMIT
			$start, $$data{portion}
EOS


# 	my $product_ids = ids ($data -> {product_specs}, {field => 'id_product_subproduct'});
# 	my $product_spec_ids = ids ($data -> {product_specs}, {});

# 	$data -> {alts_cnt} = sql_select_all (<<EOS);
# 		SELECT
# 			id_product
# 			, id_product_spec
# 		FROM
# 			product_alternatives
# 		WHERE
# 			fake = 0
# 			AND (
# 				id_voc_alternative_substitute_type = 1
# 				AND id_product IN ($product_ids)
# 			OR
# 				id_voc_alternative_substitute_type = 2
# 				AND id_product_spec IN ($product_spec_ids)
# 			)
# EOS

# 	foreach my $product_spec (@{$data -> {product_specs}}) {
# 		$product_spec -> {has_alternatives} = grep {$_ -> {id_product_spec} == $product_spec -> {id} || $_ -> {id_product} == $product_spec -> {id_product_subproduct}} @{$data -> {alts_cnt}};
# 	}


	return $data;

}


