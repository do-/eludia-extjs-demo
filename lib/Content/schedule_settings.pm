

################################################################################

sub select_schedule_settings {


	sql (
	
		add_vocabularies ({},
			users => {},
		),
		
		schedule_settings => [
	
			'id_user',
			
			['label LIKE %?%' => $_REQUEST {q}],
			
			[ LIMIT => 'start, 50'],
		
		],
			
		'users' # , other joined tables
		
	);
	

}

################################################################################

sub __set_default_schedule_settings {

	my $default_schedule_settings = {
		createByDblclick => 0,
		monthFormat      => "d.m",
		weekFormat       => "d.m(D)",
		class            => "CalendarSettingUIModel",
		hideInactiveRow  => 0,
		dayFormat        => "l d M Y",
		fromtoFormat     => "d.m.Y",
		id               => "1",
		intervalSlot     => "30",
		readOnly         => 0,
		hourFormat       => "24",
		singleDay        => 0,
		startDay         => "1",
		activeEndTime    => "19:00",
		activeStartTime  => "08:00",
		language         => "ru"
	};

	sql_select_id (schedule_settings => {
			fake     => 0,
			id_user  => $_USER -> {id},
			settings => $_JSON -> encode ($default_schedule_settings),
		},
		[qw (fake id_user)],
	);

	return $default_schedule_settings;
}

1;
