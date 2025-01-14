#Область СлужебныеПроцедурыИФункции

#Область ФормированиеПредставленийЭлементовСправочникаСотрудники

Функция ПредставлениеЭлементаСправочникаСотрудники(ДанныеДляФормированияПредставления) Экспорт
	
	Фамилия = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("Фамилия", Фамилия);
	
	Имя = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("Имя", Имя);
	
	Отчество = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("Отчество", Отчество);
	
	УточнениеНаименованияФизическогоЛица = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("УточнениеНаименованияФизическогоЛица", УточнениеНаименованияФизическогоЛица);
	
	УточнениеНаименованияСотрудника = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("УточнениеНаименованияСотрудника", УточнениеНаименованияСотрудника);
	
	Возврат КадровыйУчетКлиентСервер.ПолноеНаименованиеСотрудника(
		Фамилия, Имя, Отчество, УточнениеНаименованияФизическогоЛица, УточнениеНаименованияСотрудника);
	
КонецФункции

#КонецОбласти

Процедура ОбработкаПолученияДанныхВыбораВидовЗанятости(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если НЕ Параметры.Отбор.Свойство("Ссылка") Тогда
		
		МассивДоступныхСсылок = Новый Массив;
		МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ОсновноеМестоРаботы"));
		МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.Совместительство"));
		МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ВнутреннееСовместительство"));
		
		Параметры.Отбор.Вставить("Ссылка", МассивДоступныхСсылок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
