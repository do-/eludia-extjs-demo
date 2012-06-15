
################################################################################

sub do_update_doc_folders {

	$_REQUEST {"_$_"} ||= $_REQUEST {$_} foreach keys %_REQUEST;

	$_REQUEST {label} or die '#label#:Некорректное наименование';

	do_update_DEFAULT ();

}

################################################################################

sub do_delete_doc_folders {

	my $data = sql (doc_folders => $_REQUEST {id});

	sql_do ('UPDATE doc_folders SET fake = -1 WHERE id = ?', $_REQUEST {id});

	redirect ("/handler?type=doc_folders&id=$data->{parent}&sid=$_REQUEST{sid}");

}

################################################################################

sub get_item_of_doc_folders {

	local $conf -> {core_sql_flat} = 1;

	my $data = sql (doc_folders => $_REQUEST {id}, 'doc_folders AS rights_holder ON doc_folders.id_rights_holder');

	return $data;

}

################################################################################

sub select_doc_folders {

	my @nodes = ();

	sql (doc_folders => [	

		[parent => $_REQUEST {node} || 0],	

		[ORDER  => 'label'],		

	], sub {

		push @nodes, {		
			id   => $i -> {id},
			text => "$i->{label}",			
			cls  => 'file',	
			leaf => \1,
		}

	});

	my ($ids, $idx) = ids (\@nodes);

	sql ('doc_folders (parent, COUNT(*))' => [

		['parent IN   ' => $ids],

	], sub {

		my $node = $idx -> {$i -> {parent}};

		$node -> {cls}  = 'folder';

		$node -> {leaf} = \0;

	});

	return \@nodes;

}

1;
