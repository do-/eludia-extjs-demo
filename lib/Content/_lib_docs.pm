


################################################################################
# поле типа документа, определящеее доступность основного поля документа

sub doc_type_access_field {

	my ($field) = @_;

	my $doc_type_rights_fields = {
		'prefix'        => 'field_prefix',
		'no'            => 'field_no',
		'dt'            => 'field_dt',
		'id_doc_type'   => 'field_doc_type',
		'id_doc_kind'   => 'field_doc_kind',
		'no_ext'        => 'field_no_ext',
		'dt_ext'        => 'field_no_ext',
		'label'         => 'field_label',
		'id_user'       => 'field_id_user',
		'dt_register'   => 'field_id_user',
		'id_doc_folder' => 'field_doc_folder',
		'id_doc_status' => 'field_doc_status',
	};

	return $doc_type_rights_fields -> {$field};
}

################################################################################

sub field_accessibility { # доступность по процессу поля документа

	my ($data, $field) = @_;
	return $data -> {doc_type_rights} -> {$field}
		if exists $data -> {doc_type_rights} -> {$field};

	return $data -> {doc_type} -> {doc_type_access_field ($field)};
}

################################################################################

sub is_field_editable {

	my ($data, $field) = @_;

	return field_accessibility ($data, $field) ~~ [
		$FIELD_ACCESSIBILITY_EDITABLE,
		$FIELD_ACCESSIBILITY_MANDATORY,
	];
}

################################################################################

sub is_field_mandatory {
	my ($data, $field) = @_;
	return field_accessibility ($data, $field) == $FIELD_ACCESSIBILITY_MANDATORY;
}

################################################################################

sub is_field_read_only {
	my ($data, $field) = @_;
	return field_accessibility ($data, $field) == $FIELD_ACCESSIBILITY_READ_ONLY;
}

################################################################################

sub is_field_hidden {
	my ($data, $field) = @_;
	return field_accessibility ($data, $field) == $FIELD_ACCESSIBILITY_HIDDEN;
}

################################################################################

sub _feature {

	if (exists $conf -> {features} && exists $conf -> {features} -> {$_[0]}) {
#warn "_feature $_ is exists";
		return $conf -> {features} -> {$_[0]};
	} else {
#warn "_feature $_ is'nt exists";
		return 1;
	}
}

################################################################################

sub get_doc_field_data_field {

	my ($options) = @_;

	return $options -> {field_type} == 0 ? 'label' :
		$options -> {field_type} == 1 ? 'sum' :
		$options -> {field_type} == 2 ? 'price' :
		$options -> {field_type} == 3 ? 'dt' :
		$options -> {field_type} == 4 ?
			$options -> {select_type} ~~ [$SELECT_TYPE_CHECKBOXES, $SELECT_TYPE_MULTI_SELECT] ?
				'notes' : 'id_doc_voc_data' :
		$options -> {field_type} == 5 ? 'sum' :
		$options -> {field_type} == 6 ? 'notes' :
		$options -> {field_type} == 7 ? 'file_name' :
			'label';

}

################################################################################
# тип выбора значения доп.поля позволяет выбрать нескольких значений

sub is_multi_value_doc_field {

	my ($doc_field) = @_;

	return $doc_field -> {select_type} ~~
		[$SELECT_TYPE_CHECKBOXES, $SELECT_TYPE_MULTI_SELECT];
}

################################################################################
# тип выбора значения доп.поля позволяет выбрать одно значение

sub is_single_value_doc_field {

	my ($doc_field) = @_;

	return $doc_field -> {select_type} ~~
		[$SELECT_TYPE_SINGLE, $SELECT_TYPE_RADIO];
}

################################################################################
# get_user_fields - возвращает перечень полей документов и их значений
# Параметры:
# options:
#	all_periods                  - возвращаются все значения полей (для всех периодов)
#	doc_field_groups_ids         - ограничение перечня полей перечисленными групповыми полями
#	doc_fields_ids               - ограничение перечня полей перечисленными полями
#	doc_type_ids                 - типы документов, поля для которых необходимо вернуть
#	id_task_route_cancel         - вернуть значения полей, устанавливаемые при прерывании процесса
#	id_task_route_event          - вернуть значения полей, устанавливаемые при наступлении события по процессу
#	id_task_route_task_result    - вернуть значения полей, устанавливаемые при выполнении задачи по процессу с заданным результатом
#	no_href_dt_from              - используется в вызываемой процедуре draw_user_field (не делать ссылки на значении "начало действия значения" полей, имеющих период действия)
#	prefix_name                  - добавочный префикс для ключа (имени) поля
#	show_type_banner             - вернуть поля типа "баннер"
#	type_ids                     - ограничение перечня полей перечисленными документами, к которым они привязаны (doc_field_to_types.id_type)
#	ro_type_ids                  - перечень документов, чьи поля отображаются в режиме просмотра
#	unique_doc_fields            - вернуть перечень полей без дублей (к различным типам документов могут быть привязаны одни и те же поля)
#	with_system_fields           - вернуть вместе с дополнительными - системные поля
#   doc_field_on_tab             - undef - все, 0 - на основной карточке, 1 - на дополнительной закладке

# $_REQUEST:
#	__edit_query                 - влияет на наименования полей (добавляется префикс filter_), на режим отображения полей (read_only)
#	__read_only                  - влияет на режим отображения полей (read_only)
#	_only_properties             - возвращается только перечень полей без структуры, описывающей отображение полей (для подстановки в draw_form)
#	dt_doc_field                 - задаёт дату, на которую действует значение поля
#	do_search                    - значения полей берётся из $_REQUEST
#	id                           - id документа, для которого возвращаются значения полей
#	type                         - используется в вызываемой процедуре draw_user_field (для формирования ссылки на скачиваемый файл)
#	user_fields_defaults_are_set - значения полей в новом документе уже установлены, переопределять их значениями по умолчанию нельзя
#	ключи доп. параметров        - значения полей
#
#
# Возвращает структуру
#	{
#		properties	=> перечень полей с текущими значениями или значениями по умолчанию для документов с fake > 0,
#		fields		=> массив, подходящий для подстановки draw_form.
#		                   Каждый элемент массива - массив, формирующий одну строку формы
#	}

sub get_user_fields {

	my ($options, $data) = @_;

	my $id_ = $_REQUEST {id};

	local $_REQUEST {id} = $_REQUEST {id};

# В новых документах значения полей будут установлены значениями по умолчанию
	$_REQUEST {id} = -1
		if $data -> {fake} > 0 && !$_REQUEST {user_fields_defaults_are_set};

	if (ref $options ne HASH) {
		$options = {
			doc_type_ids => $options,
		};
	}

	my $type_ids                  = $options -> {type_ids} || 0;
	my $show_type_banner          = $options =~ /\d,\d/ || !$type_ids ? 0 : $options -> {show_type_banner} + 0;
	my $doc_type_ids              = $options -> {doc_type_ids} || '-1';
	my $doc_fields_ids            = $options -> {doc_fields_ids};
	my $doc_field_groups_ids      = $options -> {doc_field_groups_ids};
	my $prefix                    = $options -> {prefix_name};


	my $properties_filter;
	unless ($options -> {with_system_fields}) {
		$properties_filter .= ' AND doc_fields.name IS NULL AND doc_field_to_types.name IS NULL ';
	}

	if (defined $options -> {doc_field_on_tab}) {
		$properties_filter .= ' AND doc_field_to_types.doc_field_on_tab = ' . ($options -> {doc_field_on_tab} ? 1 : 0);
	}

	if ($doc_fields_ids && $doc_fields_ids ne '-1') {
		$properties_filter .= " AND doc_fields.id IN ($doc_fields_ids) ";
	}

	if (defined $doc_field_groups_ids && $doc_field_groups_ids ne '-1') {
		$properties_filter .= " AND IFNULL(group_fields.id, 0) IN ($doc_field_groups_ids) ";
	}

# Проверяем права на групповые права
	$options -> {user_workgroup_ids} = '1,' . sql_select_ids ("SELECT id_workgroup FROM user_workgroups WHERE fake = 0 AND id_user = ?", $_USER -> {id});
# Поля, доступные для изменения
	my $doc_field_groups_change_ids = sql_select_ids ("SELECT id FROM doc_fields WHERE fake = 0 AND field_type = 8 AND access_by_workgroups = 0");
	$doc_field_groups_change_ids .= ',' . sql_select_ids ("SELECT id_doc_field FROM doc_fields_workgroups WHERE fake = 0 AND id_workgroup IN ($options->{user_workgroup_ids}) AND is_change = 1");
# Поля, доступные для просмотра
	my $doc_field_groups_view_ids = sql_select_ids ("SELECT id_doc_field FROM doc_fields_workgroups WHERE fake = 0 AND id_workgroup IN ($options->{user_workgroup_ids}) AND is_change = 0 AND id_doc_field NOT IN ($doc_field_groups_change_ids)");

	my ($select, $join, $order);

	$options -> {doc_type} = sql_select_hash (doc_types => $doc_type_ids);
	my $doc_type_table_name = get_doc_type_table ($options -> {doc_type});

	if ($show_type_banner) {

		my $label = $options -> {doc_type} -> {label_field} || 'label';

		$select = ", $doc_type_table_name.$label AS type_label";
		$join   = "LEFT JOIN $doc_type_table_name ON $doc_type_table_name.id = doc_field_to_types.id_type";
		$order  = "$doc_type_table_name.$label,";

	}

	if ($type_ids =~ /,/) {
		$order .= "group_fields.label,";
	}

	my $properties = sql_select_all (<<EOS);
		SELECT
			IFNULL(doc_field_to_fields.is_required, doc_field_to_types.is_required) AS is_required
			, doc_field_to_types.require_expression
			, IFNULL(doc_field_to_fields.is_read_only, doc_field_to_types.is_read_only) AS is_read_only
			, IFNULL(doc_field_to_fields.superior_field_ids, doc_field_to_types.superior_field_ids) AS superior_field_ids
			, doc_field_to_types.ord * 1000000 + IFNULL(doc_field_to_fields.ord, 0) AS ord
			, IFNULL(doc_field_to_fields.ord_col, doc_field_to_types.ord_col) AS ord_col
			, doc_field_to_types.id_doc_type AS id_doc_type_parent
			, doc_field_to_types.id_type
			, doc_field_to_types.template
			, doc_field_to_types.id AS id_doc_field_to_type
			, doc_fields.*
			, IFNULL(doc_field_to_fields.title, doc_field_to_types.title) AS description
			, group_fields.label         AS group_label
			, group_fields.select_type   AS group_select_type
			, IFNULL(group_fields.id, 0) AS id_doc_field_group
			$select
		FROM
			doc_field_to_types
			LEFT JOIN doc_field_to_fields ON
				doc_field_to_fields.fake = 0
				AND
				doc_field_to_fields.id_doc_field = doc_field_to_types.id_doc_field
			INNER JOIN doc_fields ON
				IFNULL(doc_field_to_fields.id_doc_subfield, doc_field_to_types.id_doc_field) = doc_fields.id
				AND
				doc_fields.fake = 0
				AND
				doc_fields.field_type <> 8
			LEFT JOIN doc_fields AS group_fields ON
				doc_field_to_fields.id_doc_field = group_fields.id
				AND
				group_fields.fake = 0
			INNER JOIN doc_types ON doc_field_to_types.id_doc_type = doc_types.id
				AND
				doc_types.fake = 0
			$join
		WHERE
			doc_field_to_types.id_doc_type IN ($doc_type_ids)
			AND doc_field_to_types.id_doc_field > $DOC_TYPE_DOC_FIELDS_MAX_ID
			AND IFNULL(doc_field_to_types.id_type, 0) IN ($type_ids)
			AND doc_field_to_types.fake = 0
			AND IFNULL(group_fields.id, -1) IN ($doc_field_groups_change_ids,$doc_field_groups_view_ids)

			$properties_filter

		ORDER BY
			$order
			doc_field_to_types.ord
			, doc_field_to_types.ord_col
			, doc_field_to_fields.ord
			, doc_field_to_fields.ord_col
EOS

	if ($options -> {with_system_fields} && $doc_type_table_name eq 'docs') {

		my $used_doc_field_ids = join ',', -1, map {$_ -> {id}} @$properties;

		my $system_doc_fields = sql_select_all (<<EOS);
			SELECT
				doc_fields.*
			FROM
				doc_fields
			WHERE
				doc_fields.fake = 0
			AND
				doc_fields.id NOT IN ($used_doc_field_ids)
			AND
				id <= $DOC_TYPE_DOC_FIELDS_MAX_ID
			AND
				doc_fields.name NOT IN ('id_user', 'dt_register')
			ORDER BY
				doc_fields.id DESC
EOS

		my $hidden_fields;
		foreach my $system_doc_field (@$system_doc_fields) {

			my $doc_field_name = $system_doc_field -> {name};

			$doc_field_name =~ s/^id_//;

			my $doc_type_field_access = $options -> {doc_type} -> {'field_' . $doc_field_name};


			if ($doc_type_field_access == $FIELD_ACCESSIBILITY_HIDDEN) {
				next;
			} elsif ($doc_type_field_access == $FIELD_ACCESSIBILITY_MANDATORY) {
				$system_doc_field -> {is_required} = 1;
			} elsif ($doc_type_field_access == $FIELD_ACCESSIBILITY_READ_ONLY) {
				$system_doc_field -> {is_read_only} = 1;
			}
			$system_doc_field -> {id_type} = 0;
			$system_doc_field -> {current_values} = [$data -> {$system_doc_field -> {name}}]
				if $data -> {$system_doc_field -> {name}};

			unshift @$properties, $system_doc_field;
		}

	}

	my $current_values;

	my $dt_doc_field = $_REQUEST {dt_doc_field} || dt_iso (Today);

	my $id_type = $_REQUEST {id} || $data -> {id};

	my @properties;

	my %idx;

	# выборка доп. полей для значений, устанавливаемых в документе по процессу
	my $task_route_event_filter;
	foreach my $event_type (qw(
		id_task_route_start
		id_task_route_cancel
		id_task_route_task_result
		id_task_route_event
	)) {

		if ($options -> {$event_type} > 0) {
			$task_route_event_filter = " AND doc_field_data.$event_type = $$options{$event_type} ";
			last;
		}
	}

# Выборка текущих значений полей
	foreach my $property (@$properties) {

		$property -> {id_type} = 0
			if $options -> {unique_doc_fields};

		$property -> {id_doc_field_group} += 0;

		$property -> {key} = $property -> {name} ? $property -> {name} :
			($prefix ? "${prefix}_" : '') .
			($property -> {id_type} ? "$$property{id_type}_" : '') .
			"$property->{id_doc_field_group}_$property->{id}";

#darn {$property -> {key} => $idx {$property -> {key}}};
		next
			if $idx {$property -> {key}};

		$idx {$property -> {key}} = 1;

		push @properties, $property;

# Наименование поля в doc_field_data, хранящее значение нужного типа
		$property -> {field} = get_doc_field_data_field ($property);

		if ($_REQUEST {do_search}) {

			$current_values -> {$property -> {id}} =
				$property -> {current_values} =
				[$_REQUEST {$property -> {key}} || $_REQUEST {"_$property->{key}"} || ()];

		} else {

			$current_values -> {$property -> {id}} = [];
			$property -> {current_values} ||= [];

# Значения в различных периодах времени
			$property -> {period_values} = []
				if $options -> {all_periods};

			my $fill_doc_field_values = sub {

				return
					if $property -> {field_type} == 7 && !$i -> {value};

				$i -> {value} += 0
					if $property -> {field_type} == 5;

				$i -> {dt_from} =~ s/ .+//;
				$i -> {dt_to}   =~ s/ .+//;

				if ($i -> {is_current}) {

					push @{$current_values -> {$property -> {id}}}, $i -> {value};
					push @{$property -> {current_values}}, $i -> {value};

					$property -> {id_doc_field_data} = $i -> {id};

					$current_values -> {$property -> {id} . '_unit'} = $property -> {id_type_unit_current} = $i -> {id_type_unit};
					$current_values -> {$property -> {id} . '_dt_from'} = $property -> {dt_from} = $i -> {dt_from};
					$current_values -> {$property -> {id} . '_dt_to'}   = $property -> {dt_to}   = $i -> {dt_to};
				}

				if ($options -> {all_periods}) {

					push (@{$property -> {period_values}}, {
						value   => $i -> {value},
						id      => $i -> {id},
						dt_from => $i -> {dt_from},
						dt_to   => $i -> {dt_to},
					});

				}
			};


			my ($filter, @params);
			unless ($options -> {all_periods}) {
				$filter .= "AND ? BETWEEN dt_from AND IFNULL(dt_to, '9999-12-31')";
				push @params, $dt_doc_field,
			}
# Возможно уточнение типа документа, к которому привязано значение
# (например, поля назначены веткам классификатора номенклатуры, значения привязаны к изготавливаемой технике)
			$doc_type_ids = $data -> {doc_field_data_doc_type_ids}
				if $data -> {doc_field_data_doc_type_ids};

			sql_select_loop (<<EOS,
				SELECT
					doc_field_data.id
					, $property->{field} AS value
					, id_type_unit
					, dt_from
					, dt_to
					, IF(? BETWEEN dt_from AND IFNULL(dt_to, '9999-12-31'), 1, 0) AS is_current
				FROM
					doc_field_data
				WHERE
					id_doc_type IN ($doc_type_ids)
					AND
						IFNULL(id_type_field, 0) = ?
					AND
						id_type = ?
					AND
						id_doc_field = ?
					AND
						id_doc_field_group = ?
					AND
						fake = 0
					$task_route_event_filter
					$filter
EOS
				$fill_doc_field_values
				, $dt_doc_field
				, $property -> {id_type}
				, $id_type
				, $property -> {id}
				, $property -> {id_doc_field_group} + 0
				, @params
			);
		}
	}

	$properties = \@properties;

	if ($_REQUEST {_only_properties}) {
		return  {
			properties	=> $properties,
		};
	}

# Подготовка данных с зависимостями между полями
	my $details;
	foreach my $property (@$properties) {

		if ($property -> {superior_field_ids} && $property -> {field_type} == 4 && $property -> {select_type} == 0) {

			my @superior_doc_fields;
			foreach my $id_doc_field (split /,/, $property -> {superior_field_ids}) {
# По хорошему надо как-то формировать ссылки на зависимые поля по ключу.
# Пока ищем первое подходящее поле и берём его ключ
				my $property = (grep  {$id_doc_field == $_ -> {id}} @$properties) [0];
				push @superior_doc_fields, {id => $property -> {id}, key => $property -> {key}}
					if $property -> {id};
			}


			foreach my $doc_field (@superior_doc_fields) {

				my $value = exists $_REQUEST {"_$doc_field->{key}"} ? $_REQUEST {"_$doc_field->{key}"} :
					$current_values -> {$doc_field -> {id}} -> [0];

				if ($value) {
					$property -> {other} .= '&' . $doc_field -> {key} . '=' . $value;
				}

				$details -> {$doc_field -> {key}} ||= [];

				my @codetails = map {$_ -> {key}} grep {$_ -> {key} ne $doc_field -> {key}} @superior_doc_fields;

				if (@codetails > 0) {
					push @{$details -> {$doc_field -> {key}}}, {$property -> {key}, [@codetails]};
				} else {
					push @{$details -> {$doc_field -> {key}}}, $property -> {key};
				}
			}
		}
	}

#warn Dumper $details;

	my $property_fields;
	my $type_label = '';

	my $ord = 0;
	my $ord_col = 0;

	my $group_label;

# Поля без порядкового номера имеют минимальное порядковое значение
	my $empty_ord = -1;

	$_REQUEST {id} = $id_;

	$options -> {ro_type_ids_array} = [split /,/, $options -> {ro_type_ids}];

# Формируем структуру, подходящую для передачи в draw_form для отрисовки полей
# Баннеры обрабатываем самостоятельно, остальные поля с помощью процедуры draw_user_field
	foreach my $property (@$properties) {
#darn $property;

		$property -> {ord} ||= $empty_ord --;

		if ($show_type_banner && $type_label ne $property -> {type_label}) {

				$type_label = $property -> {type_label};

				push @$property_fields, [{
					label	=> $type_label,
					type	=> 'banner',
				}];

				$ord = 0;
		}

# Если нет фильтров на групповые поля, отображаем заголовки групп
		unless (defined $doc_field_groups_ids) {

			if ($property -> {group_select_type} == 1) {

				if ($group_label ne $property -> {group_label}) {

					push @$property_fields, [{
						label	=> $property -> {group_label},
						type	=> 'banner',
					}];

					$ord = 0;
				}

			} elsif ($property -> {group_select_type} == 2) {

				if ($group_label ne $property -> {group_label}) {

					push @$property_fields, [{
						value	=> $property -> {group_label},
						type	=> 'static',
						href    => _new_window_href ("/?type=doc_field_data_group&id_doc_type=$doc_type_ids&type_ids=$type_ids&id=$id_type&id_doc_field_group=$property->{id_doc_field_group}"),
						name    => "group_$property->{id_doc_field_group}",
						a_class => 'form-very-active-inputs',
					}];

					$group_label = $property -> {group_label};

					$ord = 0;

					next;
#darn $property_fields;
				}

				next
					if $group_label && $group_label eq $property -> {group_label};
			}

			$group_label = $property -> {group_label};
		}

# Если порядковый номер не совпадает с порядковым номером текущего поля - начинаем с нулевой колнки
		if ($ord != $property -> {ord}) {
# В этот элемент массива будет добавлено новое поле (@{$property_fields -> [-1]})
			push @$property_fields, [];
			$ord_col = 0;
			$ord = $property -> {ord};
		}

		$ord_col ++;

		while ($ord_col < $property -> {ord_col}) {
			$ord_col ++;
			push @{$property_fields -> [-1]}, {type => 'static', value => ''};
		}

		$property -> {read_only} = $_REQUEST {__read_only} && !$_REQUEST {__only_form} ||

			$property -> {id_doc_field_group} &&
			!$_REQUEST {__edit_query} &&
			$doc_field_groups_view_ids =~ /\b$property->{id_doc_field_group}\b/ ||

			$property -> {id_type} && $property -> {id_type} ~~ $options -> {ro_type_ids_array};

		draw_user_field ($data, $property_fields, $property, $doc_type_ids, $options, $details);

	}

	$_REQUEST_TO_INHERIT = undef;

	return  {
		properties	=> $properties,
		fields		=> $property_fields,
	}

}




