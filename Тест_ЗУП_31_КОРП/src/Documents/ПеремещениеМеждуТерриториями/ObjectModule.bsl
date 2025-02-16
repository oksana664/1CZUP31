#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.ТерриторияТруда.Скопировать(, "Сотрудник, Период"), Ссылка, "Период");
	
	КадровыйУчетРасширенный.СформироватьДвиженияПоТерриториям(Движения, ДанныеДляПроведения.ТерриторияТруда, Организация);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, НачалоПериода, "Объект.НачалоПериода", Отказ, НСтр("ru='Начало периода'"), , , Ложь);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеТерритории", Новый Структура("Организация", Организация)) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='В организации ""%1"" не используются обособленные территории'"),
				Организация),
			Ссылка,
			"Организация",
			"Объект",
			Отказ);
		
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОкончаниеПериода) И ОкончаниеПериода < НачалоПериода Тогда
		
		ТекстСообщения = НСтр("ru='Не верно задано окончание периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ОкончаниеПериода", , Отказ);
		
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= НачалоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения", "НачалоПериода");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, НачалоПериода);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.НачалоПериода КАК Период,
		|	ПеремещениеМеждуТерриториямиСотрудники.Сотрудник,
		|	ПеремещениеМеждуТерриториямиСотрудники.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ПеремещениеМеждуТерриториямиСотрудники.ФизическоеЛицо,
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка.Территория КАК Территория,
		|	ВЫБОР
		|		КОГДА ПеремещениеМеждуТерриториямиСотрудники.Ссылка.ОкончаниеПериода > ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДОБАВИТЬКДАТЕ(ПеремещениеМеждуТерриториямиСотрудники.Ссылка.ОкончаниеПериода, ДЕНЬ, 1)
		|		ИНАЧЕ ПеремещениеМеждуТерриториямиСотрудники.Ссылка.ОкончаниеПериода
		|	КОНЕЦ КАК ДействуетДо
		|ИЗ
		|	Документ.ПеремещениеМеждуТерриториями.Сотрудники КАК ПеремещениеМеждуТерриториямиСотрудники
		|ГДЕ
		|	ПеремещениеМеждуТерриториямиСотрудники.Ссылка = &Ссылка";
		
	Если Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДействуетДо", "ПустойПериодОкончания");
	КонецЕсли;
		
	Данные = Новый Структура("ТерриторияТруда", Запрос.Выполнить().Выгрузить());
	
	Возврат Данные;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрации = Документы.ПеремещениеМеждуТерриториями.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрации[Ссылка];	
КонецФункции	

#КонецОбласти

#КонецЕсли
