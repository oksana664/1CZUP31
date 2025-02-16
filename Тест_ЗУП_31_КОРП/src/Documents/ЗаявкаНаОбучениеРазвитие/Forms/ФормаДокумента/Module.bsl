#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Начальное заполнение
	Если Параметры.Ключ.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Ответственный", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
	КонецЕсли;
	
	ПриПолученииДанныхНаСервере();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПриПолученииДанныхНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗаявкаНаОбучениеРазвитие", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
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

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для каждого ВыбранныйСотрудник Из ВыбранноеЗначение Цикл
		Если Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник",ВыбранныйСотрудник)).Количество()=0 Тогда
			НовыйСотрудник = Объект.Сотрудники.Добавить();
			НовыйСотрудник.Сотрудник = ВыбранныйСотрудник;
			Модифицированность = Истина;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура МероприятиеПриИзменении(Элемент)
	
	ЗаполнитьВторичныеРеквизитыМероприятия();
	
	Если НЕ ЗначениеЗаполнено(Объект.Мероприятие) Тогда
		Возврат;
	КонецЕсли;
	
	Если РеквизитыКЗаполнениюЗаняты("ВыборМероприятия") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("МероприятиеПриИзмененииЗавершение",ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru = 'Заполнить заявку на основе данных мероприятия? Существующие данные будут утеряны.'"),
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьПоМероприятиюНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасходы

&НаКлиенте
Процедура РасходыПриИзменении(Элемент)
	
	ОбучениеРазвитиеКлиент.РассчитатьСуммуРасходов(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТребуемыеХарактеристики

&НаКлиенте
Процедура ТребуемыеХарактеристикиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ХарактеристикиПерсоналаКлиент.ХарактеристикиВыбор(Элементы.ТребуемыеХарактеристики.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ТребуемыеХарактеристикиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуДобавленияХарактеристик(ЭтаФорма, Копирование, Отказ);
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоТребуемыхХарактеристик

&НаКлиенте
Процедура ДеревоТребуемыхХарактеристикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ХарактеристикиПерсоналаКлиент.ХарактеристикиВыбор(Элементы.ДеревоТребуемыхХарактеристик.ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыХарактеристикиПерсонала

&НаКлиенте
Процедура ХарактеристикиПерсоналаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ХарактеристикиПерсоналаКлиент.ХарактеристикиВыбор(Элементы.ХарактеристикиПерсонала.ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоХарактеристик

&НаКлиенте
Процедура ДеревоХарактеристикВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ХарактеристикиПерсоналаКлиент.ХарактеристикиВыбор(Элементы.ДеревоХарактеристик.ТекущиеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьСотрудников(Команда)
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихНаДатуПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,,,,,АдресСпискаПодобранныхСотрудников());
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьРасходыПоМероприятию(Команда)
	
	ЗаполнитьПоМероприятиюНаСервере();
	
КонецПроцедуры

#Область КомандыСтатусаЗаявки

&НаКлиенте
Процедура НаправитьНаСогласование(Команда)
	ЗаписатьЗаявку(ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Рассматривается"), "ФормаНаправитьНаСогласование");
КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)
	ЗаписатьЗаявку(ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Отклонено"), "ФормаОтклонить");
КонецПроцедуры

&НаКлиенте
Процедура ВернутьНаПодготовку(Команда)
	ЗаписатьЗаявку(ПредопределенноеЗначение("Перечисление.СостоянияСогласования.ПустаяСсылка"), "ФормаВернутьНаПодготовку");
КонецПроцедуры

&НаКлиенте
Процедура Согласовать(Команда)
	ЗаписатьЗаявку(ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Согласовано"), "ФормаСогласовать");
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование(Команда)
	ЗаписатьЗаявку(ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Рассматривается"), "ФормаОтменитьСогласование");
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПодобратьХарактеристики(Команда)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуПодбораХарактеристик(ЭтаФорма, Новый Структура("ДобавлятьЗначенияХарактеристик, СтрокаСкрываемыхРеквизитов", Ложь, "Значения"));
КонецПроцедуры

&НаКлиенте
Процедура ПоКомпетенциям(Команда)
	
	Элементы.ПоКомпетенциям.Пометка = НЕ Элементы.ПоКомпетенциям.Пометка;
	
	УстановитьСвойстваЭлементовХарактеристикПерсонала(ЭтаФорма);
	
	ЗаполнитьДеревоХарактеристикНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоКомпетенциямТребуемые(Команда)
	
	Элементы.ПоКомпетенциямТребуемые.Пометка = НЕ Элементы.ПоКомпетенциямТребуемые.Пометка;
	
	УстановитьСвойстваЭлементовТребуемыхХарактеристикПерсонала(ЭтаФорма);
	
	ЗаполнитьДеревоТребуемыхХарактеристикНаСервере();
	
КонецПроцедуры

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
Процедура ПодобратьИзПлана(Команда)
	
	Если РеквизитыКЗаполнениюЗаняты("ПодобратьИзПлана") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодобратьИзПланаЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения,
			НСтр("ru = 'Заполнить документ на основании данных плана обучения? Существующие данные будут утеряны.'"),
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ПодобратьИзПланаЗавершение(КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()

	// Получаем статус заявки и устанавливаем вспомогательные реквизиты формы.
	УстановитьСтатусЗаявки();
	// Определяем уровень пользователя.
	ОбучениеРазвитие.УстановитьРеквизитыДоступностиРолей(ЭтаФорма);
	ОбучениеРазвитие.СкрытьНеРазрешенныеКомандыПоРолям(ЭтаФорма);
	
	ХарактеристикиПерсоналаФормы.ЗагрузитьРежимОтображенияПоКомпетенциям("ОтображениеПоКомпетенциямЗаявкаНаОбучениеРазвитие", Элементы.ПоКомпетенциям);
	ХарактеристикиПерсоналаФормы.ЗагрузитьРежимОтображенияПоКомпетенциям("ОтображениеПоКомпетенциямТребуемыеЗаявкаНаВключениеВПланОбучения", Элементы.ПоКомпетенциямТребуемые);
	
	ХарактеристикиПерсоналаФормы.ЗаполнитьКартинкуИВидХарактеристикиТаблицыХарактеристик(Объект.ХарактеристикиПерсонала);
	ЗаполнитьДеревоТребуемыхХарактеристикНаСервере();
	
	// Установим надпись мероприятия.
	ЗаполнитьВторичныеРеквизитыМероприятия();
	// Устанавливаем заголовок статуса и команды формы.
	УстановитьСвойстваЭлементовФормы(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗаявку(НовыйСтатус, ИмяЭлементаФормыКоманды)
	
	ЗакрыватьФорму = ИмяЭлементаФормыКоманды = КомандаПоУмолчанию;
	// Записываем заявку, в случае успеха - закрываем.
	Если ЗаписатьЗаявкуНаСервере(НовыйСтатус, ЗакрыватьФорму) Тогда
		Модифицированность = Ложь;
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("ИзмененСтатусЗаявкиОбученияРазвития");
		Если ЗакрыватьФорму Тогда
			Закрыть();
		Иначе
			ПриПолученииДанныхНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик ответа на вопрос заполнения по мероприятию.
//
&НаКлиенте
Процедура МероприятиеПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоМероприятиюНаСервере();
		ОбучениеРазвитиеКлиент.РассчитатьСуммуРасходов(ЭтаФорма);
	КонецЕсли;

КонецПроцедуры

#Область УстановкаСвойствЭлементовФормы

// Устанавливает свойства реквизитов формы.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовФормы(Форма)
	
	УстановитьСтатусЗаголовокЗаявки(Форма);
	УстановитьДоступностьФормыЗаявки(Форма);
	УстановитьСвойстваКомандСтатусаЗаявки(Форма);
	
	УстановитьСвойстваЭлементовХарактеристикПерсонала(Форма);
	УстановитьСвойстваЭлементовТребуемыхХарактеристикПерсонала(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтатусЗаголовокЗаявки(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаСтатусаЗаявки",
		"ОтображатьЗаголовок",
		Форма.ОтображатьСтатус);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаСтатусаЗаявки",
		"Заголовок",
		Форма.СтатусНаименование);
	
КонецПроцедуры

// Устанавливает доступность формы заявки в зависимости от прав пользователей и в зависимости от статуса заявки.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьФормыЗаявки(Форма)

	ДоступностьФормы = Ложь;
	Если Форма.ДоступноСогласованиеПервогоУровня Тогда
		ДоступностьФормы = ДоступностьФормы
			ИЛИ Форма.СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.ПустаяСсылка")
			ИЛИ Форма.СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Рассматривается");
	КонецЕсли;
	Если Форма.ДоступноСогласованиеВторогоУровня Тогда
		ДоступностьФормы = ДоступностьФормы
			ИЛИ Форма.СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Отклонено")
			ИЛИ Форма.СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Рассматривается")
			ИЛИ Форма.СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Согласовано");
	КонецЕсли;
	
	ДоступностьФормы = ДоступностьФормы И НЕ Форма.ЗаявкаИсполнена И НЕ Форма.ЗаявкаОтклонена;
	
	Форма.ТолькоПросмотр = НЕ ДоступностьФормы;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваКомандСтатусаЗаявки(Форма)

	УстановитьНаименованияКоманд(Форма);
	УстановитьКомандуПоУмолчанию(Форма);
	УстановитьДоступностьКоманд(Форма);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКомандуПоУмолчанию(Форма)

	Форма.КомандаПоУмолчанию = "";
	Если Форма.ДоступноСогласованиеВторогоУровня Тогда
		Форма.КомандаПоУмолчанию = "ФормаСогласовать";
	ИначеЕсли Форма.ДоступноСогласованиеПервогоУровня Тогда
		Форма.КомандаПоУмолчанию = "ФормаНаправитьНаСогласование";
	КонецЕсли;

	Если ЗначениеЗаполнено(Форма.КомандаПоУмолчанию) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			Форма.КомандаПоУмолчанию,
			"КнопкаПоУмолчанию",
			Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНаименованияКоманд(Форма)

	// ФормаОтменитьСогласование - устанавливаем заголовок в зависимости от статуса.
	Если Форма.СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Отклонено") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ФормаОтменитьСогласование",
			"Заголовок",
			НСтр("ru = 'Отменить отклонение'"));
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ФормаОтменитьСогласование",
			"Заголовок",
			НСтр("ru = 'Отменить согласование'"));
	КонецЕсли;
		
	// ВернутьНаПодготовку	 -  - устанавливаем заголовок в зависимости от доступности роли.
	Если Форма.ДоступноСогласованиеВторогоУровня Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ВернутьНаПодготовку",
			"Заголовок",
			НСтр("ru = 'Вернуть на подготовку'"));
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы,
			"ВернутьНаПодготовку",
			"Заголовок",
			НСтр("ru = 'Отозвать'"));
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКоманд(Форма)

	ЭтотОбъект = Форма.Объект;
	
	СтатусыЗаявок = Новый СписокЗначений;
	СтатусыЗаявок.Добавить(Форма.СтатусЗаявки);
	
	// Доступность команд-статусов.
	ДоступностьНаправитьНаСогласование = (ОбучениеРазвитиеКлиентСервер.ЗаявкаДоступноНаправитьНаСогласование(СтатусыЗаявок) 
		ИЛИ Форма.КомандаПоУмолчанию = "ФормаНаправитьНаСогласование")
		И НЕ Форма.ЗаявкаИсполнена;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаНаправитьНаСогласование",
		"Доступность",
		ДоступностьНаправитьНаСогласование);
		
	ДоступностьСогласовать = (ОбучениеРазвитиеКлиентСервер.ЗаявкаДоступноСогласовать(СтатусыЗаявок) 
		ИЛИ Форма.КомандаПоУмолчанию = "ФормаСогласовать")
		И НЕ Форма.ЗаявкаИсполнена;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаСогласовать",
		"Доступность",
		ДоступностьСогласовать);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаОтменитьСогласование",
		"Доступность",
		(ОбучениеРазвитиеКлиентСервер.ЗаявкаДоступноОтменитьСогласование(СтатусыЗаявок)
		ИЛИ ОбучениеРазвитиеКлиентСервер.ЗаявкаДоступноОтменитьОтклонение(СтатусыЗаявок))
		И НЕ Форма.ЗаявкаИсполнена);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаОтклонить",
		"Доступность",
		ОбучениеРазвитиеКлиентСервер.ЗаявкаДоступноОтклонить(СтатусыЗаявок) И НЕ Форма.ЗаявкаИсполнена);
			
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаВернутьНаПодготовку",
		"Доступность",
		ОбучениеРазвитиеКлиентСервер.ЗаявкаДоступноВернутьНаПодготовку(СтатусыЗаявок) И НЕ Форма.ЗаявкаИсполнена);
		
	// Доступность ввода на основании.
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаДокументОбучениеРазвитиеСотрудниковСоздатьНаОсновании",
		"Доступность",
		ЭтотОбъект.Статус = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Согласовано")
		И НЕ Форма.ТолькоПросмотр) ;
		
КонецПроцедуры

#КонецОбласти

// Проверяет заполнение, устанавливает заявке новый статус и записывает.
&НаСервере
Функция ЗаписатьЗаявкуНаСервере(НовыйСтатус, ЗакрыватьФорму)
	
	РезультатЗаписи = ОбучениеРазвитие.ЗаписатьЗаявкуНаСервере(РеквизитФормыВЗначение("Объект"), НовыйСтатус);
	Если РезультатЗаписи.Записана И РезультатЗаписи.Свойство("Ссылка") И ЗначениеЗаполнено(РезультатЗаписи.Ссылка) Тогда
		ДокументОбъект = РезультатЗаписи.Ссылка.ПолучитьОбъект();
		ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	КонецЕсли;
	
	Возврат РезультатЗаписи.Записана;
	
КонецФункции

// Возвращает адрес во временном хранилище массива уже подобранных сотрудников.
//
&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	СписокСотрудников = Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник");
	
	Возврат ПоместитьВоВременноеХранилище(СписокСотрудников, УникальныйИдентификатор);
	
КонецФункции

// Заполняет заявку на основании мероприятия.
//
&НаСервере
Процедура ЗаполнитьПоМероприятиюНаСервере()
	
	Если НЕ ЗначениеЗаполнено(Объект.Мероприятие) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Заполнить(Объект.Мероприятие);
	ЗначениеВРеквизитФормы(ДокументОбъект,"Объект");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСтатусЗаявки()

	СтруктураСтатусЗаявки = ОбучениеРазвитие.СтатусЗаявкиНаОбучение(Объект.Ссылка);
	
	Если СтруктураСтатусЗаявки = Неопределено Тогда
		СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.ПустаяСсылка");
		СтатусНаименование = "Готовится";
		ЗаявкаИсполнена = Ложь;
		ОтображатьСтатус = Ложь;
	Иначе	
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураСтатусЗаявки, "СтатусНаименование, ОтображатьСтатус");
		СтатусЗаявки = СтруктураСтатусЗаявки.Статус;
		ЗаявкаИсполнена = СтруктураСтатусЗаявки.ВключенаВОбучение;
	КонецЕсли;
	// Определяем статусы заявок.
	ЗаявкаОтклонена = СтатусЗаявки = ПредопределенноеЗначение("Перечисление.СостоянияСогласования.Отклонено");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВторичныеРеквизитыМероприятия()
	
	ИнфоНадписьМероприятия = ОбучениеРазвитие.ИнфоНадписьМероприятия(Объект.Мероприятие);
	
	ХарактеристикиПерсоналаФормы.ЗаполнитьВторичнуюТаблицуХарактеристикИзМероприятия(ХарактеристикиПерсонала, Объект.Мероприятие);
	ХарактеристикиПерсоналаФормы.ЗаполнитьКартинкуИВидХарактеристикиТаблицыХарактеристик(ХарактеристикиПерсонала);
	ЗаполнитьДеревоХарактеристикНаСервере();
	