################################################################################

sub is_base_doc_remote { # документ-основание объекта из другой базы

	my ($data) = @_;

	$preconf -> {peer_name} or return 0;

	# функция вызывается в списке задач и на портале для каждой задачи,
	# require достаточно дорогая операция,
	# поэтому результат функции определения, нужен ли проброс, кэшируем
	my $can_edit_in_current_base = "__can_edit_in_current_base_$$data{id_doc_type}";

	if (!exists $_REQUEST {$can_edit_in_current_base}) {

		$_REQUEST {$can_edit_in_current_base} = call_doc_type_proc ({
				id_doc_type => $data -> {id_doc_type}
			},
			'is_editable_in_current_base'
		);
	}

	if (defined $_REQUEST {$can_edit_in_current_base}) {

		return !$_REQUEST {$can_edit_in_current_base};

	}

	return !$data -> {id_type};
}

################################################################################
# составляет название объекта-основания задачи, процесса
#
#	параметры - хэш {
#		id_doc_type => тип документа
#		id_type     => id документа
#	}
#	возвращает название объекта-основания
sub get_base_doc_label {

	my ($data) = @_;

	if  (is_base_doc_remote ($data))
	{
		return $data -> {base_doc_type_label} || '';
	}

	my $doc_type = exists $data -> {doc_type} && $data -> {doc_type} -> {id} ?
		$data -> {doc_type}
		: sql_select_hash ('doc_types', $data -> {id_doc_type});

	my $doc_type_table = get_doc_type_table ($doc_type);
	$doc_type -> {label_field} ||= 'label';

	my $base_doc_label = sql_select_scalar (
		"SELECT $doc_type->{label_field} FROM $doc_type_table WHERE id = ?",
		$data -> {id_type} || -1
	);
	$base_doc_label ||= $data -> {base_doc_type_label};

	return $base_doc_label;

}
