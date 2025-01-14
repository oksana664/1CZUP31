
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Перем ПараметрыПослеЗаписи;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Отобразим элементы в зависимости от функциональной опции
	ИспользоватьЭлектронноеИнтервью = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронноеИнтервью");
	Элементы.ГруппаФункцииТребованияКХарактеристикам.Видимость = ИспользоватьЭлектронноеИнтервью;
	Если НЕ ИспользоватьЭлектронноеИнтервью Тогда
		Элементы.ГруппаДанныеДляПубликацииВакансии.Поведение = ПоведениеОбычнойГруппы.Обычное;
		Элементы.ГруппаДанныеДляПубликацииВакансии.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаДанныеДляПубликацииВакансии.ОтображатьЗаголовок = Ложь;
		Элементы.ЭтапыРаботыСКандидатамиПечатьАнкеты.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодборПерсоналаКлиентСервер.ЗаполнитьНаименованиеПрофиляДолжности(Объект);
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// По умолчанию считаем, что после записи форму нужно закрыть, 
	// в связи с тем, что нельзя обработать событие закрытия в веб-клиенте.
	ЗакрыватьПослеЗаписи = Истина;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "ГруппаКомандыФормы");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ЗаписатьСКлиента();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РеквизитыВДанные(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗакрыватьПослеЗаписи Тогда
		ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина);
	КонецЕсли;
	
	Если Не ЗакрыватьПослеЗаписи Тогда
		// Признак необходимости закрытия держим постоянно взведенным.
		ЗакрыватьПослеЗаписи = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнениеВыполнено = Ложь;
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	РеквизитыВДанные(ТекущийОбъект);
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	ХарактеристикиПерсоналаФормы.ОбработкаПроверкиЗаполненияТабличныхЧастейХарактеристик(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "СохранениеНастроекВопросовДляСобеседования" И Параметр = Объект.Ссылка Тогда
		ЗаполнитьОтображениеНастроекАнкет(); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ЗакрыватьПослеЗаписи = Истина;
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНеЗакрывать(Команда)
	
	ЗакрыватьПослеЗаписи = Ложь;
	Записать();
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОткрытьПодборХарактеристикПерсонала(Команда)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуПодбораХарактеристик(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПечатьАнкеты(Команда)
	
	ТекущиеДанные = Элементы.ЭтапыРаботыСКандидатами.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ШаблонАнкеты) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектронноеИнтервьюКлиент.ПечатьАнкеты(ТекущиеДанные.ШаблонАнкеты);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоФункциям(Команда)
	
	ЭлектронноеИнтервьюКлиент.ЗаполнитьПоФункциям(Объект, Характеристики, ЗначенияХарактеристики);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборПрограммыОбученияПоХарактеристикам(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("АдресХарактеристикПерсонала", АдресХарактеристикПерсонала());
	СтруктураПараметров.Вставить("АдресПрограммыОбучения", АдресПрограммыОбучения());
	
	ОбучениеРазвитиеКлиент.ОткрытьФормуПодбораПрограммыОбучения(
		ЭтаФорма, Новый Структура("ПараметрыФормыПодбора", СтруктураПараметров));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьДействияДеревом(Команда)
	Если Элементы.ГруппаДействияСотрудников.ТекущаяСтраница = Элементы.СтраницаДействияСотрудниковСписком Тогда
		СписокДействий = Новый Массив;
		Для Каждого ТекущаяСтрока Из Объект.ДействияСотрудников Цикл
			СписокДействий.Добавить(ТекущаяСтрока.ДействиеСотрудника);
		КонецЦикла;
		ЗаполнитьДеревоДействийСотрудников(СписокДействий);
		Элементы.ГруппаДействияСотрудников.ТекущаяСтраница = Элементы.СтраницаДействияСотрудниковДеревом;
	Иначе
		Элементы.ГруппаДействияСотрудников.ТекущаяСтраница = Элементы.СтраницаДействияСотрудниковСписком;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДействияСотрудниковПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуДобавленияДействий(ЭтаФорма, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ДействияСотрудниковПередУдалением(Элемент, Отказ)
	
	Если Элементы.ДействияСотрудников.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УдаляемыеДействия = Новый Массив;
	Для Каждого ТекущаяСтрока Из Элементы.ДействияСотрудников.ВыделенныеСтроки Цикл
		СтрокаДействия = Объект.ДействияСотрудников.НайтиПоИдентификатору(ТекущаяСтрока);
		Если СтрокаДействия = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		УдаляемыеДействия.Добавить(СтрокаДействия.ДействиеСотрудника);
	КонецЦикла;
	
	ПрочиеДействия = Новый Массив;
	Для Каждого ТекущаяСтрока Из Объект.ДействияСотрудников Цикл
		Если УдаляемыеДействия.Найти(ТекущаяСтрока.ДействиеСотрудника) = Неопределено Тогда
			ПрочиеДействия.Добавить(ТекущаяСтрока.ДействиеСотрудника);
		КонецЕсли;
	КонецЦикла;
	МассивХарактеристик = Новый Массив;
	Для Каждого ТекущаяСтрока Из Характеристики Цикл
		МассивХарактеристик.Добавить(ТекущаяСтрока.Характеристика);
	КонецЦикла;
	МассивЗначенийХарактеристик = Новый Массив;
	Для Каждого ТекущаяСтрока Из ЗначенияХарактеристики Цикл
		МассивЗначенийХарактеристик.Добавить(ТекущаяСтрока.Значение);
	КонецЦикла;
	
	ЭлектронноеИнтервьюКлиент.УдалитьДействияСотрудника(ЭтаФорма, УдаляемыеДействия, ПрочиеДействия, МассивХарактеристик, МассивЗначенийХарактеристик);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПоказатьЗначение(, Элементы.ДействияСотрудников.ТекущиеДанные.ДействиеСотрудника);
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуДобавленияХарактеристик(ЭтаФорма, Копирование, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередУдалением(Элемент, Отказ)
	
	Если Элементы.Характеристики.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Модифицированность = Истина;
	
	ИзменяемыеХарактеристики = Новый Структура;
	УдаляемыеХарактеристики = Новый Массив;
	Для Каждого ТекущаяСтрока Из Элементы.Характеристики.ВыделенныеСтроки Цикл
		СтрокаХарактеристики = Характеристики.НайтиПоИдентификатору(ТекущаяСтрока);
		Если СтрокаХарактеристики = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		УдаляемыеХарактеристики.Добавить(СтрокаХарактеристики.Характеристика);
	КонецЦикла;
	ИзменяемыеХарактеристики.Вставить("УдаляемыеХарактеристики", УдаляемыеХарактеристики);
	ИзменяемыеХарактеристики.Вставить("ДобавляемыеХарактеристики", Новый Массив);
	
	ЭлектронноеИнтервьюКлиент.ИзменитьСоставХарактеристик(Объект, Характеристики, ЗначенияХарактеристики, ИзменяемыеХарактеристики);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя <> "ХарактеристикиЗначение" Тогда
		Возврат;
	КонецЕсли;
	Если Не ДоступноДобавлениеИзменение Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Характеристики.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Или Не ЗначениеЗаполнено(ТекущиеДанные.Характеристика) Тогда
		Возврат;
	КонецЕсли;
	
	ХарактеристикиПерсоналаКлиент.ОткрытьНастройкуЗначенийХарактеристик(ЭтаФорма, ТекущиеДанные.Характеристика);
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элементы.Характеристики.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ХарактеристикаРедактируемойСтроки = Элементы.Характеристики.ТекущиеДанные.Характеристика;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиХарактеристикаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Характеристики.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектронноеИнтервьюКлиент.ОбработатьИзменениеХарактеристики(ЭтаФорма, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыРаботыСКандидатамиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя <> "ЭтапыРаботыСКандидатамиНастройкаАнкеты" Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ЭтапыРаботыСКандидатами.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() И Не Модифицированность Тогда
		ОткрытьФормуНастройкиВопросовСобеседования(ТекущиеДанные.ПолучитьИдентификатор());
		Возврат;
	КонецЕсли;
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОткрытьФормуНастройкиВопросовСобеседованияПослеВопросаЗаписать", ЭтаФорма, ТекущиеДанные.ПолучитьИдентификатор());
	ПоказатьВопросЗаписи(ОбработчикОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросЗаписи(ОбработчикОповещения)
	
	ТекстВопроса = НСтр("ru = 'Данные не записаны.
                         |Для продолжения данные профиля должности необходимо записать.'");
	СписокКнопок = Новый СписокЗначений;
	СписокКнопок.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Записать и продолжить'"));
	СписокКнопок.Добавить(КодВозвратаДиалога.Отмена);
	ПоказатьВопрос(ОбработчикОповещения, ТекстВопроса, СписокКнопок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиВопросовСобеседованияПослеВопросаЗаписать(Ответ, ИдентификаторСтрокиЭтапа) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПослеЗаписи = Ложь;
	
	ПараметрыПослеЗаписи = Новый Структура("ОписаниеОповещения");
	ПараметрыПослеЗаписи.ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуНастройкиВопросовСобеседованияПослеЗаписи", ЭтаФорма, ИдентификаторСтрокиЭтапа);
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиВопросовСобеседованияПослеЗаписи(Результат, ИдентификаторСтрокиЭтапа) Экспорт
	ОткрытьФормуНастройкиВопросовСобеседования(ИдентификаторСтрокиЭтапа);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиВопросовСобеседования(ИдентификаторСтрокиЭтапа)
	
	СтрокаЭтапа = Объект.ЭтапыРаботыСКандидатами.НайтиПоИдентификатору(ИдентификаторСтрокиЭтапа);
	
	Оповещение = Новый ОписаниеОповещения("НастройкаВопросовДляСобеседованияЗавершение", ЭтаФорма, ИдентификаторСтрокиЭтапа);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Объект", Объект.Ссылка);
	ПараметрыФормы.Вставить("ШаблонАнкеты", СтрокаЭтапа.ШаблонАнкеты);
	ПараметрыФормы.Вставить("ЭтапРаботы", СтрокаЭтапа.ЭтапРаботы);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаВопросовДляСобеседования", 
		ПараметрыФормы, 
		ЭтаФорма, 
		Строка(УникальныйИдентификатор) + "_" + ИдентификаторСтрокиЭтапа,,, 
		Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыРаботыСКандидатамиПриИзменении(Элемент)
	
	ЗаполнитьОтображениеНастроекАнкет();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжительностьПланаОбученияПриИзменении(Элемент)
	ОбучениеРазвитиеКлиент.ПриИзмененииПродолжительностиПланаОбучения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура РазмерностьПродолжительностиПланаОбученияПриИзменении(Элемент)
	ОбучениеРазвитиеКлиентСервер.УстановитьЗаголовкиКолонкамПрограммыОбучения(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыПрограммаОбучения

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	
	ПодборПерсоналаКлиентСервер.ЗаполнитьНаименованиеПрофиляДолжности(Объект, ЭтаФорма);
	ПрежняяДолжность = Объект.Должность;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодборПерсоналаКлиентСервер.ЗаполнитьНаименованиеПрофиляДолжности(Объект, ЭтаФорма);
	ПрежнееПодразделение = Объект.Подразделение;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрограммаОбученияПриИзменении(Элемент)
	ОбучениеРазвитиеКлиент.ПрограммаОбученияПриИзменении(ЭтаФорма, Элемент, Элементы.ПрограммаОбучения);
КонецПроцедуры

&НаКлиенте
Процедура ПрограммаОбученияМероприятиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПрограммаОбучения.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьВторичныеДанныеОбученияНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыРаботыСКандидатамиЭтапРаботыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ЭтапРаботы", ВыбранноеЗначение);
	СтрокиЭтапа = Объект.ЭтапыРаботыСКандидатами.НайтиСтроки(ПараметрыПоиска);
	Если СтрокиЭтапа.Количество() > 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Этап ""%1"" уже есть в списке'"), Строка(ВыбранноеЗначение));
		Сообщение.Сообщить();
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыРаботыСКандидатамиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуДобавленияЭтапов(ЭтаФорма, Копирование, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ЭтотОбъект.ПараметрыСвойств.Свойство(ТекущаяСтраница.Имя)
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект = Неопределено)

	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	ЗаполнитьОтображениеНастроекАнкет();
	
	ХарактеристикиПерсоналаФормы.ПрочитатьХарактеристикиВТаблицы(ТекущийОбъект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);
	
	ДоступноДобавлениеИзменение = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.АнкетыКандидатов);
	Если Не ДоступноДобавлениеИзменение Тогда
		Элементы.Характеристики.ТолькоПросмотр = Истина;
		Элементы.ХарактеристикиПерсоналаОткрытьПодборХарактеристикПерсонала.Доступность = Ложь;
	КонецЕсли;
	
	СоздаватьВакансииТолькоПоЗаявке = ПолучитьФункциональнуюОпцию("ОткрытиеВакансииТребуетСогласования");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаявкаНаПодборПерсоналаСоздатьНаОсновании", "Видимость", СоздаватьВакансииТолькоПоЗаявке);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВакансииСоздатьНаОсновании", "Видимость", Не СоздаватьВакансииТолькоПоЗаявке);
	
	ОбучениеРазвитиеФормы.СоздатьИЗаполнитьРеквизитыПланаОбучения(ЭтаФорма);
	
	ПрежняяДолжность = ТекущийОбъект.Должность;
	ПрежнееПодразделение = ТекущийОбъект.Подразделение;
	
КонецПроцедуры

&НаСервере
Процедура РеквизитыВДанные(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ХарактеристикиПерсоналаФормы.ПеренестиХарактеристикиВТабличнуюЧасть(ТекущийОбъект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);
	
КонецПроцедуры

#Область ДлительнаяОперация

&НаКлиенте
Процедура ЗакрытьФорму()
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьСКлиента()
	
	Результат = РезультатЗаписиДлительнойОперацией();
	
	Если Результат.Свойство("ОшибкиПроверкиЗаполнения") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОповеститьОбИзмененииОбъекта();
		ЗаписьДлительнойОперацией = Ложь;
		ЗаписьПослеВыполненияДлительнойОперацииНаКлиенте();
	Иначе
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииОбъекта()
	
	ОповеститьОбИзменении(Объект.Ссылка);
	
	ПараметрыОповещения = Новый Структура(
		"Должность, 
		|Подразделение");
	ЗаполнитьЗначенияСвойств(ПараметрыОповещения, Объект);
	
	Оповестить("Запись_ПрофильДолжности", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Функция РезультатЗаписиДлительнойОперацией()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ОшибкиПроверкиЗаполнения", Истина);
	КонецЕсли;
	
	СправочникОбъект = Неопределено;
	
	// Преобразовываем данные формы в объект.
	Если Модифицированность Тогда
		СправочникОбъект = РеквизитФормыВЗначение("Объект");
		РеквизитыВДанные(СправочникОбъект);
		ДанныеОбъекта = ЗарплатаКадры.СериализоватьОбъектВДвоичныеДанные(СправочникОбъект);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СправочникСсылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("ДанныеОбъекта", ДанныеОбъекта);
	СтруктураПараметров.Вставить("Отказ", Ложь);
	
	НаименованиеЗадания = НСтр("ru = 'Сохранение изменений профиля должности'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Справочники.ПрофилиДолжностей.ВыполнитьЗапись",
		СтруктураПараметров,
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	ЗаписьДлительнойОперацией = Не Результат.ЗаданиеВыполнено;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗаписьПослеВыполненияДлительнойОперацииНаСервере();
		ЗаписьДлительнойОперацией = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаписьПослеВыполненияДлительнойОперацииНаКлиенте()
	
	Если ЗакрыватьПослеЗаписи Тогда
		ПодключитьОбработчикОжидания("ЗакрытьФорму", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПослеЗаписи = Истина;
	
	Если ПараметрыПослеЗаписи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыПослеЗаписи.Свойство("ОписаниеОповещения") Тогда
		ВыполнитьОбработкуОповещения(ПараметрыПослеЗаписи["ОписаниеОповещения"]);
	КонецЕсли;
	
	ПараметрыПослеЗаписи = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписьПослеВыполненияДлительнойОперацииНаСервере()
	
	Модифицированность = Ложь;
	Если ЗакрыватьПослеЗаписи Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(АдресХранилища);
	СправочникОбъект = ЗарплатаКадры.ДесериализоватьОбъектИзДвоичныхДанных(ДанныеОбъекта);
	ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
	ПриПолученииДанныхНаСервере(СправочникОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ЗаданиеВыполненоВДлительнойОперации = Ложь;
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ЗаписьПослеВыполненияДлительнойОперацииНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				ЗаданиеВыполненоВДлительнойОперации = Истина;
				ОповеститьОбИзмененииОбъекта();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
	Если ЗаписьДлительнойОперацией И ЗаданиеВыполненоВДлительнойОперации Тогда
		ЗаписьПослеВыполненияДлительнойОперацииНаКлиенте();
		ЗаписьДлительнойОперацией = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

// Обработчик оповещения о закрытии формы настройки вопросов для собеседования.
// Устанавливает сформированный шаблон анкеты для текущей строки этапов работы с кандидатами.
//
// Параметры 
//	Результат - СправочникСсылка.ШаблоныАнкет, Неопределено - ссылка на сформированный шаблон анкеты. 
//	ДополнительныеПараметры - Структура - структура дополнительных параметров, содержит текущую строку этапа работы с кандидатами.
//
&НаКлиенте
Процедура НастройкаВопросовДляСобеседованияЗавершение(Результат, ИдентификаторСтрокиЭтапа) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЭтапа = Объект.ЭтапыРаботыСКандидатами.НайтиПоИдентификатору(ИдентификаторСтрокиЭтапа);
	
	СтрокаЭтапа.ШаблонАнкеты = Результат;
	ПредставлениеАнкеты = НСтр("ru = 'Без анкеты'");
	Если ЗначениеЗаполнено(Результат) Тогда
		ВопросовВШаблоне = ВопросовВШаблонеАнкеты(Результат);
		ПредставлениеАнкеты = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
			НСтр("ru = ';Анкета (%1 вопрос);;Анкета (%1 вопроса);Анкета (%1 вопросов);Анкета (%1 вопроса)'"), 
			ВопросовВШаблоне);
	КонецЕсли;
	
	СтрокаЭтапа.НастройкаАнкеты = ПредставлениеАнкеты;
	Модифицированность = Истина;
	
КонецПроцедуры

#Область ДобавлениеХарактеристик

&НаСервере
Процедура ДобавитьХарактеристикиИзДействийНаСервере(МассивДобавленныхДействий) Экспорт
	
	ДобавляемыеХарактеристики = ХарактеристикиПерсонала.МассивСтруктурХарактеристикСоЗначениямиИзДействий(МассивДобавленныхДействий);
	ХарактеристикиПерсоналаФормы.ДобавитьХарактеристикиСоЗначениями(Характеристики, ЗначенияХарактеристики, ДобавляемыеХарактеристики);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьХарактеристикиПерсоналаНаСервере(НовыеХарактеристики, ДополнительныеПараметры) Экспорт
	ХарактеристикиПерсоналаФормы.ДобавитьХарактеристикиВТабличнуюЧасть(ЭтаФорма, НовыеХарактеристики, ДополнительныеПараметры);
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция ВопросовВШаблонеАнкеты(ШаблонАнкеты)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВопросыШаблонаАнкеты.Ссылка) КАК КоличествоВопросов,
		|	ВопросыШаблонаАнкеты.Владелец КАК ШаблонАнкеты
		|ИЗ
		|	Справочник.ВопросыШаблонаАнкеты КАК ВопросыШаблонаАнкеты
		|ГДЕ
		|	ВопросыШаблонаАнкеты.Владелец = &ШаблонАнкеты
		|	И НЕ ВопросыШаблонаАнкеты.ЭтоГруппа
		|
		|СГРУППИРОВАТЬ ПО
		|	ВопросыШаблонаАнкеты.Владелец";
	Запрос.УстановитьПараметр("ШаблонАнкеты", ШаблонАнкеты);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоВопросов;
	Иначе
		Возврат 0;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОтображениеНастроекАнкет() Экспорт
	
	ИспользоватьЭлектронноеИнтервью = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронноеИнтервью");
	Если Не ИспользоватьЭлектронноеИнтервью Тогда
		Возврат;
	КонецЕсли;	
	
	Для Каждого ТекущаяСтрока Из Объект.ЭтапыРаботыСКандидатами Цикл
		ТекущаяСтрока.НастройкаАнкеты = НСтр("ru = 'Без анкеты'");
		Если ЗначениеЗаполнено(ТекущаяСтрока.ШаблонАнкеты) Тогда
			ВопросовВШаблоне = ВопросовВШаблонеАнкеты(ТекущаяСтрока.ШаблонАнкеты);
			ТекущаяСтрока.НастройкаАнкеты = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
				НСтр("ru = ';Анкета (%1 вопрос);;Анкета (%1 вопроса);Анкета (%1 вопросов);Анкета (%1 вопроса)'"), 
				ВопросовВШаблоне);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоДействийСотрудников(СписокДействий)
	
	ДеревоДействий = ЭлектронноеИнтервью.ДеревоДействийСотрудников(СписокДействий);
	ЗначениеВДанныеФормы(ДеревоДействий, ДействияСотрудниковДерево);
	
КонецПроцедуры

#Область ПрограммаОбучения

&НаСервере
Процедура ПересоздатьКолонкиПериодовПрограммыОбучения() Экспорт

	ОбучениеРазвитиеФормы.УдалитьЭлементыКолонкиПериодовПлана(ЭтаФорма);
	ОбучениеРазвитиеФормы.СоздатьКолонкиПериодовПрограммыОбучения(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПрограммуОбучения(Результат) Экспорт
	ОбучениеРазвитиеФормы.ЗагрузитьПрограммуОбучения(ЭтаФорма, Результат);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВторичныеДанныеОбученияНаСервере(ИдентификаторТекущейСтроки)
	ОбучениеРазвитиеФормы.ЗаполнитьУчебныеЧасыПланаОбучения(ЭтаФорма, ИдентификаторТекущейСтроки);
	ОбучениеРазвитиеФормы.ЗаполнитьОтветственногоВСтрокеПрограммыОбучения(ЭтаФорма, ИдентификаторТекущейСтроки);
КонецПроцедуры

&НаСервере
Функция АдресХарактеристикПерсонала()
	Возврат ПоместитьВоВременноеХранилище(Характеристики.Выгрузить(, "Характеристика,КартинкаВида,ТребуетсяОбучение"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Функция АдресПрограммыОбучения()
	Возврат ПоместитьВоВременноеХранилище(Объект.ПрограммаОбучения.Выгрузить(, "Мероприятие,Ответственный"), УникальныйИдентификатор);
КонецФункции

#КонецОбласти

#Область УправлениеСвойствами

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#КонецОбласти
