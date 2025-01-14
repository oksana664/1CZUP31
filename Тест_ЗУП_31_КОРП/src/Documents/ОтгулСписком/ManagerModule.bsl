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
//  ДокументСсылка	- ДокументСсылка.ОтгулСписком - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.ОтгулСписком - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(ДокументСсылка, Движения, РежимПроведения, Отказ, РеквизитыДляПроведения, СтруктураВидовУчета, Объект);
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		// Подготовка к регистрации перерасчетов
		ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
		
		СоздатьВТДанныеДокументов(РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.Организация, ДанныеДляРегистрацииПерерасчетов);
		ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(РеквизитыДляПроведения.Ссылка, ДанныеДляРегистрацииПерерасчетов, РеквизитыДляПроведения.Организация);
		
	КонецЕсли;
	
	Если РеквизитыДляПроведения.ПерерасчетВыполнен Тогда
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда

			РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации), ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
			
			РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
			
			ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ);

			УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
				Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено, Неопределено, Неопределено, Перечисления.ХарактерВыплатыЗарплаты.Зарплата);
					
			УчетНачисленнойЗарплаты.ЗарегистрироватьОтработанноеВремя(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам, Перечисления.ХарактерВыплатыЗарплаты.Зарплата, Истина);
			
			// - Регистрация бухучета начислений, выполняется до вызова регистрации доходов в учете НДФЛ.
			ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
						ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено, Неопределено);
			
			УчетНДФЛРасширенный.СформироватьДоходыНДФЛПоНачислениям(Движения, Отказ, РеквизитыДляПроведения.Организация,
						КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации), КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации),
						ДанныеДляПроведения.МенеджерВременныхТаблиц, , , , , ДокументСсылка);

			ОтражениеЗарплатыВБухучетеРасширенный.ДополнитьДоходыНДФЛСведениямиОРаспределенииПоСтатьямФинансирования(Движения);
			
			// - Регистрация начислений в доходах для страховых взносов.
			УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(
				Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);
			
		КонецЕсли;
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			
			// Учет среднего заработка
			УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда

		СостоянияСотрудников.ЗарегистрироватьСостоянияСотрудников(Движения, РеквизитыДляПроведения.Ссылка, ДанныеДляПроведения.ДанныеСостояний);
	
		// Регистрация перерасчетов
		Если ЕстьПерерасчеты Тогда
			ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, РеквизитыДляПроведения.Организация);
		КонецЕсли; 
		
		// Регистрация отгулов.
		УчетРабочегоВремениРасширенный.ЗарегистрироватьИПроверитьОстаткиДниЧасыОтгуловСотрудников(Движения, РеквизитыДляПроведения.ДанныеОбОтгулах, Отказ);
		
		ПерерасчетЗарплаты.УдалениеПерерасчетовПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	
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
		// При отмене документа реквизиты для проведения сформированы документом СторнированиеНачислений, их структура отличается
		// от структуры реквизитов для проведения исправленного документа. Получаем реквизиты для проведения исправленного документа.
		РеквизитыДляПроведения = РеквизитыДляПроведения(ИсправленныйДокумент);
		РеквизитыДляПроведения.ПериодРегистрации = ДополнительныеПараметры.ПериодРегистрации;
		
	Иначе
		РеквизитыДляПроведения = ДополнительныеПараметры.РеквизитыДляПроведения;
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		Сотрудники = РеквизитыДляПроведения.ДанныеОбОтгулах.ВыгрузитьКолонку("Сотрудник");
		УчетРабочегоВремениРасширенный.ЗарегистрироватьСторноЗаписиПоДокументу(Движения, РеквизитыДляПроведения.ПериодРегистрации, ИсправленныйДокумент, Сотрудники);
		УчетРабочегоВремениРасширенный.СторнироватьДниЧасыОтгуловСотрудников(Движения, ИсправленныйДокумент);
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОтменаДокумента Тогда
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			УчетСреднегоЗаработка.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
		КонецЕсли;
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			РасчетЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			УчетСтраховыхВзносовРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			УчетНДФЛРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент, ДополнительныеПараметры);
			УчетНачисленнойЗарплатыРасширенный.СторнироватьДвиженияДокумента(Движения, ИсправленныйДокумент);
			
			ИсправлениеДокументовЗарплатаКадры.СторнироватьДвиженияБезСпецификиУчетов(Движения, ИсправленныйДокумент, Ложь);
		КонецЕсли;
		
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
	
	МетаданныеДокумента = Метаданные.Документы.ОтгулСписком;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ОтгулСписком);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	СписокСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Сотрудники, "Сотрудник", Истина);
	ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокСотрудников, "ФизическоеЛицо");
	СписокФизическихЛиц = ОбщегоНазначения.ВыгрузитьКолонку(ФизическиеЛицаСотрудников, "Значение", Истина);
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = СписокФизическихЛиц;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если РеквизитыДляПроведения.ПерерасчетВыполнен Тогда
		
		Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
			
			РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ПериодРегистрации");
			РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
			
			ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
			
		КонецЕсли;
		
		Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
			ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка("Начисления");
			ДополнительныеПараметры.МесяцНачисления = "Ссылка.ПериодРегистрации";
			УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", РеквизитыДляПроведения.Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОтгулСпискомСотрудники.Сотрудник КАК Сотрудник,
	               |	ЗНАЧЕНИЕ(Перечисление.СостоянияСотрудника.ДополнительныеВыходныеДниНеОплачиваемые) КАК Состояние,
	               |	ОтгулСпискомСотрудники.ДатаНачала КАК Начало,
	               |	ОтгулСпискомСотрудники.ДатаОкончания КАК Окончание,
				   |	НЕОПРЕДЕЛЕНО КАК ВидВремени
	               |ИЗ
	               |	Документ.ОтгулСписком.Сотрудники КАК ОтгулСпискомСотрудники
	               |ГДЕ
	               |	ОтгулСпискомСотрудники.Ссылка = &Ссылка";
	
	// Данные состояний
	ДанныеСостояний = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("ДанныеСостояний", ДанныеСостояний);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СоздатьВТДанныеДокументов(ДокументСсылка, Организация, МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Регистратор", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&Организация КАК Организация,
	               |	ТаблицаДокумента.Сотрудник КАК Сотрудник,
	               |	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаНачала, МЕСЯЦ) КАК ПериодДействия,
	               |	ТаблицаДокумента.Ссылка КАК ДокументОснование
	               |ПОМЕСТИТЬ ВТДанныеДокументов
	               |ИЗ
	               |	Документ.ОтгулСписком.Сотрудники КАК ТаблицаДокумента
	               |ГДЕ
	               |	ТаблицаДокумента.Ссылка = &Регистратор
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	&Организация,
	               |	ТаблицаДокумента.Сотрудник,
	               |	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаОкончания, МЕСЯЦ),
	               |	ТаблицаДокумента.Ссылка
	               |ИЗ
	               |	Документ.ОтгулСписком.Сотрудники КАК ТаблицаДокумента
	               |ГДЕ
	               |	ТаблицаДокумента.Ссылка = &Регистратор
	               |	И ТаблицаДокумента.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтгулСписком.Ссылка КАК Ссылка,
	|	ОтгулСписком.Организация КАК Организация,
	|	ОтгулСписком.ПериодРегистрации КАК ПериодРегистрации,
	|	ОтгулСписком.Дата КАК Дата,
	|	ОтгулСписком.Номер КАК Номер,
	|	ОтгулСписком.ИсправленныйДокумент КАК ИсправленныйДокумент,
	|	ОтгулСписком.ПерерасчетВыполнен КАК ПерерасчетВыполнен,
	|	ОтгулСписком.ВидРасчета КАК ВидРасчета
	|ИЗ
	|	Документ.ОтгулСписком КАК ОтгулСписком
	|ГДЕ
	|	ОтгулСписком.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.НомерСтроки КАК НомерСтроки,
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.Территория КАК Территория,
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.УсловияТруда КАК УсловияТруда,
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения КАК ДоляРаспределения,
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.Результат КАК Результат,
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей КАК ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.ОтгулСписком.РаспределениеПоТерриториямУсловиямТруда КАК ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ОтгулСпискомРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтгулСпискомСотрудники.Ссылка.Организация КАК Организация,
	|	ОтгулСпискомСотрудники.Сотрудник КАК Сотрудник,
	|	ОтгулСпискомСотрудники.ДатаНачала КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ОтгулСпискомСотрудники.РасходДнейОтгула КАК Дни,
	|	ОтгулСпискомСотрудники.РасходЧасовОтгула КАК Часы
	|ИЗ
	|	Документ.ОтгулСписком.Сотрудники КАК ОтгулСпискомСотрудники
	|ГДЕ
	|	ОтгулСпискомСотрудники.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Если ВыборкаРеквизиты.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
	КонецЕсли;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	
	ДанныеОбОтгулах = Результаты[2].Выгрузить();
	РеквизитыДляПроведения.ДанныеОбОтгулах = ДанныеОбОтгулах;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, Организация, ПериодРегистрации, Дата, Номер, ИсправленныйДокумент, ПерерасчетВыполнен, ВидРасчета, РаспределениеПоТерриториямУсловиямТруда, ДанныеОбОтгулах");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

Процедура ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = 
	"ПериодРегистрации,
	|Организация,
	|ВидРасчета,
	|ИсправленныйДокумент";
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, ИменаРеквизитов);

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Начисления.*
	|ИЗ
	|	Документ.ОтгулСписком.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Ссылка = &Ссылка";
	
	Начисления = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
	ПараметрыПроверки.Организация = РеквизитыДокумента.Организация;
	ПараметрыПроверки.ПериодРегистрации = РеквизитыДокумента.ПериодРегистрации;
	ПараметрыПроверки.Документ = ДокументСсылка;
	ПараметрыПроверки.Начисления = Начисления;
	ПараметрыПроверки.ОсновныеНачисления = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДокумента.ВидРасчета);
	ПараметрыПроверки.ИсправленныйДокумент = РеквизитыДокумента.ИсправленныйДокумент;
	
	РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
