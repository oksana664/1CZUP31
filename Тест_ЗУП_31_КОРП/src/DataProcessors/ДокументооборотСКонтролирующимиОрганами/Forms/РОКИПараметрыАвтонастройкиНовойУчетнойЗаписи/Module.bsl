&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
		Элементы.Организация.ТолькоПросмотр = Истина;

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОсновныеДействияФормыОК(Команда)
	
	Если ПараметрыВручную Тогда
		СтрИНН = СокрЛП(ИНН);
		СтрКПП = СокрЛП(КПП);
		ДлинаИНН = СтрДлина(СтрИНН);
		ДлинаКПП = СтрДлина(СтрКПП);
		Если ДлинаИНН = 10 Тогда
			Если ДлинаКПП = 0 Тогда
				ПоказатьПредупреждение(, "Для продолжения задайте КПП.");
				Возврат;
			ИначеЕсли ДлинаКПП <> 9 Тогда
				ПоказатьПредупреждение(, "Укажите корректный КПП.");
				Возврат;
			КонецЕсли;
		ИначеЕсли ДлинаИНН = 0 Тогда
			ПоказатьПредупреждение(, "Для продолжения задайте ИНН" + ?(ДлинаКПП = 0, "\КПП", "") + ".");
			Возврат;
		ИначеЕсли ДлинаИНН <> 12 Тогда
			ПоказатьПредупреждение(, "Укажите корректный ИНН.");
			Возврат;
		КонецЕсли;
		Результат = Новый Структура("ИНН, КПП", СокрЛП(ИНН), СокрЛП(КПП));
	Иначе
		Если Организация.Пустая() Тогда
			ПоказатьПредупреждение(, "Для продолжения выберите организацию.");
			Возврат;
		КонецЕсли;

		ЭтоЮридическоеЛицо = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоЮрЛицо(Организация);
	
		// Получаем ИНН и КПП
		СтруктураДанныхОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация);	
		Если ЭтоЮридическоеЛицо Тогда
			Результат = Новый Структура("ИНН, КПП",
											СокрЛП(СтруктураДанныхОрганизации["ИННЮЛ"]),
											СокрЛП(СтруктураДанныхОрганизации["КППЮЛ"]));
		Иначе
			Результат = Новый Структура("ИНН, КПП",
											СокрЛП(СтруктураДанныхОрганизации["ИННФЛ"]), "");
		КонецЕсли;
										
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ПереключательПараметрыВручную = "0";
	ПараметрыВручную = Ложь;
	УправлениеЭУ();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУ()
	
	Элементы.ИНН.Доступность = ПараметрыВручную;
	Элементы.КПП.Доступность = ПараметрыВручную;
	Элементы.Организация.Доступность = НЕ ПараметрыВручную;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательПараметрыВручнуюПриИзменении(Элемент)
	
	ПараметрыВручную = (ПереключательПараметрыВручную = "1");
	УправлениеЭУ();
	
КонецПроцедуры

#КонецОбласти