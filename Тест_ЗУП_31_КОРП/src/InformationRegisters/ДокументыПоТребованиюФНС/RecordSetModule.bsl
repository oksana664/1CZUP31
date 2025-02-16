#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		//заполнение КонтрагентПредставление
		Если НЕ ЗначениеЗаполнено(Запись.СканированныйДокумент) Тогда
			
			// заполним представление контрагента по ссылке на контрагента
			КонтрагентПредставление = "";
			
			Если ЗначениеЗаполнено(Запись.Контрагент) Тогда
				КонтрагентПредставление = Строка(Запись.Контрагент);	
			КонецЕсли;
			
			Запись.КонтрагентПредставление = КонтрагентПредставление;
			
		КонецЕсли;
		
		//заполнение ИдентификаторВыбора
		Если НЕ ЗначениеЗаполнено(Запись.ИдентификаторВыбора) Тогда
			Запись.ИдентификаторВыбора = Новый УникальныйИдентификатор;
		КонецЕсли; 
		
		//заполнение Готовность
		Запись.Готовность = ЗначениеЗаполнено(Запись.СканированныйДокумент) ИЛИ Запись.ЕстьЭлектронныйДокумент;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
