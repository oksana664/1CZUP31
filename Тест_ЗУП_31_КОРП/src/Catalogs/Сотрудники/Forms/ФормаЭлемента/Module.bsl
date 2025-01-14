#Область ОписаниеПеременных

&НаКлиенте
Перем ОткрытыеФормы Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.ВерсионированиеОбъектов
		ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
		
		// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
		// СтандартныеПодсистемы.Свойства
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Объект", Сотрудник);
		ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
		УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, ФизическоеЛицо.ФИО, "ФизическоеЛицо");	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

	СотрудникиФормы.СотрудникиПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Ключ.Пустая() Тогда
		УстановитьОтображениеГруппВСотрудников();
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПодборПерсоналаФормы");
		Модуль.ПриСозданииНаСервереФормыСотрудника(ЭтотОбъект, ФизическоеЛицоСсылка, ТекущаяДолжностьПоШтатномуРасписанию);
	КонецЕсли;
	
	ОбновитьВидимостьПричиныУвольнения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПослеОткрытияФормы", 0.1, Истина);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	Если Модифицированность Тогда
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
	Иначе
		СотрудникиКлиент.ПроверитьНеобходимостьЗаписи(ЭтотОбъект, Отказ);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()

	СотрудникиКлиент.СотрудникиПриЗакрытии(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененЗаголовокФормыСотрудника" Тогда
		
		// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
		СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

	КонецЕсли;
		
	Если ИмяСобытия = "ИзменениеПричинУвольненияСотрудника" И Источник = Сотрудник.Ссылка Тогда  
		ОбновитьПричинуУвольнения();
	КонецЕсли;
	
	СотрудникиКлиент.СотрудникиОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	СотрудникиФормы.СотрудникиПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаГрупп = ГруппыСотрудников.ГруппыСотрудников(СотрудникСсылка, Ложь);
	СписокГруппСотрудников.ЗагрузитьЗначения(ТаблицаГрупп.ВыгрузитьКолонку("Группа"));
	УстановитьПривилегированныйРежим(Ложь);
	
	УстановитьОтображениеГруппВСотрудников();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Сотрудник);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если НЕ Отказ И НЕ ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		ЗаписатьНаКлиенте(Ложь, , Отказ);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Контактная информация
	Если КонтактнаяИнформацияФизическогоЛица <> Неопределено Тогда
		УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(КонтактнаяИнформацияФизическогоЛица, ФизическоеЛицо);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Контактная информация
	
	СотрудникиФормы.СотрудникиПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	СотрудникиФормы.СотрудникиПриЗаписиНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	СписокГруппСотрудников.ЗаполнитьПометки(Ложь);
	ТаблицаГрупп = ГруппыСотрудников.ГруппыСотрудников(СотрудникСсылка, Ложь);
	Для каждого СтрокаТаблицы Из ТаблицаГрупп Цикл
		
		ЭлементСписка = СписокГруппСотрудников.НайтиПоЗначению(СтрокаТаблицы.Группа);
		Если ЭлементСписка = Неопределено Тогда
			
			НаборЗаписей = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Сотрудник.Установить(СтрокаТаблицы.Сотрудник);
			НаборЗаписей.Отбор.ГруппаСотрудников.Установить(СтрокаТаблицы.Группа);
			
			НаборЗаписей.Записать();
			
		Иначе
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого ЭлементСписка Из СписокГруппСотрудников Цикл
		
		Если Не ЭлементСписка.Пометка Тогда
			
			НаборЗаписей = РегистрыСведений.СоставГруппСотрудников.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Сотрудник.Установить(СотрудникСсылка);
			НаборЗаписей.Отбор.ГруппаСотрудников.Установить(ЭлементСписка.Значение);
			
			Запись = НаборЗаписей.Добавить();
			Запись.Сотрудник = СотрудникСсылка;
			Запись.ГруппаСотрудников = ЭлементСписка.Значение;
			
			НаборЗаписей.Записать();
			
		КонецЕсли; 
		
	КонецЦикла;
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиНаСервере(ЭтотОбъект, ФизическоеЛицо.ФИО, ФизическоеЛицо.Ссылка, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = Перечисления.ПолФизическогоЛица.Мужской, 1, 2), Неопределено));	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	СотрудникиФормы.СотрудникиПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	СотрудникиКлиент.СотрудникиПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Сотрудник.Ссылка = Сотрудник.ГоловнойСотрудник Тогда
		
		// СтандартныеПодсистемы.Свойства
		УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Сотрудник);
		// Конец СтандартныеПодсистемы.Свойства
		
	КонецЕсли;
	
	СотрудникиФормы.СотрудникиОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокГруппСотрудниковДекорацияНажатие(Элемент)
	
	ВыбратьГруппыСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГруппСотрудниковНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьГруппыСотрудников();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКолокольчикАктивныйНажатие(Элемент)
	ОткрытьФормуНапоминаниеОДнеРождения();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКолокольчикНеАктивныйНажатие(Элемент)
	ОткрытьФормуНапоминаниеОДнеРождения();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеФормыНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиентРасширенный.ОбработатьСобытиеДополнительногоПоляФормыНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_ПояснениеНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВ"

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, РеквизитФормыВЗначение("Сотрудник"));

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с другими сотрудниками.

