#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	ПодсистемаСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы");
	Если Не ПодсистемаСуществует Тогда
		Если ЭтотОбъект.Количество() > 0
			И (ЭтотОбъект[0].ИспользоватьСменыРаботы 
			Или ЭтотОбъект[0].ИспользоватьРежимыРаботы) Тогда
			
			ВызватьИсключение НСтр("ru = 'Нельзя установить значения настроек ИспользоватьСменыРаботы и ИспользоватьРежимыРаботы'");
		КонецЕсли;
	КонецЕсли;

	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() > 0
		И ЭтотОбъект[0].ИспользоватьСменыРаботы Тогда
		
		ЭтотОбъект[0].ИспользоватьРежимыРаботы = Истина;
	КонецЕсли;	
	
	ПредыдущиеЗначенияНастроекУчетаВремени = УчетРабочегоВремениРасширенный.НастройкиУчетаВремени();
	
	ДополнительныеСвойства.Вставить("ПредыдущиеЗначенияНастроекУчетаВремени", ПредыдущиеЗначенияНастроекУчетаВремени);
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияНастроекУчетаВремени = УчетРабочегоВремениРасширенный.НастройкиУчетаВремени();
	ПредыдущиеЗначенияНастроекУчетаВремени = Неопределено;
	ДополнительныеСвойства.Свойство("ПредыдущиеЗначенияНастроекУчетаВремени", ПредыдущиеЗначенияНастроекУчетаВремени);
		
	Если ЗначенияНастроекУчетаВремени.ИспользоватьСменыРаботы Тогда
		Если ПредыдущиеЗначенияНастроекУчетаВремени = Неопределено 
			Или Не ПредыдущиеЗначенияНастроекУчетаВремени.ИспользоватьСменыРаботы Тогда
			
			Справочники.ПоказателиРасчетаЗарплаты.СоздатьПоказательОтработаноСмен();
		КонецЕсли;	
	Иначе	
		Если ПредыдущиеЗначенияНастроекУчетаВремени <> Неопределено
			И ПредыдущиеЗначенияНастроекУчетаВремени.ИспользоватьСменыРаботы Тогда
			
			Справочники.ПоказателиРасчетаЗарплаты.ОтключитьИспользованиеПоказателяОтработаноСмен();
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли