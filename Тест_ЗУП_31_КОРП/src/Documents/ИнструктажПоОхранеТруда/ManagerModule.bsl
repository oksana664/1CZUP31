#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ИнструктажПоОхранеТруда;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Журнал регистрации вводного инструктажа
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ЖурналРегистрацииИнструктажа";
	КомандаПечати.ФункциональныеОпции = "ИспользоватьИнструктажиПоОхранеТруда";
	КомандаПечати.Идентификатор = "ЖурналРегистрацииВводногоИнструктажа";
	КомандаПечати.Представление = НСтр("ru = 'Журнал регистрации вводного инструктажа'");
	
	// Журнал регистрации инструктажа на рабочем месте
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Отчет.ЖурналРегистрацииИнструктажа";
	КомандаПечати.ФункциональныеОпции = "ИспользоватьИнструктажиПоОхранеТруда";
	КомандаПечати.Идентификатор = "ЖурналРегистрацииИнструктажаНаРабочемМесте";
	КомандаПечати.Представление = НСтр("ru = 'Журнал регистрации инструктажа на рабочем месте'");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли