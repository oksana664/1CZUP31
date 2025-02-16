#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДатаОтпуска = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДатаНачала");
	Если ЗначениеЗаполнено(ДатаВозврата) И ДатаВозврата < ДатаОтпуска Тогда
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаВозврата, "Объект.ДатаВозврата", Отказ,
			НСтр("ru='Дата возврата'"), ДатаОтпуска, НСтр("ru='даты ухода в отпуск'"));
		
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаВозврата;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаВозврата;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);

	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		СписокФизическихЛиц,
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(СписокФизическихЛиц, Истина, Организация, ДатаВозврата);
	Если Не ОсновныеСотрудники.Количество() > 0 Тогда
		ТекстСообщения = Нстр("ru='%1 не работает в организации на %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Сотрудник, Формат(ДатаВозврата,"ДЛФ=D"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.Сотрудник",, Отказ);
	КонецЕсли;

	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаВозврата, "Начисления", "Показатели", Отказ, Истина, "РабочееМесто");
	
	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(ЭтотОбъект, ДатаВозврата, "Льготы", "Показатели", Отказ, Истина, "РабочееМесто", "Льгота");
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если Не ИзменитьНачисления Или НЕ НачисленияУтверждены Тогда
		ИсключаемыеРеквизиты.Добавить("Начисления.РабочееМесто");
	КонецЕсли;
	
	Если Не ИзменитьАванс Или НЕ НачисленияУтверждены Тогда
		ИсключаемыеРеквизиты.Добавить("Авансы.РабочееМесто");
		ИсключаемыеРеквизиты.Добавить("Авансы.СпособРасчетаАванса");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	СотрудникиДокумента = ОбщегоНазначения.ВыгрузитьКолонку(Начисления, "РабочееМесто", Истина);
	Для Каждого РабочееМесто Из СотрудникиДокумента Цикл 
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.Сотрудник = РабочееМесто;
		НоваяСтрока.Период = ДатаВозврата;
	КонецЦикла;
	
	ЗарплатаКадрыРасширенный.ПроверитьНаличиеДокументовСФиксированнымСдвигомНаДату(СотрудникиДаты, Ссылка, Отказ, ИсправленныйДокумент);
	
	Если ИзменитьНачисления И НачисленияУтверждены Тогда 
		РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениУходЗаРебенком(ДатаВозврата, Начисления, Ссылка, Отказ, , , ИсправленныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(Ссылка, Движения, РежимПроведения, Отказ,,, ЭтотОбъект, "ДатаВозврата");
	
	// Начинаем состояние «Работа».
	ПараметрыСостояния = СостоянияСотрудников.ПараметрыСостоянияФизическогоЛица();
	ПараметрыСостояния.Состояние = Перечисления.СостоянияСотрудника.Работа; 
	ПараметрыСостояния.ДокументСсылка = Ссылка;
	ПараметрыСостояния.Организация = Организация;
	ПараметрыСостояния.Начало = ДатаВозврата; 
	СостоянияСотрудников.ЗарегистрироватьСостояниеФизическогоЛица(Движения, Сотрудник, ПараметрыСостояния);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация, , , Истина);
	
	// Проведение документа
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
	
	Если НачисленияУтверждены Тогда
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
		
		Если ДанныеДляПроведения.Свойство("ПрименениеДополнительныхПоказателей") Тогда
			СтруктураПлановыхНачислений.Вставить("ПрименениеДополнительныхПоказателей", ДанныеДляПроведения.ПрименениеДополнительныхПоказателей);
		КонецЕсли;
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
		
		РасчетЗарплатыРасширенный.СформироватьДвиженияПримененияПлановыхНачислений(Движения, ДанныеДляПроведения.ПрименениеНачислений);
		РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок(Движения, ДанныеДляПроведения.ПорядокПересчетаТарифнойСтавки);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения.ПлановыеАвансы)
		
	КонецЕсли;
	
	Если ЗаниматьСтавку Тогда
		КадровыйУчетРасширенный.ЗанятьСтавку(Движения, ДанныеДляПроведения.ЗанятыеСтавки);
	КонецЕсли;
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	КадровыйУчетРасширенный.ЗарегистрироватьВРеестреОтпусков(Движения, ДанныеДляПроведения.ДанныеРеестраОтпусков, Отказ);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация, , Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация, , , Истина);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		ОбъектОснование = ДанныеЗаполнения.Сотрудник;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("РабочееМесто", ОбъектОснование);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ОтпускПоУходуЗаРебенкомНачисления.Ссылка,
		|	ОтпускПоУходуЗаРебенкомНачисления.Ссылка.ДатаНачала КАК ДатаНачала
		|ИЗ
		|	Документ.ОтпускПоУходуЗаРебенком.Начисления КАК ОтпускПоУходуЗаРебенкомНачисления
		|ГДЕ
		|	ОтпускПоУходуЗаРебенкомНачисления.РабочееМесто = &РабочееМесто
		|	И ОтпускПоУходуЗаРебенкомНачисления.Ссылка.Проведен
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка.ДатаИзменения
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления
		|ГДЕ
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто = &РабочееМесто
		|	И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка.Проведен
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачала УБЫВ";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			ОбъектОснование = Выборка.Ссылка;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ОтпускПоУходуЗаРебенком") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектОснование, "Проведен, Организация, Сотрудник, ОсвобождатьСтавку");
		Если НЕ ЗначенияРеквизитов.Проведен Тогда
			ВызватьИсключение НСтр("ru = 'Ввод на основании непроведенного документа невозможен.'");
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Сотрудник"); 
			ДокументОснование  	= ОбъектОснование;
			ЗаниматьСтавку  	= ЗначенияРеквизитов.ОсвобождатьСтавку;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектОснование, "Проведен, Организация, Сотрудник, ДокументОснование");
		Если НЕ ЗначенияРеквизитов.Проведен Тогда
			ВызватьИсключение НСтр("ru = 'Ввод на основании непроведенного документа невозможен.'");
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов, "Организация, Сотрудник, ДокументОснование"); 
		КонецЕсли;
	ИначеЕсли ТипЗнч(ОбъектОснование) = Тип("Структура") Тогда
		Если ОбъектОснование.Свойство("Действие") И ОбъектОснование.Действие = "Исправить" Тогда
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ОбъектОснование.Ссылка);
			ИсправленныйДокумент = ОбъектОснование.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АдаптацияУвольнение");
		Модуль.ОбработкаЗаполненияКадровогоПриказа(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ОбъектОснование, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
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
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическомуЛицу(ЭтотОбъект, Организация, Сотрудник, ДатаВозврата);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРеквизитыОснования(Реквизиты = "ВыплачиватьПособиеДоПолутораЛет,ДатаОкончанияПособияДоПолутораЛет,
	|КоличествоДетей,КоличествоПервыхДетей,
	|ВыплачиватьПособиеДоТрехЛет,ДатаОкончанияПособияДоТрехЛет") Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, Реквизиты);
	
КонецФункции

#Область ПолучитьДанныеДляПроведения

Функция ПолучитьДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура; 
	
	Если НачисленияУтверждены Тогда
		
		ЗаполнитьПлановыеНачисленияИПоказатели(ДанныеДляПроведения);
		
		ЗаполнитьПлановыеАвансы(ДанныеДляПроведения);
		
		ЗаполнитьПрименениеПлановыхНачислений(ДанныеДляПроведения);
		
		ЗаполнитьПрименениеДополнительныхПоказателей(ДанныеДляПроведения);
		
		ЗаполнитьПересчетТарифныхСтавок(ДанныеДляПроведения);
		
		ЗаполнитьСовокупныеТарифныеСтавки(ДанныеДляПроведения);
		
	КонецЕсли;
	
	ЗаполнитьДанныеВремениРегистрацииДокумента(ДанныеДляПроведения);
	
	ЗаполнитьЗанятыеСтавки(ДанныеДляПроведения);
	
	ЗаполнитьДанныеРеестраОтпусков(ДанныеДляПроведения);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#Область ПлановыеНачисленияИПоказатели

Процедура ЗаполнитьПлановыеНачисленияИПоказатели(ДанныеДляПроведения)
	
	ПлановыеНачисления = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииПлановыхНачислений();
	ПлановыеНачисления.Колонки.Добавить("ИспользуетсяПоОкончании", Новый ОписаниеТипов("Булево"));
	
	ЗначенияПоказателей = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииЗначенийПериодическихПоказателей();
	
	ДобавитьПособияПоУходу(ПлановыеНачисления);
	
	Если ИзменитьНачисления Тогда
		ДобавитьПлановыеНачисления(ПлановыеНачисления);
	КонецЕсли;
	
	Если ИзменитьЛьготы Тогда
		ДобавитьЛьготы(ПлановыеНачисления);
	КонецЕсли;
	
	ДобавитьПлановыеПоказатели(ЗначенияПоказателей, ИзменитьНачисления, ИзменитьЛьготы);
	
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
КонецПроцедуры

Процедура ДобавитьПособияПоУходу(ПлановыеНачисления)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТПлановыеНачисленияСрезПоследних(Запрос);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлановыеНачисления.Период КАК ДатаСобытия,
	|	ПлановыеНачисления.Сотрудник,
	|	ПлановыеНачисления.Начисление,
	|	ВЫРАЗИТЬ(ПлановыеНачисления.Сотрудник КАК Справочник.Сотрудники).ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ПлановыеНачисления.ФизическоеЛицо,
	|	ЛОЖЬ КАК Используется
	|ИЗ
	|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПлановыеНачисления.Добавить(), Выборка);
	КонецЦикла;
		
КонецПроцедуры

Процедура ДобавитьПлановыеНачисления(ПлановыеНачисления)
	
	Запрос = ЗапросССсылкой();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Начисление,
	|	ВЫБОР
	|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Используется,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник КАК ФизическоеЛицо,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ДокументОснование,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Размер,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
	|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПлановыеНачисления.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьПлановыеПоказатели(ЗначенияПоказателей, ИзменитьНачисления, ИзменитьЛьготы)
	
	Если Не ИзменитьНачисления И Не ИзменитьЛьготы Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = ЗапросССсылкой();
	
	Запрос.УстановитьПараметр("ИзменитьНачисления", ИзменитьНачисления);
	Запрос.УстановитьПараметр("ИзменитьЛьготы", ИзменитьЛьготы);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Организация КАК Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник КАК ФизическоеЛицо,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель КАК Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Значение) КАК Значение,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия
		|ПОМЕСТИТЬ ВТПоказатели
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка
		|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ИдентификаторСтрокиВидаРасчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка
		|	И &ИзменитьНачисления
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ДокументОснование,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ДокументОснование,
		|	МАКСИМУМ(ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Значение),
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Льготы КАК ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка
		|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ИдентификаторСтрокиВидаРасчета
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = &Ссылка
		|	И &ИзменитьЛьготы
		|
		|СГРУППИРОВАТЬ ПО
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.РабочееМесто,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ДокументОснование,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Показатели.Организация КАК Организация,
		|	Показатели.Сотрудник КАК Сотрудник,
		|	Показатели.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Показатели.Показатель КАК Показатель,
		|	Показатели.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(Показатели.Значение) КАК Значение,
		|	Показатели.ДатаСобытия КАК ДатаСобытия
		|ИЗ
		|	ВТПоказатели КАК Показатели
		|
		|СГРУППИРОВАТЬ ПО
		|	Показатели.Организация,
		|	Показатели.Сотрудник,
		|	Показатели.ФизическоеЛицо,
		|	Показатели.Показатель,
		|	Показатели.ДокументОснование,
		|	Показатели.ДатаСобытия";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ЗначенияПоказателей.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьВТПлановыеНачисленияСрезПоследних(Запрос)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&ДатаВозврата КАК Период,
	|	&ОсновнойСотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТИзмеренияДаты";
	Запрос.УстановитьПараметр("ДатаВозврата", ДатаВозврата);
	Запрос.УстановитьПараметр("ОсновнойСотрудник", ОсновнойСотрудник);
	
	Запрос.Выполнить();
	
	КатегорииПособий = УчетПособийСоциальногоСтрахованияРасширенный.КатегорииНачисленийОплачивающихПособияПоУходуЗаРебенком();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистраСрез();
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "Начисление.КатегорияНачисленияИлиНеоплаченногоВремени", "В", КатегорииПособий);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних("ПлановыеНачисления", Запрос.МенеджерВременныхТаблиц,	Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТИзмеренияДаты", "Сотрудник"), ПараметрыПостроения);
		
КонецПроцедуры

Процедура ДобавитьЛьготы(ПлановыеНачисления)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка.ДатаВозврата КАК ДатаСобытия,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.РабочееМесто КАК Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Льгота КАК Начисление,
		|	ВЫБОР
		|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.ДокументОснование КАК ДокументОснование,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Размер КАК Размер,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Льготы КАК ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенкомЛьготы.Ссылка = &Ссылка";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПлановыеНачисления.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьПлановыеАвансы(ДанныеДляПроведения)
	
	ПлановыеАвансы =  ПустаяТаблицаРегистрацииПлановыхАвансов();
	
	Если ИзменитьАванс Тогда
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.РабочееМесто КАК Сотрудник,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.РабочееМесто.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.СпособРасчетаАванса КАК СпособРасчетаАванса,
		|	ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.Аванс КАК Аванс,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Сотрудник КАК ФизическоеЛицо
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Авансы КАК ВозвратИзОтпускаПоУходуЗаРебенкомАвансы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
		|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомАвансы.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
		|ГДЕ
		|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(ПлановыеАвансы.Добавить(), Выборка);
		КонецЦикла;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПлановыеАвансы", ПлановыеАвансы);
	
КонецПроцедуры

Функция ПустаяТаблицаРегистрацииПлановыхАвансов()
	
	ТаблицаРегистрации = Новый ТаблицаЗначений;
	ТаблицаРегистрации.Колонки.Добавить("ДатаСобытия", 			Новый ОписаниеТипов("Дата"));
	ТаблицаРегистрации.Колонки.Добавить("Сотрудник", 			Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаРегистрации.Колонки.Добавить("ГоловнаяОрганизация",	Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаРегистрации.Колонки.Добавить("ВидСобытия", 			Новый ОписаниеТипов("ПеречислениеСсылка.ВидыКадровыхСобытий"));
	ТаблицаРегистрации.Колонки.Добавить("СпособРасчетаАванса", 	Новый ОписаниеТипов("ПеречислениеСсылка.СпособыРасчетаАванса"));
	ТаблицаРегистрации.Колонки.Добавить("Аванс", 				Новый ОписаниеТипов("Число"));
	ТаблицаРегистрации.Колонки.Добавить("ДействуетДо", 			Новый ОписаниеТипов("Дата"));
	ТаблицаРегистрации.Колонки.Добавить("ФизическоеЛицо", 		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	
	Возврат ТаблицаРегистрации;
	
КонецФункции

Процедура ЗаполнитьПрименениеПлановыхНачислений(ДанныеДляПроведения)
	
	ПрименениеНачислений = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииПримененияПлановыхНачислений();
	
	Запрос = ЗапросССсылкой();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата КАК ДатаСобытия,
	|	МАКСИМУМ(ИСТИНА) КАК Применение
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком КАК ВозвратИзОтпускаПоУходуЗаРебенком
	|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенком.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто,
	|	ВозвратИзОтпускаПоУходуЗаРебенком.ДатаВозврата";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ПрименениеНачислений.Добавить(), Выборка);
	КонецЦикла;

	ДанныеДляПроведения.Вставить("ПрименениеНачислений", ПрименениеНачислений);
	
КонецПроцедуры

Процедура ЗаполнитьПрименениеДополнительныхПоказателей(ДанныеДляПроведения)
	
	Если ИзменитьНачисления Тогда
		
		ПрименениеДополнительныхПоказателей = Неопределено;
		
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто
			|ПОМЕСТИТЬ ВТПоказателиНачислений
			|ИЗ
			|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
			|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто = ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.ИдентификаторСтрокиВидаРасчета = ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета
			|ГДЕ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = &Ссылка
			|	И ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаВозврата КАК ДатаСобытия,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация КАК Организация,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто КАК Сотрудник,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник КАК ФизическоеЛицо,
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель КАК Показатель,
			|	ВЫБОР
			|		КОГДА ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК Применение
			|ИЗ
			|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Показатели КАК ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиНачислений КАК ПоказателиНачислений
			|		ПО ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ПоказателиНачислений.Ссылка
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто = ПоказателиНачислений.РабочееМесто
			|			И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель = ПоказателиНачислений.Показатель
			|ГДЕ
			|	ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = &Ссылка
			|	И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = 0
			|	И ВозвратИзОтпускаПоУходуЗаРебенкомПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
			|	И ПоказателиНачислений.Показатель ЕСТЬ NULL ";
		
		ПрименениеДополнительныхПоказателей = Запрос.Выполнить().Выгрузить();
		
		ДанныеДляПроведения.Вставить("ПрименениеДополнительныхПоказателей", ПрименениеДополнительныхПоказателей);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПересчетТарифныхСтавок(ДанныеДляПроведения)
	
	ПорядокПересчетаТарифнойСтавки = Неопределено;
	
	Если ИзменитьНачисления Тогда
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПересчетТарифныхСтавок.Ссылка.ДатаВозврата КАК ДатаСобытия,
		|	ПересчетТарифныхСтавок.РабочееМесто КАК Сотрудник,
		|	ПересчетТарифныхСтавок.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ПересчетТарифныхСтавок.ПорядокРасчетаСтоимостиЕдиницыВремени КАК ПорядокРасчета,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.ПересчетТарифныхСтавок КАК ПересчетТарифныхСтавок
		|ГДЕ
		|	ПересчетТарифныхСтавок.Ссылка = &Ссылка";
		ПорядокПересчетаТарифнойСтавки = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПорядокПересчетаТарифнойСтавки", ПорядокПересчетаТарифнойСтавки);
	
КонецПроцедуры

Процедура ЗаполнитьСовокупныеТарифныеСтавки(ДанныеДляПроведения)
	
	ДанныеСовокупныхТарифныхСтавок = Неопределено;
	
	Если ИзменитьНачисления Тогда
		Запрос = ЗапросССсылкой();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПересчетТарифныхСтавок.Ссылка.ДатаВозврата КАК ДатаСобытия,
		|	ПересчетТарифныхСтавок.РабочееМесто КАК Сотрудник,
		|	ПересчетТарифныхСтавок.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА ПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ ПересчетТарифныхСтавок.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.ПересчетТарифныхСтавок КАК ПересчетТарифныхСтавок
		|ГДЕ
		|	ПересчетТарифныхСтавок.Ссылка = &Ссылка";
		ДанныеСовокупныхТарифныхСтавок = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", ДанныеСовокупныхТарифныхСтавок);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеВремениРегистрацииДокумента(ДанныеДляПроведения)
	
	Запрос = ЗапросССсылкой();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто КАК Сотрудник,
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка.ДатаВозврата КАК ДатаСобытия
	|ИЗ
	|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ВозвратИзОтпускаПоУходуЗаРебенкомНачисления
	|ГДЕ
	|	ВозвратИзОтпускаПоУходуЗаРебенкомНачисления.Ссылка = &Ссылка";
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
КонецПроцедуры

Процедура ЗаполнитьЗанятыеСтавки(ДанныеДляПроведения)
	
	ЗанятыеСтавки = Неопределено;
	
	Если ЗаниматьСтавку Тогда
		
		МассивРабочихМест = КадровыйУчетРасширенный.МассивСотрудников(Сотрудник, Организация, ДатаВозврата);
		
		ЗанятыеСтавки = Новый ТаблицаЗначений;
		ЗанятыеСтавки.Колонки.Добавить("Сотрудник", 		Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
		ЗанятыеСтавки.Колонки.Добавить("ДатаЗанятияСтавки", Новый ОписаниеТипов("Дата"));
		
		Для каждого РабочееМесто Из МассивРабочихМест Цикл
			ЗанятаяСтавка = ЗанятыеСтавки.Добавить();
			ЗанятаяСтавка.Сотрудник 		= РабочееМесто;
			ЗанятаяСтавка.ДатаЗанятияСтавки = ДатаВозврата;
		КонецЦикла;
		
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ЗанятыеСтавки", ЗанятыеСтавки);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеРеестраОтпусков(ДанныеДляПроведения)
	
	// Данные для Реестра отпусков
	ДанныеРеестраОтпусков = КадровыйУчетРасширенный.ТаблицаРеестраОтпусков();
	НоваяСтрока = ДанныеРеестраОтпусков.Добавить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Сотрудник", ОсновнойСотрудник);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(РеестрОтпусков.Период) КАК Период,
		|	РеестрОтпусков.Сотрудник КАК Сотрудник,
		|	РеестрОтпусков.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВТПоследнийПериодОснований
		|ИЗ
		|	РегистрСведений.РеестрОтпусков КАК РеестрОтпусков
		|ГДЕ
		|	РеестрОтпусков.Регистратор = &ДокументОснование
		|	И РеестрОтпусков.Сотрудник = &Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	РеестрОтпусков.Сотрудник,
		|	РеестрОтпусков.ДокументОснование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеестрОтпусков.Сотрудник КАК Сотрудник,
		|	РеестрОтпусков.ФизическоеЛицо КАК ФизическоеЛицо,
		|	РеестрОтпусков.ДокументОснование КАК ДокументОснование,
		|	РеестрОтпусков.Номер КАК Номер,
		|	РеестрОтпусков.ВидОтпуска КАК ВидОтпуска,
		|	РеестрОтпусков.ВидДоговора КАК ВидДоговора,
		|	РеестрОтпусков.Основание КАК Основание,
		|	РеестрОтпусков.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск КАК НачалоПериодаЗаКоторыйПредоставляетсяОтпуск,
		|	РеестрОтпусков.КонецПериодаЗаКоторыйПредоставляетсяОтпуск КАК КонецПериодаЗаКоторыйПредоставляетсяОтпуск,
		|	РеестрОтпусков.ДатаНачалаПериодаОтсутствия КАК ДатаНачалаПериодаОтсутствия
		|ИЗ
		|	РегистрСведений.РеестрОтпусков КАК РеестрОтпусков
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоследнийПериодОснований КАК ПоследнийПериодОснований
		|		ПО РеестрОтпусков.Период = ПоследнийПериодОснований.Период
		|			И РеестрОтпусков.Сотрудник = ПоследнийПериодОснований.Сотрудник
		|			И РеестрОтпусков.ДокументОснование = ПоследнийПериодОснований.ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	
	НоваяСтрока.Период = Дата;
	
	НоваяСтрока.ДатаОкончанияПериодаОтсутствия = НачалоДня(ДатаВозврата) - 1;
	
	НоваяСтрока.КоличествоДнейОтпуска = ЗарплатаКадрыКлиентСервер.ДнейВПериоде(
		НоваяСтрока.ДатаНачалаПериодаОтсутствия, НоваяСтрока.ДатаОкончанияПериодаОтсутствия);
	
	ДанныеДляПроведения.Вставить("ДанныеРеестраОтпусков", ДанныеРеестраОтпусков);
	
КонецПроцедуры

Функция ЗапросССсылкой()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Возврат Запрос;
КонецФункции 

#КонецОбласти

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.ВозвратИзОтпускаПоУходуЗаРебенком.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
	
КонецФункции	

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация,
		|	ТаблицаДокумента.РабочееМесто КАК Сотрудник,
		|	ТаблицаДокумента.Ссылка.ДатаВозврата КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ВозвратИзОтпускаПоУходуЗаРебенком.Начисления КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
