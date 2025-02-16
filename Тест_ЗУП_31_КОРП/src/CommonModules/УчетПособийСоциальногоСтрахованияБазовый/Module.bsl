#Область СлужебныйПрограммныйИнтерфейс

// Заполняет табличные части документа "ИсходящаяСправкаОЗаработкеДляРасчетаПособий".
//
// Параметры:
//  Объект -  ДокументОбъект.ИсходящаяСправкаОЗаработкеДляРасчетаПособий
//  ПараметрыЗаполнения - см. ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия.
//  
// Возвращаемое значение:
//	Истина, если данные в объекте были обновлены.
//
Функция ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(Объект, ПараметрыЗаполнения) Экспорт
	
	Если ПараметрыЗаполнения.Обновление Тогда
		
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		СоздатьВТДанныеОЗаработкеДляЗаполнения(МенеджерВременныхТаблиц, ПараметрыЗаполнения);
		Модифицирован = ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(МенеджерВременныхТаблиц, Объект, "ДанныеОЗаработке", "ВТДанныеОЗаработкеДляЗаполнения");
		
	Иначе
		
		Объект.ДанныеОЗаработке.Загрузить(ДанныеОЗаработкеДляЗаполнения(ПараметрыЗаполнения));
		Модифицирован = Истина;
		
	КонецЕсли;
	
	Возврат Модифицирован; 
	
КонецФункции

// Формирует параметры для создания временных таблиц используемых для заполнения справки о заработке для расчета
// пособий.
//
// Параметры:
//  Объект - ДокументОбъект.СправкаОЗаработкеДляРасчетаПособий.
//
// Возвращаемое значение:
//    Структура:
//		ГодНачало
//		ГодОкончание
//		Сотрудник
//		Организация
//      ПоВсемОП - данные по Организации или по ГоловнойОрганизации.
//      Обновление - учитывать ли зафиксированные в документе реквизиты.
//      РасчетныеГоды - отбор заполняемых лет, входящих в период между ГодНачало и ГодОкончание.
//      ОграничиватьРазмерЗаработка - применять ли ограничение базой страховых взносов.
//
Функция ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия(Объект = Неопределено) Экспорт
	ПараметрыЗаполненияСправки = Новый Структура("ГодНачала, ГодОкончания, Сотрудник, Организация, ПоВсемОП, Обновление, РасчетныеГоды, ОграничиватьРазмерЗаработка");
	ПараметрыЗаполненияСправки.ПоВсемОП = Ложь;
	ПараметрыЗаполненияСправки.Обновление = Ложь;
	ПараметрыЗаполненияСправки.РасчетныеГоды = Неопределено;
	ПараметрыЗаполненияСправки.ОграничиватьРазмерЗаработка = Истина;
	Возврат ПараметрыЗаполненияСправки
КонецФункции

// Возвращает таблицу с данными о заработке сотрудника по годам.
//
// Параметры:
//  ПараметрыЗаполнения - Структура, состав см. в
//                        УчетПособийСоциальногоСтрахования.ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия.
//  
// Возвращаемое значение:
//  Таблица значений с колонками:
//		РасчетныйГод	
//		Заработок	
//			
Функция ДанныеОЗаработкеДляЗаполнения(ПараметрыЗаполнения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеОЗаработкеДляЗаполнения(Запрос.МенеджерВременныхТаблиц, ПараметрыЗаполнения);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеОЗаработкеДляЗаполнения.РасчетныйГод,
	|	ДанныеОЗаработкеДляЗаполнения.Заработок
	|ИЗ
	|	ВТДанныеОЗаработкеДляЗаполнения КАК ДанныеОЗаработкеДляЗаполнения";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Возвращает массив ссылок из ПВР Начисления, соответствующих облагаемым взносами компенсациям, возмещаемым из бюджета ФСС 
// (в частности, оплата 4-х дополнительных выходных дней для ухода за детьми инвалидами).
//
// Параметры:
//	нет
// 
// Возвращаемое значение:
//	Массив
// 
Функция НачисленияОблагаемыхВзносамиПособий() Экспорт

	Возврат Новый Массив()
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТДанныеОЗаработкеДляЗаполнения(МенеджерВременныхТаблиц, ПараметрыЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыЗаполнения.Сотрудник, "ФизическоеЛицо"));
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(ПараметрыЗаполнения.Организация));
	Запрос.УстановитьПараметр("ОграничиватьРазмерЗаработка", ПараметрыЗаполнения.ОграничиватьРазмерЗаработка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&ФизическоеЛицо КАК ФизическоеЛицо,
		|	&ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ПОМЕСТИТЬ ВТФизЛицаОрганизаций";
		
	Запрос.Выполнить();
	
	УчетСтраховыхВзносов.СформироватьВТРасширенныеСведенияОДоходахИВзносах(Дата(ПараметрыЗаполнения.ГодНачала, 1, 1), КонецГода(Дата(ПараметрыЗаполнения.ГодОкончания, 1, 1)), ПараметрыЗаполнения.Организация, Запрос.МенеджерВременныхТаблиц, Истина, , , , Истина);
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ГОД(СведенияОДоходах.Период) КАК РасчетныйГод,
		|	СУММА(СведенияОДоходах.БазаФСС - СведенияОДоходах.СуммаПревысившаяПределФСС) КАК Заработок
		|ПОМЕСТИТЬ ВТДанныеОЗаработкеБезОграничения
		|ИЗ
		|	ВТРасширенныеСведенияОДоходах КАК СведенияОДоходах
		|ГДЕ
		|	&ОтборПоОрганизации
		|
		|СГРУППИРОВАТЬ ПО
		|	ГОД(СведенияОДоходах.Период)
		|
		|ИМЕЮЩИЕ
		|	СУММА(СведенияОДоходах.БазаФСС - СведенияОДоходах.СуммаПревысившаяПределФСС) <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеОЗаработке.РасчетныйГод,
		|	СУММА(ВЫБОР
		|			КОГДА ДанныеОЗаработке.Заработок >= ПредельнаяВеличинаБазыСтраховыхВзносов.РазмерФСС
		|					И &ОграничиватьРазмерЗаработка
		|				ТОГДА ПредельнаяВеличинаБазыСтраховыхВзносов.РазмерФСС
		|			ИНАЧЕ ДанныеОЗаработке.Заработок
		|		КОНЕЦ) КАК Заработок
		|ПОМЕСТИТЬ ВТДанныеОЗаработкеДляЗаполнения
		|ИЗ
		|	(ВЫБРАТЬ
		|		МАКСИМУМ(ПредельнаяВеличинаБазыСтраховыхВзносов.Период) КАК Период,
		|		ДанныеОЗаработке.РасчетныйГод КАК РасчетныйГод,
		|		ДанныеОЗаработке.Заработок КАК Заработок
		|	ИЗ
		|		ВТДанныеОЗаработкеБезОграничения КАК ДанныеОЗаработке
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредельнаяВеличинаБазыСтраховыхВзносов КАК ПредельнаяВеличинаБазыСтраховыхВзносов
		|			ПО (ДанныеОЗаработке.РасчетныйГод >= ГОД(ПредельнаяВеличинаБазыСтраховыхВзносов.Период))
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеОЗаработке.РасчетныйГод,
		|		ДанныеОЗаработке.Заработок) КАК ДанныеОЗаработке
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПредельнаяВеличинаБазыСтраховыхВзносов КАК ПредельнаяВеличинаБазыСтраховыхВзносов
		|		ПО ДанныеОЗаработке.Период = ПредельнаяВеличинаБазыСтраховыхВзносов.Период
		|ГДЕ
		|	ДанныеОЗаработке.РасчетныйГод В(&РасчетныеГоды)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеОЗаработке.РасчетныйГод";
	
	Если ПараметрыЗаполнения.ПоВсемОП Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ОтборПоОрганизации","Истина");
	Иначе		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ОтборПоОрганизации","СведенияОДоходах.Организация = &Организация");
		Запрос.УстановитьПараметр("Организация", ПараметрыЗаполнения.Организация);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.РасчетныеГоды = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеОЗаработке.РасчетныйГод В(&РасчетныеГоды)", "ИСТИНА");	
	Иначе
		Запрос.УстановитьПараметр("РасчетныеГоды", ПараметрыЗаполнения.РасчетныеГоды);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса; 
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьВБольничныхЛистахДолюНеполногоРабочегоВремени(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1000
	|	БольничныйЛист.Ссылка
	|ИЗ
	|	Документ.БольничныйЛист КАК БольничныйЛист
	|ГДЕ
	|	БольничныйЛист.ДоляНеполногоВремени = 0";
	
	Результат = Запрос.Выполнить();
	ОбработкаЗавершена = Результат.Пустой();
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(
		Параметры,
		"ОбработкаЗавершена",
		ОбработкаЗавершена);
	Если ОбработкаЗавершена Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				Параметры,
				Выборка.Ссылка.Метаданные().ПолноеИмя(),
				"Ссылка",
				Выборка.Ссылка) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
		ОбъектДокумента.ДоляНеполногоВремени = 1;
		ОбъектДокумента.ОбменДанными.Загрузка = Истина;
		ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		ОбъектДокумента.Записать();
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(Параметры);
	КонецЦикла;
	
КонецПроцедуры

// См. УчетПособийСоциальногоСтрахования.ПриЗаписиКонстантыИспользоватьНачислениеЗарплаты.
Процедура ПриЗаписиКонстантыИспользоватьНачислениеЗарплаты(КонстантаОбъект) Экспорт
	// Действие не требуется.
КонецПроцедуры

#Область ПолучениеДанныхДляРасчетаСреднегоЗаработкаПоДокументу

// Создает временную таблицу с реквизитами документов необходимыми для формирования
// структуры параметров расчета среднего заработка ФСС.
//
// Параметры:
//  МенеджерВременныхТаблиц	 - менеджер временных таблиц, куда будет помещена временная таблица ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС 
//  МассивСсылок			 - массив ссылок, по которым необходимо получить данные, допустимые типы элементов - "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком".
//
Процедура СоздатьВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(МенеджерВременныхТаблиц, МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.УстановитьПараметр("ДатаОтдельногоРасчетаПособийПоМатеринству", УчетПособийСоциальногоСтрахованияКлиентСервер.ДатаОтдельногоРасчетаПособийПоМатеринству());

	Запрос.Текст =   
	"ВЫБРАТЬ
	|	БольничныйЛист.Ссылка,
	|	БольничныйЛист.Сотрудник,
	|	БольничныйЛист.ДатаНачалаСобытия КАК ДатаНачалаСобытия,
	|	ВЫБОР
	|		КОГДА БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ТравмаНаПроизводстве)
	|				ИЛИ БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.Профзаболевание)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПрименятьПредельнуюВеличину,
	|	ВЫБОР
	|		КОГДА БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ПоБеременностиИРодам)
	|				И БольничныйЛист.ПериодРегистрации >= &ДатаОтдельногоРасчетаПособийПоМатеринству
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьДниБолезниУходаЗаДетьми,
	|	БольничныйЛист.ПериодРасчетаСреднегоЗаработкаПервыйГод,
	|	БольничныйЛист.ПериодРасчетаСреднегоЗаработкаВторойГод,
	|	БольничныйЛист.РайонныйКоэффициентРФНаНачалоСобытия КАК РайонныйКоэффициентРФ,
	|	БольничныйЛист.ДоляНеполногоВремени
	|ПОМЕСТИТЬ ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ
	|ИЗ
	|	Документ.БольничныйЛист КАК БольничныйЛист
	|ГДЕ
	|	БольничныйЛист.Ссылка В(&МассивСсылок)";	
	
	Запрос.Выполнить();
	
	ОписаниеФильтра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ");
	ОписаниеФильтра.СоответствиеИзмеренийРегистраИзмерениямФильтра.Вставить("Период", "ДатаНачалаСобытия");

	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"МинимальнаяОплатаТрудаРФ",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ОписаниеФильтра,
		,
		"ВТМинимальнаяОплатаТруда");
		
	Запрос.Текст =   
	"ВЫБРАТЬ
	|	ДанныеДокументаРасчетаСреднего.Ссылка,
	|	ДанныеДокументаРасчетаСреднего.Сотрудник,
	|	ДанныеДокументаРасчетаСреднего.ДатаНачалаСобытия,
	|	ДанныеДокументаРасчетаСреднего.ПрименятьПредельнуюВеличину,
	|	ДанныеДокументаРасчетаСреднего.ИспользоватьДниБолезниУходаЗаДетьми,
	|	ДанныеДокументаРасчетаСреднего.ПериодРасчетаСреднегоЗаработкаПервыйГод,
	|	ДанныеДокументаРасчетаСреднего.ПериодРасчетаСреднегоЗаработкаВторойГод,
	|	ДанныеДокументаРасчетаСреднего.РайонныйКоэффициентРФ,
	|   ДанныеДокументаРасчетаСреднего.ДоляНеполногоВремени,
	|	МинимальнаяОплатаТруда.Размер КАК МинимальныйРазмерОплатыТрудаРФ
	|ПОМЕСТИТЬ ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС
	|ИЗ
	|	ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ КАК ДанныеДокументаРасчетаСреднего
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТМинимальнаяОплатаТруда КАК МинимальнаяОплатаТруда
	|		ПО ДанныеДокументаРасчетаСреднего.ДатаНачалаСобытия = МинимальнаяОплатаТруда.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФССБезМРОТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТМинимальнаяОплатаТруда";	
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Функция - Таблицы данных среднего заработка ФСС
//
// Параметры:
//  ИмяДокумента - Строка, имя документа для которого надо получить данные для расчета среднего заработка
//  МассивСсылок - массив, "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком".
// 
// Возвращаемое значение:
//  ДанныеДляРасчета - структура, содержит поля с таблицами данных для расчета среднего заработка по МассивСсылок 
//					ДанныеОНачислениях, Таблица значений	
//					ДанныеОВремени, Таблица значений	
//					ДанныеСтрахователей, Таблица значений.
//
Функция ТаблицыДанныхСреднегоЗаработкаФСС(ИмяДокумента, МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СреднийЗаработокФСС.Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетаСреднегоЗаработкаФСС.Постановление2011) КАК ПорядокРасчета,
	|	СреднийЗаработокФСС.ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
	|	ЗНАЧЕНИЕ(Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка) КАК СпособОтраженияЗарплатыВБухучете,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиРасходовЗарплата.ПустаяСсылка) КАК СтатьяРасходов,
	|	ЛОЖЬ КАК ОблагаетсяЕНВД,
	|	СреднийЗаработокФСС.Период,
	|	СреднийЗаработокФСС.Сумма
	|ИЗ
	|	Документ.#ИмяДокумента#.СреднийЗаработокФСС КАК СреднийЗаработокФСС
	|ГДЕ
	|	СреднийЗаработокФСС.Ссылка В(&МассивСсылок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтработанноеВремяДляСреднегоФСС.Ссылка,
	|	ОтработанноеВремяДляСреднегоФСС.ФизическоеЛицо,
	|	ОтработанноеВремяДляСреднегоФСС.Период,
	|	ОтработанноеВремяДляСреднегоФСС.ДнейБолезниУходаЗаДетьми
	|ИЗ
	|	Документ.#ИмяДокумента#.ОтработанноеВремяДляСреднегоФСС КАК ОтработанноеВремяДляСреднегоФСС
	|ГДЕ
	|	ОтработанноеВремяДляСреднегоФСС.Ссылка В(&МассивСсылок)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяДокумента#", ИмяДокумента);
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДанныеОНачислениях 	= Результат[0].Выгрузить();
	ДанныеВремени 		= Результат[1].Выгрузить();
	ДанныеСтрахователей	= УчетПособийСоциальногоСтрахования.ПустаяТаблицаДанныеСтрахователейСреднийЗаработокФСС();
	
	ДанныеДляРасчета 	= Новый Структура("ДанныеОНачислениях,ДанныеОВремени,ДанныеСтрахователей", ДанныеОНачислениях, ДанныеВремени, ДанныеСтрахователей);
	
	Возврат ДанныеДляРасчета;
	
КонецФункции 

Функция ОписаниеТипаСтраховательСреднийЗаработокФСС() Экспорт
	Возврат Новый ОписаниеТипов("СправочникСсылка.Организации");
КонецФункции 

#КонецОбласти 

#КонецОбласти

