#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ о создании комиссии
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.ДекларацияСоответствияУсловийТруда";
	КомандаПечати.Идентификатор = "ФормаОтчета2014Кв1_ФормаОтчета";
	КомандаПечати.Представление = НСтр("ru = 'Декларация соответствия условий труда'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаОтчета2014Кв1_ФормаОтчета") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ФормаОтчета2014Кв1_ФормаОтчета",
			НСтр("ru = 'Декларация соответствия условий труда'"), ПечатьФормаОтчета2014Кв1(МассивОбъектов, ОбъектыПечати), ,
			"Документ.ДекларацияСоответствияУсловийТруда.ФормаОтчета2014Кв1_ФормаОтчета");
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьФормаОтчета2014Кв1(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДекларацияСоответствияУсловийТруда_ПриказОСозданииКомиссии";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДекларацияСоответствияУсловийТруда.ФормаОтчета2014Кв1_ФормаОтчета");
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		ДанныеДокумента = ДанныеПечати.Значение;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОсновнаяЧасть1 = Макет.ПолучитьОбласть("ОсновнаяЧасть1");
		ОсновнаяЧасть1.Параметры.Заполнить(ДанныеДокумента);
		ТабличныйДокумент.Вывести(ОсновнаяЧасть1);
		
		МногострочнаяЧасть = Макет.ПолучитьОбласть("МногострочнаяЧасть");
		Для Каждого СтрокаРабочегоМеста Из ДанныеДокумента.МассивРабочихМест Цикл
			МногострочнаяЧасть.Параметры.РабочееМесто_Численность = СтрокаРабочегоМеста;
			ТабличныйДокумент.Вывести(МногострочнаяЧасть);
		КонецЦикла;
		
		ОсновнаяЧасть2 = Макет.ПолучитьОбласть("ОсновнаяЧасть2");
		ОсновнаяЧасть2.Параметры.Заполнить(ДанныеДокумента);
		ТабличныйДокумент.Вывести(ОсновнаяЧасть2);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ключ);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДекларацияСоответствияУсловийТруда.Ссылка КАК Документ,
	|	ДекларацияСоответствияУсловийТруда.Дата КАК ДатаДокумента,
	|	ДекларацияСоответствияУсловийТруда.Организация КАК Организация,
	|	Организации.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	ДекларацияСоответствияУсловийТруда.Исполнитель.НаименованиеПолное КАК ОПСОУТ,
	|	ДекларацияСоответствияУсловийТруда.Руководитель КАК Руководитель,
	|	ДекларацияСоответствияУсловийТруда.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ДекларацияСоответствияУсловийТруда.РеквизитыЗаключенияЭксперта КАК РеквизитыЗаключенияЭксперта,
	|	ДекларацияСоответствияУсловийТруда.РегистрационныйНомер КАК РегистрационныйНомер,
	|	ДекларацияСоответствияУсловийТрудаРабочиеМеста.РабочееМесто КАК РабочееМесто,
	|	ДекларацияСоответствияУсловийТрудаРабочиеМеста.Численность КАК Численность
	|ИЗ
	|	Документ.ДекларацияСоответствияУсловийТруда КАК ДекларацияСоответствияУсловийТруда
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ДекларацияСоответствияУсловийТруда.Организация = Организации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДекларацияСоответствияУсловийТруда.РабочиеМеста КАК ДекларацияСоответствияУсловийТрудаРабочиеМеста
	|		ПО ДекларацияСоответствияУсловийТруда.Ссылка = ДекларацияСоответствияУсловийТрудаРабочиеМеста.Ссылка
	|ГДЕ
	|	ДекларацияСоответствияУсловийТруда.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ,
	|	РабочееМесто";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Документ") Цикл
		
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Выборка);
		ДанныеПечати.Вставить("ДатаПодписи", Формат(Выборка.ДатаДокумента, "ДЛФ=ДД"));
		ДанныеПечати.Вставить("ОПСОУТ_РегистрационныйНомер", Выборка.ОПСОУТ + ", №" + Выборка.РегистрационныйНомер);
		
		// ФИОРуководителя
		КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, ДанныеПечати.Руководитель, "ФамилияИО, Пол, Фамилия", ОбщегоНазначения.ТекущаяДатаПользователя());
		Для каждого СтрокаКадровыхДанных Из КадровыеДанные Цикл
			ДанныеПечати.Вставить("ФИОРуководителя", СтрокаКадровыхДанных.ФамилияИО);
			ДанныеПечати.Вставить("ПолРуководителя", СтрокаКадровыхДанных.Пол);
			ДанныеПечати.Вставить("ФамилияРуководителя", СтрокаКадровыхДанных.Фамилия);
		КонецЦикла;
		
		// Фактический адрес организации
		АдресаОрганизаций = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресаОрганизаций(Выборка.Организация);
		ОписаниеФактическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
		ДанныеПечати.Вставить("ОрганизацияФактическийАдрес", ОписаниеФактическогоАдреса.Представление);
		
		// Сведения об организации
		СписокПоказателей = Новый Массив;
		СписокПоказателей.Добавить("ИННЮЛ");
		СписокПоказателей.Добавить("ОГРН");
		СведенияОбОрганизации = ЗарплатаКадры.ПолучитьСведенияОбОрганизации(Выборка.Организация, , СписокПоказателей);
		ДанныеПечати.Вставить("ИНН_ОГРН_Организации", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'ИНН %1, ОГРН %2'"),
				СведенияОбОрганизации.ИННЮЛ, СведенияОбОрганизации.ОГРН));
		
		МассивРабочихМест = Новый Массив;
		Пока Выборка.Следующий() Цикл
			ОкончаниеРаботников = "";
			Если Выборка.Численность > 4 И Выборка.Численность <= 20 Тогда
				ОкончаниеРаботников = НСтр("ru = 'ов'");
			ИначеЕсли Прав(Выборка.Численность, 1) = "1" Тогда
				ОкончаниеРаботников = "";
			ИначеЕсли Число(Прав(Выборка.Численность, 1)) >= 2 И Число(Прав(Выборка.Численность, 1)) <= 4 Тогда
				ОкончаниеРаботников = НСтр("ru = 'а'");
			Иначе
				ОкончаниеРаботников = НСтр("ru = 'ов'");
			КонецЕсли;
			СтрокаРабочегоМеста = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, на котором занят%3 %2 работник%4'"),
				Выборка.РабочееМесто, Выборка.Численность, ?(Выборка.Численность = 1, "", НСтр("ru = 'ы'")), ОкончаниеРаботников);
			МассивРабочихМест.Добавить(СтрокаРабочегоМеста);
		КонецЦикла;
		ДанныеПечати.Вставить("МассивРабочихМест", МассивРабочихМест);
		
		// Заполнение соответствия
		ДанныеПечатиОбъектов.Вставить(Выборка.Документ, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли