#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	КодДоходаНДФЛ				= Справочники.ВидыДоходовНДФЛ.ПустаяСсылка();
	КодДоходаСтраховыеВзносы	= Справочники.ВидыДоходовПоСтраховымВзносам.ПустаяСсылка();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Обновляем кэш платформы для зачитывания актуальных настроек
	// используется в ОтражениеЗарплатыВУчетеПовтИсп.ТаблицаНачислениеУдержаниеВидОперации.
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли