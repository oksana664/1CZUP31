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


#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ об изменении тарифной сетки.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказОбИзмененииТарифнойСетки";
	КомандаПечати.Представление = НСтр("ru = 'Печать'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОбИзмененииТарифнойСетки") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм, 
						"ПФ_MXL_ПриказОбИзмененииТарифнойСетки", 
						НСтр("ru = 'Приказ об изменении тарифной группы'"), 
						ПечатнаяФормаПриказаОбИзмененииТарифнойСетки(МассивОбъектов, ОбъектыПечати), ,
						"Документ.РаботаСверхурочно.ПФ_MXL_ПриказОбИзмененииТарифнойСетки");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПриказаОбИзмененииТарифнойСетки(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриказОбИзмененииТарифнойСетки";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УтверждениеТарифнойСетки.ПФ_MXL_ПриказОбИзмененииТарифнойСетки");
	
	ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаРазряд 		= Макет.ПолучитьОбласть("ШапкаТаблицы|Разряд");
	ОбластьШапкаКоэффициент = Макет.ПолучитьОбласть("ШапкаТаблицы|Коэффициент");
	ОбластьШапкаТариф 		= Макет.ПолучитьОбласть("ШапкаТаблицы|Тариф");
	ОбластьСтрокаРазряд 	= Макет.ПолучитьОбласть("СтрокаТаблицы|Разряд");
	ОбластьСтрокаКоэффициент = Макет.ПолучитьОбласть("СтрокаТаблицы|Коэффициент");
	ОбластьСтрокаТариф 		= Макет.ПолучитьОбласть("СтрокаТаблицы|Тариф");
	ОбластьПодвал 	  		= Макет.ПолучитьОбласть("Подвал");
	
	ДанныеДляПечати = ДанныеДляПечатиПриказаОбИзмененииТарифнойСетки(МассивОбъектов);
	
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоСтрокам 	= ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТаблицаСотрудники = Новый ТаблицаЗначений;
	ТаблицаСотрудники.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудники.Колонки.Добавить("ФИО", Новый ОписаниеТипов("Строка"));
	ТаблицаСотрудники.Колонки.Добавить("Должность", Новый ОписаниеТипов("Строка"));
	ТаблицаСотрудники.Колонки.Добавить("ДатаДок", Новый ОписаниеТипов("Дата"));
	
	Пока ВыборкаПоДокументам.Следующий() Цикл  
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		НомерПункта = 0;
		ТаблицаСотрудники.Очистить();
		
		Параметры = ПолучитьСтруктуруПараметровПриказаОбИзмененииТарифнойСетки();
		КадровыйУчет.ЗаполнитьПараметрыКадровогоПриказа(Параметры, ВыборкаПоДокументам);
		
		Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
			
			Если ВыборкаПоДокументам.ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
				ПредставлениеВидаВРодительномПадеже = НСтр("ru='квалификационную надбавку'");
			Иначе
				ПредставлениеВидаВРодительномПадеже = НСтр("ru='профессиональную квалификационную группу'");
			КонецЕсли;
			
		Иначе
			
			Если ВыборкаПоДокументам.ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
				ПредставлениеВидаВРодительномПадеже = НСтр("ru='тарифную группу надбавок'");
			Иначе
				ПредставлениеВидаВРодительномПадеже = НСтр("ru='тарифную группу'");
			КонецЕсли;
			
		КонецЕсли;
		ОбластьШапка.Параметры.ПредставлениеВидаВРодительномПадеже = ПредставлениеВидаВРодительномПадеже;
		
		Параметры.ДатаВступленияВСилу = Формат(Параметры.ДатаВступленияВСилу, "ДЛФ=ДД");
		Параметры.ДатаДок = Формат(Параметры.ДатаДок, "ДЛФ=Д");
		
		ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, Параметры);
		ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, Параметры);
		
		ТабДокумент.Вывести(ОбластьШапка);
		
		ТабДокумент.Вывести(ОбластьШапкаРазряд);
		Если ВыборкаПоДокументам.ПрименениеТарифныхКоэффициентов Тогда 
			ТабДокумент.Присоединить(ОбластьШапкаКоэффициент);
		КонецЕсли;
		ТабДокумент.Присоединить(ОбластьШапкаТариф);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
		
		ВыборкаПоСтрокам.Сбросить();
		
		Пока ВыборкаПоСтрокам.НайтиСледующий(СтруктураПоиска) Цикл 
			
			ОбластьСтрокаРазряд.Параметры.Разряд = ВыборкаПоСтрокам.Разряд;
			ТабДокумент.Вывести(ОбластьСтрокаРазряд);
			
			Если ВыборкаПоДокументам.ПрименениеТарифныхКоэффициентов Тогда 
				ОбластьСтрокаКоэффициент.Параметры.РазрядныйКоэффициент = ВыборкаПоСтрокам.РазрядныйКоэффициент;
				ТабДокумент.Присоединить(ОбластьСтрокаКоэффициент);
			КонецЕсли;
			
			ОбластьСтрокаТариф.Параметры.Тариф = ВыборкаПоСтрокам.Тариф;
			ТабДокумент.Присоединить(ОбластьСтрокаТариф);
			
		КонецЦикла;
		
		ТабДокумент.Вывести(ОбластьПодвал);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
	
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции	

Функция ДанныеДляПечатиПриказаОбИзмененииТарифнойСетки(МассивОбъектов)
	
	// Запрос по шапкам документов.
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ТаблицаОрганизаций = Новый ТаблицаЗначений;
	ТаблицаОрганизаций.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ДокументСсылка.УтверждениеТарифнойСетки"));
	ТаблицаОрганизаций.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	РеквизитыДокументов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОбъектов, "ТарифнаяСетка,ДатаВступленияВСилу");
	Для каждого ДокументИзменения Из МассивОбъектов Цикл
		
		РеквизитыДокумента = РеквизитыДокументов.Получить(ДокументИзменения);
		СоздатьВТСотрудникиСОплатойПоТарифнойСетке(Запрос.МенеджерВременныхТаблиц, РеквизитыДокумента.ТарифнаяСетка, РеквизитыДокумента.ДатаВступленияВСилу);
		
		Запрос.УстановитьПараметр("ДокументИзменения", ДокументИзменения);
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	&ДокументИзменения КАК Ссылка,
			|	СотрудникиОрганизации.Организация
			|ИЗ
			|	ВТСотрудникиОрганизацииСПоказателями КАК СотрудникиОрганизации";
			
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Запрос.Выполнить().Выгрузить(), ТаблицаОрганизаций);
		
		Запрос.Текст = "УНИЧТОЖИТЬ ВТСотрудникиОрганизацииСПоказателями";
		Запрос.Выполнить();
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ТаблицаОрганизаций", ТаблицаОрганизаций);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТаблицаОрганизаций.Ссылка КАК Ссылка,
		|	ТаблицаОрганизаций.Организация КАК Организация
		|ПОМЕСТИТЬ ВТОрганизацииДокументов
		|ИЗ
		|	&ТаблицаОрганизаций КАК ТаблицаОрганизаций
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УтверждениеТарифнойСетки.Ссылка КАК Ссылка,
		|	УтверждениеТарифнойСетки.Дата КАК Дата,
		|	УтверждениеТарифнойСетки.Номер КАК Номер,
		|	УтверждениеТарифнойСетки.ТарифнаяСетка КАК ТарифнаяСетка,
		|	УтверждениеТарифнойСетки.ВидТарифнойСетки,
		|	УтверждениеТарифнойСетки.ДатаВступленияВСилу КАК ДатаВступленияВСилу,
		|	УтверждениеТарифнойСетки.ТарифнаяСетка.ПрименениеТарифныхКоэффициентов КАК ПрименениеТарифныхКоэффициентов,
		|	ЕСТЬNULL(ОрганизацииДокументов.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация,
		|	ВЫБОР
		|		КОГДА ОрганизацииДокументов.Организация ЕСТЬ NULL 
		|			ТОГДА """"
		|		КОГДА ПОДСТРОКА(ВЫРАЗИТЬ(ОрганизацииДокументов.Организация КАК Справочник.Организации).НаименованиеПолное, 1, 10) = """"
		|			ТОГДА ВЫРАЗИТЬ(ОрганизацииДокументов.Организация КАК Справочник.Организации).Наименование
		|		ИНАЧЕ ВЫРАЗИТЬ(ОрганизацииДокументов.Организация КАК Справочник.Организации).НаименованиеПолное
		|	КОНЕЦ КАК НазваниеОрганизации
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.УтверждениеТарифнойСетки КАК УтверждениеТарифнойСетки
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОрганизацииДокументов КАК ОрганизацииДокументов
		|		ПО УтверждениеТарифнойСетки.Ссылка = ОрганизацииДокументов.Ссылка
		|ГДЕ
		|	УтверждениеТарифнойСетки.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ЗарплатаКадрыРасширенный.СоздатьВТОтветственныеЛица(Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов", "Руководитель, ДолжностьРуководителя", "Дата");			   
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокументов.Номер КАК Номер,
		|	ДанныеДокументов.Дата КАК Дата,
		|	ДанныеДокументов.ТарифнаяСетка КАК ТарифнаяСетка,
		|	ДанныеДокументов.ВидТарифнойСетки КАК ВидТарифнойСетки,
		|	ДанныеДокументов.ДатаВступленияВСилу КАК ДатаВступленияВСилу,
		|	ДанныеДокументов.ПрименениеТарифныхКоэффициентов КАК ПрименениеТарифныхКоэффициентов,
		|	ДанныеДокументов.Организация КАК Организация,
		|	ДанныеДокументов.НазваниеОрганизации КАК НазваниеОрганизации,
		|	ДанныеДокументов.Дата КАК Период,
		|	ЕСТЬNULL(ОтветственныеЛица.Руководитель, ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)) КАК Руководитель,
		|	ЕСТЬNULL(ОтветственныеЛица.ДолжностьРуководителя, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК ДолжностьРуководителя
		|ПОМЕСТИТЬ ВТДанныеДокументовОтветственныеЛица
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтветственныеЛица КАК ОтветственныеЛица
		|		ПО ДанныеДокументов.Организация = ОтветственныеЛица.Организация
		|			И ДанныеДокументов.Дата = ОтветственныеЛица.Период";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументовОтветственныеЛица");
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокументов.Номер КАК НомерДок,
		|	ДанныеДокументов.Дата КАК ДатаДок,
		|	ДанныеДокументов.ТарифнаяСетка КАК ТарифнаяСетка,
		|	ДанныеДокументов.ВидТарифнойСетки КАК ВидТарифнойСетки,
		|	ДанныеДокументов.ДатаВступленияВСилу КАК ДатаВступленияВСилу,
		|	ДанныеДокументов.ПрименениеТарифныхКоэффициентов КАК ПрименениеТарифныхКоэффициентов,
		|	ДанныеДокументов.Организация КАК Организация,
		|	ДанныеДокументов.НазваниеОрганизации КАК НазваниеОрганизации,
		|	ДанныеДокументов.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
		|	ЕСТЬNULL(ФИООтветственныхЛиц.РасшифровкаПодписи, """") КАК РуководительРасшифровкаПодписи
		|ИЗ
		|	ВТДанныеДокументовОтветственныеЛица КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИООтветственныхЛиц
		|		ПО ДанныеДокументов.Руководитель = ФИООтветственныхЛиц.ФизическоеЛицо
		|			И ДанныеДокументов.Ссылка = ФИООтветственныхЛиц.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаДок,
		|	Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати = Новый Структура;
	ДанныеДляПечати.Вставить("РезультатПоШапке", РезультатЗапроса);
	
	// Запрос по табличным частям
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УтверждениеТарифнойСеткиТарифы.Ссылка КАК Ссылка,
		|	УтверждениеТарифнойСеткиТарифы.РазрядКатегория.Наименование КАК Разряд,
		|	УтверждениеТарифнойСеткиТарифы.РазрядныйКоэффициент КАК РазрядныйКоэффициент,
		|	УтверждениеТарифнойСеткиТарифы.Тариф КАК Тариф
		|ИЗ
		|	Документ.УтверждениеТарифнойСетки.Тарифы КАК УтверждениеТарифнойСеткиТарифы
		|ГДЕ
		|	УтверждениеТарифнойСеткиТарифы.Ссылка В(&МассивОбъектов)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	УтверждениеТарифнойСеткиТарифы.РазрядКатегория.РеквизитДопУпорядочивания";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПечати.Вставить("РезультатПоТабличнойЧасти", РезультатЗапроса);
	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ПолучитьСтруктуруПараметровПриказаОбИзмененииТарифнойСетки()
	
	Параметры = КадровыйУчет.ПараметрыКадровогоПриказа();
	
	Параметры.Вставить("ТарифнаяСетка");
	Параметры.Вставить("ДатаВступленияВСилу");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

Процедура СоздатьВТСотрудникиСОплатойПоТарифнойСетке(МенеджерВременныхТаблиц, ТарифнаяСетка, ДатаВступленияВСилу)
	
	ФОИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	ВидТарифнойСетки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТарифнаяСетка, "ВидТарифнойСетки");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	Показатели = РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Истина);
	Запрос.УстановитьПараметр("Показатели", Показатели);
	Запрос.УстановитьПараметр("ДатаВступленияВСилу", ДатаВступленияВСилу);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&ДатаВступленияВСилу КАК Период,
		|	НачисленияПоказатели.Ссылка КАК Начисление,
		|	НачисленияПоказатели.Показатель
		|ПОМЕСТИТЬ ВТНачисленияПериоды
		|ИЗ
		|	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
		|ГДЕ
		|	НачисленияПоказатели.Показатель В(&Показатели)";

	Запрос.Выполнить();
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТНачисленияПериоды", "Начисление"));
		
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыеНачисления.Период,
		|	ПлановыеНачисления.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТФизическиеЛица
		|ИЗ
		|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
		|ГДЕ
		|	ПлановыеНачисления.Используется
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПлановыеНачисления.Период,
		|	ПлановыеНачисления.Сотрудник,
		|	ПлановыеНачисления.ФизическоеЛицо
		|ПОМЕСТИТЬ ВТСотрудникиОтбор
		|ИЗ
		|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
		|ГДЕ
		|	ПлановыеНачисления.Используется
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТНачисленияПериоды
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТПлановыеНачисленияСрезПоследних";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		ПараметрыПостроения.Отборы, "Показатель", "В", Показатели);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТСотрудникиОтбор", "Сотрудник,ФизическоеЛицо"),
		ПараметрыПостроения,
		"ВТЗначенияПериодическихПоказателей");
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудников.НачалоПериода = ДатаВступленияВСилу;
	ПараметрыПолученияСотрудников.ОкончаниеПериода = ДатаВступленияВСилу;
	ПараметрыПолученияСотрудников.КадровыеДанные = "Организация,Подразделение,Должность,РазрядКатегория";
	
	Если ФОИспользоватьШтатноеРасписание Тогда
		ПараметрыПолученияСотрудников.КадровыеДанные = ПараметрыПолученияСотрудников.КадровыеДанные + ",ДолжностьПоШтатномуРасписанию";
	КонецЕсли;
	
	Если ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
		ПараметрыПолученияСотрудников.КадровыеДанные = ПараметрыПолученияСотрудников.КадровыеДанные + ",ТарифнаяСеткаНадбавки";
	Иначе
		ПараметрыПолученияСотрудников.КадровыеДанные = ПараметрыПолученияСотрудников.КадровыеДанные + ",ТарифнаяСетка";
	КонецЕсли;
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизации.Сотрудник,
		|	СотрудникиОрганизации.ФизическоеЛицо,
		|	СотрудникиОрганизации.Организация,
		|	СотрудникиОрганизации.Подразделение,
		|	СотрудникиОрганизации.Должность,
		|	СотрудникиОрганизации.РазрядКатегория,
		|	СотрудникиОрганизации.ТарифнаяСетка,
		|	МАКСИМУМ(ЗначенияПериодическихПоказателей.Значение) КАК Значение
		|ПОМЕСТИТЬ ВТСотрудникиОрганизацииСПоказателями
		|ИЗ
		|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗначенияПериодическихПоказателей КАК ЗначенияПериодическихПоказателей
		|		ПО СотрудникиОрганизации.Сотрудник = ЗначенияПериодическихПоказателей.Сотрудник
		|			И СотрудникиОрганизации.Организация = ЗначенияПериодическихПоказателей.Организация
		|
		|СГРУППИРОВАТЬ ПО
		|	СотрудникиОрганизации.Сотрудник,
		|	СотрудникиОрганизации.ФизическоеЛицо,
		|	СотрудникиОрганизации.Организация,
		|	СотрудникиОрганизации.Подразделение,
		|	СотрудникиОрганизации.Должность,
		|	СотрудникиОрганизации.ТарифнаяСетка,
		|	СотрудникиОрганизации.РазрядКатегория
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТФизическиеЛица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТСотрудникиОтбор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТЗначенияПериодическихПоказателей
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТСотрудникиОрганизации";
	
	Если ФОИспользоватьШтатноеРасписание Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.Должность,",
			"СотрудникиОрганизации.Должность,
			|	СотрудникиОрганизации.ДолжностьПоШтатномуРасписанию,");
	КонецЕсли;
	
	Если ВидТарифнойСетки = Перечисления.ВидыТарифныхСеток.Надбавка Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СотрудникиОрганизации.ТарифнаяСетка,",
			"СотрудникиОрганизации.ТарифнаяСеткаНадбавки,");
	КонецЕсли;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьСпособыОкругления() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	УтверждениеТарифнойСетки.Ссылка
		|ИЗ
		|	Документ.УтверждениеТарифнойСетки КАК УтверждениеТарифнойСетки
		|ГДЕ
		|	УтверждениеТарифнойСетки.СпособОкругления = ЗНАЧЕНИЕ(Справочник.СпособыОкругленияПриРасчетеЗарплаты.ПустаяСсылка)
		|	И УтверждениеТарифнойСетки.ТарифнаяСетка.ПрименениеТарифныхКоэффициентов";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		СпособОкругления = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			ОбъектДокумента.СпособОкругления = СпособОкругления;
			
			ОбъектДокумента.ОбменДанными.Загрузка = Истина;
			ОбъектДокумента.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьИзмененияПозицийШтатногоРасписанияПоДвижениям() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ИсторияИспользованияШтатногоРасписания.Регистратор
		|ПОМЕСТИТЬ ВТУтвержденияТарифныхГрупп
		|ИЗ
		|	РегистрСведений.ИсторияИспользованияШтатногоРасписания КАК ИсторияИспользованияШтатногоРасписания
		|ГДЕ
		|	ИсторияИспользованияШтатногоРасписания.Регистратор ССЫЛКА Документ.УтверждениеТарифнойСетки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	УтвержденияТарифныхГрупп.Регистратор
		|ИЗ
		|	ВТУтвержденияТарифныхГрупп КАК УтвержденияТарифныхГрупп";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	УтвержденияТарифныхГрупп.Регистратор КАК Регистратор,
			|	ВЫРАЗИТЬ(УтвержденияТарифныхГрупп.Регистратор КАК Документ.УтверждениеТарифнойСетки).Дата КАК Дата,
			|	ВЫРАЗИТЬ(УтвержденияТарифныхГрупп.Регистратор КАК Документ.УтверждениеТарифнойСетки).Ответственный КАК Ответственный,
			|	ВЫРАЗИТЬ(УтвержденияТарифныхГрупп.Регистратор КАК Документ.УтверждениеТарифнойСетки).Комментарий КАК Комментарий,
			|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания.Владелец КАК Организация,
			|	ИсторияИспользованияШтатногоРасписания.Дата КАК ДатаВступленияВСилу,
			|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания.Должность КАК Должность,
			|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания.Подразделение КАК Подразделение,
			|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания КАК Позиция,
			|	ИсторияНачисленийПоШтатномуРасписанию.Начисление,
			|	ИсторияИспользованияШтатногоРасписания.*,
			|	ИсторияНачисленийПоШтатномуРасписанию.*,
			|	ИсторияПоказателейПоШтатномуРасписанию.*
			|ИЗ
			|	ВТУтвержденияТарифныхГрупп КАК УтвержденияТарифныхГрупп
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияИспользованияШтатногоРасписания КАК ИсторияИспользованияШтатногоРасписания
			|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияНачисленийПоШтатномуРасписанию КАК ИсторияНачисленийПоШтатномуРасписанию
			|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияПоказателейПоШтатномуРасписанию КАК ИсторияПоказателейПоШтатномуРасписанию
			|				ПО ИсторияНачисленийПоШтатномуРасписанию.Регистратор = ИсторияПоказателейПоШтатномуРасписанию.Регистратор
			|					И ИсторияНачисленийПоШтатномуРасписанию.ПозицияШтатногоРасписания = ИсторияПоказателейПоШтатномуРасписанию.ПозицияШтатногоРасписания
			|					И ИсторияНачисленийПоШтатномуРасписанию.ИдентификаторСтрокиВидаРасчета = ИсторияПоказателейПоШтатномуРасписанию.ИдентификаторСтрокиВидаРасчета
			|			ПО ИсторияИспользованияШтатногоРасписания.Регистратор = ИсторияНачисленийПоШтатномуРасписанию.Регистратор
			|				И ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания = ИсторияНачисленийПоШтатномуРасписанию.ПозицияШтатногоРасписания
			|		ПО УтвержденияТарифныхГрупп.Регистратор = ИсторияИспользованияШтатногоРасписания.Регистратор
			|
			|УПОРЯДОЧИТЬ ПО
			|	Регистратор,
			|	Организация,
			|	ДатаВступленияВСилу,
			|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания.Подразделение.РеквизитДопУпорядочиванияИерархического,
			|	ИсторияИспользованияШтатногоРасписания.ПозицияШтатногоРасписания.Должность.РеквизитДопУпорядочивания,
			|	Позиция,
			|	Начисление.РеквизитДопУпорядочивания,
			|	Начисление";
			
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			СписокДокументовИзменениеШтатногоРасписания = Новый Массив;
		
			Пока Выборка.СледующийПоЗначениюПоля("Организация") Цикл
				
				Пока Выборка.СледующийПоЗначениюПоля("ДатаВступленияВСилу") Цикл
					
					ДокументИзменения = Документы.ИзменениеШтатногоРасписания.СоздатьДокумент();
					
					ДокументИзменения.Ответственный = Пользователи.ТекущийПользователь();
					УправлениеШтатнымРасписанием.ЗаполнитьПодписантовДокумента(ДокументИзменения, ДокументИзменения.ДатаВступленияВСилу, Ложь);
					
					ЗаполнитьЗначенияСвойств(ДокументИзменения, Выборка);
					
					ИдентификаторСтрокиПозиции = 1;
					Пока Выборка.СледующийПоЗначениюПоля("Позиция") Цикл
						
						СтрокаПозиции = ДокументИзменения.Позиции.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаПозиции, Выборка);
						
						СтрокаПозиции.ИдентификаторСтрокиПозиции = ИдентификаторСтрокиПозиции;
						
						Пока Выборка.СледующийПоЗначениюПоля("Начисление") Цикл
							
							СтрокаНачислений = ДокументИзменения.Начисления.Добавить();
							ЗаполнитьЗначенияСвойств(СтрокаНачислений, Выборка);
							
							СтрокаНачислений.ИдентификаторСтрокиПозиции = ИдентификаторСтрокиПозиции;
							
							Пока Выборка.Следующий() Цикл
								
								СтрокаПоказателей = ДокументИзменения.Показатели.Добавить();
								ЗаполнитьЗначенияСвойств(СтрокаПоказателей, Выборка);
								
								СтрокаПоказателей.ИдентификаторСтрокиПозиции = ИдентификаторСтрокиПозиции;
								
							КонецЦикла;
							
						КонецЦикла;
						
						ИдентификаторСтрокиПозиции = ИдентификаторСтрокиПозиции + 1;
						
					КонецЦикла;
					
					ДокументИзменения.Записать(РежимЗаписиДокумента.Запись);
					СписокДокументовИзменениеШтатногоРасписания.Добавить(ДокументИзменения);
					
				КонецЦикла;
				
			КонецЦикла;
			
			// Очистка движений по регистру сведений ИсторияИспользованияШтатногоРасписания
			НаборЗаписей = РегистрыСведений.ИсторияИспользованияШтатногоРасписания.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Записать();
			
			// Очистка движений по регистру сведений ИсторияНачисленийПоШтатномуРасписанию
			НаборЗаписей = РегистрыСведений.ИсторияНачисленийПоШтатномуРасписанию.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Записать();
			
			// Очистка движений по регистру сведений ИсторияПоказателейПоШтатномуРасписанию
			НаборЗаписей = РегистрыСведений.ИсторияПоказателейПоШтатномуРасписанию.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Записать();
			
			Для каждого ДокументИзменения Из СписокДокументовИзменениеШтатногоРасписания Цикл
				
				УправлениеШтатнымРасписанием.ДокументыОбработкаПроведения(
					ДокументИзменения, Ложь, РежимПроведенияДокумента.Неоперативный, Неопределено, ДокументИзменения.ДатаВступленияВСилу);
				
				ДокументИзменения.Проведен = Истина;
				ДокументИзменения.Записать(РежимЗаписиДокумента.Запись);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИзменениеПлановыхНачисленийСотрудниковПоДвижениям() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Регистратор
		|ПОМЕСТИТЬ ВТРегистраторы
		|ИЗ
		|	РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников
		|ГДЕ
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Регистратор ССЫЛКА Документ.УтверждениеТарифнойСетки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Регистраторы.Регистратор
		|ИЗ
		|	ВТРегистраторы КАК Регистраторы";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор КАК Регистратор,
			|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Организация КАК Организация,
			|	ВЫРАЗИТЬ(Регистраторы.Регистратор КАК Документ.УтверждениеТарифнойСетки).Дата КАК Дата,
			|	ВЫРАЗИТЬ(Регистраторы.Регистратор КАК Документ.УтверждениеТарифнойСетки).ДатаВступленияВСилу КАК ДатаИзменения,
			|	ВЫРАЗИТЬ(Регистраторы.Регистратор КАК Документ.УтверждениеТарифнойСетки).Ответственный КАК Ответственный,
			|	ВЫРАЗИТЬ(Регистраторы.Регистратор КАК Документ.УтверждениеТарифнойСетки).Комментарий КАК Комментарий,
			|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Сотрудник КАК Сотрудник,
			|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Показатель,
			|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Значение
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников
			|		ПО Регистраторы.Регистратор = ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Регистратор
			|
			|УПОРЯДОЧИТЬ ПО
			|	Регистратор,
			|	Организация,
			|	Сотрудник";
			
		Выборка = Запрос.Выполнить().Выбрать();
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор,
			|	ПлановыеНачисления.Сотрудник,
			|	ПлановыеНачисления.Начисление,
			|	ПлановыеНачисления.Размер
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисления КАК ПлановыеНачисления
			|		ПО Регистраторы.Регистратор = ПлановыеНачисления.Регистратор
			|ГДЕ
			|	ПлановыеНачисления.Используется
			|	И НЕ ПлановыеНачисления.ВторичнаяЗапись";
			
		ТаблицаНачислений = Запрос.Выполнить().Выгрузить();
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	Регистраторы.Регистратор,
			|	ЗначенияСовокупныхТарифныхСтавокСотрудников.Сотрудник,
			|	ЗначенияСовокупныхТарифныхСтавокСотрудников.СовокупнаяТарифнаяСтавка КАК СовокупнаяТарифнаяСтавка,
			|	ЗначенияСовокупныхТарифныхСтавокСотрудников.ВидТарифнойСтавки
			|ИЗ
			|	ВТРегистраторы КАК Регистраторы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыйФОТИтоги КАК ЗначенияСовокупныхТарифныхСтавокСотрудников
			|		ПО Регистраторы.Регистратор = ЗначенияСовокупныхТарифныхСтавокСотрудников.РегистраторСобытия";
			
		ТаблицаСтавок = Запрос.Выполнить().Выгрузить();
		
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			СписокДокументовИзменениеПлановыхНачислений = Новый Массив;
		
			Пока Выборка.СледующийПоЗначениюПоля("Организация") Цикл
				
				ДокументИзменения = Документы.ИзменениеПлановыхНачислений.СоздатьДокумент();
				ЗаполнитьЗначенияСвойств(ДокументИзменения, Выборка);
				
				МаксимальныйИдентификаторСтрокиСотрудника = 0;
				Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
					
					МаксимальныйИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника + 1;
					Пока Выборка.Следующий() Цикл
						
						СтрокаПоказателя = ДокументИзменения.ПоказателиСотрудников.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаПоказателя, Выборка);
						СтрокаПоказателя.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
						
					КонецЦикла; 
					
					СтруктураПоиска = Новый Структура("Регистратор,Сотрудник");
					ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
					
					НачисленияСотрудника = ТаблицаНачислений.НайтиСтроки(СтруктураПоиска);
					Для каждого НачислениеСотрудника Из НачисленияСотрудника Цикл
						
						СтрокаНачисления = ДокументИзменения.НачисленияСотрудников.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаНачисления, НачислениеСотрудника);
						СтрокаНачисления.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
						
					КонецЦикла;
					
					СтавкиСотрудника = ТаблицаСтавок.НайтиСтроки(СтруктураПоиска);
					Для каждого СтавкаСотрудника Из СтавкиСотрудника Цикл
						
						СтрокаСтавки = ДокументИзменения.Сотрудники.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаСтавки, СтавкаСотрудника);
						СтрокаСтавки.ДатаИзменения = Выборка.ДатаИзменения;
						СтрокаСтавки.ИдентификаторСтрокиСотрудника = МаксимальныйИдентификаторСтрокиСотрудника;
						
					КонецЦикла;
					
				КонецЦикла;
				
				ДокументИзменения.Записать(РежимЗаписиДокумента.Запись);
				СписокДокументовИзменениеПлановыхНачислений.Добавить(ДокументИзменения);
				
			КонецЦикла;
			
			// Очистка движений по регистру сведений ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.
			НаборЗаписей = РегистрыСведений.ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Записать();
			
			// Очистка движений по регистру сведений ПлановыеНачисления
			НаборЗаписей = РегистрыСведений.ПлановыеНачисления.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Записать();
			
			// Очистка движений по регистру сведений ЗначенияСовокупныхТарифныхСтавокСотрудников.
			НаборЗаписей = РегистрыСведений.УдалитьЗначенияСовокупныхТарифныхСтавокСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
			НаборЗаписей.Записать();
			
			Для каждого ДокументИзменения Из СписокДокументовИзменениеПлановыхНачислений Цикл
				ДокументИзменения.Записать(РежимЗаписиДокумента.Проведение);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
