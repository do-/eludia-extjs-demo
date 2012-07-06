use Text::Iconv;


################################################################################

sub do_update_projects_status_report {

#warn $_USER -> {label};
#warn Encode::encode ('cp-1251', $_USER -> {label});
	my $data = {
#		user    => Encode::encode ('cp-1251', $_USER -> {label}),
		user    => $_USER -> {label},
		dt      => sprintf ("%04d-%02d-%02d %02d:%02d", Today_and_Now ()),
		dt_from => $_REQUEST {_dt_from},
		dt_to   => $_REQUEST {_dt_to},
	};

	my ($filter, @params);
	if ($_REQUEST {_dt_from}) {
		$filter .= ' AND DATE(task_route_items.dt_start) >= ? ';
		push @params, dt_iso ($_REQUEST {_dt_from});
	}

	if ($_REQUEST {_dt_to}) {
                $filter .= ' AND DATE(task_route_items.dt_finish) <= ? ';
                push @params, dt_iso ($_REQUEST {_dt_to});
        }


	if ($_REQUEST {_id_task_route_item_status}) {

		$filter .= ' AND task_route_items.id_task_route_item_status = ? ';
		push @params, $_REQUEST {_id_task_route_item_status};

		$data -> {task_route_item_status_label} = sql_select_scalar (
                        'SELECT label FROM task_route_item_status WHERE id = ?'
                        , $_REQUEST {_id_task_route_item_status}
                );
	}

	$data -> {task_route_items} = sql_select_all (<<EOS
		SELECT
			task_route_items.no AS task_route_item_no
			, task_route_items.id AS id_task_route_item
			, task_route_items.dt_start
			, task_route_items.dt_finish
			, voc_brands.label     AS product_brand
			, voc_good_types.label AS product_type
			, voc_good_kinds.label AS product_kind
			, products.full_name   AS product_label
			, products.label       AS product_no
			, users.label          AS responsible_user_label
		FROM
			task_route_items
		LEFT JOIN docs ON
			docs.id_doc_type = task_route_items.id_doc_type
			AND docs.id = task_route_items.id_type

                LEFT JOIN doc_field_data AS doc_field_data_product ON doc_field_data_product.fake = 0
                        AND doc_field_data_product.id_doc_type = docs.id_doc_type
                        AND doc_field_data_product.id_type = docs.id
                        AND doc_field_data_product.id_doc_field = ?

		LEFT JOIN doc_field_data AS doc_field_data_brand ON doc_field_data_brand.fake = 0
			AND doc_field_data_brand.id_doc_type = $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS
			AND doc_field_data_brand.id_type_field = $ID_PRODUCT_FIELD_GROUP_VITEK
			AND doc_field_data_brand.id_type = doc_field_data_product.id_doc_voc_data
			AND doc_field_data_brand.id_doc_field = ?
		LEFT JOIN doc_field_data AS doc_field_data_type ON doc_field_data_type.fake = 0
			AND doc_field_data_type.id_doc_type = $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS
			AND doc_field_data_type.id_type_field = $ID_PRODUCT_FIELD_GROUP_VITEK
			AND doc_field_data_type.id_type = doc_field_data_product.id_doc_voc_data
			AND doc_field_data_type.id_doc_field = ?
		LEFT JOIN doc_field_data AS doc_field_data_kind ON doc_field_data_kind.fake = 0
			AND doc_field_data_kind.id_doc_type = $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS
			AND doc_field_data_kind.id_type_field = $ID_PRODUCT_FIELD_GROUP_VITEK
			AND doc_field_data_kind.id_type = doc_field_data_product.id_doc_voc_data
			AND doc_field_data_kind.id_doc_field = ?

		LEFT JOIN doc_field_data AS doc_field_data_responsible ON doc_field_data_responsible.fake = 0
			AND doc_field_data_responsible.id_doc_type = docs.id_doc_type
			AND doc_field_data_responsible.id_type = docs.id
			AND doc_field_data_responsible.id_doc_field = ?

		LEFT JOIN voc_brands ON
			voc_brands.id = doc_field_data_brand.id_doc_voc_data
		LEFT JOIN voc_good_types ON
			voc_good_types.id = doc_field_data_type.id_doc_voc_data
		LEFT JOIN voc_good_kinds ON
			voc_good_kinds.id = doc_field_data_kind.id_doc_voc_data
		LEFT JOIN products ON
			products.id = doc_field_data_product.id_doc_voc_data
		LEFT JOIN users ON
			users.id = doc_field_data_responsible.id_doc_voc_data

		WHERE
			task_route_items.fake = 0
		AND
			docs.fake = 0
		AND
			task_route_items.id_doc_type = ?

		$filter
EOS
		, 100201 # Доп поле 'Изделие'
		, $ID_DOC_FIELD_BRAND
		, $ID_DOC_FIELD_PRODUCT_TYPE
		, $ID_DOC_FIELD_PRODUCT_KIND
		, 100205 # Доп поле 'Ответственный менеджер'
		, 100078 # $ID_DOC_TYPE_PRODUCT_SHEET
		, @params
	);

#darn $data -> {task_route_items};
	foreach (@{$data -> {task_route_items}}) {
		_projects_status_report_draw_progress_markup ($_);
	}

	out_report ({
		#debug      => 1,
		template   => 'projects_status_report',
		data       => $data,
		out_format => 'xls',
		file_name  => 'Выполнение проектов',
	});
}

################################################################################

sub select_projects_status_report {

	my $data = {};

	add_vocabularies ($data,
		'task_route_item_status',
	);

	return $data;
}

################################################################################
# рисует html-разметку для прогресс-поля 'исполнение процесса'

sub _projects_status_report_draw_progress_markup {

	my ($row) = @_;

	my $task_route = sql_select_hash (<<EOS, $row -> {id_task_route_item});
		SELECT
			task_routes.*
		FROM
			task_route_items
		LEFT JOIN
			task_routes ON task_routes.id = task_route_items.id_task_route
		WHERE
			task_route_items.id = ?
EOS

	my $total_tasks_cnt = sql_select_scalar (
		'SELECT COUNT(id) FROM task_route_tasks WHERE fake = 0 AND id_task_route = ?'
		, $task_route -> {id}
	);

	my $finished_tasks_cnt = sql_select_scalar (<<EOS
		SELECT
			COUNT(id)
		FROM
			tasks
		WHERE
			id_task_route_item = ?
		AND
			fake = 0
		AND
			id_task_status >= 4
EOS
		, $row -> {id_task_route_item}
	);

	my $progress = $finished_tasks_cnt / $total_tasks_cnt;
	$row -> {progress_markup} =
		_draw_progress_text_field ($progress);
	$row -> {progress_percent} = int (100 * $progress);
}

################################################################################
# рисует html-разметку для прогресс-поля

sub _draw_progress_text_field {

	my ($progress) = @_;

#darn [$total, $done];
	my $progress_char = '&#9632;'; # black square
	my $empty_char    = '&#9633;'; # white square

	my $total_chars = 15;
	my $done_chars  = int ($progress * $total_chars);

	return ($progress_char x $done_chars) . ($empty_char x ($total_chars - $done_chars));
}

################################################################################

sub out_report { # вывод отчета через jasper server

	my ($options) = @_;

	$options -> {template} or die '_lib_common.out_report: template not specified';
	$options -> {data} ||= {};
	$options -> {out_format} ||= 'xls';

	_jasper_rest_api_request ({
		url_tail       => 'login',
		request_params => {
			j_username => 'jasperadmin',
			j_password => 'jasperadmin',
		}
	});

	my $report_unit = _jasper_rest_api_request ({url_tail => "resource/reports/$$options{template}" });


	use File::Temp qw(tempfile);
	use File::Basename qw(basename);
	my ($report_unit_xml_fh, $report_unit_xml_file_path) = tempfile (
		"$$options{template}_$_REQUEST{sid}_XXXX",
		DIR    => $preconf -> {_} -> {docroot} . '/i/',
		SUFFIX => '.xml',
	);
	my $report_unit_xml_filename = basename ($report_unit_xml_file_path);


	require XML::Simple;
	my $xml_parser = XML::Simple -> new (KeyAttr => [], RootName => 'data');

	binmode ($report_unit_xml_fh, ":utf8");


	my $converter = Text::Iconv -> new ("utf-8", "windows-1251");


	print $report_unit_xml_fh $xml_parser -> XMLout ($options -> {data});
	close $report_unit_xml_fh;

$report_unit  =~ s|</resourceDescriptor>\n$||;
$report_unit .= <<XML;
<parameter name="XML_URL" class="java.lang.String">
    <![CDATA[http://$ENV{HTTP_HOST}/i/$report_unit_xml_filename]]>
</parameter>
</resourceDescriptor>
XML

	my $report_descriptor = _jasper_rest_api_request ({
		url_tail     => "report/reports/$$options{template}",
		request_type => 'put',
		request_body => $report_unit,
		request_params => {
			RUN_OUTPUT_FORMAT => $options -> {out_format},
		},
	});
	unlink $report_unit_xml_file_path
		unless $options -> {debug};

	my $report = $xml_parser -> parse_string ($report_descriptor);


	my $file_contents = _jasper_rest_api_request ({
		url_tail       => "report/$$report{uuid}",
		request_params => {file => $report -> {file} -> {content}}
	});

	download_file_header ({
		file_name => "$$options{file_name}.$$options{out_format}",
		charset   => $i18n -> {_charset},
		type      => $report -> {file} -> {type},
		#size      => length ($file_contents),
	});

	$r -> print ($file_contents);
}


################################################################################

sub _jasper_rest_api_request { # взаимодействие с jasperserver api

	my ($options) = @_;

	$options -> {request_type} ||= 'get';
	$options -> {request_params} ||= {};

	use LWP::UserAgent;
	use HTTP::Response;
	use HTTP::Cookies;
	use HTTP::Request;
	use HTTP::Request::Common;

	our $ua;
	if (!$ua)  {
		$ua = LWP::UserAgent -> new ();
		$ua -> agent ("Eludia/user_$_USER{id}");
		my $cookie_jar = HTTP::Cookies -> new ();
		$ua -> cookie_jar ($cookie_jar);
	}
#darn $ua;

	my $api_url = $preconf -> {reporting_api_url} . "/$$options{url_tail}";

	if ($options -> {request_type} ~~ [qw(get put)])  {
		$api_url .= '?' . join '&', map {"$_=$options->{request_params}->{$_}"}
			keys %{$options -> {request_params}};
	}

#_debug_log ('_jasper_rest_api_request', $api_url);

	my @put_params;
	push @put_params, (Content => $options -> {request_body})
		if $options -> {request_body};

	my $response = $options -> {request_type} eq 'get'? $ua -> request (HTTP::Request::Common::GET ($api_url))
		: $options -> {request_type} eq 'put'? $ua -> request (HTTP::Request::Common::PUT($api_url, @put_params))
		: '';

	if ($response -> is_error ()) {
		die $api_url . ":\n\n" . $response -> content () . "\n\n" . $response -> status_line ();
	}

#darn $response;

	return $response -> content ();
}


