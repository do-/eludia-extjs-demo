

################################################################################

sub prefix_no {

	my ($data) = @_;

	return ($data -> {prefix} ? $data -> {prefix} . ' - ' : '') . $data -> {no};

}


################################################################################

sub get_doc_type_table { # возвращает таблицу, в которой хранятся объекты типа

	my ($doc_type) = @_;

	ref $doc_type eq 'HASH' && $doc_type -> {id} || !ref $doc_type
		or return 'docs';

	if (!ref $doc_type && $doc_type > 0) {

		$doc_type = sql_select_hash (
			'SELECT name, subname FROM doc_types WHERE id = ?',
			$doc_type
		);

	}

	return $doc_type -> {subname} || $doc_type -> {name} || 'docs';
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
	print $report_unit_xml_fh Encode::decode ('cp-1251', $xml_parser -> XMLout ($options -> {data}) );
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

_debug_log ('_jasper_rest_api_request', $api_url);

	my @put_params;
	push @put_params, (Content => $options -> {request_body})
		if $options -> {request_body};

	my $response = $options -> {request_type} eq 'get'? $ua -> request (HTTP::Request::Common::GET ($api_url))
		: $options -> {request_type} eq 'put'? $ua -> request (HTTP::Request::Common::PUT($api_url, @put_params))
		: '';

	if ($response -> is_error ()) {
		die $api_url . ":\n" . $response -> status_line ();
	}

#darn $response;

	return $response -> content ();
}
