#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда
		СтатусРезидент = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.СтатусыНалогоплательщиковПоНДФЛ.Резидент");
		Для Каждого ЗаписьНабора Из ЭтотОбъект Цикл
			ЗаписьНабора.Статус = СтатусРезидент;
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ФизическоеЛицо = Неопределено;
	Если ЭтотОбъект.Отбор.ФизическоеЛицо.Использование Тогда
		ФизическоеЛицо = ЭтотОбъект.Отбор.ФизическоеЛицо.Значение;
	КонецЕсли;
	
	РегистрыСведений.СтатусФизическихЛицКакНалогоплательщиковНДФЛВторичный.ЗаполнитьВторичныеДанные(ФизическоеЛицо);
	
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
	ИменаПолей.ФизическиеЛица = "ФизическоеЛицо";
	ИменаПолей.ДатыПолученияДанных = "Период";
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	
КонецФункции

#КонецОбласти 

#КонецЕсли