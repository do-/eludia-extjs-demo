################################################################################

sub do_execute_logon {

	$_REQUEST {login} or die "#login#:�� ������ ������ login";

	my $id_user = sql ('users(id)' => ['login', [LIMIT => 1]]) or die "#login#:������ ������������ � �� �� ����������";

	$id_user = sql ('users(id)' => [
	
		'login',		
		
		['password IN (PASSWORD(?), OLD_PASSWORD(?))' => [$_REQUEST {password}, $_REQUEST {password}]],
		
		[LIMIT => 1]
		
	]) or die "#password#:��������, �� �������� ��� ����� ������";

	start_session ($id_user);
	
	redirect ("/?type=sessions&id=$_REQUEST{sid}&sid=$_REQUEST{sid}", {kind => 'js'});

}

1;
