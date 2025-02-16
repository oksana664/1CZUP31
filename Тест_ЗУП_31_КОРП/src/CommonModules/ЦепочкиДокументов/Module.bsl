
#Область СлужебныйПрограммныйИнтерфейс

// Записывает связь документов Основание-Подчиненный в регистр,
// вместе со вторичными данными.
// Вызывается при записи Подчиненного.
// Параметры:
// 	- Форма - форма, содержащая реквизит-ссылку на документ Основание
// 	- Объект - текущий объект.
//
Процедура СформироватьЦепочкиДокументов(Форма, Объект) Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЦепочкиДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	ПодчиненныйДокумент = Объект.Ссылка;
	ДокументОснование = Форма.ЗамещениеДокументОснование;
	
	Если ПодчиненныйДокумент = Неопределено ИЛИ ДокументОснование = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаСотрудник = ОписаниеДокументовЗамещения(ПодчиненныйДокумент).ИмяРеквизитаСотрудник;
	ИмяРеквизитаОтсутствующийСотрудник = ОписаниеДокументовЗамещения(ДокументОснование).ИмяРеквизитаОтсутствующийСотрудник;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, ИмяРеквизитаОтсутствующийСотрудник + ",Организация,ПометкаУдаления");
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ЦепочкиДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Основание = ДокументОснование;
	МенеджерЗаписи.СотрудникОснования = РеквизитыОснования[ИмяРеквизитаОтсутствующийСотрудник];
	МенеджерЗаписи.ПометкаУдаленияОснования = РеквизитыОснования["ПометкаУдаления"];
	МенеджерЗаписи.ОрганизацияОснования = РеквизитыОснования["Организация"];
	
	МенеджерЗаписи.Подчиненный = ПодчиненныйДокумент;
	МенеджерЗаписи.СотрудникПодчиненного = Объект[ИмяРеквизитаСотрудник];
	МенеджерЗаписи.ПометкаУдаленияПодчиненного = Объект["ПометкаУдаления"];
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

// Обновляет вторичные реквизиты документа в регистре.
// Параметры:
// 	- ТекущийОбъект - текущий объект.
//
Процедура УстановитьВторичныеРеквизитыДокументаЗамещения(ТекущийОбъект) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьЦепочкиДокументов") Тогда
		Возврат;
	КонецЕсли;
	
	ДокументСсылка = ТекущийОбъект.Ссылка;
	ПометкаУдаления = ТекущийОбъект.ПометкаУдаления;
	Организация = ТекущийОбъект.Организация;
	ИмяРеквизитаСотрудник = ОписаниеДокументовЗамещения(ДокументСсылка).ИмяРеквизитаСотрудник;
	Сотрудник = ТекущийОбъект[ИмяРеквизитаСотрудник];
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦепочкиДокументов.Основание,
		|	ЦепочкиДокументов.Подчиненный,
		|	&Сотрудник КАК СотрудникОснования,
		|	&Организация КАК ОрганизацияОснования,
		|	&ПометкаУдаления КАК ПометкаУдаленияОснования,
		|	ЦепочкиДокументов.СотрудникПодчиненного,
		|	ЦепочкиДокументов.ПометкаУдаленияПодчиненного
		|ИЗ
		|	РегистрСведений.ЦепочкиДокументов КАК ЦепочкиДокументов
		|ГДЕ
		|	ЦепочкиДокументов.Основание = &Ссылка
		|	И (ЦепочкиДокументов.ПометкаУдаленияОснования <> &ПометкаУдаления
		|			ИЛИ ЦепочкиДокументов.ОрганизацияОснования <> &Организация
		|			ИЛИ ЦепочкиДокументов.СотрудникОснования <> &Сотрудник)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЦепочкиДокументов.Основание,
		|	ЦепочкиДокументов.Подчиненный,
		|	ЦепочкиДокументов.СотрудникОснования,
		|	ЦепочкиДокументов.ОрганизацияОснования,
		|	ЦепочкиДокументов.ПометкаУдаленияОснования,
		|	&Сотрудник,
		|	&ПометкаУдаления
		|ИЗ
		|	РегистрСведений.ЦепочкиДокументов КАК ЦепочкиДокументов
		|ГДЕ
		|	ЦепочкиДокументов.Подчиненный = &Ссылка
		|	И (ЦепочкиДокументов.ПометкаУдаленияПодчиненного <> &ПометкаУдаления
		|			ИЛИ ЦепочкиДокументов.СотрудникПодчиненного <> &Сотрудник)";
	
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи = РегистрыСведений.ЦепочкиДокументов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Записать(Истина);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Возвращает таблицу значений с документами, которые былли введены на основании массива документов основания,
// переданных в качестве параметра.
// 	Параметры
//		* ДокументыОснование - ОпределяемыйТип.ЦепочкиДокументовПодчиненные или Массив
// 	Возвращаемое значение
//	 ТаблицаЗначений со следующиеи колонками:
//		* Основание 						- ОпределяемыйТип.ЦепочкиДокументовОснования
//		* Подчиненный 						- ОпределяемыйТип.ЦепочкиДокументовПодчиненные
//		* СотрудникОснования			- тип СправочникСсылка.Сотрудники
//		* СотрудникОснованияФамилияИО	- тип строка
//		* СотрудникПодчиненного				- тип СправочникСсылка.Сотрудники
//		* СотрудникПодчиненногоФамилияИО		- тип строка.
// 
Функция ПодчиненныеДокументы(Знач ДокументыОснование) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДокументыОснование) Тогда
		Возврат ПустаяТаблицаДокументовЗамещения();
	КонецЕсли;
	
	Если ТипЗнч(ДокументыОснование) <> Тип("Массив") Тогда
		ДокументыОснование = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументыОснование);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЦепочкиДокументов.Основание,
		|	ЦепочкиДокументов.Подчиненный,
		|	ЦепочкиДокументов.СотрудникОснования,
		|	ЦепочкиДокументов.СотрудникПодчиненного
		|ПОМЕСТИТЬ ВТЦепочкиДокументов
		|ИЗ
		|	РегистрСведений.ЦепочкиДокументов КАК ЦепочкиДокументов
		|ГДЕ
		|	ЦепочкиДокументов.Основание В(&ДокументыОснование)
		|	И НЕ ЦепочкиДокументов.ПометкаУдаленияПодчиненного
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТЦепочкиДокументов.СотрудникОснования КАК Сотрудник,
		|	&Период КАК Период
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	ВТЦепочкиДокументов КАК ВТЦепочкиДокументов
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТЦепочкиДокументов.СотрудникПодчиненного,
		|	&Период
		|ИЗ
		|	ВТЦепочкиДокументов КАК ВТЦепочкиДокументов";
	
	Запрос.УстановитьПараметр("ДокументыОснование", ДокументыОснование);
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Описатель = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудники");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(Описатель, Истина, "ФамилияИО");
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТЦепочкиДокументов.Основание,
		|	ВТЦепочкиДокументов.Подчиненный,
		|	ВТЦепочкиДокументов.СотрудникОснования,
		|	ЕСТЬNULL(Сотрудники.ФамилияИО, """") КАК СотрудникОснованияФамилияИО,
		|	ВТЦепочкиДокументов.СотрудникПодчиненного,
		|	ЕСТЬNULL(СотрудникиДругие.ФамилияИО, """") КАК СотрудникПодчиненногоФамилияИО
		|ИЗ
		|	ВТЦепочкиДокументов КАК ВТЦепочкиДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК Сотрудники
		|		ПО ВТЦепочкиДокументов.СотрудникОснования = Сотрудники.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК СотрудникиДругие
		|		ПО ВТЦепочкиДокументов.СотрудникПодчиненного = СотрудникиДругие.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТКадровыеДанныеСотрудников";
		
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

// Возвращает таблицу значений с документами, являющимися основаниями для массива подчиненных документов,
// переданных в качестве параметра.
// 	Параметры
//		* ПодчиненныеДокументы - ОпределяемыйТип.ЦепочкиДокументовПодчиненные или Массив
// 	Возвращаемое значение
//	 ТаблицаЗначений со следующиеи колонками:
//		* Основание 						- ОпределяемыйТип.ЦепочкиДокументовОснования
//		* Подчиненный 						- ОпределяемыйТип.ЦепочкиДокументовПодчиненные
//		* СотрудникОснования			- тип СправочникСсылка.Сотрудники
//		* СотрудникОснованияФамилияИО	- тип строка
//		* СотрудникПодчиненного				- тип СправочникСсылка.Сотрудники
//		* СотрудникПодчиненногоФамилияИО		- тип строка.
// 
Функция ДокументыОснования(Знач ПодчиненныеДокументы) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПодчиненныеДокументы) Тогда
		Возврат ПустаяТаблицаДокументовЗамещения();
	КонецЕсли;
	
	Если ТипЗнч(ПодчиненныеДокументы) <> Тип("Массив") Тогда
		ПодчиненныеДокументы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПодчиненныеДокументы);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЦепочкиДокументов.Основание,
		|	ЦепочкиДокументов.Подчиненный,
		|	ЦепочкиДокументов.СотрудникОснования,
		|	ЦепочкиДокументов.СотрудникПодчиненного
		|ПОМЕСТИТЬ ВТЦепочкиДокументов
		|ИЗ
		|	РегистрСведений.ЦепочкиДокументов КАК ЦепочкиДокументов
		|ГДЕ
		|	ЦепочкиДокументов.Подчиненный В(&ПодчиненныеДокументы)
		|	И НЕ ЦепочкиДокументов.ПометкаУдаленияОснования
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТЦепочкиДокументов.СотрудникОснования КАК Сотрудник,
		|	&Период КАК Период
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	ВТЦепочкиДокументов КАК ВТЦепочкиДокументов
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТЦепочкиДокументов.СотрудникПодчиненного,
		|	&Период
		|ИЗ
		|	ВТЦепочкиДокументов КАК ВТЦепочкиДокументов";
	
	Запрос.УстановитьПараметр("ПодчиненныеДокументы", ПодчиненныеДокументы);
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Описатель = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(Запрос.МенеджерВременныхТаблиц, "ВТСотрудники");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(Описатель, Истина, "ФамилияИО");
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТЦепочкиДокументов.Основание,
		|	ВТЦепочкиДокументов.Подчиненный,
		|	ВТЦепочкиДокументов.СотрудникОснования,
		|	ЕСТЬNULL(Сотрудники.ФамилияИО, """") КАК СотрудникОснованияФамилияИО,
		|	ВТЦепочкиДокументов.СотрудникПодчиненного,
		|	ЕСТЬNULL(СотрудникиДругие.ФамилияИО, """") КАК СотрудникПодчиненногоФамилияИО
		|ИЗ
		|	ВТЦепочкиДокументов КАК ВТЦепочкиДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК Сотрудники
		|		ПО ВТЦепочкиДокументов.СотрудникОснования = Сотрудники.Сотрудник
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК СотрудникиДругие
		|		ПО ВТЦепочкиДокументов.СотрудникПодчиненного = СотрудникиДругие.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТКадровыеДанныеСотрудников";
		
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

// Возвращает документ Основание для Подчиненного документа.
//
Функция ДокументОснование(ДокументСсылка) Экспорт

	Если Не ЭтоПодчиненныйДокумент(ДокументСсылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДокументыОснования = ДокументыОснования(ДокументСсылка);
	Если ДокументыОснования.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат ДокументыОснования[0].Основание;
	КонецЕсли;

КонецФункции

Функция ЭтоПодчиненныйДокумент(ДокументСсылка) Экспорт
	 Возврат Метаданные.ОпределяемыеТипы.ЦепочкиДокументовПодчиненные.Тип.СодержитТип(ТипЗнч(ДокументСсылка));
КонецФункции

Функция ЭтоДокументОснование(ДокументСсылка) Экспорт
	 Возврат Метаданные.ОпределяемыеТипы.ЦепочкиДокументовОснования.Тип.СодержитТип(ТипЗнч(ДокументСсылка));
КонецФункции

#Область ОбработчикиОбновления
	
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Версия = "3.1.3.1";
	Обработчик.Процедура = "ЦепочкиДокументов.УстановитьИспользованиеЦепочекДокументов";
	
КонецПроцедуры

Процедура УстановитьИспользованиеЦепочекДокументов() Экспорт 

	Если Константы.ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы.Получить() = Истина Тогда
		Константы.ИспользоватьЦепочкиДокументов.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

Функция ПустаяТаблицаДокументовЗамещения() 

	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	ТаблицаЗначений.Колонки.Добавить("Основание");
	ТаблицаЗначений.Колонки.Добавить("Подчиненный");
	ТаблицаЗначений.Колонки.Добавить("СотрудникОснования");
	ТаблицаЗначений.Колонки.Добавить("СотрудникОснованияФамилияИО");

	Возврат ТаблицаЗначений;

КонецФункции

Функция ФамилияИОПадеж(СотрудникИО, НомерПадежа) Экспорт

	Возврат СклонениеПредставленийОбъектов.ПросклонятьПредставление(СотрудникИО, НомерПадежа);

КонецФункции

Функция ТаблицаСДокументомОснованием(ДокументОснование = Неопределено) Экспорт 

	ТаблицаЗамещения = ПустаяТаблицаДокументовЗамещения();
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат ТаблицаЗамещения;
	КонецЕсли;
	
	ИмяРеквизитаСотрудник = ОписаниеДокументовЗамещения(ДокументОснование).ИмяРеквизитаОтсутствующийСотрудник;
    Сотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, ИмяРеквизитаСотрудник);
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, Сотрудник, "ФамилияИО", ТекущаяДатаСеанса());
	Если КадровыеДанные.Количество() > 0 Тогда
		СотрудникИО = КадровыеДанные[0].ФамилияИО;
	Иначе	
		СотрудникИО = "";
	КонецЕсли;
	
	СтрокаЗамещения = ТаблицаЗамещения.Добавить();
	СтрокаЗамещения.Основание = ДокументОснование;
	СтрокаЗамещения.СотрудникОснования = Сотрудник;
	СтрокаЗамещения.СотрудникОснованияФамилияИО = СотрудникИО;
	
	Возврат ТаблицаЗамещения;
		
КонецФункции

Функция ОписаниеДокументовЗамещения(ДокументСсылка) Экспорт 

	Возврат Документы[ДокументСсылка.Метаданные().Имя].ОписаниеДокумента();
	
КонецФункции

#КонецОбласти
