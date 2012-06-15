
################################################################################

sub get_item_of_docs {

	my $data = sql (docs => $_REQUEST {id},
		'log(dt)',
		'users(label)',
		'doc_folders(label)',

		'doc_field_data(NONE) ON doc_field_data.id_type = docs.id AND doc_field_data.id_doc_type = docs.id_doc_type AND doc_field_data.fake = 0 and doc_field_data.id_doc_field = 100201',
		'products(full_name) ON doc_field_data.id_doc_voc_data',
		'voc_groups(label)',
		'doc_field_data(notes) AS dfd_prod ON dfd_prod.id_type = docs.id AND dfd_prod.id_doc_type = docs.id_doc_type AND dfd_prod.fake = 0 and dfd_prod.id_doc_field = 100203',
		'doc_field_data(label) AS dfd_mark ON dfd_mark.id_type = docs.id AND dfd_mark.id_doc_type = docs.id_doc_type AND dfd_mark.fake = 0 and dfd_mark.id_doc_field = 100204',
		'doc_field_data(NONE) AS dfd_users ON dfd_users.id_type = docs.id AND dfd_users.id_doc_type = docs.id_doc_type AND dfd_users.fake = 0 and dfd_users.id_doc_field = 100205',
		'users(label) AS man_users ON dfd_users.id_doc_voc_data',
		'doc_field_data(notes) AS dfd_func ON dfd_func.id_type = docs.id AND dfd_func.id_doc_type = docs.id_doc_type AND dfd_func.fake = 0 and dfd_func.id_doc_field = 100206',
		'doc_field_data(notes) AS dfd_lic ON dfd_lic.id_type = docs.id AND dfd_lic.id_doc_type = docs.id_doc_type AND dfd_lic.fake = 0 and dfd_lic.id_doc_field = 100207',
		'doc_field_data(NONE) AS dfd_dir_users ON dfd_dir_users.id_type = docs.id AND dfd_dir_users.id_doc_type = docs.id_doc_type AND dfd_dir_users.fake = 0 and dfd_dir_users.id_doc_field = 100218',
		'users(label) AS dir_users ON dfd_dir_users.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com1 ON dfd_com1.id_type = docs.id AND dfd_com1.id_doc_type = docs.id_doc_type AND dfd_com1.fake = 0 and dfd_com1.id_doc_field = 100220 AND dfd_com1.id_doc_field_group = 100211',
		'docs(label_href) AS com1 ON dfd_com1.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com2 ON dfd_com2.id_type = docs.id AND dfd_com2.id_doc_type = docs.id_doc_type AND dfd_com2.fake = 0 and dfd_com2.id_doc_field = 100221 AND dfd_com2.id_doc_field_group = 100211',
		'docs(label_href) AS com2 ON dfd_com2.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com3 ON dfd_com3.id_type = docs.id AND dfd_com3.id_doc_type = docs.id_doc_type AND dfd_com3.fake = 0 and dfd_com3.id_doc_field = 100225 AND dfd_com3.id_doc_field_group = 100211',
		'docs(label_href) AS com3 ON dfd_com3.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_boss_users ON dfd_boss_users.id_type = docs.id AND dfd_boss_users.id_doc_type = docs.id_doc_type AND dfd_boss_users.fake = 0 and dfd_boss_users.id_doc_field = 100229 AND dfd_boss_users.id_doc_field_group = 100211',
		'users(label) AS boss_users ON dfd_boss_users.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com12 ON dfd_com12.id_type = docs.id AND dfd_com12.id_doc_type = docs.id_doc_type AND dfd_com12.fake = 0 and dfd_com12.id_doc_field = 100220 AND dfd_com12.id_doc_field_group = 100230',
		'docs(label_href) AS com12 ON dfd_com12.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com22 ON dfd_com22.id_type = docs.id AND dfd_com22.id_doc_type = docs.id_doc_type AND dfd_com22.fake = 0 and dfd_com22.id_doc_field = 100221 AND dfd_com22.id_doc_field_group = 100230',
		'docs(label_href) AS com22 ON dfd_com22.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com32 ON dfd_com32.id_type = docs.id AND dfd_com32.id_doc_type = docs.id_doc_type AND dfd_com32.fake = 0 and dfd_com32.id_doc_field = 100225 AND dfd_com32.id_doc_field_group = 100230',
		'docs(label_href) AS com32 ON dfd_com32.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_boss_users2 ON dfd_boss_users2.id_type = docs.id AND dfd_boss_users2.id_doc_type = docs.id_doc_type AND dfd_boss_users2.fake = 0 and dfd_boss_users2.id_doc_field = 100229 AND dfd_boss_users2.id_doc_field_group = 100230',
		'users(label) AS boss_users2 ON dfd_boss_users2.id_doc_voc_data',

		'doc_field_data(NONE) AS dfd_com_dir_users ON dfd_com_dir_users.id_type = docs.id AND dfd_com_dir_users.id_doc_type = docs.id_doc_type AND dfd_com_dir_users.fake = 0 and dfd_com_dir_users.id_doc_field = 100242 AND dfd_com_dir_users.id_doc_field_group = 100241',
		'users(label) AS com_dir_users ON dfd_com_dir_users.id_doc_voc_data',

	);

	my $fields = {

		'100208_100209' => {field => 'dt',    name => 'dfd_dt_set'},
		'100208_100210' => {field => 'dt',    name => 'dfd_dt_get'},

		'100211_100212' => {field => 'sum',   name => 'dfd_serious1'},
		'100211_100213' => {field => 'sum',   name => 'dfd_minor1'},
		'100211_100214' => {field => 'label', name => 'dfd_recom1'},

		'100211_100222' => {field => 'sum',   name => 'dfd_serious2'},
		'100211_100223' => {field => 'sum',   name => 'dfd_minor2'},
		'100211_100224' => {field => 'label', name => 'dfd_recom2'},

		'100211_100226' => {field => 'sum',   name => 'dfd_serious3'},
		'100211_100227' => {field => 'sum',   name => 'dfd_minor3'},
		'100211_100228' => {field => 'label', name => 'dfd_recom3'},

		'100219_100209' => {field => 'dt',    name => 'dfd_dt_set2'},
		'100219_100210' => {field => 'dt',    name => 'dfd_dt_get2'},

		'100230_100212' => {field => 'sum',   name => 'dfd_serious12'},
		'100230_100213' => {field => 'sum',   name => 'dfd_minor12'},
		'100230_100214' => {field => 'label', name => 'dfd_recom12'},

		'100230_100222' => {field => 'sum',   name => 'dfd_serious22'},
		'100230_100223' => {field => 'sum',   name => 'dfd_minor22'},
		'100230_100224' => {field => 'label', name => 'dfd_recom22'},

		'100230_100226' => {field => 'sum',   name => 'dfd_serious32'},
		'100230_100227' => {field => 'sum',   name => 'dfd_minor32'},
		'100230_100228' => {field => 'label', name => 'dfd_recom32'},
		'100230_100231' => {field => 'notes', name => 'dfd_output'},

		'100241_100232' => {field => 'label', name => 'dfd_no'},
		'100241_100233' => {field => 'dt',    name => 'dfd_first_ship'},

		'100234_100235' => {field => 'label', name => 'dfd_color1'},
		'100234_100237' => {field => 'label', name => 'dfd_color2'},
		'100234_100239' => {field => 'label', name => 'dfd_color3'},
		'100234_100236' => {field => 'sum',   name => 'dfd_percent1'},
		'100234_100238' => {field => 'sum',   name => 'dfd_percent2'},
		'100234_100240' => {field => 'sum',   name => 'dfd_percent3'},

	};

	sql_select_loop (
		"SELECT * FROM doc_field_data WHERE fake = 0 AND id_doc_type = ? AND id_type = ?",
		sub {
			if ($fields -> {"$$i{id_doc_field_group}_$$i{id_doc_field}"} -> {field}) {
				my $f = $fields -> {"$$i{id_doc_field_group}_$$i{id_doc_field}"};
				$data -> {$f -> {name}} -> {$f -> {field}} = $i -> {$f -> {field}};
				if ($f -> {field} eq 'sum') {
					$data -> {$f -> {name}} -> {$f -> {field}} = $data -> {$f -> {name}} -> {$f -> {field}} == 0 ? ''
						: $data -> {$f -> {name}} -> {$f -> {field}} + 0;
				}
			}
		},
		$data -> {id_doc_type}, $data -> {id}
	);

	if ($data -> {dfd_lic} -> {notes}) {
		$data -> {licenses} = join '<br>', sql_select_col ("SELECT label_href FROM docs WHERE id IN ($data->{dfd_lic}->{notes})");
	}

	foreach my $f1 (qw (dfd_serious dfd_minor)) {
		foreach my $f2 (qw (1 2 3 12 22 32)) {
			$data -> {"$f1$f2"} -> {sum} = $data -> {"$f1$f2"} -> {sum} == 0 ? '' : $data -> {"$f1$f2"} -> {sum} + 0;
		}
	}

darn $data;
	return $data;

}

################################################################################

sub select_docs {

	darn sql ({},

		docs => [

			'in_list',

			['id_doc_folder IN' => $_REQUEST {tree} ? [sql_select_subtree (doc_folders => $_REQUEST {id_doc_folder})] : $_REQUEST {id_doc_folder}],
			['label LIKE %?%'  => $_REQUEST {q}],

			[ LIMIT => 'start, 25'],

		],
		'doc_field_data(NONE) ON doc_field_data.id_type = docs.id AND doc_field_data.id_doc_type = docs.id_doc_type AND doc_field_data.fake = 0 and doc_field_data.id_doc_field = 100201',
		'products(full_name) ON doc_field_data.id_doc_voc_data',
		'voc_groups',
		'doc_field_data(NONE) AS dfd_users ON dfd_users.id_type = docs.id AND dfd_users.id_doc_type = docs.id_doc_type AND dfd_users.fake = 0 and dfd_users.id_doc_field = 100205',
		'users ON dfd_users.id_doc_voc_data',

	);

}

1;
