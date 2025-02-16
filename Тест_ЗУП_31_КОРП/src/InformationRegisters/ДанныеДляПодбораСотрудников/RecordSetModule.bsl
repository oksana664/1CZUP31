#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Не Запись.ПоДоговоруГПХ Тогда
			Запись.КоличествоСтавокПредставление = КадровыйУчетРасширенныйКлиентСервер.ПредставлениеКоличестваСтавок(Запись.КоличествоСтавок);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
			МодульОрганизационнаяСтруктура = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
			МодульОрганизационнаяСтруктура.ЗаполнитьМестоВСтруктуреПредприятияДанныхДляПодбораСотрудников(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
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
	ИменаПолей.Организации = Новый Массив;
	ИменаПолей.Организации.Добавить("Организация");
	ИменаПолей.Организации.Добавить("Филиал");
	ИменаПолей.Сотрудники = "Сотрудник";
	ИменаПолей.ДатыПолученияДанных = "Начало";
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	
КонецФункции

#КонецОбласти 

#КонецЕсли