&НаКлиенте
Процедура Подключаемый_ОткрытьФормуСотрудника(Команда)

	СотрудникиКлиент.ОткрытьФормуСотрудника(ЭтотОбъект, Команда);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДругиеМестаРаботы(Команда)

	СотрудникиКлиент.ОткрытьФормуСпискаМестРаботыФизическогоЛица(ФизическоеЛицоСсылка, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Сотрудник);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Сотрудник, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Сотрудник);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ОформитьПриемНаРаботу(Команда)

	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, СотрудникСсылка, "Документы.ПриемНаРаботу");

КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорРаботыУслуги(Команда)

	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, СотрудникСсылка, "Документы.ДоговорРаботыУслуги");

КонецПроцедуры

&НаКлиенте
Процедура ОформитьДоговорАвторскогоЗаказа(Команда)

	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, СотрудникСсылка, "Документы.ДоговорАвторскогоЗаказа");

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОформитьНаОсновании(Команда)
	
	СотрудникиКлиент.ОформитьНаОсновании(ЭтотОбъект, СотрудникСсылка, Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда) Экспорт
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ОбработатьКомандуСклонения(ЭтотОбъект, ФизическоеЛицо.ФИО, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
	    			
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПравилоФормированияПредставления() Экспорт
	Возврат ПараметрыСеанса.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники;
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеСвязанныеСФизлицом() Экспорт

	СотрудникиФормы.ПрочитатьДанныеСвязанныеССотрудником(ЭтотОбъект);
	
	ОбновитьВидимостьПричиныУвольнения();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьПредставлениеПриИзменении(Элемент)

	СотрудникиКлиент.ДополнитьПредставлениеСотрудникаПриИзменении(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработкаИзмененияДанныхОРабочемМестеНаСервере(ПараметрСотрудник) Экспорт

	СотрудникиФормы.ОбработкаИзмененияДанныхОРабочемМесте(ЭтотОбъект, ПараметрСотрудник, "ДругиеРабочиеМеста");

КонецПроцедуры

&НаСервере
Процедура ТекущаяОрганизацияПриИзмененииНаСервере() Экспорт

	СотрудникиФормы.ПриИзмененииОрганизации(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФизическогоЛицаНаСервере() Экспорт

	СотрудникиФормы.ОбновитьДанныеФизическогоЛица(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтотОбъект, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияФормы()
	
	СотрудникиКлиент.СотрудникиПриОткрытии(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПодработкиНажатие(Элемент, СтандартнаяОбработка)
	ПоказатьЗначение(, НазначениеПодработки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// При изменении данных физлица / сотрудника.

&НаКлиенте
Процедура ТекущаяОрганизацияПриИзменении(Элемент)

	ТекущаяОрганизацияПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ФизлицоИННПриИзменении(Элемент)

	СотрудникиКлиент.СотрудникиИННПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ФизлицоСтраховойНомерПФРПриИзменении(Элемент)

	СотрудникиКлиент.СотрудникиСтраховойНомерПФРПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ВАрхивеПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтотОбъект, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриемаПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтотОбъект, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ДатаУвольненияПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтотОбъект, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура ТекущаяТарифнаяСтавкаПриИзменении(Элемент)

	СотрудникиКлиентСервер.УстановитьИнфоНадпись(ЭтотОбъект, ОбщегоНазначенияКлиент.ДатаСеанса());

КонецПроцедуры

&НаКлиенте
Процедура УточнениеНаименованияПриИзменении(Элемент)

	СотрудникиКлиент.СформироватьНаименованиеСотрудника(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ВидЗанятостиПриИзменении(Элемент)

	СотрудникиКлиент.ПроверитьКонфликтыВидаЗанятостиССуществующимиСотрудниками(Сотрудник.Ссылка, Сотрудник.ФизическоеЛицо, ТекущаяОрганизация, Сотрудник.ВидЗанятости, ДатаПриема);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Редактирование ФИО

&НаКлиенте
Процедура ИзменитьФИО(Команда)

	СотрудникиКлиент.СотрудникИзменилФИОНажатие(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ФИОФизическихЛицИстория(Команда)

	СотрудникиКлиент.СотрудникиОткрытьФормуРедактированияИстории("ФИОФизическихЛиц", ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)

	СотрудникиКлиент.ПриИзмененииФИОСотрудника(ЭтотОбъект);
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ФизлицоПолПриИзменении(Элемент)

	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ЭтотОбъект);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Редактирование места рождения.

&НаКлиенте
Процедура ФизлицоДатаРожденияПриИзменении(Элемент)

	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ЭтотОбъект);
	СотрудникиКлиентСервер.УстановитьПодсказкуКДатеРождения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаДоступаПриИзменении(Элемент)

	СотрудникиКлиент.ЗаблокироватьФизическоеЛицоПриРедактировании(ЭтотОбъект);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Расширенные подсистемы

// Места работы

&НаКлиенте
Процедура ИсторияИзмененийМестаРаботы(Команда)

	ПараметрыОткрытия = Новый Структура("СсылкаНаСотрудника", СотрудникСсылка);
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаИсторииИзмененияМестаРаботы", ПараметрыОткрытия, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ЛичныеДанные(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.ЛичныеДанные"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплаты(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьЭлемент", Истина);
	
	Если СозданиеНового И Не ЗначениеЗаполнено(Сотрудник.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
				|Переход к сведениям о выплате зарплаты и учете затрат возможен только после записи данных.
				|Данные будут записаны.'");
				
		Оповещение = Новый ОписаниеОповещения("ВыплатаЗарплатыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
	Иначе
		
		ДополнительныеПараметры.ЗаписатьЭлемент = Ложь;
		ВыплатаЗарплатыЗавершение(Неопределено, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыплатаЗарплатыЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьЭлемент И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.ВыплатаЗарплаты"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогНаДоходы(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.НалогНаДоходы"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Страхование(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Страхование"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыГПХ(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.ДоговорыГПХ"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияИУдержания(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.НачисленияИУдержания"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отсутствия(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.Отсутствия"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КадровыеДокументы(Команда)
	
	СтандартнаяОбработка = Истина;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.ОткрытьФормуКадровыхПриказовВоеннослужащих(ЭтотОбъект, СтандартнаяОбработка);
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		
		СотрудникиКлиент.ОткрытьДополнительнуюФорму(
			СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("ЖурналДокументов.КадровыеДокументы.ФормаСписка"), ЭтотОбъект, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами.

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы) Экспорт
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтотОбъект);
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеИзХранилищаВФормуНаСервере(Параметр) Экспорт
	
	СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
		ЭтотОбъект,
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(Параметр.ИмяФормы),
		Параметр.АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеДополнительнойФормы(ИмяФормы, Отказ) Экспорт
	
	СотрудникиФормы.СохранитьДанныеДополнительнойФормы(ЭтотОбъект, ИмяФормы, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ВоинскийУчет(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.ВоинскийУчет"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбразованиеКвалификация(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьЭлемент", Истина);
	
	Если СозданиеНового И НЕ ЗначениеЗаполнено(Сотрудник.ФизическоеЛицо) Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
				|Переход к сведениям об образовании, квалификации возможен только после записи данных.
				|Данные будут записаны.'");
				
		Оповещение = Новый ОписаниеОповещения("ОбразованиеКвалификацияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);	
		
	Иначе 
		
		ДополнительныеПараметры.ЗаписатьЭлемент = Ложь;
		ОбразованиеКвалификацияЗавершение(Неопределено, ДополнительныеПараметры);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбразованиеКвалификацияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьЭлемент И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.ОбразованиеКвалификация"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Справки(Команда)
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Справки"), ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Семья(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Семья"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КадровыйРезерв(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда
		МодульКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("КадровыйРезервКлиент");
		МодульКлиент.ОткрытьФормуКадровыйРезерв(ЭтотОбъект, ФизическоеЛицоСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьКандидатаСотрудника(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодборПерсонала") Тогда
		МодульКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодборПерсоналаКлиент");
		МодульКлиент.ОткрытьФормуКандидатаИзФормыСотрудника(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОхранаТруда(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		МодульКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОхранаТрудаФормыКлиент");
		МодульКлиент.ОткрытьФормуПоОхранеТруда(ЭтотОбъект, СотрудникСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИндивидуальныеЛьготы(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ЛьготыСотрудниковКлиент");
		Модуль.ОткрытьФормуИндивидуальныйПакетЛьгот(ЭтотОбъект, ФизическоеЛицоСсылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельность(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.ТрудоваяДеятельность"), ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппыСотрудников()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("ВыбранныеГруппы", СписокГруппСотрудников.ВыгрузитьЗначения());
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("СписокГруппСотрудниковОбработкаВыбораЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ГруппыСотрудников.ФормаВыбора", ПараметрыОткрытия, Элементы.СписокГруппСотрудников, , , , ОповещениеЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокГруппСотрудниковОбработкаВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		СписокГруппСотрудников.ЗагрузитьЗначения(Результат);
		Модифицированность = Истина;
		
		УстановитьОтображениеГруппВСотрудников();
		
	КонецЕсли; 
	
КонецПроцедуры

#Область НапоминанияСотрудника

&НаКлиенте
Процедура ОткрытьФормуНапоминаниеОДнеРождения()

	Если Не ЗначениеЗаполнено(ФизическоеЛицо.ДатаРождения) Тогда
	    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Перед тем, как установить напоминание о дне рождения сотрудника, заполните, пожалуйста, дату рождения.'"),,
			"ФизическоеЛицо.ДатаРождения");
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьЭлемент", Истина);
	
	Если СозданиеНового И НЕ ЗначениеЗаполнено(Сотрудник.ФизическоеЛицо) Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
				|Установка напоминания о дне рождения возможна только после записи данных.
				|Данные будут записаны.'");
				
		Оповещение = Новый ОписаниеОповещения("ОткрытьФормуНапоминаниеОДнеРожденияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);	
		
	Иначе 
		
		ДополнительныеПараметры.ЗаписатьЭлемент = Ложь;
		ОткрытьФормуНапоминаниеОДнеРожденияЗавершение(Неопределено, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНапоминаниеОДнеРожденияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 

	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьЭлемент И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура("СписокПредметов", АдресСпискаСотрудниковНаСервере(Сотрудник.Ссылка, УникальныйИдентификатор));
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("УстановитьВидимостьДекорацийНапоминанияОДнеРождения", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.НапоминаниеОДнеРождения", ПараметрыОткрытияФормы, ЭтаФорма, УникальныйИдентификатор,,,ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДекорацийНапоминанияОДнеРождения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	УстановитьВидимостьДекорацийНапоминанияОДнеРожденияНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДекорацийНапоминанияОДнеРожденияНаСервере()
	СотрудникиФормыРасширенный.УстановитьВидимостьДекорацийНапоминанияОДнеРождения(ЭтаФорма);
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресСпискаСотрудниковНаСервере(СотрудникСсылка, ИдентификаторФормы)
	Возврат ПоместитьВоВременноеХранилище(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СотрудникСсылка), ИдентификаторФормы);
КонецФункции

#КонецОбласти

&НаСервере
Процедура УстановитьОтображениеГруппВСотрудников()
	
	ПоказыватьГруппыСотрудников = СписокГруппСотрудников.Количество() > 0;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокГруппСотрудников",
		"Видимость",
		ПоказыватьГруппыСотрудников);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокГруппСотрудниковДекорация",
		"Видимость",
		Не ПоказыватьГруппыСотрудников);
	
КонецПроцедуры

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте 
Процедура Подключаемый_ПросклонятьПредставлениеПоВсемПадежам() 
	
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставлениеПоВсемПадежам(ЭтотОбъект, ФизическоеЛицо.ФИО, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "АНАЛИЗ ТЕКУЧЕСТИ ПЕРСОНАЛА"

&НаКлиенте
Процедура ПричинаУвольненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АнализТекучестиПерсонала") И НЕ Сотрудник.Ссылка.Пустая() Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("АнализТекучестиПерсоналаКлиент");
		Модуль.ОткрытьФормуВводаПричинУвольнения(ЭтаФорма, Сотрудник.Ссылка);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьПричинуУвольнения()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АнализТекучестиПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АнализТекучестиПерсонала");
		Модуль.ОбновитьПричинуУвольнения(ЭтаФорма, Сотрудник.Ссылка);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьПричиныУвольнения()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АнализТекучестиПерсонала") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АнализТекучестиПерсонала");
		Модуль.ОбновитьВидимостьПричиныУвольнения(ЭтаФорма, Сотрудник.Ссылка);
		Модуль.ОбновитьПричинуУвольнения(ЭтаФорма, Сотрудник.Ссылка);
	Иначе
		Элементы.ПричинаУвольнения.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры


#Область ЗаписьЭлемента                                                                                 

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено, Отказ = Ложь) Экспорт 
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЗаписьЭлементаСправочникаСотрудники");

	СотрудникиКлиент.СохранитьДанныеФорм(ЭтотОбъект, Отказ, ЗакрытьПослеЗаписи);
	Если НЕ ПроверяютсяОднофамильцы Тогда
		ПараметрыЗаписи = Новый Структура;
		СотрудникиКлиент.СотрудникиПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьРежимТолькоПросмотраЛичныхДанных() Экспорт
	
	СотрудникиКлиентСервер.УстановитьРежимТолькоПросмотраЛичныхДанныхВФормеСотрудника(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

