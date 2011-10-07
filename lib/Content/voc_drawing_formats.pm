################################################################################

sub do_update_voc_drawing_formats {

	if ($_REQUEST {id} eq ':NEW') {
	
		$_REQUEST {id}   = sql_do_insert (voc_drawing_formats => {label => ''});	
#		$_REQUEST {uuid} = _get_uuid(); 
		
	}

	$_REQUEST {"_$_"} ||= $_REQUEST {$_} foreach keys %_REQUEST;

	$_REQUEST {label} or die '#label#:Некорректное наименование';
	
	vld_unique ('voc_drawing_formats', {field => 'label'}) or die "#label#:Формат с таким наименованием уже существует";

	do_update_DEFAULT ();

#	save_synchronize() if ($preconf -> {peer_master});

}

################################################################################

sub get_item_of_voc_drawing_formats {

	my $data = sql (voc_drawing_formats => $_REQUEST {id}, 'log(dt)', 'users(label)');

#	_get_log ($data);

	return $data;

}

################################################################################

sub select_voc_drawing_formats {

	sql ({}, voc_drawing_formats => [
		['label LIKE %?%' => $_REQUEST {q}],			
		[ LIMIT => 'start, 25'],		
	]);

}

1;