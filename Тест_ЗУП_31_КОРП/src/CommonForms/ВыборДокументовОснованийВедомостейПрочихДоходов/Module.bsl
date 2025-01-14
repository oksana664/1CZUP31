
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Параметры.СпособВыплаты) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
		
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "СпособВыплаты, Организация, ВыбранныеДокументы, ДатаОстатков, ИсключаемыйРегистратор");
	
	УстановитьЗаголовки();
	
	ЗаполнитьСписокДокументов();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьДокумент(Элемент.ТекущиеДанные.Значение)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыполнить(Команда)
	
	ВыбранныеДокументы = Новый СписокЗначений;
	Для Каждого ЭлементСпискаДокументов Из СписокДокументов Цикл
		Если ЭлементСпискаДокументов.Пометка Тогда
			ВыбранныеДокументы.Добавить(ЭлементСпискаДокументов.Значение);
		КонецЕсли	
	КонецЦикла;	
	
	Оповестить("ВыборДокументовОснованийВедомостейПрочихДоходов", ВыбранныеДокументы, ЭтаФорма);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьВыполнить(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыполнить(Команда)
	ТекущиеДанные = Элементы.СписокДокументов.ТекущиеДанные;
	Если Элементы.СписокДокументов.ТекущиеДанные <> Неопределено Тогда
		ОткрытьДокумент(ТекущиеДанные.Значение)
	КонецЕсли	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить(Команда)
	ЗаполнитьСписокДокументов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовки()
	
	Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 для выплаты по ведомости'"),
			СпособВыплаты);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДокументов()
	
	ШаблонПредставления = НСтр("ru = '%1 от %2 - %3'");
	
	СписокДокументов.Очистить();
	
	СпособРасчетов = ВзаиморасчетыПоПрочимДоходам.СоответствиеСпособВыплатыСпособРасчетов()[СпособВыплаты];
	ИмяВидаДокументаОснования = ВзаиморасчетыПоПрочимДоходам.ИменаВидовДокументовВзаиморасчетыСКонтрагентамиАкционерами()[СпособВыплаты];
	ИмяТаблицыДокументов = Метаданные.Документы.Найти(ИмяВидаДокументаОснования).ПолноеИмя();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);  
	Запрос.УстановитьПараметр("ДатаОстатков", ДатаОстатков);
	Запрос.УстановитьПараметр("СпособРасчетов", СпособРасчетов); 
	Запрос.УстановитьПараметр("ИсключаемыйРегистратор", ИсключаемыйРегистратор);
	
	ТекстЗапросаОстатки = ВзаиморасчетыПоПрочимДоходам.ТекстЗапросаОстаткиВзаиморасчетовСКонтрагентамиАкционерами();
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки,"И Взаиморасчеты.ФизическоеЛицо В(&ФизическиеЛица)","");
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки,"И ФизическоеЛицо В (&ФизическиеЛица)","");
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки,"И ДокументОснование В (&Основания)","И ДокументОснование ССЫЛКА Документ." + ИмяВидаДокументаОснования);
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки,"И Взаиморасчеты.ДокументОснование В(&Основания)","И Взаиморасчеты.ДокументОснование ССЫЛКА Документ." + ИмяВидаДокументаОснования);
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки,"И Остатки.СтатьяФинансирования = &СтатьяФинансирования", "");
	ТекстЗапросаОстатки = СтрЗаменить(ТекстЗапросаОстатки,"И Остатки.СтатьяРасходов = &СтатьяРасходов", "");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Остатки.ДокументОснование КАК ДокументОснование,
	|	ТаблицаДокументов.КраткийСоставДокумента КАК КраткийСоставДокумента,
	|	ТаблицаДокументов.Номер КАК Номер,
	|	ТаблицаДокументов.Дата КАК Дата
	|ИЗ
	|	#ТаблицаДокументов КАК ТаблицаДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ #ТаблицаОстатков КАК Остатки
	|		ПО ТаблицаДокументов.Ссылка = Остатки.ДокументОснование";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ТаблицаДокументов", ИмяТаблицыДокументов);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ТаблицаОстатков", "(" + ТекстЗапросаОстатки +")");
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Представление = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПредставления, 
			Выборка.Номер, 
			Формат(Выборка.Дата, "ДЛФ=Д"),
			Выборка.КраткийСоставДокумента);
		
		ЭлементСпискаДокументов = СписокДокументов.Добавить(Выборка.ДокументОснование, Представление);
		ЭлементСпискаДокументов.Пометка = ВыбранныеДокументы.НайтиПоЗначению(Выборка.ДокументОснование) <> Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьДокумент(Ссылка)
	ПоказатьЗначение(, Ссылка);
КонецПроцедуры

#КонецОбласти
