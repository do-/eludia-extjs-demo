################################################################################

sub is_base_doc_remote { # документ-основание объекта из другой базы

	my ($data) = @_;

	$preconf -> {peer_name} or return 0;

	# функция вызывается в списке задач и на портале для каждой задачи,
	# require достаточно дорогая операция,
	# поэтому результат функции определения, нужен ли проброс, кэшируем
	my $can_edit_in_current_base = "__can_edit_in_current_base_$$data{id_doc_type}";

	if (!exists $_REQUEST {$can_edit_in_current_base}) {

		$_REQUEST {$can_edit_in_current_base} = call_doc_type_proc ({
				id_doc_type => $data -> {id_doc_type}
			},
			'is_editable_in_current_base'
		);
	}

	if (defined $_REQUEST {$can_edit_in_current_base}) {

		return !$_REQUEST {$can_edit_in_current_base};

	}

	return !$data -> {id_type};
}

################################################################################
# составляет название объекта-основания задачи, процесса
#
#	параметры - хэш {
#		id_doc_type => тип документа
#		id_type     => id документа
#	}
#	возвращает название объекта-основания
sub get_base_doc_label {

	my ($data) = @_;

	if  (is_base_doc_remote ($data))
	{
		return $data -> {base_doc_type_label} || '';
	}

	my $doc_type = exists $data -> {doc_type} && $data -> {doc_type} -> {id} ?
		$data -> {doc_type}
		: sql_select_hash ('doc_types', $data -> {id_doc_type});

	my $doc_type_table = get_doc_type_table ($doc_type);
	$doc_type -> {label_field} ||= 'label';

	my $base_doc_label = sql_select_scalar (
		"SELECT $doc_type->{label_field} FROM $doc_type_table WHERE id = ?",
		$data -> {id_type} || -1
	);
	$base_doc_label ||= $data -> {base_doc_type_label};

	return $base_doc_label;

}
