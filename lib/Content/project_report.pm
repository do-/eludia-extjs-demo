################################################################################

sub do_update_project_report {

	my $data = {
		user    => $_USER -> {label},
		dt      => sprintf ("%04d-%02d-%02d %02d:%02d", Today_and_Now ()),
	};

	$data -> {task_route_item} = sql_select_hash (<<EOS
		SELECT
			task_route_items.dt_start
			, task_route_items.dt_finish
			, task_route_item_status.label
			, TO_DAYS(IFNULL(task_route_items.dt_finish, NOW()) - task_route_items.dt_start) AS duration
		FROM
			task_route_items
		LEFT JOIN task_route_item_status ON
			task_route_item_status.id = task_route_items.id_task_route_item_status
		WHERE
			task_route_items.id_doc_type = ?
		AND
			task_route_items.id_type = ?
EOS
	 	, 100078 # $ID_DOC_TYPE_PRODUCT_SHEET
	 	, $_REQUEST {_id_product_sheet}
	);

	my $id_product = get_doc_field_data ({
		id_doc_field => 100201, # Доп поле 'Изделие'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
	});
	$data -> {product_label} = sql_select_scalar (
		'SELECT full_name FROM products WHERE id = ?'
		, $id_product
	);

	my $id_product_kind = get_doc_field_data ({
		id_doc_field => $ID_DOC_FIELD_PRODUCT_KIND,
		id_doc_type  => $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS,
		id_type		 => $id_product,
		id_type_field => $ID_PRODUCT_FIELD_GROUP_VITEK,
	});
	$data -> {product_kind} = sql_select_scalar (
		'SELECT label FROM voc_good_kinds WHERE id = ?'
		, $id_product_kind
	);

	my $id_product_type = get_doc_field_data ({
		id_doc_field => $ID_DOC_FIELD_PRODUCT_TYPE,
		id_doc_type  => $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS,
		id_type		 => $id_product,
		id_type_field => $ID_PRODUCT_FIELD_GROUP_VITEK,
	});
	$data -> {product_type} = sql_select_scalar (
		'SELECT label FROM voc_good_types WHERE id = ?'
		, $id_product_type
	);

	my $id_product_brand = get_doc_field_data ({
		id_doc_field => $ID_DOC_FIELD_BRAND,
		id_doc_type  => $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS,
		id_type		 => $id_product,
		id_type_field => $ID_PRODUCT_FIELD_GROUP_VITEK,
	});
	$data -> {product_brand} = sql_select_scalar (
		'SELECT label FROM voc_brands WHERE id = ?'
		, $id_product_brand
	);

	$data -> {product_no} = get_doc_field_data ({
		id_doc_field => 100232, # доп поле 'присвоен номер модели'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
		id_doc_field_group => 100241, # ПРИНЯТЬ МОДЕЛЬ В АССОРТИМЕНТ
	});

	$data -> {product_sheet_producer} = get_doc_field_data ({
		id_doc_field => 100203, # доп поле 'производитель'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
	});
	#$data -> {product_sheet_producer} =~ s|\n|<br/>|g;

	my $id_responsible_user = get_doc_field_data ({
		id_doc_field => 100205, # Доп поле 'Ответственный менеджер'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
	});
	$data -> {responsible_user_label} = sql_select_scalar (
		'SELECT label FROM users WHERE id = ?'
		, $id_responsible_user
	);

	$data -> {main_functions} = get_doc_field_data ({
		id_doc_field => 100206, # Доп поле 'Основные функции'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
	});
	#$data -> {main_functions} =~ s|\n|<br/>|g;

	my $ids_licenses = get_doc_field_data ({
		id_doc_field => 100207, # Доп поле 'Лицензии'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
	}) || -1;
	$data -> {licenses} = join "; ", sql_select_col ("SELECT label FROM docs WHERE id IN ($ids_licenses)");

	$data -> {sample_no} = get_doc_field_data ({
		id_doc_field => 100204, # доп поле 'Маркировка образца'
		id_doc_type  => 100078, # $ID_DOC_TYPE_PRODUCT_SHEET
		id_type		 => $_REQUEST {_id_product_sheet},
	});

	$data -> {tasks} = sql_select_all (<<EOS
		SELECT
			tasks.id
			, tasks.no     AS task_no
			, tasks.prefix AS task_prefix
			, tasks.label  AS task_label
			, task_status.label AS task_status_label

			, tasks.dt_from_plan AS task_dt_from_plan
			, tasks.dt_to_plan   AS task_dt_to_plan
			, tasks.dt_from_fact AS task_dt_from_fact
			, tasks.dt_to_fact   AS task_dt_to_fact
			, TO_DAYS(IFNULL(tasks.dt_to_fact, NOW())) - TO_DAYS(tasks.dt_to_plan) AS task_deviation

			, user_executors.label AS user_executor_label
			, deps.label           AS user_executor_dep_label
		FROM
			tasks
		LEFT JOIN
			task_status ON task_status.id = tasks.id_task_status
		LEFT JOIN
			users AS user_executors ON user_executors.id = tasks.id_user_executor
		LEFT JOIN hr_orders ON hr_orders.fake = 0
			AND hr_orders.id_user = tasks.id_user_executor
			AND CURDATE() BETWEEN hr_orders.dt AND IFNULL(hr_orders.dt_to, '9999-12-31')
			AND hr_orders.position_label IS NOT NULL
		LEFT JOIN deps ON deps.fake = 0
			AND deps.id = hr_orders.id_dep
		WHERE
			tasks.fake = 0
		AND
			tasks.id_doc_type = ?
		AND
			tasks.id_type = ?
EOS
		, 100078 # $ID_DOC_TYPE_PRODUCT_SHEET
		, $_REQUEST {_id_product_sheet}
	);

#darn $data -> {tasks};

	require_content ('projects_status_report');
	out_report ({
		#debug      => 1,
		template   => 'project_report',
		data       => $data,
		out_format => 'xls',
		file_name  => 'Проект',
	});
}

################################################################################

sub select_project_report {

	my $data = {};

	$data -> {product_sheets} = sql_select_all (
		'SELECT id, label_href AS label FROM docs WHERE fake = 0 AND id_doc_type = ? ORDER BY label_href'
		, 100078 # $ID_DOC_TYPE_PRODUCT_SHEET
	);

	return $data;
}

1;
