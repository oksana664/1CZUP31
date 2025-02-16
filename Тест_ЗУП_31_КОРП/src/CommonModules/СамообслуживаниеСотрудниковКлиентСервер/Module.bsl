
#Область СлужебныеПроцедурыИФункции

Функция ОписаниеНастроекОтправкиУведомлений() Экспорт 
	
	ОписаниеНастроекПользователей = Новый Структура(
	"ВидАдресаЭлектроннойПочты,
	|ВключатьВебСсылкуВУведомление,
	|ЗаголовокУведомления,
	|РассылатьУведомленияАвтоматически,
	|ШаблонУведомления");
	
	Возврат ОписаниеНастроекПользователей;
	
КонецФункции

Функция ОписаниеНастроекСозданияПользователей() Экспорт 
	
	ОписаниеНастроекПользователей = Новый Структура(
	"ГруппаПользователей,
	|ВыбранныеГруппыДоступа,
	|АутентификацияOpenID,
	|АутентификацияСтандартная,
	|ПоказыватьВСпискеВыбора,
	|ЗапрещеноИзменятьПароль,
	|АутентификацияОС");
	
	Возврат ОписаниеНастроекПользователей;
	
КонецФункции

Функция НастройкиОтправкиУведомленийПоУмолчанию() Экспорт 
	
	НастройкиПоУмолчанию = Новый Структура("ЗаголовокУведомления, ШаблонУведомления");								
	
	НастройкиПоУмолчанию.ЗаголовокУведомления 	= НСтр("ru = 'Доступ в систему «1С:Зарплата и управление персоналом 8 КОРП»'");
	
	НастройкиПоУмолчанию.ШаблонУведомления 		= НСтр("ru = 'Для доступа к системе «1С:Зарплата и управление персоналом 8 КОРП» используйте следующие учетные данные:
														|Пользователь: %ИмяПользователяИБ%
														|Пароль: %Пароль%'");
									
	Возврат НастройкиПоУмолчанию;								
									
КонецФункции

Функция ОписаниеПользователя() Экспорт 
	
	ОписаниеПользователя = Новый Структура(
	"Пользователь,
	|Недействителен,
	|ИдентификаторПользователяИБ,
	|ИдентификаторПользователяСервиса");
	
	Возврат ОписаниеПользователя;
	
КонецФункции

#КонецОбласти
