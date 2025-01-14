
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	НайтиЗадублированныхФизическихЛиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗадублированныеФизическиеЛица.ПолучитьЭлементы().Количество() = 0 Тогда
		
		Отказ = Истина;
		
		ТекстПредупреждения = НСтр("ru='Не найдены карточки с задвоенными данными'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	Иначе
		
		РазвернутьДерево();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадублированныеФизическиеЛицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыполнитьВыбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыполнитьВыбор();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	НайтиЗадублированныхФизическихЛиц();
	РазвернутьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НайтиЗадублированныхФизическихЛиц()
	
	ЗадублированныеФизическиеЛица.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	
	// Подготовка таблицы отборов
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
		|	&Период КАК Период
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	НЕ ФизическиеЛица.ЭтоГруппа
		|	И НЕ ФизическиеЛица.ПометкаУдаления";
		
	Запрос.Выполнить();
	
	// Получение ИНН и СНИЛС
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТФизическиеЛица");
		
	КадровыеДанные = "ИНН,СтраховойНомерПФР";
		
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Ложь, КадровыеДанные);
	
	// Получение данных о задублированных документах.
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокументыФизическихЛиц.Физлицо) КАК Количество,
		|	ДокументыФизическихЛиц.ВидДокумента,
		|	ДокументыФизическихЛиц.Серия,
		|	ДокументыФизическихЛиц.Номер
		|ПОМЕСТИТЬ ВТДокументыФизическихЛицПредварительно
		|ИЗ
		|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|ГДЕ
		|	ДокументыФизическихЛиц.ВидДокумента <> ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка)
		|	И ДокументыФизическихЛиц.Номер <> """"
		|	И НЕ ДокументыФизическихЛиц.Физлицо.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	ДокументыФизическихЛиц.ВидДокумента,
		|	ДокументыФизическихЛиц.Серия,
		|	ДокументыФизическихЛиц.Номер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДокументыФизическихЛицПредварительно.ВидДокумента КАК ДокументВид,
		|	ДокументыФизическихЛицПредварительно.Серия КАК ДокументСерия,
		|	ДокументыФизическихЛицПредварительно.Номер КАК ДокументНомер,
		|	ДокументыФизическихЛиц.Физлицо КАК ФизическоеЛицо,
		|	ДокументыФизическихЛиц.Представление КАК ДокументПредставление
		|ПОМЕСТИТЬ ВТДокументыФизическихЛиц
		|ИЗ
		|	ВТДокументыФизическихЛицПредварительно КАК ДокументыФизическихЛицПредварительно
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|		ПО ДокументыФизическихЛицПредварительно.ВидДокумента = ДокументыФизическихЛиц.ВидДокумента
		|			И ДокументыФизическихЛицПредварительно.Номер = ДокументыФизическихЛиц.Номер
		|			И ДокументыФизическихЛицПредварительно.Серия = ДокументыФизическихЛиц.Серия
		|			И (ДокументыФизическихЛицПредварительно.Количество > 1)
		|			И (НЕ ДокументыФизическихЛиц.Физлицо.ПометкаУдаления)";
		
	Запрос.Выполнить();
		
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВТКадровыеДанныеФизическихЛиц.Инн КАК ИНН,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТКадровыеДанныеФизическихЛиц.ФизическоеЛицо) КАК Количество
		|ПОМЕСТИТЬ ВТЗадублированныеИНН
		|ИЗ
		|	ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизическихЛиц
		|ГДЕ
		|	ВТКадровыеДанныеФизическихЛиц.Инн <> """"
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТКадровыеДанныеФизическихЛиц.Инн
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТКадровыеДанныеФизическихЛиц.ФизическоеЛицо) КАК Количество,
		|	ВТКадровыеДанныеФизическихЛиц.СтраховойНомерПФР КАК СтраховойНомерПФР
		|ПОМЕСТИТЬ ВТЗадублированныеСНИЛС
		|ИЗ
		|	ВТКадровыеДанныеФизическихЛиц КАК ВТКадровыеДанныеФизическихЛиц
		|ГДЕ
		|	ВТКадровыеДанныеФизическихЛиц.СтраховойНомерПФР <> """"
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТКадровыеДанныеФизическихЛиц.СтраховойНомерПФР
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&ИНН КАК ОбластьПоиска,
		|	ЗадублированныеИНН.ИНН КАК Значение,
		|	КадровыеДанныеФизическихЛиц.ФизическоеЛицо,
		|	ЗадублированныеИНН.ИНН КАК ИНН,
		|	NULL КАК СтраховойНомерПФР,
		|	NULL КАК ДокументВид,
		|	NULL КАК ДокументНомер,
		|	NULL КАК ДокументСерия
		|ИЗ
		|	ВТЗадублированныеИНН КАК ЗадублированныеИНН
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
		|		ПО ЗадублированныеИНН.ИНН = КадровыеДанныеФизическихЛиц.ИНН
		|			И (ЗадублированныеИНН.Количество > 1)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&СНИЛС,
		|	ЗадублированныеСНИЛС.СтраховойНомерПФР,
		|	КадровыеДанныеФизическихЛиц.ФизическоеЛицо,
		|	NULL,
		|	ЗадублированныеСНИЛС.СтраховойНомерПФР,
		|	NULL,
		|	NULL,
		|	NULL
		|ИЗ
		|	ВТЗадублированныеСНИЛС КАК ЗадублированныеСНИЛС
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
		|		ПО ЗадублированныеСНИЛС.СтраховойНомерПФР = КадровыеДанныеФизическихЛиц.СтраховойНомерПФР
		|			И (ЗадублированныеСНИЛС.Количество > 1)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДокументУдостоверяющийЛичность,
		|	ДокументыФизическихЛиц.ДокументПредставление,
		|	КадровыеДанныеФизическихЛиц.ФизическоеЛицо,
		|	NULL,
		|	NULL,
		|	ДокументыФизическихЛиц.ДокументВид,
		|	ДокументыФизическихЛиц.ДокументНомер,
		|	ДокументыФизическихЛиц.ДокументСерия
		|ИЗ
		|	ВТДокументыФизическихЛиц КАК ДокументыФизическихЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
		|		ПО ДокументыФизическихЛиц.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
		|ИТОГИ
		|	МАКСИМУМ(ИНН),
		|	МАКСИМУМ(СтраховойНомерПФР),
		|	МАКСИМУМ(ДокументВид),
		|	МАКСИМУМ(ДокументНомер),
		|	МАКСИМУМ(ДокументСерия)
		|ПО
		|	ОбластьПоиска,
		|	Значение";
		
	Запрос.УстановитьПараметр("ИНН", НСтр("ru='ИНН'"));
	Запрос.УстановитьПараметр("СНИЛС", НСтр("ru='СНИЛС'"));
	Запрос.УстановитьПараметр("ДокументУдостоверяющийЛичность", НСтр("ru='Документ, удостоверяющий личность'"));
	
	ДеревоЗначений = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ЗаполнитьЗадублированныеФизическиеЛица(ЗадублированныеФизическиеЛица.ПолучитьЭлементы(), ДеревоЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗадублированныеФизическиеЛица(КоллекцияСтрокДанныхФормы, СтрокаДанных)
	
	Для каждого СтрокаСтрокиДанных Из СтрокаДанных.Строки Цикл
		
		НоваяСтрокаКоллекции = КоллекцияСтрокДанныхФормы.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрокаКоллекции, СтрокаСтрокиДанных);
		Если СтрокаСтрокиДанных.Значение = Null Тогда
			НоваяСтрокаКоллекции.Представление = СтрокаСтрокиДанных.ОбластьПоиска;
		ИначеЕсли СтрокаСтрокиДанных.ФизическоеЛицо = Null Тогда
			НоваяСтрокаКоллекции.Представление = СтрокаСтрокиДанных.Значение;
		Иначе
			НоваяСтрокаКоллекции.Представление = СтрокаСтрокиДанных.ФизическоеЛицо;
		КонецЕсли;
		
		ЗаполнитьЗадублированныеФизическиеЛица(НоваяСтрокаКоллекции.ПолучитьЭлементы(), СтрокаСтрокиДанных)
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДерево()
	
	Для каждого СтрокаДерева Из ЗадублированныеФизическиеЛица.ПолучитьЭлементы() Цикл
		Элементы.ЗадублированныеФизическиеЛица.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбор()
	
	ТекущиеДанные = Элементы.ЗадублированныеФизическиеЛица.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		ИЛИ ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПолучитьРодителя().ПолучитьРодителя() <> Неопределено Тогда
		ТекущиеДанные = ТекущиеДанные.ПолучитьРодителя();
	КонецЕсли;
	
	ВыбранныеДанные = Новый Массив;
	Для каждого ДанныеВыбора Из ТекущиеДанные.ПолучитьЭлементы() Цикл
		ВыбранныеДанные.Добавить(ДанныеВыбора.ФизическоеЛицо);
	КонецЦикла;
	
	ОповеститьОВыборе(ВыбранныеДанные);
	
КонецПроцедуры

#КонецОбласти
