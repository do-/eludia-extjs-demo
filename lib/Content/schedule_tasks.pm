

################################################################################

sub do_delete_schedule_tasks {

	require_content ('tasks');

	my $error = validate_delete_tasks ();

	$error && out_json_and_die ({success => 'false', errorInfo => $error});

	out_json ({success => 'true', info => 'OK'});

	do_delete_tasks ();

}



################################################################################

sub do_create_schedule_tasks {

	my $schedule = sql (schedules => [[id => $_REQUEST {id_schedule} || -1]], "$conf->{systables}->{__queries}(dump) AS q");

	my $VAR1;

	eval $schedule -> {q} -> {dump};

	$_REQUEST {id} = __create_tasks ({
		id_task_type     => $VAR1 -> {filters} -> {task_type_ids},
#		label            => $_REQUEST {subject},
		dt_from_plan     => (delete $_REQUEST {dt_from_plan}) . ':00',
		dt_to_plan       => (delete $_REQUEST {dt_to_plan}) . ':00',
		id_user_executor => $VAR1 -> {filters} -> {id_user_executor},
	});

	$_REQUEST {type} = 'tasks';

}


################################################################################

sub do_add_schedule_tasks {


	$_REQUEST {subject} or out_json_and_die ({success => 'false', errorInfo => 'Вы забыли ввести описание задачи'});

	($_REQUEST {startDay} =~ /(\d+)-(\d+)-(\d+)/) or out_json_and_die ({success => 'false', errorInfo => 'Неверная дата начала'});
	($_REQUEST {endDay}   =~ /(\d+)-(\d+)-(\d+)/) or out_json_and_die ({success => 'false', errorInfo => 'Неверная дата завершения'});

	my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
	$_REQUEST {subject} = $converter -> convert ($_REQUEST {subject});


	my $schedule = sql (schedules => [[id => $_REQUEST {calendarId} || -1]], "$conf->{systables}->{__queries}(dump) AS q");

	my $VAR1;

	eval $schedule -> {q} -> {dump};

	$_REQUEST {id} = __create_tasks ({
		fake             => 0,
		id_task_type     => $VAR1 -> {filters} -> {task_type_ids},
		label            => $_REQUEST {subject},
		dt_from_plan     => $_REQUEST {startDay} . ' ' . $_REQUEST {startHMTime} . ':00',
		dt_to_plan       => $_REQUEST {endDay} . ' ' . $_REQUEST {endHMTime} . ':00',
		id_user_executor => $VAR1 -> {filters} -> {id_user_executor},
	});

	out_json ({success => 'true', info => 'OK', id => $_REQUEST {id}});


}

################################################################################

sub do_update_schedule_tasks {

#out_json_and_die ({success => 'false', errorInfo => 'Нельзя'});
	$_REQUEST {subject} or out_json_and_die ({success => 'false', errorInfo => 'Вы забыли ввести описание задачи'});

	($_REQUEST {startDay} =~ /(\d+)-(\d+)-(\d+)/) or out_json_and_die ({success => 'false', errorInfo => 'Неверная дата начала'});
	($_REQUEST {endDay}   =~ /(\d+)-(\d+)-(\d+)/) or out_json_and_die ({success => 'false', errorInfo => 'Неверная дата завершения'});

	my $data = sql_select_hash ('tasks');

	check_task_rights ($data);

	require_content ('tasks');
	task_dt_from_plan_read_only ($data) && out_json_and_die ({success => 'false', errorInfo => 'Изменение запрещено'});

	my $converter = Text::Iconv -> new ("utf-8", "windows-1251");
	$_REQUEST {subject} = $converter -> convert ($_REQUEST {subject});

	sql_do ('UPDATE tasks SET label = ?, dt_from_plan = ?, dt_to_plan = ? WHERE id = ?',
		$_REQUEST {subject},
		$_REQUEST {startDay} . ' ' . $_REQUEST {startHMTime} . ':00',
		$_REQUEST {endDay} . ' ' . $_REQUEST {endHMTime} . ':00',
		$_REQUEST {id},
	);


	out_json ({success => 'true', info => 'OK', id => $_REQUEST {id}});


}



################################################################################

sub get_item_of_schedule_tasks {

	my $data = {
		success => 0,
	};

	require_content ('tasks');

	local $_REQUEST {xls} = 1;

	my $schedules = sql (schedules => [
 			[id_user => $_USER -> {id}],
		],

		"$conf->{systables}->{__queries}(order_context) AS q"
	);
	local $_REQUEST {id_task_to_check} = $_REQUEST {id};

	foreach my $i (@$schedules) {

		local $_REQUEST {__order_context} = $i -> {q} -> {order_context};
		local $_REQUEST {id_filter}       = $i -> {id___query};
		local $_REQUEST {dt_to_plan}      = $_REQUEST {startDay};
		local $_REQUEST {dt_from_plan_to} = $_REQUEST {endDay};
		local $_REQUEST {skip_filter_names} = 'dt_to_plan,dt_from_plan_to';
		$_QUERY = undef;

		my $tasks = select_tasks ();

		foreach my $task (@{$tasks -> {tasks}}) {

			if ($data -> {event}) {

				push @{$data -> {event} -> {calendarIds}}, $i -> {id};

				next;

			}

			check_task_rights ($task);
			my $is_locked = task_dt_from_plan_read_only ($task) || task_dt_to_plan_read_only ($task) ? 1 : 0;


			my ($ymd, $startTime) = ($task -> {dt_from_plan} =~ /(.*) (\d+:\d+)/);
			my ($eymd, $endTime) = ($task -> {dt_to_plan} =~ /(.*) (\d+:\d+)/);

			$data -> {event} = {
				id          => $task -> {id},
				eventId     => $task -> {id},

				calendarId  => $i -> {id},
				calendarIds => [$i -> {id}],

				ymd         => $ymd,
				startTime   => $startTime,

				eymd        => $eymd,
				endTime     => $endTime,

				subject     => $task -> {label},
				repeatType  => 'no',

				locked      => $is_locked,
			};

			$data -> {success} = 'true';

		}
	}
#darn $data;
	out_json ($data);

}


################################################################################

sub select_schedule_tasks {


	my $data = {
		results => [],
		total   => 0,
	};

	require_content ('tasks');
	local $_REQUEST {xls} = 1;
	my $task_idx;
	sql (schedules => [
 			[id_user => $_USER -> {id}],
		],

		"$conf->{systables}->{__queries}(order_context) AS q",

		sub {

			local $_REQUEST {__order_context} = $i -> {q} -> {order_context};
			local $_REQUEST {id_filter} = $i -> {id___query};
			local $_REQUEST {skip_filter_names} = 'dt_to_plan,dt_from_plan_to';
			local $_REQUEST {dt_to_plan} = $_REQUEST {startDay};
			local $_REQUEST {dt_from_plan_to} = $_REQUEST {endDay};
			$_QUERY = undef;

			my $tasks = _select_tasks ();

			foreach my $task (@{$tasks -> {tasks}}) {

				if ($task_idx -> {$task -> {id}}) {
					push @{$task_idx -> {$task -> {id}} -> {calendarIds}}, $i -> {id};
					next;
				}

				check_task_rights ($task);
				my $is_locked = task_dt_from_plan_read_only ($task) || task_dt_to_plan_read_only ($task) ? 1 : 0;

				my ($ymd, $startTime) = ($task -> {dt_from_plan} =~ /(.*) (\d+:\d+)/);
				my ($eymd, $endTime) = ($task -> {dt_to_plan} =~ /(.*) (\d+:\d+)/);
				$task_idx -> {$task -> {id}} = {

					id          => $task -> {id},

					calendarId  => $i -> {id},
					calendarIds => [$i -> {id}],

					ymd         => $ymd,
					startTime   => $startTime,

					eymd        => $eymd,
					endTime     => $endTime,

					subject     => $task -> {label},
					repeatType  => 'no',

					locked      => $is_locked,
				};
				push @{$data -> {results}}, $task_idx -> {$task -> {id}};

				$data -> {total} ++;
			}
		}
	);
#darn $data;
	out_json ($data);

}


1;
