
################################################################################

sub check_task_rights {

	my ($task, $options) = @_;

	my $id_user = $options -> {id_user} || $_USER -> {id};
	my $check_user;
	if ($id_user != $_USER -> {id}) {
		$check_user = sql_select_hash ('users', $id_user);
		foreach (split /\,/, $check_user -> {options}) {$check_user -> {options_hash} -> {$_} = 1};
		$check_user -> {hr_order} = sql_select_hash ('SELECT * FROM hr_orders WHERE fake = 0 AND id_user = ? ORDER BY dt DESC LIMIT 1', $check_user -> {id});
	} else {
		$check_user = $_USER;
	}

## Себя пока не проверяем
	my $check_users = [
		{
			id_user	=> $id_user,
		},
	];

#warn Dumper $item;

	my $replaced_users = sql_select_all (<<EOS, $id_user, $task -> {id_doc_type} && $task -> {id_type} ? 1 : 0);
		SELECT
			id_user
		FROM
			user_replacements
		WHERE
			user_replacements.id_assistant = ?
		AND
			(
				is_tasks = 1
				OR
				IF(? = 1, is_docs, 0) = 1
			)
		AND
			CURDATE() >= dt_from AND CURDATE() <= dt_to
		AND
			fake = 0
EOS

	foreach my $replaced_user (@$replaced_users) {
#кроме тех которые были завершены до перевода замещаемого в текущее его подразделение
		($replaced_user -> {dt}, $replaced_user -> {is_boss}) = sql_select_array ('SELECT dt, is_boss FROM hr_orders WHERE fake = 0 AND id_user = ? ORDER BY dt DESC LIMIT 1', $replaced_user -> {id_user});

		unless ($replaced_user -> {is_boss}) {
			$replaced_user -> {task_conditions} = " !\$task -> {dt_to_fact} || \$task -> {dt_to_fact} gt '$replaced_user->{dt}' ";
		}

	}

	$task -> {is_initiator} =
		$task -> {id_user_initiator} == $id_user ||
		0 + grep {$_ -> {id_user} == $task -> {id_user_initiator}} (@$replaced_users);

	my $replaced_user_ids = join ',', -1, ($id_user, map {$_ -> {id_user}} @$replaced_users);

	my @subordinate_user_ids;

	if ($check_user -> {hr_order} -> {is_boss}) {
#		@subordinate_user_ids = sql_select_col (<<EOS, "%_$check_user->{hr_order}->{id_dep}");
		@subordinate_user_ids = sql_select_col (<<EOS, $check_user -> {hr_order} -> {id_dep});
			SELECT
				id_user
			FROM
				hr_orders
			WHERE
				fake = 0
			AND
				dt <= CURDATE()
			AND
				IFNULL(dt_to, '9999-12-31') > CURDATE()
			AND
				id_dep = ?
			GROUP BY
				id_user
EOS

		my @subordinate_deps = sql_select_col ('SELECT id FROM deps WHERE parent = ? AND fake = 0', $check_user -> {hr_order} -> {id_dep});
		foreach my $id_dep (@subordinate_deps) {
#			push @subordinate_user_ids, sql_select_col (<<EOS, "%_$id_dep");
			push @subordinate_user_ids, sql_select_col (<<EOS, $id_dep);
				SELECT
					id_user
				FROM
					hr_orders
				WHERE
					fake = 0
				AND
					is_boss = 1
				AND
					dt <= CURDATE()
				AND
					IFNULL(dt_to, '9999-12-31') > CURDATE()
				AND
					id_dep = ?
				GROUP BY
					id_user
EOS
		}

	}

	$task -> {is_executor} =
		$task -> {id_user_executor} == $check_user -> {id} ||
		$task -> {id_user_executor} == 0 && sql_select_scalar ("SELECT id FROM user_workgroups WHERE id_user IN ($replaced_user_ids) AND id_workgroup = ? AND fake = 0", $task -> {id_workgroup_executor}) ||
		(0 + grep {$_ -> {id_user} == $task -> {id_user_executor}} @$replaced_users) ||
		(0 + grep {$_ == $task -> {id_user_executor}} @subordinate_user_ids);


#	my $replaced_user_
	($task -> {is_admin}, $task -> {is_can_view}) = sql_select_col (<<EOS, $task -> {id_task_type});
		SELECT
			SUM(task_type_rights.is_admin)
			, SUM(task_type_rights.is_can_view)
		FROM
			task_type_rights
			LEFT JOIN user_workgroups ON task_type_rights.id_workgroup = user_workgroups.id_workgroup AND user_workgroups.fake = 0 AND user_workgroups.id_user IN ($replaced_user_ids, $check_user->{id})
		WHERE
			task_type_rights.fake = 0
		AND
			task_type_rights.id_task_type = ?
		AND
			(task_type_rights.is_admin = 1 OR task_type_rights.is_can_view = 1)
		AND
			(user_workgroups.id IS NOT NULL OR task_type_rights.id_workgroup = 1)
EOS

	if ($task -> {id_task_route_item}) {

		$task -> {is_admin} ||= sql_select_scalar (<<EOS, $task -> {id_task_route_item});
			SELECT
				task_route_rights.id
			FROM
				task_route_items
				INNER JOIN task_route_rights ON task_route_items.id_task_route = task_route_rights.id_task_route AND task_route_rights.is_admin = 1 AND task_route_rights.fake = 0
				LEFT JOIN user_workgroups ON task_route_rights.id_workgroup = user_workgroups.id_workgroup AND user_workgroups.fake = 0 AND user_workgroups.id_user IN ($replaced_user_ids, $check_user->{id})
			WHERE
				task_route_items.id = ?
			AND
				(user_workgroups.id IS NOT NULL OR task_route_rights.id_workgroup = 1)
EOS


	}

	$task -> {is_inspector} =
		$task -> {id_user_inspector} == $check_user -> {id} ||
		$task -> {is_admin} ||
		(0 + grep {$_ -> {id_user} == $task -> {id_user_inspector}} @$replaced_users);

	$task -> {is_can_view} ||= $task -> {is_initiator}
		|| $task -> {is_inspector}
		|| $task -> {is_admin}
		|| $task -> {is_executor};

	return
		if $task -> {is_can_view};

# Далее могут быть даны права только на просмотр задачи
	my $replaced_users_by_doc = $task -> {id_doc_type} && $task -> {id_type} ? sql_select_all (<<EOS, $id_user) : [];
		SELECT
			id_user
		FROM
			user_replacements
		WHERE
			user_replacements.id_assistant = ?
		AND
			is_docs = 1
		AND
			CURDATE() >= dt_from AND CURDATE() <= dt_to
		AND
			fake = 0
EOS

	$task -> {is_can_view} =
		(0 + grep {$_ -> {id_user} == $task -> {id_user_initiator}} @$replaced_users_by_doc) ||
		(0 + grep {$_ -> {id_user} == $task -> {id_user_executor}}  @$replaced_users_by_doc) ||
		(0 + grep {$_ -> {id_user} == $task -> {id_user_inspector}} @$replaced_users_by_doc);

	return
		if $task -> {is_can_view};

	push @$check_users, @$replaced_users, @$replaced_users_by_doc;

	my $deps = sql_select_all ('SELECT id, dt, dt_to, id_dep, is_boss FROM hr_orders WHERE id_user = ? AND fake = 0 ORDER BY dt', $check_user -> {id});

	my $deps_filter;

	for (my $i=0; $i < @$deps; $i ++) {
#warn $i;
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
				my $users = sql_select_all (<<EOS, $id_dep);
					SELECT
						*
					FROM
						hr_orders
					WHERE
						$dep->{user_filter}
					AND
						id_dep = ?
EOS
#warn Dumper $users;
				foreach my $user (@$users) {

					my ($dt_from, $dt_to);

					$dt_from = $dep -> {dt} gt $user -> {dt} ? $dep -> {dt} : $user -> {dt};

					$user -> {task_conditions} = "(\$task -> {dt} ge '$dt_from' || \$task -> {dt_to_fact} ge '$dt_from')";

					if ($dep -> {dt_to} || $user -> {dt_to}) {

						if (!$dep -> {dt_to}) {

							$dt_to = $user -> {dt_to};

						} elsif (!$user -> {dt_to}) {

							$dt_to = $dep -> {dt_to};

						} else {
							$dt_to = $dep -> {dt_to} gt $user -> {dt_to} ? $user -> {dt_to} : $dep -> {dt_to};
						}

						$user -> {task_conditions} .= " && \$task -> {dt} le '$dt_to'"
					} else {

						$user -> {task_conditions} .= " || \$task -> {id_task_status} < 4"

					}

					push @$check_users, $user;

				}

			}

		}
	}

	my $check_tasks = [$task];
	$task -> {task_type} = sql_select_hash ('task_types', $task -> {id_task_type});

	my $parent = $task;
	while ($parent -> {parent}) {
		$parent = sql_select_hash ('tasks', $parent -> {parent});
		$parent -> {task_type} = sql_select_hash ('task_types', $parent -> {id_task_type});
		push @$check_tasks, $parent;
	}

	if ($task -> {task_type} -> {is_can_child_view_parents}) {
		my $parent_ids = $task -> {id};

		while (TRUE) {

			my $children = sql_select_all ("SELECT * FROM tasks WHERE parent IN ($parent_ids) AND fake = 0");
			$parent_ids = '';
			foreach my $child (@$children) {
				push @$check_tasks, $child;

				$child -> {task_type} = sql_select_hash ('task_types', $child -> {id_task_type});
				$parent_ids = $child -> {id} . ','
					if ($child -> {task_type} -> {is_can_child_view_parents});
			}

			last unless $parent_ids;

			substr ($parent_ids, -1, 1) = '';

		}


	}

	if ($task -> {id_task_route_item}) {

		my $relatives = sql_select_all ('SELECT * FROM tasks WHERE id_task_route_item = ? AND fake = 0 AND id <> ?',
			$task -> {id_task_route_item}, $task -> {id});

		push @$check_tasks, @$relatives;
	}

	my %tasks = map {($_ -> {id}, $_)} @$check_tasks;

	foreach my $t (values %tasks) {

		foreach my $user (@$check_users) {

			if ($user -> {task_conditions}) {

				unless (eval $user -> {task_conditions}) {
					warn $@
						if $@;

#					warn "is_evaled 0";
					next;
				}
#					warn "is_evaled 1";
			}

			if ($user -> {id_user} =~ /^($$t{id_user_initiator}|$$t{id_user_executor}|$$t{id_user_inspector})$/) {
				$task -> {is_can_view} = 1;
				$task -> {is_can_view_user_reason} = $user -> {id_user};
				$task -> {is_can_view_task_reason} = $t -> {id};
				$task -> {is_can_view_reason} = 'initiator|executor|inspector';

				return;
			}

			my $task_histories = sql_select_all ('SELECT id_user_initiator, id_user_executor, id_user_inspector FROM task_histories WHERE id_task = ?', $t -> {id});
			foreach my $task_history_item (@$task_histories) {
				if ($user -> {id_user} =~ /^($$task_history_item{id_user_initiator}|$$task_history_item{id_user_executor}|$$task_history_item{id_user_inspector})$/) {
					$task -> {is_can_view} = 1;
					$task -> {is_can_view_user_reason} = $user -> {id_user};
					$task -> {is_can_view_task_reason} = $t -> {id};

					$task -> {is_can_view_reason} = 'history initiator|executor|inspector';

					return;
				}
			}

			next
				if ($user -> {id_user} != $check_user -> {id} && $user -> {id_dep});
# Данные права не распространяются по иерархии
			my $user_workgroups = '1,' . sql_select_ids ('SELECT id_workgroup FROM user_workgroups WHERE fake = 0 AND id_user = ?', $user -> {id_user});

			if (sql_select_scalar (<<EOS, $t -> {id_task_type})) { $task -> {is_can_view} = 1; $task -> {is_can_view_user_reason} = $user -> {id_user}; $task -> {is_can_view_task_reason} = $t -> {id}; $task -> {is_can_view_reason} = 'task_type_admin'; return; }
				SELECT
					task_type_rights.id
				FROM
					task_type_rights
				WHERE
					task_type_rights.fake = 0
				AND
					task_type_rights.id_task_type = ?
				AND
					task_type_rights.is_admin = 1
				AND
					task_type_rights.id_workgroup IN ($user_workgroups)
EOS

			if (sql_select_scalar (<<EOS, $t -> {id_task_route_item})) { $task -> {is_can_view} = 1; $task -> {is_can_view_reason} = 'task_route_admin'; return; }
				SELECT
					task_route_rights.id
				FROM
					task_route_items
					INNER JOIN task_route_rights ON task_route_items.id_task_route = task_route_rights.id_task_route AND is_admin = 1 AND id_workgroup IN ($user_workgroups)
				WHERE
					task_route_items.id = ?
EOS



		}
	}


}
