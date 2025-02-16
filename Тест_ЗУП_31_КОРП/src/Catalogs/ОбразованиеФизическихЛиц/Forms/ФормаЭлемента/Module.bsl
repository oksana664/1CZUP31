#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Параметры.Ключ.Пустая() Тогда
		ПриПолученииДанных(Объект);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ПриПолученииДанных(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриПолученииДанных(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписанСправочникОбразованиеФизическихЛиц", , ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидОбразованияПриИзменении(Элемент)
	
	УстановитьВидДополнительногоОбучения();
	УстановитьВидПослевузовскогоОбразования();
	
	УстановитьОтображениеЭлементовФормы(ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриПолученииДанных(ТекущийОбъект)
	
	УстановитьОтображениеЭлементовФормы(ЭтаФорма, ТекущийОбъект);
	
	Если ОбщегоНазначения.СсылкаСуществует(Объект.Владелец) Тогда
		Заголовок = НСтр("ru='Образование'") + ": " + Объект.Владелец;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Владелец",
		"Видимость",
		НЕ ЗначениеЗаполнено(Объект.Владелец));
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеЭлементовФормы(Форма, ТекущийОбъект)
				
	УстановитьОтображениеВидаПослеВузовскогоОбразования(Форма, ТекущийОбъект);
	УстановитьОтображениеВидаДополнительногоОбучения(Форма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеВидаПослеВузовскогоОбразования(Форма, ТекущийОбъект)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ВидПослевузовскогоОбразования",
		"Видимость",
		ТекущийОбъект.ВидОбразования = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ВысшееОбразованиеПодготовкаКадровВысшейКвалификации")
			Или ТекущийОбъект.ВидОбразования = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ПослевузовскоеОбразование"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеВидаДополнительногоОбучения(Форма, ТекущийОбъект)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Форма.Элементы,
	"ВидПрофессиональногоОбучения",
	"Видимость",
	ТекущийОбъект.ВидОбразования = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ПрофессиональноеОбучение"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	Форма.Элементы,
	"ВидПрофессиональногоОбразования",
	"Видимость",
	ТекущийОбъект.ВидОбразования = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ДополнительноеПрофессиональноеОбразование"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидДополнительногоОбучения()
	
	Если Объект.ВидОбразования <> ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ПрофессиональноеОбучение")
		И Объект.ВидОбразования <> ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ДополнительноеПрофессиональноеОбразование") Тогда
		Объект.ВидДополнительногоОбучения = ПредопределенноеЗначение("Перечисление.ВидыПрофессиональнойПодготовки.ПустаяСсылка");
	ИначеЕсли Объект.ВидОбразования = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ПрофессиональноеОбучение")
		И Не ЗначениеЗаполнено(Объект.ВидДополнительногоОбучения) Тогда
		Объект.ВидДополнительногоОбучения = ПредопределенноеЗначение("Перечисление.ВидыПрофессиональнойПодготовки.ПовышениеКвалификации");
	ИначеЕсли Объект.ВидОбразования = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ДополнительноеПрофессиональноеОбразование")
		И (Объект.ВидДополнительногоОбучения = ПредопределенноеЗначение("Перечисление.ВидыПрофессиональнойПодготовки.Подготовка") 
		ИЛИ Не ЗначениеЗаполнено(Объект.ВидДополнительногоОбучения)) Тогда
		Объект.ВидДополнительногоОбучения = ПредопределенноеЗначение("Перечисление.ВидыПрофессиональнойПодготовки.ПовышениеКвалификации");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидПослевузовскогоОбразования()
	
	Если Объект.ВидОбразования <> ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ВысшееОбразованиеПодготовкаКадровВысшейКвалификации")
		И Объект.ВидОбразования <> ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ПослевузовскоеОбразование") Тогда
		Объект.ВидПослевузовскогоОбразования = ПредопределенноеЗначение("Справочник.ВидыОбразованияФизическихЛиц.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

