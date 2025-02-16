#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПовторяющаясяБронь") И ЗначениеЗаполнено(Параметры.ПовторяющаясяБронь)
		И Параметры.Свойство("ДатаИсключения") И ЗначениеЗаполнено(Параметры.ДатаИсключения) Тогда
		
		ПовторяющаясяБронь = Параметры.ПовторяющаясяБронь;
		ПовторяющаясяБроньДатаИсключения = Параметры.ДатаИсключения;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаписьНового = Истина;
		ОбновитьПовторение();
		ПроверитьПересекающиесяБрони();
	КонецЕсли;
	
	НачальноеЗначениеДатаНачала = Объект.ДатаНачала;
	НачальноеЗначениеДатаОкончания = Объект.ДатаОкончания;
	
	УстановитьДоступностьИВидимостьКоманд();
	
	Элементы.Основание.Видимость = ЗначениеЗаполнено(Объект.Предмет);
	
	ОтображатьВремяС = БронированиеПомещений.ПолучитьПерсональнуюНастройку("ОтображатьВремяС");
	
	УстановитьРежимФормы();
	
	УстановитьПодсказкуСпособаВвода();
	
	УстановитьФокус();
	
	УстановитьПодсказкуПомещения();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	УстановитьДоступностьВремени();
	Если ЕстьПересекающиесяБрони Тогда
		ПодключитьОбработчикОжидания("ВыборВремени", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальныйИдентификатор Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Бронь" Тогда
		
		Если Объект.Ссылка = Параметр Тогда
			Прочитать();
		Иначе
			ПроверитьПересекающиесяБрониКлиент();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ОбновитьПовторение();
	ПроверитьПересекающиесяБрони();
	
	УстановитьДоступностьИВидимостьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПроверитьПересекающиесяБрони() Тогда
		
		Отказ = Истина;
		
		ЗакрытьПослеЗаписи =
			ПараметрыЗаписи.Свойство("ЗакрытьПослеЗаписи") И ПараметрыЗаписи.ЗакрытьПослеЗаписи;
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Записать", Истина);
		ПараметрыОбработчика.Вставить("Закрыть", ЗакрытьПослеЗаписи);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборВремениЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		БронированиеПомещенийКлиент.ВыбратьВремяБрони(Объект, ПовторяющаясяБронь,
			ПовторяющаясяБроньДатаИсключения, ОписаниеОповещения, , Истина);
		
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая()
		И Не ПараметрыЗаписи.Свойство("ПодтверждениеПрошлогоПериода")
		И Объект.ДатаНачала < ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
		
		Отказ = Истина;
		
		ЗакрытьПослеЗаписи =
			ПараметрыЗаписи.Свойство("ЗакрытьПослеЗаписи")
			И ПараметрыЗаписи.ЗакрытьПослеЗаписи;
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Записать", Истина);
		ПараметрыОбработчика.Вставить("Закрыть", ЗакрытьПослеЗаписи);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПодтверждениеПрошлогоПериодаЗавершение",
			ЭтотОбъект,
			ПараметрыОбработчика);
		
		ТекстВопроса = НСтр("ru = 'Указанная дата начала брони уже прошла. Забронировать?'");
		ПоказатьВопросДаНет(ОписаниеОповещения, ТекстВопроса);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(ПовторяющаясяБронь) И ЗначениеЗаполнено(ПовторяющаясяБроньДатаИсключения) Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПовторяющаясяБронь", ПовторяющаясяБронь);
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ДатаИсключения", ПовторяющаясяБроньДатаИсключения);
	КонецЕсли;
	
	Если ИзменилисьНастройкаПовторения Тогда
		НастройкиПовторения = ТекущийОбъект.ПолучитьНастройкиПовторения();
		ТекущийОбъект.ДополнительныеСвойства.Вставить("НастройкиПовторения", НастройкиПовторения);
	КонецЕсли;
	
	ТекущийОбъект.СпособСозданияБрони = Перечисления.СпособыСозданияБрони.Вручную;
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьИВидимостьКоманд();
	УстановитьПодсказкуСпособаВвода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗаписьНового Тогда
		Оповестить("Создание_Бронь");
	КонецЕсли;
	
	ИзменилисьНастройкаПовторения = Ложь;
	Оповестить("Запись_Бронь", Объект.Ссылка, УникальныйИдентификатор);
	
	ТекстОповещения = ?(ПараметрыЗаписи.ЭтоНовыйОбъект, НСтр("ru = 'Создание:'"), НСтр("ru = 'Изменение:'"));
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	БронированиеПомещенийКлиент.ВыбратьПользователяБрони(Элемент, Объект.Пользователь, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторениеСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПовторениеЗавершение", ЭтотОбъект);
	БронированиеПомещенийКлиент.ОткрытьФормуНастройкиПовторения(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Модифицированность = Истина;
	Объект.ДатаНачала = Дата(1,1,1);
	Объект.ДатаОкончания = Дата(1,1,1);
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Модифицированность = Истина;
	Объект.ДатаНачала = Дата(1,1,1);
	Объект.ДатаОкончания = Дата(1,1,1);
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, Объект.ДатаНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаВремяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, Объект.ДатаНачала);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Модифицированность = Истина;
	Объект.ДатаНачала = Дата(1,1,1);
	Объект.ДатаОкончания = Дата(1,1,1);
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяПриИзменении(Элемент)
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Элемент.СписокВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Модифицированность = Истина;
	Объект.ДатаНачала = Дата(1,1,1);
	Объект.ДатаОкончания = Дата(1,1,1);
	
	РаботаСРабочимКалендаремКлиентСервер.СкорректироватьДатуНачалаИОкончания(
		Объект.ДатаНачала, Объект.ДатаОкончания, Объект.ВесьДень,
		НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, Объект.ДатаОкончания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияВремяОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСРабочимКалендаремКлиент.СформироватьДанныеВыбораВремени(Текст, ДанныеВыбора, Объект.ДатаОкончания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВесьДеньПриИзменении(Элемент)
	
	БронированиеПомещенийКлиент.ПриИзмененииВесьДень(
		Объект, НачальноеЗначениеДатаНачала, НачальноеЗначениеДатаОкончания, ОтображатьВремяС);
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	УстановитьДоступностьВремени();
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	
	ПомещениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("КлючНазначенияИспользования", "ВыборПомещенияДляБрони");
	
	ОткрытьФорму("Справочник.ТерриторииИПомещения.Форма.ВыборПомещения", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеОчистка(Элемент, СтандартнаяОбработка)
	
	ПомещениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БронированиеПомещенийВызовСервера.СформироватьДанныеВыбораПомещения(
			ПараметрыПолученияДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БронированиеПомещенийВызовСервера.СформироватьДанныеВыбораПомещения(
			ПараметрыПолученияДанных);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ПараметрыЗаписи = Новый Структура("ЗакрытьПослеЗаписи", Истина);
	ЗаписатьВыполнить(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура Повторение(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПовторениеЗавершение", ЭтотОбъект);
	БронированиеПомещенийКлиент.ОткрытьФормуНастройкиПовторения(Объект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	ИзменилисьНастройкаПовторения = Истина;
	ПовторениеЗавершениеНаСервере(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьВремя(Команда)
	
	ВыборВремени();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	Если Модифицированность = Истина Или (Не ЗначениеЗаполнено(Объект.Ссылка)) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПометитьНаУдалениеЗавершение", ЭтотОбъект);
		ТекстВопроса =
			НСтр("ru = 'Для установки отметки удаления необходимо записать внесенные изменения. Записать данные?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	БронированиеПомещенийКлиент.УстановитьПометкуУдаления(Объект.Ссылка, Не Объект.ПометкаУдаления);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Записать();
	
	БронированиеПомещенийКлиент.УстановитьПометкуУдаления(Объект.Ссылка, Не Объект.ПометкаУдаления);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСпискиВыбора()
	
	// Заполнение списка выбора даты начала
	Элементы.ДатаНачалаВремя.СписокВыбора.Очистить();
	
	Если ЗначениеЗаполнено(Объект.ДатаНачала) Тогда 
		ТекДата = НачалоДня(Объект.ДатаНачала);
	Иначе
		ТекДата = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	КонецЕсли;
	
	Для Инд = 1 По 48 Цикл
		
		Элементы.ДатаНачалаВремя.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
		Если Объект.ДатаНачала > ТекДата И Объект.ДатаНачала < ТекДата + 1800 Тогда
			Элементы.ДатаНачалаВремя.СписокВыбора.Добавить(Объект.ДатаНачала, Формат(Объект.ДатаНачала, "ДФ=ЧЧ:мм"));
		КонецЕсли;
		
		ТекДата = ТекДата + 1800;
		
	КонецЦикла;
	
	// Заполнение списка выбора даты окончания
	Элементы.ДатаОкончанияВремя.СписокВыбора.Очистить();
	
	СобытиеВПределахОдногоДня = ЗначениеЗаполнено(Объект.ДатаНачала)
		И (НачалоДня(Объект.ДатаНачала) = НачалоДня(Объект.ДатаОкончания)
			ИЛИ НЕ ЗначениеЗаполнено(Объект.ДатаОкончания))
		И Объект.ДатаНачала < Объект.ДатаОкончания;
	
	Если СобытиеВПределахОдногоДня Тогда
		
		ТекДата = РаботаСРабочимКалендаремКлиентСервер.КонецПолучаса(Объект.ДатаНачала);
		Если Объект.ДатаОкончания > ТекДата - 1800 И Объект.ДатаОкончания < ТекДата Тогда
			Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(
				Объект.ДатаОкончания, Формат(Объект.ДатаОкончания, "ДФ=ЧЧ:мм"));
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		ТекДата = НачалоДня(Объект.ДатаОкончания);
	Иначе
		ТекДата = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	КонецЕсли;
	
	Для Инд = 1 По 48 Цикл
		
		Если СобытиеВПределахОдногоДня И ТекДата > КонецДня(Объект.ДатаНачала) Тогда
			Прервать;
		КонецЕсли;
		
		Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(ТекДата, Формат(ТекДата, "ДФ=ЧЧ:мм"));
		Если Объект.ДатаОкончания > ТекДата И Объект.ДатаОкончания < ТекДата + 1800 Тогда
			Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(Объект.ДатаОкончания, Формат(Объект.ДатаОкончания, "ДФ=ЧЧ:мм"));
		КонецЕсли;
		ТекДата = ТекДата + 1800;
		
	КонецЦикла;
	
	Элементы.ДатаОкончанияВремя.СписокВыбора.Добавить(ТекДата, "00:00");
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиДлительностьСобытия()
	
	ДлительностьСтр = "";
	
	Если Не ЗначениеЗаполнено(Объект.ДатаНачала) Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда 
		Возврат;
	КонецЕсли;
	
	ДлительностьСек = НачалоМинуты(Объект.ДатаОкончания) - НачалоМинуты(Объект.ДатаНачала);
	
	Если Объект.ВесьДень Тогда
		ДлительностьСек = ДлительностьСек + 60;
	КонецЕсли;
	
	Дней = Цел(ДлительностьСек / 86400); // 86400 - число секунд в сутках
	ПредставлениеДней = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru = ';%1 день;;%1 дня;%1 дней;'"), Дней);
	
	Часов = Цел((ДлительностьСек - Дней * 86400) / 3600); // 86400 - число секунд в сутках
	ПредставлениеЧасов = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru = ';%1 час;;%1 часа;%1 часов;'"), Часов);
	
	Минут = Цел((ДлительностьСек - Дней * 86400 - Часов * 3600) / 60); // 86400 - число секунд в сутках
	ПредставлениеМинут = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru = ';%1 минута;;%1 минуты;%1 минут;'"), Минут);
	
	Если Дней > 0 Тогда 
		ДлительностьСтр = ДлительностьСтр + ПредставлениеДней;
	КонецЕсли;
	
	Если Часов > 0 Тогда 
		
		Если Дней > 0 Тогда
			ДлительностьСтр = ДлительностьСтр + " ";
		КонецЕсли;
		
		ДлительностьСтр = ДлительностьСтр + ПредставлениеЧасов;
	КонецЕсли;
	
	Если Минут > 0 Тогда 
		
		Если Дней > 0 Или Часов > 0 Тогда
			ДлительностьСтр = ДлительностьСтр + " ";
		КонецЕсли;
		
		ДлительностьСтр = ДлительностьСтр + ПредставлениеМинут;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьВремени()
	
	Элементы.ДатаНачалаВремя.Доступность = Не Объект.ВесьДень;
	Элементы.ДатаОкончанияВремя.Доступность = Не Объект.ВесьДень;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПовторение()
	
	ЭтоПовторяющаясяБронь = (Объект.ТипЗаписи = Перечисления.ТипЗаписиКалендаря.ПовторяющеесяСобытие);
	Элементы.ПовторениеСтрокой.Видимость = ЭтоПовторяющаясяБронь;
	
	Если ЭтоПовторяющаясяБронь Тогда
		ЗначениеОбъект = РеквизитФормыВЗначение("Объект");
		ПовторениеСтрокой = ЗначениеОбъект.ПолучитьПредставлениеПовторения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПересекающиесяБрониКлиент()
	
	Если Не ЗначениеЗаполнено(Объект.ДатаНачала) Или Не ЗначениеЗаполнено(Объект.ДатаОкончания) 
		Или Не ЗначениеЗаполнено(Объект.Помещение) И Элементы.ПодобратьВремя.Видимость = Ложь Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПроверитьПересекающиесяБрони();
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПересекающиесяБрони()
	
	ПересекающиесяБрони.Очистить();
	Если Не ЗначениеЗаполнено(Объект.ДатаНачала) Или Не ЗначениеЗаполнено(Объект.ДатаОкончания) 
		Или Не ЗначениеЗаполнено(Объект.Помещение) Тогда
		
		Элементы.ПодобратьВремя.Видимость = Ложь;
		Возврат Истина;
		
	КонецЕсли;
	
	ТаблицаБроней = БронированиеПомещений.ПолучитьПересекающиесяБрони(
		Объект, ПовторяющаясяБронь, ПовторяющаясяБроньДатаИсключения);
	Для Каждого СтрокаБронь Из ТаблицаБроней Цикл
		НоваяСтрока = ПересекающиесяБрони.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаБронь);
	КонецЦикла;
	
	ЕстьПересекающиесяБрони = (ПересекающиесяБрони.Количество() > 0);
	Элементы.ПодобратьВремя.Видимость = ЕстьПересекающиесяБрони;
	
	Возврат Не ЕстьПересекающиесяБрони;
	
КонецФункции

&НаСервере
Процедура ПовторениеЗавершениеНаСервере(НоваяБронь)
	
	НоваяБроньЗначение = ДанныеФормыВЗначение(НоваяБронь, Тип("ДокументОбъект.Бронь"));
	НоваяБроньЗначение.СкорректироватьДатыПовторения();
	ЗначениеВРеквизитФормы(НоваяБроньЗначение, "Объект");
	
	ОбновитьПовторение();
	ПроверитьПересекающиесяБрони();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьИВидимостьКоманд()
	
	Элементы.ФормаПовторение.Доступность =
		(Объект.ТипЗаписи <> Перечисления.ТипЗаписиКалендаря.ЭлементПовторяющегосяСобытия);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимФормы()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УстановитьРежимЧтения();
	Иначе
		УстановитьРежимСоздания()
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимЧтения()
	
	УстановитьРежимЧтения = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если БронированиеПомещений.ДоступноИзменениеБрони(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
	Элементы.ПовторениеСтрокой.Гиперссылка = Ложь;
	
	Элементы.ФормаГруппаРедактирование.Видимость = Ложь;
	Элементы.ФормаГруппаРедактированиеЕще.Видимость = Ложь;
	Элементы.ФормаГруппаЧтение.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРежимСоздания()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ФормаГотово.КнопкаПоУмолчанию = Истина;
	
	Элементы.ФормаГруппаРедактирование.Видимость = Ложь;
	Элементы.ФормаГруппаРедактированиеЕще.Видимость = Ложь;
	Элементы.ФормаГруппаСоздание.Видимость = Истина;
	Элементы.ФормаГруппаСозданиеЕще.Видимость = Истина;
	Элементы.ФормаГруппаЧтениеИРедактирование.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПомещениеПриИзмененииНаСервере()
	
	УстановитьДоступностьИВидимостьКоманд();
	ПроверитьПересекающиесяБрони();
	УстановитьПодсказкуПомещения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(ПараметрыЗаписи)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Записать(ПараметрыЗаписи) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗаписи.ЗакрытьПослеЗаписи И Открыта() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуСпособаВвода()
	
	Если Объект.СпособСозданияБрони = Перечисления.СпособыСозданияБрони.Автоматически Тогда
		Элементы.Основание.Подсказка = НСтр("ru = 'Бронь введена автоматически.'");
		Элементы.Основание.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	ИначеЕсли Объект.СпособСозданияБрони = Перечисления.СпособыСозданияБрони.АвтоматическиУказанПредмет Тогда
		Элементы.Основание.Подсказка = НСтр("ru = 'Предмет брони указан автоматически.'");
		Элементы.Основание.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	Иначе
		Элементы.Основание.Подсказка = "";
		Элементы.Основание.ОтображениеПодсказки = ОтображениеПодсказки.Авто;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФокус()
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Помещение) Тогда
		Элементы.Помещение.АктивизироватьПоУмолчанию = Истина;
	Иначе
		Элементы.КоличествоЧеловек.АктивизироватьПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВремени()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборВремениЗавершение", ЭтотОбъект);
	БронированиеПомещенийКлиент.ВыбратьВремяБрони(
		Объект, ПовторяющаясяБронь, ПовторяющаясяБроньДатаИсключения, ОписаниеОповещения, Объект.ВесьДень);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВремениЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Действие = "ВыборРекомендации" Тогда
		ЗаполнитьЗначенияСвойств(Объект, Результат.Рекомендация);
		Объект.ВесьДень = Ложь;
	ИначеЕсли Результат.Действие = "ВыборРекомендацииПомещения" Тогда
		Объект.Помещение = Результат.Рекомендация;
	КонецЕсли;
	
	ЗаполнитьСпискиВыбора();
	ВывестиДлительностьСобытия();
	ПроверитьПересекающиесяБрониКлиент();
	
	Если ДополнительныеПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("Записать") И ДополнительныеПараметры.Записать Тогда
		Если ДополнительныеПараметры.Свойство("Закрыть") И ДополнительныеПараметры.Закрыть Тогда
			ПараметрыЗаписи = Новый Структура("ЗакрытьПослеЗаписи", Истина);
			ЗаписатьВыполнить(ПараметрыЗаписи);
		Иначе
			ПараметрыЗаписи = Новый Структура("ЗакрытьПослеЗаписи", Ложь);
			ЗаписатьВыполнить(ПараметрыЗаписи);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуПомещения()
	
	РеквизитыПомещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Помещение,
		"Описание, Вместимость");
	ОтветственныйХозяйственноеОбеспечение = 
		Справочники.ТерриторииИПомещения.ОтветственныйХозяйственноеОбеспечение(Объект.Помещение);
	ОтветственныйТехническоеОбеспечение = 
		Справочники.ТерриторииИПомещения.ОтветственныйТехническоеОбеспечение(Объект.Помещение);
	
	Если ЗначениеЗаполнено(РеквизитыПомещения.Описание) Тогда
		Элементы.Помещение.Подсказка = РеквизитыПомещения.Описание;
		Элементы.Помещение.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	Иначе
		Элементы.Помещение.Подсказка = "";
		Элементы.Помещение.ОтображениеПодсказки = ОтображениеПодсказки.Авто;
	КонецЕсли;
	Элементы.КоличествоЧеловек.АвтоОтметкаНезаполненного =
		ЗначениеЗаполнено(РеквизитыПомещения.Вместимость);
	Элементы.ХозяйственноеОбеспечение.Видимость =
		ЗначениеЗаполнено(ОтветственныйХозяйственноеОбеспечение);
	Элементы.ТехническоеОбеспечение.Видимость = 
		ЗначениеЗаполнено(ОтветственныйТехническоеОбеспечение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждениеПрошлогоПериодаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("Записать") И ДополнительныеПараметры.Записать Тогда
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("ПодтверждениеПрошлогоПериода");
		Если ДополнительныеПараметры.Свойство("Закрыть") И ДополнительныеПараметры.Закрыть Тогда
			ПараметрыЗаписи.Вставить("ЗакрытьПослеЗаписи", Истина);
			ЗаписатьВыполнить(ПараметрыЗаписи);
		Иначе
			ПараметрыЗаписи.Вставить("ЗакрытьПослеЗаписи", Ложь);
			ЗаписатьВыполнить(ПараметрыЗаписи);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросДаНет(ОписаниеОповещенияОЗавершении, ТекстВопроса,
	ТекстКнопкиДа = Неопределено, ТекстКнопкиНет = Неопределено, КнопкаПоУмолчанию = Неопределено)

	// Показывает вопрос "Да" / "Нет", принимая Esc и закрытие формы крестиком как ответ "Нет".
	//
	// Параметры:
	//   ОписаниеОповещенияОЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия с
	//     передачей параметра КодВозвратаДиалога.Да или КодВозвратаДиалога.Нет.
	//   ТекстВопроса - Строка - текст задаваемого вопроса.
	//   ТекстКнопкиДа - Строка - необязательный, текст кнопки "Да".
	//   ТекстКнопкиНет - Строка - необязательный, текст кнопки "Нет".
	//   КнопкаПоУмолчанию - РежимДиалогаВопрос - необязательный, кнопка по умолчанию.
	//
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоказатьВопросДаНетЗавершение", ЭтотОбъект, ОписаниеОповещенияОЗавершении);
		
	Кнопки = Новый СписокЗначений;
	Если ТекстКнопкиДа = Неопределено Тогда
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Да'"));
	Иначе
		Кнопки.Добавить(КодВозвратаДиалога.ОК, ТекстКнопкиДа);
	КонецЕсли;
	Если ТекстКнопкиНет = Неопределено Тогда
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Нет'"));
	Иначе
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, ТекстКнопкиНет);
	КонецЕсли;
	
	Если КнопкаПоУмолчанию = Неопределено Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	ИначеЕсли КнопкаПоУмолчанию = КодВозвратаДиалога.Да Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КодВозвратаДиалога.ОК);
	ИначеЕсли КнопкаПоУмолчанию = КодВозвратаДиалога.Нет Тогда
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,, КодВозвратаДиалога.Отмена);
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение кнопки по умолчанию: %1'"),
			КнопкаПоУмолчанию);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросДаНетЗавершение(Результат, ОписаниеОповещения) Экспорт

	// Вызывается после закрытия окна с вопросом "Да" / "Нет" и вызывает ранее переданный обработчик
	// оповещения с передачей ответа пользователя.
	//
	// Параметры:
	//   Результат - КодВозвратаДиалога - ответ пользователя,
	//     КодВозвратаДиалога.ОК или КодВозвратаДиалога.Отмена.
	//   ОписаниеОповещения - ОписаниеОповещения - описание вызываемого оповещения.
	//
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти