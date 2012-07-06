
################################################################################

sub get_item_of_tasks {

	my $data = sql (tasks => ['id'], 'users(label) AS user_initiators', 'task_types(is_multiple_executors)');

	check_task_rights ($data);

	__d ($data);

	$data -> {no} = prefix_no ($data);

	if ($data -> {id_doc_type}) {

		$data -> {doc_type} = sql_select_hash ('doc_types', $data -> {id_doc_type});

		$data -> {base_doc_type_label} = $data -> {doc_type} -> {label};

		$data -> {base_doc_table} = get_doc_type_table ($data -> {doc_type});

		$data -> {base_doc_label} = get_base_doc_label ($data);


	}

	return $data;

}


################################################################################

sub select_tasks {

	my $data = {
		id_type     => $_REQUEST {id_type},
		id_doc_type => sql_select_scalar ('SELECT id_doc_type FROM docs WHERE id = ?', $_REQUEST {id_type}),
	};


	$_REQUEST {limit} += 0;

	sql ($data,
		'tasks(id, label, prefix, no, dt, dt_to_plan, dt_to_fact, id_task_status)' => [
			[id_doc_type => $data -> {id_doc_type} || -1],
			[id_type     => $data -> {id}],
			['label LIKE %?%'  => $_REQUEST {q}],

			[ ORDER => 'dt'],

			[ LIMIT => "start, $_REQUEST{limit}"],

		],
		'task_importances                  ON tasks.id_task_importance',
		'task_status                       ON tasks.id_task_status',
		'users      AS user_executors      ON tasks.id_user_executor',
		'users      AS user_inspectors     ON tasks.id_user_inspector',
		'users      AS user_initiators     ON tasks.id_user_initiator',
		'workgroups AS workgroup_executors ON tasks.id_workgroup_executor',
	);

	$data -> {doc_tasks} = $data -> {tasks};



	return $data;

}










































################################################################################

sub _tasks_add_search_query_options { # ôîðìèðóåò ïàðàìåòðû çàïðîñà äëÿ ïîèñêà ïî íîìåðó çàäà÷è

	my ($query_options, $search_string) = @_;

	length ($search_string) > 0 or return;

	my $label_search_expression  = '%' . $search_string . '%';

	my ($tasks_no_filter, @tasks_no_params);

	# åñëè èùåì ïî íîìåðó, èùåì ñòðîãîå ñîâïàäåíèå
	if ($search_string =~ /^\d+$/) {

		$tasks_no_filter = q[tasks.no = ?];
		push @tasks_no_params, $search_string;

	} else {

		my $full_no_search_expression  = $search_string;

		$full_no_search_expression =~ s/\s*-\s*/-/;

		$full_no_search_expression = '%' . $full_no_search_expression . '%';

		$tasks_no_filter = q[CONCAT(IF(tasks.prefix IS NULL, '', CONCAT(tasks.prefix, '-')), tasks.no) LIKE ?];
		push @tasks_no_params, $full_no_search_expression;
	}

	$query_options -> {filter} .= " AND (tasks.label LIKE ? OR $tasks_no_filter) ";
	push @{$query_options -> {filter_params}}, ($label_search_expression, @tasks_no_params);
}



################################################################################

sub _select_tasks { # Задачи

	my ($options) = @_;

	my $data = {
		portion => $conf -> {portion},
	};

	# HACK: избежать неявного check___query из sql(), фильтры применяет _tasks_apply_filter_set
	$_REQUEST {__allow_check___query} = 0;

	my $query_options = { # опции запроса, выбирающего задачи
		labels        => '',
		joins         => '',
		filter        => '',
		join_params   => [],
		filter_params => [],
		group         => '',
		having        => '',
	};

	# HACK: баг движка: поля тулбара с опцией other
	# не сохраняются при пролистывании (подчерк впереди названия поля)
	foreach my $toolbar_input_select qw(id_user_executor id_user_inspector) {

		$_REQUEST {$toolbar_input_select} = $_REQUEST {'_' . $toolbar_input_select}
			if exists $_REQUEST {'_' . $toolbar_input_select};
	}

	if ($_REQUEST {parent}) {

		generate__last_query_string ();

		$data -> {parent} = sql_select_hash ('tasks', $_REQUEST {parent});

		check_task_rights ($data -> {parent});

		$options -> {show_all_regardless_rights} = $data -> {parent} -> {is_executor}
			|| $data -> {parent} -> {is_inspector};

		$data -> {task_type} = $data -> {parent} -> {task_type} = sql_select_hash ('task_types', $data -> {parent} -> {id_task_type});

		$data -> {children_task_exists} = 1;

		$_REQUEST {__read_only} = 1;

		$data -> {parent} -> {path} = [
			{type => 'tasks', name => 'Список задач'},
			{type => 'tasks', name => get_task_full_name ({task => $data -> {parent}}) },
			{type => 'tasks', name => 'Дочерние задачи'},
		];


		__d ($data -> {parent}, 'dt', 'dt_from_plan', 'dt_from_fact', 'dt_to_plan', 'dt_to_fact', 'dt_remind_executor', 'dt_remind_inspector', 'dt_accepted',);


		$data -> {user_initiators} = sql_select_vocabulary ('users' => {filter => "id=$data->{parent}->{id_user_initiator}"});
		add_vocabularies ($data -> {parent},
			task_status     => {
				in => $data -> {parent} -> {id_task_status},
			},
			task_types      => {
				in => $data -> {parent} -> {id_task_type},
			},
		);

	}

	if ($_REQUEST {id_task_route_item}) {

		sql ($data, 'task_route_items',
			[
				[id => $_REQUEST {id_task_route_item}]
			],
			'task_routes',
			'task_route_item_status',
			'doc_types',
			'users',
		);

		$data -> {id_base_doc} = $data -> {task_route_items} -> {id_type};
		if ($data -> {id_base_doc}) {

			$data -> {base_doc_label} = get_base_doc_label ($data -> {task_route_items});
			$data -> {base_doc_type} =
				get_doc_type_table ($data -> {task_route_items} -> {doc_type});
		}


		$data -> {task_route_items} -> {task_route_tasks_cnt} = sql_select_scalar (
			'SELECT COUNT(*) FROM task_route_tasks WHERE fake = 0 AND id_task_route = ?',
			$data -> {task_route_items} -> {task_route} -> {id}
		);

		$data -> {task_route_role_ids} = get_users_task_route_role_ids ($_REQUEST {id_task_route_item}, $_USER -> {id});

		($data -> {is_can_cancel_route_item}, $data -> {is_can_edit_doc_files}) = sql_select_array (<<EOS);
			SELECT
				SUM(is_can_cancel_route_item)
				, SUM(is_can_edit_doc_files)
			FROM
				task_route_roles
			WHERE
				id IN ($data->{task_route_role_ids})
			AND
				fake = 0
			AND
				is_can_cancel_route_item = 1
EOS


		$_REQUEST {__read_only} = 1;

		__d ($data -> {task_route_items}, 'dt_start', 'dt_finish');

		$data -> {task_route_items} -> {path} = [
			{type => 'task_route_items', name => 'Перечень процессов'},
			{type => 'tasks', name => 'Задачи процесса', },
		];

		$query_options -> {filter} .= ' AND tasks.id_task_route_item = ?';

		push @{$query_options -> {filter_params}}, $_REQUEST {id_task_route_item};


	}

	if ($_REQUEST {id_task_route_task}) {

		$query_options -> {filter} .= ' AND tasks.id_task_route_task = ?';

		push @{$query_options -> {filter_params}}, $_REQUEST {id_task_route_task};

	}

	_tasks_apply_filter_set ($data);

	$data -> {act_for_user_ids} = [
		$_USER -> {id},
		sql_select_col (<<EOS, $_USER -> {id})
			SELECT
				id_user
			FROM
				user_replacements
			WHERE
				fake = 0
			AND
				is_tasks = 1
			AND
				id_assistant = ?
			AND
				dt_from <= CURDATE()
			AND
				dt_to >= CURDATE()
EOS
	];

	my $act_for_user_ids = join (', ', -1, grep {$_ > 0} @{$data -> {act_for_user_ids}});

	my $workgroup_ids = '1,' . sql_select_ids ("SELECT id_workgroup FROM user_workgroups WHERE fake = 0 AND id_user IN ($act_for_user_ids)");
	my $admin_task_type_ids = sql_select_ids (<<EOS);
		SELECT DISTINCT
			id_task_type
		FROM
			task_type_rights
		WHERE
			fake = 0
		AND
			(is_admin = 1 OR is_can_view = 1)
		AND
			id_workgroup IN ($workgroup_ids)
EOS
#	warn "select_tasks: admin_task_type_ids - $admin_task_type_ids";

	if ($_REQUEST {process_only}) {

		$query_options -> {filter} .= ' AND (tasks.id_task_route_item IS NOT NULL OR tasks.is_parent_is_task_route = 1) ';

		if ($_REQUEST {id_task_route}) {
			$query_options -> {filter} .= ' AND task_route_items.id_task_route = ? ';
			push @{$query_options -> {filter_params}}, $_REQUEST {id_task_route};
		}


	}


	$_REQUEST {base_doc_type_ids} = join ',', grep {/^\d+$/} split /,/, $_REQUEST {base_doc_type_ids};
	if ($_REQUEST {base_doc_type_ids}) {

		$query_options -> {filter} .= " AND tasks.id_doc_type IN (-1, $_REQUEST{base_doc_type_ids})";
		$data -> {doc_types} = sql_select_vocabulary ('doc_types', {filter => "id IN (-1, $_REQUEST{base_doc_type_ids})"});
	}

	if ($_REQUEST {without_process_only}) {
		$query_options -> {filter} .= ' AND tasks.id_task_route_item IS NULL AND is_parent_is_task_route = 0 ';
	}

# Проверка задачи на соответствие условиям фильтра
	if ($_REQUEST {id_task_to_check}) {
		$query_options -> {filter} .= ' AND tasks.id = ? ';
		push @{$query_options -> {filter_params}}, $_REQUEST {id_task_to_check};
	}

	if ($_REQUEST {dt_to_plan}) {
		$query_options -> {filter} .= ' AND tasks.dt_to_plan >= ? ';
		push @{$query_options -> {filter_params}}, dt_iso ($_REQUEST {dt_to_plan});
	}

	if ($_REQUEST {dt_to_plan_to}) {
		$query_options -> {filter} .= ' AND tasks.dt_to_plan <= ? ';
		push @{$query_options -> {filter_params}}, dt_iso ($_REQUEST {dt_to_plan_to}) . ' 23:59:59';
	}

	if ($_REQUEST {dt_from_plan}) {
		$query_options -> {filter} .= ' AND tasks.dt_from_plan >= ? ';
		push @{$query_options -> {filter_params}}, dt_iso ($_REQUEST {dt_from_plan});
	}

	if ($_REQUEST {dt_from_plan_to}) {
		$query_options -> {filter} .= ' AND tasks.dt_from_plan <= ? ';
		push @{$query_options -> {filter_params}}, dt_iso ($_REQUEST {dt_from_plan_to}) . ' 23:59:59';
	}

	if ($_REQUEST {is_overdue}) {
		$query_options -> {filter} .= ' AND IF(tasks.id_task_status < 3, tasks.dt_to_plan < NOW(), tasks.dt_to_plan < tasks.dt_to_fact) ';
	}

	if ($_REQUEST {is_not_overdue}) {
		$query_options -> {filter} .= ' AND IF(tasks.id_task_status < 3, tasks.dt_to_plan >= NOW(), tasks.dt_to_plan >= tasks.dt_to_fact) ';
	}


	if ($_REQUEST {id_doc_type}) {

		$query_options -> {filter} .= ' AND tasks.id_doc_type = ?';
		push @{$query_options -> {filter_params}}, $_REQUEST {id_doc_type};

		if ($_REQUEST {type} ne 'tasks') {

			$data -> {is_have_doc_types} = sql_select_scalar ('SELECT id FROM doc_type_task_types WHERE fake = 0 AND id_doc_type = ?', $_REQUEST {id_doc_type});

		}
	}

	if ($_REQUEST {id_type}) {
		$query_options -> {filter} .= ' AND tasks.id_type = ?';
		push @{$query_options -> {filter_params}}, $_REQUEST {id_type};

		if ($_REQUEST {type} ne 'tasks' && $_REQUEST {id_doc_type}) {
			my $doc_type = sql_select_hash ('doc_types', $_REQUEST {id_doc_type});

			$data -> {is_fake_type} = sql_select_scalar ("SELECT fake FROM $$doc_type{name} WHERE id = ?", $_REQUEST {id_type})
				if $doc_type -> {name};

			$data -> {is_exist_task_route_tasks} = sql_select_scalar ('SELECT * FROM tasks WHERE fake = 0 AND id_doc_type = ? AND id_type = ? AND id_task_route_item IS NOT NULL', $_REQUEST {id_doc_type}, $_REQUEST {id_type});

		}
	}


	_tasks_add_search_query_options ($query_options, $_REQUEST {q});

	$_REQUEST {task_type_ids} = join ',', grep {/^\d+$/} split /,/, $_REQUEST {task_type_ids};
	# TODO: _check_ids ($_REQUEST {task_type_ids});
	if ($_REQUEST {task_type_ids}) {
		$query_options -> {filter} .= " AND tasks.id_task_type IN ( $_REQUEST{task_type_ids} )";
	}

	if ($_REQUEST {period} == 1) {

		$query_options -> {filter} .= ' AND tasks.dt_to_plan < NOW() AND tasks.id_task_status IN (1, 2, 3)';

	} elsif ($_REQUEST {period} == 2) {

		$query_options -> {filter} .= ' AND tasks.dt_to_plan BETWEEN NOW() AND ADDDATE(NOW(), INTERVAL (6-WEEKDAY(NOW())) DAY) AND tasks.id_task_status IN (1, 2, 3)';

	} elsif ($_REQUEST {period} == 3) {

		$query_options -> {filter} .= ' AND tasks.dt_to_plan BETWEEN NOW() AND ? AND tasks.id_task_status IN (1, 2, 3)';

		push @{$query_options -> {filter_params}}, sprintf ("%04d-%02d-31", Today);

	}

	if ($_REQUEST {relation_type} == 1) {

		$query_options -> {filter} .= " AND tasks.id_user_inspector IN ($act_for_user_ids)";

	} elsif ($_REQUEST {relation_type} == 2 || $_REQUEST {relation_type} == 3) {

		my @subordinate_filter;

		if ($_REQUEST {relation_type} == 3) {

			my $admin_task_routes = sql ('task_route_rights(id_task_route)' => [
					[is_admin => 1],
					['id_workgroup IN' => [split /,/, $workgroup_ids]]
				]
			);

			my $involved_users = <<EOS;
				(
					(
						tasks.id_workgroup_executor IN ($workgroup_ids)
					AND
						IFNULL(tasks.id_user_executor, 0) = 0
					)
					OR
					tasks.id_user_executor IN ($act_for_user_ids)
					OR
					tasks.id_user_inspector IN ($act_for_user_ids)
					OR
					tasks.id_user_initiator IN ($act_for_user_ids)
					OR
					EXISTS (
						SELECT
							id
						FROM
							task_histories
						WHERE
							tasks.id = task_histories.id_task
						AND (
							id_user_executor IN ($act_for_user_ids)
							OR
							tasks.id_user_inspector IN ($act_for_user_ids)
						)
					)
					OR
					tasks.id_task_type IN ($admin_task_type_ids)
					OR
					task_route_items.id_task_route IN ($$admin_task_routes)
				)
EOS
			push @subordinate_filter, $involved_users;
		}

		my $deps = sql_select_all ('SELECT id, dt, dt_to, id_dep, is_boss FROM hr_orders WHERE id_user = ? AND fake = 0 ORDER BY dt', $_USER -> {id});

		my $deps_filter;

		for (my $i=0; $i < @$deps; $i ++) {

			my $dep = $deps -> [$i];
#warn "id_dep: $dep->{id_dep}\n";
#warn Dumper $dep;
			if ($dep -> {is_boss}) {

				my @dep_ids = sql_select_subtree ('deps', $dep -> {id_dep});

				if ($dep -> {dt_to}) {

					$dep -> {user_filter} = " dt < '$dep->{dt_to}' AND (dt_to IS NULL OR dt_to > '$dep->{dt}')";


				} else {

					$dep -> {user_filter} = " (dt_to IS NULL OR dt_to > '$dep->{dt}') ";

				}
#warn $dep -> {user_filter};
				foreach my $id_dep (@dep_ids) {
#warn $id_dep;
					my @users = sql_select_col (<<EOS, $id_dep);
						SELECT
							id_user
						FROM
							hr_orders
						WHERE
							$dep->{user_filter}
						AND
							id_dep = ?
EOS
#warn Dumper \@users;
					if (@users) {
						my $subordinate_user_ids = join (',', -1, grep {$_ > 0} @users);

						if ($dep -> {dt_to}) {

							push @subordinate_filter, " (tasks.id_user_initiator IN ($subordinate_user_ids) OR tasks.id_user_inspector IN ($subordinate_user_ids) OR tasks.id_user_executor IN ($subordinate_user_ids) AND ((tasks.dt >= '$dep->{dt}' AND tasks.dt < '$dep->{dt_to}') OR (tasks.dt < '$dep->{dt_to}' AND tasks.dt_to_fact IS NULL) OR (tasks.dt_to_fact >= '$dep->{dt}' AND tasks.dt_to_fact < '$dep->{dt_to}')))";

						} else {

							push @subordinate_filter, " (tasks.id_user_initiator IN ($subordinate_user_ids) OR tasks.id_user_inspector IN ($subordinate_user_ids) OR tasks.id_user_executor IN ($subordinate_user_ids) AND (tasks.dt >= '$dep->{dt}' OR tasks.dt_to_fact >= '$dep->{dt}' OR tasks.dt_to_fact IS NULL))";

						}
					}

				}

			}
		}
		if ($_REQUEST {relation_type} == 2) {
			if (@subordinate_filter) {
				$query_options -> {filter} .= ' AND (' . join (' OR ', @subordinate_filter) . ') ';
			}
		} elsif ($_REQUEST {relation_type} == 3 && !$options -> {show_all_regardless_rights}) {
			if (@subordinate_filter) {
				$query_options -> {filter} .= ' AND (' . join (' OR ', @subordinate_filter) . " OR tasks.id_task_type IN ($admin_task_type_ids)) ";
			}
		}
#warn Dumper \@subordinate_filter;
#warn $query_options -> {filter};

	} elsif ($_REQUEST {relation_type} == 4) {

		$query_options -> {filter} .= " AND tasks.id_user_initiator IN ($act_for_user_ids)";

	} else { # $_REQUEST {relation_type} == 0 # на исполнение

		$query_options -> {filter} .= " AND (tasks.id_user_executor IN ($act_for_user_ids) OR (IFNULL(tasks.id_user_executor, 0) = 0 AND tasks.id_workgroup_executor IN ($workgroup_ids)))";

	}

	if ($_REQUEST {is_done} == 1) {

		$query_options -> {filter} .= ' AND tasks.id_task_status = 4';

	} elsif (!$_REQUEST {is_done}) {

		$query_options -> {filter} .= ' AND tasks.id_task_status < 4';

	}

	if ($_REQUEST {id_task_status}) {

		$query_options -> {filter} .= ' AND tasks.id_task_status = ?';
		push @{$query_options -> {filter_params}}, $_REQUEST {id_task_status};

	}

	if ($_REQUEST {id_task_importance}) {

		$query_options -> {filter} .= ' AND tasks.id_task_importance = ?';
		push @{$query_options -> {filter_params}}, $_REQUEST {id_task_importance};

	}

	if ($_REQUEST {id_voc_agent}) {

		$query_options -> {filter} .= ' AND tasks.id_voc_agent = ?';
		push @{$query_options -> {filter_params}}, $_REQUEST {id_voc_agent};

	}

	if ($_REQUEST {id_task_route}) {

		$_REQUEST {id_task_route} += 0;

		$query_options -> {filter} .= ' AND tasks.id_task_route_item IN ('.
				sql_select_ids ("SELECT id FROM task_route_items WHERE id_task_route = ? AND fake = 0", $_REQUEST {id_task_route})
			. ')';
	}

	delete $_REQUEST {user_executor_ids}
		if $_REQUEST {user_executor_ids} eq '-1';

	if ($_REQUEST {user_executor_ids} && $_REQUEST {id_user_executor} && $_REQUEST {user_executor_ids} !~ /\b$_REQUEST{id_user_executor}\b/) {
		delete $_REQUEST {id_user_executor};
	}


	if ($_REQUEST {id_user_executor}) {

		my $user_workgroup_ids = '1,' . sql_select_ids ("SELECT id_workgroup FROM user_workgroups WHERE fake = 0 AND id_user IN ($_REQUEST{id_user_executor})");

		$query_options -> {filter} .= " AND (tasks.id_user_executor = $_REQUEST{id_user_executor} OR (IFNULL(tasks.id_user_executor, 0) = 0 AND tasks.id_workgroup_executor IN ($user_workgroup_ids)))";

	} elsif ($_REQUEST {user_executor_ids}) {

		_check_ids ($_REQUEST {user_executor_ids});

		my $user_workgroup_ids = '1,' . sql_select_ids ("SELECT id_workgroup FROM user_workgroups WHERE fake = 0 AND id_user IN ($_REQUEST{user_executor_ids})");
		$query_options -> {filter} .= " AND (tasks.id_user_executor IN ($_REQUEST{user_executor_ids}) OR (IFNULL(tasks.id_user_executor, 0) = 0 AND tasks.id_workgroup_executor IN ($user_workgroup_ids)))";

	}


	if ($_REQUEST {id_user_inspector}) {
		$query_options -> {filter} .= " AND tasks.id_user_inspector = $_REQUEST{id_user_inspector}";

	}

	if ($_REQUEST {user_inspector_ids}) {
		_check_ids ($_REQUEST {user_inspector_ids});
		$query_options -> {filter} .= " AND tasks.id_user_inspector IN ($_REQUEST{user_inspector_ids})";

	}

	if ($_REQUEST {id_user_initiator}) {
		$query_options -> {filter} .= " AND tasks.id_user_initiator = $_REQUEST{id_user_initiator}";
	}

	# нужна сортировака по доп. полям, поэтому делаем join'ы
	$data -> {extra_fields} = get_task_types_union_doc_fields ($_REQUEST {task_type_ids});
	_tasks_set_query_options_by_user_fields ($query_options, $data -> {extra_fields});

	my $start = $_REQUEST {start} + 0;
	my $limit = "LIMIT $start, $$data{portion}";

	my @doc_fields_order = map {($_ -> {key} => "$_->{order_field}")}
		grep {$_ -> {order_field}} @{$data -> {extra_fields}};

	my $voc_agent_table = keys (%{$DB_MODEL -> {tables} -> {voc_agents}}) ? 'voc_agents' : 'voc_firms';
	my $order	= "ORDER BY\n" . order ('tasks.dt_to_plan',
		no                   => 'tasks.prefix, tasks.no',
		dt                   => 'tasks.dt',
		task_status_label    => 'task_status.label',
		id_task_status       => 'IF(task_status.id NOT IN (1,2), 1, 0), IF(task_status.id <> 3, 1, 0), tasks.dt_to_plan',
		dt_from_plan         => 'tasks.dt_from_plan',
		dt_to_plan           => 'tasks.dt_to_plan',
		dt_to_fact           => 'tasks.dt_to_fact',
		task_importance_label => 'CASE WHEN task_importances.ord IS NULL THEN 2 ELSE 1 END, task_importances.ord',
		voc_agent_label       => "CASE WHEN $voc_agent_table.label IS NULL THEN 2 ELSE 1 END, $voc_agent_table.label",

		deviation            => 'deviation',

		task_type_label      => 'task_types.label',
		label                => 'tasks.label',
		user_executor_label  => 'user_executors.label',
		user_inspector_label => 'user_inspectors.label',

		id_task_importance   => 'task_importances.ord DESC, tasks.dt_to_plan DESC',
		task_children_state  => "CASE WHEN children_tasks.id IS NULL THEN 2 ELSE 1 END\n"
			. ', CASE WHEN MIN(children_tasks.id_task_status) >= 4 THEN 2 ELSE 1 END',

		portal_to_execute_dt                 => 'tasks.id_task_status, tasks.dt',
		portal_to_execute_dt_to_plan         => 'tasks.id_task_status, tasks.dt_to_plan',
		portal_to_execute_id_task_importance => 'tasks.id_task_status, CASE WHEN task_importances.ord IS NULL THEN 2 ELSE 1 END, task_importances.ord, tasks.dt_to_plan',

		portal_to_inspect_dt                 => 'IF(tasks.id_task_status <> 3, 1, 0), tasks.dt',
		portal_to_inspect_dt_to_plan         => 'IF(tasks.id_task_status <> 3, 1, 0), tasks.dt_to_plan',
		portal_to_inspect_id_task_importance => 'IF(tasks.id_task_status <> 3, 1, 0), CASE WHEN task_importances.ord IS NULL THEN 2 ELSE 1 END, task_importances.ord, tasks.dt_to_plan',

		@doc_fields_order,
	);

	if ($_REQUEST {parent}) {

		if ($_REQUEST {show_all_descendants}) {

			$data -> {subtree} = join ',', (-1,
				grep {$_ != $_REQUEST {parent}} sql_select_subtree (tasks => $_REQUEST {parent})
			);

			$query_options -> {filter} .= " AND tasks.id IN ($$data{subtree}) ";

			$order = ''; # ибо tree_sort после выборки
			$limit = ''; # приходится выбирать все поддерево задач (для показа иерархии)

		} else {
			$query_options -> {filter} .= ' AND tasks.parent = ?';
			push @{$query_options -> {filter_params}}, $_REQUEST {parent};
		}
	}

	if ($_QUERY -> {content} -> {columns} -> {task_children_state} -> {ord} || $_REQUEST {task_children_state}) {

		$query_options -> {labels} .= "\n, MIN(children_tasks.id_task_status) < 4 AS has_unfinished_children";
		$query_options -> {joins} .=
			'LEFT JOIN tasks children_tasks ON children_tasks.parent = tasks.id AND children_tasks.fake = 0';
		$query_options -> {group}  .= 'tasks.id';

		if ($_REQUEST {task_children_state}) {
			$query_options -> {having} .= $_REQUEST {task_children_state} == 1?
				'MIN(children_tasks.id_task_status) < 4'
				: 'MIN(children_tasks.id_task_status) >= 4';
		}
	}

	$query_options -> {group} = "GROUP BY\n" . $query_options -> {group}
		if $query_options -> {group};
	$query_options -> {having} = "HAVING\n" . $query_options -> {having}
		if $query_options -> {having};

	#warn "select_tasks.query_options: " . Dumper ($query_options);
	($data -> {tasks}, $data -> {cnt}) = sql_select_all_cnt (<<EOS,
		SELECT
			tasks.*
			, TO_DAYS(IFNULL(tasks.dt_to_fact, NOW())) - TO_DAYS(tasks.dt_to_plan) AS deviation
			, task_types.label AS task_type_label
			, task_status.label AS task_status_label
			, task_importances.label AS task_importance_label
			, $voc_agent_table.label AS voc_agent_label
			, user_executors.label AS user_executor_label
			, user_inspectors.label AS user_inspector_label
			, user_initiators.label AS user_initiator_label
			, workgroup_executors.label AS workgroup_executors_label

			, doc_types.label AS base_doc_type_label
			, doc_types.name AS base_doc_type_name
			, doc_types.subname AS base_doc_type_subname

			, CASE
				WHEN tasks.id_task_status >= 4 THEN NULL
				WHEN tasks.dt_to_plan < NOW() THEN '$ALERT_COLOR'
				ELSE NULL
			END AS bgcolor

			$query_options->{labels}

		FROM
			tasks
			INNER JOIN task_types ON tasks.id_task_type = task_types.id
			INNER JOIN task_status ON tasks.id_task_status = task_status.id

			LEFT JOIN task_importances ON tasks.id_task_importance = task_importances.id AND task_types.field_id_task_importance <> 3
			LEFT JOIN $voc_agent_table ON tasks.id_voc_agent = $voc_agent_table.id AND task_types.field_id_voc_agent <> 3

			LEFT JOIN users user_executors ON tasks.id_user_executor = user_executors.id
			LEFT JOIN users user_inspectors ON tasks.id_user_inspector = user_inspectors.id
			LEFT JOIN users user_initiators ON tasks.id_user_initiator = user_initiators.id

			LEFT JOIN workgroups workgroup_executors ON tasks.id_workgroup_executor = workgroup_executors.id
			LEFT JOIN task_route_items ON tasks.id_task_route_item = task_route_items.id
			LEFT JOIN docs ON docs.id_doc_type = tasks.id_doc_type AND docs.id = tasks.id_type
			LEFT JOIN doc_types ON doc_types.id = tasks.id_doc_type

			$query_options->{joins}

		WHERE
			tasks.fake = 0
			$query_options->{filter}

		$query_options->{group}
		$query_options->{having}
		$order
		$limit
EOS
		@{$query_options -> {join_params}}
		, @{$query_options -> {filter_params}}
	);

	push @{$data -> {dt_fields}}, (qw(dt dt_from_plan dt_to_plan dt_to_fact));


	# генерация номера в иерархии и сортировка
	if ($_REQUEST {parent} && $_REQUEST {show_all_descendants}) {

		my $subtree = sql_select_all ("SELECT id, parent FROM tasks WHERE id IN ($$data{subtree})");

		$subtree = tree_sort ($subtree);

		# генерация номера задачи в иерархии (1, 1.1, 1.1.1)
		my $level_no_hash = {};
		foreach my $task (@$subtree) {

			foreach (grep {$_ > $task -> {level}} keys %$level_no_hash) {
				delete $level_no_hash -> {$_}
			}

			$level_no_hash -> {$task -> {level}} ++;

			$task -> {level_label} = join '.', map {$level_no_hash -> {$_}} (1 .. $task -> {level});
		}

		my ($ids, $subtree_level_hash) = ids ($subtree);

		# задачам (возможно отфильтрованным) присваиваем правильный номер в иерархии
		foreach my $task (@{$data -> {tasks}}) {
			$task -> {level_label} = $subtree_level_hash -> {$task -> {id}} -> {level_label};
		}

		@{$data -> {tasks}} = sort {
			$subtree_level_hash -> {$a -> {id}} -> {ord} cmp $subtree_level_hash -> {$b -> {id}} -> {ord}
		} @{$data -> {tasks}};

		my $portion_start = 0 + $_REQUEST {start};
		my $portion_end = $portion_start + $data -> {portion} - 1;
		if ($data -> {cnt} < $data -> {portion}) {
			$portion_end  = $data -> {cnt} - 1;
		}
		@{$data -> {tasks}} = @{$data -> {tasks}}[$portion_start .. $portion_end];
	}

#__profile_in ('select_tasks.tasks_add_details');
	foreach my $task (@{$data -> {tasks}}) {

		check_task_rights ($task) if $options -> {show_all_regardless_rights};

		$task -> {base_doc_label} = get_base_doc_label ($task);

		$task -> {base_doc_table} = $task -> {base_doc_type_subname}
			|| $task -> {base_doc_type_name}
			|| 'docs';

		$task -> {base_doc_shown} = $task -> {id_doc_type} && $task -> {id_type}
			&& $_QUERY -> {content} -> {columns} -> {base_doc_label} -> {ord};

		if ($task -> {base_doc_shown}) {

			$task -> {base_doc_files_table} = $task -> {base_doc_table} eq 'docs'?
				'doc_files'
				: ($task -> {base_doc_table} . '_files');

			my $type_unplural = en_unplural ($task -> {base_doc_table});

			if ($DB_MODEL -> {tables} -> {$task -> {base_doc_files_table}}
				&& $DB_MODEL -> {tables} -> {$task -> {base_doc_files_table}} -> {columns} -> {'id_' . $type_unplural})
			{

				$task -> {base_doc_files} = sql_select_all (<<EOS, $task -> {id_type});
					SELECT
						*
					FROM
						$$task{base_doc_files_table}
					WHERE
						fake = 0
						AND is_actual = 1
						AND id_$type_unplural = ?
EOS
			}
		}
	}
#__profile_out ('select_tasks.tasks_add_details');

	my $task_ids = join ',', -1, map {$_ -> {id}} @{$data -> {tasks}};

	my $task_msgs = sql_select_all_hash (<<EOS, $_USER -> {id}, dt_iso (Today) . ' 23:59:59');
		SELECT
			id_type AS id
		FROM
			msgs
		WHERE
			id_user_recipient = ?
		AND
			dt_delivered IS NULL
		AND
			IF(id_msg_type=2, dt, CURDATE()) <= ?
		AND
			id_doc_type = $ID_DOC_TYPE_TASKS
		AND
			id_type IN ($task_ids)
		AND
			fake = 0
EOS


	map {$_ -> {is_have_msg} = $task_msgs -> {$_ -> {id}}} @{$data -> {tasks}};

	add_vocabularies ($data,
		'task_status'	=> {order => 'id',},
	);

	my $selected_initiator = $_REQUEST {id_user_initiator} || -1;
	$data -> {user_initiators} = sql_select_vocabulary ('users'	=> {
		in => "$selected_initiator, $act_for_user_ids"
	});

	my $selected_inspector = $_REQUEST {id_user_inspector} || -1;
	$data -> {user_inspectors} = sql_select_vocabulary ('users'	=> {
		in     => "$selected_inspector, $act_for_user_ids",
		# . ($_REQUEST{user_inspector_ids} ? ",$_REQUEST{user_inspector_ids}" : ''),
	});

	if ($_REQUEST {user_executor_ids}) {

		$data -> {user_executors} = sql_select_vocabulary ('users'	=> {
			in => $_REQUEST {user_executor_ids}
		});

	} else {

		my $selected_executor = $_REQUEST {id_user_executor} || -1;

		$data -> {user_executors} = sql_select_vocabulary ('users'	=> {
			in => "$selected_executor, $act_for_user_ids"
		});
	}

	if ($_REQUEST {id_doc_type}) {

		$data -> {task_type_exists} = sql_select_col (<<EOS, $_REQUEST {id_doc_type});
			SELECT
				doc_type_task_types.id_task_type
			FROM
				doc_type_task_types
				INNER JOIN task_type_rights ON doc_type_task_types.id_task_type = task_type_rights.id_task_type
				INNER JOIN task_types ON task_type_rights.id_task_type = task_types.id AND task_types.fake = 0 AND task_types.is_used_only_in_task_routes = 0
			WHERE
				doc_type_task_types.id_doc_type = ?
			AND
				task_type_rights.fake = 0
			AND
				task_type_rights.is_create = 1
			AND
				task_type_rights.id_workgroup IN ($workgroup_ids)
			AND
				task_types.is_system = 0
EOS

	}

	return $data;

}

################################################################################

sub _tasks_apply_filter_set { # переписывает %_REQUEST согласно выбранному набору фильтров

	my ($data) = @_;

	$_REQUEST {__order_context} ||= $_REQUEST {id_task_route_item} ? 'is_task_route_item=1' :
		$_REQUEST {id_doc_type} && $_REQUEST {id_type} ? 'is_doc_tasks=1' :
		$_REQUEST {parent} ? 'is_children=1' :
		'type=tasks';

	$_REQUEST {__order_context} = 'type=tasks'
		if $_REQUEST {skip_filters};

	require_content ('tasks_filters');

	$_REQUEST {id_filter} ||= get_user_value ('selected_filter_id') || -1;
	my $default_filter_id = get_user_value ('default_filter_id') || -1;
	$_REQUEST {id_filter} ||= $default_filter_id;


	# если набор фильтров не указан, выбираем фильтр по умолчанию
	if (!$_REQUEST {id_filter} || $_REQUEST {id_filter} == -1) {

		$_REQUEST {id_filter} = sql_select_id ($conf -> {systables} -> {__queries} => {
				-dump          => _tasks_filters_get_default_filter (),
				-id_user       => $_USER -> {id},
				-order_context => $_REQUEST {__order_context},
				-label         => 'default',
				-type          => 'tasks',
				-fake          => 0,
			},
			['id_user', 'order_context', 'type', 'label'],
		);

		set_user_value ('default_filter_id', $_REQUEST {id_filter});
		$default_filter_id = $_REQUEST {id_filter};
		$_REQUEST {id___query} = $_REQUEST {id_filter};
	}

	# на экранах задач по процессу, по документу и подзадач выбор фильтров отключен
	$data -> {stored_filters_enabled} =
		!$_REQUEST {id_task_route_item} &&
		!$_REQUEST {id_task_route_task} &&
		!($_REQUEST {id_doc_type} && $_REQUEST {id_type}) &&
		!$_REQUEST {parent};

	$_REQUEST {id_filter} = $default_filter_id
		if !$data -> {stored_filters_enabled};

	if ($data -> {stored_filters_enabled}) {
		# определяем предопределенные наборы фильтров для выпадающего списка
		$data -> {tasks_filters} = sql ($conf -> {systables} -> {__queries} => [
			['IFNULL(id_user,0) IN' => [0, $_USER -> {id}]], # показывать общие (id_user => NULL) и свои фильтры
			[type                   => 'tasks'],
			[order_context          => $_REQUEST {__order_context}],
			['id <>'                => $default_filter_id],
			# пропускаем записи, созданные стандартным механизмом фильтрации
			['label LIKE %?%'       => '_'],
			['label <> ?'           => 'default'],
		]);
		unshift @{$data -> {tasks_filters}}, {
			id => $default_filter_id,
			label => '[По умолчанию]',
		};
	}

	$_REQUEST {id___query} = $_REQUEST {id_filter};
	my $query = sql ($conf -> {systables} -> {__queries} => [
		[id => $_REQUEST {id_filter} || -1],
	]);
	$query -> {content} = get_filter ($query -> {dump});

	# HACK: check__query не перепишет существующие параметры значениями из фильтра
	if ($_REQUEST {skip_filters}) {

		foreach my $key (keys %{$query -> {content} -> {filters}}) {
			exists $_REQUEST {$key} or $_REQUEST {$key} = '';
		}
	}

	$_REQUEST {__allow_check___query} = 1;
	check___query();
	$_REQUEST {__allow_check___query} = 0;

	return if $_REQUEST {skip_filters};

	# применяем фильтры, переписывая %_REQUEST
	if ($_REQUEST {id_filter} != $_REQUEST {id_filter_previous}) {

		delete $_QUERY -> {content} -> {filters} -> {_id_user_inspector};
		delete $_QUERY -> {content} -> {filters} -> {_id_user_executor};
		delete $_REQUEST {order};
		map {delete $_QUERY -> {content} -> {filters} -> {$_}} split /,/, $_REQUEST {skip_filter_names};

		# не перебиваем значения, выбираемые на тулбаре
		foreach my $key (keys %{$_QUERY -> {content} -> {filters}}) {

			$_REQUEST {$key} = $_QUERY -> {content} -> {filters} -> {$key};
		}

		set_user_value ('selected_filter_id', $_REQUEST {id_filter});
	}

	# если текущий набор фильтров - 'по умолчанию', в нем сохраняются значения быстрых фильтров на тулбаре
	# (например, исполнитель, контролер, действие)
	if ($_REQUEST {id_filter} == $default_filter_id && $_REQUEST {id_filter} == $_REQUEST {id_filter_previous}) {

		$_QUERY -> {content} -> {filters} -> {relation_type} = $_REQUEST {relation_type};

		if ($_REQUEST {type} eq 'tasks') { # быстрые фильтры, видимые только на экране задач

			$_QUERY -> {content} -> {filters} -> {id_user_inspector} =
				$_REQUEST {id_user_inspector} || '';

			$_QUERY -> {content} -> {filters} -> {id_user_executor} =
				$_REQUEST {id_user_executor} || '';

			$_QUERY -> {content} -> {filters} -> {q} = $_REQUEST {q} || '';
		}

		delete $_QUERY -> {content} -> {filters} -> {_id_user_inspector};
		delete $_QUERY -> {content} -> {filters} -> {_id_user_executor};

		sql ($conf -> {systables} -> {__queries} => [
			[id     => $_REQUEST {id_filter}],
			[UPDATE => [
				[dump => Dumper ($_QUERY -> {content})]
			]]
		]);
	}

	# если просматриваем задач по экземпляру процесса, по документу или дочерние задачи и не указано иное, сбрасываем фильтры
	if (!$data -> {stored_filters_enabled}) {

		unless ( $_REQUEST {keep_filters} && exists ($_QUERY -> {content} -> {filters})) {

			my $filters = $_QUERY -> {content} -> {filters};

			foreach my $key (keys %$filters) {

				$_REQUEST {$key} = $filters -> {$key} = '';

			}

			$_REQUEST {is_done} = $filters -> {is_done} = 2;
			$_REQUEST {relation_type} = $filters -> {relation_type} = 3;

			# перезаписывать использованный в последнем сеансе фильтр
			sql_do ("UPDATE $conf->{systables}->{__queries} SET dump = ? WHERE id = ?", Dumper ($_QUERY -> {content}), $_REQUEST {id_filter});


			my $href = sql_select_scalar ("SELECT href FROM $conf->{systables}->{__access_log} WHERE id_session = ? AND no = ?", $_REQUEST {sid}, $_REQUEST {__last_query_string});

			if ($href !~ /keep_filters=1/) {
				sql_do ("UPDATE $conf->{systables}->{__access_log} SET href = ? WHERE id_session = ? AND no = ?", $href . '&keep_filters=1', $_REQUEST {sid}, $_REQUEST {__last_query_string});
			}

		}

		$_REQUEST {keep_filters} = 1;

	}

	$_REQUEST {id_filter_previous} = $_REQUEST {id_filter};
}

################################################################################

sub _tasks_set_query_options_by_user_fields { # формирует части sql-запроса для select_tasks, которые позволяют выбрать доп поля

	# только последние два параметра передаются по ссылке
	my ($query_options, $doc_fields_to_show) = @_;

	my $join_id = 0; # счетчик, обечпечиывающий уникальность псевдонимов

	# формируем join'ы для выборки доп. полей
	foreach my $doc_field (@$doc_fields_to_show) {

		next unless $_QUERY -> {content} -> {columns} -> {$doc_field -> {key}} -> {ord}
			|| $_REQUEST {$doc_field -> {key}}
			|| $_REQUEST {$doc_field -> {key} . '_to'};

		my $field_name = get_doc_field_data_field ($doc_field);

		# справочное значение
		if ($doc_field -> {field_type} == 4) {

			_tasks_set_query_options_for_voc_value ($query_options, $join_id, $doc_field);
			$join_id++;
			next;
		}

		# остальные типы доп полей
		my $join_alias = "doc_field_data$join_id";

		$query_options -> {labels} .= $doc_field -> {field_type} == 5? # чекбокс
			", IF($join_alias.$field_name > 0, 'Да', '') AS '$$doc_field{key}'\n"
			: ", $join_alias.$field_name AS '$doc_field->{key}'\n";

		$query_options -> {joins} .= <<EOS;
			LEFT JOIN doc_field_data $join_alias ON
					$join_alias.id_doc_type = $ID_DOC_TYPE_TASKS
					AND $join_alias.id_type = tasks.id
					AND $join_alias.id_doc_field = ?
					AND $join_alias.id_doc_field_group = ?
					AND $join_alias.fake = 0
EOS
		push @{$query_options -> {join_params}},
			$doc_field -> {id}, $doc_field -> {id_doc_field_group} + 0;


		my $orderby_expression = {
			# объекты без поля - чекбокса = объекты со снятым чекбоксом
			5 => "IFNULL($join_alias.$field_name, 0)"
		};
		$doc_field -> {order_field} = $orderby_expression -> {$doc_field -> {field_type}}
			|| "$join_alias.$field_name";

		$doc_field -> {join_alias} = "$join_alias";
		$doc_field -> {full_name} = "$join_alias.$field_name";

		$join_id++;
	}

	# дополняем фильтры для выборки доп. полей
	# (в последнюю очередь, в отдельном цикле, иначе может нарушится соответствие подставляемых значений и ? в $filter)
	foreach my $doc_field (@$doc_fields_to_show) {

		my $value = $_REQUEST {$doc_field -> {key}};
		my $value_to = $_REQUEST {$doc_field -> {key} . '_to'};

		next if !$doc_field -> {full_name} || !$value && !$value_to;

		if ($doc_field -> {field_type} =~ /0|6/) { # строка или многострочный ткст

			$query_options -> {filter} .= " AND $doc_field->{full_name} LIKE ? ";
			push @{$query_options -> {filter_params}}, '%' . $value . '%';

		} elsif ($doc_field -> {field_type} =~ /1|2/) { # число или поле типа 'денежный'

			if ($value) {
				$query_options -> {filter} .= " AND $doc_field->{full_name} >= ?";
				push @{$query_options -> {filter_params}}, $value;
			}
			if ($value_to) {
				$query_options -> {filter} .= " AND $doc_field->{full_name} <= ?";
				push @{$query_options -> {filter_params}}, $value_to;
			}

		} elsif ($doc_field -> {field_type} == 3){ #дата

			if ($value) {
				$query_options -> {filter} .= " AND $doc_field->{full_name} >= ?";
				push @{$query_options -> {filter_params}}, dt_iso ($value);
			}
			if ($value_to) {
				$query_options -> {filter} .= " AND $doc_field->{full_name} <= ?";
				push @{$query_options -> {filter_params}}, dt_iso ($value_to);
			}

		} elsif ($doc_field -> {field_type} == 5) { # чекбокс

			$query_options -> {filter} .= " AND $doc_field->{full_name} = ?";
			push @{$query_options -> {filter_params}}, $value == 1? 1 : 0;
		}
	}

}

################################################################################

sub _tasks_set_query_options_for_voc_value {

	my ($query_options, $join_id, $doc_field) = @_;

	# источник значения - таблица указанная в label_field доп поля или sql-запрос (из sql_source). По умолчанию общий справочник - docs
	my $voc = sql_select_hash ('doc_types', $doc_field -> {id_doc_type});
	$voc -> {name} ||= 'docs';

	return
		if is_multi_value_doc_field ($doc_field);

	my $voc_alias_label_field_name;
	if ($voc -> {label_field}) {

		$doc_field -> {order_field} = $voc -> {label_field};
		$doc_field -> {order_field} =~ s/$voc->{name}\./source$join_id./g
			if ($voc -> {name});

		$voc_alias_label_field_name = $voc -> {label_field};
		$voc_alias_label_field_name =~ s/$voc->{name}\./source./g
			if ($voc -> {name});

	} else {

		$doc_field -> {order_field} = "source$join_id.label";
		$voc_alias_label_field_name = 'source.label';

	}

	my $join_table = $voc -> {sql_source} ? "($voc->{sql_source})" : $voc->{name};

	$query_options -> {joins} .= <<EOS;
			LEFT JOIN (
				SELECT
					doc_field_data.id_type
					, doc_field_data.id_doc_voc_data
					, GROUP_CONCAT($voc_alias_label_field_name SEPARATOR '<br>') AS label
				FROM
					doc_field_data
					INNER JOIN $join_table source ON doc_field_data.id_doc_voc_data = source.id
				WHERE
					doc_field_data.id_type IS NOT NULL -- вообще-то нужно связать с tasks.id
					AND doc_field_data.id_doc_type = $ID_DOC_TYPE_TASKS
					AND doc_field_data.id_doc_field = ?
					AND doc_field_data.id_doc_field_group = ?
					AND doc_field_data.fake = 0
				GROUP BY
					doc_field_data.id_type
			) AS source$join_id ON source$join_id.id_type = tasks.id
EOS
	push @{$query_options -> {join_params}},
		$doc_field -> {id}, $doc_field -> {id_doc_field_group} + 0;


	$query_options -> {labels} .= ", source$join_id.label AS '$doc_field->{key}'\n";
}




################################################################################

sub task_dt_from_plan_read_only { # определяет доступность поля 'Дата начала плановая'

	my ($data) = @_;

	return editing_prohibited_by_task_template ($data)
		|| $data -> {id_task_status} > 1
		|| $_REQUEST {_id_task_status}
		|| ($data -> {id_task_status} == 1 && !$data -> {is_initiator});

}

################################################################################

sub task_dt_to_plan_read_only {# определяет доступность поля 'Дата завершения плановая'

	my ($data) = @_;

	return editing_prohibited_by_task_template ($data)
		|| $_REQUEST {_id_task_status}
		|| !(

			(
				$data -> {id_task_status} <= 3
				&&
				(
					$data -> {is_inspector}
					||
					$data -> {is_admin}
				)
				&&
				$data -> {task_type} -> {is_can_insp_chng_dt_plan_to}
			)
			||
			($data -> {id_task_status} == 1 && $data -> {is_initiator}),
		),
}


################################################################################
# опция 'Разрешить инициатору менять параметры задачи'
# выставлена в 'запрещено' (инициатору или всем)
sub editing_prohibited_by_task_template {

	my ($data) = @_;

	if ($data -> {id_task_route_task} && !exists $data -> {task_route_tasks}) {
		$data -> {task_route_tasks} = sql_select_hash (task_route_tasks => $data -> {id_task_route_task});
	}

	my $is_editing_prohibited = $data -> {id_task_route_task}
		&& ($data -> {task_route_tasks} -> {is_initiator_can_update_task} == 2);

	my $is_editing_prohibited_to_initiator = $data -> {id_task_route_task}
		&& !$data -> {task_route_tasks} -> {is_initiator_can_update_task};

	return $is_editing_prohibited
		|| $is_editing_prohibited_to_initiator && $data -> {is_initiator};
}


