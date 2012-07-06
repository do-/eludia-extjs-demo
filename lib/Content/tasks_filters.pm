################################################################################

sub validate_apply_tasks_filters { # применяет и сохраняет фильтр
	
	my $data = sql ($conf -> {systables} -> {__queries});
	
	$_REQUEST {_setting__label} || $data -> {id} == $_REQUEST {default_filter_id} || $_REQUEST {type} ne 'tasks'
		or return '#_setting__label#: Укажите название фильтра';

	undef;
}

################################################################################

sub do_apply_tasks_filters { # применение фильтров (редирект на экран задач)

	my $error = _tasks_filters_update_task_filter ();
	
	if ($error) {
		$_REQUEST {__redirect_alert} = $error;
		return;
	}
	
	# фильтр становится текущим для пользователя
	set_user_value ('selected_filter_id', $_REQUEST {id});

	my $esc = esc_href();
	
	$esc =~ s/&id_filter=\d+//gi;
	$esc .= '&id_filter=' . $_REQUEST {id};
	
	$esc =~ s/&__order_context=[^&;]+//gi;
	$esc .= '&__order_context=' . uri_escape (delete $_REQUEST {order_context});
	
	$esc =~ s/&id_filter_previous=\d+//gi;
	
	# зашли с портала, и настроили фильтры, они должны примениться
	$esc =~ s/&skip_filters=\d+//gi;
	
	# если сузили область до пары страниц вместо тысяч, переходим на первую страницу
	$esc =~ s/&start=\d+//gi;
	
	$esc =~ s/&order=\w+//gi;
	
	redirect ($esc, {kind => 'js'});

}

################################################################################

sub validate_make_public_tasks_filters {
	
	$_USER -> {options_hash} -> {admin} || $_USER -> {options_hash} -> {admin_docflow}
		or return 'Общие фильтры может создавать только администратор';

	undef;
}

################################################################################

sub do_make_public_tasks_filters { # публикует пользовательский фильтр для всех пользователей

	# пользователь возможно поменял текущий фильтр
	my $content = extract_filters_values ();
	
	sql ($conf -> {systables} -> {__queries} => [
		[id       => $_REQUEST {id}],
		[UPDATE => [
			[id_user => undef],	
			[dump    => Dumper ($content)],
		]],
	]);
}

################################################################################

sub is_equal_filters { # определяет эквивалентность наборов фильтрации
	
	my ($filter1, $filter2) = @_;

	# сравниваем наборы колонок
	my %union_columns = ();
	foreach (keys %{$filter1 -> {columns}}, keys %{$filter2 -> {columns}}) {
		$union_columns {$_} = 1;
	}
	
	foreach my $key (keys %union_columns) {
		my $col1 = exists $filter1 -> {columns} -> {$key}? $filter1 -> {columns} -> {$key} : {};
		my $col2 = exists $filter2 -> {columns} -> {$key}? $filter2 -> {columns} -> {$key} : {};
		
		foreach (qw (desc ord sort)) {
			$col1 -> {$_} ||= '';
			$col2 -> {$_} ||= '';
			
			return 0
				if $col1 -> {$_} ne $col2 -> {$_};
		}
	}
	
	# сравниваем наборы фильтров	
	my %union_filters = ();
	foreach (keys %{$filter1 -> {filters}}, keys %{$filter2 -> {filters}}) {
		$union_filters {$_} = 1;
	}
	foreach my $key (keys %union_filters) {
		my $f1 = exists $filter1 -> {filters} -> {$key}? $filter1 -> {filters} -> {$key} : '';
		my $f2 = exists $filter2 -> {filters} -> {$key}? $filter2 -> {filters} -> {$key} : '';
		
		if ($f1 =~ m/^\d+$/ && $f2 =~ m/^\d+$/) {
			return 0 if $f1 != $f2;
			next;
		}
			
		my @f1_ids = sort (map {$_ > 0} split /,/, $f1);
		my @f2_ids = sort (map {$_ > 0} split /,/, $f2);
		
		return 0
			if !(@f1_ids ~~ @f2_ids);
	}
	
	return 1;
}

################################################################################

sub get_filter {

	my ($dump) = @_;
	
	my $VAR1;
	eval $dump;
	
	return $VAR1;
}

################################################################################
# сохраняет настройки текущего фильтра
# возвращает текст ошибки (или undef при успехе)
sub _tasks_filters_update_task_filter {
	
	my $edited_filter = sql ($conf -> {systables} -> {__queries});
	
	# формируем описание параметров сортировки и порядка полей (часть do_update___queries())
	my $content = extract_filters_values ();
	
	# перед нажатием на кнопку 'применить' фильтр был отредактирован
	if  (!is_equal_filters ($content, get_filter ($edited_filter -> {dump}))
		 && $edited_filter -> {label} eq $_REQUEST {_setting__label})
	{
		
		return 'Общие фильтры может изменять только администратор'
			if !$edited_filter -> {id_user}
				&& !(
					$_USER -> {options_hash} -> {admin}
					|| $_USER -> {options_hash} -> {admin_docflow}
				);
	}
	
	if ($_REQUEST {_setting__label} eq '') {# переписываем настройки фильтра по умолчанию
		
		sql ($conf -> {systables} -> {__queries} => [
			[id => $_REQUEST {id}],
			[UPDATE => [
				[order_context   => $_REQUEST {order_context}],
				[dump    => Dumper ($content)],
				[label   => 'default'],
				[id_user => $_USER -> {id}],
				[type    => 'tasks'],
			]]
		]);
		
		return undef;
	}

	my $is_filter_edited = $edited_filter -> {id} && $_REQUEST {_setting__label} eq $edited_filter -> {label};

	# переписываем определение фильтра, найденное по имени
	$_REQUEST {id} = sql_select_id ($conf -> {systables} -> {__queries} => {
		 order_context   => $_REQUEST {order_context},
		 -label   => $_REQUEST {_setting__label},
		 -dump    => Dumper ($content),
		 id_user  => $is_filter_edited? $edited_filter -> {id_user} || 0 : $_USER -> {id},
		 parent   => $edited_filter -> {id},
		 type     => 'tasks',
		 -fake    => 0,
		},
		[qw(id_user label order_context)],
	);
	
	return undef;
}

################################################################################

sub get_item_of_tasks_filters { # Фильтры на задачи
	
	$_REQUEST {default_filter_id} = get_user_value ('default_filter_id');	
		
	# если нет фильтра по умолчанию, создаем и сохраняем его id для дальнейшего использования
	unless ($_REQUEST {id} > 0) {
		
		$_REQUEST {id} = $_REQUEST {default_filter_id};
		
		# фильтры хранятся в системной таблице __queries
		$_REQUEST {id} ||= sql_select_id ($conf -> {systables} -> {__queries} => {
				-dump => _tasks_filters_get_default_filter (),
				-id_user => $_USER -> {id},
				-order_context   => $_REQUEST {order_context},
				-label   => 'default',
				-type    => 'tasks',
				-fake    => 0,
			},
			['id_user', 'order_context', 'type', 'label'],
		);
		
		set_user_value ('default_filter_id', $_REQUEST {id});
		$_REQUEST {default_filter_id} = $_REQUEST {id};
	}
	
	# восстанавливаем сохраненные значения фильтров
	my $data = sql ($conf -> {systables} -> {__queries});
	$data -> {content}  = get_filter ($data -> {dump});
	
	foreach my $field (keys %{$data -> {content} -> {filters}}) {
		$_REQUEST {$field} = $data -> {content} -> {filters} -> {$field};
	}
	delete $_REQUEST {id_user_executor}
		if !exists $data -> {content} -> {filters} -> {id_user_executor};

	$data -> {content} -> {filters} -> {id_voc_agent} ||= -1;
	add_vocabularies ($data,
		voc_agents => {
			filter => "id=$data->{content}->{filters}->{id_voc_agent}",
			off    => !(keys (%{$DB_MODEL -> {tables} -> {voc_agents}}) + keys (%{$DB_MODEL -> {tables} -> {voc_firms}})),
			name   => keys (%{$DB_MODEL -> {tables} -> {voc_agents}}) ? 'voc_agents' : 'voc_firms',
		},
		'task_routes',
		'task_importances',
		'task_status',
	);
	
	my $user_and_assistants = join ',', ($_USER -> {id}, sql_select_col ('SELECT id_user FROM user_replacements WHERE fake = 0 AND is_tasks = 1 AND id_assistant = ? AND dt_from <= CURDATE() AND dt_to >= CURDATE()', $_USER -> {id}));
	
	$_REQUEST {id_user_initiator} ||= 0;
	$data -> {user_initiators} = sql_select_vocabulary ('users'	=> {filter => "id IN ($_REQUEST{id_user_initiator}, $user_and_assistants)"});

	$_REQUEST {id_user_inspector} ||= 0;
	$data -> {user_inspectors} = sql_select_vocabulary ('users'	=> {filter => "id IN ($_REQUEST{id_user_inspector}, $user_and_assistants)"});

	$data -> {user_executors} = sql_select_vocabulary ('users'	=> {
		in => $_REQUEST {user_executor_ids} || $_REQUEST {id_user_executor} || '-1'
	});
	
	$data -> {avialable_filters} = sql ($conf -> {systables} -> {__queries} => [
		['IFNULL(id_user,0) IN' => [0, $_USER -> {id}]], # в подсказке свои и общие фильтры
		['label LIKE ?%' => $_REQUEST {_setting__label}],
		['label LIKE %?%'=> '_'],
		[order_context   => $_REQUEST {order_context}],
		[type            => 'tasks'],
		[ LIMIT          => [0, 15]],
	]);
	
	
	$data -> {label} = '' if $data -> {label} eq 'default';
	
	# выбранные задачи наследуются от предыдущего экрана (при смене задач экран обновляется) или из сохраненного фильтра
	my $updated_task_types_ids = exists($_REQUEST {_filter_task_type_ids})? $_REQUEST {_filter_task_type_ids}
		: $data -> {content} -> {filters} -> {task_type_ids};
	
	$data -> {extra_fields} = get_task_types_union_doc_fields ($updated_task_types_ids);
	
	# выбранные типы документов и типы задач
	my $selected_doc_type_ids = [-1, split (/,/, $data -> {content} -> {filters} -> {base_doc_type_ids})];
	my $selected_task_type_ids = [-1, split (/,/, $updated_task_types_ids)];
	$data -> {doc_types} = sql (doc_types => [
		[id => $selected_doc_type_ids],
	]);
	$data -> {task_types} = sql (task_types => [
		[id => $selected_task_type_ids],
	]);
		
	return $data;

}



################################################################################

sub select_tasks_filters { # фильтры для экрана списка фильтров

	my $data;
	
	# выбираем свои и общие фильтры
	($data -> {tasks_filters}, $data -> {cnt}) = sql (
		$conf -> {systables} -> {__queries} => [
			['IFNULL(id_user,0) IN' => [0, $_USER -> {id}]],
			[order_context       => $_REQUEST {order_context}],
			[type                => 'tasks'],
			['label LIKE %?%'    => $_REQUEST {q}],
			# пропускаем записи с пустым именем, созданные стандартным механизмом фильтрации
			# FIXME: разобраться, почему простое ['label <> ?' => ''], не работает
			['label LIKE %?%'       => '_'],
			['label <> ?'           => 'default'],
			[ LIMIT => [0 + $_REQUEST {start}, $conf -> {portion}]],
		],
		'users',
	);
	
	return $data;
}

################################################################################

sub validate_delete_tasks_filters {

	my $data = sql ($conf -> {systables} -> {__queries});

	if ($_USER -> {options_hash} -> {admin} || $_USER -> {options_hash} -> {admin_docflow}) {
		!$data -> {id_user} || $data -> {id_user} == $_USER -> {id}
			or return 'Нельзя удалять чужой фильтр';
	} else {
		$data -> {id_user} == $_USER -> {id}
			or return 'Нельзя удалять чужой фильтр';
	}

	undef;
}

################################################################################

sub do_delete_tasks_filters { # удалаяет фильтр. уходим на экран фильтра по умолчанию

	sql_do ("UPDATE $conf->{systables}->{__queries} SET fake = -1 WHERE id = ?", $_REQUEST {id});

	# после удаления пользователь отправляется на экран фильтра по умолчанию
	set_user_value ('selected_filter_id', $_REQUEST {default_filter_id});
	$_REQUEST {id_filter} = $_REQUEST {default_filter_id};

	# удалив фильтр, пользователь жмет esc с экрана фильтра по умолчанию - на вызывающем экране применен удаленный фильтр
	my $esc_href = sql_select_scalar (
		"SELECT href FROM $conf->{systables}->{__access_log} WHERE id_session = ? AND no = ?",
		$_REQUEST {sid},
		$_REQUEST {__last_last_query_string}
	);

	$esc_href =~ s/[\&\?]id_filter=\d+//;
	$esc_href .= "&id_filter=$_REQUEST{default_filter_id}";

	sql_do ("UPDATE $conf->{systables}->{__access_log} SET href = ? WHERE id_session = ? AND no = ?",
		$esc_href,
		$_REQUEST {sid},
		$_REQUEST {__last_last_query_string}
	);
	
	#warn Dumper \%_REQUEST;
	redirect (
		{
			type   => 'tasks_filters',
			id     => $_REQUEST {default_filter_id},
			action => '',
			__last_query_string => $_REQUEST{__last_last_query_string}, # keep_esc => 1
		},
		{kind => 'js', keep_esc => 1}
	);

}

################################################################################

sub get_user_value { # восстанавливает значение именованой настройки для данного пользователя

	my ($name) = @_;

	local $_REQUEST {order_context} = $_REQUEST {__order_context}
		if $_REQUEST {type} ne 'tasks_filters';
		
	my $context = "type=tasks&order_context=$_REQUEST{order_context}&id_user=" . $_USER -> {id};
	my $setting = sql ($conf -> {systables} -> {__defaults} => [
		[name    => $name],
		[context => $context],
		[LIMIT   => 1]
	]);
	
	return $setting -> {value};
}	

################################################################################

sub set_user_value { # сохраняет значение именованой настройки для данного пользователя

	my ($name, $value) = @_;

	local $_REQUEST {order_context} = $_REQUEST {__order_context}
		if $_REQUEST {type} ne 'tasks_filters';
		
	my $context = "type=tasks&order_context=$_REQUEST{order_context}&id_user=" . $_USER -> {id};
	sql_select_id ($conf -> {systables} -> {__defaults} => {
			fake    => 0,
			context => $context,
			name    => $name,
			-value  => $value,
	
		},
		['context', 'name']
	);
}	

################################################################################

sub extract_filters_values { # формирует хэш-описание фильтров и порядка колонок из параметров запроса

	my $content;
	
	my @order = ();
	
	foreach my $key (keys %_REQUEST) {
	
		$key =~ /^_(\w+)_(desc|ord)$/ or next;
		
		my $order = $1;
		
		$content -> {columns} -> {$order} = {
			ord  => $_REQUEST {"_${order}_ord"},
			sort => $_REQUEST {"_${order}_sort"},
			desc => $_REQUEST {"_${order}_desc"},
		};
		
		# выбирать невидимые доп. поля ради сортировки по ним дорого
		my $doc_field_sort_without_showing = $order =~ /^[_|\d]+$/
			&& !$content -> {columns} -> {$order} -> {ord};
			
		if ($doc_field_sort_without_showing) {
			$content -> {columns} -> {$order} -> {sort} = '';
		}
		
		if ($_REQUEST {"_${order}_sort"}) {
		
			$order [ $_REQUEST {"_${order}_sort"} ]  = $order;
			$order [ $_REQUEST {"_${order}_sort"} ] .= ' DESC' if $_REQUEST {"_${order}_desc"};
		
		}
	
	}
	
	foreach my $key (keys %_REQUEST) {
	
		$key =~ /^_filter_+(\w+)$/ or next;
		
		my $filter = $1;
		
		$content -> {filters} -> {$filter} = $_REQUEST {$key} || '';
	
	}
	
	# указан фильтр на единственного пользователя: высвечиваем его в тулбаре списка задач
	my @selected_user_executors = grep {$_ > 0}
		split /,/, $content -> {filters} -> {user_executor_ids};
		
	if (1 == @selected_user_executors) {
		$content -> {filters} -> {id_user_executor} = $selected_user_executors [0];
		delete $content -> {filters} -> {user_executor_ids};
	}
	
	return $content;
}

################################################################################

sub _tasks_filters_get_default_filter {

	my $filter  = {

		columns => {
		
			no => {
				'desc' => '1',
				'ord' => '1',
				'sort' => '2'
			},
			dt => {
				'desc' => '1',
				'ord' => '2',
				'sort' => '1'
			},
			
			dt_to_plan => {
				'desc' => '0',
				'ord' => '3',
				'sort' => ''
			},
			task_importance_label => {
				'desc' => '0',
				'ord' => '4',
				'sort' => ''
			},
			label => {
				'desc' => '0',
				'ord' => '5',
				'sort' => ''
			},
			user_executor_label => {
				'desc' => '0',
				'ord' => '6',
				'sort' => ''
			},
			user_inspector_label => {
				'desc' => '0',
				'ord' => '7',
				'sort' => ''
			},
		},
		
		filters => {
			id_user_executor => $_USER -> {id},
		}
	};
	
	# скрываем остальные столбцы
	foreach (qw (dt_to_fact deviation task_status_label task_type_label base_doc_label user_initiator_label voc_agent_label)) {
		$filter -> {columns} -> {$_} = {'ord' => 0};
	}

	return Dumper($filter);
}

1;
