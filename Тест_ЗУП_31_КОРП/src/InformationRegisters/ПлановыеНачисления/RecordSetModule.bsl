#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
    Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
        Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПередЗаписью(ЭтотОбъект);
	
	КадровыйУчет.ПлановыеНачисленияПередЗаписью(ЭтотОбъект, Отказ);
	
	Если Не (ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") 
		И ДополнительныеСвойства.ЭтоВторичныйНабор) Тогда
		
		Если ДополнительныеСвойства.Свойство("МенеджерВременныхТаблицПередЗаписью") Тогда
			МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблицПередЗаписью;
		Иначе
			МенеджерВременныхТаблиц	= Новый МенеджерВременныхТаблиц;
			ДополнительныеСвойства.Вставить("МенеджерВременныхТаблицПередЗаписью", МенеджерВременныхТаблиц);
		КонецЕсли;
		ЗарплатаКадрыПериодическиеРегистры.СоздатьВТСтарыйНаборЗаписей(ЭтотОбъект, МенеджерВременныхТаблиц);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
    Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
        Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПриЗаписи(ЭтотОбъект);
	
	Если Не (ДополнительныеСвойства.Свойство("ЭтоВторичныйНабор") 
		И ДополнительныеСвойства.ЭтоВторичныйНабор) Тогда
		
		МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблицПередЗаписью;
		ПараметрыРесурсов = ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов("ПлановыеНачисления");
		
		ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
		ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
		ПараметрыПостроения.ИзмеренияРасчета = РасчетЗарплаты.ИзмеренияРасчетаПлановыхНачислений();
		ПараметрыПостроения.ПараметрыРесурсов = ПараметрыРесурсов;
		
		ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистраПоИзменениям(
			"ПлановыеНачисления", 
			ЭтотОбъект, 
			МенеджерВременныхТаблиц, 
			ПараметрыПостроения);
				
	КонецЕсли;
	
	КадровыйУчет.ПлановыеНачисленияПриЗаписи(ЭтотОбъект, Отказ);	
	ОтражениеЗарплатыВБухучетеРасширенный.ПлановыеНачисленияПриЗаписи(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
