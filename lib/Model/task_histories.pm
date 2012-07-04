label => 'Çàäà÷è: Èñòîğèÿ èçìåíåíèÿ ïîëåé',

columns => {

	id_task            => {TYPE_NAME => 'int', , label => 'Ññûëêà íà çàäà÷ó'},
	id_user            => {TYPE_NAME => 'int', , label => 'Àâòîğ èçìåíåíèÿ'},
	dt                 => {TYPE_NAME => 'datetime', label => 'Äàòà èçìåíåíèÿ'},

	# Èñòîğèÿ èçìåíåíèÿ âñåõ ïîëåé çàäà÷è õğàíèòñÿ â îäíîé òàáëèöå: â êàæäîé çàïèñè íå NULL òîëüêî îäíî èç ïîëåé
	id_user_initiator         => {TYPE_NAME => 'int', ref => 'users', label => 'Èíèöèàòîğ'},

	id_workgroup_executor     => {TYPE_NAME => 'int', ref => 'workgroups', label => 'Ãğóïïà Èñïîëíèòåëåé'},
	id_user_executor          => {TYPE_NAME => 'int', ref => 'users', label => 'Èñïîëíèòåëü'},

	dt_from_plan              => {TYPE_NAME => 'datetime', label => 'Äàòà íà÷àëà ïëàíîâàÿ'},
	dt_to_plan                => {TYPE_NAME => 'datetime', label => 'Äàòà çàâåğøåíèÿ ïëàíîâàÿ'},

	dt_from_fact              =>  {TYPE_NAME => 'datetime', label => 'Äàòà íà÷àëà ôàêòè÷åñêÿ'},
	dt_to_fact                => {TYPE_NAME => 'datetime', label => 'Äàòà çàâåğøåíèÿ ôàêòè÷åñêÿ'},

	id_task_type_result       => {TYPE_NAME => 'int', label => 'Ğåçóëüòàò'},
	id_task_route_task_result => {TYPE_NAME => 'int', label => 'Ğåçëóüòàò (äëÿ çàäà÷ ïî ïğîöåññàì)'},
	result                    => {TYPE_NAME => 'text', label => 'Ğåçóëüòàò ïîäğîáíî'},

	id_workgroup_inspector    => {TYPE_NAME => 'int', ref => 'workgroups', label => 'Ãğóïïà êîíòğîë¸ğîâ'},
	id_user_inspector         => {TYPE_NAME => 'int', ref => 'users', label => 'Êîíòğîëåğ'},
	
	id_actual_user_inspector => {TYPE_NAME => 'int', ref => 'users', label => 'Êîíòğîëåğ, ïğèíÿâøèé èñïîëíåíèå çàäà÷è (ìîæåò îòëè÷àòñÿ îò óêàçàííîãî â çàäà÷å)'},
	id_user_who_cancelled    => {TYPE_NAME => 'int', ref => 'users', label => 'Ïîëüçîâàòåëü, îòìåíèâøèé èñïîëíåíèå çàäà÷è'},

},

keys => {
	id_task		=> 'id_task',
},

