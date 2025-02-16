
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		Элементы.Список.РежимВыбора = Истина;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			Заголовок = НСтр("ru = 'Подбор начислений'");
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок = НСтр("ru = 'Выбор начисления'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Параметры.ТекущаяСтрока) Тогда
			ВАрхиве = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ТекущаяСтрока, "ВАрхиве");
			Если ВАрхиве Тогда
				// Если при открытии формы выбора передано не действующее начисление, изменим отбор в списке.
				ПоказыватьНачисленияВАрхиве = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьОтборИспользуемых(Список.Отбор, ПоказыватьНачисленияВАрхиве);
	
	Если Параметры.Свойство("ИсключатьПособияПоУходуЗаРебенком") Тогда
		УстановитьОтборПособияПоУходуЗаРебенком(Список.Отбор, Параметры.ИсключатьПособияПоУходуЗаРебенком);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		НовыйТекстЗапроса = Модуль.УточнитьТекстЗапросаСпискаНачислений(Список.ТекстЗапроса);
		Если Не ПустаяСтрока(НовыйТекстЗапроса) Тогда
			Список.ТекстЗапроса = НовыйТекстЗапроса;
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельФормы;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,,, "ВАрхиве");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьНачисленияВАрхивеПриИзменении(Элемент)
	УстановитьОтборИспользуемых(Список.Отбор, ПоказыватьНачисленияВАрхиве);
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормыЭлементаПланаВидовРасчетаНачисления");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормыНовогоЭлементаПланаВидовРасчетаНачисления");

КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область КомандыПодсистемыНастройкиПорядкаЭлементов

&НаКлиенте
Процедура НастройкаСреднегоЗаработка(Команда)
	
	ОткрытьФорму("Обработка.ГрупповоеРедактированиеНачислений.Форма", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборИспользуемых(ГруппаОтбора, ПоказыватьВАрхиве)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ГруппаОтбора, "ВАрхиве");
	Если НЕ ПоказыватьВАрхиве Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтбора, "ВАрхиве", Ложь);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПособияПоУходуЗаРебенком(ГруппаОтбора, ИсключатьПособияПоУходуЗаРебенком)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(ГруппаОтбора, "КатегорияНачисленияИлиНеоплаченногоВремени");
	
	Если ИсключатьПособияПоУходуЗаРебенком Тогда
		
		ИсключенныеВиды = Новый Массив;
		ИсключенныеВиды.Добавить(
			ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет"));
		ИсключенныеВиды.Добавить(
			ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоТрехЛет"));
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаОтбора, "КатегорияНачисленияИлиНеоплаченногоВремени", ИсключенныеВиды, ВидСравненияКомпоновкиДанных.НеВСписке);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
