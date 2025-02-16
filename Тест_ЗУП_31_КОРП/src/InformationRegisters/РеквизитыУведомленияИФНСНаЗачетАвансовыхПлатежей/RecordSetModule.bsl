#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	ИменаПолей.ФизическиеЛица = "ФизическоеЛицо";
	ИменаПолей.ДатыПолученияДанных = "Год";
	
	ОграниченияРегистрации = ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	ОграниченияРегистрации.ДатаПолученияДанных = Дата(ОграниченияРегистрации.ДатаПолученияДанных, 12,31);
	
	Возврат ОграниченияРегистрации
	
КонецФункции

#КонецОбласти 

#КонецЕсли
