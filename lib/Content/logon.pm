################################################################################

sub do_execute_logon {

	$_REQUEST {login} or die "#login#:Âû çàáûëè ââåñòè login";

	my $id_user = sql ('users(id)' => ['login', [LIMIT => 1]]) or die "#login#:Òàêîãî ïîëüçîâàòåëÿ â ÁÄ íå îáíàğóæåíî";

	my $user = sql ('users(id)' => [
	
		'login',		
		
		['password IN (PASSWORD(?), OLD_PASSWORD(?))' => [$_REQUEST {password}, $_REQUEST {password}]],
		
		[LIMIT => 1]
		
	], 'sessions ON sessions.id_user = users.id')
	
	or die "#password#:Âåğîÿòíî, Âû îøèáëèñü ïğè ââîäå ïàğîëÿ";

	$_REQUEST {sid} = $user -> {session} -> {id} or start_session ($id_user);
	
	our $_USER = sql (users => $id_user);
	
	redirect ("/?type=sessions&id=$_REQUEST{sid}&sid=$_REQUEST{sid}", {kind => 'js'});

}

1;
