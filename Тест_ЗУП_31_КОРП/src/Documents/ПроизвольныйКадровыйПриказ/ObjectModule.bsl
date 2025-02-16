#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТабличнуюЧастьФизическиеЛица();
	
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
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, Дата);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТабличнуюЧастьФизическиеЛица() Экспорт
	
	ФизическиеЛица.Очистить();
		
	// Сбор данных сотрудников
	СотрудникиМассив = Новый Массив;
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		СотрудникиМассив.Добавить(Сотрудник);
	Иначе
		УникальныеСотрудники = Новый Соответствие;
		Для Каждого СтрокаТабличнойЧасти Из Сотрудники Цикл
			СотрудникСсылка = СтрокаТабличнойЧасти.Сотрудник;
			Если УникальныеСотрудники[СотрудникСсылка] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СотрудникиМассив.Добавить(СотрудникСсылка);
			УникальныеСотрудники.Вставить(СотрудникСсылка, Истина);
		КонецЦикла;
	КонецЕсли;
		
	Если СотрудникиМассив.Количество() > 0 Тогда
		// Получение физических лиц для собранных сотрудников.
		ФизлицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СотрудникиМассив, "ФизическоеЛицо");
		// Массив физических лиц сотрудников.
		Физлица = ОбщегоНазначения.ВыгрузитьКолонку(ФизлицаСотрудников, "Значение", Истина);
	КонецЕсли;
	
	Если Физлица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Заполняем табличную часть Физические лица.
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(ФизическиеЛица, Физлица, "ФизическоеЛицо");
	
	// Заполнение краткого состава документа.
	КраткийСоставДокумента = ЗарплатаКадры.КраткийСоставСотрудников(СотрудникиМассив, Дата, Физлица, ФизлицаСотрудников);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
