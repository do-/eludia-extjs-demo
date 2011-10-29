sub get_skin_name {'ExtJsProxy'}

our $conf = {
	
	portion => 25,
	session_timeout => 30,
		
#	number_format => {
#		-thousands_sep   => ' ',
#		-decimal_point   => ',',
#	},
	
	core_recycle_ids => 0,
	core_unlimit_xls => 1,
#	core_sql_flat => 1,
			
};

our $DB_MODEL = {

	default_columns => {
		id   => {TYPE_NAME  => 'int', _EXTRA => 'auto_increment', _PK => 1},
		fake => {TYPE_NAME  => 'bigint'},
	},

};

sub print_file {
	my ($fn, $s) = @_;
	open (F, ">$fn") or die "Can't write to $fn: $!\n";
	flock (F, LOCK_EX);	
	eval {print F $s};
	flock (F, LOCK_UN);
	close (F);
	die $@ if $@;
}

sub voc_static {

	$ENV {DOCUMENT_ROOT} or return;
	setup_json ();
	my $root = $ENV {DOCUMENT_ROOT} . '/voc/';
	-d $root or mkdir ($root);	
	my $data = add_vocabularies ({}, @_);	
	while (my ($k, $v) = each %$data) {
		print_file ("${root}${k}.json" => $_JSON -> encode ({success => \1, content => $v}));
	}
		
}

1;
