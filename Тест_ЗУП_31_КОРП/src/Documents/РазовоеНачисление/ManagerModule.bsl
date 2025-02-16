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
//  ДокументСсылка	- ДокументСсылка.РазовоеНачисление - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.РазовоеНачисление - Передается только при вызове из обработки проведения документа
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
		РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
		
		РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
		
		// Удержания
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
		ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержанийДоПределаПоСотрудникам(Движения, Отказ, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.УдержанияДоПределаПоСотрудникам);
		РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
		
		ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ);
		
		// - Регистрация бухучета начислений и удержаний, выполняется до вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
			ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено,
			РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
		
		// НДФЛ
		УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПоВременнойТаблицеНачислений(
			РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.МесяцНачисления, РеквизитыДляПроведения.ПорядокВыплаты, РеквизитыДляПроведения.ПланируемаяДатаВыплаты, ДанныеДляПроведения, Истина, РеквизитыДляПроведения.РассчитыватьУдержания Или УчетНДФЛРасширенный.ДоходыВУчетеНДФЛРегистрируютсяПоДатеВыплаты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.Начисление)));
		
		// КорректировкиВыплаты
		РасчетЗарплатыРасширенный.СформироватьДвиженияКорректировкиВыплатыПоВременнойТаблицеНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, РеквизитыДляПроведения.ПорядокВыплаты, ДанныеДляПроведения, Истина, РеквизитыДляПроведения.РассчитыватьУдержания Или УчетНДФЛРасширенный.ДоходыВУчетеНДФЛРегистрируютсяПоДатеВыплаты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДляПроведения.Начисление)));
		
		Если РеквизитыДляПроведения.РассчитыватьУдержания Тогда
			УчетНДФЛРасширенный.УточнитьУчетНалогаПоЦеннымБумагам(Движения, Истина);
		КонецЕсли;
		
		// Учет начисленной зарплаты
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
		
		УчетНачисленнойЗарплаты.ЗарегистрироватьОтработанноеВремя(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам, РеквизитыДляПроведения.ПорядокВыплаты);
		
		// - Регистрация бухучета НДФЛ, выполняется после вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
			Неопределено, Неопределено, ДанныеДляПроведения.НДФЛПоСотрудникам,
			РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
		
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
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.РазовоеНачисление;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.РазовоеНачисление);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

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
		
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.МесяцНачисления", "Ссылка.Начисление");  
		
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
		
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления");
		РасчетЗарплаты.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьПогашениеЗадолженностиПоУдержаниям(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.МесяцНачисления);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка();
		ДополнительныеПараметры.Таблицы.Начисления.Начисление = "Ссылка.Начисление";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаНачала = "Ссылка.ДатаНачала";
		ДополнительныеПараметры.Таблицы.Начисления.ДатаОкончания = "Ссылка.ДатаОкончания";
		ДополнительныеПараметры.Таблицы.Начисления.НачалоБазовогоПериода = "Ссылка.ДатаНачала";
		ДополнительныеПараметры.Таблицы.Начисления.ОкончаниеБазовогоПериода = "Ссылка.ДатаОкончания";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РазовоеНачисление.Ссылка,
	|	РазовоеНачисление.Дата,
	|	РазовоеНачисление.МесяцНачисления,
	|	РазовоеНачисление.Организация,
	|	РазовоеНачисление.ПорядокВыплаты,
	|	РазовоеНачисление.ПланируемаяДатаВыплаты,
	|	РазовоеНачисление.РассчитыватьУдержания,
	|	РазовоеНачисление.ИсправленныйДокумент,
	|	РазовоеНачисление.Начисление
	|ИЗ
	|	Документ.РазовоеНачисление КАК РазовоеНачисление
	|ГДЕ
	|	РазовоеНачисление.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.НомерСтроки,
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки,
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.Территория,
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.УсловияТруда,
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения,
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.Результат,
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.РазовоеНачисление.РаспределениеПоТерриториямУсловиямТруда КАК РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	РазовоеНачислениеРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка";
	
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
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, Дата, МесяцНачисления, Организация, ПорядокВыплаты, ПланируемаяДатаВыплаты, 
		| РассчитыватьУдержания, РаспределениеПоТерриториямУсловиямТруда, Начисление, ИсправленныйДокумент");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

Процедура ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ)
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	ИменаРеквизитов = 
	"МесяцНачисления,
	|Организация,
	|ИсправленныйДокумент,
	|Начисление";
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, ИменаРеквизитов);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Начисления.*
	               |ИЗ
	               |	Документ.РазовоеНачисление.Начисления КАК Начисления
	               |ГДЕ
	               |	Начисления.Ссылка = &Ссылка";
				   
	Начисления = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
	ПараметрыПроверки.Организация = РеквизитыДокумента.Организация;
	ПараметрыПроверки.ПериодРегистрации = РеквизитыДокумента.МесяцНачисления;
	ПараметрыПроверки.Документ = ДокументСсылка;
	ПараметрыПроверки.Начисления = Начисления;
	ПараметрыПроверки.ИмяКолонки = "Сотрудник";
	ПараметрыПроверки.Начисление = РеквизитыДокумента.Начисление;
	ПараметрыПроверки.ИсправленныйДокумент = РеквизитыДокумента.ИсправленныйДокумент;
	
	РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
