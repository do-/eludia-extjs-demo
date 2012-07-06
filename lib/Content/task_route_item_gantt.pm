

################################################################################

sub select_task_route_item_gantt {

	my $data = {
		id_doc_type => $_REQUEST {id_doc_type},
		id_type     => $_REQUEST {id_type},
	};
	
	$data -> {task_route_items} = sql_select_all (<<EOS, $_REQUEST {id_doc_type}, $_REQUEST {id_type});
		SELECT DISTINCT
			task_routes.label
			, task_route_items.id
			, task_route_items.id_task_route_item_status
			, task_route_items.id_task_route
			, task_route_items.dt_start
			, task_route_items.dt_finish
		FROM
			tasks
			INNER JOIN task_route_items ON tasks.id_task_route_item = task_route_items.id
			INNER JOIN task_routes ON task_route_items.id_task_route = task_routes.id
		WHERE
			tasks.fake = 0
		AND
			tasks.id_doc_type = ?
		AND
			tasks.id_type = ?
		ORDER BY
			task_route_items.dt_start DESC	
EOS

	$_REQUEST {id_task_route_item} ||= $data -> {task_route_items} -> [0] -> {id};
	
	$data -> {task_route_item} = (grep {$_ -> {id} == $_REQUEST {id_task_route_item}} @{$data -> {task_route_items}}) [0];

	return $data
		unless $data -> {task_route_item} -> {id};
		

	sql (
		$data,
		
		'tasks(id, id_user_executor, id_task_route_task, id_task_status, id_preceding_task, group_task_no, prefix, no, dt, label, dt_from_plan, dt_to_plan, dt_from_fact, dt_to_fact, TO_DAYS(CASE WHEN tasks.dt_to_fact IS NULL THEN NOW() ELSE tasks.dt_to_fact END) - TO_DAYS(dt_to_plan) AS deviation)' => [
			[id_task_route_item => $_REQUEST {id_task_route_item}],
			[ORDER              => 'dt_to_fact',],
		],
		
		'users AS user_initiators',
		'users AS user_executors',
		'workgroups AS workgroup_executors',
		'users AS user_inspectors',
		
		'task_types',
		'task_status',
		'task_importances',
		'task_route_task_results',
	);
	
	my $ids = ids ($data -> {tasks});
	
	do {
	
		my $children = sql (
			'tasks(id, id_user_executor, id_task_route_task, id_task_status, parent AS id_preceding_task, group_task_no, prefix, no, dt, label, dt_from_plan, dt_to_plan, dt_from_fact, dt_to_fact, TO_DAYS(CASE WHEN tasks.dt_to_fact IS NULL THEN NOW() ELSE tasks.dt_to_fact END) - TO_DAYS(dt_to_plan) AS deviation)' => [
				['parent IN' => $ids],
			],
		);
		
		push @{$data -> {tasks}}, @$children;
		
		$ids = ids ($children);
		
	} while (@$children);
	
	
#darn $data -> {tasks};
#warn @{$data -> {tasks}}, "\n", $data -> {task_route_item} -> {id_task_route_item_status} == 1;


	if (@{$data -> {tasks}} && $data -> {task_route_item} -> {id_task_route_item_status} == 1) {
	
# Первая задача в процессе имеет типы задач (task_route_task) и не имеет предшественника
		my $start_task = (grep {$_ -> {id_task_route_task} && !$_ -> {id_preceding_task}} @{$data -> {tasks}}) [0];
darn $start_task;

# Использованные типы задач при определении будущих путей использовать не будем
		my %task_route_task_used_ids =
			map {($_ -> {id_task_route_task} => 1)}
			grep {$_ -> {id_task_route_task}}
			@{$data -> {tasks}};
		
		my $task_route_tasks = sql (task_route_tasks => [
				[id_task_route => $data -> {task_route_item} -> {id_task_route}],
				['id NOT IN' => [keys %task_route_task_used_ids]],
				[ORDER       => 'no'],
			],
			'task_types',

			'users AS user_executors ON task_route_tasks.is_executor_is_role = 0 AND task_types.is_multiple_executors = 0 AND task_route_tasks.id_user_executor = user_executors.id',

			'workgroups AS workgroup_executors ON task_route_tasks.is_executor_is_role = 0 AND task_types.is_multiple_executors <> 0 AND task_types.is_multiple_executors <> 2 AND task_route_tasks.id_workgroup_executor = workgroup_executors.id',
			
			'task_route_task_users ON task_route_tasks.is_executor_is_role = 0 AND task_types.is_multiple_executors = 2 AND task_route_task_users.id_task_route_task = task_route_tasks.id',
			'users AS task_route_task_user_executors ON task_route_task_users.id_user_executor',
			
			'task_route_roles AS task_route_role_executors ON (task_route_tasks.is_executor_is_role = 1 OR task_route_tasks.is_executor_is_role = 2) AND task_route_tasks.id_task_route_role_executor = task_route_role_executors.id',
			
			
			'workgroups AS workgroup_inspectors ON task_route_tasks.is_inspector_is_role = 0 AND task_route_tasks.id_workgroup_inspector = workgroup_inspectors.id',
			'task_route_roles AS task_route_role_inspectors ON task_route_tasks.is_inspector_is_role = 1 AND task_route_tasks.id_task_route_role_inspector = task_route_role_inspectors.id',
			
			'users AS user_inspectors ON task_route_tasks.is_inspector_is_role = 0 AND task_route_tasks.id_user_inspector = user_inspectors.id',
		);
	
# Т.к. id в tasks и task_route_task могут совпадать, инвертируем id,
# а чтобы task_route_task был похож на tasks, устанавливаем id_task_route_task
# Таким образом в id_task_route_task - оригинальное значение id, а в id - инвертированное
		map {$_ -> {id} = -($_ -> {id_task_route_task} = $_ -> {id})} @{$task_route_tasks};
		
# Связи между типами задач будем выбирать те, в которых источник - выполняющиеся задачи
# (не завершённые, т.е. это текущее состояние процесса)
# или типы задач, которые не использовались
		my %task_route_task_src = map {($_ -> {id_task_route_task} => 1)}
			grep {!$task_route_task_used_ids {$_ -> {id_task_route_task}}}
			@{$task_route_tasks};
#darn \%task_route_task_src;
		map {$task_route_task_src {$_ -> {id_task_route_task}} = 1}
			grep {$_ -> {id_task_route_task} && $_ -> {id_task_status} < 4}
			@{$data -> {tasks}};
#darn \%task_route_task_src;
# Дуги графа формируем из задач, которые уже выполнились + связок между типами задач
		my $task_route_task_binds = sql (task_route_task_binds => [
				[id_task_route_task_src          => [keys %task_route_task_src]],
			],
			'task_route_task_results(id, is_default_result, label)',
		);
		
# Формируем узлы графа
		push @{$data -> {tasks}}, @$task_route_tasks;
		
# Формируем матрицу переходов
# В качестве идентификаторов будем использовать id задач и инвертированные id типов задач
# Используются следующие веса:
#	1 - данный переход уже совершен.
#	10 - задача в статусе 'Подтвердить выполнение', известен результат задачи
#	50 - данный переход отмечен "по умолчанию",
#	100_000 - duration_days * 24 - duration_hours - другие переходы
#	100_000_000_000 - бесконечность
		my $INFINITY = 100_000_000_000;
		my $transitions;
		my ($ids, $idx) = ids ($data -> {tasks});

		foreach my $task (@{$data -> {tasks}}) {
		
			next
				unless $task -> {id_task_route_task};
		
			if ($task -> {id_task_status} == 4) {
				
				foreach my $next_task (@{$data -> {tasks}}) {
					next
						unless $task -> {id} == $next_task -> {id_preceding_task};
						
					$transitions -> {$task -> {id}} -> {$next_task -> {id}} = 1;
				}
				
			} elsif ($task -> {id_task_status} == 3 && $task -> {id_task_route_task_result}) {
				
				foreach my $next_task_route_task (@$task_route_task_binds) {
				
					next
						unless $task -> {id_task_route_task} == $next_task_route_task -> {id_task_route_task_src}
							&&
							$task -> {id_task_route_task_result} == $next_task_route_task -> {id_task_route_task_result};

				
					$transitions -> {$task -> {id}} -> {$next_task_route_task -> {id}} = 10;
					
				}

			} else {

				foreach my $next_task_route_task (@$task_route_task_binds) {

# Существует такой тип задачи (не удалён)
					my $next_task = $idx -> {- $next_task_route_task -> {id_task_route_task_dst}};

					next
						unless $task -> {id_task_route_task} == $next_task_route_task -> {id_task_route_task_src} && $next_task -> {id};
						

					$transitions -> {$task -> {id}} -> {- $next_task_route_task -> {id_task_route_task_dst}} =
						$next_task_route_task -> {task_route_task_result} -> {is_default_result} ? 50 :
							exists $transitions -> {$task -> {id}} -> {- $next_task_route_task -> {id_task_route_task_dst}} && $transitions -> {$task -> {id}} -> {- $next_task_route_task -> {id_task_route_task_dst}} < 100_000 - $next_task -> {duration_days} - $next_task -> {duration_hours} ? $transitions -> {$task -> {id}} -> {- $next_task_route_task -> {id_task_route_task_dst}} :
								100_000 - $next_task -> {duration_days} - $next_task -> {duration_hours};
					;

				}
				
				my $is_exist_default_routes = grep {$transitions -> {$task -> {id}} -> {$_} == 50} keys (%{$transitions -> {$task -> {id}}});
				
				if ($is_exist_default_routes) {
					foreach my $id (keys (%{$transitions -> {$task -> {id}}})) {
						delete $transitions -> {$task -> {id}} -> {$id}
							if $transitions -> {$task -> {id}} -> {$id} > 50;
					}
				}



			}
			
		}
darn $data -> {tasks};
darn $transitions;		
		
# Алгоритм Дейкстры
		map {
			$_ -> {_distance} = $INFINITY
				unless $_ -> {id} == $start_task -> {id}
		} @{$data -> {tasks}};

		my $current_task = $start_task;
		
		do {
		
			foreach my $id_next_task (keys (%{$transitions -> {$current_task -> {id}}})) {

				my $next_task = $idx -> {$id_next_task};
				
				if (!$next_task -> {_is_permanent}) {
	
					my $distance = $current_task -> {_distance} + $transitions -> {$current_task -> {id}} -> {$id_next_task};
					
					if ($next_task -> {_distance} > $distance) {

						$next_task -> {_distance} = $distance;
						$next_task -> {id_preceding_task} = $current_task -> {id};
						
#						unless ($next_task -> {id_task_status}) {
#							$next_task -> {dt_from_plan} = $current_task -> {dt_to_fact} ||
#								$current_task -> {dt_to_plan};
#								
#							my ($year, $month, $day, $hour, $min, $sec) = split (/\D+/, $next_task -> {dt_from_plan});
#							
#							$next_task -> {dt_to_plan} = sprintf ("%04i-%02i-%02i %02i:%02i:%02i", Add_Delta_DHMS ($year, $month, $day, $hour, $min, $sec, $next_task -> {duration_days}, $next_task -> {duration_hours}, 0, 0));
#							
#							$next_task-> {deviation} = $next_task -> {dt_to_plan} gt $today ? '' :
#								Delta_Days (Today, Add_Delta_Days ($year, $month, $day, $next_task -> {duration_days}));
#						}



					}
					
				}
				
			}
			
			$current_task -> {_is_permanent} = 1;
			
			$current_task = undef;
			
			my $min_distance = $INFINITY;
			
			foreach my $task (@{$data -> {tasks}}) {
				if (!$task -> {_is_permanent} && $task -> {_distance} < $min_distance) {
					$min_distance = $task -> {_distance};
					$current_task = $task;
				}
			}
		} while $current_task;
		
# Возможно, в выборку попали задачи, которые не имеют родителя
		$data -> {tasks} = [grep {$_ -> {id_preceding_task} || $_ -> {id} == $start_task -> {id}} @{$data -> {tasks}}];

darn $transitions;

# Если в опциях типа задачи указано "До инициации ожидать завершения всех предыдущих по процессу задач",
# то пройдёмся по связям и перецепим ветку на самую задачу, которая выполнится позже всех предшествующих данной
		foreach my $task (@{$data -> {tasks}}) {
		
			if ($task -> {is_prev_tsks_done_bfre_this}) {

				foreach my $id_task_route_task_src (keys %$transitions) {
				
					foreach my $id_task_route_task_dst (keys %{$transitions -> {$id_task_route_task_src}}) {
					
						if ($id_task_route_task_dst == $task -> {id}) {
						
#							if ($idx -> {$id_task_route_task_src} -> {dt_to_plan} gt $task -> {dt_from_plan}) {
#							
#								$task -> {id_preceding_task} = $id_task_route_task_src;
#								$task -> {dt_from_plan} = $idx -> {$id_task_route_task_src} -> {dt_to_plan};
#								
#								my ($year, $month, $day, $hour, $min, $sec) = split (/\D+/, $task -> {dt_from_plan});
#								
#								$task -> {dt_to_plan} = sprintf ("%04i-%02i-%02i %02i:%02i:%02i", Add_Delta_DHMS ($year, $month, $day, $hour, $min, $sec, $task -> {duration_days}, $task -> {duration_hours}, 0, 0));
#								
#								$task-> {deviation} = $task -> {dt_to_plan} gt $today ? '' :
#									Delta_Days (Today, Add_Delta_Days ($year, $month, $day, $task -> {duration_days}));
#									
#							}
						}
						
					}
				}
			}
		}

	
	}

#darn $data -> {tasks};

	my $other_doc_tasks = sql (
		'tasks(id, id_user_executor, id_task_route_task, id_task_status, group_task_no, prefix, no, dt, label, dt_from_plan, dt_to_plan, dt_from_fact, dt_to_fact, TO_DAYS(CASE WHEN tasks.dt_to_fact IS NULL THEN NOW() ELSE tasks.dt_to_fact END) - TO_DAYS(dt_to_plan) AS deviation)' => [
			['parent IS NULL'],
			['id_task_route_item IS NULL'],
			[id_doc_type => $data -> {id_doc_type}],
			[id_type     => $data -> {id_type}],
		],
	);
	
	my $ids = ids ($other_doc_tasks);
	
	while (@$other_doc_tasks) {
	
		push @{$data -> {tasks}}, @$other_doc_tasks;
		
		$other_doc_tasks = sql (
			'tasks(id, id_user_executor, id_task_route_task, id_task_status, parent AS id_preceding_task, group_task_no, prefix, no, dt, label, dt_from_plan, dt_to_plan, dt_from_fact, dt_to_fact, TO_DAYS(CASE WHEN tasks.dt_to_fact IS NULL THEN NOW() ELSE tasks.dt_to_fact END) - TO_DAYS(dt_to_plan) AS deviation)' => [
				['parent IN' => $ids],
			],
		);
		
		$ids = ids ($other_doc_tasks);
		
	}

        $data -> {tasks} = tree_sort ($data -> {tasks}, {
		parent => 'id_preceding_task',
	});
	
	my @current_level_tasks = (grep {!$_ -> {id_preceding_task}} @{$data -> {tasks}});
	my ($ids, $idx) = ids ($data -> {tasks});

	while (@current_level_tasks) {

		my @next_level_tasks = ();
		foreach my $task (@current_level_tasks) {

			my @children = grep {$_ -> {id_preceding_task} == $task -> {id}} @{$data -> {tasks}};
			foreach my $child (@children) {
				
				unless ($child -> {id_task_status}) {
			
				
					$child -> {dt_from_plan} = $task -> {dt_to_fact} ||
						$task -> {dt_to_plan};
						
					my ($year, $month, $day, $hour, $min, $sec) = split (/\D+/, $child -> {dt_from_plan});
					
					$child -> {dt_to_plan} = sprintf ("%04i-%02i-%02i %02i:%02i:%02i", Add_Delta_DHMS ($year, $month, $day, $hour, $min, $sec, $child -> {duration_days}, $child -> {duration_hours}, 0, 0));
					
					$child-> {deviation} = $child -> {dt_to_plan} gt $today ? '' :
						Delta_Days (Today, Add_Delta_Days ($year, $month, $day, $child -> {duration_days}));
						
				}

			}
			push  @next_level_tasks, @children;
		}
		
		@current_level_tasks = @next_level_tasks;
	}
	
#foreach my $task (@{$data -> {tasks}}) {
#	darn ({
#		id => $task -> {id},
#		id_preceding_task => $task -> {id_preceding_task},
#		label => $task -> {label},
#		_distance => $task -> {_distance},
#		dt_from_plan => $task -> {dt_from_plan},
#		dt_to_plan => $task -> {dt_to_plan},
#		deviation => $task -> {deviation},
#		duration_days => $task -> {duration_days},
#		duration_hours => $task -> {duration_hours},
#		id => $task -> {id},
#	});
#}
	
	return $data;
	
}


1;
