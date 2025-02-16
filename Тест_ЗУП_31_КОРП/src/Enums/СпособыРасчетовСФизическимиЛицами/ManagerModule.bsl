

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ВзаиморасчетыПоПрочимДоходамВызовСервера.СпособыРасчетовСФизическимиЛицамиОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры
	
#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Формируется массив доступных способов расчетов.
//
Функция ДоступныеСпособыРасчетов() Экспорт
	
	СпособыРасчетов = Новый Массив;
	СпособыРасчетов.Добавить(Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами);
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Дивиденды") Тогда
		СпособыРасчетов.Добавить(Перечисления.СпособыРасчетовСФизическимиЛицами.Дивиденды);
		СпособыРасчетов.Добавить(Перечисления.СпособыРасчетовСФизическимиЛицами.ДивидендыСотрудникам);
	КонецЕсли;
	
	Возврат СпособыРасчетов;
	
КонецФункции

#КонецОбласти

#КонецЕсли