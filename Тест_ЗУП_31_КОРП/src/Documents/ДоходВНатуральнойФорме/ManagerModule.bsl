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


// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.ДоходВНатуральнойФорме - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.ДоходВНатуральнойФорме - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(ДокументСсылка, Движения, РежимПроведения, Отказ, РеквизитыДляПроведения, СтруктураВидовУчета, Объект, "МесяцНачисления");
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда

		ДатаОперации = УчетНДФЛРасширенный.ДатаОперацииПоДокументу(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.МесяцНачисления);
		
		// Начисления
		РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.ПоказателиНачислений, Истина);
		
		РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
		
		// - Регистрация бухучета начислений, выполняется до вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
			ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено, Неопределено, Истина);
		
		// НДФЛ
		УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПоВременнойТаблицеНачислений(РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация,
			РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.МесяцНачисления, Перечисления.ХарактерВыплатыЗарплаты.Межрасчет, РеквизитыДляПроведения.ДатаПолученияДохода, ДанныеДляПроведения, Истина);
		
		// КорректировкиВыплаты
		РасчетЗарплатыРасширенный.СформироватьДвиженияКорректировкиВыплатыПоВременнойТаблицеНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, Перечисления.ХарактерВыплатыЗарплаты.Межрасчет, ДанныеДляПроведения, Истина);
		
		// Учет начисленной зарплаты
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.Начисления,
			Неопределено, Неопределено, ДанныеДляПроведения.ПрочиеДоходы, Неопределено);
		
		// - Регистрация бухучета НДФЛ, выполняется после вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
			Неопределено, Неопределено, ДанныеДляПроведения.НДФЛПоСотрудникам, Истина);
			
		// Страховые взносы
		УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);
	
		ПерерасчетЗарплаты.УдалениеПерерасчетовПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		
	КонецЕсли;

	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда

		// Учет среднего заработка
		УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
		
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.ОтменаДокумента Тогда
		
		РасчетЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		ОтражениеЗарплатыВБухучетеРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		УчетНДФЛРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
		УчетНачисленнойЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		УчетСтраховыхВзносовРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
		УчетСреднегоЗаработка.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		
		ИсправлениеДокументовЗарплатаКадры.СторнироватьДвиженияБезСпецификиУчетов(Движения, ИсправленныйДокумент, Ложь);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ДоходВНатуральнойФорме;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ДоходВНатуральнойФорме);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Ведомость получения материальных ценностей.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.ДоходВНатуральнойФорме";
	КомандаПечати.Идентификатор = "ПФ_MXL_ВедомостьПолученияМатериальныхЦенностей";
	КомандаПечати.Представление = НСтр("ru = 'Ведомость получения материальных ценностей'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	
	// Ведомость выдачи натуральной оплаты (415-АПК).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.ДоходВНатуральнойФорме";
	КомандаПечати.Идентификатор = "ПФ_MXL_415АПК";
	КомандаПечати.Представление = НСтр("ru = 'Ведомость выдачи натуральной оплаты (415-АПК)'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);

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
	
	НужноПечататьВедомость = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ВедомостьПолученияМатериальныхЦенностей");
	
	Если НужноПечататьВедомость Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ВедомостьПолученияМатериальныхЦенностей",
			НСтр("ru = 'Ведомость получения материальных ценностей'"), ПечатьВедомости(МассивОбъектов, ОбъектыПечати), ,
			"Документ.ДоходВНатуральнойФорме.ПФ_MXL_ВедомостьПолученияМатериальныхЦенностей");
	КонецЕсли;
	
	НужноПечатать415АПК = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_415АПК");
	
	Если НужноПечатать415АПК Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_415АПК",
			НСтр("ru = 'Ведомость выдачи натуральной оплаты (415-АПК)'"), Печать415АПК(МассивОбъектов, ОбъектыПечати), ,
			"Документ.ДоходВНатуральнойФорме.ПФ_MXL_415АПК");
	КонецЕсли;
						
КонецПроцедуры								

Функция ПечатьВедомости(МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДоходВНатуральнойФорме_ВедомостьПолученияМатериальныхЦенностей";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДоходВНатуральнойФорме.ПФ_MXL_ВедомостьПолученияМатериальныхЦенностей");
	
	ОбластьШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ВыводимыеОбласти = Новый Массив();
	ВыводимыеОбласти.Добавить(ОбластьСтрока);
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;		
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапкаДокумента.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьШапкаДокумента.Параметры.Дата = Формат(ДанныеПечати.Значение.Дата, "ДЛФ=D");
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ОбластьШапкаДокумента.Параметры.Подразделение) Тогда
			ОбластьШапкаДокумента.Параметры.Подразделение = ОбластьШапкаДокумента.Параметры.Подразделение.ПолноеНаименование();
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьШапкаДокумента);
		
		ОбластьШапка.Параметры.Заполнить(ДанныеПечати.Значение);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Для Каждого ДанныеСотрудника Из ДанныеПечати.Значение.ДанныеСотрудников Цикл
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьШапка);
			КонецЕсли;
			
			ОбластьСтрока.Параметры.Заполнить(ДанныеСотрудника);			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
	
		КонецЦикла;

		ОбластьПодвал.Параметры.Заполнить(ДанныеПечати.Значение);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ключ);
		
	КонецЦикла;	
						
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция Печать415АПК(МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДоходВНатуральнойФорме_415АПК";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДоходВНатуральнойФорме.ПФ_MXL_415АПК");
	
	ОбластьШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ВыводимыеОбласти = Новый Массив();
	ВыводимыеОбласти.Добавить(ОбластьСтрока);
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;		
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапкаДокумента.Параметры.Заполнить(ДанныеПечати.Значение);
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ОбластьШапкаДокумента.Параметры.Подразделение) Тогда
			ОбластьШапкаДокумента.Параметры.Подразделение = ОбластьШапкаДокумента.Параметры.Подразделение.ПолноеНаименование();
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьШапкаДокумента);
		
		ОбластьШапка.Параметры.Заполнить(ДанныеПечати.Значение);
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Для Каждого ДанныеСотрудника Из ДанныеПечати.Значение.ДанныеСотрудников Цикл
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			Если Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьШапка);
			КонецЕсли;
			
			ОбластьСтрока.Параметры.Заполнить(ДанныеСотрудника);			
			ТабличныйДокумент.Вывести(ОбластьСтрока);
	
		КонецЦикла;

		ОбластьПодвал.Параметры.Заполнить(ДанныеПечати.Значение);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ключ);
		
	КонецЦикла;	
						
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоходВНатуральнойФорме.Ссылка,
	|	ДоходВНатуральнойФорме.Номер,
	|	ДоходВНатуральнойФорме.Дата,
	|	ДоходВНатуральнойФорме.Организация КАК НазваниеОрганизации,
	|	ДоходВНатуральнойФорме.Организация.КодПоОКПО КАК ОКПО,
	|	ДоходВНатуральнойФорме.Подразделение,
	|	ДоходВНатуральнойФорме.Начислено КАК СуммаПоДокументу,
	|	ДоходВНатуральнойФорме.Руководитель,
	|	ДоходВНатуральнойФорме.ДолжностьРуководителя,
	|	ДоходВНатуральнойФорме.ГлавныйБухгалтер,
	|	ДоходВНатуральнойФорме.Исполнитель,
	|	ДоходВНатуральнойФорме.ДолжностьИсполнителя
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	Документ.ДоходВНатуральнойФорме КАК ДоходВНатуральнойФорме
	|ГДЕ
	|	ДоходВНатуральнойФорме.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, "Руководитель,ГлавныйБухгалтер,Исполнитель", "ВТДанныеДокумента");
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоходВНатуральнойФорме.Ссылка,
	|	ДоходВНатуральнойФорме.Номер,
	|	ДоходВНатуральнойФорме.Дата,
	|	ДоходВНатуральнойФорме.НазваниеОрганизации,
	|	ДоходВНатуральнойФорме.ОКПО,
	|	ДоходВНатуральнойФорме.Подразделение,
	|	ДоходВНатуральнойФорме.СуммаПоДокументу,
	|	ФИОРуководителя.РасшифровкаПодписи КАК РуководительРасшифровкаПодписи,
	|	ДоходВНатуральнойФорме.ДолжностьРуководителя,
	|	ФИОГлавногоБухгалтера.РасшифровкаПодписи КАК ГлавныйБухгалтерРасшифровкаПодписи,
	|	ФИОИсполнителя.РасшифровкаПодписи КАК ИсполнительРасшифровкаПодписи,
	|	ДоходВНатуральнойФорме.ДолжностьИсполнителя
	|ИЗ
	|	ВТДанныеДокумента КАК ДоходВНатуральнойФорме
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОРуководителя
	|		ПО ДоходВНатуральнойФорме.Ссылка = ФИОРуководителя.Ссылка
	|			И ДоходВНатуральнойФорме.Руководитель = ФИОРуководителя.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОГлавногоБухгалтера
	|		ПО ДоходВНатуральнойФорме.Ссылка = ФИОГлавногоБухгалтера.Ссылка
	|			И ДоходВНатуральнойФорме.ГлавныйБухгалтер = ФИОГлавногоБухгалтера.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОИсполнителя
	|		ПО ДоходВНатуральнойФорме.Ссылка = ФИОИсполнителя.Ссылка
	|			И ДоходВНатуральнойФорме.Исполнитель = ФИОИсполнителя.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоходВНатуральнойФормеДоходы.Ссылка,
	|	ДоходВНатуральнойФормеДоходы.НомерСтроки КАК НомерСтроки,
	|	ДоходВНатуральнойФормеДоходы.Сотрудник,
	|	ДоходВНатуральнойФормеДоходы.Сотрудник.Код КАК ТабельныйНомер,
	|	ДоходВНатуральнойФормеДоходы.Результат КАК Сумма
	|ИЗ
	|	Документ.ДоходВНатуральнойФорме.Начисления КАК ДоходВНатуральнойФормеДоходы
	|ГДЕ
	|	ДоходВНатуральнойФормеДоходы.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ДокументыДляПечати = РезультатыЗапроса[0].Выгрузить();
	СтрокиДокументов = РезультатыЗапроса[1].Выгрузить();
	
	Для Каждого ДокументДляПечати Из ДокументыДляПечати Цикл
		
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ДокументДляПечати);
		
		// Заполнение строк по сотрудникам.
		ДанныеСотрудников = СтрокиДокументов.НайтиСтроки(Новый Структура("Ссылка", ДанныеПечати.Ссылка));
		ДанныеПечати.Вставить("ДанныеСотрудников", ДанныеСотрудников);
		
		// Заполнение соответствия
		ДанныеПечатиОбъектов.Вставить(ДокументДляПечати.Ссылка, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

#КонецОбласти

Функция ДанныеДляБухучетаЗарплатыПервичныхДокументов(Объект) Экспорт

	ДанныеДляБухучета = Новый Структура;
	ДанныеДляБухучета.Вставить("ДокументОснование", Объект.Ссылка);
	
	ТаблицаБухучетЗарплаты = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаБухучетЗарплатыПервичныхДокументов();
	НоваяСтрока = ТаблицаБухучетЗарплаты.Добавить();
	НоваяСтрока.ДокументОснование = Объект.Ссылка;
	НоваяСтрока.НачислениеУдержание = Объект.Начисление;
	НоваяСтрока.СпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
	НоваяСтрока.ОтношениеКЕНВД = Объект.ОтношениеКЕНВД;
	НоваяСтрока.СтатьяФинансирования = Объект.СтатьяФинансирования;
	НоваяСтрока.СтатьяРасходов = Объект.СтатьяРасходов;
	
	ДанныеДляБухучета.Вставить("ТаблицаБухучетЗарплаты", ТаблицаБухучетЗарплаты);
	
	Возврат ДанныеДляБухучета;
	
КонецФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 

	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда

		ДанныеДляПроведения.Вставить("ПрочиеДоходы");
		
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ДатаПолученияДохода", "Ссылка.Начисление");
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("НачисленияДокумента", ДанныеДляПроведения.НачисленияПоСотрудникам);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	*
		|ПОМЕСТИТЬ ВТНачисленияДокумента
		|ИЗ
		|	&НачисленияДокумента КАК НачисленияДокумента";
		
		Запрос.Выполнить();
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	ВТНачисленияДокумента КАК ЗаписиНачислений
		|ГДЕ
		|	ЗаписиНачислений.Начисление.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)";
		
		ДанныеДляПроведения.Начисления = Запрос.Выполнить().Выгрузить();
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	ВТНачисленияДокумента КАК ЗаписиНачислений
		|ГДЕ
		|	ЗаписиНачислений.Начисление.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ДоходВНатуральнойФорме)";
		
		ДанныеДляПроведения.ПрочиеДоходы = Запрос.Выполнить().Выгрузить();
		
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления");
		
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		
		ДанныеДляПроведения.УдержанияПоСотрудникам = РасчетЗарплатыРасширенный.ПустаяТаблицаУдержанияДокумента();
		
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка();
		ДополнительныеПараметры.Таблицы.Начисления.Начисление = "Ссылка.Начисление";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаДействия = "Ссылка.МесяцНачисления";
		ДополнительныеПараметры.Таблицы.Начисления.НачалоБазовогоПериода = "Ссылка.МесяцНачисления";
		ДополнительныеПараметры.Таблицы.Начисления.ОкончаниеБазовогоПериода = "Ссылка.МесяцНачисления";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаНачала = "Ссылка.МесяцНачисления";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаОкончания = "Ссылка.МесяцНачисления";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;

КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоходВНатуральнойФорме.Ссылка,
	|	ДоходВНатуральнойФорме.Дата,
	|	ДоходВНатуральнойФорме.ДатаПолученияДохода,
	|	ДоходВНатуральнойФорме.МесяцНачисления,
	|	ДоходВНатуральнойФорме.ИсправленныйДокумент,
	|	ДоходВНатуральнойФорме.Организация
	|ИЗ
	|	Документ.ДоходВНатуральнойФорме КАК ДоходВНатуральнойФорме
	|ГДЕ
	|	ДоходВНатуральнойФорме.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.НомерСтроки,
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки,
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.Территория,
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.УсловияТруда,
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения,
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.Результат,
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.ДоходВНатуральнойФорме.РаспределениеПоТерриториямУсловиямТруда КАК ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ДоходВНатуральнойФормеРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, Дата, ДатаПолученияДохода, МесяцНачисления, Организация, РаспределениеПоТерриториямУсловиямТруда, ИсправленныйДокумент");
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

#КонецОбласти

#КонецЕсли