#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ИзменениеУсловийДоговораЗаймаСотруднику;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическоеЛицоВШапке(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыПечатиДокумента

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Дополнительное соглашение к договору займа.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ДополнительноеСоглашениеКДоговоруЗайма";
	КомандаПечати.Представление = НСтр("ru = 'Дополнительное соглашение к договору займа'");
	КомандаПечати.Порядок = 10;
	
	// График погашения займа
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ГрафикПогашенияЗайма";
	КомандаПечати.Представление = НСтр("ru = 'График погашения займа'");
	КомандаПечати.Порядок = 20;
	
	// Карточка учета договора займа
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "КарточкаУчетаДоговораЗайма";
	КомандаПечати.Представление = НСтр("ru = 'Карточка учета договора займа'");
	КомандаПечати.Порядок = 30;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДополнительноеСоглашениеКДоговоруЗайма") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, "ДополнительноеСоглашениеКДоговоруЗайма", НСтр("ru = 'Дополнительное соглашение к договору займа'"), ДополнительноеСоглашениеКДоговоруЗайма(МассивОбъектов, ОбъектыПечати));
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ГрафикПогашенияЗайма") Тогда
		Документы.ДоговорЗаймаСотруднику.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КарточкаУчетаДоговораЗайма") Тогда
		Документы.ДоговорЗаймаСотруднику.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

Функция ДополнительноеСоглашениеКДоговоруЗайма(МассивОбъектов, ОбъектыПечати)
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	ДанныеПечатиОбъектов = ДанныеПечатиДополнительногоСоглашения(МассивОбъектов);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДоговорЗаймаСотруднику.ПФ_MXL_ДоговорЗайма");
	
	ПервыйДокумент = Истина;
	Для Каждого ДокументСсылка Из МассивОбъектов Цикл
		
		Если ПервыйДокумент Тогда
			ПервыйДокумент = Ложь;
		Иначе
			// Все документы нужно выводить на разных страницах.
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
		
		ДанныеПечати = ДанныеПечатиОбъектов.Получить(ДокументСсылка);
		ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "ЗаголовокДополнительногоСоглашения", ДанныеПечати));
		ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "ПреамбулаДополнительногоСоглашения", ДанныеПечати));
		
		НомерИзменений = 1;
		
		// Изменилась сумма займа
		Если ДанныеПечати.СуммаЗаймаИзменена Тогда
			ДокументРезультат.Вывести(ОбластьСтрокаИзменений(Макет, НомерИзменений, "1.1", НСтр("ru = '«Предмет договора»'")));
			ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "СуммаЗайма", ДанныеПечати));
		КонецЕсли;
		
		// Изменился срок займа
		Если ДанныеПечати.ДатаОкончанияИзменена Тогда
			ДокументРезультат.Вывести(ОбластьСтрокаИзменений(Макет, НомерИзменений, "1.2", НСтр("ru = '«Предмет договора»'")));
			ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "СрокЗайма", ДанныеПечати));
		КонецЕсли;
		
		// Изменились транши
		Если ДанныеПечати.СпособПредоставления = Перечисления.СпособыПредоставленияЗаймаСотруднику.Траншами 
			И ДанныеПечати.ТраншиЗаймаИзменены Тогда
			ДокументРезультат.Вывести(ОбластьСтрокаИзменений(Макет, НомерИзменений, "2.1", НСтр("ru = '«Права и обязанности сторон»'")));
			ДокументРезультат.Вывести(Макет.ПолучитьОбласть("ПредоставлениеТраншами"));
			Для Каждого СтрокаТранша Из ДанныеПечати.ТраншиЗайма Цикл
				ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "Транш", СтрокаТранша));
			КонецЦикла;
		КонецЕсли;
		
		// Изменилась процентная ставка.
		Если ДанныеПечати.ПроцентнаяСтавкаИзменена Тогда
			ДокументРезультат.Вывести(ОбластьСтрокаИзменений(Макет, НомерИзменений, "2.2", НСтр("ru = '«Права и обязанности сторон»'")));
			Если ДанныеПечати.ПроцентнаяСтавка = 0 Тогда
				ДокументРезультат.Вывести(Макет.ПолучитьОбласть("ПроцентнаяСтавкаНеопределена"));
			Иначе
				ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "ПроцентнаяСтавкаОпределена", ДанныеПечати));
			КонецЕсли;
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "ПересчетПлатежей", ДанныеПечати, НомерИзменений));
		ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "МесяцВступленияВСилуДополнительногоСоглашения", ДанныеПечати, НомерИзменений));
		ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "ЮридическаСилаДополнительногоСоглашения", ДанныеПечати, НомерИзменений));
		ДокументРезультат.Вывести(ОбластьСПараметрами(Макет, "АдресаРеквизитыСторон", ДанныеПечати));
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ДокументСсылка);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ДанныеПечатиДополнительногоСоглашения(МассивОбъектов) Экспорт
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ИзменениеТраншиЗайма.Ссылка,
		|	ИзменениеТраншиЗайма.ДатаПредоставления,
		|	ИзменениеТраншиЗайма.Сумма,
		|	ИзменениеТраншиЗайма.РазмерПогашения,
		|	ИзменениеТраншиЗайма.ДатаПогашения
		|ИЗ
		|	Документ.ИзменениеУсловийДоговораЗаймаСотруднику.ТраншиЗайма КАК ИзменениеТраншиЗайма
		|ГДЕ
		|	ИзменениеТраншиЗайма.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИзменениеТраншиЗайма.ДатаПредоставления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеДоговора.Ссылка,
		|	ДоговорТраншиЗайма.ДатаПредоставления,
		|	ДоговорТраншиЗайма.Сумма,
		|	ДоговорТраншиЗайма.РазмерПогашения,
		|	ДоговорТраншиЗайма.ДатаПогашения
		|ИЗ
		|	Документ.ДоговорЗаймаСотруднику.ТраншиЗайма КАК ДоговорТраншиЗайма
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийДоговораЗаймаСотруднику КАК ИзменениеДоговора
		|		ПО (ИзменениеДоговора.ДоговорЗайма = ДоговорТраншиЗайма.Ссылка)
		|			И (ИзменениеДоговора.Ссылка В (&МассивОбъектов))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДоговорТраншиЗайма.ДатаПредоставления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВзаиморасчетыПоЗаймамСотрудникамОбороты.ДоговорЗайма КАК ДоговорЗайма,
		|	ВзаиморасчетыПоЗаймамСотрудникамОбороты.СуммаЗаймаПриход КАК Сумма,
		|	ВзаиморасчетыПоЗаймамСотрудникамОбороты.Период КАК Дата
		|ИЗ
		|	РегистрНакопления.ВзаиморасчетыПоЗаймамСотрудникам.Обороты(
		|			,
		|			,
		|			Месяц,
		|			ДоговорЗайма В
		|				(ВЫБРАТЬ
		|					ИзменениеУсловийДоговораЗаймаСотруднику.ДоговорЗайма
		|				ИЗ
		|					Документ.ИзменениеУсловийДоговораЗаймаСотруднику КАК ИзменениеУсловийДоговораЗаймаСотруднику
		|				ГДЕ
		|					ИзменениеУсловийДоговораЗаймаСотруднику.Ссылка В (&МассивОбъектов))) КАК ВзаиморасчетыПоЗаймамСотрудникамОбороты
		|ГДЕ
		|	ВзаиморасчетыПоЗаймамСотрудникамОбороты.СуммаЗаймаПриход > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИзменениеДоговора.Ссылка,
		|	ДоговорЗаймаСотруднику.Ссылка КАК ДоговорЗайма,
		|	ДоговорЗаймаСотруднику.Номер КАК НомерДоговора,
		|	ДоговорЗаймаСотруднику.Дата КАК ДатаДоговора,
		|	ИзменениеДоговора.Номер КАК НомерДокумента,
		|	ИзменениеДоговора.Дата КАК ДатаДокумента,
		|	ДоговорЗаймаСотруднику.Организация,
		|	ДоговорЗаймаСотруднику.Организация.НаименованиеПолное КАК НазваниеОрганизации,
		|	ДоговорЗаймаСотруднику.ФизическоеЛицо,
		|	ИзменениеДоговора.Руководитель,
		|	ИзменениеДоговора.ДолжностьРуководителя,
		|	ДоговорЗаймаСотруднику.СпособПредоставления,
		|	ИзменениеДоговора.Сумма КАК СуммаЗайма,
		|	ДоговорЗаймаСотруднику.ДатаПредоставления,
		|	ИзменениеДоговора.ДатаИзменений КАК ДатаАктуальности,
		|	ИзменениеДоговора.ДатаИзменений КАК ДатаИзменений,
		|	КОНЕЦПЕРИОДА(ИзменениеДоговора.ДатаОкончания, МЕСЯЦ) КАК ДатаОкончания,
		|	РАЗНОСТЬДАТ(ДоговорЗаймаСотруднику.ДатаПредоставления, ИзменениеДоговора.ДатаОкончания, МЕСЯЦ) + 1 КАК Срок,
		|	ВЫБОР
		|		КОГДА ДоговорЗаймаСотруднику.ВидПлатежей = ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейПогашенияЗаймаСотруднику.АннуитетныеПлатежи)
		|			ТОГДА ИзменениеДоговора.РазмерПлатежа
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК РазмерПлатежа,
		|	ВЫБОР
		|		КОГДА ДоговорЗаймаСотруднику.ВидПлатежей = ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейПогашенияЗаймаСотруднику.АннуитетныеПлатежи)
		|			ТОГДА 0
		|		ИНАЧЕ ИзменениеДоговора.РазмерПогашения
		|	КОНЕЦ КАК РазмерПогашения,
		|	ИзменениеДоговора.ПроцентнаяСтавка,
		|	ДоговорЗаймаСотруднику.СпособПогашения,
		|	ДоговорЗаймаСотруднику.ВидПлатежей,
		|	ИзменениеДоговора.ДатаНачалаПогашения КАК НачалоПогашения,
		|	ИзменениеДоговора.ОграничениеПлатежа,
		|	ВЫБОР
		|		КОГДА ДоговорЗаймаСотруднику.Сумма <> ИзменениеДоговора.Сумма
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК СуммаЗаймаИзменена,
		|	ВЫБОР
		|		КОГДА ДоговорЗаймаСотруднику.ДатаОкончания <> ИзменениеДоговора.ДатаОкончания
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ДатаОкончанияИзменена,
		|	ВЫБОР
		|		КОГДА ДоговорЗаймаСотруднику.ПроцентнаяСтавка <> ИзменениеДоговора.ПроцентнаяСтавка
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ПроцентнаяСтавкаИзменена,
		|	ВЫБОР
		|		КОГДА ДоговорЗаймаСотруднику.ДатаНачалаПогашения <> ИзменениеДоговора.ДатаНачалаПогашения
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК НачалоПогашенияИзменено,
		|	ИзменениеДоговора.МатериальнаяВыгодаОблагаетсяНДФЛ,
		|	ДоговорЗаймаСотруднику.ЗаемПоДоговоруВыданПолностью,
		|	ДоговорЗаймаСотруднику.ФормаРасчетов,
		|	&ТекДата,
		|	ЕСТЬNULL(ВзаиморасчетыПоЗаймамСотрудникамОстатки.СуммаЗаймаОстаток, 0) КАК ОстатокЗайма
		|ИЗ
		|	Документ.ИзменениеУсловийДоговораЗаймаСотруднику КАК ИзменениеДоговора
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДоговорЗаймаСотруднику КАК ДоговорЗаймаСотруднику
		|		ПО ИзменениеДоговора.ДоговорЗайма = ДоговорЗаймаСотруднику.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыПоЗаймамСотрудникам.Остатки(, ) КАК ВзаиморасчетыПоЗаймамСотрудникамОстатки
		|		ПО (ВзаиморасчетыПоЗаймамСотрудникамОстатки.ДоговорЗайма = ИзменениеДоговора.ДоговорЗайма)
		|ГДЕ
		|	ИзменениеДоговора.Ссылка В(&МассивОбъектов)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДатаСеанса());
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	// Коллекцию траншей в документе изменения сравниваем с коллекцией 
	// в исходном документе договоре займа.
	ИзменениеТранши = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 3].Выгрузить();
	ДоговорТранши = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 2].Выгрузить();
	ТаблицаВыдачЗайма = РезультатыЗапроса[РезультатыЗапроса.ВГраница() - 1].Выгрузить();
	
	Выборка = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ДанныеПечати = Документы.ДоговорЗаймаСотруднику.ПараметрыПечатнойФормыДоговораЗайма();
		
		ИзменениеТраншиДокумента = ИзменениеТранши.Скопировать(Новый Структура("Ссылка", Выборка.Ссылка));
		ДоговорТраншиДокумента = ДоговорТранши.Скопировать(Новый Структура("Ссылка", Выборка.Ссылка));
		
		ДанныеПечати.Вставить("ТраншиЗаймаИзменены", Не ОбщегоНазначения.КоллекцииИдентичны(ИзменениеТраншиДокумента, ДоговорТраншиДокумента));
		Если ДанныеПечати.ТраншиЗаймаИзменены Тогда
			ИзменениеТраншиДокумента.Колонки.Добавить("ДатаПредоставленияСтрока");
			Для Каждого СтрокаТранша Из ИзменениеТраншиДокумента Цикл
				СтрокаТранша.ДатаПредоставленияСтрока = Формат(СтрокаТранша.ДатаПредоставления, "ДФ='ММММ гггг'");
			КонецЦикла;
		КонецЕсли;
		ДанныеПечати.Вставить("ТраншиЗайма", ИзменениеТраншиДокумента);
		ДанныеПечати.Вставить("ВыдачиЗайма", ТаблицаВыдачЗайма.Скопировать(Новый Структура("ДоговорЗайма", Выборка.ДоговорЗайма)));
		
		ЗаполнитьЗначенияСвойств(ДанныеПечати, Выборка);
		ДанныеПечати.Вставить("НомерДокумента", Выборка.НомерДокумента);
		ДанныеПечати.Вставить("ДатаДокумента", Выборка.ДатаДокумента);
		
		// Представление документа
		ДанныеПечати.Вставить("ПредставлениеДокумента", 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'к дополнительному соглашению №%1 от %2 
						|(договор займа №%3 от %4)'"), 
				Выборка.НомерДокумента, 
				Формат(Выборка.ДатаДокумента, "ДЛФ=D"),
				Выборка.НомерДоговора, 
				Формат(Выборка.ДатаДоговора, "ДЛФ=D")));
		
		// Признаки изменений
		ДанныеПечати.Вставить("СуммаЗаймаИзменена", Выборка.СуммаЗаймаИзменена);
		ДанныеПечати.Вставить("ДатаОкончанияИзменена", Выборка.ДатаОкончанияИзменена);
		ДанныеПечати.Вставить("ПроцентнаяСтавкаИзменена", Выборка.ПроцентнаяСтавкаИзменена);
		ДанныеПечати.Вставить("НачалоПогашенияИзменено", Выборка.НачалоПогашенияИзменено);
		
		// Юридический адрес организации.
		АдресОрганизации = "";
		Если ЗначениеЗаполнено(Выборка.Организация) Тогда
			АдресОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
				Выборка.Организация,
				Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
				Выборка.ДатаДокумента);
		КонецЕсли;
		ДанныеПечати.Вставить("ЮридическийАдресОрганизации", АдресОрганизации);
		
		Если Не ЗначениеЗаполнено(Выборка.НачалоПогашения) Тогда
			// Если дата отсрочки не заполнена, то начало погашения - следующий месяц.
			ДанныеПечати.Вставить("НачалоПогашенияСтрока", НСтр("ru = 'месяца, следующего за месяцем предоставления'"));
		Иначе
			ДанныеПечати.Вставить("НачалоПогашенияСтрока", Формат(Выборка.НачалоПогашения, "ДЛФ=D"));
		КонецЕсли;
		
		// Форматирование дат
		ДанныеПечати.Вставить("ДатаДоговора", Формат(Выборка.ДатаДоговора, "ДЛФ=D"));
		ДанныеПечати.Вставить("ДатаПредоставленияСтрока", Формат(Выборка.ДатаПредоставления, "ДЛФ=D"));
		ДанныеПечати.Вставить("ДатаОкончанияСтрока", Формат(Выборка.ДатаОкончания, "ДЛФ=D"));
		ДанныеПечати.Вставить("ДатаИзмененийСтрока", Формат(Выборка.ДатаИзменений, "ДЛФ=D"));
		
		// Данные физического лица
		ФизическиеЛицаМассив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка.ФизическоеЛицо);
		ИменаПолей = "ФИОПолные, Пол, АдресПоПрописке, ДокументВид, ДокументСерия, ДокументНомер";
		ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, ФизическиеЛицаМассив, ИменаПолей, Выборка.ДатаДоговора);
		Если ДанныеФизическогоЛица.Количество() > 0 Тогда
			ДанныеПечати.Вставить("ФИОСотрудника", 		ДанныеФизическогоЛица[0].ФИОПолные);
			СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(
					ДанныеФизическогоЛица[0].АдресПоПрописке, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			АдресПоПрописке = "";
			УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, АдресПоПрописке);
			ДанныеПечати.Вставить("АдресПоПрописке",	АдресПоПрописке);
			ДанныеПечати.Вставить("ДокументВид",		ДанныеФизическогоЛица[0].ДокументВид);
			ДанныеПечати.Вставить("ДокументСерия",		ДанныеФизическогоЛица[0].ДокументСерия);
			ДанныеПечати.Вставить("ДокументНомер",		ДанныеФизическогоЛица[0].ДокументНомер);
			ДанныеПечати.Вставить("Именуемый",	?(ДанныеФизическогоЛица[0].Пол = Перечисления.ПолФизическогоЛица.Мужской, 
					НСтр("ru = 'именуемый'"), НСтр("ru = 'именуемая'")));
		КонецЕсли;
		
		ДанныеПечатиОбъектов.Вставить(Выборка.Ссылка, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

Функция ОбластьСПараметрами(Макет, ИмяОбласти, ДанныеПечати, НомерИзменений = Неопределено)
	
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Область.Параметры.Заполнить(ДанныеПечати);
	
	Если НомерИзменений <> Неопределено Тогда
		Область.Параметры.НомерИзменений = НомерИзменений;
		НомерИзменений = НомерИзменений + 1;
	КонецЕсли;
	
	Возврат Область;
	
КонецФункции

Функция ОбластьСтрокаИзменений(Макет, НомерИзменений, ПунктДоговора, НазваниеРаздела)
	
	Область = Макет.ПолучитьОбласть("СтрокаИзменений");
	Область.Параметры.ПунктДоговора = ПунктДоговора;
	Область.Параметры.НазваниеРаздела = НазваниеРаздела;
	Область.Параметры.НомерИзменений = НомерИзменений;
	НомерИзменений = НомерИзменений + 1;
	
	Возврат Область;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли