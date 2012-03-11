################################################################################

sub do_update_voc_units {

	$_REQUEST {_label} or die '#_label#:Некорректное наименование';
	
	vld_unique ('voc_units', {field => 'label'}) or die "#_label#:Единица с таким наименованием уже существует";
	!$_REQUEST {_code_okei} or vld_unique ('voc_units', {field => 'code_okei'}) or die "#_code_okei#:Единица с таким кодом уже существует";

	do_update_DEFAULT ();
	
	sql_do ('UPDATE voc_unit_coeffs SET id_product = 0 WHERE id_product IS NULL');
	
	my @a = ();	
	
	foreach my $k (keys %_REQUEST) {
	
		$k =~ /^_unit_(\d+)$/ or next;
		
		my $v = $_REQUEST {$k} or next;
		
		push @a, {
			id_unit_to   => $1,
			coeff        => $v,	
			id_log       => $_REQUEST {_id_log},
			fake         => 0,
		};		
	
	}
	
	wish (table_data => darn \@a, {
	
		table => 'voc_unit_coeffs',
		root  => {
			id_unit_from => $_REQUEST {id},
			id_product   => 0,
		},
		key   => 'id_unit_to',
	
	});

}

################################################################################

sub get_item_of_voc_units {

	my $data = sql (voc_units => $_REQUEST {id}, 'log(dt)', 'users(label)');
	
	sql ($data, 'voc_units(id,label)' => [['id <>' => $data -> {id}]],

		['voc_unit_coeffs(coeff) ON voc_unit_coeffs.id_unit_to = voc_units.id' => [
			[id_unit_from    => $data -> {id}],
			[fake            => 0],
			['id_product...' => 0],
		]],
	
	);

	return $data;

}

################################################################################

sub select_voc_units {

	sql ({}, voc_units => [
		['label LIKE %?%' => $_REQUEST {q}],
		[ LIMIT => 'start, 25'],
		[ ORDER => ($_REQUEST {order} || 'label') . ' ' . ($_REQUEST {desc} ? 'DESC' : 'ASC')],
	]);

}

1;
