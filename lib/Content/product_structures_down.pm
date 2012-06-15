################################################################################

sub do_check_state_product_structures_down {

	my $cnt = sql_select_scalar (<<EOS, $_REQUEST {id_product}, $_REQUEST {sid});
		SELECT
			COUNT(*)
		FROM
			product_structures_down
		WHERE
			product_structures_down.fake = 0
			AND product_structures_down.id_product = ?
			AND product_structures_down.id_session = ?
EOS

	out_html ({}, $_JSON -> encode ({
		success => 1,
		cnt     => $cnt
	}));


}

################################################################################

sub __do_reduction_units {

	my ($options) = @_;
# id_product
# quantity
# id_voc_unit_from
# id_voc_unit_to
# precision

	return wantarray ? ($options -> {quantity}, 1) : $options -> {quantity}
		if $options -> {id_voc_unit_from} == $options -> {id_voc_unit_to};

	my $voc_unit_coeffs = sql_select_hash (<<EOS, $options -> {id_voc_unit_from}, $options -> {id_voc_unit_to}, $options -> {id_voc_unit_from}, $options -> {id_voc_unit_to}, $options -> {id_product});
		SELECT
			id
			, coeff
			, id_unit_from
			, id_product
		FROM
			voc_unit_coeffs
		WHERE
			fake = 0
			AND (
				(id_unit_from = ? AND id_unit_to = ?)
				OR
				(id_unit_to = ? AND id_unit_from = ?)
			)
			AND IFNULL(id_product, 0) IN (0,?)
			AND coeff <> 0
		ORDER BY
			IFNULL(id_product, 0) DESC
		LIMIT 1
EOS

	my $precision = defined $options -> {precision} ? $options -> {precision} : sql_select_scalar ('SELECT precision_production FROM products WHERE id = ?', $options -> {id_product});

	my $quantity = $options -> {id_voc_unit_from} == $voc_unit_coeffs -> {id_unit_from} ?
			sprintf ("%.${precision}f", $options -> {quantity} * $voc_unit_coeffs -> {coeff})
		: $voc_unit_coeffs -> {id} ? sprintf ("%.${precision}f", $options -> {quantity} / $voc_unit_coeffs -> {coeff})
		: 0;

	my $coeff = $options -> {id_voc_unit_from} == $voc_unit_coeffs -> {id_unit_from} ? $voc_unit_coeffs -> {coeff}
		: $voc_unit_coeffs -> {id} ? sprintf ("%.8f", 1 / $voc_unit_coeffs -> {coeff})
		: 0;

	return wantarray ? ($quantity, $coeff) : $quantity;

}


################################################################################

sub get_company_manufacture_dep_ids {

	my ($options) = @_;
#darn $options;
	my ($id_top_dep, $id_top_dep_status, $is_common_manufacture);

	if (exists $options -> {id_top_dep} && exists $options -> {id_top_dep_status} && exists $options -> {is_common_manufacture}) {

		($id_top_dep, $id_top_dep_status, $is_common_manufacture) = @{$options} {'id_top_dep', 'id_top_dep_status', 'is_common_manufacture'};

	} elsif ($options -> {id_dep}) {

		my $dep = sql_select_hash ('deps', $options -> {id_dep});

		if ($dep -> {id_dep_status}) {
			($id_top_dep, $id_top_dep_status, $is_common_manufacture) = @{$dep} {'id_top_dep', 'id_dep_status', 'is_common_manufacture'};
		} else {
			($id_top_dep, $id_top_dep_status, $is_common_manufacture) = sql_select_array ('SELECT id, id_dep_status, is_common_manufacture FROM deps WHERE id = ?', $dep -> {id_top_dep});
		}

	} elsif ($options -> {id_top_dep}) {
		($id_top_dep, $id_top_dep_status, $is_common_manufacture) = sql_select_array ('SELECT id, id_dep_status, is_common_manufacture FROM deps WHERE id = ?', $options -> {id_top_dep});
	}

	my $id_dep_company = $options -> {id_dep_company} || (
		$id_top_dep_status == 2 && $is_common_manufacture && !$options -> {only_subdeps} ?
			sql_select_scalar ('SELECT parent FROM deps WHERE id = ?', $id_top_dep)
			:
			$id_top_dep
	);
#warn "id_dep_company: $id_dep_company\n";

	$id_dep_company += 0;
	my $top_dep_ids = "$id_dep_company," . sql_select_ids ('SELECT id FROM deps WHERE fake = 0 AND parent = ? AND id_dep_status = 2 AND is_common_manufacture = 1', $id_dep_company);

	return "$id_dep_company," . sql_select_ids ("SELECT id FROM deps WHERE fake = 0 AND id_top_dep IN ($top_dep_ids)");

}

################################################################################

sub do_update_product_structures_down {

darn \%_REQUEST;
	my $ids = sql_select_ids ("SELECT id FROM $conf->{systables}->{sessions}");
	sql_do ("DELETE FROM product_structures_down WHERE id_session NOT IN ($ids)");

	$_REQUEST {id_dep} = sql_select_scalar (<<EOS, $_REQUEST {id_product});
		SELECT
			top_deps.id
		FROM
			product_productions
			INNER JOIN deps ON product_productions.id_dep = deps.id AND deps.fake = 0
			INNER JOIN deps AS top_deps ON deps.id_top_dep = top_deps.id AND top_deps.fake = 0
		WHERE
			product_productions.id_product = ?
			AND product_productions.fake = 0
		LIMIT 1
EOS


	$_REQUEST {id_product_production} = sql_select_scalar (<<EOS, $_REQUEST {id_product}, $_REQUEST {id_dep});
		SELECT
			product_productions.id
		FROM
			product_productions
			INNER JOIN voc_product_routes ON product_productions.id_voc_product_route = voc_product_routes.id AND voc_product_routes.fake = 0
			INNER JOIN voc_product_production_types ON voc_product_routes.id_voc_product_production_type = voc_product_production_types.id
			INNER JOIN deps ON product_productions.id_dep = deps.id AND deps.fake = 0
		WHERE
			product_productions.id_product = ?
			AND deps.id_top_dep = ?
			AND product_productions.fake = 0
			AND product_productions.is_basic = 1
EOS


	$_REQUEST {_dt} = dt_iso (Date::Calc::Today);

	defaults (
		\%_REQUEST, 
		"type=product_structures_down&id_user=$_USER->{id}", 
		id_product            => {},
		id_dep                => {},
		id_product_production => {},
		_dt                   => {},
	);


	local $_REQUEST {_dep_ids} = get_company_manufacture_dep_ids ({
		id_top_dep	=> $_REQUEST {id_dep},
	});
warn $_REQUEST {_dep_ids};
	sql_do ("DELETE FROM product_structures_down WHERE id_product = ? AND id_session = ?", $_REQUEST {id_product}, $_REQUEST {sid});

	$_REQUEST {_idx} = {$_REQUEST {id_product} => 1};


	$_REQUEST {_products} = {};
	$_REQUEST {_line} = 0;

	$SIG {'CHLD'} = "IGNORE";
	eval {$db -> disconnect};

	defined (my $child_pid = fork) or die "Cannot fork: $!\n";

	sql_reconnect ();

	if ($child_pid) {
warn "\n\nthis is parent. cid = $child_pid\n\n\n";

		$_REQUEST {__content_type} ||= 'application/json; charset=utf-8';

		out_html ({}, $_JSON -> encode ({
			success => 1,
		}));
warn "__response_sent: $_REQUEST{__response_sent}"
	} else {

warn "\n\nthis is child\n\n\n";

		my $log_path = "/i/upload/images/$_REQUEST{sid}.txt";
		open LOG, ">" . $r -> document_root . $log_path;
		flock LOG, 1;
		print LOG "Развертка структуры изделия\r\n\r\n";

		_fill_structures_down ($_REQUEST {id_product}, $_REQUEST {id_product_production}, '', 0, 1, 1, 1, 1, *LOG);

		print LOG "\r\nОбработано $_REQUEST{_line} записей"
		 	if ($_REQUEST {_line} % 100 == 0);

warn "\n\nchild done\n\n\n";

		print LOG "\r\nРазвертка завершена\r\n";
		close (LOG);

		$_REQUEST {__response_sent} = 1;
		$_REQUEST {__suicide} = 1;
	}



}

################################################################################

sub _fill_structures_down {

	my ($id_product, $id_product_production, $ord, $parent, $is_basic, $is_order_spec, $is_spec, $multiplicator, $log) = @_;

	my $product = sql_select_hash ("SELECT label, full_name, id_voc_product_type FROM products WHERE id = ?", $id_product);

	$_REQUEST {_line} ++;
	print LOG "\r\nОбработано $_REQUEST{_line} записей"
	 	if ($_REQUEST {_line} % 100 == 0);

	my $product_production_filter;
	my $product_specs_operations_filter;
	my @params = ($id_product, $_REQUEST {_dt}, $_REQUEST {_dt});

	if ($id_product_production != -1) {

		$product_production_filter .= ' AND (product_specs.id_product_production = ? OR IFNULL(product_specs.id_product_production,0) = 0) ';
		push @params, $id_product_production;

		unshift @params, $id_product_production, $_REQUEST {_dt}, $_REQUEST {_dt};
		$product_specs_operations_filter = ' AND product_specs_operations.id_product_production = ? ';
		$product_specs_operations_filter .= " AND ? >= product_specs_operations.dt_from AND ? < IFNULL(product_specs_operations.dt_to, '9999-12-31') ";

	} else {

		$id_product_production = sql_select_scalar (<<EOS, $id_product);
			SELECT
				id
			FROM
				product_productions
			WHERE
				id_product = ?
				AND fake = 0
				AND id_dep IN ($_REQUEST{_dep_ids})
				AND is_basic = 1
EOS

	}

	$multiplicator ||= 0;

	my $specs = sql_select_all (<<EOS, @params);
		SELECT
			product_specs.id
			, product_specs.id_product_subproduct
			, product_specs.id_product_parent
			, product_specs_operations.id_product_production
			, IF(product_specs.id_product_production = 0, product_specs.quantity, 0) AS quantity
			, IF(product_specs_operations.id IS NOT NULL, product_specs_operations.id_voc_unit, product_specs.id_voc_unit) AS product_spec_id_voc_unit
			, products.id_voc_unit AS product_id_voc_unit
			, products.id_voc_product_type AS product_id_voc_product_type
			, product_productions.is_basic AS is_basic_branch
			, product_productions.id_dep
			, (IFNULL(product_specs_operations.quantity, 0) / 100 * IFNULL(product_specs_operations.percent, 100)) AS product_specs_operation_quantity
			, products.label AS product_label
			, products.full_name AS product_name
			, basic_product_productions.id AS id_basic_product_production
			, product_specs_operations.id AS operation_id
			, pp_spec_actual.id AS id_product_production_spec
			, pp_spec_actual.id_voc_unit AS id_voc_unit_spec
			, basic_product_productions.id_voc_unit AS id_voc_unit_basic
			, voc_product_routes.label AS route
			, product_specs.id_product_production AS product_spec_id_product_production
		FROM
			product_specs
			INNER JOIN products ON products.fake = 0 AND products.id = product_specs.id_product_subproduct
			LEFT JOIN product_specs_operations ON (
				product_specs.id = product_specs_operations.id_product_spec
				AND product_specs_operations.fake = 0
				$product_specs_operations_filter
			)
			LEFT JOIN product_productions ON (
				product_productions.id = product_specs_operations.id_product_production
				AND product_productions.fake = 0
			)
			LEFT JOIN product_productions AS basic_product_productions ON (
				basic_product_productions.id_product = product_specs.id_product_subproduct
				AND basic_product_productions.fake = 0
				AND basic_product_productions.id_dep IN ($_REQUEST{_dep_ids})
				AND basic_product_productions.is_basic = 1
			)
			LEFT JOIN product_productions AS pp_spec ON pp_spec.id = product_specs_operations.id_product_production_spec
			LEFT JOIN voc_product_routes ON pp_spec.id_voc_product_route = voc_product_routes.id
			LEFT JOIN product_productions AS pp_spec_actual ON (
				pp_spec_actual.fake = 0
				AND pp_spec_actual.id_product = pp_spec.id_product
				AND pp_spec_actual.id_dep IN ($_REQUEST{_dep_ids})
				AND pp_spec_actual.id_voc_product_route = pp_spec.id_voc_product_route
			)
		WHERE
			product_specs.fake = 0
			AND product_specs.id_product_parent = ?
			AND product_specs.id_product_subproduct > 0
			AND (IFNULL(product_specs.id_product_production, 0) = 0 OR product_productions.id_dep IN ($_REQUEST{_dep_ids}))
			AND IFNULL(product_specs_operations.is_material, 0) = 0
			AND (? >= product_specs.dt_from OR product_specs.dt_from IS NULL)
			AND ? < IFNULL(product_specs.dt_to, '9999-12-31')
			$product_production_filter
		ORDER BY
			IF(product_specs_operations.id IS NOT NULL, IF(product_productions.is_basic = 1, 1, product_productions.id), 0)
			, IF(product_specs.position IS NOT NULL, 0, 1)
			, product_specs.position
			, products.name
EOS

	my $cycle;
	my $is_not_using;

	if (!$id_product_production) {

		print $log "\t01\t$product->{label}\t$product->{full_name}\tотсутствует способ изготовления\r\n"  if $product -> {id_voc_product_type} != 8;
		return;

	} else {

		(my $id_voc_product_production_type, $cycle, $is_not_using) =
			sql_select_array ("SELECT id_voc_product_production_type, cycle, is_not_using FROM product_productions WHERE id = ?",
				$id_product_production);

		if ($id_voc_product_production_type == 3) {

			if (@$specs != 0) {

				my $product_production = sql_select_scalar (<<EOS, $id_product);
					SELECT
						product_productions.id
					FROM
						product_productions
						LEFT JOIN voc_product_routes ON product_productions.id_voc_product_route = voc_product_routes.id AND voc_product_routes.fake = 0
					WHERE
						product_productions.fake = 0
						AND product_productions.id_product = ?
						AND product_productions.id_dep IN ($_REQUEST{_dep_ids})
						AND voc_product_routes.id_voc_product_production_type <> 3
EOS
				print $log "\t01\t$product->{label}\t$product->{full_name}\tимеет спецификацию, но в перечне способов изготовления все способы с типом закупка\r\n" if !$product_production;
			}

			sql_do ("UPDATE product_structures_down SET cycle = ? WHERE id = ?", $cycle + 0, $parent);

			return;

		} else {
			print $log "\t02\t$product->{label}\t$product->{full_name}\tне указаны материалы и комплектующие\r\n"  if @$specs == 0;
		}
	}

	my $n = 0;
	my $order;

	my $product_ids = ids ($specs, {field => 'id_product_subproduct'});
	my $product_spec_ids = ids ($specs, {});

	my $have_alts = sql_select_all_hash (<<EOS);
		SELECT
			IF(IFNULL(id_product_spec,0) = 0, id_product, id_product_spec) AS id
			, COUNT(*) AS count
		FROM
			product_alternatives
		WHERE
			fake = 0
			AND (
				id_voc_alternative_substitute_type = 1
				AND id_product IN ($product_ids)
				OR
				id_voc_alternative_substitute_type = 2
				AND id_product_spec IN ($product_spec_ids)
			)
EOS

	my %idx;
	foreach my $spec (@{$specs}) {

		my $id_product_production_parent = $spec -> {id_product_production} || $id_product_production;

		if ($spec -> {product_specs_operation_quantity} > 0) {

			$spec -> {is_basic} = !$is_basic ? 0 : $id_product_production_parent != $id_product_production ? 0 : 1;

			my $quantity_total = $multiplicator * __do_reduction_units ({
				id_product       => $spec -> {id_product_subproduct},
				id_voc_unit_from => $spec -> {product_spec_id_voc_unit},
				id_voc_unit_to   => $spec -> {product_id_voc_unit},
				quantity         => $spec -> {product_specs_operation_quantity},
				precision        => 7,
			});


			unless ($quantity_total) {

				print $log "\t04\t$spec->{product_label}\t$spec->{product_name}\tотсутствует возможность конвертации единицы измерения в основную. Пропускаем.\r\n";

				next;

			}

			my $quantity_total_basic = $multiplicator * __do_reduction_units ({
				id_product       => $spec -> {id_product_subproduct},
				id_voc_unit_from => $spec -> {product_spec_id_voc_unit},
				id_voc_unit_to   => $spec -> {id_voc_unit_spec},
				quantity         => $spec -> {product_specs_operation_quantity},
				precision        => 7,
			});

			if (!$quantity_total_basic && $spec -> {id_product_production_spec} && $multiplicator) {
				print $log "\t04\t$spec->{product_label}\t$spec->{product_name}\tотсутствует возможность конвертации единицы измерения в ЕИ способа изготовления\r\n";
				$quantity_total_basic = 0;
			}


			 if ($spec -> {id_product_production_spec} || $spec -> {product_id_voc_product_type} == 8) {

			 	$n++;
				$order = $ord . sprintf ("%05d", $n) . '.';

				sql_do (<<EOS,
					INSERT INTO product_structures_down
						(fake, id_product, id_dep, ord, quantity, quantity_total, id_product_spec, have_alts, id_session, is_basic, is_order_spec, is_spec, parent, id_product_production, id_product_production_spec, id_product_specs_operation)
					VALUES
						(0,    ?,          ?,      ?,   ?,        ?,              ?,               ?,         ?,          ?,        ?,             ?,       ?,      ?,                     ?,                          ?)
EOS
					$_REQUEST {id_product},
					$spec -> {id_dep},
					$order,
					$spec -> {product_specs_operation_quantity},
					$quantity_total,
					$spec -> {id},
					$have_alts -> {$spec -> {id_product_subproduct}} -> {count} || $have_alts -> {$spec -> {id}} -> {count} ? 1 : 0,
					$_REQUEST {sid},
					$spec -> {is_basic},
					!$is_order_spec ? 0 : 1,
					!$is_spec ? 0 : !$spec -> {product_spec_id_product_production} ? 1 : 0,
					$parent,
					$spec -> {id_product_production},
					$spec -> {id_product_production_spec},
					$spec -> {operation_id}
				);

				my $id_product_structures_down = sql_select_scalar ("SELECT LAST_INSERT_ID()");
					_fill_structures_down ($spec -> {id_product_subproduct}, $spec -> {id_product_production_spec}, $order, $id_product_structures_down, $spec -> {is_basic}, !$is_order_spec ? 0 : 1, !$is_spec ? 0 : !$spec -> {product_spec_id_product_production} ? 1 : 0, $quantity_total_basic, $log);

			} else {
				print $log "\t01\t$spec->{product_label}\t$spec->{product_name}\tотсутствует способ изготовления\r\n";

			}
		}

		if ($spec -> {quantity} > 0) {

			next if $idx {$spec -> {id}};

			unless ($spec -> {id_basic_product_production} || $spec -> {product_id_voc_product_type} == 8) {
				print $log "\t01\t$spec->{product_label}\t$spec->{product_name}\tотсутствует способ изготовления\r\n";
				next;
			}

#кол-во в спец-ии = количество в спец-ии  -  материалы указанного СИ, подвяз. к спец-ии
			if ($spec -> {product_specs_operation_quantity} > 0) {
				$spec -> {quantity} -= sql_select_scalar ("SELECT SUM(quantity) FROM product_specs_operations WHERE id_product_spec = ? AND fake = 0 AND id_product_production = ? ", $spec -> {id}, $id_product_production) + 0;
			}

			if ($spec -> {quantity} < 0) {
				print $log "\t03\t$spec->{product_label}\t$spec->{product_name}\tкол-во в способе изготовления $product->{label} $product->{full_name} больше, чем количество в ее спецификации\r\n";
				$idx {$spec -> {id}} = -1;
				next;
			}

			next if $spec -> {quantity} == 0;

			my $quantity_total = $multiplicator * __do_reduction_units ({
				id_product       => $spec -> {id_product_subproduct},
				id_voc_unit_from => $spec -> {product_spec_id_voc_unit},
				id_voc_unit_to   => $spec -> {product_id_voc_unit},
				quantity         => $spec -> {quantity},
				precision        => 7,
			});

			unless ($quantity_total) {
				print $log "\t04\t$spec->{product_label}\t$spec->{product_name}\tотсутствует возможность конвертации единицы измерения в основную. Пропускаем.\r\n";
				next;
			}

			my $quantity_total_basic = $multiplicator * __do_reduction_units ({
				id_product       => $spec -> {id_product_subproduct},
				id_voc_unit_from => $spec -> {product_spec_id_voc_unit},
				id_voc_unit_to   => $spec -> {id_voc_unit_basic},
				quantity         => $spec -> {quantity},
				precision        => 7,
			});

			if (!$quantity_total_basic && $spec -> {id_basic_product_production} && $multiplicator) {
				print $log "\t04\t$spec->{product_label}\t$spec->{product_name}\tотсутствует возможность конвертации единицы измерения в ЕИ способа изготовления\r\n";
				$quantity_total_basic = 0;
			}


			$n++;
			$order = $ord . sprintf ("%05d", $n) . '.';

			$spec -> {is_basic} = !$is_basic ? 0 : 1;

			my $id_product_structures_down;

			sql_do (<<EOS,
				INSERT INTO product_structures_down
					(fake, id_product, id_dep, ord, quantity, quantity_total, id_product_spec, have_alts, id_session, is_basic, is_order_spec, is_spec, parent, id_product_production, id_product_production_spec, id_product_specs_operation)
				VALUES
					(0,    ?,          ?,      ?,   ?,        ?,              ?,               ?,         ?,          ?,        ?,             ?,       ?,      ?,                     ?,                          0)
EOS
				$_REQUEST {id_product},
				$spec -> {id_dep},
				$order,
				$spec -> {quantity},
				$quantity_total,
				$spec -> {id},
				$have_alts -> {$spec -> {id_product_subproduct}} -> {count} || $have_alts -> {$spec -> {id}} -> {count} ? 1 : 0,
				$_REQUEST {sid},
				$spec -> {is_basic},
				!$is_order_spec ? 0 : $is_not_using ? 0 : 1,
				!$is_spec ? 0 : 1,
				$parent,
				$spec -> {id_product_production},
				$spec -> {id_basic_product_production},
			);

			$id_product_structures_down = sql_select_scalar ("SELECT LAST_INSERT_ID()");
				_fill_structures_down ($spec -> {id_product_subproduct}, -1, $order, $id_product_structures_down, $spec -> {is_basic}, !$is_order_spec ? 0 : $is_not_using ? 0 : 1, !$is_spec ? 0 : 1, $quantity_total_basic, $log);

			$idx {$spec -> {id}} = $id_product_structures_down;

		}

	}


	$cycle += sql_select_scalar ("SELECT MAX(cycle) FROM product_structures_down WHERE parent = ?", $parent);
	sql_do ("UPDATE product_structures_down SET cycle = ? WHERE id = ?", $cycle + 0, $parent);

}

################################################################################

sub select_product_structures_down {

	my $data = {
		portion               => $conf -> {portion},
	};

	defaults (
		$data, 
		"type=product_structures_down&id_user=$_USER->{id}", 
		id_product            => {},
		id_dep                => {},
		id_product_production => {},
		_dt                   => {},
	);

darn $data;
darn \%_REQUEST;

	__d ($data, 'dt');


	my $filter = '';
	my @params = ();

	if ($_REQUEST {q}) {
		$filter .= " AND (subproduct.label LIKE ? OR subproduct.full_name LIKE ?) ";
		push @params, '%' . $_REQUEST {q} . '%';
		push @params, '%' . $_REQUEST {q} . '%';
	}
	if ($_REQUEST {id_type_parent}) {
		$filter .= " AND parent.id_voc_product_type = ? ";
		push (@params, $_REQUEST {id_type_parent});
	}
	if ($_REQUEST {id_type_subproduct}) {
		$filter .= " AND subproduct.id_voc_product_type = ? ";
		push (@params, $_REQUEST {id_type_subproduct});
	}
	if ($_REQUEST {id_type_spec}) {
		$filter .= " AND product_specs.id_voc_product_type = ? AND IFNULL(product_specs.id_product_production, 0) = 0 ";
		push (@params, $_REQUEST {id_type_spec});
	}

	if ($_REQUEST {is_basic}) {
		$filter .= " AND (product_structures_down.is_basic = 1) ";
	}
	if ($_REQUEST {only_order_spec}) {
		$filter .= " AND IFNULL(spec_product_productions.is_transitive, 0) = 0 AND product_structures_down.is_order_spec = 1 ";
	}
	if ($_REQUEST {id_voc_product_production_type}) {
		$filter .= " AND voc_product_routes.id_voc_product_production_type = ? ";
		push @params, $_REQUEST {id_voc_product_production_type};
	}
	if ($_REQUEST {id_voc_product_production_type_spec}) {
		$filter .= " AND spec_voc_product_routes.id_voc_product_production_type = ? ";
		push @params, $_REQUEST {id_voc_product_production_type_spec};
	}

# 	if ($_REQUEST {parent}) {

# 		my $parent = $_REQUEST {parent} == 999999999 ? 0 : $_REQUEST {parent};

# 		$data -> {id_product_parent} = sql_select_scalar (<<EOS, $parent);
# 			SELECT
# 				id_product_subproduct
# 			FROM
# 				product_structures_down
# 				INNER JOIN product_specs ON product_specs.id = product_structures_down.id_product_spec AND product_specs.fake = 0
# 			WHERE
# 				product_structures_down.id = ?
# EOS
# 		$data -> {product_parent_label} = sql_select_scalar ('SELECT full_name FROM products WHERE id = ?', $data -> {id_product_parent});

# 		if ($_REQUEST {subtree} && $parent) {

# 			my $subtree = join ',', -1, grep {$_ !=  $_REQUEST {parent}} sql_select_subtree (product_structures_down => $parent);
# 			$filter .= " AND product_structures_down.id IN ($subtree) ";

# 		} elsif ($_REQUEST {subtree}) {

# 		} else {
# 			$filter .= " AND product_structures_down.parent = ? ";
# 			push @params, $parent;

# 		}
# 	}

	if ($_REQUEST {without_product_operations}) {
		$filter .= " AND product_structures_down.is_spec = 1 ";
	}

	#my $start = $_REQUEST {start} + 0;

	# my $order = order ('product_structures_down.ord',
	# 	ord              => 'product_structures_down.ord',
	# 	parent_label     => 'parent_label',
	# 	parent_name      => 'parent_name',
	# 	pp               => '',
	# 	type             => 'voc_product_type_label',
	# 	position         => 'product_specs.position',
	# 	subproduct_label => 'subproduct_label',
	# 	subproduct_name  => 'subproduct_name',
	# 	quantity         => 'quantity',
	# 	unit             => 'voc_unit_label',
	# 	note             => 'product_specs.note',
	# 	dt_from          => 'dt_from',
	# 	dt_to            => 'dt_to',
	# 	alts             => 'product_structures_down.have_alts',
	# 	make             => 'voc_product_routes.label',
	# 	cycle_pp         => 'product_productions_spec.cycle',
	# 	cycle            => 'product_structures_down.cycle',
	# );



	my $sql_middle = <<EOS;
		FROM
			product_structures_down
			LEFT JOIN deps ON product_structures_down.id_dep = deps.id
			LEFT JOIN deps top_deps ON deps.id_top_dep = top_deps.id
			LEFT JOIN product_specs ON product_specs.id = product_structures_down.id_product_spec AND product_specs.fake = 0
			LEFT JOIN products AS parent ON parent.id = product_specs.id_product_parent
			LEFT JOIN products AS subproduct ON subproduct.id = product_specs.id_product_subproduct
			LEFT JOIN voc_product_types ON voc_product_types.id = product_specs.id_voc_product_type AND IFNULL(product_specs.id_product_production, 0) = 0
			LEFT JOIN voc_units AS product_voc_units ON product_voc_units.id = subproduct.id_voc_unit
			LEFT JOIN voc_units ON voc_units.id = product_specs.id_voc_unit
			LEFT JOIN product_specs_operations ON product_specs_operations.id = product_structures_down.id_product_specs_operation
			LEFT JOIN product_productions ON product_productions.id = product_specs_operations.id_product_production
			LEFT JOIN product_productions AS basic_product_productions ON basic_product_productions.id = product_structures_down.id_product_production
			LEFT JOIN product_productions AS spec_product_productions ON spec_product_productions.id = product_structures_down.id_product_production_spec
			LEFT JOIN voc_product_routes ON voc_product_routes.id = product_productions.id_voc_product_route
			LEFT JOIN voc_product_production_types ON voc_product_routes.id_voc_product_production_type = voc_product_production_types.id
			LEFT JOIN voc_product_routes AS spec_voc_product_routes ON spec_voc_product_routes.id = spec_product_productions.id_voc_product_route
			LEFT JOIN voc_units AS operation_voc_units ON operation_voc_units.id = product_specs_operations.id_voc_unit
			LEFT JOIN product_productions AS product_productions_spec ON product_productions_spec.id = product_structures_down.id_product_production_spec
			LEFT JOIN production_operations ON production_operations.id = product_specs_operations.id_production_operation
		WHERE
			product_structures_down.fake = 0
			AND product_structures_down.id_product = ?
			AND product_structures_down.id_session = ?
EOS


	my @nodes = ();

	sql_select_loop (<<EOS,
		SELECT
			product_structures_down.*
			, parent.label AS parent_label
			, parent.full_name AS parent_name
			, voc_product_types.label AS voc_product_type_label
			, product_specs.position AS position
			, product_specs.id_product_subproduct
			, subproduct.label AS subproduct_label
			, subproduct.full_name AS subproduct_name
			, IFNULL(operation_voc_units.label, voc_units.label) AS voc_unit_label
			, product_voc_units.label AS product_voc_unit_label
			, product_specs.note
			, IFNULL(product_specs_operations.dt_from, product_specs.dt_from) AS dt_from
			, IFNULL(product_specs_operations.dt_to, product_specs.dt_to) AS dt_to
			, CONCAT(voc_product_routes.label, ' - ', voc_product_production_types.label)  AS no_route
			, spec_voc_product_routes.label AS pp_label
			, subproduct.precision_production
			, product_specs.id_voc_product_type
			, voc_product_types.id AS type_id
			, voc_product_types.label AS type_label
			, top_deps.label AS top_dep_label
			, product_productions_spec.cycle AS cycle_pp
			, production_operations.no AS operation

		$sql_middle

			AND product_structures_down.parent = ?
			$filter
		ORDER BY
			product_structures_down.ord
EOS


		sub {
			__d ($i);

			$i -> {ord} =~ s/\.0+/\./g;
			$i -> {ord} =~ s/^0+//;
			$i -> {ord} =~ s/\.$//;

			$i -> {quantity} += 0;
			$i -> {quantity_total} += 0;

			$i -> {cls} = 'file';
			$i -> {leaf} =\1;
			push @nodes, $i;

		}
		, $data -> {id_product}
		, $_REQUEST {sid}
		, $_REQUEST {node} || 0
		, @params
	);


	my ($ids, $idx) = ids (\@nodes);
	
	sql_select_loop (<<EOS,
			SELECT
				product_structures_down.parent
				, COUNT(*)
		$sql_middle
			AND product_structures_down.parent IN ($ids)
			$filter
		GROUP BY
			1
EOS


		sub {

			my $node = $idx -> {$i -> {parent}};
	
			$node -> {cls}  = 'folder';
		
			$node -> {leaf} = \0;
		
		}
		, $data -> {id_product}
		, $_REQUEST {sid}
		, @params
	);

darn \@nodes;

	return \@nodes;

}

1;

