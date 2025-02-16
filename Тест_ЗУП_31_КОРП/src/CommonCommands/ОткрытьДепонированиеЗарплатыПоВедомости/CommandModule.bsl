
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Ведомость = ПараметрКоманды;
	Форма = ПараметрыВыполненияКоманды.Источник;
	
	ДепонированиеПоВедомости = ДепонированиеПоВедомости(Ведомость);
	Если ЗначениеЗаполнено(ДепонированиеПоВедомости) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ДепонированиеПоВедомости);
		ОткрытьФорму("Документ.ДепонированиеЗарплаты.ФормаОбъекта", ПараметрыФормы, Форма); 
	Иначе
		ТекстСообщения = НСтр("ru = 'По ведомости нет доступных сведений о депонировании зарплаты'");
		ВызватьИсключение ТекстСообщения
	КонецЕсли	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДепонированиеПоВедомости(Ведомость)
	Возврат Документы.ДепонированиеЗарплаты.НайтиПоВедомости(Ведомость)
КонецФункции	

#КонецОбласти
