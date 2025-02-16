
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("КлючВарианта,СформироватьПриОткрытии,Отбор");
	ПараметрыФормы.КлючВарианта = "ДиалогиЧатботов";
	ПараметрыФормы.СформироватьПриОткрытии = Истина;
	
	ПараметрыФормы.Отбор = Новый Структура("Чатбот");
	ПараметрыФормы.Отбор.Чатбот = ПараметрКоманды;
	
	ОткрытьФорму("Отчет.ДиалогиЧатботов.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
