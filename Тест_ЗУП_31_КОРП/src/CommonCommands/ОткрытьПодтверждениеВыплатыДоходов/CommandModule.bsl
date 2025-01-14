
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Ведомость = ПараметрКоманды;
	Форма = ПараметрыВыполненияКоманды.Источник;
	
	ПодтверждениеВыплаты = ПодтверждениеВыплатыДоходов(Ведомость);
	Если ЗначениеЗаполнено(ПодтверждениеВыплаты) Тогда
		ПоказатьЗначение(, ПодтверждениеВыплаты);
	Иначе
		ТекстСообщения = НСтр("ru = 'По ведомости нет доступных подтверждений выплаты доходов'");
		ВызватьИсключение ТекстСообщения
	КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодтверждениеВыплатыДоходов(Ведомость)
	
	Возврат РегистрыСведений.ДатыВыплатыДоходов.НайтиПоВедомости(Ведомость);
	
КонецФункции

#КонецОбласти
