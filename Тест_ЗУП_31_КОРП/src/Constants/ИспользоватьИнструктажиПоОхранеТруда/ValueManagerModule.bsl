#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОхранаТруда.УстановитьПараметрыНабораСвойствВидыИнструктажейПоОхранеТруда();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