КонецПроцедуры

// Проверяет наличие данных в реквизитах, предназначенных для заполнения.
&НаКлиенте
Функция РеквизитыКЗаполнениюЗаняты(Режим)

	Если Режим = "ПодобратьИзПлана" Тогда
	 
		Возврат ЗначениеЗаполнено(Объект.ДатаНачала)
			ИЛИ ЗначениеЗаполнено(Объект.ДатаОкончания)
			ИЛИ Объект.Сотрудники.Количество() > 0
			ИЛИ Объект.Расходы.Количество() > 0;
			
			
	ИначеЕсли Режим = "ВыборМероприятия" Тогда
		
		Возврат Объект.Расходы.Количество() > 0;
			
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПодобратьИзПланаЗавершение(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПодобратьИзПланаНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзПланаНаКлиенте()

	ПараметрыФормы = Новый Структура("РежимВыбора, ЗакрыватьПриВыборе", Истина, Истина); 
	
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораКурсаИзПлана",ЭтаФорма);
	ОткрытьФорму("Документ.ПланОбученияРазвития.Форма.ФормаПодбораИзПланаОбучения", ПараметрыФормы,ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораКурсаИзПлана(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		
		ЗаполнитьПоОснованиюНаСервере(РезультатВыбора);
		УстановитьСвойстваЭлементовФормы(ЭтаФорма);
		Модифицированность = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюНаСервере(ДанныеЗаполнения)

	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Заполнить(ДанныеЗаполнения);
	ЗначениеВРеквизитФормы(ДокументОбъект,"Объект");
	
	ЗаполнитьВторичныеРеквизитыМероприятия();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоХарактеристикНаСервере()

	ХарактеристикиПерсоналаФормы.СохранитьРежимОтображенияПоКомпетенциям("ОтображениеПоКомпетенциямЗаявкаНаОбучениеРазвитие", Элементы.ПоКомпетенциям);
	
	Если НЕ Элементы.ПоКомпетенциям.Пометка Тогда
		Возврат;
	КонецЕсли;
	
	ХарактеристикиДерево = РеквизитФормыВЗначение("ДеревоХарактеристик");
	ХарактеристикиПерсоналаФормы.ЗаполнитьДеревоХарактеристик(ХарактеристикиПерсонала, ХарактеристикиДерево);
	ЗначениеВРеквизитФормы(ХарактеристикиДерево, "ДеревоХарактеристик");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоТребуемыхХарактеристикНаСервере()

	ХарактеристикиПерсоналаФормы.СохранитьРежимОтображенияПоКомпетенциям("ОтображениеПоКомпетенциямТребуемыеЗаявкаНаВключениеВПланОбучения", Элементы.ПоКомпетенциям);
	
	Если НЕ Элементы.ПоКомпетенциямТребуемые.Пометка Тогда
		Возврат;
	КонецЕсли;
	
	ХарактеристикиДерево = РеквизитФормыВЗначение("ДеревоТребуемыхХарактеристик");
	ХарактеристикиПерсоналаФормы.ЗаполнитьДеревоХарактеристик(Объект.ХарактеристикиПерсонала, ХарактеристикиДерево);
	ЗначениеВРеквизитФормы(ХарактеристикиДерево, "ДеревоТребуемыхХарактеристик");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовТребуемыхХарактеристикПерсонала(Форма)

	ХарактеристикиПерсоналаКлиентСервер.УстановитьВидимостьГруппКомандВКоманднойПанелиХарактеристик(
		Форма, Форма.Элементы.ПоКомпетенциямТребуемые, "КоманднаяПанельТаблицыТребуемых", "КоманднаяПанельТребуемогоДерева");
	ХарактеристикиПерсоналаКлиентСервер.УстановитьДоступностьКомандПанелиХарактеристикПерсонала(
		Форма, Форма.Элементы.ПоКомпетенциямТребуемые);
		
	ХарактеристикиПерсоналаКлиентСервер.УстановитьВидимостьГруппХарактеристикПерсонала(
		Форма, Форма.Элементы.ПоКомпетенциямТребуемые, "ТаблицаТребуемыхХарактеристикГруппа", "ДеревоТребуемыхХарактеристикГруппа");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовХарактеристикПерсонала(Форма)

	ХарактеристикиПерсоналаКлиентСервер.УстановитьВидимостьГруппКомандВКоманднойПанелиХарактеристик(
		Форма, Форма.Элементы.ПоКомпетенциям);
	ХарактеристикиПерсоналаКлиентСервер.УстановитьВидимостьГруппХарактеристикПерсонала(
		Форма, Форма.Элементы.ПоКомпетенциям);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьХарактеристикиПерсоналаНаСервере(НовыеХарактеристики, ДополнительныеПараметры) Экспорт
	ХарактеристикиПерсоналаФормы.ДобавитьХарактеристикиВТабличнуюЧасть(ЭтаФорма, НовыеХарактеристики, ДополнительныеПараметры, "Объект.ХарактеристикиПерсонала");
КонецПроцедуры

#КонецОбласти 
