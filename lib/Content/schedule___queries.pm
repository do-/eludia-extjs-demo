
################################################################################

sub __add_personal_schedule___queries {

	my $personal_task_type = sql_select_hash (task_types => 10_001);

	my $personal_filter = {

		filters => {
#			task_type_ids    => 10_001,
			id_user_executor => $_USER -> {id},
		},
		columns => {
			label => {
				ord => 1,
			},
		},
	};

	my $id___query = sql_select_id ($conf -> {systables} -> {__queries} => {
			fake          => 0,
			type          => 'tasks',
			order_context => 'type=personal_schedule',
			label         => $personal_task_type -> {label},
			-dump         => Dumper ($personal_filter),
			id_user       => $_USER -> {id},
		},
		[qw(fake id_user label order_context)],
	);
	
	sql_select_id (schedules => {
			fake          => 0,
			id_user       => $_USER -> {id},
			label         => $personal_task_type -> {label},
			-id___query   => $id___query,
			color         => 'blue',
			is_personal   => 1,
		},
		[qw(fake id_user is_personal)],
	);	
	
}


1;
