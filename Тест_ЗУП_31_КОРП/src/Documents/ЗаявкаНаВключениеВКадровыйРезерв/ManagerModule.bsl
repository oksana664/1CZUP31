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
	
	МетаданныеДокумента = Метаданные.Документы.ЗаявкаНаВключениеВКадровыйРезерв;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическоеЛицоВШапке(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения(Ссылка)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкаНаВключениеВКадровыйРезерв.ДатаВыдвижения КАК Период,
		|	ЗаявкаНаВключениеВКадровыйРезерв.ПозицияРезерва КАК ПозицияРезерва,
		|	ЗаявкаНаВключениеВКадровыйРезерв.ВидРезерва КАК ВидРезерва,
		|	ЗаявкаНаВключениеВКадровыйРезерв.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияСогласования.Рассматривается) КАК Статус
		|ИЗ
		|	Документ.ЗаявкаНаВключениеВКадровыйРезерв КАК ЗаявкаНаВключениеВКадровыйРезерв
		|ГДЕ
		|	ЗаявкаНаВключениеВКадровыйРезерв.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	ДвиженияИсторииКадровогоРезерва = РезультатЗапроса.Выгрузить();
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("ДвиженияИсторииКадровогоРезерва", ДвиженияИсторииКадровогоРезерва);
	
	Возврат ДанныеДляПроведения;

КонецФункции	

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли