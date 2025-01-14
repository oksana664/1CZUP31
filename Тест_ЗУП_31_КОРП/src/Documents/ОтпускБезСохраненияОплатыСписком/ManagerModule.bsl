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
//  ДокументСсылка	- ДокументСсылка.ОтпускБезСохраненияОплатыСписком - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.ОтпускБезСохраненияОплатыСписком - Передается только при вызове из обработки проведения документа
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
		
		ПараметрыДвиженийОтпусков = ОстаткиОтпусков.ПараметрыДляСформироватьДвиженияФактическихОтпусков();
		ПараметрыДвиженийОтпусков.ДатаРегистрации = РеквизитыДляПроведения.Дата;
		ПараметрыДвиженийОтпусков.Начисления = ДанныеДляПроведения.Начисления;
		ПараметрыДвиженийОтпусков.ПериодНачисления = РеквизитыДляПроведения.ПериодРегистрации;
		ОстаткиОтпусков.СформироватьДвиженияФактическихОтпусков(Движения, Отказ, ПараметрыДвиженийОтпусков);
		
		Для Каждого СтрокаСостояний Из ДанныеДляПроведения.ДанныеРеестраОтпусков Цикл
			СостоянияСотрудников.ЗарегистрироватьОтпускСотрудника(Движения, РеквизитыДляПроведения.Ссылка, СтрокаСостояний.Сотрудник, СтрокаСостояний.ВидОтпуска, СтрокаСостояний.ДатаНачалаПериодаОтсутствия, СтрокаСостояний.ДатаОкончанияПериодаОтсутствия);
		КонецЦикла;
		
		УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР(РеквизитыДляПроведения.Ссылка)[РеквизитыДляПроведения.Ссылка]);
		
		// Регистрация перерасчетов
		Если ЕстьПерерасчеты Тогда
			ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, РеквизитыДляПроведения.Организация);
		КонецЕсли; 
		
		ПерерасчетЗарплаты.УдалениеПерерасчетовПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		
		КадровыйУчетРасширенный.ЗарегистрироватьВРеестреОтпусков(Движения, ДанныеДляПроведения.ДанныеРеестраОтпусков, Отказ);
		
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
	
	МетаданныеДокумента = Метаданные.Документы.ОтпускБезСохраненияОплатыСписком;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ОтпускБезСохраненияОплатыСписком);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеКадровогоСостоянияРасширенная,ЧтениеКадровогоСостоянияРасширенная,ДобавлениеИзменениеОтпусков,ЧтениеОтпусков", , Ложь) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_Т6а";
		КомандаПечати.Представление = НСтр("ru = 'Приказ о предоставлении отпуска работникам (Т-6а)'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция ПолныеПраваНаДокумент() Экспорт
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 
	
	ФизическиеЛицаСотрудников = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Объект.Сотрудники.Выгрузить(, "Сотрудник").ВыгрузитьКолонку("Сотрудник"), "ФизическоеЛицо");
	Если ФизическиеЛицаСотрудников.Количество() > 0 Тогда
		ФизическиеЛица = ОбщегоНазначения.ВыгрузитьКолонку(ФизическиеЛицаСотрудников, "Значение", Истина);
	Иначе
		ФизическиеЛица = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Справочники.ФизическиеЛица.ПустаяСсылка());
	КонецЕсли;
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ФизическиеЛица;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ 
	|	ОтпускБезСохраненияОплаты.ВидОтпуска,
	|	ОтпускБезСохраненияОплаты.ВидРасчета.ВидСтажаПФР2014 КАК ВидСтажаПФР,
	|	ОтпускБезСохраненияОплатыСпискомСотрудники.Сотрудник,
	|	ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаНачала,
	|	ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаОкончания,
	|	ОтпускБезСохраненияОплаты.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплатыСписком.Сотрудники КАК ОтпускБезСохраненияОплатыСпискомСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтпускБезСохраненияОплатыСписком КАК ОтпускБезСохраненияОплаты
	|		ПО ОтпускБезСохраненияОплатыСпискомСотрудники.Ссылка = ОтпускБезСохраненияОплаты.Ссылка
	|ГДЕ
	|	ОтпускБезСохраненияОплаты.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу);
		
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.ВидСтажаПФР) Тогда
				
				ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
				ОписаниеПериода.Сотрудник = Выборка.Сотрудник;
				ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаНачала;
				ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
				ОписаниеПериода.Состояние = СостоянияСотрудников.СостояниеПоВидуОтпуска(Выборка.ВидОтпуска);
				
				РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
				
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Выборка.ВидСтажаПФР);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ДанныеДляРегистрацииВУчете;
	
КонецФункции

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета) 
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ПериодРегистрации");
		Если РеквизитыДляПроведения.ПерерасчетВыполнен Тогда
			
			РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
			ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
			
		КонецЕсли;
		
		// Данные для Реестра отпусков
		ДанныеРеестраОтпусков = КадровыйУчетРасширенный.ТаблицаРеестраОтпусков();
		
		ДокументОснование = РеквизитыДляПроведения.Ссылка;
		Основание = КадровыйУчетРасширенный.ОснованиеДляРеестра(РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.Номер);
		
		Если ЗначениеЗаполнено(РеквизитыДляПроведения.ИсправленныйДокумент) Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ДокументОснование", РеквизитыДляПроведения.ИсправленныйДокумент);
			
			Запрос.Текст =
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	РеестрОтпусков.ДокументОснование КАК ДокументОснование,
				|	РеестрОтпусков.Основание КАК Основание
				|ИЗ
				|	РегистрСведений.РеестрОтпусков КАК РеестрОтпусков
				|ГДЕ
				|	РеестрОтпусков.Регистратор = &ДокументОснование";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда 
				ДокументОснование = Выборка.ДокументОснование;
				Основание = Выборка.Основание;
			КонецЕсли;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("Ссылка", РеквизитыДляПроведения.Ссылка);
		
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.Сотрудник,
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаНачала КАК Период
			|ПОМЕСТИТЬ ВТСотрудникиПериоды
			|ИЗ
			|	Документ.ОтпускБезСохраненияОплатыСписком.Сотрудники КАК ОтпускБезСохраненияОплатыСпискомСотрудники
			|ГДЕ
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.Ссылка = &Ссылка";
		
		Запрос.Выполнить();
		
		ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
			Запрос.МенеджерВременныхТаблиц,
			"ВТСотрудникиПериоды");
			
		КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(
			ОписательВременныхТаблиц,
			Истина,
			"ВидДоговора");
			
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ОтпускБезСохраненияОплаты.Ссылка КАК ДокументОснование,
			|	ОтпускБезСохраненияОплаты.ВидОтпуска КАК ВидОтпуска,
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.Сотрудник КАК Сотрудник,
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаНачала КАК ДатаНачалаПериодаОтсутствия,
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаОкончания КАК ДатаОкончанияПериодаОтсутствия,
			|	КадровыеДанныеСотрудников.ВидДоговора КАК ВидДоговора,
			|	ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаНачала КАК Период
			|ИЗ
			|	Документ.ОтпускБезСохраненияОплатыСписком.Сотрудники КАК ОтпускБезСохраненияОплатыСпискомСотрудники
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтпускБезСохраненияОплатыСписком КАК ОтпускБезСохраненияОплаты
			|		ПО ОтпускБезСохраненияОплатыСпискомСотрудники.Ссылка = ОтпускБезСохраненияОплаты.Ссылка
			|			И (ОтпускБезСохраненияОплаты.Ссылка = &Ссылка)
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
			|		ПО ОтпускБезСохраненияОплатыСпискомСотрудники.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
			|			И ОтпускБезСохраненияОплатыСпискомСотрудники.ДатаНачала = КадровыеДанныеСотрудников.Период";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		НомерСтр = 1;
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ДанныеРеестраОтпусков.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			
			НоваяСтрока.Номер = НомерСтр;
			
			НоваяСтрока.КоличествоДнейОтпуска = ЗарплатаКадрыКлиентСервер.ДнейВПериоде(
				НоваяСтрока.ДатаНачалаПериодаОтсутствия, НоваяСтрока.ДатаОкончанияПериодаОтсутствия);
			
			НоваяСтрока.ДокументОснование = ДокументОснование;
			НоваяСтрока.Основание = Основание;
			
			НомерСтр = НомерСтр + 1;
			
		КонецЦикла;
		
		ДанныеДляПроведения.Вставить("ДанныеРеестраОтпусков", ДанныеРеестраОтпусков);
		
	КонецЕсли;
	
	Если РеквизитыДляПроведения.ПерерасчетВыполнен И СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка("Начисления");
		ДополнительныеПараметры.МесяцНачисления = "Ссылка.ПериодРегистрации";
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СоздатьВТДанныеДокументов(ДокументСсылка, Организация, МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Регистратор", ДокументСсылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	&Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаНачала, МЕСЯЦ) КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ОтпускБезСохраненияОплатыСписком.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	НАЧАЛОПЕРИОДА(ТаблицаДокумента.ДатаОкончания, МЕСЯЦ),
		|	ТаблицаДокумента.Ссылка
		|ИЗ
		|	Документ.ОтпускБезСохраненияОплатыСписком.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|	И ТаблицаДокумента.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтпускБезСохраненияОплаты.Ссылка КАК Ссылка,
	|	ОтпускБезСохраненияОплаты.Организация КАК Организация,
	|	ОтпускБезСохраненияОплаты.ПериодРегистрации КАК ПериодРегистрации,
	|	ОтпускБезСохраненияОплаты.Дата КАК Дата,
	|	ОтпускБезСохраненияОплаты.Номер КАК Номер,
	|	ОтпускБезСохраненияОплаты.ИсправленныйДокумент КАК ИсправленныйДокумент,
	|	ОтпускБезСохраненияОплаты.ПерерасчетВыполнен КАК ПерерасчетВыполнен,
	|	ОтпускБезСохраненияОплаты.ВидОтпуска КАК ВидОтпуска,
	|	ОтпускБезСохраненияОплаты.ВидРасчета КАК ВидРасчета
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплатыСписком КАК ОтпускБезСохраненияОплаты
	|ГДЕ
	|	ОтпускБезСохраненияОплаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.НомерСтроки КАК НомерСтроки,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.Территория КАК Территория,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.УсловияТруда КАК УсловияТруда,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения КАК ДоляРаспределения,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.Результат КАК Результат,
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей КАК ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплатыСписком.РаспределениеПоТерриториямУсловиямТруда КАК ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ОтпускБезСохраненияОплатыРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка";
	
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
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, Организация, ПериодРегистрации, Дата, Номер, ИсправленныйДокумент, ПерерасчетВыполнен, ВидОтпуска, ВидРасчета, РаспределениеПоТерриториямУсловиямТруда");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

Процедура ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = 
	"ПериодРегистрации,
	|Организация,
	|ИсправленныйДокумент,
	|ВидРасчета";
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, ИменаРеквизитов);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Начисления.*
	|ИЗ
	|	Документ.ОтпускБезСохраненияОплатыСписком.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Ссылка = &Ссылка";
	
	Начисления = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
	ПараметрыПроверки.Организация = РеквизитыДокумента.Организация;
	ПараметрыПроверки.ПериодРегистрации = РеквизитыДокумента.ПериодРегистрации;
	ПараметрыПроверки.Документ = ДокументСсылка;
	ПараметрыПроверки.Начисления = Начисления;
	ПараметрыПроверки.ИсправленныйДокумент = РеквизитыДокумента.ИсправленныйДокумент;
	ПараметрыПроверки.ОсновныеНачисления = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитыДокумента.ВидРасчета);
	
	РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
	
КонецПроцедуры

// Проверяет, что сотрудники, указанные в документе работают в периоды отсутствия.
//
// Параметры:
//		ДокументОбъект	- ДокументОбъект.ОтпускБезСохраненияОплатыСписком
//		Отказ			- Булево
//
Процедура ПроверитьРаботающих(ДокументОбъект, Отказ) Экспорт
	
	ПериодыОтпусков = ДокументОбъект.Сотрудники.Выгрузить(, "ДатаНачала, ДатаОкончания");
	ПериодыОтпусков.Свернуть("ДатаНачала, ДатаОкончания");
	
	Для Каждого ПериодОтпуска Из ПериодыОтпусков Цикл
		
		СтрокиКПроверке = ДокументОбъект.Сотрудники.НайтиСтроки(Новый Структура("ДатаНачала, ДатаОкончания",
			ПериодОтпуска.ДатаНачала, ПериодОтпуска.ДатаОкончания));
			
		МассивСотрудников = Новый Массив();
		
		Для Каждого Строка Из СтрокиКПроверке Цикл
			МассивСотрудников.Добавить(Строка.Сотрудник);
		КонецЦикла;
		
		ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
		ПараметрыПолученияСотрудниковОрганизаций.Организация 				= ДокументОбъект.Организация;
		ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ПериодОтпуска.ДатаНачала;
		ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ПериодОтпуска.ДатаОкончания;
		ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ	= Неопределено;
		ПараметрыПолученияСотрудниковОрганизаций.ИсключаемыйРегистратор		= ДокументОбъект.Ссылка;
		
		КадровыйУчет.ПроверитьРаботающихСотрудников(
			МассивСотрудников,
			ПараметрыПолученияСотрудниковОрганизаций,
			Отказ,
			Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
			
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
