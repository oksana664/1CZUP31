
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		// Новая заявка.
		// Заполняем реквизиты значениями по умолчанию.
		ЗначенияДляЗаполнения = Новый Структура("Ответственный", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Объект.ПланируемаяДатаЗакрытия = ДобавитьМесяц(ТекущаяДатаСеанса(), 1);
		
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
	
	// Отобразим элементы в зависимости от функциональной опции.
	ИспользоватьЭлектронноеИнтервью = ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронноеИнтервью");
	Элементы.ГруппаФункцииТребованияКХарактеристикам.Видимость = ИспользоватьЭлектронноеИнтервью;
	Если ИспользоватьЭлектронноеИнтервью Тогда
		ХарактеристикиПерсоналаФормы.ПрочитатьХарактеристикиВТаблицы(Объект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);
	Иначе
		Элементы.ГруппаДанныеДляПубликацииВакансии.Поведение = ПоведениеОбычнойГруппы.Обычное;
		Элементы.ГруппаДанныеДляПубликацииВакансии.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаДанныеДляПубликацииВакансии.ОтображатьЗаголовок = Ложь;
	КонецЕсли;
	
	ДоступноДобавлениеИзменение = ПравоДоступа("Добавление", Метаданные.Документы.ЗаявкаНаПодборПерсонала);
	Если Не ДоступноДобавлениеИзменение Тогда
		Элементы.Характеристики.ТолькоПросмотр = Истина;
		Элементы.ХарактеристикиПерсоналаОткрытьПодборХарактеристикПерсонала.Доступность = Ложь;
		Элементы.ЗаполнитьИзПрофиля.Доступность = Ложь;
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбновитьСпособНабора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ХарактеристикиПерсоналаФормы.ПеренестиХарактеристикиВТабличнуюЧасть(ТекущийОбъект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ХарактеристикиПерсоналаФормы.ОбработкаПроверкиЗаполненияТабличныхЧастейХарактеристик(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

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
Процедура ЗаполнитьИзПрофиля(Команда)
	
	ДанныеПрофиля = ДанныеПрофиляДолжности(Объект.ПрофильДолжности);
	
	ДанныеПрофиляИзменены = (Не ПустаяСтрока(Объект.Требования) Или Не ПустаяСтрока(Объект.Обязанности) Или Не ПустаяСтрока(Объект.Условия)) 
			И (Объект.Требования <> ДанныеПрофиля.Требования Или Объект.Обязанности <> ДанныеПрофиля.Обязанности Или Объект.Условия <> ДанныеПрофиля.Условия);
	
	Если ИспользоватьЭлектронноеИнтервью Тогда
		Объект.ХарактеристикиПерсонала.Очистить();
		Для Каждого ТекущаяСтрока Из Характеристики Цикл
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Характеристика", ТекущаяСтрока.Характеристика);
			СтрокиЗначений = ЗначенияХарактеристики.НайтиСтроки(СтруктураПоиска);
			Для Каждого СтрокаЗначения Из СтрокиЗначений Цикл
				НоваяСтрока = Объект.ХарактеристикиПерсонала.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
				НоваяСтрока.Значение = СтрокаЗначения.Значение;
				НоваяСтрока.ВесЗначения = СтрокаЗначения.ВесЗначения;
			КонецЦикла;
		КонецЦикла;
		ДанныеПрофиляИзменены = ДанныеПрофиляИзменены
				ИЛИ ((Объект.ХарактеристикиПерсонала.Количество() <> 0 ИЛИ Объект.ДействияСотрудников.Количество() <> 0)
					И (НЕ ДанныеПрофиляСовпадают(Объект.ХарактеристикиПерсонала, ДанныеПрофиля.ХарактеристикиПерсонала)
						ИЛИ НЕ ДанныеПрофиляСовпадают(Объект.ДействияСотрудников, ДанныеПрофиля.ДействияСотрудников)));
		
		ТекстВопроса = НСтр("ru = 'Функции, требования к характеристикам и данные для публикации вакансии 
		                     |будут заменены описанием из профиля должности.
                             |Продолжить?'");
	Иначе
				
		ТекстВопроса = НСтр("ru = 'Требования, обязанности и условия работы будут заменены описанием из профиля должности.
                             |Продолжить?'");
	КонецЕсли;
		
	
	Если ДанныеПрофиляИзменены Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ВопросОЗаменыОписанияИзПрофиляЗавершение", ЭтотОбъект, ДанныеПрофиля), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОписаниеИзПрофиляДолжности(ДанныеПрофиля);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборХарактеристикПерсонала(Команда)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуПодбораХарактеристик(ЭтаФорма);
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

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ПозицияПриИзменении(Элемент)
	
	ДанныеПозиции = ДанныеПозицииШтатногоРасписания(Объект.Позиция);
	
	Объект.Подразделение = ДанныеПозиции.МестоВСтруктуреПредприятия;
	Объект.ПредполагаемыйДоход = ДанныеПозиции.ФОТ;
	Объект.Должность = ДанныеПозиции.Должность;
	
КонецПроцедуры

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
Процедура ХарактеристикиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	ХарактеристикиПерсоналаКлиент.ОткрытьФормуДобавленияХарактеристик(ЭтаФорма, Копирование, Отказ);
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	УстановитьПанельСведенийСогласования(ТекущийОбъект);
	
	ХарактеристикиПерсоналаФормы.ЗаполнитьКартинкуИВидХарактеристикиТаблицыХарактеристик(Характеристики);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПанельСведенийСогласования(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	СостоянияСогласования = Новый Массив;
	СостоянияСогласования.Добавить(Перечисления.СостоянияСогласования.Согласовано);
	СостоянияСогласования.Добавить(Перечисления.СостоянияСогласования.Отклонено);
	
	// Работа с заявкой пока не завершена — не отображаем панель согласования.
	Если СостоянияСогласования.Найти(ТекущийОбъект.Состояние) = Неопределено Тогда
		Элементы.СостояниеСогласованияГруппа.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Элементы.СостояниеСогласованияГруппа.Видимость = Истина;
	
	// Если открыта вакансия, то показываем еще и поле с вакансией.
	ОтборПоЗаявке = Новый Структура("Основание", ТекущийОбъект.Ссылка);
	Вакансии = Справочники.Вакансии.ВакансииПоОтбору(ОтборПоЗаявке);
	Если Вакансии.Количество() > 0 Тогда
		Вакансия = Вакансии[0];
	КонецЕсли;
	
	Элементы.Вакансия.Видимость = ЗначениеЗаполнено(Вакансия);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОЗаменыОписанияИзПрофиляЗавершение(РезультатВопроса, ДанныеПрофиля) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		// Пользователь отказался от замены описания из профиля.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОписаниеИзПрофиляДолжности(ДанныеПрофиля);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОписаниеИзПрофиляДолжности(ДанныеПрофиля)
	
	Если ИспользоватьЭлектронноеИнтервью Тогда
		
		Объект.ХарактеристикиПерсонала.Очистить();
		Для каждого ТекущаяСтрока Из ДанныеПрофиля.ХарактеристикиПерсонала Цикл
			НовСтрока = Объект.ХарактеристикиПерсонала.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, ТекущаяСтрока);	
		КонецЦикла;
		ПрочитатьХарактеристикиВТаблицы();
		
		Объект.ДействияСотрудников.Очистить();
		Для каждого ТекущаяСтрока Из ДанныеПрофиля.ДействияСотрудников Цикл
			НовСтрока = Объект.ДействияСотрудников.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, ТекущаяСтрока);
		КонецЦикла;
	КонецЕсли;	
	
	Объект.Требования = ДанныеПрофиля.Требования;
	Объект.Обязанности = ДанныеПрофиля.Обязанности;
	Объект.Условия = ДанныеПрофиля.Условия;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПрофиляДолжности(ПрофильДолжности)
	Возврат Справочники.ПрофилиДолжностей.ДанныеПрофиляДолжности(ПрофильДолжности);
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеПозицииШтатногоРасписания(Позиция)
	Возврат Справочники.ШтатноеРасписание.ДанныеПозицииШтатногоРасписания(Позиция);
КонецФункции

&НаКлиенте
Функция ДанныеПрофиляСовпадают(Знач ДанныеВакансии, Знач ДанныеПрофиля)
	
	Если ДанныеВакансии.Количество() <> ДанныеПрофиля.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИндексСтроки = 0;
	Для каждого ТекущаяСтрока Из ДанныеПрофиля Цикл
		Для каждого ТекущаяКолонка Из ТекущаяСтрока Цикл
			Если ДанныеВакансии[ИндексСтроки][ТекущаяКолонка.Ключ] <> ТекущаяСтрока[ТекущаяКолонка.Ключ] Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПрочитатьХарактеристикиВТаблицы()
	
	ХарактеристикиПерсоналаФормы.ПрочитатьХарактеристикиВТаблицы(Объект.ХарактеристикиПерсонала, Характеристики, ЗначенияХарактеристики);	
	
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

&НаСервере
Процедура ЗаполнитьДеревоДействийСотрудников(СписокДействий)
	
	ДеревоДействий = ЭлектронноеИнтервью.ДеревоДействийСотрудников(СписокДействий);
	
	ЗначениеВДанныеФормы(ДеревоДействий, ДействияСотрудниковДерево);
КонецПроцедуры

&НаКлиенте
Процедура СпособНабораПриИзменении(Элемент)
	ОбновитьСпособНабора();
КонецПроцедуры

&НаКлиенте
Процедура НазначениеНабораПозицияПриИзменении(Элемент)
	ОбновитьСпособНабора();
КонецПроцедуры

&НаКлиенте
Процедура НазначениеНабораДолжностьПодразделениеПриИзменении(Элемент)
	ОбновитьСпособНабора();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСпособНабора()
	
	ЭтоМассовая = Объект.СпособНабора = ПредопределенноеЗначение("Перечисление.СпособНабораПерсоналаНаВакансию.МассовыйНабор");
	
	Если НЕ ЭтоМассовая Тогда 
		Объект.НазначениеНабора = ПредопределенноеЗначение("Перечисление.НазначениеНабораПерсоналаНаВакансию.ПозицияШтатногоРасписания");
	КонецЕсли;
	
	НаПозицию = Объект.НазначениеНабора = ПредопределенноеЗначение("Перечисление.НазначениеНабораПерсоналаНаВакансию.ПозицияШтатногоРасписания");
	
	Если НаПозицию Тогда 
		
		Если ЗначениеЗаполнено(ПозицияПредыдущееЗначение) Тогда 
			Объект.Позиция = ПозицияПредыдущееЗначение;
			ПозицияПредыдущееЗначение = Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПричинаОткрытияПредыдущееЗначение) Тогда 
			Объект.ПричинаОткрытия = ПричинаОткрытияПредыдущееЗначение;
			ПричинаОткрытияПредыдущееЗначение = Неопределено;
		КонецЕсли;	
		
	Иначе 
		
		ПозицияПредыдущееЗначение = Объект.Позиция;
		Объект.Позиция = Неопределено;
		
		ПричинаОткрытияПредыдущееЗначение = Объект.ПричинаОткрытия;
		Объект.ПричинаОткрытия = Неопределено;
		
	КонецЕсли;
	
	Элементы.НазначениеНабораДолжностьПодразделение.ТолькоПросмотр = НЕ ЭтоМассовая;
	
	Элементы.Позиция.Доступность = НаПозицию;
	Элементы.ПричинаОткрытия.Доступность = НаПозицию;
	
	Элементы.Должность.ТолькоПросмотр = НаПозицию;
	Элементы.Подразделение.ТолькоПросмотр = НаПозицию;
	
КонецПроцедуры	

&НаКлиенте
Процедура ДолжностьПриИзменении(Элемент)
	ПодразделениеДолжностьПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПодразделениеДолжностьПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеДолжностьПриИзменении()
	
	Если ЗначениеЗаполнено(ПозицияПредыдущееЗначение) Тогда 
		
		ДанныеПозиции = ДанныеПозицииШтатногоРасписания(ПозицияПредыдущееЗначение);
		
		Если ДанныеПозиции.Должность <> Объект.Должность
			ИЛИ ДанныеПозиции.МестоВСтруктуреПредприятия <> Объект.Подразделение Тогда 
		
			ПозицияПредыдущееЗначение = Неопределено;
			ПричинаОткрытияПредыдущееЗначение = Неопределено;
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
