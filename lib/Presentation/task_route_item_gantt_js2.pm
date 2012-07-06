

################################################################################

sub draw_task_route_item_gantt_js2 {

	my ($data) = @_;

	push @{$_REQUEST {__include_css}}, 'dhtmlxGantt/dhtmlxGantt/codebase/dhtmlxgantt';
	push @{$_REQUEST {__include_js}}, 'dhtmlxGantt/dhtmlxGantt/codebase/dhtmlxcommon';
	push @{$_REQUEST {__include_js}}, 'dhtmlxGantt/dhtmlxGantt/sources/dhtmlxgantt';

	my $project_dt_from = $data -> {tasks} -> [0] -> {dt_from_fact} || $data -> {tasks} -> [0] -> {dt_from_plan};
	my ($year, $month, $day) = ($project_dt_from =~ /(\d{4})-(\d{2})-(\d{2})/);
# В JS месяцы начинаются с нуля
	$month --;

	$data -> {task_route_item} -> {label} =~ s/"/\\"/g;
	$data -> {task_route_item} -> {label} =~ s/\r?\n//g;
	my $js = <<EOH;
			var win_top    = screen.availHeight <= 600 ? 25 : 50;
			var win_left   = screen.availWidth <= 800 ? 25 : 50;
			var win_height = screen.availHeight - win_top * 2;
			var win_width  = screen.availWidth - win_left * 2;
			\$("#GanttDiv").height(win_height - 20).width(win_width - 20);
			var gantt = new GanttChart();
			gantt.maxWidthPanelNames = 300;
			gantt.setImagePath("/i/dhtmlxGantt/dhtmlxGantt/codebase/imgs/");
			gantt.setEditable(false);
			gantt.setCorrectError(true);

		        var project_1 = new GanttProjectInfo(1, "$data->{task_route_item}->{label}", new Date($year, $month, $day));
EOH

	foreach my $task (@{$data -> {tasks}}) {

		next
			unless $task -> {id};

		my $dt_from = $task -> {dt_from_fact} || $task -> {dt_from_plan};
		my $dt_to =   $task -> {dt_to_fact} || $task -> {dt_to_plan};

		my ($dt_from_year, $dt_from_month, $dt_from_day, $dt_from_hours) = ($dt_from =~ /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})/);
		my ($dt_to_year, $dt_to_month, $dt_to_day, $dt_to_hours)           = ($dt_to =~ /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})/);

		my ($Dd,$Dh,$Dm,$Ds) = Date::Calc::Delta_DHMS ($dt_from_year, $dt_from_month, $dt_from_day, $dt_from_hours, 0, 0
			, $dt_to_year, $dt_to_month, $dt_to_day, $dt_to_hours, 0, 0);

		my $duration_hours = $Dd * 8 + $Dh - 1;
		$duration_hours = 1
			if $duration_hours < 1;

		$dt_from_month --;

		$task -> {id_preceding_task} ||= 0;
		$task -> {label} =~ s/"/\\"/g;
		$task -> {label} =~ s/\r?\n//g;

		$js .= <<EOH
			project_1.addTask(new GanttTaskInfo($task->{id}, "$task->{label}", new Date($dt_from_year, $dt_from_month, $dt_from_day, $dt_from_hours, 0, 0), $duration_hours, 0, $task->{id_preceding_task}));
EOH

	}

	$js .= <<'EOH';
		        gantt.addProject(project_1);
			gantt.create("GanttDiv");
EOH

	j ($js);

	return q!<div style="position:relative" id="GanttDiv"></div>!;

}


1;
