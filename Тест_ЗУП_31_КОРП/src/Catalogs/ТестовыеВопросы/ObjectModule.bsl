#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипВопроса = Перечисления.ТипыТестовыхВопросов.ОдинИзМногих
		ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.МногиеИзМногих
		ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.Таблица
		ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.Последовательность
		ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.Соответствие
		ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.ПоШаблону Тогда
		
		
		
	КонецЕсли;
		
		
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДополнительныеСвойства.Вставить("ОбъектКопирования", ОбъектКопирования);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;		
	
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоГруппа Тогда
		
		// МетодРасчетаРезультата
		
		Если ТипВопроса = Перечисления.ТипыТестовыхВопросов.ЭлементActiveX
			ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.Открытый
			ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.РаботаВПрограмме Тогда
			
			МетодРасчетаРезультата = Перечисления.МетодыРасчетаРезультатаТестовогоВопроса.ПустаяСсылка();
			
		КонецЕсли;
		
		Если ТипВопроса = Перечисления.ТипыТестовыхВопросов.ОдинИзМногих
			ИЛИ ТипВопроса = Перечисления.ТипыТестовыхВопросов.ПоШаблону Тогда
			
			МетодРасчетаРезультата = Перечисления.МетодыРасчетаРезультатаТестовогоВопроса.ТочноеСовпадение;
			
		КонецЕсли;
		
		// РазрешенРазвернутыйОтвет
		
		Если ТипВопроса = Перечисления.ТипыТестовыхВопросов.Открытый Тогда
			РазрешенРазвернутыйОтвет = Истина;
		КонецЕсли;
		
		Если ТипВопроса = Перечисления.ТипыТестовыхВопросов.ЭлементActiveX Тогда
			РазрешенРазвернутыйОтвет = Ложь;
		КонецЕсли;
		
		// Устанавливаем реквизит "ФасетныйВопрос".
		
		Если ТипВопроса <> Перечисления.ТипыТестовыхВопросов.ОдинИзМногих
			И ТипВопроса <> Перечисления.ТипыТестовыхВопросов.МногиеИзМногих
			И ТипВопроса <> Перечисления.ТипыТестовыхВопросов.ПоШаблону Тогда
			ФасетныйВопрос = Ложь;
		КонецЕсли;
		
		// ПоследовательныйВыводВариантов
		
		Если ТипВопроса <> Перечисления.ТипыТестовыхВопросов.Таблица
			И ТипВопроса <> Перечисления.ТипыТестовыхВопросов.Соответствие Тогда
			ПоследовательныйВыводВариантов = Ложь;
		КонецЕсли;
		
		// Очищаем значения параметров, заполняемых программой
		
		Для каждого СтрокаТЧ Из Параметры Цикл
			
			Если СтрокаТЧ.ЗаполняетсяПрограммой Тогда
				СтрокаТЧ.Значение = Неопределено;
			КонецЕсли;
			
		КонецЦикла;		
		
	КонецЕсли;
	
	РазработкаЭлектронныхКурсовСлужебный.ПроверитьВозможностьЗаписиЭлементаПередЗаписью(ЭтотОбъект, Отказ);
	РазработкаЭлектронныхКурсовСлужебный.УстановитьДатуИзмененияПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда	
		Возврат;
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#КонецЕсли


