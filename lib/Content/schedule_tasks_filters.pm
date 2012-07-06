

################################################################################

sub validate_delete_schedule_tasks_filters {


	return validate_delete_tasks_filters ();

}

################################################################################

sub do_delete_schedule_tasks_filters {

	sql_do ("UPDATE $conf->{systables}->{__queries} SET fake = -1 WHERE id = ?", $_REQUEST {id});
	
	dialog_close ();

}



################################################################################

sub validate_apply_schedule_tasks_filters { # применяет и сохраняет фильтр
	
	$_REQUEST {_setting__label} or return '#_setting__label#: Укажите название фильтра';

	undef;
}

################################################################################

sub do_apply_schedule_tasks_filters { # применение фильтров (редирект на экран задач)

	require_content ('tasks_filters');

	$_REQUEST {"_label_ord"} = 1
		unless exists $_REQUEST {"_label_ord"};

	my $error = _tasks_filters_update_task_filter ();
darn $error;
	if ($error) {
		$_REQUEST {__redirect_alert} = $error;
		return;
	}
	

	dialog_close ({
		id    => $_REQUEST {id},
		label => $_REQUEST {_setting__label},
	});

}

################################################################################

sub validate_make_public_schedule_tasks_filters {
	
	$_USER -> {options_hash} -> {admin} || $_USER -> {options_hash} -> {admin_docflow}
		or return 'Общие фильтры может создавать только администратор';

	$_REQUEST {_setting__label} or return '#_setting__label#: Укажите название фильтра';

	undef;
}

################################################################################

sub do_make_public_schedule_tasks_filters { # публикует пользовательский фильтр для всех пользователей

	require_content ('tasks_filters');

	do_make_public_tasks_filters ();

	sql_do ("UPDATE $conf->{systables}->{__queries} SET label = ? WHERE id = ?", $_REQUEST {_setting__label}, $_REQUEST {id});

}



################################################################################

sub get_item_of_schedule_tasks_filters {

	require_both ('tasks_filters');

	local $_REQUEST {__order_context} = 'type=schedule';
	my $data = get_item_of_tasks_filters ();

	$data -> {schedule} = sql (schedules => [
		[id___query   => $data -> {id}],
		[id_user      => $_USER -> {id}],
		[LIMIT        => 1],
	]);

	$_REQUEST {__read_only} = $data -> {schedule} -> {is_personal};

	return $data;

}

################################################################################

sub select_schedule_tasks_filters {

	my $data = {};

	local $conf -> {portion} = $_REQUEST {limit} || $conf -> {portion};

	sql ($data,
		$conf -> {systables} -> {__queries} => [
			['IFNULL(id_user,0) IN' => [0, $_USER -> {id}]],
			[order_context       => $_REQUEST {order_context}],
			[type                => 'tasks'],
			['label LIKE %?%'    => $_REQUEST {q}],
			# пропускаем записи с пустым именем, созданные стандартным механизмом фильтрации
			['label LIKE %?%'       => '_'],
			['label <> ?'           => 'default'],
			[ LIMIT => [0 + $_REQUEST {start}, $conf -> {portion}]],
		],
		'users',
	);

	out_json ([
		map {{
			id         => $_ -> {id},
			label      => $_ -> {label},
			user_label => $_ -> {user} -> {label} || '[для всех]',
		}} @{$data -> {__queries}}
	]);
	

}


1;
