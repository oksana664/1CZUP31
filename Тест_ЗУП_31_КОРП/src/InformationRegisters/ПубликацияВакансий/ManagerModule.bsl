#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьАдресПубликацииЗаписи(ЗаписьОПубликации) Экспорт
	
	ИдентификаторВакансии = ЗаписьОПубликации.ИдентификаторВакансии;
	
	Если ЗаписьОПубликации.МестоПубликации = ИнтеграцияРекрутинговыхСайтовКлиентСервер.HeadHunter() Тогда
		ЗаписьОПубликации.АдресПубликации = ИнтеграцияРекрутинговыхСайтовКлиентСервер.АдресВакансииHeadHunter(ИдентификаторВакансии);
	ИначеЕсли ЗаписьОПубликации.МестоПубликации = ИнтеграцияРекрутинговыхСайтовКлиентСервер.SuperJob() Тогда
		ЗаписьОПубликации.АдресПубликации = ИнтеграцияРекрутинговыхСайтовКлиентСервер.АдресВакансииSuperJob(ИдентификаторВакансии);
	ИначеЕсли ЗаписьОПубликации.МестоПубликации = ИнтеграцияРекрутинговыхСайтовКлиентСервер.Rabota() Тогда
		ЗаписьОПубликации.АдресПубликации = ИнтеграцияРекрутинговыхСайтовКлиентСервер.АдресВакансииRabota(ИдентификаторВакансии)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

