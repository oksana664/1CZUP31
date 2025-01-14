#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	ЗарплатаКадрыВызовСервера.ПредставленияОснованийУвольненияОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ЗарплатаКадрыВызовСервера.ПредставленияОснованийУвольненияОбработкаПолученияДанныхВыбора(
		"ОснованияЗаключенияСрочныхТрудовыхДоговоров", ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение справочника.
//
Процедура НачальноеЗаполнение(НачальноеЗаполнение = Истина) Экспорт
	
	ИмяСправочника = Метаданные.Справочники.ОснованияЗаключенияСрочныхТрудовыхДоговоров.Имя;
	
	Если НачальноеЗаполнение Тогда
		
		Если КонтрактыДоговорыСотрудников.СправочникЗаполнен(ИмяСправочника) Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ИмяМакета = ИмяМакетаКлассификатора();
	
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей.Вставить("Наименование", "Title");
	СоответствиеПолей.Вставить("ТекстОснования", "Reason");
	
	КлючиПоиска = Новый Структура;
	КлючиПоиска.Вставить("КлючиПоискаСправочника", "Наименование");
	КлючиПоиска.Вставить("КлючиПоискаМакета", "Title");
	
	КонтрактыДоговорыСотрудников.ЗаполнитьСправочникИзМакетаКлассификатора(ИмяСправочника, ИмяМакета, СоответствиеПолей, КлючиПоиска);
	
КонецПроцедуры

// Процедура обновляет наименования статей из классификатора. 
// Поиск элемента производится по реквизиту ТекстОснования.
//
Процедура ОбновитьНаименованияИзКлассификатора() Экспорт 
	
	ИмяСправочника = Метаданные.Справочники.ОснованияЗаключенияСрочныхТрудовыхДоговоров.Имя;
	ИмяМакета = ИмяМакетаКлассификатора();
	ИмяРеквизитаПоиска = "ТекстОснования";
	ИмяПоляЗначенияПоиска = "Reason";
	
	ОбновляемыеПоля = Новый Соответствие;
	ОбновляемыеПоля.Вставить("Наименование", "Title");
	
	КонтрактыДоговорыСотрудников.ОбновитьПоляСправочникаИзМакетаКлассификатора(ИмяСправочника, ИмяМакета, ИмяРеквизитаПоиска, ИмяПоляЗначенияПоиска, ОбновляемыеПоля);
	
КонецПроцедуры

Процедура ОбновитьСИзменениями20161003() Экспорт
	
	ОбновитьНаименованияИзКлассификатора();
	НачальноеЗаполнение(Ложь);
	
КонецПроцедуры

Процедура ИсправитьНаименованиеП9Ч1Ст59ИУдалитьЗадвоенныеЭлементы() Экспорт
	
	Оригинал = Справочники.ОснованияЗаключенияСрочныхТрудовыхДоговоров.НайтиПоНаименованию("п. 9 ч. 1 ст. 59");
	Если ЗначениеЗаполнено(Оригинал) Тогда
		
		ОбъектОригинала = Оригинал.ПолучитьОбъект();
		
		КлассификаторСправочника = ОбщегоНазначения.ПрочитатьXMLВТаблицу(
			Справочники.ОснованияЗаключенияСрочныхТрудовыхДоговоров.ПолучитьМакет("ОснованияЗаключенияСрочныхТрудовыхДоговоров").ПолучитьТекст()).Данные;
		
		СтрокаОригинала = КлассификаторСправочника.Найти(ОбъектОригинала.Наименование, "Title");
		Если СтрокаОригинала <> Неопределено
			И ОбъектОригинала.ТекстОснования <> СтрокаОригинала.Reason Тогда
			
			ОбъектОригинала.ТекстОснования = СтрокаОригинала.Reason;
			ОбъектОригинала.ОбменДанными.Загрузка = Истина;
			ОбъектОригинала.Записать();
			
		КонецЕсли;
		
		Двойник = Справочники.ОснованияЗаключенияСрочныхТрудовыхДоговоров.НайтиПоНаименованию("Ст. 59 ч. 1 п. 9");
		Если ЗначениеЗаполнено(Двойник) Тогда
		
			ПарыЗамен = Новый Соответствие;
			ПарыЗамен.Вставить(Двойник, Оригинал);
			
			ПараметрыЗамены = Новый Структура;
			ПараметрыЗамены.Вставить("СпособУдаления", "Пометка");
			ПараметрыЗамены.Вставить("ВключатьБизнесЛогику", Ложь);
			ПараметрыЗамены.Вставить("ЗаменаПарыВТранзакции", Ложь);
			ПараметрыЗамены.Вставить("ПривилегированнаяЗапись", Истина);
			
			ТаблицаРезультата = ОбщегоНазначения.ЗаменитьСсылки(ПарыЗамен, ПараметрыЗамены);
			Для каждого СтрокаРезультата Из ТаблицаРезультата Цикл
				
				Если СтрокаРезультата.ТипОшибки = "ОшибкаЗаписи" Тогда
					
					ОбъектОшибки = СтрокаРезультата.ОбъектОшибки;
					ОбъектОшибки.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
					Попытка
						ОбъектОшибки.Записать();
					Исключение
						
						ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
							УровеньЖурналаРегистрации.Предупреждение,
							ОбъектОшибки.Метаданные(),
							ОбъектОшибки.Ссылка,
							НСтр("ru='Не удалось заменить задвоенное основание заключения трудового договора'"));
						
					КонецПопытки;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяМакетаКлассификатора()
	Возврат "ОснованияЗаключенияСрочныхТрудовыхДоговоров";
КонецФункции

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
// Используется для сопоставления элементов механизмом «Выгрузка/загрузка областей данных».
//
// Возвращаемое значение: Массив(Строка) - массив имен реквизитов, образующих
//  естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Наименование");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли