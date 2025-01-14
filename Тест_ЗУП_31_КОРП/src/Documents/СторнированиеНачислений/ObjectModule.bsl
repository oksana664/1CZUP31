#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Сторнировать" Тогда
		ЗаполнитьПоСторнируемомуДокументу(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("СторнируемыйДокумент", СторнируемыйДокумент);
	Документы.СторнированиеНачислений.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Сторнирование", Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьДокументОснование(Отказ);
	ПроверитьПериодДействияНачислений(Отказ);
	
	Если ЗначениеЗаполнено(ЭтотОбъект.СторнируемыйДокумент) Тогда
		// Сторнирование производим следующим или текущим месяцем.
		ОписаниеДокумента = Документы.СторнированиеНачислений.ОписаниеСторнируемогоДокумента(ЭтотОбъект.СторнируемыйДокумент);
		ПериодРегистрацииСторнируемогоДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект.СторнируемыйДокумент, ОписаниеДокумента.МесяцНачисленияИмя);
		Если ПериодРегистрацииСторнируемогоДокумента <> Неопределено
			И ПериодРегистрацииСторнируемогоДокумента > ЭтотОбъект.ПериодРегистрации Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Период сторнирования не может быть меньше периода сторнируемого документа (%1 г.)'"),
				Формат(ПериодРегистрацииСторнируемогоДокумента, "ДФ='ММММ гггг'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ПериодРегистрации",,Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// Проверка корректности распределения по источникам финансирования
	ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "ДоначисленияИПерерасчеты,Сторнировано";
	
	ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
		ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
	
	// Проверка корректности распределения по территориям и условиям труда
	ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "ДоначисленияИПерерасчеты";
	
	РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
		ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
	
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
	МассивПараметров.Добавить(Новый Структура("ДоначисленияИПерерасчеты", "Сотрудник"));
	МассивПараметров.Добавить(Новый Структура("Сторнировано", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПериодДействияНачислений(Отказ)
	
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = ЭтотОбъект.Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("ДоначисленияИПерерасчеты", НСтр("ru = 'Доначисления и перерасчеты'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
	
КонецПроцедуры

Процедура ЗаполнитьПоСторнируемомуДокументу(ДанныеЗаполнения)
	
	Сторнировано.Очистить();
	ДоначисленияИПерерасчеты.Очистить();
	Показатели.Очистить();
	РаспределениеРезультатовНачислений.Очистить();
	РаспределениеПоТерриториямУсловиямТруда.Очистить();
	
	СторнируемыйДокумент = ДанныеЗаполнения.Ссылка;
	
	ОписаниеДокумента = Документы.СторнированиеНачислений.ОписаниеСторнируемогоДокумента(СторнируемыйДокумент);
	ДополнитьОписаниеСторнируемогоДокумента(ОписаниеДокумента, СторнируемыйДокумент);
	
	НачислениеДокумента = Неопределено;
	Если ОписаниеДокумента.РеквизитНачислениеДокумента <> Неопределено Тогда
		// Получаем начисление из "шапки" документа.
		НачислениеДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СторнируемыйДокумент, ОписаниеДокумента.РеквизитНачислениеДокумента);
		НачислениеДокументаЗачетНормыВремени = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НачислениеДокумента, "ЗачетНормыВремени");
	КонецЕсли;
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СторнируемыйДокумент, "Организация, " + ОписаниеДокумента.МесяцНачисленияИмя);
	
	ПериодРегистрацииСторнируемогоДокумента = ЗначенияРеквизитов[ОписаниеДокумента.МесяцНачисленияИмя];
	Организация = ЗначенияРеквизитов.Организация;
	ИмяТаблицы = ОбщегоНазначения.ИмяТаблицыПоСсылке(СторнируемыйДокумент);
	
	Если ДанныеЗаполнения.Свойство("Период") Тогда
		ПериодРегистрации = ДанныеЗаполнения.Период;
	ИначеЕсли ДанныеЗаполнения.Свойство("ДопустимоИсправлениеВТекущемПериоде") И ДанныеЗаполнения.ДопустимоИсправлениеВТекущемПериоде Тогда
		ПериодРегистрации = ДанныеЗаполнения.ПериодРегистрацииИсправленногоДокумента;
	Иначе
		ЗаполняемыеЗначения = Новый Структура("Месяц");
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
		ПериодРегистрации = Макс(ЗаполняемыеЗначения.Месяц, ДобавитьМесяц(ПериодРегистрацииСторнируемогоДокумента, 1));
		ДоначислитьЗарплатуПриНеобходимости = Истина;
	КонецЕсли;
	
	ДоначислитьЗарплатуПриНеобходимости = ДоначислитьЗарплатуПриНеобходимости И (ПериодРегистрацииСторнируемогоДокумента < ПериодРегистрации);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", СторнируемыйДокумент);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Начисления.Регистратор КАК ДокументНачисления
	|ПОМЕСТИТЬ ВТДокументыНачисления
	|ИЗ
	|	РегистрРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.ДокументОснование = &Ссылка
	|	И Начисления.Регистратор <> &Ссылка";
	
	Запрос.Выполнить();
	
	Если ОписаниеДокумента.ДокументБезДатаНачала Тогда
		Если ОписаниеДокумента.ДокументСТаблицейНачисления Тогда
			// Это случай, когда сторнируется документ без вытесняющих начислений (пример - Премия).
			ТекстЗапроса = 
			"ВЫБРАТЬ
			|	*
			|ИЗ
			|	#Начисления КАК Начисления
			|ГДЕ
			|	Начисления.Ссылка = &Ссылка
			|;
			|
			|///////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	*
			|ИЗ
			|	#РаспределениеРезультатовНачислений КАК РаспределениеРезультатов
			|ГДЕ
			|	РаспределениеРезультатов.Ссылка = &Ссылка
			|;
			|
			|///////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	*
			|ИЗ
			|	#РаспределениеПоТерриториямУсловиямТруда КАК РаспределениеПоТерриториям
			|ГДЕ
			|	РаспределениеПоТерриториям.Ссылка = &Ссылка";
		Иначе
			// Это случай, когда сторнируется документ без таблицы "Начисления" (пример - ИндивидуальныйГрафик).
			ТекстЗапроса = 
			"ВЫБРАТЬ ПЕРВЫЕ 0
			|	NULL КАК Сотрудник
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ 0
			|	NULL КАК Сотрудник
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ 0
			|	NULL КАК Сотрудник";
		КонецЕсли;
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	#Начисления КАК Начисления
		|ГДЕ
		|	Начисления.Ссылка = &Ссылка
		|;
		|
		|///////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	*
		|ИЗ
		|	#РаспределениеРезультатовНачислений КАК РаспределениеРезультатов
		|ГДЕ
		|	РаспределениеРезультатов.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	*
		|ИЗ
		|	#РаспределениеПоТерриториямУсловиямТруда КАК РаспределениеПоТерриториям
		|ГДЕ
		|	РаспределениеПоТерриториям.Ссылка = &Ссылка";
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Начисления", ИмяТаблицы + ".Начисления");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#НачисленияПерерасчет", ИмяТаблицы + ".НачисленияПерерасчет");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#РаспределениеРезультатовНачислений", ИмяТаблицы + ".РаспределениеРезультатовНачислений");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#РаспределениеПоТерриториямУсловиямТруда", ИмяТаблицы + ".РаспределениеПоТерриториямУсловиямТруда");
	
	Результаты = Запрос.ВыполнитьПакет();
	
	НачисленияЗаднимЧислом = ИсправлениеДокументовРасчетЗарплаты.ПустаяТаблицаНачисленийЗаднимЧислом();
	
	РегистраторНаборДляЗаполненияПерерасчета = Документы.НачислениеЗарплаты.ПолучитьСсылку();
	НаборыЗаписей = ЗарплатаКадры.НаборыЗаписейРегистратора(Метаданные.Документы.НачислениеЗарплаты, РегистраторНаборДляЗаполненияПерерасчета);
	
	Если ЭтотОбъект.ДоначислитьЗарплатуПриНеобходимости Тогда
		НаборДляЗаполненияПерерасчета = НаборыЗаписей["Начисления"];
		ЗначенияПоказателейНабор = НаборыЗаписей["ЗначенияПоказателейНачислений"];
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РаспределениеРезультатов",					Результаты[1].Выгрузить());
	ДополнительныеПараметры.Вставить("РаспределениеПоТерриториям",					Результаты[2].Выгрузить());
	ДополнительныеПараметры.Вставить("УчитыватьСуммуВычета",						Результаты[0].Колонки.Найти("СуммаВычета") <> Неопределено);
	ДополнительныеПараметры.Вставить("НачислениеДокумента",							НачислениеДокумента);
	ДополнительныеПараметры.Вставить("ДокументБезДатаНачала",						ОписаниеДокумента.ДокументБезДатаНачала);
	ДополнительныеПараметры.Вставить("РегистраторНаборДляЗаполненияПерерасчета",	РегистраторНаборДляЗаполненияПерерасчета);
	ДополнительныеПараметры.Вставить("ОтборСтрок",									Новый Структура("ИдентификаторСтроки"));
	
	// Заполним сторнируемые начисления.
	ВыборкаНачислений = Результаты[0].Выбрать();
	Пока ВыборкаНачислений.Следующий() Цикл
		ДополнитьСторнируемыеНачисления(ВыборкаНачислений, НачисленияЗаднимЧислом, ДополнительныеПараметры);
	КонецЦикла;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.НачислениеЗарплаты.Начисления КАК НачислениеЗарплаты
	|ГДЕ
	|	НачислениеЗарплаты.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТДокументыНачисления.ДокументНачисления
	|			ИЗ
	|				ВТДокументыНачисления)
	|	И НачислениеЗарплаты.ДокументОснование = &Ссылка
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.НачислениеЗарплаты.РаспределениеРезультатовНачислений КАК НачислениеЗарплаты
	|ГДЕ
	|	НачислениеЗарплаты.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТДокументыНачисления.ДокументНачисления
	|			ИЗ
	|				ВТДокументыНачисления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	Документ.НачислениеЗарплаты.РаспределениеПоТерриториямУсловиямТруда КАК НачислениеЗарплаты
	|ГДЕ
	|	НачислениеЗарплаты.Ссылка В
	|			(ВЫБРАТЬ
	|				ВТДокументыНачисления.ДокументНачисления
	|			ИЗ
	|				ВТДокументыНачисления)";
	
	РезультатыДокументовОснований = Запрос.ВыполнитьПакет();
	
	ДополнительныеПараметры.Вставить("РаспределениеРезультатов",	РезультатыДокументовОснований[1].Выгрузить());
	ДополнительныеПараметры.Вставить("РаспределениеПоТерриториям",	РезультатыДокументовОснований[2].Выгрузить());
	ДополнительныеПараметры.Вставить("ОтборСтрок",					Новый Структура("ИдентификаторСтроки, Ссылка"));
	
	// Заполним сторнируемые начисления документов-оснований.
	ВыборкаНачисленийДокументовОснований = РезультатыДокументовОснований[0].Выбрать();
	Пока ВыборкаНачисленийДокументовОснований.СледующийПоЗначениюПоля("Ссылка") Цикл
		Пока ВыборкаНачисленийДокументовОснований.Следующий() Цикл
			ДополнитьСторнируемыеНачисления(ВыборкаНачисленийДокументовОснований, НачисленияЗаднимЧислом, ДополнительныеПараметры);
		КонецЦикла;
	КонецЦикла;
	
	Если ОписаниеДокумента.ДокументБезДатаНачала Тогда
		ЗарплатаКадрыРасширенный.СкорректироватьДатыНачисленийБезПериодаДействия(Сторнировано, ПериодРегистрацииСторнируемогоДокумента);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Если Не ОписаниеДокумента.ДокументБезДатаНачала 
		И ЭтотОбъект.ДоначислитьЗарплатуПриНеобходимости 
		И Не (НачислениеДокумента <> НеОпределено И Не НачислениеДокументаЗачетНормыВремени) Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	МИНИМУМ(Начисления.НачалоСтарогоПериода) КАК НачалоСтарогоПериода,
		|	МАКСИМУМ(Начисления.ОкончаниеСтарогоПериода) КАК ОкончаниеСтарогоПериода,
		|	Начисления.Организация КАК Организация,
		|	Начисления.ПериодРегистрации КАК ПериодРегистрации
		|ИЗ
		|	(ВЫБРАТЬ
		|		Начисления.ДатаНачала КАК НачалоСтарогоПериода,
		|		ВЫБОР
		|			КОГДА Начисления.ДатаОкончания > &КонецПериодаРегистрации
		|				ТОГДА &КонецПериодаРегистрации
		|			ИНАЧЕ Начисления.ДатаОкончания
		|		КОНЕЦ КАК ОкончаниеСтарогоПериода,
		|		Начисления.Ссылка.Организация КАК Организация,
		|		Начисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации
		|	ИЗ
		|		#Начисления КАК Начисления
		|	ГДЕ
		|		Начисления.Ссылка = &Ссылка
		|		И Начисления.ДатаНачала < &КонецПериодаРегистрации
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		Начисления.ДатаНачала,
		|		Начисления.ДатаОкончания,
		|		Начисления.Ссылка.Организация,
		|		Начисления.Ссылка.МесяцНачисления
		|	ИЗ
		|		Документ.НачислениеЗарплаты.Начисления КАК Начисления
		|	ГДЕ
		|		Начисления.Ссылка В
		|				(ВЫБРАТЬ
		|					ВТДокументыНачисления.ДокументНачисления
		|				ИЗ
		|					ВТДокументыНачисления)
		|		И Начисления.ДокументОснование = &Ссылка) КАК Начисления
		|
		|СГРУППИРОВАТЬ ПО
		|	Начисления.Организация,
		|	Начисления.ПериодРегистрации
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Начисления.Сотрудник КАК Сотрудник,
		|	Начисления.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ИЗ
		|	#Начисления КАК Начисления
		|ГДЕ
		|	Начисления.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Начисления.Сотрудник,
		|	Начисления.Сотрудник.ГоловнаяОрганизация
		|ИЗ
		|	Документ.НачислениеЗарплаты.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТДокументыНачисления.ДокументНачисления
		|			ИЗ
		|				ВТДокументыНачисления)
		|	И Начисления.ДокументОснование = &Ссылка";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Начисления", ИмяТаблицы + ".Начисления");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Начисления.Ссылка.ПериодРегистрации", "Начисления.Ссылка." + ОписаниеДокумента.МесяцНачисленияИмя);
		Запрос.УстановитьПараметр("КонецПериодаРегистрации", КонецМесяца(ПериодРегистрации));
		Результаты = Запрос.ВыполнитьПакет();
		
		ВременнаяСсылка = Документы.НачислениеЗарплаты.ПолучитьСсылку();
		НачисленияНабор = РасчетЗарплатыРасширенный.НаборЗаписейНачисления(ВременнаяСсылка);
		ВременнаяСсылкаФизлицо = Справочники.ФизическиеЛица.ПолучитьСсылку();
		
		ИдентификаторСтрокиПлановые = 1;
		ВыборкаДанныеСторнируемого = Результаты[0].Выбрать();
		
		ИдентификаторСтрокиДоначисления = 1;
		
		Пока ВыборкаДанныеСторнируемого.Следующий() Цикл
			Если ВыборкаДанныеСторнируемого.НачалоСтарогоПериода > ПериодРегистрации Тогда
				Продолжить;
			КонецЕсли;
			
			НачалоСтарогоПериода = ВыборкаДанныеСторнируемого.НачалоСтарогоПериода;
			ОкончаниеСтарогоПериода = Мин(ВыборкаДанныеСторнируемого.ОкончаниеСтарогоПериода, ПериодРегистрации - 1);
			
			ВременныйПериодРегистрации = ВыборкаДанныеСторнируемого.ПериодРегистрации;
			ВременныйСледующийПериодРегистрации = ДобавитьМесяц(ВременныйПериодРегистрации, 1);
			
			// "старые" сотрудники
			// таблица для использования в РасчетЗарплатыРасширенный.ДанныеДляНачисленияЗарплаты.
			ТаблицаСтарыхСотрудников = Новый ТаблицаЗначений;
			ТаблицаСтарыхСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
			ТаблицаСтарыхСотрудников.Колонки.Добавить("Начисление", Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Начисления"));
			
			ВыборкаСтарыеСотрудники = Результаты[1].Выбрать();
			
			Сотрудники = Новый Массив;
			Пока ВыборкаСтарыеСотрудники.Следующий() Цикл
				Сотрудники.Добавить(ВыборкаСтарыеСотрудники.Сотрудник);
			КонецЦикла;
			
			// Получим данные плановых начислений за исправляемый период.
			МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(ПериодРегистрации, ВыборкаДанныеСторнируемого.Организация);
			МенеджерРасчета.ИсключаемыйРегистратор = Ссылка;
			МенеджерРасчета.НастройкиРасчета.ИсключатьРанееОплаченныеПериоды = Ложь;
			ПлановыеНачисления = МенеджерРасчета.НачисленияЗарплатыЗаПериод(Сотрудники, НачалоСтарогоПериода, ОкончаниеСтарогоПериода);
			
			// Добавим во временный набор плановые начисления сторнируемого периода.
			Для Каждого СтрокаНачисления Из ПлановыеНачисления Цикл
				НоваяСтрокаНачисленияЗаднимЧислом = НачисленияЗаднимЧислом.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаНачисленияЗаднимЧислом, СтрокаНачисления);
				НоваяСтрокаНачисленияЗаднимЧислом.ВидРасчета = СтрокаНачисления.Начисление;
				НоваяСтрокаНачисленияЗаднимЧислом.ПериодДействияНачало = СтрокаНачисления.ДатаНачала;
				НоваяСтрокаНачисленияЗаднимЧислом.ПериодДействияКонец = СтрокаНачисления.ДатаОкончания;
				
				НоваяСтрокаДоначислений = ДоначисленияИПерерасчеты.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаДоначислений, СтрокаНачисления);
				НоваяСтрокаДоначислений.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиДоначисления;
				Для Каждого СтрокаПоказателя Из СтрокаНачисления.Показатели Цикл
					НоваяСтрокаПоказателя = Показатели.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаПоказателя, СтрокаПоказателя);
					НоваяСтрокаПоказателя.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиДоначисления;
				КонецЦикла;
				ИдентификаторСтрокиДоначисления = ИдентификаторСтрокиДоначисления + 1;
				
			КонецЦикла;
			
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Истина);
		НачисленияНабор.Записать();
		НаборДляЗаполненияПерерасчета.Записать();
		ЗначенияПоказателейНабор.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Если ЭтотОбъект.ДоначислитьЗарплатуПриНеобходимости Тогда
		ИсправлениеДокументовРасчетЗарплаты.ЗаполнитьНачисленияПерерасчетПоНачисленияЗаднимЧислом(Организация, ПериодРегистрации, НачисленияЗаднимЧислом, ДоначисленияИПерерасчеты, РегистраторНаборДляЗаполненияПерерасчета, , Показатели);
	КонецЕсли;
	
	ОтменитьТранзакцию();
	
КонецПроцедуры

Процедура ДополнитьОписаниеСторнируемогоДокумента(Описание, СторнируемыйДокумент)
	
	МетаданныеДокумента = СторнируемыйДокумент.Метаданные();
	
	Описание.Вставить("ДокументСТаблицейНачисления", МетаданныеДокумента.ТабличныеЧасти.Найти("Начисления") <> Неопределено);
	Описание.Вставить("ДокументБезДатаНачала", Истина);
	Описание.Вставить("ДокументБезНачисление", Истина);
	Описание.Вставить("РеквизитНачислениеДокумента", Неопределено);
	
	Если Описание.ДокументСТаблицейНачисления Тогда
		Описание.ДокументБезДатаНачала = МетаданныеДокумента.ТабличныеЧасти.Начисления.Реквизиты.Найти("ДатаНачала") = Неопределено;
		Описание.ДокументБезНачисление = МетаданныеДокумента.ТабличныеЧасти.Начисления.Реквизиты.Найти("Начисление") = Неопределено;
	КонецЕсли;
	
	Если Описание.ДокументБезНачисление Тогда
		Для Каждого Реквизит Из МетаданныеДокумента.Реквизиты Цикл
			Если Реквизит.Тип.Типы()[0] = Тип("ПланВидовРасчетаСсылка.Начисления") Тогда
				Описание.РеквизитНачислениеДокумента = Реквизит.Имя;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

Процедура ДополнитьСторнируемыеНачисления(ВыборкаНачислений, НачисленияЗаднимЧислом, ДополнительныеПараметры)
	
	РаспределениеРезультатов = ДополнительныеПараметры.РаспределениеРезультатов;
	РаспределениеПоТерриториям = ДополнительныеПараметры.РаспределениеПоТерриториям;
	УчитыватьСуммуВычета = ДополнительныеПараметры.УчитыватьСуммуВычета;
	НачислениеДокумента = ДополнительныеПараметры.НачислениеДокумента;
	ДокументБезДатаНачала = ДополнительныеПараметры.ДокументБезДатаНачала;
	РегистраторНаборДляЗаполненияПерерасчета = ДополнительныеПараметры.РегистраторНаборДляЗаполненияПерерасчета;
	ОтборСтрок = ДополнительныеПараметры.ОтборСтрок;
	
	НоваяСтрока = Сторнировано.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаНачислений);
	НоваяСтрока.Результат = - НоваяСтрока.Результат;
	Если УчитыватьСуммуВычета Тогда
		НоваяСтрока.СуммаВычета = - НоваяСтрока.СуммаВычета;
	КонецЕсли;
	НоваяСтрока.ОтработаноДней = - НоваяСтрока.ОтработаноДней;
	НоваяСтрока.ОтработаноЧасов = - НоваяСтрока.ОтработаноЧасов;
	НоваяСтрока.ОплаченоДней = - НоваяСтрока.ОплаченоДней;
	НоваяСтрока.ОплаченоЧасов = - НоваяСтрока.ОплаченоЧасов;
	Если ЗначениеЗаполнено(НачислениеДокумента) Тогда
		НоваяСтрока.Начисление = НачислениеДокумента;
	Иначе
		НоваяСтрока.Начисление = ВыборкаНачислений.Начисление;
	КонецЕсли;
	Если НЕ ДокументБезДатаНачала Тогда
		НоваяСтрока.ДатаНачала = ВыборкаНачислений.ДатаНачала;
		НоваяСтрока.ДатаОкончания = ВыборкаНачислений.ДатаОкончания;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(НоваяСтрока.ПериодДействия) Тогда
		НоваяСтрока.ПериодДействия = НачалоМесяца(НоваяСтрока.ДатаНачала);
	КонецЕсли;
	НоваяСтрока.Сторно = Истина;
	НоваяСтрока.ФиксРасчет = Истина;
	
	СтрокаНачисленийЗаднимЧислом = НачисленияЗаднимЧислом.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаНачисленийЗаднимЧислом, ВыборкаНачислений);
	СтрокаНачисленийЗаднимЧислом.Регистратор = РегистраторНаборДляЗаполненияПерерасчета;
	СтрокаНачисленийЗаднимЧислом.ИдентификаторСтроки = 0;
	СтрокаНачисленийЗаднимЧислом.РегистраторПоказателей = Неопределено;
	СтрокаНачисленийЗаднимЧислом.ИдентификаторСтрокиПоказателей = Неопределено;
	Если ЗначениеЗаполнено(НачислениеДокумента) Тогда
		СтрокаНачисленийЗаднимЧислом.ВидРасчета = НачислениеДокумента;
	Иначе
		СтрокаНачисленийЗаднимЧислом.ВидРасчета = ВыборкаНачислений.Начисление;
	КонецЕсли;
	Если НЕ ДокументБезДатаНачала Тогда
		СтрокаНачисленийЗаднимЧислом.ПериодДействияНачало = ВыборкаНачислений.ДатаНачала;
		СтрокаНачисленийЗаднимЧислом.ПериодДействияКонец = ВыборкаНачислений.ДатаОкончания;
	КонецЕсли;
	СтрокаНачисленийЗаднимЧислом.Сторно = Истина;
	
	НовыйИдентификаторСтроки = Сторнировано.Количество();
	ОтборСтрок.ИдентификаторСтроки = ВыборкаНачислений.ИдентификаторСтрокиВидаРасчета;
	Если ОтборСтрок.Свойство("Ссылка") Тогда
		ОтборСтрок.Ссылка = ВыборкаНачислений.Ссылка;
	КонецЕсли;
	НоваяСтрока.ИдентификаторСтрокиВидаРасчета = НовыйИдентификаторСтроки;
	СтрокиРаспределения = РаспределениеРезультатов.НайтиСтроки(ОтборСтрок);
	Для каждого СтрокаРаспределения Из СтрокиРаспределения Цикл
		НоваяСтрока = РаспределениеРезультатовНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаспределения);
		НоваяСтрока.Результат = - НоваяСтрока.Результат;
		НоваяСтрока.ИдентификаторСтроки = НовыйИдентификаторСтроки;
	КонецЦикла;
	СтрокиТерриторий = РаспределениеПоТерриториям.НайтиСтроки(ОтборСтрок);
	Для каждого СтрокаТерритории Из СтрокиТерриторий Цикл
		НоваяСтрока = РаспределениеПоТерриториямУсловиямТруда.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТерритории);
		НоваяСтрока.Результат = - НоваяСтрока.Результат;
		НоваяСтрока.ИдентификаторСтроки = НовыйИдентификаторСтроки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДокументОснование(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СторнируемыйДокумент", СторнируемыйДокумент);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СторнированиеНачислений.Ссылка
	|ИЗ
	|	Документ.СторнированиеНачислений КАК СторнированиеНачислений
	|ГДЕ
	|	СторнированиеНачислений.Проведен
	|	И СторнированиеНачислений.СторнируемыйДокумент = &СторнируемыйДокумент
	|	И СторнированиеНачислений.Ссылка <> &Ссылка";
	
	ШаблонСообщения = НСтр("ru = 'Документ %1 уже сторнирован документом %2'");
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СторнируемыйДокумент, Выборка.Ссылка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.СторнируемыйДокумент",,Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
