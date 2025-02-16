
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Переводит указанные заявки в состояние «Согласована»
// 
// Параметры
//	Заявки — массив значений типа ДокументСсылка.ЗаявкаНаПодборПерсонала.
//
Процедура СогласоватьЗаявки(Заявки) Экспорт
	
	Для Каждого Заявка Из Заявки Цикл
		УстановитьРешениеПоЗаявке(Заявка, Перечисления.СостоянияСогласования.Согласовано, Истина);
	КонецЦикла;
	
КонецПроцедуры

// Переводит указанные заявки в состояние «Отклонена»
// 
// Параметры
//	Заявки — массив значений типа ДокументСсылка.ЗаявкаНаПодборПерсонала.
//
Процедура ОтклонитьЗаявки(Заявки) Экспорт
	
	Для Каждого Заявка Из Заявки Цикл
		УстановитьРешениеПоЗаявке(Заявка, Перечисления.СостоянияСогласования.Отклонено);
	КонецЦикла;
	
КонецПроцедуры

// Формирует структуру с данными документа по его ссылке.
//
Функция ДанныеЗаявкиНаПодборПерсонала(ДокументСсылка) Экспорт
	
	ДанныеЗаявки = Новый Структура(
		"Позиция,
		|Подразделение,
		|Должность,
		|ПрофильДолжности,
		|Требования,
		|Обязанности,
		|Условия,
		|ПредполагаемыйДоход,
		|ПланируемаяДатаЗакрытия,
		|Приоритет,
		|ПричинаОткрытия,
		|Состояние,
		|Рассмотрел,
		|ДатаРассмотрения,
		|ХарактеристикиПерсонала,
		|ДействияСотрудников,
		|ЭтапыРаботыСКандидатами,
		|СпособНабора,
		|НазначениеНабора,
		|Ответственный,
		|Комментарий");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЗаявкаНаПодборПерсонала.Ссылка,
		|	ЗаявкаНаПодборПерсонала.Позиция,
		|	ЗаявкаНаПодборПерсонала.Подразделение,
		|	ЗаявкаНаПодборПерсонала.Должность,
		|	ЗаявкаНаПодборПерсонала.ПрофильДолжности,
		|	ЗаявкаНаПодборПерсонала.Требования,
		|	ЗаявкаНаПодборПерсонала.Обязанности,
		|	ЗаявкаНаПодборПерсонала.Условия,
		|	ЗаявкаНаПодборПерсонала.ПредполагаемыйДоход,
		|	ЗаявкаНаПодборПерсонала.ПланируемаяДатаЗакрытия,
		|	ЗаявкаНаПодборПерсонала.Приоритет,
		|	ЗаявкаНаПодборПерсонала.ПричинаОткрытия,
		|	ЗаявкаНаПодборПерсонала.Состояние,
		|	ЗаявкаНаПодборПерсонала.Рассмотрел,
		|	ЗаявкаНаПодборПерсонала.ДатаРассмотрения,
		|	ЗаявкаНаПодборПерсонала.ХарактеристикиПерсонала.(
		|		Характеристика,
		|		Значение,
		|		Вес,
		|		ТребуетсяПроверка,
		|		ТребуетсяОбучение,
		|		ВесЗначения
		|	),
		|	ЗаявкаНаПодборПерсонала.ДействияСотрудников.(
		|		ДействиеСотрудника
		|	),
		|	ЗаявкаНаПодборПерсонала.ПрофильДолжности.ЭтапыРаботыСКандидатами.(
		|		ЭтапРаботы КАК ЭтапРаботы,
		|		ШаблонАнкеты КАК ШаблонАнкеты,
		|		Комментарий КАК Комментарий
		|	) КАК ЭтапыРаботыСКандидатами,
		|	ЗаявкаНаПодборПерсонала.СпособНабора,
		|	ЗаявкаНаПодборПерсонала.НазначениеНабора,
		|	ЗаявкаНаПодборПерсонала.Ответственный,
		|	ЗаявкаНаПодборПерсонала.Комментарий
		|ИЗ
		|	Документ.ЗаявкаНаПодборПерсонала КАК ЗаявкаНаПодборПерсонала
		|ГДЕ
		|	ЗаявкаНаПодборПерсонала.Ссылка = &ДокументСсылка");
		
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеЗаявки, Выборка,, "ХарактеристикиПерсонала, ДействияСотрудников");
	
	МассивХарактеристикиПерсонала = Новый Массив;
	ДействияСотрудников = Новый Массив;
	ЭтапыРаботыСКандидатами = Новый Массив;
	Если Выборка.Количество() > 0 Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронноеИнтервью") Тогда
			ВыборкаХарактеристикиПерсонала = Выборка.ХарактеристикиПерсонала.Выбрать();
			Пока ВыборкаХарактеристикиПерсонала.Следующий() Цикл
				СтруктураСтроки = Новый Структура(
					"Характеристика,
					|Значение,
					|Вес,
					|ТребуетсяПроверка,
					|ТребуетсяОбучение,
					|ВесЗначения");
				ЗаполнитьЗначенияСвойств(СтруктураСтроки, ВыборкаХарактеристикиПерсонала);
				МассивХарактеристикиПерсонала.Добавить(СтруктураСтроки);
			КонецЦикла;
			ВыборкаДействияСотрудников = Выборка.ДействияСотрудников.Выбрать();
			Пока ВыборкаДействияСотрудников.Следующий() Цикл
				СтруктураСтроки = Новый Структура("ДействиеСотрудника");
				ЗаполнитьЗначенияСвойств(СтруктураСтроки, ВыборкаДействияСотрудников);
				ДействияСотрудников.Добавить(СтруктураСтроки);
			КонецЦикла;
		КонецЕсли;
		ВыборкаЭтапыРаботыСКандидатами = Выборка.ЭтапыРаботыСКандидатами.Выбрать();
		Пока ВыборкаЭтапыРаботыСКандидатами.Следующий() Цикл
			СтруктураСтроки = Новый Структура(
				"ЭтапРаботы,
				|ШаблонАнкеты,
				|Комментарий");
			ЗаполнитьЗначенияСвойств(СтруктураСтроки, ВыборкаЭтапыРаботыСКандидатами);
			ЭтапыРаботыСКандидатами.Добавить(СтруктураСтроки);
		КонецЦикла;
	КонецЕсли;
	ДанныеЗаявки.ХарактеристикиПерсонала = МассивХарактеристикиПерсонала;
	ДанныеЗаявки.ДействияСотрудников = ДействияСотрудников;
	ДанныеЗаявки.ЭтапыРаботыСКандидатами = ЭтапыРаботыСКандидатами;
	
	Возврат ДанныеЗаявки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура УстановитьРешениеПоЗаявке(Заявка, Решение, ПроверятьЗаполнение = Ложь)
	
	ЗаявкаОбъект = Заявка.ПолучитьОбъект();
	
	Если ПроверятьЗаполнение Тогда
		Если Не ЗаявкаОбъект.ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаявкаОбъект.Состояние = Решение;
	ЗаявкаОбъект.Рассмотрел = Пользователи.ТекущийПользователь();
	ЗаявкаОбъект.ДатаРассмотрения = ТекущаяДатаСеанса();
	ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли