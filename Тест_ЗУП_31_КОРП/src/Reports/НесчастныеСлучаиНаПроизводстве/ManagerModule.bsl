#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СведенияОНесчастныхСлучаях");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сводные сведения о несчастных случаях на предприятии.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПричиныНесчастныхСлучаев");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сводные сведения причин несчастных случаев на предприятии.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СведенияОПострадавших");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сводные сведения последствий несчастных случаев на предприятии.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "УщербОтНесчастныхСлучаев");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сводные сведения о сумме материального ущерба в связи с несчастными случаями.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли