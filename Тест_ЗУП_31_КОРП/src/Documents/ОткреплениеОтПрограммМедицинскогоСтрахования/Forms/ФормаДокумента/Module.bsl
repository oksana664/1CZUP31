
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда 
		
		МассивСотрудников = Неопределено;
		Если Параметры.Свойство("ЗначенияЗаполнения") И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения) Тогда
			ЗаполнитьЗначенияСвойств(Объект, Параметры.ЗначенияЗаполнения, , "Сотрудники");
			Если Параметры.ЗначенияЗаполнения.Свойство("Сотрудники") И ТипЗнч(Параметры.ЗначенияЗаполнения.Сотрудники) = Тип("Массив") Тогда
				МассивСотрудников = Параметры.ЗначенияЗаполнения.Сотрудники;
			КонецЕсли;
		Иначе
			ЗначенияДляЗаполнения = Новый Структура;
			ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
			Если Не Параметры.Свойство("ЗначенияЗаполнения") Или Не Параметры.ЗначенияЗаполнения.Свойство("Подразделение") Тогда
				// Подразделение (пустое значение) может быть передано как параметр заполнения из обработки.
				ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
			КонецЕсли;
			ЗначенияДляЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
			ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		КонецЕсли;
		
		ПриПолученииДанныхНаСервере();
		СотрудникиЗаполнитьНаСервере(МассивСотрудников);
		
	Иначе
		
		// Если это открытие уже существующего документа, 
		// то оно может выполняться в режиме добавления строк.
		Если Параметры.Свойство("ЗначенияЗаполнения") И Параметры.ЗначенияЗаполнения.Свойство("Сотрудники") Тогда
			МассивСотрудников = Новый Массив;
			Для Каждого ПараметрСотрудник Из Параметры.ЗначенияЗаполнения.Сотрудники Цикл
				НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ПараметрСотрудник));
				Если НайденныеСтроки.Количество() = 0 Тогда
					МассивСотрудников.Добавить(ПараметрСотрудник);
				КонецЕсли;
			КонецЦикла;
			
			Если МассивСотрудников.Количество() > 0 Тогда
				СотрудникиЗаполнитьНаСервере(МассивСотрудников);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ТекущийОбъект.ДатаОтправки = Дата(Год(ТекущийОбъект.Дата), Месяц(ТекущийОбъект.Дата), День(ТекущийОбъект.Дата), Час(ТекущаяДата), Минута(ТекущаяДата), Секунда(ТекущаяДата));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ОткреплениеОтПрограммМедицинскогоСтрахования", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборФорматаВложений") Тогда
		
		Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> КодВозвратаДиалога.Отмена Тогда
			ПараметрыОтправки = ПараметрыОтправкиПисьма(ВыбранноеЗначение);
			
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтраховаяКомпанияПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиОбработкаВыбораНаСервере(ТекущиеДанные.Сотрудник);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиДатаОкончанияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиДатаПриИзмененииНаСервере(ТекущиеДанные.Сотрудник, ТекущиеДанные.ДатаОткрепления, ТекущиеДанные.ДатаРождения);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПрограммыСтрахованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	ОповещениеЗавершения = Новый ОписаниеОповещения("СотрудникиПрограммыСтрахованияЗавершениеРедактирования", ЭтотОбъект, ТекущиеДанные);
	МедицинскоеСтрахованиеКлиент.ПрограммыСтрахованияРедактировать(
		ЭтотОбъект, ТекущиеДанные, "ПрограммыСтрахованияСотрудников", "Сотрудник",
		ТекущиеДанные.ДатаОткрепления + ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах(), ОповещениеЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиРасширенияПрограммСтрахованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	ОповещениеЗавершения = Новый ОписаниеОповещения("СотрудникиРасширенияПрограммСтрахованияЗавершениеРедактирования", ЭтотОбъект, ТекущиеДанные);
	МедицинскоеСтрахованиеКлиент.РасширенияПрограммСтрахованияРедактировать(
		ЭтотОбъект, ТекущиеДанные, "РасширенияПрограммСтрахованияСотрудников", "Сотрудник",
		ТекущиеДанные.ДатаОткрепления + ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах(), ОповещениеЗавершения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СотрудникиЗаполнить(Команда)
	СотрудникиЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДатуПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,
		Объект.Организация,
		Объект.Подразделение,
		Объект.Дата,
		Истина,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьПечатныеФормыПоПочтеНастройкаУчетнойЗаписиПредложена", ЭтотОбъект);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтправитьПечатныеФормыПоПочтеНастройкаУчетнойЗаписиПредложена(УчетнаяЗаписьНастроена, ДополнительныеПараметры) Экспорт
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ИмяОткрываемойФормы = "ОбщаяФорма.ВыборФорматаВложений";
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиЗаполнитьНаСервере(Сотрудники = Неопределено)
	
	Если Сотрудники = Неопределено Тогда
		Объект.Сотрудники.Очистить();
		Объект.ПрограммыСтрахованияСотрудников.Очистить();
		Объект.РасширенияПрограммСтрахованияСотрудников.Очистить();
	Иначе
		Для Каждого СотрудникМассива Из Сотрудники Цикл
			
			СтруктураОтбора = Новый Структура("Сотрудник", СотрудникМассива);
			НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(СтруктураОтбора);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Объект.Сотрудники.Удалить(НайденнаяСтрока);
			КонецЦикла;
			
			СтруктураОтбора = Новый Структура("Сотрудник", СотрудникМассива);
			НайденныеСтроки = Объект.ПрограммыСтрахованияСотрудников.НайтиСтроки(СтруктураОтбора);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Объект.ПрограммыСтрахованияСотрудников.Удалить(НайденнаяСтрока);
			КонецЦикла;
			
			СтруктураОтбора = Новый Структура("Сотрудник", СотрудникМассива);
			НайденныеСтроки = Объект.РасширенияПрограммСтрахованияСотрудников.НайтиСтроки(СтруктураОтбора);
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				Объект.РасширенияПрограммСтрахованияСотрудников.Удалить(НайденнаяСтрока);
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СтраховаяКомпания", Объект.СтраховаяКомпания);
	Запрос.УстановитьПараметр("ОткреплятьСотрудниковВОтпускеПоУходуЗаРебенком", ОткреплятьСотрудниковВОтпускеПоУходуЗаРебенком);
	Запрос.УстановитьПараметр("ДатаОкончанияСтрахования", Объект.ДатаОкончанияСтрахования);
	Запрос.УстановитьПараметр("ИсключаемыйРегистратор", Объект.Ссылка);
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Объект.Организация;
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ПараметрыПолученияСотрудников.Подразделение = Объект.Подразделение;
	КонецЕсли;
	ПараметрыПолученияСотрудников.НачалоПериода 	= Объект.ДатаНачалаСтрахования;
	ПараметрыПолученияСотрудников.ОкончаниеПериода	= Объект.ДатаОкончанияСтрахования;
	ПараметрыПолученияСотрудников.КадровыеДанные	= "Организация, ДатаУвольнения, ДатаРождения";
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников);
	
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("ОтборНеУстановлен", Сотрудники = Неопределено);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СотрудникиОрганизации.ДатаУвольнения КАК ДатаОткрепления,
	|	СотрудникиОрганизации.ДатаРождения КАК ДатаРождения
	|ПОМЕСТИТЬ ВТСотрудникиСОтбором
	|ИЗ
	|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
	|ГДЕ
	|	(&ОтборНеУстановлен = ИСТИНА
	|			ИЛИ СотрудникиОрганизации.Сотрудник В (&Сотрудники))";
	Запрос.Выполнить();
	
	Если ОткреплятьСотрудниковВОтпускеПоУходуЗаРебенком Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиСОтбором.Сотрудник КАК Сотрудник
		|ИЗ
		|	ВТСотрудникиСОтбором КАК СотрудникиСОтбором";
		
		МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
		
		Состояния = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.СостоянияСотрудника.ОтпускПоУходуЗаРебенком);
		СостоянияСотрудников.СоздатьВТСостоянияСотрудников(
			Запрос.МенеджерВременныхТаблиц, МассивСотрудников, Состояния, Объект.ДатаНачалаСтрахования, Объект.ДатаОкончанияСтрахования);
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 0
		|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
		|	NULL КАК Начало
		|ПОМЕСТИТЬ ВТСостоянияСотрудников";
		Запрос.Выполнить();
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МИНИМУМ(Сотрудники.ДатаОткрепления) КАК ДатаОткрепления,
	|	Сотрудники.ДатаРождения КАК ДатаРождения
	|ПОМЕСТИТЬ ВТОткрепляемыеСотрудники
	|ИЗ
	|	(ВЫБРАТЬ
	|		СотрудникиСОтбором.Сотрудник КАК Сотрудник,
	|		СотрудникиСОтбором.ФизическоеЛицо КАК ФизическоеЛицо,
	|		СотрудникиСОтбором.ДатаОткрепления КАК ДатаОткрепления,
	|		СотрудникиСОтбором.ДатаРождения КАК ДатаРождения
	|	ИЗ
	|		ВТСотрудникиСОтбором КАК СотрудникиСОтбором
	|	ГДЕ
	|		ВЫБОР
	|				КОГДА СотрудникиСОтбором.ДатаОткрепления = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА НЕ &ОтборНеУстановлен
	|				ИНАЧЕ СотрудникиСОтбором.ДатаОткрепления <> ДАТАВРЕМЯ(1, 1, 1)
	|			КОНЕЦ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СостоянияСотрудников.Сотрудник,
	|		СостоянияСотрудников.Сотрудник.ФизическоеЛицо,
	|		СостоянияСотрудников.Начало,
	|		СостоянияСотрудников.Сотрудник.ФизическоеЛицо.ДатаРождения
	|	ИЗ
	|		ВТСостоянияСотрудников КАК СостоянияСотрудников) КАК Сотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	Сотрудники.Сотрудник,
	|	Сотрудники.ФизическоеЛицо,
	|	Сотрудники.ДатаРождения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиНеПрикрепленные.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТОтложенныеСотрудники
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиНеПрикрепленные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтложенноеМедицинскоеСтрахованиеСотрудников КАК ОтложенноеМедицинскоеСтрахованиеСотрудников
	|		ПО СотрудникиНеПрикрепленные.Сотрудник = ОтложенноеМедицинскоеСтрахованиеСотрудников.Сотрудник
	|			И (ОтложенноеМедицинскоеСтрахованиеСотрудников.Организация = &Организация)
	|			И (ОтложенноеМедицинскоеСтрахованиеСотрудников.СтраховаяКомпания = &СтраховаяКомпания)
	|ГДЕ
	|	&ОтборНеУстановлен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрограммыМедицинскогоСтрахованияСотрудников.Организация КАК Организация,
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МАКСИМУМ(ПрограммыМедицинскогоСтрахованияСотрудников.Период) КАК Период
	|ПОМЕСТИТЬ ВТМаксимальныеПериодыПрограммСтрахования
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПрограммыМедицинскогоСтрахованияСотрудников КАК ПрограммыМедицинскогоСтрахованияСотрудников
	|		ПО (ПрограммыМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|			И (ПрограммыМедицинскогоСтрахованияСотрудников.Регистратор <> &ИсключаемыйРегистратор)
	|ГДЕ
	|	ПрограммыМедицинскогоСтрахованияСотрудников.Период <= &ДатаОкончанияСтрахования
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрограммыМедицинскогоСтрахованияСотрудников.Организация,
	|	СотрудникиОрганизации.Сотрудник,
	|	ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация КАК Организация,
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МАКСИМУМ(РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период) КАК Период
	|ПОМЕСТИТЬ ВТМаксимальныеПериодыРасширенийСтрахования
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РасширенияПрограммМедицинскогоСтрахованияСотрудников КАК РасширенияПрограммМедицинскогоСтрахованияСотрудников
	|		ПО (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|			И (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Регистратор <> &ИсключаемыйРегистратор)
	|ГДЕ
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период <= &ДатаОкончанияСтрахования
	|
	|СГРУППИРОВАТЬ ПО
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация,
	|	СотрудникиОрганизации.Сотрудник,
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	СотрудникиОрганизации.ДатаОткрепления КАК ДатаОткрепления,
	|	СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СотрудникиОрганизации.ДатаРождения КАК ДатаРождения,
	|	ПрограммыМедицинскогоСтрахованияСотрудников.ПрограммаСтрахования КАК ПрограммаСтрахования,
	|	ПрограммыМедицинскогоСтрахованияСотрудников.СтраховаяПремия КАК СтраховаяПремия
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПрограммыМедицинскогоСтрахованияСотрудников КАК ПрограммыМедицинскогоСтрахованияСотрудников
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимальныеПериодыПрограммСтрахования КАК МаксимальныеПериодыПрограммСтрахования
	|			ПО ПрограммыМедицинскогоСтрахованияСотрудников.Период = МаксимальныеПериодыПрограммСтрахования.Период
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = МаксимальныеПериодыПрограммСтрахования.ФизическоеЛицо
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.Организация = МаксимальныеПериодыПрограммСтрахования.Организация
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПрограммыМедицинскогоСтрахованияСотрудников КАК ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение
	|			ПО (ПрограммыМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.Период = ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.Период
	|				И (ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.Регистратор ССЫЛКА Документ.ОткреплениеОтПрограммМедицинскогоСтрахования)
	|		ПО (ПрограммыМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|			И СотрудникиОрганизации.ДатаОткрепления > ПрограммыМедицинскогоСтрахованияСотрудников.Период
	|			И (ПрограммыМедицинскогоСтрахованияСотрудников.Регистратор <> &ИсключаемыйРегистратор)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтложенныеСотрудники КАК ОтложенныеСотрудники
	|		ПО СотрудникиОрганизации.Сотрудник = ОтложенныеСотрудники.Сотрудник
	|ГДЕ
	|	(ОтложенныеСотрудники.Сотрудник ЕСТЬ NULL
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|				И ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо ЕСТЬ NULL
	|			ИЛИ НЕ &ОтборНеУстановлен)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СотрудникиОрганизации.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	СотрудникиОрганизации.ДатаОткрепления КАК ДатаОткрепления,
	|	СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СотрудникиОрганизации.ДатаРождения КАК ДатаРождения,
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.РасширениеПрограммСтрахования КАК РасширениеПрограммСтрахования,
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.СтраховаяПремия КАК СтраховаяПремия
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасширенияПрограммМедицинскогоСтрахованияСотрудников КАК РасширенияПрограммМедицинскогоСтрахованияСотрудников
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимальныеПериодыРасширенийСтрахования КАК МаксимальныеПериодыРасширенийСтрахования
	|			ПО РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период = МаксимальныеПериодыРасширенийСтрахования.Период
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = МаксимальныеПериодыРасширенийСтрахования.ФизическоеЛицо
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = МаксимальныеПериодыРасширенийСтрахования.Организация
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасширенияПрограммМедицинскогоСтрахованияСотрудников КАК РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение
	|			ПО (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период = РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.Период
	|				И (РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.Регистратор ССЫЛКА Документ.ОткреплениеОтПрограммМедицинскогоСтрахования)
	|		ПО (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|			И СотрудникиОрганизации.ДатаОткрепления > РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период
	|			И (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Регистратор <> &ИсключаемыйРегистратор)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтложенныеСотрудники КАК ОтложенныеСотрудники
	|		ПО СотрудникиОрганизации.Сотрудник = ОтложенныеСотрудники.Сотрудник
	|ГДЕ
	|	(ОтложенныеСотрудники.Сотрудник ЕСТЬ NULL
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо ЕСТЬ NULL
	|			ИЛИ НЕ &ОтборНеУстановлен)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СотрудникиОрганизации.Сотрудник";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	МассивСтруктурПрограмм = Новый Массив;
	ВыборкаПрограммыСтрахования = РезультатЗапроса[РезультатЗапроса.ВГраница()-1].Выбрать();
	Пока ВыборкаПрограммыСтрахования.СледующийПоЗначениюПоля("Сотрудник") Цикл
		
		НоваяСтрока = Объект.Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПрограммыСтрахования);
		
		Пока ВыборкаПрограммыСтрахования.СледующийПоЗначениюПоля("ПрограммаСтрахования") Цикл
			Если Не ЗначениеЗаполнено(ВыборкаПрограммыСтрахования.ПрограммаСтрахования) Тогда
				Продолжить;
			КонецЕсли;
			ДатыСтрахования = Новый Структура;
			ДатыСтрахования.Вставить("ДатаНачала", ВыборкаПрограммыСтрахования.ДатаОткрепления + ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах());
			ДатыСтрахования.Вставить("ДатаОкончания", Объект.ДатаОкончанияСтрахования);
			ДатыСтрахования.Вставить("ДатаНачалаСтрахования", Объект.ДатаНачалаСтрахования);
			ДатыСтрахования.Вставить("ДатаОкончанияСтрахования", Объект.ДатаОкончанияСтрахования);
			
			СтруктураПрограммы = Новый Структура;
			СтруктураПрограммы.Вставить("ПрограммаСтрахования", ВыборкаПрограммыСтрахования.ПрограммаСтрахования);
			СтруктураПрограммы.Вставить("СтраховаяПремия", МедицинскоеСтрахование.СтраховаяПремия(
				ВыборкаПрограммыСтрахования.ПрограммаСтрахования, ДатыСтрахования, ВыборкаПрограммыСтрахования.ДатаРождения, ШкалаВозрастов, Истина));
			МассивСтруктурПрограмм.Добавить(СтруктураПрограммы);
		КонецЦикла;
		МедицинскоеСтрахованиеФормы.УстановитьПрограммыСтрахования(Объект, НоваяСтрока, "ПрограммыСтрахованияСотрудников", "Сотрудник", МассивСтруктурПрограмм);
	КонецЦикла;
	
	МассивСтруктурРасширений = Новый Массив;
	ВыборкаРасширенияСтрахования = РезультатЗапроса[РезультатЗапроса.ВГраница()].Выбрать();
	Пока ВыборкаРасширенияСтрахования.СледующийПоЗначениюПоля("Сотрудник") Цикл
		
		ПараметрыОтбора = Новый Структура("Сотрудник", ВыборкаРасширенияСтрахования.Сотрудник);
		НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 0 Тогда
			НоваяСтрока = Объект.Сотрудники.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРасширенияСтрахования);
		КонецЕсли;
		
		Пока ВыборкаРасширенияСтрахования.СледующийПоЗначениюПоля("РасширениеПрограммСтрахования") Цикл
			Если Не ЗначениеЗаполнено(ВыборкаРасширенияСтрахования.РасширениеПрограммСтрахования) Тогда
				Продолжить;
			КонецЕсли;
			ДатыСтрахования = Новый Структура;
			ДатыСтрахования.Вставить("ДатаНачала", ВыборкаРасширенияСтрахования.ДатаОткрепления + ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах());
			ДатыСтрахования.Вставить("ДатаОкончания", Объект.ДатаОкончанияСтрахования);
			ДатыСтрахования.Вставить("ДатаНачалаСтрахования", Объект.ДатаНачалаСтрахования);
			ДатыСтрахования.Вставить("ДатаОкончанияСтрахования", Объект.ДатаОкончанияСтрахования);
			
			СтруктураРасширения = Новый Структура;
			СтруктураРасширения.Вставить("РасширениеСтрахования", ВыборкаРасширенияСтрахования.РасширениеПрограммСтрахования);
			СтруктураРасширения.Вставить("СтраховаяПремия", МедицинскоеСтрахование.СтраховаяПремия(
				ВыборкаРасширенияСтрахования.РасширениеПрограммСтрахования, ДатыСтрахования, ВыборкаРасширенияСтрахования.ДатаРождения, ШкалаВозрастов, Истина));
			МассивСтруктурРасширений.Добавить(СтруктураРасширения);
		КонецЦикла;
		МедицинскоеСтрахованиеФормы.УстановитьРасширенияПрограммСтрахования(Объект, НоваяСтрока, "РасширенияПрограммСтрахованияСотрудников", "Сотрудник", МассивСтруктурРасширений);
	КонецЦикла;
	
	РассчитатьСтраховуюПремиюСотрудников(Сотрудники);
	
	Объект.Сотрудники.Сортировать("Сотрудник");
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОсновныхПолейНаСервере()
	МедицинскоеСтрахованиеФормы.ОткреплениеПрочитатьНастройки(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура РассчитатьСтраховуюПремиюСотрудников(Сотрудники = Неопределено)
	
	СтруктураИменТаблиц = МедицинскоеСтрахованиеФормы.СтруктураИменТаблиц();
	СтруктураИменТаблиц.ИмяТаблицыСотрудники = "Сотрудники";
	СтруктураИменТаблиц.ИмяТаблицыПрограммыСтрахованияСотрудников = "ПрограммыСтрахованияСотрудников";
	СтруктураИменТаблиц.ИмяТаблицыРасширенийПрограммСтрахованияСотрудников = "РасширенияПрограммСтрахованияСотрудников";
	МедицинскоеСтрахованиеФормы.РассчитатьСтраховуюПремиюСотрудников(Объект, СтруктураИменТаблиц, Сотрудники);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура СотрудникиОбработкаВыбораНаСервере(ВыбранныеСотрудники)

	Если ТипЗнч(ВыбранныеСотрудники) = Тип("Массив") Тогда
		МассивСотрудников = ВыбранныеСотрудники;
	Иначе
		МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеСотрудники);
	КонецЕсли;
	
	Если МассивСотрудников.Количество() > 0 Тогда
		
		СотрудникиЗаполнитьНаСервере(МассивСотрудников);
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиДатаПриИзмененииНаСервере(Сотрудник, ДатаНачала, ДатаРождения)
	
	ДатыСтрахования = Новый Структура;
	ДатыСтрахования.Вставить("ДатаНачала", ДатаНачала);
	ДатыСтрахования.Вставить("ДатаОкончания", Объект.ДатаОкончанияСтрахования);
	ДатыСтрахования.Вставить("ДатаНачалаСтрахования", Объект.ДатаНачалаСтрахования);
	ДатыСтрахования.Вставить("ДатаОкончанияСтрахования", Объект.ДатаОкончанияСтрахования);
	
	ПараметрыОтбора = Новый Структура("Сотрудник", Сотрудник);
	СтрокиПрограмм = Объект.ПрограммыСтрахованияСотрудников.НайтиСтроки(ПараметрыОтбора);
	Для Каждого СтрокаТаблицы Из СтрокиПрограмм Цикл
		СтрокаТаблицы.СтраховаяПремия = МедицинскоеСтрахование.СтраховаяПремия(
			СтрокаТаблицы.ПрограммаСтрахования, ДатыСтрахования, ДатаРождения, ШкалаВозрастов, Истина);
	КонецЦикла;
	СтрокиРасширений = Объект.РасширенияПрограммСтрахованияСотрудников.НайтиСтроки(ПараметрыОтбора);
	Для Каждого СтрокаТаблицы Из СтрокиРасширений Цикл
		СтрокаТаблицы.СтраховаяПремия = МедицинскоеСтрахование.СтраховаяПремия(
			СтрокаТаблицы.РасширениеСтрахования, ДатыСтрахования, ДатаРождения, ШкалаВозрастов, Истина);
	КонецЦикла;
	
	РассчитатьСтраховуюПремиюСотрудников(Сотрудник);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОтправкиПисьма(ВыбранноеЗначение)
	Возврат МедицинскоеСтрахование.ПараметрыОтправкиПисьма(ЭтотОбъект, ВыбранноеЗначение, Получатели, НСтр("ru = 'Открепление сотрудников'"));
КонецФункции

&НаКлиенте
Процедура СотрудникиПрограммыСтрахованияЗавершениеРедактирования(Результат, ТекущиеДанные) Экспорт
	
	Если Результат <> Неопределено Тогда
		СотрудникиПрограммыСтрахованияЗавершениеРедактированияНаСервере(Результат, ТекущиеДанные.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиПрограммыСтрахованияЗавершениеРедактированияНаСервере(Результат, ИдентификаторСтроки)
	
	Если Результат <> Неопределено Тогда
		
		СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
		МедицинскоеСтрахованиеФормы.УстановитьПрограммыСтрахования(Объект, СтрокаСотрудника, "ПрограммыСтрахованияСотрудников", "Сотрудник", Результат);
		
		РассчитатьСтраховуюПремиюСотрудников(СтрокаСотрудника.Сотрудник);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиРасширенияПрограммСтрахованияЗавершениеРедактирования(Результат, ТекущиеДанные) Экспорт
	
	Если Результат <> Неопределено Тогда
		СотрудникиРасширенияПрограммСтрахованияЗавершениеРедактированияНаСервере(Результат, ТекущиеДанные.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СотрудникиРасширенияПрограммСтрахованияЗавершениеРедактированияНаСервере(Результат, ИдентификаторСтроки)
	
	Если Результат <> Неопределено Тогда
		
		СтрокаСотрудника = Объект.Сотрудники.НайтиПоИдентификатору(ИдентификаторСтроки);
		МедицинскоеСтрахованиеФормы.УстановитьРасширенияПрограммСтрахования(Объект, СтрокаСотрудника, "РасширенияПрограммСтрахованияСотрудников", "Сотрудник", Результат);
		
		РассчитатьСтраховуюПремиюСотрудников(СтрокаСотрудника.Сотрудник);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
