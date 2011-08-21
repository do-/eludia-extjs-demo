################################################################################

sub get_item_of_users {

	my $data = sql (users => $_REQUEST {id});

	return $data;

}


################################################################################

sub select_users {

	sql (
	
		{},
		
		users => [

			['label LIKE %?%' => $_REQUEST {q}],
			
			[ LIMIT => 'start, 50'],
		
		],
					
	);
	
}

################################################################################

sub do_update_users {

	$_REQUEST {id} eq ':NEW' and $_REQUEST {id} = sql_do_insert (users => {label => ''});

	$_REQUEST {"_$_"} ||= $_REQUEST {$_} foreach keys %_REQUEST;

	$_REQUEST {label} or die '#label#:Некорректное имя';
	$_REQUEST {login} or die '#login#:Некорректный login';
	
	vld_unique ('users', {field => 'login'}) or die "#login#:Login '$_REQUEST{_login}' уже занят";
	
	if ($_REQUEST {_password}) {
	
		$_REQUEST {_password} = sql_select_scalar ('SELECT PASSWORD(?)', $_REQUEST {_password});
	
	}
	else {
	
		delete $_REQUEST {password};
	
	}
	
	do_update_DEFAULT ();

}

1;