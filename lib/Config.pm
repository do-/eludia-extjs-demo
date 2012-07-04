
require_content ('_lib_common');
require_content ('_lib_docs');
require_content ('_lib_tasks');

sub get_skin_name {'ExtJsProxy'}

# �������� � /var/projects/pdm ����� vitek_voc_goods_fields_as_doc_fields
our $ID_DOC_FIELD_BRAND                  = 30_000; # �����
our $ID_DOC_FIELD_PRODUCT_KIND           = 30_002; # ��� ������������
our $ID_DOC_FIELD_PRODUCT_TYPE           = 30_001; # ��� ������������

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


1;
