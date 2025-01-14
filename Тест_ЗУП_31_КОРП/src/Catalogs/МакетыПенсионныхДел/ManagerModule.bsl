#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

Функция ПолучитьТекстовоеВложение(Ссылка, ИмяФайла) Экспорт
	
	// получаем вложение
	СтрВложения = КонтекстЭДО().ПолучитьВложения(Ссылка, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	СтрВложение = СтрВложения[0];
	
	// сохраняем вложение на диск
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	СтрВложение.Данные.Получить().Записать(ИмяВременногоФайла);
	
	// считываем при помощи ЧтениеТекста, чтобы автоматически распозналась кодировка UTF? или ANSI
	ОбъектЧтение = Новый ЧтениеТекста(ИмяВременногоФайла);
	СтрТекст = ОбъектЧтение.Прочитать();
	ОбъектЧтение.Закрыть();
	
	// удаляем временный файл
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат СтрТекст;
	
КонецФункции

Функция ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, Идентификатор) Экспорт
	
	СтрВложения = КонтекстЭДО().ПолучитьВложения(Ссылка, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Вложение = СтрВложения[0];
	
	Возврат ПоместитьВоВременноеХранилище(Вложение.Данные.Получить(), Идентификатор);

КонецФункции

Функция ПолучитьНастройки(Организация, ОрганПФР) Экспорт
	
	Размер2МБ = 2097152;
	
	Настройки = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Организация.УчетнаяЗаписьОбмена)
		И ЗначениеЗаполнено(ОрганПФР) Тогда
		
		Если Организация.УчетнаяЗаписьОбмена.СпецоператорСвязи = Перечисления.СпецоператорыСвязи.Такском Тогда
			ВызватьИсключение(НСтр("ru = 'Для абонентов оператора ""Такском"" в настоящее время не предусмотрена возможность отправки макетов пенсионных дел'"));
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("УчетнаяЗапись", Организация.УчетнаяЗаписьОбмена);
		Запрос.УстановитьПараметр("ОрганПФР", ОрганПФР);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПравилаОтправкиМакетовПенсионныхДел.Данные
		|ИЗ
		|	РегистрСведений.ПравилаОтправкиМакетовПенсионныхДел КАК ПравилаОтправкиМакетовПенсионныхДел
		|ГДЕ
		|	ПравилаОтправкиМакетовПенсионныхДел.УчетнаяЗапись = &УчетнаяЗапись
		|	И ПравилаОтправкиМакетовПенсионныхДел.ОрганПФР = &ОрганПФР";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СохраненныеНастройки = Выборка.Данные.Получить();
			Если ЗначениеЗаполнено(СохраненныеНастройки) Тогда
				Настройки = СохраненныеНастройки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Настройки.Свойство("Вложение") Тогда
		Если Не ЗначениеЗаполнено(Настройки.Вложение.МаксимальныйРазмерВложения) Тогда
			Настройки.Вложение.Вставить("МаксимальныйРазмерВложения", Размер2МБ);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Настройки.Вложение.МаксимальныйРазмерФайла) Тогда
			Настройки.Вложение.Вставить("МаксимальныйРазмерФайла", Размер2МБ);
		КонецЕсли;
	КонецЕсли;
		
	Возврат Настройки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#Область ПроцедурыИФункцииПечати

// Функция формирует табличный документ с печатной формой
Функция ПечатьРеестраДокументов(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб				= Истина;
	ТабличныйДокумент.ИмяПараметровПечати		= "ПАРАМЕТРЫ_ПЕЧАТИ_РеестрДокументов_МакетыПенсионныхДел";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.МакетыПенсионныхДел.ПФ_MXL_РеестрДокументов");

	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МакетыПенсионныхДелЭлектронныеДокументы.Файл КАК КоличествоЛистов,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка.ФИО КАК Сотрудник,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка.Организация КАК Организация,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка.СтраховойНомерПФР КАК СНИЛС,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка.АдресРегистрации КАК АдресРегистрации,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Документ КАК Документ,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка.Телефон КАК Телефон,
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.МакетыПенсионныхДел.ЭлектронныеДокументы КАК МакетыПенсионныхДелЭлектронныеДокументы
	|ГДЕ
	|	МакетыПенсионныхДелЭлектронныеДокументы.Ссылка В(&МассивСсылок)
	|	И МакетыПенсионныхДелЭлектронныеДокументы.Файл <> ЗНАЧЕНИЕ(Справочник.МакетыПенсионныхДелПрисоединенныеФайлы.ПустаяСсылка)
	|	И МакетыПенсионныхДелЭлектронныеДокументы.Документ <> ""Реестр""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документ
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КоличествоЛистов)
	|ПО
	|	Ссылка,
	|	Документ";
	
	ВыборкаСсылка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаСсылка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ШапкаВыведена = Ложь;
		
		ВыборкаДокумент = ВыборкаСсылка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ПорядковыйНомер = 1;
		Пока ВыборкаДокумент.Следующий() Цикл
			Если Не ШапкаВыведена Тогда
				ОбластьШапка.Параметры.Заполнить(ВыборкаДокумент);
				Если ЗначениеЗаполнено(ВыборкаДокумент.Телефон) Тогда
					АдресИТелефон = СтрШаблон("%1
                                               |тел. %2", ВыборкаДокумент.АдресРегистрации, ВыборкаДокумент.Телефон);
				Иначе
					АдресИТелефон = СтрШаблон("%1", ВыборкаДокумент.АдресРегистрации);
				КонецЕсли;									   				
				ОбластьШапка.Параметры.АдресРегистрацииИТелефон = АдресИТелефон;
				
				РеквизитыОрганизации = "РегНомПФР, ТелОрганизации, НаимЮЛПол";				
				СтруктураДанныхОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(ВыборкаДокумент.Организация,, РеквизитыОрганизации);
				ОбластьШапка.Параметры.Организация = СтруктураДанныхОрганизации.НаимЮЛПол;
				ОбластьШапка.Параметры.РегистрационныйНомерПФР = СтруктураДанныхОрганизации.РегНомПФР;
				ТабличныйДокумент.Вывести(ОбластьШапка);
				ШапкаВыведена = Истина;
			КонецЕсли;
			ОбластьСтрока.Параметры.ПорядковыйНомер = ПорядковыйНомер;
			ОбластьСтрока.Параметры.Документ = ВыборкаДокумент.Документ;
			ОбластьСтрока.Параметры.КоличествоЛистов = ВыборкаДокумент.КоличествоЛистов;
			ТабличныйДокумент.Вывести(ОбластьСтрока);
			
			ПорядковыйНомер = ПорядковыйНомер + 1;
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		ТабличныйДокумент.ТолькоПросмотр = Истина;
		
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаСсылка.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РеестрДокументов") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РеестрДокументов", "Реестр документов",
			ПечатьРеестраДокументов(МассивОбъектов, ОбъектыПечати), , "Справочник.МакетыПенсионныхДел.ПФ_MXL_РеестрДокументов");
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

Функция КонтекстЭДО()
	
	Возврат ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
КонецФункции

#КонецОбласти

#КонецЕсли