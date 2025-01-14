
#Область СлужебныеПроцедурыИФункции

// Содержит настройки размещения вариантов отчетов в панели отчетов.
// Описание см. ЗарплатаКадрыВариантыОтчетов.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	// Базовые настройки вариантов отчетов.
	ЗарплатаКадрыОтчетыБазовый.НастроитьВариантыОтчетов(Настройки);
	
	// Исключение вариантов отчетов, не предназначенных для интерактивного использования.
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЖурналУчетаИсполнительныхДокументов, "КарточкаУчетаИсполнительныхДокументов");
	Вариант.Включен = Ложь;
	
	// Технические варианты отчетов.
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ФактическиеОтпускаСотрудников, "ФактическиеОтпускаСотрудников");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ПлановыеУдержанияСотрудников, "ПлановыеУдержанияСотрудников");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.КадроваяИсторияСотрудников, "КадроваяИсторияСотрудников");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ОтчетыПоСотрудникам, "ЗаполнениеСписковСотрудников");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ОтчетыПоСотрудникам, "Т4");
	Вариант.Описание = НСтр("ru='Учетная карточка научного работника (Т-4)'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ОтчетыПоСотрудникам, "СевернаяНадбавка");
	Вариант.Описание = НСтр("ru='Северная надбавка'");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ОстаткиОтпусков, "ДанныеРасчета");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.УнифицированнаяФормаТ2, "Т2ГСМС");
	Вариант.Включен = Ложь;
	
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("ПрименятьСевернуюНадбавку");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ОтчетыПоСотрудникам, "СевернаяНадбавка");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	
	// Подчинение вариантов отчета по источникам финансирования функциональной опции ИспользоватьИсточникиФинансирования.
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержанийАвансом, "РасчетныйЛистокСРазбивкойПоИсточникамФинансированияПерваяПоловинаМесяца");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализЗадолженностиПоЗарплате, "ЗадолженностьВРазрезеИсточниковФинансирования");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЛицевыеСчетаСотрудников, "Т54");
	Вариант.ФункциональныеОпции.Добавить("ИспользоватьРасчетЗарплатыРасширенная");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЛицевыеСчетаСотрудников, "Т54а");
	Вариант.ФункциональныеОпции.Добавить("ИспользоватьРасчетЗарплатыРасширенная");
	
	// Обновление настроек отчетов по штатному расписанию.
	УправлениеШтатнымРасписанием.УстановитьДоступностьОтчетовПоШтатномуРасписанию(Настройки);
	
	ФункциональныеОпции = Новый Массив;
	ФункциональныеОпции.Добавить("РаботаВБюджетномУчреждении");   
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.УнифицированнаяФормаТ13, "Форма0504421");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	Вариант.Описание = НСтр("ru = 'Устаревшая форма. Применялась до 2015 года'");
	Вариант.Размещение.Очистить();
	Вариант.Размещение.Вставить(Метаданные.Подсистемы.Зарплата, "СмТакже");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.УнифицированнаяФормаТ13, "Форма0504421с2015");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержаний, "Форма0504401");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	Вариант.Включен = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержаний, "Форма0504401с2015");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	Вариант.Включен = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержаний, "Форма0504402");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	Вариант.Включен = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержанийАвансом, "Т49ПерваяПоловинаМесяца");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержанийАвансом, "Форма0504402ПерваяПоловинаМесяца");
	Вариант.ФункциональныеОпции = ФункциональныеОпции;
	Вариант.Включен = Истина;
	
	// Настройки вариантов отчетов приложений.
#Область ЗарплатаКадрыПриложения	
	// Обновление настроек отчетов по учету депонентов.
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетДепонированнойЗарплаты") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетДепонированнойЗарплатыРасширенный");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.УчетБюджетныхУчреждений") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УчетБюджетныхУчреждений");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ЗарплатаКадрыКомандныйИнтерфейс") Тогда
		МодульКомандныйИнтерфейс = ОбщегоНазначения.ОбщийМодуль("ЗарплатаКадрыКомандныйИнтерфейс");
		МодульКомандныйИнтерфейс.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина.ДоступКНаркотическимСредствам") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ДоступКНаркотическимСредствам");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Медицина.ТарификационнаяОтчетностьУчрежденийФМБА") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ТарификационнаяОтчетностьУчрежденийФМБА");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Подработки") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Подработки");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.АттестацииСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АттестацииСотрудников");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадрыРасширенная") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("КонфигурацииЗарплатаКадрыРасширенный");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОрганизационнаяСтруктура");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.ОстаткиОтпусков") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОстаткиОтпусков");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПлановыеПрочиеДоходы") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПлановыеПрочиеДоходы");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.БухучетХозрасчетныхОрганизацийРасширенная") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("БухучетХозрасчетныхОрганизацийРасширенный");
		Модуль.НастроитьВариантыОтчетов(Настройки);
	КонецЕсли;

#КонецОбласти

	// Настройка отчетов
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализЗадолженностиПоЗарплате);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализИзмененийЛичныхДанныхСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализНачисленийИУдержанийАвансом);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализПлановыхНачислений);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВоинскийУчетБронирование);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВоинскийУчетОбщий);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВыплатыНезарплатныхДоходов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ГрафикОтпусков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДинамикаПлановыхНачислений);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Договорники);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЖурналУчетаИсполнительныхДокументов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗаймыСотрудникам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИзменениеШтатногоРасписания);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИсполнительныеДокументы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КадроваяИсторияСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КонтактнаяИнформацияСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЛицевыеСчетаСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.НаградыСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.НастройкиПрограммыЗарплатаКадры);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОбразованияСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПлановыеУдержанияСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СведенияОбИзмененияхДляВоенкомата);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СоставыСемейСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СостояниеШтатногоРасписания);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СостоянияСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СправкаРасчетРезервыОтпусков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СправкиСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СравнениеПлановыхИФактическихНачислений);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СтажиСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СтатистикаПерсонала);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ТрудоваяДеятельностьСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.УнифицированнаяФормаТ13);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ФактическиеОтпускаСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ШтатноеРасписание);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ШтатноеРасписаниеНачисления);
	
КонецПроцедуры

Процедура ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчета, НаАванс) Экспорт
	
	КоллекцияПользовательскихПолей = НастройкиОтчета.ПользовательскиеПоля.Элементы;
	
	Если КлючВарианта = "Т51"
		Или КлючВарианта = "Т51ПерваяПоловинаМесяца"
		Или КлючВарианта = "Т49"
		Или КлючВарианта = "Т49ПерваяПоловинаМесяца"
		Или КлючВарианта = "Форма0504402"
		Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
		
		Для Каждого ПользовательскоеПоле Из КоллекцияПользовательскихПолей Цикл
			
			Если ПользовательскоеПоле.Заголовок = "ОтработаноРабочихДней" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных <> ""Праздники""
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных <> ""ВыходныеДни""
					|		И ВидРасчета.ВидВремени <> ЗНАЧЕНИЕ(Перечисление.ВидыРабочегоВремениСотрудников.ЦелодневноеНеотработанное)
					|		И ВидРасчета.ВидВремени <> ЗНАЧЕНИЕ(Перечисление.ВидыРабочегоВремениСотрудников.ЧасовоеНеотработанное)
					|		Тогда ОтработаноДней
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноРабочихЧасов" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных <> ""Праздники""
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных <> ""ВыходныеДни""
					|		И ВидРасчета.ВидВремени <> ЗНАЧЕНИЕ(Перечисление.ВидыРабочегоВремениСотрудников.ЦелодневноеНеотработанное)
					|		И ВидРасчета.ВидВремени <> ЗНАЧЕНИЕ(Перечисление.ВидыРабочегоВремениСотрудников.ЧасовоеНеотработанное)
					|		Тогда ОтработаноЧасов
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноПразднВыходныхДней" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И (ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""Праздники""
					|			ИЛИ ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""ВыходныеДни"")
					|		Тогда ОтработаноДней
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноПразднВыходныхЧасов" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И (ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""Праздники""
					|			ИЛИ ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""ВыходныеДни"")
					|		Тогда ОтработаноЧасов
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноПраздничныхДней" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""Праздники""
					|		Тогда ОтработаноДней
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноПраздничныхЧасов" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""Праздники""
					|		Тогда ОтработаноЧасов
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноВыходныхДней" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""ВыходныеДни""
					|		Тогда ОтработаноДней
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ОтработаноВыходныхЧасов" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.ОбозначениеВТабелеУчетаРабочегоВремени.ИмяПредопределенныхДанных = ""ВыходныеДни""
					|		Тогда ОтработаноЧасов
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "НачисленоПовременно" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда)
					|		И ВидРасчета.СпособВыполненияНачисления <> ЗНАЧЕНИЕ(Перечисление.СпособыВыполненияНачислений.ПоОтдельномуДокументуДоОкончательногоРасчета)
					|		Тогда Сумма
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "НачисленоСдельно" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.СдельнаяОплатаТруда)
					|		Тогда Сумма
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "НачисленоВНатуральнойФорме" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
					|		Тогда Сумма
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ПрочиеДоходы" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И (ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени <> ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда) ИЛИ (ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПовременнаяОплатаТруда) И ВидРасчета.СпособВыполненияНачисления = ЗНАЧЕНИЕ(Перечисление.СпособыВыполненияНачислений.ПоОтдельномуДокументуДоОкончательногоРасчета)))
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени <> ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.СдельнаяОплатаТруда)
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени <> ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени <> ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.МатериальнаяПомощь)
					|		ИЛИ ВидРасчета В (ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ДоговорАвторскогоЗаказа),
					|			ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ДоговорРаботыУслуги),
					|			ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.КомпенсацияЗаЗадержкуЗарплаты),
					|			ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеПриРожденииРебенка),
					|			ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеНаПогребениеСотруднику),
					|			ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.ПособиеПриПостановкеНаУчетВРанниеСрокиБеременности))
					|		Тогда Сумма
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ДругиеДоходы" Тогда
				
				Выражение = 
					"Выбор
					|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
					|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.МатериальнаяПомощь)
					|		Тогда Сумма
					|	Иначе 0
					|Конец";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ПрочиеУдержания" Тогда
				
				Если КлючВарианта = "Т51"
					Или КлючВарианта = "Т51ПерваяПоловинаМесяца"
					Или КлючВарианта = "Форма0504402"
					Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
					
					Если НаАванс Тогда
						
						Выражение =
							"Выбор
							|	Когда ВидРасчета <> Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
							|		Тогда Сумма
							|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
							|		Тогда Сумма
							|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
							|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
							|		Тогда Сумма
							|	Иначе 0
							|Конец";
						
					Иначе
						
						Выражение =
							"Выбор
							|	Когда ВидРасчета <> Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
							|		Тогда Сумма
							|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаАванса) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
							|		Тогда Сумма
							|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
							|		Тогда Сумма
							|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
							|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
							|		Тогда Сумма
							|	Иначе 0
							|Конец";
						
					КонецЕсли;
					
				Иначе
					
					Если НаАванс Тогда
						
						Выражение =
							"Выбор
							|	Когда ВидРасчета.КатегорияУдержания = Значение(Перечисление.КатегорииУдержаний.ИсполнительныйЛист) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
							|		Тогда 0
							|	Когда ВидРасчета <> Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
							|		Тогда Сумма
							|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
							|		Тогда 0
							|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
							|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
							|		Тогда Сумма
							|	Иначе 0
							|Конец";
						
					Иначе
						
						Выражение = 
							"Выбор
							|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаАванса) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
							|		Тогда 0
							|	Когда ВидРасчета.КатегорияУдержания = Значение(Перечисление.КатегорииУдержаний.ИсполнительныйЛист) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
							|		Тогда 0
							|	Когда ВидРасчета <> Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
							|		Тогда Сумма
							|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
							|		Тогда 0
							|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
							|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
							|		Тогда Сумма
							|	Иначе 0
							|Конец";
						
					КонецЕсли;
					
				КонецЕсли;
					
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "ВсегоУдержано" Тогда
				
				Если НаАванс Тогда
					
					Выражение =
						"Выбор
						|	Когда ВидРасчета = Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ)
						|		Тогда Сумма
						|	Когда ВидРасчета <> Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
						|		Тогда Сумма
						|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
						|		Тогда Сумма
						|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
						|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
						|		Тогда Сумма
						|	Иначе 0
						|Конец";
					
				Иначе
					
					Выражение =
						"Выбор
						|	Когда ВидРасчета = Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ)
						|		Тогда Сумма
						|	Когда ВидРасчета <> Значение(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Удержано)
						|		Тогда Сумма
						|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаАванса) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
						|		Тогда Сумма
						|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
						|		Тогда Сумма
						|	Когда Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Начислено)
						|		И ВидРасчета.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаТрудаВНатуральнойФорме)
						|		Тогда Сумма
						|	Иначе 0
						|Конец";
					
				КонецЕсли;
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			ИначеЕсли ПользовательскоеПоле.Заголовок = "Аванс"
				И (КлючВарианта = "Т49" Или КлючВарианта = "Т49ПерваяПоловинаМесяца") Тогда
				
				Если НаАванс Тогда
					
					Выражение = 
						"Выбор
						|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
						|		Тогда Сумма
						|	Иначе 0
						|Конец";
					
				Иначе
					
					Выражение = 
						"Выбор
						|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаАванса) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
						|		Тогда Сумма
						|	Когда ВидРасчета = Значение(Перечисление.ВидыВзаиморасчетовССотрудниками.ВыплатаВМежрасчетныйПериод) И Группа = Значение(Перечисление.ГруппыНачисленияУдержанияВыплаты.Выплачено)
						|		Тогда Сумма
						|	Иначе 0
						|Конец";
					
				КонецЕсли;
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей("Сумма(" + Выражение + ")");
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ЗарплатаКадрыОтчеты.ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта) Тогда
		
		Для Каждого ПользовательскоеПоле Из КоллекцияПользовательскихПолей Цикл
			
			Если ПользовательскоеПоле.Заголовок = "УчетВремениВЧасах" Тогда
				
				Выражение = "ЕСТЬNULL(ВидРасчета.УчетВремениВЧасах, Ложь)";
				
				ПользовательскоеПоле.УстановитьВыражениеДетальныхЗаписей(Выражение);
				ПользовательскоеПоле.УстановитьВыражениеИтоговыхЗаписей(Выражение);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьВариантОтчетаРасчетныйЛисток(НастройкиОтчета) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьТарифныеСеткиПриРасчетеЗарплаты")
		Или ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание")
			И ПолучитьФункциональнуюОпцию("ИспользоватьРазрядыКатегорииКлассыДолжностейИПрофессийВШтатномРасписании") Тогда
			
		ДобавитьВГруппировкуРазрядКатегорияГоловногоСотрудникаНаКонецПериода(НастройкиОтчета.Структура);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючВарианта = "РасчетныйЛисток"
		Или КлючВарианта = "РасчетныйЛистокСРазбивкойПоИсточникамФинансирования" Тогда
		
		УстановитьИспользованиеПараметраОтчета("ВыводитьПоказателиНачисленийИУдержаний", НовыеНастройкиКД);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьИспользованиеПараметраОтчета(ИмяПараметра,НовыеНастройкиКД) Экспорт
	
	ПараметрОтчета = НовыеНастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Если ПараметрОтчета <> Неопределено Тогда
		ПараметрОтчета.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	КонецЕсли; 
	
КонецПроцедуры

Функция ДобавитьВГруппировкуРазрядКатегорияГоловногоСотрудникаНаКонецПериода(Структура)
	
	ВставленоПолеГруппировки = Ложь;
	Для каждого ЭлементСтруктуры Из Структура Цикл
		
		Если ЭлементСтруктуры.Использование Тогда
			
			ВставленоПолеГруппировки = Ложь;
			Если ЭлементСтруктуры.ПоляГруппировки.Элементы.Количество() > 0 Тогда
				
				Для каждого ЭлементГруппировки Из ЭлементСтруктуры.ПоляГруппировки.Элементы Цикл
					
					Если ТипЗнч(ЭлементГруппировки) = Тип("ПолеГруппировкиКомпоновкиДанных") Тогда
						
						Если ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("ДолжностьГоловногоСотрудникаНаКонецПериода") Тогда
							
							ПолеГруппировки = ЭлементСтруктуры.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
							ПолеГруппировки.Использование = Истина;
							ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("РазрядКатегорияГоловногоСотрудникаНаКонецПериода");
							
							ВставленоПолеГруппировки = Истина;
							Прервать;
							
						КонецЕсли; 
						
					КонецЕсли; 
					
				КонецЦикла;
				
			КонецЕсли; 
			
			Если Не ВставленоПолеГруппировки Тогда
				ВставленоПолеГруппировки = ДобавитьВГруппировкуРазрядКатегорияГоловногоСотрудникаНаКонецПериода(ЭлементСтруктуры.Структура)
			КонецЕсли; 
			
			Если ВставленоПолеГруппировки Тогда
				Прервать;
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат ВставленоПолеГруппировки;
		
КонецФункции

Функция ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта) Экспорт
	
	ЭтоРасчетныйЛисток = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		ЭтоРасчетныйЛисток = Модуль.ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта);
		
	КонецЕсли;
	
	Если Не ЭтоРасчетныйЛисток Тогда
		
		ЭтоРасчетныйЛисток = ЗарплатаКадрыОтчетыБазовый.ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта)
			Или КлючВарианта = "РасчетныйЛистокПерваяПоловинаМесяца"
			Или КлючВарианта = "РасчетныйЛистокСРазбивкойПоИсточникамФинансированияПерваяПоловинаМесяца";
		
	КонецЕсли;
	
	Возврат ЭтоРасчетныйЛисток;
	
КонецФункции

Функция ДанныеРеестраКадровыхПриказовПоОтборамОтчета(ПериодДатаНачала, ПериодДатаОкончания, ЭлементыОтбора) Экспорт
	
	СписокОрганизаций = Новый Массив;
	СписокСотрудников = Новый Массив;
	
	Для Каждого ОтборОтчета Из ЭлементыОтбора Цикл
		
		Если ТипЗнч(ОтборОтчета) = Тип("ЭлементОтбораКомпоновкиДанных") И ОтборОтчета.Использование Тогда
			
			Если ОтборОтчета.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
				
				Если ТипЗнч(ОтборОтчета.ПравоеЗначение) = Тип("СписокЗначений") Тогда
					СписокОрганизаций = ОтборОтчета.ПравоеЗначение.ВыгрузитьЗначения();
				ИначеЕсли ТипЗнч(ОтборОтчета.ПравоеЗначение) = Тип("Массив") Тогда
					СписокОрганизаций = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ОтборОтчета.ПравоеЗначение);
				Иначе
					СписокОрганизаций.Добавить(ОтборОтчета.ПравоеЗначение);
				КонецЕсли;
				
			КонецЕсли;
			
			Если ОтборОтчета.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудник") Тогда
				
				Если ТипЗнч(ОтборОтчета.ПравоеЗначение) = Тип("СписокЗначений") Тогда
					СписокСотрудников = ОтборОтчета.ПравоеЗначение.ВыгрузитьЗначения();
				ИначеЕсли ТипЗнч(ОтборОтчета.ПравоеЗначение) = Тип("Массив") Тогда
					СписокСотрудников = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ОтборОтчета.ПравоеЗначение);
				Иначе
					СписокСотрудников.Добавить(ОтборОтчета.ПравоеЗначение);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат КадровыйУчетРасширенный.ДанныеРеестраКадровыхПриказов(ПериодДатаОкончания, ПериодДатаНачала, СписокОрганизаций, СписокСотрудников);
	
КонецФункции

Функция НаборыВнешнихДанныхАнализНачисленийИУдержаний() Экспорт
	
	НаборыВнешнихДанных = ЗарплатаКадрыОтчетыБазовый.НаборыВнешнихДанныхАнализНачисленийИУдержаний();
	
	НачисленияУдержанияДокумента = НаборыВнешнихДанных.НачисленияУдержанияДокумента;
	
	НачисленияУдержанияДокумента.Колонки.Добавить("ВремяВЧасах",										Новый ОписаниеТипов("Булево"));
	НачисленияУдержанияДокумента.Колонки.Добавить("Значение",											Новый ОписаниеТипов("Число"));
	НачисленияУдержанияДокумента.Колонки.Добавить("Показатель",											Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"));
	НачисленияУдержанияДокумента.Колонки.Добавить("РазрядКатегорияГоловногоСотрудникаНаКонецПериода",	Новый ОписаниеТипов("СправочникСсылка.РазрядыКатегорииДолжностей"));
	НачисленияУдержанияДокумента.Колонки.Добавить("РазрядКатегорияНаКонецПериода",						Новый ОписаниеТипов("СправочникСсылка.РазрядыКатегорииДолжностей"));
	НачисленияУдержанияДокумента.Колонки.Добавить("РазрядКатегория",									Новый ОписаниеТипов("СправочникСсылка.РазрядыКатегорииДолжностей"));
	
	Возврат НаборыВнешнихДанных;
	
КонецФункции

Функция ЗапросДанныеДокументаФизическихЛиц() Экспорт
	
	Запрос = ЗарплатаКадрыОтчетыБазовый.ЗапросДанныеДокументаФизическихЛиц();
	
	ДополнительныеПоляКадровыхДанныхСотрудников = ЗарплатаКадрыОбщиеНаборыДанных.ПустаяТаблицаДополнительныхПолейПредставлений();
	
	СтрокаДополнительногоПоля = ДополнительныеПоляКадровыхДанныхСотрудников.Добавить();
	СтрокаДополнительногоПоля.ИмяПоля = "РазрядКатегория";
	СтрокаДополнительногоПоля.ПустоеЗначениеНаЯзыкеЗапросов = "ЗНАЧЕНИЕ(Справочник.РазрядыКатегорииДолжностей.ПустаяСсылка)";
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьПсевдонимПоля(
		СтрокаДополнительногоПоля,
		"КадровыеДанныеСотрудников",
		"РазрядКатегория",
		"РабочееМесто.РазрядКатегория");
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьПсевдонимПоля(
		СтрокаДополнительногоПоля,
		"КадровыеДанныеСотрудниковНаКонецПериода",
		"РазрядКатегорияНаКонецПериода",
		"РабочееМесто.РазрядКатегорияНаКонецПериода");
	
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьПсевдонимПоля(
		СтрокаДополнительногоПоля,
		"КадровыеДанныеГоловныхСотрудников",
		"РазрядКатегорияГоловногоСотрудникаНаКонецПериода",
		"РабочееМесто.РазрядКатегорияГоловногоСотрудникаНаКонецПериода",
		НСтр("ru='Разряд категория основного сотрудника на конец периода'"));
	
	ЗарплатаКадрыОбщиеНаборыДанных.ВывестиДополнительныеПоляПредставленийВЗапрос(Запрос, ДополнительныеПоляКадровыхДанныхСотрудников, "Представления_КадровыеДанныеСотрудниковАнализНачисленийИУдержаний");
	
	Возврат Запрос;
	
КонецФункции

Функция НачислениеДоговораГПХПоДокументуОснованию(ДокументОснование) Экспорт
	
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ДоговорАвторскогоЗаказа") Тогда
		Возврат Перечисления.ВидыОсобыхНачисленийИУдержаний.ДоговорАвторскогоЗаказа;
	КонецЕсли;
	
	Возврат Перечисления.ВидыОсобыхНачисленийИУдержаний.ДоговорРаботыУслуги;
	
КонецФункции

#КонецОбласти