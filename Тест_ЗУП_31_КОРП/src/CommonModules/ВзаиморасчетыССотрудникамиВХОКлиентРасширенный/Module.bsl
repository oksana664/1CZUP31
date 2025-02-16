////////////////////////////////////////////////////////////////////////////////
// Подсистема "Взаиморасчеты с сотрудниками ВХО".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	ОграничениеИспользованияДокументовКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

Процедура ПослеОтправкиВБанк(Форма) Экспорт
	ОграничениеИспользованияДокументовКлиент.ПодключитьОбработчикОжиданияОкончанияКомандыЗакрытия(Форма, "Подключаемый_ПослеОтправкиВБанк");
КонецПроцедуры

Процедура ОбработчикОжиданияПослеОтправкиВБанк(Форма) Экспорт
	
	Если ОграничениеИспользованияДокументовВызовСервера.ДокументОграничен(Форма.Объект.Ссылка) Тогда
		ОграничениеИспользованияДокументовКлиентСервер.УстановитьДоступностьДанныхФормы(Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
