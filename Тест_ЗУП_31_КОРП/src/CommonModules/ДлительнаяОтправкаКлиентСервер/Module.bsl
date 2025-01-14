
#Область ПрограммныйИнтерфейс

Функция ФормаДлительнойОтправкиОткрыта() Экспорт
	
	ПараметрыДлительнойОтправки = ЗначенияПараметровДлительнойОтправки();
	ИдентификаторПолучателя 	= ПараметрыДлительнойОтправки["ИдентификаторПолучателя"];
	
	ФормаОткрыта = ЗначениеЗаполнено(ИдентификаторПолучателя);
	
	Возврат ФормаОткрыта;
	
КонецФункции

// Вывод ошибок. Если открыта форма длительной операции - все ошибки будут в ней накапливаться и затем показаны в отдельном окне ошибок.
// Если форма не открыта, но указан идентификатор формы-получателя сообщений, то сообщения выводятся в эту форму.
// В противном случае текст выводится обычным способом в нижнюю часть активной формы.
//
// Параметры:
//  ТекстСообщения	 - Строка - Текст выводимого сообщения.
//
Процедура ВывестиОшибку(
	Знач ТекстСообщения,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь
	) Экспорт
	
	Если ФормаДлительнойОтправкиОткрыта() Тогда
		
		// Добавляем сообщение к уже имеющимся.
		НоваяОшибка = ДлительнаяОтправкаКлиентСервер.НоваяОшибка(ТекстСообщения);
		ИзменитьПараметрыДлительнойОтправки("Ошибки", НоваяОшибка);
		
	Иначе
		Если ЗначениеЗаполнено(КлючДанных)
			ИЛИ ЗначениеЗаполнено(Поле) 
			ИЛИ ЗначениеЗаполнено(ПутьКДанным)
			ИЛИ Отказ <> Ложь Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
		Иначе
			ДокументооборотСКОКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиПредупреждение(
	Знач ТекстСообщения,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь
	) Экспорт
	
	Если ФормаДлительнойОтправкиОткрыта() Тогда
		// Предупреждения не показываем при открытой форме ошибок.
	Иначе
		Если ЗначениеЗаполнено(КлючДанных)
			ИЛИ ЗначениеЗаполнено(Поле) 
			ИЛИ ЗначениеЗаполнено(ПутьКДанным)
			ИЛИ Отказ <> Ложь Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, КлючДанных, Поле, ПутьКДанным, Отказ);
		Иначе
			ДокументооборотСКОКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьПараметрыДлительнойОтправки() Экспорт
	
	СоздатьПараметрыДлительнойОтправкиПриНеобходимости();
	ТекущееЗначениеПараметров 	= ЗначенияПараметровПоУмолчанию(); 
	НовоеЗначениеПараметров 	= Новый ФиксированноеСоответствие(ТекущееЗначениеПараметров);
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ПараметрыСеанса["СостояниеДлительнойОтправки"] = НовоеЗначениеПараметров;
	#Иначе
		ПараметрыПриложения["БРО.СостояниеДлительнойОтправки"] = НовоеЗначениеПараметров;
	#КонецЕсли
	
КонецПроцедуры

// Запоминаем параметры бублика в ПараметрыПриложения
// чтобы потом их можно было использовать не только из ЭДО,
// но и из модулей рег. отчетности.
// Список ключей - в процедуре ЗначенияПараметровПоУмолчанию.
Процедура ИзменитьПараметрыДлительнойОтправки(КлючПараметра, НовоеЗначение) Экспорт
		
	ТекущееЗначениеПараметров = ЗначенияПараметровДлительнойОтправки();
	ТекущееЗначениеПараметров = Новый Соответствие(ТекущееЗначениеПараметров);
	
	Если КлючПараметра = "Ошибки" Тогда
		ТекущееЗначениеПараметров["Ошибки"] = ДобавитьОшибку(ТекущееЗначениеПараметров["Ошибки"], НовоеЗначение);
	Иначе
		ТекущееЗначениеПараметров[КлючПараметра] = НовоеЗначение;
	КонецЕсли; 
	
	НовоеЗначениеПараметров = Новый ФиксированноеСоответствие(ТекущееЗначениеПараметров);
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ПараметрыСеанса["СостояниеДлительнойОтправки"] = НовоеЗначениеПараметров;
	#Иначе
		ПараметрыПриложения["БРО.СостояниеДлительнойОтправки"] = НовоеЗначениеПараметров;
	#КонецЕсли
	
КонецПроцедуры

Функция ЗначенияПараметровПоУмолчанию() Экспорт
	
	СостояниеДлительнойОтправки = Новый Соответствие;
	// Идентификатор формы, в которую будут выводиться сообщения, чтобы они 
	// не наезжали на бублик и не загораживали его.
	СостояниеДлительнойОтправки.Вставить("ИдентификаторПолучателя", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	СостояниеДлительнойОтправки.Вставить("Ошибки", 					Новый ФиксированныйМассив(Новый Массив));
	СостояниеДлительнойОтправки.Вставить("ТекущаяОрганизация", 		Неопределено);
	
	Возврат СостояниеДлительнойОтправки;
	
КонецФункции

Функция ЗначенияПараметровДлительнойОтправки() Экспорт
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		ПараметрыДлительнойОтправки = ПараметрыСеанса["СостояниеДлительнойОтправки"];
		
		// Здесь никогда не может оказаться пустого параметра сеанса, потому что 
		// он обязательно инициализируется при запуске программы процедурами БСП. 
		
	#Иначе
		
		ПараметрыДлительнойОтправки = ПараметрыПриложения["БРО.СостояниеДлительнойОтправки"];
		
		Если ПараметрыДлительнойОтправки = Неопределено Тогда
			ЗначенияПоУмолчанию = ЗначенияПараметровПоУмолчанию();
			ПараметрыПриложения.Вставить("БРО.СостояниеДлительнойОтправки", Новый ФиксированноеСоответствие(ЗначенияПоУмолчанию));
			ПараметрыДлительнойОтправки = ПараметрыПриложения["БРО.СостояниеДлительнойОтправки"];
		КонецЕсли;
		
	#КонецЕсли
	
	Возврат ПараметрыДлительнойОтправки;
	
КонецФункции

Функция ЗначениеПараметраДлительнойОтправки(КлючПараметра)
	
	ТекущееЗначениеПараметров = ЗначенияПараметровДлительнойОтправки();
	ЗначениеПараметра = ТекущееЗначениеПараметров[КлючПараметра];
	
	Возврат ЗначениеПараметра;
	
КонецФункции

Функция ДобавитьОшибку(Знач Ошибки, Знач НоваяОшибка) Экспорт
	
	// Не добавляем дублирующуюся ошибку.
	Если ТакаяОшибкаУжеЕсть(Ошибки, НоваяОшибка) Тогда
		Возврат Ошибки;
	Иначе
		// Ошибки - это фиксированный массив,
		// его можно менять только преобразовав в обычный массив.
		ОшибкиПослеДобавления = Новый Массив(Ошибки);
		ОшибкиПослеДобавления.Добавить(НоваяОшибка);
		
		Возврат Новый ФиксированныйМассив(ОшибкиПослеДобавления);
	
	КонецЕсли;
	
КонецФункции

Функция ТакаяОшибкаУжеЕсть(Знач Ошибки, Знач НоваяОшибка) Экспорт
	
	Для каждого Ошибка Из Ошибки Цикл
		Если Ошибка["ОписаниеОшибки"] = НоваяОшибка["ОписаниеОшибки"]
			И Ошибка["Организация"] = НоваяОшибка["Организация"] Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция НоваяОшибка(Знач ОписаниеОшибки) Экспорт
	
	// Текст ошибки.
	НоваяОшибка = Новый Структура;
	НоваяОшибка.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	
	// Организация.
	ТекущаяОрганизация = ЗначениеПараметраДлительнойОтправки("ТекущаяОрганизация");
	Если ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		Организация = ТекущаяОрганизация;
	КонецЕсли;
	НоваяОшибка.Вставить("Организация", Организация);
	
	НоваяОшибка = Новый ФиксированнаяСтруктура(НоваяОшибка);
	
	Возврат НоваяОшибка;
	
КонецФункции

Функция ВидОбъекта(СсылкаНаОбъект) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоОтчет", 				Ложь);
	ДополнительныеПараметры.Вставить("ЭтоПисьмо", 				Ложь);
	ДополнительныеПараметры.Вставить("ЭтоОтветНаТребование",	Ложь);
	ДополнительныеПараметры.Вставить("ЭтоСверка", 				Ложь);
	ДополнительныеПараметры.Вставить("ЭтоЕГРЮЛ", 				Ложь);
	ДополнительныеПараметры.Вставить("ЭтоМакетПФР", 			Ложь);
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		
		ТипОбъекта = ТипЗнч(СсылкаНаОбъект);
		
		Если ТипОбъекта = Тип("СправочникСсылка.ДокументыРеализацииПолномочийНалоговыхОрганов")
			ИЛИ ТипОбъекта = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы")
			ИЛИ ТипОбъекта = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС") Тогда
			ДополнительныеПараметры.ЭтоОтветНаТребование = Истина;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами") Тогда
			ДополнительныеПараметры.ЭтоПисьмо = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ЗапросНаИнформационноеОбслуживаниеНалогоплательщика")
			ИЛИ ТипОбъекта = Тип("ДокументСсылка.ЗапросНаИнформационноеОбслуживаниеСтрахователя") Тогда
			ДополнительныеПараметры.ЭтоСверка = Истина;
		ИначеЕсли ТипОбъекта = Тип("ДокументСсылка.ЗапросНаВыпискуИзЕГРЮЛ_ЕГРИП") Тогда
			ДополнительныеПараметры.ЭтоЕГРЮЛ = Истина;
		ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.МакетыПенсионныхДел") Тогда
			ДополнительныеПараметры.ЭтоМакетПФР = Истина;
		Иначе
			ДополнительныеПараметры.ЭтоОтчет = Истина;
		КонецЕсли;
			
	КонецЕсли;
		
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция НазваниеОбъектаВИменительномПадеже(СсылкаНаОбъект, ПерваяБукваЗаглавная = Ложь) Экспорт
	
	ВидОбъекта = ВидОбъекта(СсылкаНаОбъект);
	
	Если ВидОбъекта.ЭтоПисьмо Тогда
		Название = НСтр("ru = 'письмо'");
	ИначеЕсли ВидОбъекта.ЭтоОтветНаТребование Тогда
		Название = НСтр("ru = 'ответ на требование'");
	ИначеЕсли ВидОбъекта.ЭтоСверка Тогда
		Название = НСтр("ru = 'запрос на сверку'");
	ИначеЕсли ВидОбъекта.ЭтоЕГРЮЛ Тогда
		Название = НСтр("ru = 'запрос на выписку'");
	ИначеЕсли ВидОбъекта.ЭтоМакетПФР Тогда
		Название = НСтр("ru = 'макет пенсионных дел'");
	Иначе
		Название = НСтр("ru = 'отчет'");
	КонецЕсли;
	
	Если ПерваяБукваЗаглавная Тогда
		Название = ВРег(Лев(Название,1)) + НРег(Сред(Название, 2));
	КонецЕсли;
		
	Возврат Название;
	
КонецФункции

Функция НазваниеОбъектаВРодительномПадеже(СсылкаНаОбъект) Экспорт
	
	ВидОбъекта = ВидОбъекта(СсылкаНаОбъект);
	
	Если ВидОбъекта.ЭтоПисьмо Тогда
		Название = НСтр("ru = 'письма'");
	ИначеЕсли ВидОбъекта.ЭтоОтветНаТребование Тогда
		Название = НСтр("ru = 'ответа на требование'");
	ИначеЕсли ВидОбъекта.ЭтоСверка Тогда
		Название = НСтр("ru = 'запроса на сверку'");
	ИначеЕсли ВидОбъекта.ЭтоЕГРЮЛ Тогда
		Название = НСтр("ru = 'запроса на выписку'");
	ИначеЕсли ВидОбъекта.ЭтоМакетПФР Тогда
		Название = НСтр("ru = 'макета пенсионных дел'");
	Иначе
		Название = НСтр("ru = 'отчета'");
	КонецЕсли;
		
	Возврат Название;
	
КонецФункции

Функция КоличествоОшибокОтменыДействия(Ошибки) Экспорт
	
	ОшибкиОтменыДействия = Новый Массив;
	// КриптоПро
	ОшибкиОтменыДействия.Добавить("The operation was canceled by the user");
	ОшибкиОтменыДействия.Добавить("Действие было отменено пользователем");
	// VipNet
	ОшибкиОтменыДействия.Добавить("Операция была отменена пользователем");
	// ЭП в облаке
	ОшибкиОтменыДействия.Добавить("Пользователь отказался от ввода пароля");
	
	КоличествоОшибокОтменыДействия = 0;
	
	Для каждого ОшибкаИзФиксированногоМассива Из Ошибки Цикл
		
		Для каждого ОшибкаОтменыДействия Из ОшибкиОтменыДействия Цикл
			Если Найти(ОшибкаИзФиксированногоМассива.ОписаниеОшибки, ОшибкаОтменыДействия) > 0 Тогда
				КоличествоОшибокОтменыДействия = КоличествоОшибокОтменыДействия + 1;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат КоличествоОшибокОтменыДействия;
	
КонецФункции

#Область ВспомогательныеПроцедурыИФункции

Функция ДобавитьСтроку(ПредыдущиеЗначения, НовоеСообщение, Разделитель = Неопределено) Экспорт
	
	Если Разделитель = Неопределено Тогда
		Разделитель = РазделительСтрок();
	КонецЕсли;
	
	// Не добавляем дублирующиеся сообщения.
	Если Найти(ПредыдущиеЗначения, НовоеСообщение) = 0 Тогда
		// Вместо символа ПС используем другой разделитель ошибок, поскольку внутри одного сообщения
		// текст уже может быть разделен символом ПС и тогда одно сообщение будет разбито на два.
		Если ЗначениеЗаполнено(ПредыдущиеЗначения) Тогда
			Возврат СокрЛП(СокрЛП(ПредыдущиеЗначения) + Разделитель + НовоеСообщение);
		Иначе
			Возврат СокрЛП(НовоеСообщение);
		КонецЕсли;
	Иначе
		Возврат СокрЛП(ПредыдущиеЗначения);
	КонецЕсли;
	
КонецФункции

Функция ЧислоИПредметИсчисления(
		Число,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род) Экспорт
	
	ФорматнаяСтрока = "Л = ru_RU";
	
	ПараметрыПредметаИсчисления = "%1,%2,%3,%4,,,,,0";
	ПараметрыПредметаИсчисления = СтрШаблон(
		ПараметрыПредметаИсчисления,
		ПараметрыПредметаИсчисления1,
		ПараметрыПредметаИсчисления2,
		ПараметрыПредметаИсчисления3,
		Род);
		
	ЧислоСтрокойИПредметИсчисления = НРег(ЧислоПрописью(Число, ФорматнаяСтрока, ПараметрыПредметаИсчисления));
	
	ЧислоПрописью = ЧислоСтрокойИПредметИсчисления;
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления3, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления2, "");
	ЧислоПрописью = СтрЗаменить(ЧислоПрописью, ПараметрыПредметаИсчисления1, "");
	
	ЧислоЦифройИПредметИсчисления = Строка(Число) + " " + СтрЗаменить(ЧислоСтрокойИПредметИсчисления, ЧислоПрописью, "");
	
	Возврат ЧислоЦифройИПредметИсчисления;
	
КонецФункции

Функция ЗаменитьПоследнююЗапятуюНаИ(ИсходнаяСтрока, Разделитель = ", ") Экспорт
	
	ДлинаРазделителя = СтрДлина(Разделитель);
	
	ПозицияРазделителя = СтрНайти(ИсходнаяСтрока, Разделитель, НаправлениеПоиска.СКонца);
	Если ПозицияРазделителя <> 0 Тогда
		
		ПодстрокаДоРазделителя 		= Лев(ИсходнаяСтрока, ПозицияРазделителя - 1);
		ПодстрокаПослеРазделителя 	= Сред(ИсходнаяСтрока, ПозицияРазделителя + ДлинаРазделителя);
		
		ИсходнаяСтрока = ПодстрокаДоРазделителя + " и " + ПодстрокаПослеРазделителя;
		
	КонецЕсли;
	
	Возврат ИсходнаяСтрока;
	
КонецФункции

Функция РазделительСтрок() Экспорт

	Возврат Символы.Таб;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьПараметрыДлительнойОтправкиПриНеобходимости()

	 ЗначенияПараметровДлительнойОтправки();

КонецПроцедуры


#КонецОбласти