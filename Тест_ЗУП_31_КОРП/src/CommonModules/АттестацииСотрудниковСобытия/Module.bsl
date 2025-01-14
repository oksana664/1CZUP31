
#Область СлужебныйПрограммныйИнтерфейс

Процедура СоздатьВидыАттестацииСотрудниковПриЗаписи(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.Значение Тогда
		АттестацииСотрудников.СоздатьВидыАттестацииСотрудников();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтключитьКадровыйУчетАттестацииСотрудников(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.Значение Тогда
		
		ИспользоватьАттестацииСотрудников = Константы.ИспользоватьАттестацииСотрудников.СоздатьМенеджерЗначения();
		ИспользоватьАттестацииСотрудников.Значение = Ложь;
		ИспользоватьАттестацииСотрудников.ОбменДанными.Загрузка = Истина;
		ИспользоватьАттестацииСотрудников.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти