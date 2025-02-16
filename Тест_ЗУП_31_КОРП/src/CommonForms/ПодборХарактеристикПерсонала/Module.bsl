
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьНастройкиФормы();
	УстановитьДоступностьЭлементовФильтрации(ЭтаФорма);
	
	ИспользоватьФильтры = Ложь;
	
	УстановитьПараметрыСпискаХарактеристик();
	УстановитьПараметрыСпискаЗначенийХарактеристик();
			
	УстановитьУсловноеОформлениеДляХарактеристик();	
	
	УстановитьПризнакиОтображенияРеквизитовФормы();
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	СохранитьНастройкиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьПодбор(Команда)
	
	МассивСтрок = Новый Массив;
	Для каждого ТекущаяСтрока Из ПодобранныеХарактеристики Цикл
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Характеристика", ТекущаяСтрока.Характеристика);
		СтрокиЗначений = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрокаЗначений Из СтрокиЗначений Цикл
			СтруктураСтроки = Новый Структура(
				"Характеристика, 
				|Значение,
				|Вес,
				|ТребуетсяПроверка,
				|ТребуетсяОбучение,
				|ВесЗначения");
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, ТекущаяСтрока);
			СтруктураСтроки.Вставить("Значение", ТекущаяСтрокаЗначений.Значение);
			СтруктураСтроки.Вставить("ВесЗначения", ТекущаяСтрокаЗначений.ВесЗначения);
			МассивСтрок.Добавить(СтруктураСтроки);
		КонецЦикла;
	КонецЦикла;
		 
	Закрыть(МассивСтрок);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимФильтрацииПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФильтрации(ЭтаФорма);
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьХарактеристику(Команда)
	
	ВыделенныеСтроки = Элементы.СписокХарактеристик.ВыделенныеСтроки;
	МассивХарактеристик = Новый Массив;
	Для Каждого ТекущаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.СписокХарактеристик.ДанныеСтроки(ТекущаяСтрока);
		МассивХарактеристик.Добавить(ТекущиеДанные.Характеристика);
	КонецЦикла;
	Для Каждого ТекущаяХарактеристика Из МассивХарактеристик Цикл
		ДобавитьХарактеристику(ТекущаяХарактеристика);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеХарактеристики(Команда)
	
	ПараметрДействиеСотрудника = Неопределено;
	ПараметрКомпетенцияПерсонала = Неопределено;
	ПараметрГруппаХарактеристикПерсонала = Неопределено;
	
	Если РежимФильтрации = 0
		И Элементы.ДействияСотрудников.ТекущиеДанные <> Неопределено Тогда
		ПараметрДействиеСотрудника = Элементы.ДействияСотрудников.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 1
		И Элементы.КомпетенцииПерсонала.ТекущиеДанные <> Неопределено Тогда
		ПараметрКомпетенцияПерсонала = Элементы.КомпетенцииПерсонала.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 2
		И Элементы.ГруппыХарактеристик.ТекущиеДанные <> Неопределено Тогда
		ПараметрГруппаХарактеристикПерсонала = Элементы.ГруппыХарактеристик.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	МассивХарактеристик = ВсеХарактеристики(ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала);
	Для Каждого ВыбраннаяХарактеристика Из МассивХарактеристик Цикл
		ПоместитьХарактеристикуВТаблицуВыбранныхЗначений(ВыбраннаяХарактеристика, ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗначение(Команда)
	
	ВыделенныеСтроки = Элементы.ЗначенияХарактеристик.ВыделенныеСтроки;
	МассивСтрок = Новый Массив;
	Для Каждого ТекущаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.ЗначенияХарактеристик.ДанныеСтроки(ТекущаяСтрока);
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Характеристика", ТекущиеДанные.Характеристика);
		СтруктураСтроки.Вставить("Значение", ТекущиеДанные.Значение);
		МассивСтрок.Добавить(СтруктураСтроки);
	КонецЦикла;
	Для Каждого ТекущаяСтрока Из МассивСтрок Цикл
		ДобавитьЗначениеХарактеристики(ТекущаяСтрока.Характеристика, ТекущаяСтрока.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеЗначения(Команда)
	
	ТекущиеДанные = Элементы.СписокХарактеристик.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДобавитьХарактеристику(ТекущиеДанные.Характеристика);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппыХарактеристикПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ФильтрыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпетенцииПерсоналаПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ФильтрыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияСотрудниковПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ФильтрыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ФильтрыПриАктивизацииСтрокиОбработчикОжидания()
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокХарактеристикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыделенныеСтроки = Элементы.СписокХарактеристик.ВыделенныеСтроки;
	МассивХарактеристик = Новый Массив;
	Для Каждого ТекущаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.СписокХарактеристик.ДанныеСтроки(ТекущаяСтрока);
		МассивХарактеристик.Добавить(ТекущиеДанные.Характеристика);
	КонецЦикла;
	Для Каждого ТекущаяХарактеристика Из МассивХарактеристик Цикл
		ДобавитьХарактеристику(ТекущаяХарактеристика);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияХарактеристикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыделенныеСтроки = Элементы.ЗначенияХарактеристик.ВыделенныеСтроки;
	МассивСтрок = Новый Массив;
	Для Каждого ТекущаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.ЗначенияХарактеристик.ДанныеСтроки(ТекущаяСтрока);
		СтруктураСтроки = Новый Структура;
		СтруктураСтроки.Вставить("Характеристика", ТекущиеДанные.Характеристика);
		СтруктураСтроки.Вставить("Значение", ТекущиеДанные.Значение);
		МассивСтрок.Добавить(СтруктураСтроки);
	КонецЦикла;
	Для Каждого ТекущаяСтрока Из МассивСтрок Цикл
		ДобавитьЗначениеХарактеристики(ТекущаяСтрока.Характеристика, ТекущаяСтрока.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокХарактеристикПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("УстановитьОтборЗначенийХарактеристикОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеХарактеристикиПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеХарактеристикиЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ПодобранныеХарактеристики.ТекущиеДанные;
	Если (ТекущиеДанные = Неопределено Или Не ЗначениеЗаполнено(ТекущиеДанные.Характеристика)) Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗначений = Новый Массив;
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	СтрокиЗначений = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
	Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
		СтруктураЗначения = Новый Структура;
		СтруктураЗначения.Вставить("Значение", ТекущаяСтрока.Значение);
		СтруктураЗначения.Вставить("ВесЗначения", ТекущаяСтрока.ВесЗначения);
		МассивЗначений.Добавить(СтруктураЗначения);
	КонецЦикла;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	Оповещение = Новый ОписаниеОповещения("ПодобранныеХарактеристикиЗначениеОкончаниеВыбора", ЭтаФорма, СтруктураПараметров);
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Характеристика", ТекущиеДанные.Характеристика);
	ПараметрыОткрытия.Вставить("МассивЗначений", МассивЗначений);
	ОткрытьФорму("ОбщаяФорма.НастройкаЗначенийХарактеристик", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеХарактеристикиПередУдалением(Элемент, Отказ)
	
	ВыделенныеСтроки = Элементы.ПодобранныеХарактеристики.ВыделенныеСтроки;
	МассивХарактеристик = Новый Массив;
	Для Каждого ТекущаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = Элементы.ПодобранныеХарактеристики.ДанныеСтроки(ТекущаяСтрока);
		МассивХарактеристик.Добавить(ТекущиеДанные.Характеристика);
	КонецЦикла;
	
	Для Каждого ТекущаяХарактеристика Из МассивХарактеристик Цикл
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Характеристика", ТекущаяХарактеристика);
		СтрокиЗначений = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
		Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
			ПодобранныеЗначения.Удалить(ТекущаяСтрока);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФильтрации(Форма)
	
	Если Форма.РежимФильтрации = 0 Тогда
		Форма.Элементы.СтраницыНавигация.ТекущаяСтраница = Форма.Элементы.СтраницаДействияСотрудников;
	ИначеЕсли Форма.РежимФильтрации = 1 Тогда
		Форма.Элементы.СтраницыНавигация.ТекущаяСтраница = Форма.Элементы.СтраницаКомпетенцииПерсонала;
	Иначе
		Форма.Элементы.СтраницыНавигация.ТекущаяСтраница = Форма.Элементы.СтраницаГруппыХарактеристик;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыДинамическихСписков()
	
	ПараметрДействиеСотрудника = Неопределено;
	ПараметрКомпетенцияПерсонала = Неопределено;
	ПараметрГруппаХарактеристикПерсонала =Неопределено;
	
	Если РежимФильтрации = 0
			И Элементы.ДействияСотрудников.ТекущиеДанные <> Неопределено Тогда
		ПараметрДействиеСотрудника = Элементы.ДействияСотрудников.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 1
			И Элементы.КомпетенцииПерсонала.ТекущиеДанные <> Неопределено Тогда
		ПараметрКомпетенцияПерсонала = Элементы.КомпетенцииПерсонала.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 2
			И Элементы.ГруппыХарактеристик.ТекущиеДанные <> Неопределено Тогда
		ПараметрГруппаХарактеристикПерсонала = Элементы.ГруппыХарактеристик.ТекущиеДанные.Ссылка;
	КонецЕсли;		
		
	СписокХарактеристик.Параметры.УстановитьЗначениеПараметра("ДействиеСотрудника",           ПараметрДействиеСотрудника);
	СписокХарактеристик.Параметры.УстановитьЗначениеПараметра("КомпетенцияПерсонала",         ПараметрКомпетенцияПерсонала);
	СписокХарактеристик.Параметры.УстановитьЗначениеПараметра("ГруппаХарактеристикПерсонала", ПараметрГруппаХарактеристикПерсонала);
	
	ЗначенияХарактеристик.Параметры.УстановитьЗначениеПараметра("ДействиеСотрудника",           ПараметрДействиеСотрудника);
	ЗначенияХарактеристик.Параметры.УстановитьЗначениеПараметра("КомпетенцияПерсонала",         ПараметрКомпетенцияПерсонала);
	ЗначенияХарактеристик.Параметры.УстановитьЗначениеПараметра("ГруппаХарактеристикПерсонала", ПараметрГруппаХарактеристикПерсонала);
	
	ТекущиеДанные = Элементы.СписокХарактеристик.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияХарактеристик,
				"Характеристика",
				Неопределено,
				ВидСравненияКомпоновкиДанных.Равно,
				"Характеристика",
				Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияХарактеристик,
				"Характеристика",
				ТекущиеДанные.Характеристика,
				ВидСравненияКомпоновкиДанных.Равно,
				"Характеристика",
				Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборЗначенийХарактеристикОбработчикОжидания()
	
	ТекущиеДанные = Элементы.СписокХарактеристик.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияХарактеристик,
			"Характеристика",
			ТекущиеДанные.Характеристика,
			ВидСравненияКомпоновкиДанных.Равно,
			"Характеристика",
			Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьХарактеристикуВТаблицуВыбранныхЗначений(Характеристика, ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала, Значение=Неопределено)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Характеристика", Характеристика);
	СтрокиХарактеристики = ПодобранныеХарактеристики.НайтиСтроки(СтруктураПоиска);
	Если СтрокиХарактеристики.Количество() = 0 Тогда
		ТекущаяСтрока = ПодобранныеХарактеристики.Добавить();
		ТекущаяСтрока.Характеристика = Характеристика;
		ТекущаяСтрока.КартинкаВида = ВидХарактеристики(Характеристика);
	Иначе
		ТекущаяСтрока = СтрокиХарактеристики[0];
	КонецЕсли;
	
	РезультатыЗапроса = ДобавляемыеЗначения(Характеристика, ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала, Значение);
	
	ТекущаяСтрока.Вес = ТекущаяСтрока.Вес + РезультатыЗапроса.Вес;
	Если ТекущаяСтрока.Вес = 0 Тогда
		ТекущаяСтрока.Вес = 1;
	КонецЕсли;
	ТекущаяСтрока.ТребуетсяПроверка = ТекущаяСтрока.ТребуетсяПроверка Или РезультатыЗапроса.ТребуетсяПроверка;
	ТекущаяСтрока.ТребуетсяОбучение = ТекущаяСтрока.ТребуетсяОбучение Или РезультатыЗапроса.ТребуетсяОбучение;
	
	Если РезультатыЗапроса.МассивЗначений.Количество() > 0 Тогда
		Для Каждого НовоеЗначение Из РезультатыЗапроса.МассивЗначений Цикл
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Характеристика", НовоеЗначение.Характеристика);
			СтруктураПоиска.Вставить("Значение", НовоеЗначение.Значение);
			НайденныеСтроки = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				НайденныеСтроки[0].ВесЗначения = НайденныеСтроки[0].ВесЗначения + НовоеЗначение.ВесЗначения;
			Иначе
				НоваяСтрока = ПодобранныеЗначения.Добавить();
				НоваяСтрока.Характеристика = Характеристика;
				НоваяСтрока.Значение = НовоеЗначение.Значение;
				НоваяСтрока.ВесЗначения = НовоеЗначение.ВесЗначения;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если Значение = Неопределено Тогда
			СтруктураПоиска = Новый Структура(
				"Характеристика,
				|Значение");
			СтруктураПоиска.Характеристика = Характеристика;
			НайденныеСтроки = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				НайденныеСтроки[0].ВесЗначения = НайденныеСтроки[0].ВесЗначения + 1;
			Иначе
				НоваяСтрока = ПодобранныеЗначения.Добавить();
				НоваяСтрока.Характеристика = Характеристика;
				НоваяСтрока.ВесЗначения = 1;
			КонецЕсли;
		Иначе
			НоваяСтрока = ПодобранныеЗначения.Добавить();
			НоваяСтрока.Характеристика = Характеристика;
			НоваяСтрока.Значение = Значение;
			НоваяСтрока.ВесЗначения = 1;
		КонецЕсли;
	КонецЕсли;
	
	ЗначенияСтрокой = "";
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Характеристика", Характеристика);
	СтрокиХарактеристики = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаЗначения Из СтрокиХарактеристики Цикл
		Если ЗначениеЗаполнено(СтрокаЗначения.Значение) Тогда
			ЗначенияСтрокой = СокрЛП(ЗначенияСтрокой) + ?(ЗначенияСтрокой = "", "", ", ") + СокрЛП(Строка(СтрокаЗначения.Значение));
		КонецЕсли;
	КонецЦикла;
	ТекущаяСтрока.ЗначенияСтрокой = ЗначенияСтрокой;
	
	УстановитьПараметрыВыбораСписков();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавляемыеЗначения(Характеристика, ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала, Значение)
	
	РезультатЗапроса = Новый Структура;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДействиеСотрудника", ПараметрДействиеСотрудника);
	Запрос.УстановитьПараметр("КомпетенцияПерсонала", ПараметрКомпетенцияПерсонала);
	Запрос.УстановитьПараметр("ГруппаХарактеристикПерсонала", ПараметрГруппаХарактеристикПерсонала);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Значение", Значение);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДействияСотрудников.Характеристика КАК Характеристика,
		|	ДействияСотрудников.Значение КАК Значение,
		|	МАКСИМУМ(ДействияСотрудников.Вес) КАК Вес,
		|	МАКСИМУМ(ДействияСотрудников.ТребуетсяПроверка) КАК ТребуетсяПроверка,
		|	МАКСИМУМ(ДействияСотрудников.ТребуетсяОбучение) КАК ТребуетсяОбучение,
		|	МАКСИМУМ(ДействияСотрудников.ВесЗначения) КАК ВесЗначения
		|ПОМЕСТИТЬ ВТХарактеристики
		|ИЗ
		|	Справочник.ДействияСотрудников.ХарактеристикиПерсонала КАК ДействияСотрудников
		|ГДЕ
		|	&ДействиеСотрудника <> НЕОПРЕДЕЛЕНО
		|	И ДействияСотрудников.Ссылка В ИЕРАРХИИ(&ДействиеСотрудника)
		|	И ДействияСотрудников.Характеристика = &Характеристика
		|	И (ДействияСотрудников.Значение = &Значение
		|			ИЛИ &Значение = НЕОПРЕДЕЛЕНО)
		|
		|СГРУППИРОВАТЬ ПО
		|	ДействияСотрудников.Характеристика,
		|	ДействияСотрудников.Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КомпетенцииПерсонала.Характеристика,
		|	КомпетенцииПерсонала.Значение,
		|	МАКСИМУМ(КомпетенцииПерсонала.Вес),
		|	МАКСИМУМ(КомпетенцииПерсонала.ТребуетсяПроверка),
		|	МАКСИМУМ(КомпетенцииПерсонала.ТребуетсяОбучение),
		|	МАКСИМУМ(КомпетенцииПерсонала.ВесЗначения)
		|ИЗ
		|	Справочник.КомпетенцииПерсонала.ХарактеристикиПерсонала КАК КомпетенцииПерсонала
		|ГДЕ
		|	&КомпетенцияПерсонала <> НЕОПРЕДЕЛЕНО
		|	И КомпетенцииПерсонала.Ссылка В ИЕРАРХИИ(&КомпетенцияПерсонала)
		|	И КомпетенцииПерсонала.Характеристика = &Характеристика
		|	И (КомпетенцииПерсонала.Значение = &Значение
		|			ИЛИ &Значение = НЕОПРЕДЕЛЕНО)
		|
		|СГРУППИРОВАТЬ ПО
		|	КомпетенцииПерсонала.Характеристика,
		|	КомпетенцииПерсонала.Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ГруппыХарактеристикПерсонала.Характеристика,
		|	ГруппыХарактеристикПерсонала.Значение,
		|	МАКСИМУМ(ГруппыХарактеристикПерсонала.Вес),
		|	МАКСИМУМ(ГруппыХарактеристикПерсонала.ТребуетсяПроверка),
		|	МАКСИМУМ(ГруппыХарактеристикПерсонала.ТребуетсяОбучение),
		|	МАКСИМУМ(ГруппыХарактеристикПерсонала.ВесЗначения)
		|ИЗ
		|	Справочник.ГруппыХарактеристикПерсонала.ХарактеристикиПерсонала КАК ГруппыХарактеристикПерсонала
		|ГДЕ
		|	&ГруппаХарактеристикПерсонала <> НЕОПРЕДЕЛЕНО
		|	И ГруппыХарактеристикПерсонала.Ссылка В ИЕРАРХИИ(&ГруппаХарактеристикПерсонала)
		|	И ГруппыХарактеристикПерсонала.Характеристика = &Характеристика
		|	И (ГруппыХарактеристикПерсонала.Значение = &Значение
		|			ИЛИ &Значение = НЕОПРЕДЕЛЕНО)
		|
		|СГРУППИРОВАТЬ ПО
		|	ГруппыХарактеристикПерсонала.Характеристика,
		|	ГруппыХарактеристикПерсонала.Значение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ХарактеристикиПерсонала.Ссылка,
		|	ЗначенияХарактеристикПерсонала.Ссылка,
		|	1,
		|	ЛОЖЬ,
		|	ЛОЖЬ,
		|	1
		|ИЗ
		|	ПланВидовХарактеристик.ХарактеристикиПерсонала КАК ХарактеристикиПерсонала
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗначенияХарактеристикПерсонала КАК ЗначенияХарактеристикПерсонала
		|		ПО ХарактеристикиПерсонала.Ссылка = ЗначенияХарактеристикПерсонала.Владелец
		|			И (НЕ ЗначенияХарактеристикПерсонала.ПометкаУдаления)
		|ГДЕ
		|	&ДействиеСотрудника = НЕОПРЕДЕЛЕНО
		|	И &КомпетенцияПерсонала = НЕОПРЕДЕЛЕНО
		|	И &ГруппаХарактеристикПерсонала = НЕОПРЕДЕЛЕНО
		|	И ХарактеристикиПерсонала.Ссылка = &Характеристика
		|	И (ЗначенияХарактеристикПерсонала.Ссылка = &Значение
		|			ИЛИ &Значение = НЕОПРЕДЕЛЕНО)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Характеристики.Характеристика,
		|	Характеристики.Значение,
		|	СУММА(Характеристики.Вес) КАК Вес,
		|	МАКСИМУМ(Характеристики.ТребуетсяПроверка) КАК ТребуетсяПроверка,
		|	МАКСИМУМ(Характеристики.ТребуетсяОбучение) КАК ТребуетсяОбучение,
		|	СУММА(Характеристики.ВесЗначения) КАК ВесЗначения
		|ИЗ
		|	ВТХарактеристики КАК Характеристики
		|
		|СГРУППИРОВАТЬ ПО
		|	Характеристики.Характеристика,
		|	Характеристики.Значение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Характеристики.Характеристика,
		|	МАКСИМУМ(Характеристики.Вес) КАК Вес,
		|	МАКСИМУМ(Характеристики.ТребуетсяПроверка) КАК ТребуетсяПроверка,
		|	МАКСИМУМ(Характеристики.ТребуетсяОбучение) КАК ТребуетсяОбучение
		|ИЗ
		|	ВТХарактеристики КАК Характеристики
		|
		|СГРУППИРОВАТЬ ПО
		|	Характеристики.Характеристика";
		
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[2].Выбрать();
	Если Выборка.Следующий() Тогда
		РезультатЗапроса.Вставить("Вес", Выборка.Вес);
		РезультатЗапроса.Вставить("ТребуетсяПроверка", Выборка.ТребуетсяПроверка);
		РезультатЗапроса.Вставить("ТребуетсяОбучение", Выборка.ТребуетсяОбучение);
	Иначе
		РезультатЗапроса.Вставить("Вес", 0);
		РезультатЗапроса.Вставить("ТребуетсяПроверка", Ложь);
		РезультатЗапроса.Вставить("ТребуетсяОбучение", Ложь);
	КонецЕсли;
	
	МассивЗначений = Новый Массив;
	Если НЕ Результат[1].Пустой() Тогда
		Выборка = Результат[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураЗначения = Новый Структура;
			СтруктураЗначения.Вставить("Характеристика", Выборка.Характеристика);
			СтруктураЗначения.Вставить("Значение", Выборка.Значение);
			СтруктураЗначения.Вставить("ВесЗначения", Выборка.ВесЗначения);
			МассивЗначений.Добавить(СтруктураЗначения);
		КонецЦикла;
	КонецЕсли;
	РезультатЗапроса.Вставить("МассивЗначений", МассивЗначений);
	
	Возврат РезультатЗапроса;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	ДанныеНастройки = ХранилищеОбщихНастроек.Загрузить("ПодборХарактеристикПерсонала", "НастройкиФормы",, ИмяПользователя());
	Если ТипЗнч(ДанныеНастройки) = Тип("Структура") Тогда
		ДанныеНастройки.Свойство("РежимФильтрации", РежимФильтрации);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	ДанныеНастройки = Новый Структура;
	ДанныеНастройки.Вставить("РежимФильтрации", РежимФильтрации);
	ХранилищеОбщихНастроек.Сохранить("ПодборХарактеристикПерсонала", "НастройкиФормы", ДанныеНастройки,, ИмяПользователя());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВсеХарактеристики(ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДействиеСотрудника", ПараметрДействиеСотрудника);
	Запрос.УстановитьПараметр("КомпетенцияПерсонала", ПараметрКомпетенцияПерсонала);
	Запрос.УстановитьПараметр("ГруппаХарактеристикПерсонала", ПараметрГруппаХарактеристикПерсонала);
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВложенныйЗапрос.Характеристика
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДействияСотрудников.Характеристика КАК Характеристика,
		|		ДействияСотрудников.Значение КАК Значение
		|	ИЗ
		|		Справочник.ДействияСотрудников.ХарактеристикиПерсонала КАК ДействияСотрудников
		|	ГДЕ
		|		&ДействиеСотрудника <> НЕОПРЕДЕЛЕНО
		|		И ДействияСотрудников.Ссылка В ИЕРАРХИИ(&ДействиеСотрудника)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		КомпетенцииПерсонала.Характеристика,
		|		КомпетенцииПерсонала.Значение
		|	ИЗ
		|		Справочник.КомпетенцииПерсонала.ХарактеристикиПерсонала КАК КомпетенцииПерсонала
		|	ГДЕ
		|		&КомпетенцияПерсонала <> НЕОПРЕДЕЛЕНО
		|		И КомпетенцииПерсонала.Ссылка В ИЕРАРХИИ(&КомпетенцияПерсонала)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ГруппыХарактеристикПерсонала.Характеристика,
		|		ГруппыХарактеристикПерсонала.Значение
		|	ИЗ
		|		Справочник.ГруппыХарактеристикПерсонала.ХарактеристикиПерсонала КАК ГруппыХарактеристикПерсонала
		|	ГДЕ
		|		&ГруппаХарактеристикПерсонала <> НЕОПРЕДЕЛЕНО
		|		И ГруппыХарактеристикПерсонала.Ссылка В ИЕРАРХИИ(&ГруппаХарактеристикПерсонала)
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ХарактеристикиПерсонала.Ссылка,
		|		ЗначенияХарактеристикПерсонала.Ссылка
		|	ИЗ
		|		ПланВидовХарактеристик.ХарактеристикиПерсонала КАК ХарактеристикиПерсонала
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЗначенияХарактеристикПерсонала КАК ЗначенияХарактеристикПерсонала
		|			ПО ХарактеристикиПерсонала.Ссылка = ЗначенияХарактеристикПерсонала.Владелец
		|				И (НЕ ЗначенияХарактеристикПерсонала.ПометкаУдаления)
		|	ГДЕ
		|		&ДействиеСотрудника = НЕОПРЕДЕЛЕНО
		|		И &КомпетенцияПерсонала = НЕОПРЕДЕЛЕНО
		|		И &ГруппаХарактеристикПерсонала = НЕОПРЕДЕЛЕНО) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Характеристика";
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивХарактеристик = Новый Массив;
	Пока Выборка.Следующий() Цикл
		МассивХарактеристик.Добавить(Выборка.Характеристика);
	КонецЦикла;
	
	Возврат МассивХарактеристик;

КонецФункции

&НаКлиенте
Процедура ДобавитьХарактеристику(Характеристика)
	
	ПараметрДействиеСотрудника = Неопределено;
	ПараметрКомпетенцияПерсонала = Неопределено;
	ПараметрГруппаХарактеристикПерсонала = Неопределено;
	
	Если РежимФильтрации = 0
		И Элементы.ДействияСотрудников.ТекущиеДанные <> Неопределено Тогда
		ПараметрДействиеСотрудника = Элементы.ДействияСотрудников.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 1
		И Элементы.КомпетенцииПерсонала.ТекущиеДанные <> Неопределено Тогда
		ПараметрКомпетенцияПерсонала = Элементы.КомпетенцииПерсонала.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 2
		И Элементы.ГруппыХарактеристик.ТекущиеДанные <> Неопределено Тогда
		ПараметрГруппаХарактеристикПерсонала = Элементы.ГруппыХарактеристик.ТекущиеДанные.Ссылка;
	КонецЕсли;		
	
	ПоместитьХарактеристикуВТаблицуВыбранныхЗначений(Характеристика, ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЗначениеХарактеристики(Характеристика, ЗначениеХарактеристики)
	
	ПараметрДействиеСотрудника = Неопределено;
	ПараметрКомпетенцияПерсонала = Неопределено;
	ПараметрГруппаХарактеристикПерсонала = Неопределено;
	
	Если РежимФильтрации = 0
		И Элементы.ДействияСотрудников.ТекущиеДанные <> Неопределено Тогда
		ПараметрДействиеСотрудника = Элементы.ДействияСотрудников.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 1
		И Элементы.КомпетенцииПерсонала.ТекущиеДанные <> Неопределено Тогда
		ПараметрКомпетенцияПерсонала = Элементы.КомпетенцииПерсонала.ТекущиеДанные.Ссылка;
	ИначеЕсли РежимФильтрации = 2
		И Элементы.ГруппыХарактеристик.ТекущиеДанные <> Неопределено Тогда
		ПараметрГруппаХарактеристикПерсонала = Элементы.ГруппыХарактеристик.ТекущиеДанные.Ссылка;
	КонецЕсли;		
	
	ПоместитьХарактеристикуВТаблицуВыбранныхЗначений(Характеристика, ПараметрДействиеСотрудника, ПараметрКомпетенцияПерсонала, ПараметрГруппаХарактеристикПерсонала, ЗначениеХарактеристики);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыВыбораСписков()

	СписокВыбранныхХарактеристик = Новый СписокЗначений;
	СписокВыбранныхЗначений = Новый СписокЗначений;
	Для Каждого ВыбранноеЗначение Из ПодобранныеЗначения Цикл
		Если СписокВыбранныхХарактеристик.НайтиПоЗначению(ВыбранноеЗначение.Характеристика) = Неопределено Тогда
			СписокВыбранныхХарактеристик.Добавить(ВыбранноеЗначение.Характеристика);
		КонецЕсли;
		Если СписокВыбранныхЗначений.НайтиПоЗначению(ВыбранноеЗначение.Значение) = Неопределено Тогда
			СписокВыбранныхЗначений.Добавить(ВыбранноеЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
		
	СписокХарактеристик.УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = СписокВыбранныхХарактеристик;
	ЗначенияХарактеристик.УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = СписокВыбранныхЗначений;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобранныеХарактеристикиХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПодобранныеХарактеристики.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.КартинкаВида = ВидХарактеристики(ТекущиеДанные.Характеристика);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидХарактеристики(Характеристика)
	Возврат ХарактеристикиПерсонала.ВидИКартинкаХарактеристики(Характеристика).Картинка;
КонецФункции

// Обработчик оповещения о закрытии формы настройки весов характеристик.
// Добавляет подобранные значения характеристик персонала и их веса.
//
// Параметры 
//	Результат - Структура - структура, содержащая характеристику персонала и массив структур выбранных значений этой характеристики и их весов. 
//	ДополнительныеПараметры - Структура - структура дополнительных параметров.
//
&НаКлиенте
Процедура ПодобранныеХарактеристикиЗначениеОкончаниеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяХарактеристика = Результат.Характеристика;
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Характеристика", ТекущаяХарактеристика);
	СтрокиХарактеристики = ПодобранныеХарактеристики.НайтиСтроки(СтруктураПоиска);
	Если СтрокиХарактеристики.Количество() > 0 Тогда
		СтрокаХарактеристики = СтрокиХарактеристики[0];
	Иначе
		СтрокаХарактеристики = ПодобранныеХарактеристики.Добавить();
		СтрокаХарактеристики.Характеристика = ТекущаяХарактеристика;
		СтрокаХарактеристики.Вес = 1;
		СтрокаХарактеристики.КартинкаВида = ВидХарактеристики(ТекущаяХарактеристика);
	КонецЕсли;
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Характеристика", ТекущаяХарактеристика);
	СтрокиЗначений = ПодобранныеЗначения.НайтиСтроки(СтруктураПоиска);
	Для Каждого ТекущаяСтрока Из СтрокиЗначений Цикл
		ПодобранныеЗначения.Удалить(ТекущаяСтрока);
	КонецЦикла;
	ЗначенияСтрокой = "";
	Для Каждого ТекущаяСтрока Из Результат.МассивЗначений Цикл
		НоваяСтрока = ПодобранныеЗначения.Добавить();
		НоваяСтрока.Характеристика = ТекущаяХарактеристика;
		НоваяСтрока.Значение = ТекущаяСтрока.Значение;
		НоваяСтрока.ВесЗначения = ТекущаяСтрока.ВесЗначения;
		ЗначенияСтрокой = СокрЛП(ЗначенияСтрокой) + ?(ЗначенияСтрокой = "", "", ", ") + СокрЛП(Строка(ТекущаяСтрока.Значение));
	КонецЦикла;
	СтрокаХарактеристики.ЗначенияСтрокой = ЗначенияСтрокой;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСпискаХарактеристик()

	СписокХарактеристик.Параметры.УстановитьЗначениеПараметра("ДействиеСотрудника",           Неопределено);
	СписокХарактеристик.Параметры.УстановитьЗначениеПараметра("КомпетенцияПерсонала",         Неопределено);
	СписокХарактеристик.Параметры.УстановитьЗначениеПараметра("ГруппаХарактеристикПерсонала", Неопределено);

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСпискаЗначенийХарактеристик()

	ЗначенияХарактеристик.Параметры.УстановитьЗначениеПараметра("ДействиеСотрудника",           Неопределено);
	ЗначенияХарактеристик.Параметры.УстановитьЗначениеПараметра("КомпетенцияПерсонала",         Неопределено);
	ЗначенияХарактеристик.Параметры.УстановитьЗначениеПараметра("ГруппаХарактеристикПерсонала", Неопределено);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗначенияХарактеристик,
		"Характеристика",
		Неопределено,
		ВидСравненияКомпоновкиДанных.Равно,
		"Характеристика",
		Истина);

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеДляХарактеристик()
	
	ЭлементОформления = СписокХарактеристик.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстПодобранногоЗначенияЦвет);
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = Новый СписокЗначений;
	ЭлементОформления.Использование = Истина;
	
	ЭлементОформления = ЗначенияХарактеристик.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстПодобранногоЗначенияЦвет);
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Значение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = Новый СписокЗначений;
	ЭлементОформления.Использование = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПризнакиОтображенияРеквизитовФормы()

	Если Не Параметры.Свойство("СкрытьРеквизиты") Тогда
		Возврат;
	КонецЕсли;
	
	СписокСкрываемыхРеквизитов = Параметры.СкрытьРеквизиты;
	
	Если СписокСкрываемыхРеквизитов.Свойство("Значения") Тогда
		СкрытьЗначенияХарактеристик = Истина;
		СкрытьВесаЗначений = Истина;
		СкрытьТребуетсяОбучение = Истина;
		СкрытьТребуетсяПроверка = Истина;
		Возврат;
	КонецЕсли;
	
	Если СписокСкрываемыхРеквизитов.Свойство("Вес") Тогда
		СкрытьВесаЗначений = Истина;
	КонецЕсли;
	Если СписокСкрываемыхРеквизитов.Свойство("ТребуетсяОбучение") Тогда
		СкрытьТребуетсяОбучение = Истина;
	КонецЕсли;
	Если СписокСкрываемыхРеквизитов.Свойство("ТребуетсяПроверка") Тогда
		СкрытьТребуетсяПроверка = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСписокЗначенийХарактеристик",
		"Видимость",
		Не СкрытьЗначенияХарактеристик);

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПодобранныеХарактеристикиЗначение",
		"Видимость",
		Не СкрытьЗначенияХарактеристик);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПодобранныеХарактеристикиВес",
		"Видимость",
		Не СкрытьВесаЗначений);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПодобранныеХарактеристикиТребуетсяПроверка",
		"Видимость",
		Не СкрытьТребуетсяПроверка);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПодобранныеХарактеристикиТребуетсяОбучение",
		"Видимость",
		Не СкрытьТребуетсяОбучение);
		
КонецПроцедуры

#КонецОбласти
