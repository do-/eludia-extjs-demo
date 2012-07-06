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
our $ID_DOC_FIELD_PRODUCT_KIND           = 30_002; # Вид номенклатуры
our $ID_DOC_FIELD_PRODUCT_TYPE           = 30_001; # Тип номенклатуры
our $ID_DOC_FIELD_BRAND                  = 30_000; # Бренд


our $ID_DOC_TYPE_BANKS                   =     72; # Банк
our $ID_DOC_TYPE_BASIC_DOCS              = 10_003; # Основной договор
our $ID_DOC_TYPE_BDDS                    =    100; # Планировать бюджет(БДДС)
our $ID_DOC_TYPE_BUYING_DMNDS            = 15_001; # Заявки на закупку
our $ID_DOC_TYPE_BUYING_ORDERS           =    163; # Заказ на закупку
our $ID_DOC_TYPE_COMPANIES               =    194; # Компания
our $ID_DOC_TYPE_CONSIGNMENTS            = 10_037; # Партии поставки
our $ID_DOC_TYPE_DEV_PROJECT             =    213; # Проект разработки
our $ID_DOC_TYPE_DMNDS                   =    165; # Заявка на оплату
our $ID_DOC_TYPE_DOC_DESIGN              = 10_001; # Конструкторская документация
our $ID_DOC_TYPE_DOC_DESIGN_SNAP         =    206; # Конструкторская документация (на оснастку)
our $ID_DOC_TYPE_DOC_FOLDERS             =    200; # Папки Архива
our $ID_DOC_TYPE_DOC_TECHNOLOGY          =    203; # Технологическая документация
our $ID_DOC_TYPE_DOCS                    =    202; # Договор
our $ID_DOC_TYPE_ECN_DESIGN              =    204; # Конструкторское извещение
our $ID_DOC_TYPE_ECN_TECHNOLOGY          =    208; # Технологическое извещение
our $ID_DOC_TYPE_EQUIPMENT_TYPES         =    191; # Типы оборудования
our $ID_DOC_TYPE_INVENTORY_ADJUSTMENTS   = 15_000; # Ведомость инвентаризации
our $ID_DOC_TYPE_INVEST_PROJECTS         =    180; # Инвест. проекты
our $ID_DOC_TYPE_MAP_ORDER_TOOLING       =    205; # Карта заказа оснастки
our $ID_DOC_TYPE_OPERATIONS              =    192; # Технологические операции
our $ID_DOC_TYPE_ORDERS                  = 10_010; # Производственный заказ
our $ID_DOC_TYPE_ORDERS_TYPES            = 10_036; # Типы заказов
our $ID_DOC_TYPE_PAY_LIST                =    101; # Список согласования платежей
our $ID_DOC_TYPE_PAY_REGISTER            =    164; # Реестр платежей
our $ID_DOC_TYPE_PRODUCTS                =    196; # Номенклатура
our $ID_DOC_TYPE_PRODUCT_FIELD_GROUPS    =    188; # Группы параметров номенклатуры
our $ID_DOC_TYPE_PRODUCT_PRODUCTION      = 10_033; # Способы изготовления
our $ID_DOC_TYPE_PROGRAM_CHPU            =    207; # Программа для станка с ЧПУ
our $ID_DOC_TYPE_PROTOCOL_KK             = 10_024; # Протокол конкурсной комиссии
our $ID_DOC_TYPE_RECLAMATIONS            =    190; # Рекламация
our $ID_DOC_TYPE_SHIPMENT_ORDERS         = 10_009; # Заказ на отгрузку
our $ID_DOC_TYPE_TASK_ROUTES             =    197; # Процессы
our $ID_DOC_TYPE_TASKS                   = 10_002; # Типы задач
our $ID_DOC_TYPE_TECHNICS                =    214; #
our $ID_DOC_TYPE_TECHNIC_FIELD_GROUPS    = 10_034; # Параметры обслуживаемой техники
our $ID_DOC_TYPE_VOC_AGENTS              =    199; # Контрагенты
our $ID_DOC_TYPE_VOC_CURRENSIES          =    229; # Валюта
our $ID_DOC_TYPE_VOC_UNIT                =    230; # Единицы измерения

# Размещаем по алфавиту имён констант
our $ID_DOC_FIELD_BASE_DOC               = 10_032; # Основной договор
our $ID_DOC_FIELD_BDDS_ARTS              = 10_033; # Статья БДДС (доход)
our $ID_DOC_FIELD_BDDS_ARTS_INV          = 10_043; # Статья БДДС (расход)
our $ID_DOC_FIELD_CFO                    =  1_023; # ЦФО
our $ID_DOC_FIELD_COMPANIES              = 10_087; # Компания
our $ID_DOC_FIELD_DEPS                   = 10_038; # Отв. подразделение
our $ID_DOC_FIELD_DOC_HOLDERS            = 10_026; # Договородержатель
our $ID_DOC_FIELD_DOC_SUMMA              = 10_029; # Сумма договора, руб (доход)
our $ID_DOC_FIELD_DOC_SUMMA_INV          = 10_046; # Сумма договора, руб (расход)
our $ID_DOC_FIELD_DOC_SUMMA_CURRENCY     = 10_037; # Сумма договора, в валюте (доход)
our $ID_DOC_FIELD_DOC_SUMMA_CURRENCY_INV = 10_045; # Сумма договора, в валюте (расход)
our $ID_DOC_FIELD_DOC_TYPE               = 10_030; # Доходный/расходный
our $ID_DOC_FIELD_DOCS                   = 20_003; # Договор
our $ID_DOC_FIELD_DT_ACTIVE_UNTIL        = 20_001; # Срок действия
our $ID_DOC_FIELD_DT_APPROVE_SENT        = 10_027; # Дата отправки на согласование
our $ID_DOC_FIELD_DT_BEGIN_PLAN          = 10_064; # Дата начала (план)
our $ID_DOC_FIELD_DT_BEGIN_FACT          = 10_066; # Дата начала (факт)
our $ID_DOC_FIELD_DT_END_PLAN            = 10_065; # Дата окончания (план)
our $ID_DOC_FIELD_DT_END_FACT            = 10_067; # Дата окончания (факт)
our $ID_DOC_FIELD_DT_SIGNED              = 10_028; # Дата заключения
our $ID_DOC_FIELD_HAS_ACTIVE_DEADLINE    = 20_000; # До исполнения обязательств
our $ID_DOC_FIELD_INVEST_PROJECTS        =   1039; # Инвест проект
our $ID_DOC_FIELD_NOTE                   =    509; # Примечание
our $ID_DOC_FIELD_ORDERS                 = 10_041; # Производственный заказ
our $ID_DOC_FIELD_PAY_TERMS              = 10_034; # Условия платежа (доход)
our $ID_DOC_FIELD_PAY_TERMS_INV          = 10_044; # Условия платежа (расход)
our $ID_DOC_FIELD_PAYERS                 = 20_002; # Плательщик
our $ID_DOC_FIELD_PROJECT_MANAGER        = 10_068; # Руководитель проекта
our $ID_DOC_FIELD_PROJECT_SUMMA_PLAN     = 20_004; # Сумма проекта (план), руб
our $ID_DOC_FIELD_PROTOCOL_KK            =    404; # Протокол конкурсной комиссии
our $ID_DOC_FIELD_PRODUCT                =    522; # Номенклатура
our $ID_DOC_FIELD_PRODUCT_DOT            = 10_039; # Номенклатура.
our $ID_DOC_FIELD_PRODUCT_PRODUCTION     = 10_082; # Способы изготовления
our $ID_DOC_FIELD_RATE                   = 10_036; # Курс
our $ID_DOC_FIELD_RATE_1                 = 10_084; # Доп. курс 1
our $ID_DOC_FIELD_RATE_2                 = 10_086; # Доп. курс 2
our $ID_DOC_FIELD_RIGGING                =    526; # Оснастка
our $ID_DOC_FIELD_SERVICE_TYPES          = 10_031; # Тип услуг
our $ID_DOC_FIELD_SHIPMENT_ORDERS        = 10_040; # Заказ на отгрузку
our $ID_DOC_FIELD_TECHNICS               =     56; # Техника
our $ID_DOC_FIELD_USERS                  =    411; # Ответственный за договор
our $ID_DOC_FIELD_VOC_AGENTS             =    413; # Контрагент
our $ID_DOC_FIELD_VOC_CURRENCIES         = 10_035; # Валюта
our $ID_DOC_FIELD_VOC_CURRENCIES_1       = 10_083; # Доп. валюта 1
our $ID_DOC_FIELD_VOC_CURRENCIES_2       = 10_085; # Доп. валюта 2
our $ID_DOC_FIELD_VOC_PAYMENT_TYPE       = 10_042; # Тип платежа

our $DOC_FIELD_PRODUCT_IDS               = "522,10039"; #


require_content ('_lib_common');
require_content ('_lib_docs');
require_content ('_lib_tasks');

sub get_skin_name {

warn "get_skin_name: $_REQUEST{type}";

	$_REQUEST {type} eq 'task_route_item_gantt_js2' || $_REQUEST {type} =~ /^sched/ ? 'TurboMilk' : 'ExtJsProxy'

}

# описания в /var/projects/pdm ветка vitek_voc_goods_fields_as_doc_fields
our $ID_DOC_FIELD_BRAND                  = 30_000; # Бренд
our $ID_DOC_FIELD_PRODUCT_KIND           = 30_002; # Вид номенклатуры
our $ID_DOC_FIELD_PRODUCT_TYPE           = 30_001; # Тип номенклатуры

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
