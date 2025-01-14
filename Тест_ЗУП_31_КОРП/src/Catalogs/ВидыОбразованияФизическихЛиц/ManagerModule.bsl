#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗарплатаКадрыВызовСервера.ПодготовитьДанныеВыбораКлассификаторовСПорядкомКодов(ДанныеВыбора, Параметры, СтандартнаяОбработка, "Справочник.ВидыОбразованияФизическихЛиц");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение классификатора.
Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьВидыОбразований();
	
КонецПроцедуры
	
Процедура ЗаполнитьВидыОбразований() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыОбразованияФизическихЛиц.Ссылка,
		|	ВидыОбразованияФизическихЛиц.ИмяПредопределенныхДанных,
		|	ВидыОбразованияФизическихЛиц.Код,
		|	ВидыОбразованияФизическихЛиц.ФасетОКИН,
		|	ВидыОбразованияФизическихЛиц.Наименование
		|ИЗ
		|	Справочник.ВидыОбразованияФизическихЛиц КАК ВидыОбразованияФизическихЛиц";
		
	ТаблицаСуществующихВидов = Запрос.Выполнить().Выгрузить();
	
	ТекстовыйДокумент = Справочники.ВидыОбразованияФизическихЛиц.ПолучитьМакет("КлассификаторВидовОбразования");
	ТаблицаКлассификатора = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Для каждого СтрокаКлассификатора Из ТаблицаКлассификатора Цикл
		
		ИмяПредопределенныхДанных = СтрокаКлассификатора.Name;
		Код = СтрокаКлассификатора.Code;
		ФасетОКИН = Число(СтрокаКлассификатора.FasetOKIN);
		Наименование = СтрокаКлассификатора.FullName;
		
		Если ЗначениеЗаполнено(ИмяПредопределенныхДанных) Тогда
			
			СсылкаНаЭлемент = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц." + ИмяПредопределенныхДанных);
			Если СсылкаНаЭлемент = Неопределено Тогда
				СправочникОбъект = Справочники.ВидыОбразованияФизическихЛиц.СоздатьЭлемент();
				СправочникОбъект.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
			Иначе
				СправочникОбъект = СсылкаНаЭлемент.ПолучитьОбъект();
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(Код) Тогда
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Код", Код);
			СтруктураПоиска.Вставить("ФасетОКИН", ФасетОКИН);
			
			НайденныеСтроки = ТаблицаСуществующихВидов.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				СправочникОбъект = НайденныеСтроки[0].Ссылка.ПолучитьОбъект();
			Иначе
				СправочникОбъект = Справочники.ВидыОбразованияФизическихЛиц.СоздатьЭлемент();
			КонецЕсли;
			
		Иначе
			
			СтрокаКлассификатора = ТаблицаСуществующихВидов.Найти(Наименование, "Наименование");
			Если СтрокаКлассификатора = Неопределено Тогда
				СправочникОбъект = Справочники.ВидыОбразованияФизическихЛиц.СоздатьЭлемент();
			Иначе
				СправочникОбъект = СтрокаКлассификатора.Ссылка.ПолучитьОбъект();
			КонецЕсли;
			
		КонецЕсли; 
		
		Если СправочникОбъект.Код <> Код
			Или СправочникОбъект.ФасетОКИН <> ФасетОКИН 
			Или СправочникОбъект.Наименование <> Наименование Тогда
			
			СправочникОбъект.Код = Код;
			СправочникОбъект.ФасетОКИН = ФасетОКИН;
			СправочникОбъект.Наименование = Наименование;
			
			СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаменитьВидыОбразованияПредопределенными() Экспорт
	
	НачальноеЗаполнение();
	
	ВидыОбразования = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыОбразованияФизическихЛиц.Ссылка,
		|	ВидыОбразованияФизическихЛицПредопределенные.Ссылка КАК СсылкаПредопределенного,
		|	ВидыОбразованияФизическихЛиц.ПометкаУдаления
		|ИЗ
		|	Справочник.ВидыОбразованияФизическихЛиц КАК ВидыОбразованияФизическихЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыОбразованияФизическихЛиц КАК ВидыОбразованияФизическихЛицПредопределенные
		|		ПО ВидыОбразованияФизическихЛиц.Код = ВидыОбразованияФизическихЛицПредопределенные.Код
		|			И (ВидыОбразованияФизическихЛицПредопределенные.Предопределенный)
		|ГДЕ
		|	(ВидыОбразованияФизическихЛиц.Код = ""03""
		|			ИЛИ ВидыОбразованияФизическихЛиц.Код = ""15"")
		|	И НЕ ВидыОбразованияФизическихЛиц.Предопределенный";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если НЕ Выборка.ПометкаУдаления Тогда
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СправочникОбъект.ПометкаУдаления = Истина;
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			СправочникОбъект.Записать();
			
		КонецЕсли; 
		
		ВидыОбразования.Добавить(Выборка.Ссылка);
		
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОбразованиеФЛ.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	РегистрСведений.УдалитьОбразованиеФизическихЛиц КАК ОбразованиеФЛ
		|ГДЕ
		|	ОбразованиеФЛ.ВидОбразования В(&ВидыОбразования)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТФизическиеЛица.ФизическоеЛицо
		|ИЗ
		|	ВТФизическиеЛица КАК ВТФизическиеЛица";
		
	Запрос.УстановитьПараметр("ВидыОбразования", ВидыОбразования);
		
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ОбразованиеФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ВЫБОР
			|		КОГДА НЕ ОбразованиеФЛ.ВидОбразования.Предопределенный
			|				И ОбразованиеФЛ.ВидОбразования.Код = ""03""
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизическихЛиц.ОсновноеОбщееОбразование)
			|		КОГДА НЕ ОбразованиеФЛ.ВидОбразования.Предопределенный
			|				И ОбразованиеФЛ.ВидОбразования.Код = ""15""
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизическихЛиц.НеполноеВысшееОбразование)
			|		ИНАЧЕ ОбразованиеФЛ.ВидОбразования
			|	КОНЕЦ КАК ВидОбразования,
			|	ОбразованиеФЛ.*
			|ИЗ
			|	ВТФизическиеЛица КАК ВТФизическиеЛица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьОбразованиеФизическихЛиц КАК ОбразованиеФЛ
			|		ПО ВТФизическиеЛица.ФизическоеЛицо = ОбразованиеФЛ.ФизическоеЛицо
			|ИТОГИ ПО
			|	ФизическоеЛицо";
			
		ВыборкаПоФизическимЛицам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоФизическимЛицам.Следующий() Цикл
			
			Набор = РегистрыСведений.УдалитьОбразованиеФизическихЛиц.СоздатьНаборЗаписей();
			Набор.Отбор.ФизическоеЛицо.Установить(ВыборкаПоФизическимЛицам.ФизическоеЛицо);
			
			ВыборкаПоЗаписям = ВыборкаПоФизическимЛицам.Выбрать();
			Пока ВыборкаПоЗаписям.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(Набор.Добавить(), ВыборкаПоЗаписям);
			КонецЦикла;
			
			Набор.ОбменДанными.Загрузка = Истина;
			Набор.Записать();
			
		КонецЦикла; 
		
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЛистокСообщенияДляВоенкомата.Ссылка,
		|	ВЫБОР
		|		КОГДА ЛистокСообщенияДляВоенкомата.Образование.Код = ""03""
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизическихЛиц.ОсновноеОбщееОбразование)
		|		КОГДА ЛистокСообщенияДляВоенкомата.Образование.Код = ""15""
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыОбразованияФизическихЛиц.НеполноеВысшееОбразование)
		|		ИНАЧЕ ЛистокСообщенияДляВоенкомата.Образование
		|	КОНЕЦ КАК Образование
		|ИЗ
		|	Документ.ЛистокСообщенияДляВоенкомата КАК ЛистокСообщенияДляВоенкомата
		|ГДЕ
		|	ЛистокСообщенияДляВоенкомата.Образование В(&ВидыОбразования)";
	Запрос.УстановитьПараметр("ВидыОбразования", ВидыОбразования);
		
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.Образование = Выборка.Образование;
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			ДокументОбъект.Записать();
		
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьДублиВидовДополнительногоОбразования() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыОбразованияФизическихЛиц.Ссылка,
	|	ВидыОбразованияФизическихЛицПредопределенные.Ссылка КАК СсылкаПредопределенного,
	|	ВидыОбразованияФизическихЛицПредопределенные.ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.ВидыОбразованияФизическихЛиц КАК ВидыОбразованияФизическихЛиц
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыОбразованияФизическихЛиц КАК ВидыОбразованияФизическихЛицПредопределенные
	|		ПО ВидыОбразованияФизическихЛиц.Код = ВидыОбразованияФизическихЛицПредопределенные.Код
	|			И ВидыОбразованияФизическихЛиц.ФасетОКИН = ВидыОбразованияФизическихЛицПредопределенные.ФасетОКИН
	|			И (ВидыОбразованияФизическихЛицПредопределенные.Предопределенный)
	|ГДЕ
	|	(ВидыОбразованияФизическихЛиц.Код = ""12""
	|			ИЛИ ВидыОбразованияФизическихЛиц.Код = ""10"")
	|	И ВидыОбразованияФизическихЛиц.ФасетОКИН = 30
	|	И НЕ ВидыОбразованияФизическихЛиц.Предопределенный";
	
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	НайденныеСсылки = НайтиПоСсылкам(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка"));

	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если НайденныеСсылки.Найти(Выборка.Ссылка, "Ссылка") = Неопределено Тогда
			
			ОбновлениеИнформационнойБазы.УдалитьДанные(СправочникОбъект);
			
		Иначе
			
			ПредопределенныйОбъект = Выборка.СсылкаПредопределенного.ПолучитьОбъект();
			ОбновлениеИнформационнойБазы.УдалитьДанные(ПредопределенныйОбъект);
			
			СправочникОбъект.ИмяПредопределенныхДанных = Выборка.ИмяПредопределенныхДанных;
			СправочникОбъект.ПометкаУдаления = Ложь;
			СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
			
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
	
	Результат.Добавить("Код");
	Результат.Добавить("ФасетОКИН");
	Результат.Добавить("ИмяПредопределенныхДанных");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли