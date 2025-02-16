#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	СтруктураЗаписи = Новый Структура("ГоловнаяОрганизация");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
				
		Если ЗначениеЗаполнено(Запись.ГоловнаяОрганизация) И ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Запись.ГоловнаяОрганизация) <> Запись.ГоловнаяОрганизация Тогда
			Отказ = Истина;
			ТекстОшибки = НСтр("ru = 'Учетная политика по НДФЛ определяется только для головных организаций.'");
			КлючЗаписи = РегистрыСведений.ДокументыФизическихЛиц.СоздатьКлючЗаписи(СтруктураЗаписи);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, КлючЗаписи, "Запись.ГоловнаяОрганизация");
		КонецЕсли;
		
	КонецЦикла;
	
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
	
	ИменаПолей = ОбменДаннымиЗарплатаКадры.ИменаПолейОграниченияРегистрацииРегистраСведений();
	ИменаПолей.Организации = "ГоловнаяОрганизация";
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	
КонецФункции

#КонецОбласти 

#КонецЕсли