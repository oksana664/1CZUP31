#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ЕдиновременноеПособиеЗаСчетФСС;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическоеЛицоВШапке(МетаданныеДокумента);
	
КонецФункции

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "Документ.ЕдиновременноеПособиеЗаСчетФСС";
	НовыеСведения.ПоляРегистрации = "ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "Начислено";
	НовыеСведения.ОбластьДанных   = "Доходы";
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ЕдиновременноеПособиеЗаСчетФСС);
	
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

Функция ДатаНаступленияСтраховогоСлучая(Ссылка) Экспорт 
	
	ДатаНаступленияСтраховогоСлучая = Неопределено;
	
	Если ЗначениеЗаполнено(Ссылка) И ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЕдиновременноеПособиеЗаСчетФСС") Тогда
		ДатаНаступленияСтраховогоСлучая = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ДатаСобытия");
	КонецЕсли;
	
	Возврат ДатаНаступленияСтраховогоСлучая;	
	
КонецФункции

#КонецОбласти

#КонецЕсли