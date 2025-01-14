
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Ключ.Пустая() Тогда
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ХарактеристикиПерсоналаФормы.ПеренестиХарактеристикиВТабличнуюЧасть(ТекущийОбъект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
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
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыХарактеристики

&НаКлиенте
Процедура ХарактеристикиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуДобавленияХарактеристик(
		ЭтаФорма, Копирование, Отказ, Новый Структура("СтруктураЗначенийПоУмолчанию", Новый Структура("Вес", 1)));
		
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередУдалением(Элемент, Отказ)
	ХарактеристикиПерсоналаКлиент.УдалитьЗначенияХарактеристик(ЭтаФорма, Элементы.Характеристики.ВыделенныеСтроки);
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя <> "ХарактеристикиЗначенияСтрокой" Тогда
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
	
	ЗаполнитьВидИКартинкаХарактеристикиНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	ХарактеристикиПерсоналаКлиент.ОбработатьИзменениеХарактеристики(ЭтаФорма, ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриПолученииДанныхНаСервере()

	ХарактеристикиПерсоналаФормы.ПрочитатьХарактеристикиВТаблицы(Объект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаХарактеристикиПерсонала",
		"ТолькоПросмотр",
		Не ПравоДоступа("Изменение", Метаданные.Справочники.КомпетенцииПерсонала));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ХарактеристикиПерсоналаОткрытьПодборХарактеристикПерсонала",
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.Справочники.КомпетенцииПерсонала));
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьХарактеристикиПерсоналаНаСервере(НовыеХарактеристики, ДополнительныеПараметры) Экспорт
	ХарактеристикиПерсоналаФормы.ДобавитьХарактеристикиВТабличнуюЧасть(ЭтаФорма, НовыеХарактеристики, ДополнительныеПараметры);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидИКартинкаХарактеристикиНаСервере(Идентификатор)

	ТекущиеДанные = Характеристики.НайтиПоИдентификатору(Идентификатор);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитов = ХарактеристикиПерсонала.ВидИКартинкаХарактеристики(ТекущиеДанные.Характеристика);
	ТекущиеДанные.ВидХарактеристики = СтруктураРеквизитов.ВидХарактеристики;
	ТекущиеДанные.КартинкаВида = СтруктураРеквизитов.Картинка;

КонецПроцедуры

#КонецОбласти 
