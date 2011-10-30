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

1;
