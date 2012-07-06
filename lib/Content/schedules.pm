

################################################################################

sub do_delete_schedules {


	my $data = sql_select_hash ('schedules');

	$data -> {id_user} == $_USER -> {id} || out_json_and_die ({success => 'false', errorInfo => 'Нельзя удалять чужой календарь'});

	sql_do ("UPDATE schedules SET fake = -1 WHERE id = ?", $_REQUEST {id});

	out_json ({success => 'true', info => 'OK'});

#	esc ();

}



################################################################################

sub do_update_schedules {

	$_REQUEST {id___query} ||= $_REQUEST {name};

	$_REQUEST {id___query} or out_json_and_die ({success => 'false', errorInfo => 'Вы забыли наименование календаря'});

	my $__query = sql_select_hash ($conf -> {systables} -> {__queries} => $_REQUEST {id___query});
	$__query -> {id} && (!$__query -> {id_user} || $__query -> {id_user} == $_USER -> {id}) || out_json_and_die ({success => 'false', errorInfo => 'Выбрано неверное наименование календаря'});

	my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
	$_REQUEST {description} = $converter -> convert ($_REQUEST {description});
	$_REQUEST {is_hidden} = $_REQUEST {hide} eq 'true';

	if ($_REQUEST {id}) {

		my $schedule = sql_select_hash (schedules => $_REQUEST {id});

		$schedule -> {id_user} == $_USER -> {id} || out_json_and_die ({success => 'false', errorInfo => 'Отсутствуют права на изменение'});

		sql_do ('UPDATE schedules SET label = ?, id___query = ?, color = ?, description = ?, is_hidden = ? WHERE id = ?', $__query -> {label}, $__query -> {id}, $_REQUEST {color}, $_REQUEST {description}, $_REQUEST {is_hidden}, $_REQUEST {id});

	} else {
		vld_unique (schedules => {
			field  => 'id___query',
			value  => $_REQUEST {id___query},
			filter => "id_user = $_USER->{id}",
		}) || out_json_and_die ({success => 'false', errorInfo => 'У Вас уже подключен выбранный календарь'});

		$_REQUEST {id} = sql_do_insert (schedules => {
			fake         => 0,
			id_user      => $_USER -> {id},
			label        => $__query -> {label},
			id___query   => $__query -> {id},
			color        => $_REQUEST {color},
			description  => $_REQUEST {description},
			is_hidden    => $_REQUEST {is_hidden},
		});
	}

	out_json ({success => 'true', id => $_REQUEST {id}});

}



################################################################################

sub select_schedules {


	my $data = {};
	my $cs = sql_select_scalar ('SELECT settings FROM schedule_settings WHERE fake = 0 AND id_user = ?', $_USER -> {id});
	
	if ($cs) {

		$data -> {cs} = $_JSON -> decode ($cs);

	} else {

		require_content ('schedule_settings');
		$data -> {cs} = __set_default_schedule_settings ();
		
		require_content ('schedule___queries');
		__add_personal_schedule___queries ();
		
	}

	sql (
	
		add_vocabularies ($data,
#			users => {},
		),
		
		schedules => [
	
			[id_user => $_USER -> {id}],
			

		],
			
	);
	
#	my $converter = Text::Iconv -> new ("windows-1251", "utf-8");
	
	my $response = {
		cs     => [$data -> {cs}],
		owned  => [
			map {
				{
					id          => $_ -> {id},
					id___query  => $_ -> {id___query},
#					name        => $converter -> convert ($_ -> {label}),
					name        => $_ -> {label},
					color       => $_ -> {color},
					description => $_ -> {description},
					hide        => $_ -> {is_hidden} ? $_JSON -> true : $_JSON -> false,
				},
			} @{$data -> {schedules}}
		],
		shared => [
		],
		re     => [
		],
	};


	out_json ($response);
	

}


1;
