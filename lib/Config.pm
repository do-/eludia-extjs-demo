use Text::Iconv;

use Date::Calc qw(
	Day_of_Week
	Today
	Delta_Days
	Add_Delta_YM
	Add_Delta_Days
	Add_Delta_DHMS
	Days_in_Month
	This_Year
	Today_and_Now
	Now
	Week_Number
	check_date
);


our $ID_PRODUCT_FIELD_GROUP_VITEK        = 30_000;
our $ID_DOC_FIELD_PRODUCT_KIND           = 30_002; # ��� ������������
our $ID_DOC_FIELD_PRODUCT_TYPE           = 30_001; # ��� ������������
our $ID_DOC_FIELD_BRAND                  = 30_000; # �����


our $ID_DOC_TYPE_BANKS                   =     72; # ����
our $ID_DOC_TYPE_BASIC_DOCS              = 10_003; # �������� �������
our $ID_DOC_TYPE_BDDS                    =    100; # ����������� ������(����)
our $ID_DOC_TYPE_BUYING_DMNDS            = 15_001; # ������ �� �������
our $ID_DOC_TYPE_BUYING_ORDERS           =    163; # ����� �� �������
our $ID_DOC_TYPE_COMPANIES               =    194; # ��������
our $ID_DOC_TYPE_CONSIGNMENTS            = 10_037; # ������ ��������
our $ID_DOC_TYPE_DEV_PROJECT             =    213; # ������ ����������
our $ID_DOC_TYPE_DMNDS                   =    165; # ������ �� ������
our $ID_DOC_TYPE_DOC_DESIGN              = 10_001; # ��������������� ������������
our $ID_DOC_TYPE_DOC_DESIGN_SNAP         =    206; # ��������������� ������������ (�� ��������)
our $ID_DOC_TYPE_DOC_FOLDERS             =    200; # ����� ������
our $ID_DOC_TYPE_DOC_TECHNOLOGY          =    203; # ��������������� ������������
our $ID_DOC_TYPE_DOCS                    =    202; # �������
our $ID_DOC_TYPE_ECN_DESIGN              =    204; # ��������������� ���������
our $ID_DOC_TYPE_ECN_TECHNOLOGY          =    208; # ��������������� ���������
our $ID_DOC_TYPE_EQUIPMENT_TYPES         =    191; # ���� ������������
our $ID_DOC_TYPE_INVENTORY_ADJUSTMENTS   = 15_000; # ��������� ��������������
our $ID_DOC_TYPE_INVEST_PROJECTS         =    180; # ������. �������
our $ID_DOC_TYPE_MAP_ORDER_TOOLING       =    205; # ����� ������ ��������
our $ID_DOC_TYPE_OPERATIONS              =    192; # ��������������� ��������
our $ID_DOC_TYPE_ORDERS                  = 10_010; # ���������������� �����
our $ID_DOC_TYPE_ORDERS_TYPES            = 10_036; # ���� �������
our $ID_DOC_TYPE_PAY_LIST                =    101; # ������ ������������ ��������
our $ID_DOC_TYPE_PAY_REGISTER            =    164; # ������ ��������
our $ID_DOC_TYPE_PRODUCTS                =    196; # ������������
our $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS    =    188; # ������ ���������� ������������
our $ID_DOC_TYPE_PRODUCT_PRODUCTION      = 10_033; # ������� ������������
our $ID_DOC_TYPE_PROGRAM_CHPU            =    207; # ��������� ��� ������ � ���
our $ID_DOC_TYPE_PROTOCOL_KK             = 10_024; # �������� ���������� ��������
our $ID_DOC_TYPE_RECLAMATIONS            =    190; # ����������
our $ID_DOC_TYPE_SHIPMENT_ORDERS         = 10_009; # ����� �� ��������
our $ID_DOC_TYPE_TASK_ROUTES             =    197; # ��������
our $ID_DOC_TYPE_TASKS                   = 10_002; # ���� �����
our $ID_DOC_TYPE_TECHNICS                =    214; #
our $ID_DOC_TYPE_TECHNIC_FIELD_GROUPS    = 10_034; # ��������� ������������� �������
our $ID_DOC_TYPE_VOC_AGENTS              =    199; # �����������
our $ID_DOC_TYPE_VOC_CURRENSIES          =    229; # ������
our $ID_DOC_TYPE_VOC_UNIT                =    230; # ������� ���������

# ��������� �� �������� ��� ��������
our $ID_DOC_FIELD_BASE_DOC               = 10_032; # �������� �������
our $ID_DOC_FIELD_BDDS_ARTS              = 10_033; # ������ ���� (�����)
our $ID_DOC_FIELD_BDDS_ARTS_INV          = 10_043; # ������ ���� (������)
our $ID_DOC_FIELD_CFO                    =  1_023; # ���
our $ID_DOC_FIELD_COMPANIES              = 10_087; # ��������
our $ID_DOC_FIELD_DEPS                   = 10_038; # ���. �������������
our $ID_DOC_FIELD_DOC_HOLDERS            = 10_026; # �����������������
our $ID_DOC_FIELD_DOC_SUMMA              = 10_029; # ����� ��������, ��� (�����)
our $ID_DOC_FIELD_DOC_SUMMA_INV          = 10_046; # ����� ��������, ��� (������)
our $ID_DOC_FIELD_DOC_SUMMA_CURRENCY     = 10_037; # ����� ��������, � ������ (�����)
our $ID_DOC_FIELD_DOC_SUMMA_CURRENCY_INV = 10_045; # ����� ��������, � ������ (������)
our $ID_DOC_FIELD_DOC_TYPE               = 10_030; # ��������/���������
our $ID_DOC_FIELD_DOCS                   = 20_003; # �������
our $ID_DOC_FIELD_DT_ACTIVE_UNTIL        = 20_001; # ���� ��������
our $ID_DOC_FIELD_DT_APPROVE_SENT        = 10_027; # ���� �������� �� ������������
our $ID_DOC_FIELD_DT_BEGIN_PLAN          = 10_064; # ���� ������ (����)
our $ID_DOC_FIELD_DT_BEGIN_FACT          = 10_066; # ���� ������ (����)
our $ID_DOC_FIELD_DT_END_PLAN            = 10_065; # ���� ��������� (����)
our $ID_DOC_FIELD_DT_END_FACT            = 10_067; # ���� ��������� (����)
our $ID_DOC_FIELD_DT_SIGNED              = 10_028; # ���� ����������
our $ID_DOC_FIELD_HAS_ACTIVE_DEADLINE    = 20_000; # �� ���������� ������������
our $ID_DOC_FIELD_INVEST_PROJECTS        =   1039; # ������ ������
our $ID_DOC_FIELD_NOTE                   =    509; # ����������
our $ID_DOC_FIELD_ORDERS                 = 10_041; # ���������������� �����
our $ID_DOC_FIELD_PAY_TERMS              = 10_034; # ������� ������� (�����)
our $ID_DOC_FIELD_PAY_TERMS_INV          = 10_044; # ������� ������� (������)
our $ID_DOC_FIELD_PAYERS                 = 20_002; # ����������
our $ID_DOC_FIELD_PROJECT_MANAGER        = 10_068; # ������������ �������
our $ID_DOC_FIELD_PROJECT_SUMMA_PLAN     = 20_004; # ����� ������� (����), ���
our $ID_DOC_FIELD_PROTOCOL_KK            =    404; # �������� ���������� ��������
our $ID_DOC_FIELD_PRODUCT                =    522; # ������������
our $ID_DOC_FIELD_PRODUCT_DOT            = 10_039; # ������������.
our $ID_DOC_FIELD_PRODUCT_PRODUCTION     = 10_082; # ������� ������������
our $ID_DOC_FIELD_RATE                   = 10_036; # ����
our $ID_DOC_FIELD_RATE_1                 = 10_084; # ���. ���� 1
our $ID_DOC_FIELD_RATE_2                 = 10_086; # ���. ���� 2
our $ID_DOC_FIELD_RIGGING                =    526; # ��������
our $ID_DOC_FIELD_SERVICE_TYPES          = 10_031; # ��� �����
our $ID_DOC_FIELD_SHIPMENT_ORDERS        = 10_040; # ����� �� ��������
our $ID_DOC_FIELD_TECHNICS               =     56; # �������
our $ID_DOC_FIELD_USERS                  =    411; # ������������� �� �������
our $ID_DOC_FIELD_VOC_AGENTS             =    413; # ����������
our $ID_DOC_FIELD_VOC_CURRENCIES         = 10_035; # ������
our $ID_DOC_FIELD_VOC_CURRENCIES_1       = 10_083; # ���. ������ 1
our $ID_DOC_FIELD_VOC_CURRENCIES_2       = 10_085; # ���. ������ 2
our $ID_DOC_FIELD_VOC_PAYMENT_TYPE       = 10_042; # ��� �������

our $DOC_FIELD_PRODUCT_IDS               = "522,10039"; #


require_content ('_lib_common');
require_content ('_lib_docs');
require_content ('_lib_tasks');

sub get_skin_name {

warn "get_skin_name: $_REQUEST{type}";

	$_REQUEST {type} eq 'task_route_item_gantt_js2' || $_REQUEST {type} =~ /^sched/ ? 'TurboMilk' : 'ExtJsProxy'

}

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
