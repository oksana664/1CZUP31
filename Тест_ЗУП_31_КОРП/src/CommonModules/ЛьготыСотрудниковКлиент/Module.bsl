
#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуРедактированияСоставаЛьготСотрудников(Параметры, Форма) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.РедактированиеСоставаЛьготСотрудников", Параметры, Форма);
	
КонецПроцедуры

Процедура ОткрытьФормуИндивидуальныйПакетЛьгот(Форма, ФизическоеЛицо) Экспорт 
	
	Параметры = Новый Структура("ФизическоеЛицо", ФизическоеЛицо);
	ОткрытьФорму("ОбщаяФорма.СотрудникиИндивидуальныйПакетЛьгот", Параметры, Форма);
	
КонецПроцедуры

Процедура ОткрытьФормуНовойЗаписиПерерасчетовЛьгот(Форма) Экспорт
	
	Если ЗначениеЗаполнено(Форма.Организация) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Организация", Форма.Организация);
		
		Оповещение = Новый ОписаниеОповещения("ЗарегистрироватьНеобходимостьПерерасчетаЗарплатыЗавершение", Форма);
		
		ОткрытьФорму("ОбщаяФорма.ФормаНовойЗаписиПерерасчетовЛьгот", ПараметрыОткрытия, Форма, , , , Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
