#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = "СинхронизацияДанныхЧерезУниверсальныйФормат";
	
	Если Параметры.Свойство("ИдентификаторНастройки") Тогда
		ВариантНастройки = Параметры.Свойство("ИдентификаторНастройки");
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаБазыКорреспондентаПриСозданииНаСервере(ЭтаФорма, ИмяПланаОбмена);
	Если Параметры.Свойство("ИдентификаторНастройки") И Параметры.ИдентификаторНастройки = "ОбменУТБП" Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПравилаОтправкиСправочников) Тогда
		ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПравилаОтправкиДокументов) Тогда
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РежимВыгрузкиПриНеобходимости) Тогда
		РежимВыгрузкиПриНеобходимости = 
			Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	КонецЕсли;

	Если ИспользоватьОтборПоОрганизациям Тогда
		
		ПравилоОтбораСправочников = "Отбор";
		
	Иначе
		ПравилоОтбораСправочников = "БезОтбора";
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УстановитьДатуЗапретаИзменений",
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	
	Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" 
		И ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
		
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	// Очистка неиспользуемых реквизитов и заполнение служебных
	
	РежимВыгрузкиПриНеобходимости = 
		ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости");
	
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию");
		
	ИначеЕсли ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости");
		
	Иначе
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию");
		
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	// Сохранение настроек
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	КоллекцияФильтров = Неопределено;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберете организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            ПараметрыВнешнегоСоединения);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументов",
		"Доступность",
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПереключательДокументыНеОтправлять",
		"Доступность",
		Не ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОписаниеДокументыНеОтправлять",
		"Доступность",
		Не ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументы.ПодчиненныеЭлементы,
		"ГруппаРежимОтправкиДокументов",
		"Доступность",
		Не ПравилаОтправкиСправочников = "НеСинхронизировать");
		
	#Область ГруппаНастройкаДополнительныхОтборов
	ВидимостьГруппы = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций")
		И ПравилаОтправкиСправочников <> "НеСинхронизировать";
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаНастройкаДополнительныхОтборов",
		"Видимость",
		ВидимостьГруппы);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ОткрытьСписокВыбранныхОрганизаций",
		"Доступность",
		ИспользоватьОтборПоОрганизациям);
	#КонецОбласти

	#Область ГруппаПрочее
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаСоставПрочихНастроек");
	УстановитьВидимостьГруппыНаСервере(Элементы, "ГруппаПрочее");
	#КонецОбласти

КонецПроцедуры


&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	ЭтаФорма[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		СписокВыбранныхЗначений.Колонки.Идентификатор.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения + "_Ключ";
		ЭтаФорма[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	// Обновим заголовок выбранных организаций
	Если Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	Возврат ЭтаФорма[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения].Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения + "_Ключ").ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения + "_Ключ");
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьГруппыНаСервере(ЭлементыФормы, ИмяГруппы)
	
	ГруппаФормы = ЭлементыФормы.Найти(ИмяГруппы);
	
	Если ГруппаФормы = Неопределено
		Или Не ТипЗнч(ГруппаФормы) = Тип("ГруппаФормы") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Видимость = Ложь;
	
	Для Каждого ПодчиненныйЭлемент Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		
		Если Не ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы")	Тогда
			Продолжить; // устанавливаем видимость только по видимости дочерних групп первого уровня вложенности
		КонецЕсли;
		
		Видимость = Видимость ИЛИ ПодчиненныйЭлемент.Видимость;
			
	КонецЦикла;
	
	ГруппаФормы.Видимость = Видимость;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти