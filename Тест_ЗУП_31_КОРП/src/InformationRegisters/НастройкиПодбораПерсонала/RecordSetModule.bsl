#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		// ИспользоватьОценкуЭффективностиИсточниковИнформацииОКандидатах имеет смысл только при включении ИспользоватьПодборПерсонала,
		// в противном случае отключаем оценку эффективности.
		Если Запись.ИспользоватьОценкуЭффективностиИсточниковИнформацииОКандидатах И НЕ Запись.ИспользоватьПодборПерсонала Тогда
			Запись.ИспользоватьОценкуЭффективностиИсточниковИнформацииОКандидатах = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	РаботаСРабочимКалендаремБЗК.ПередЗаписьюНастроекПодбораПерсонала(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСРабочимКалендаремБЗК.УстановитьНастройкуИспользоватьРабочийКалендарь(ЭтотОбъект);
	
	ПодборПерсонала.УстановитьПараметрыНабораСвойствСправочников();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли