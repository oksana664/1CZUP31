
#Область СлужебныеПроцедурыИФункции

#Область НастройкаРасчетаЗарплаты

Процедура УстановитьЗначенияЗависимыхНастроекРасчетаЗарплаты(Форма, ИспользоватьНачислениеЗарплаты) Экспорт

	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("УчетБюджетныхУчрежденийКлиент");
		Модуль.УстановитьЗначенияЗависимыхНастроекРасчетаЗарплаты(Форма, ИспользоватьНачислениеЗарплаты);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
