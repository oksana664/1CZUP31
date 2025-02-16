
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	ПодсистемаСуществует = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба");
	Если Не ПодсистемаСуществует Тогда
		Если Значение Тогда
			ВызватьИсключение НСтр("ru = 'Нельзя установить значение ИспользоватьГосударственнуюСлужбу'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПодсистемаСуществует Тогда
		ИспользоватьМуниципальнуюСлужбу = Константы.ИспользоватьМуниципальнуюСлужбу.Получить();
		Если Значение И ИспользоватьМуниципальнуюСлужбу Тогда
			ВызватьИсключение НСтр("ru = 'В программе уже ведется расчет денежного содержания Муниципальных служащих, не допускается использовать одновременно расчет денежного содержания Государственных и Муниципальных служащих'");	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Значение И НЕ Константы.ИспользоватьУчетКлассныхЧинов.Получить() Тогда
		Константы.ИспользоватьУчетКлассныхЧинов.Установить(Истина);
	ИначеЕсли Не ЭтотОбъект.Значение И Константы.ИспользоватьУчетКлассныхЧинов.Получить() Тогда
		Константы.ИспользоватьУчетКлассныхЧинов.Установить(Ложь);	
	КонецЕсли;
		
	// Подключаемые Характеристики
	ИсточникиХарактеристик = Новый Массив;
	ИсточникиХарактеристик.Добавить("СтрокиОтчетностиРасходовИЧисленностиРаботниковГосударственныхОрганов");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		
		ИсточникиХарактеристик.Добавить("СвойстваДолжностейГосударственнойСлужбы");
		ИсточникиХарактеристик.Добавить("СвойстваНачисленийГосударственныхСлужащих");
		
		Если Не ЭтотОбъект.Значение Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
			Модуль.СброситьРасчетСохраняемогоДенежногоСодержания();					
		КонецЕсли;	
		
	КонецЕсли; 
			
	ПодключаемыеХарактеристикиЗарплатаКадры.ОбновитьНаборыПодключаемыхХарактеристик(ЭтотОбъект.Значение, ИсточникиХарактеристик);
	
КонецПроцедуры

#КонецЕсли
