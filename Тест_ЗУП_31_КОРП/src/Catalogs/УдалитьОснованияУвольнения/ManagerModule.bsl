#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение статей ТК - оснований увольнения.
Процедура НачальноеЗаполнение() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ИСТИНА КАК ЗначениеИстина
	               |ИЗ
	               |	Справочник.ОснованияУвольнения КАК ОснованияУвольнения
	               |ГДЕ
	               |	ОснованияУвольнения.Предопределенный = ЛОЖЬ";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;	
	
	КлассификаторXML = Справочники.ОснованияУвольнения.ПолучитьМакет("ОснованияУвольненияПоТКРФ").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		Если ЗначениеЗаполнено(СтрокаКлассификатора.ID) Тогда 
			СправочникСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ОснованияУвольнения." + СтрокаКлассификатора.ID);
			Если СправочникСсылка <> Неопределено Тогда
				СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
				СправочникОбъект.Наименование = СтрокаКлассификатора.Title;
				СправочникОбъект.ТекстОснования = СтрокаКлассификатора.Reason;
				СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
				СправочникОбъект.Записать();
			КонецЕсли;
		Иначе
			СправочникСсылка = Справочники.ОснованияУвольнения.НайтиПоНаименованию(СтрокаКлассификатора.Title);
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				СправочникОбъект = Справочники.ОснованияУвольнения.СоздатьЭлемент();
				СправочникОбъект.Наименование = СтрокаКлассификатора.Title;
				СправочникОбъект.ТекстОснования = СтрокаКлассификатора.Reason;
				СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
				СправочникОбъект.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

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