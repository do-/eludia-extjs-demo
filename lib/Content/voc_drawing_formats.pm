################################################################################

sub do_update_voc_drawing_formats {

	$_REQUEST {_label} or die '#_label#:Некорректное наименование';
	
	vld_unique ('voc_drawing_formats', {field => 'label'}) or die "#label#:Формат с таким наименованием уже существует";

	do_update_DEFAULT ();

}

################################################################################

sub get_item_of_voc_drawing_formats {

	sql (voc_drawing_formats => $_REQUEST {id}, 'log(dt)', 'users(label)');

}

################################################################################

sub select_voc_drawing_formats {

	sql ({}, voc_drawing_formats => [
		['label LIKE %?%' => $_REQUEST {q}],			
		[ LIMIT => 'start, 25'],		
	]);

}

1;
