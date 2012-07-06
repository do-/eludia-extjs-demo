 label => 'Êàëåíäàğè ïîëüçîâàòåëåé',

columns => {
	id_user       => 'select (users)', # Âëàäåëåö êàëåíäàğÿ
	label         => 'string',         # Íàèìåíîâàíèå
	id___query    => "select ($conf->{systables}->{__queries})", # Ôèëüòğ êàëåíäàğÿ
	color         => 'string',         # Öâåò çàäà÷
	is_personal   => 'checkbox',       # Ëè÷íûé êàëåíäàğü
	description   => 'text',
	is_hidden     => 'checkbox',       # Ëè÷íûé êàëåíäàğü
},

keys => {
	id_user => 'id_user',
},


