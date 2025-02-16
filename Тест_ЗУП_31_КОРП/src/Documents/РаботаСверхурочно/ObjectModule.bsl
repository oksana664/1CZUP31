#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Если ВремяУчтено И ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда 
		РегистрируемыеДанныеОВремени = ДанныеОВремени();
		УчетРабочегоВремени.ПроверитьРегистрируемыеДанныхОВремени(Ссылка, РегистрируемыеДанныеОВремени, Отказ, Истина, ПериодРегистрации);
		УчетРабочегоВремени.ЗарегистрироватьРабочееВремяСотрудников(Движения, РегистрируемыеДанныеОВремени, ПериодРегистрации);
		// Отгулы
		УчетРабочегоВремениРасширенный.ЗарегистрироватьДниЧасыОтгуловСотрудников(Движения, ДанныеОбОтгулах());
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПроверки = УчетРабочегоВремениРасширенный.ПараметрыДляПроверкиЗаполненияСверхурочныхДокументов();
	ПараметрыПроверки.ДанныеОРаботе = ДанныеОРаботе();
	ПараметрыПроверки.ВремяУчтено = ВремяУчтено;
	ПараметрыПроверки.СогласиеПолучено = СогласиеПолучено;
	ПараметрыПроверки.Организация = Организация;
	ПараметрыПроверки.ПериодРегистрации = ПериодРегистрации;
	ПараметрыПроверки.ИмяПоляСпискаДат = "ДниСверхурочнойРаботы";
	
	УчетРабочегоВремениРасширенный.ПриПроверкеЗаполненияСверхурочныхДокументов(ПараметрыПроверки, Отказ, ПроверяемыеРеквизиты);
	
	ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеОВремени() Экспорт
	
	ДанныеОВремени = УчетРабочегоВремени.ТаблицаДляРегистрацииВремени();
	
	ВидВремениСверхурочные = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Сверхурочные");
	ВидВремениСверхурочныеБезОплаты = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.СверхурочныеБезПовышеннойОплаты");
	
	Для Каждого ТекСтрока Из Сотрудники Цикл
		
		Если ТекСтрока.ОтработаноЧасов = 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		Если ТекСтрока.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда
			ПрисваиваемыйВидВремени = ВидВремениСверхурочныеБезОплаты;
		Иначе
			ПрисваиваемыйВидВремени = ВидВремениСверхурочные;
		КонецЕсли;
		Если ПрисваиваемыйВидВремени = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаДанныхОВремени = ДанныеОВремени.Добавить();
		СтрокаДанныхОВремени.Дата = ТекСтрока.Дата;
		СтрокаДанныхОВремени.Сотрудник = ТекСтрока.Сотрудник;
		СтрокаДанныхОВремени.ВидВремени = ПрисваиваемыйВидВремени;
		СтрокаДанныхОВремени.Дней = 1;
		СтрокаДанныхОВремени.Часов = ТекСтрока.ОтработаноЧасов;
		
	КонецЦикла;

	Возврат ДанныеОВремени;
	
КонецФункции	

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	ТаблицаДокумента.Дата КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.РаботаСверхурочно.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДанныеОбОтгулах()

	ТаблицаОтгулов = Новый ТаблицаЗначений;
	ТаблицаОтгулов.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаОтгулов.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаОтгулов.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаОтгулов.Колонки.Добавить("ВидДвижения", Новый ОписаниеТипов("ВидДвиженияНакопления"));
	ТаблицаОтгулов.Колонки.Добавить("Дни", Новый ОписаниеТипов("Число"));
	ТаблицаОтгулов.Колонки.Добавить("Часы", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл
		Если НЕ СтрокаТаблицы.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда 
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаОтгулов.Добавить();
		НоваяСтрока.Период = СтрокаТаблицы.Дата;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Сотрудник = СтрокаТаблицы.Сотрудник;
		НоваяСтрока.Дни = 0; 
		НоваяСтрока.Часы = СтрокаТаблицы.ОтработаноЧасов;
	КонецЦикла;

	Возврат ТаблицаОтгулов;
	
КонецФункции

Функция ДанныеОРаботе()

	Возврат Сотрудники.Выгрузить();

КонецФункции

#КонецОбласти

#КонецЕсли
