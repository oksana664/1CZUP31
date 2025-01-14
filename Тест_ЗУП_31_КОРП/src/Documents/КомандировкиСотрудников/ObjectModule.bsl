#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСвязанныеКомандировки(Отказ);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	 Для каждого Строка Из Сотрудники Цикл
		Если ЗначениеЗаполнено(Строка.ДатаНачала)
			И ЗначениеЗаполнено(Строка.ДатаОкончания)
			И Строка.ДатаОкончания < Строка.ДатаНачала Тогда
			НомерТекущейСтроки = Строка.НомерСтроки - 1;
	        ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Дата начала командировки не может быть меньше даты окончания.'"),,"Объект.Сотрудники[" + НомерТекущейСтроки + "].ДатаОкончания",, Отказ);
		КонецЕсли;
	 КонецЦикла;
КонецПроцедуры

Процедура ОбновитьСвязанныеКомандировки(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КомандировкиСотрудниковСотрудники.НомерСтроки
	|ИЗ
	|	Документ.КомандировкиСотрудников.Сотрудники КАК КомандировкиСотрудниковСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Командировка КАК КомандировкаДокументы
	|		ПО КомандировкиСотрудниковСотрудники.Командировка = КомандировкаДокументы.Ссылка
	|			И (КомандировкиСотрудниковСотрудники.Сотрудник <> КомандировкаДокументы.Сотрудник
	|				ИЛИ КомандировкиСотрудниковСотрудники.ФизическоеЛицо <> КомандировкаДокументы.ФизическоеЛицо
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДатаНачала <> КомандировкаДокументы.ДатаНачала
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДатаОкончания <> КомандировкаДокументы.ДатаОкончания
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДнейВПути <> КомандировкаДокументы.ДнейВПути
	|				ИЛИ КомандировкиСотрудниковСотрудники.ДатаНачала <> КомандировкаДокументы.ДатаНачалаСобытия
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.МестоНазначения КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.МестоНазначения КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.ОрганизацияНазначения КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.ОрганизацияНазначения КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.Цель КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.Цель КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.КомандировкаЗаСчетСредств КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.КомандировкаЗаСчетСредств КАК СТРОКА(100)))
	|				ИЛИ (ВЫРАЗИТЬ(КомандировкиСотрудниковСотрудники.Ссылка.Основание КАК СТРОКА(100))) <> (ВЫРАЗИТЬ(КомандировкаДокументы.Основание КАК СТРОКА(100))))
	|ГДЕ
	|	КомандировкиСотрудниковСотрудники.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбновитьСвязаннуюКомандировку(Сотрудники[Выборка.НомерСтроки -1], Отказ);
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСвязаннуюКомандировку(Строка, Отказ)
	
	Если Не ЗначениеЗаполнено(Строка) 
		Или Не ЗначениеЗаполнено(Строка.Командировка) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ДокументОбъект = Строка.Командировка.ПолучитьОбъект();
		Если НЕ (ДокументОбъект.Проведен И ДокументОбъект.ДокументРассчитан) Тогда
			ДокументОбъект.Сотрудник = Строка.Сотрудник;
			ДокументОбъект.ФизическоеЛицо = Строка.ФизическоеЛицо;
			ДокументОбъект.ДатаНачала = Строка.ДатаНачала;
			ДокументОбъект.ДатаОкончания = Строка.ДатаОкончания;
			ДокументОбъект.ДнейВПути = Строка.ДнейВПути;
			ДокументОбъект.ДатаНачалаСобытия = Строка.ДатаНачала;
		КонецЕсли;
		
		ДокументОбъект.МестоНазначения = Строка.МестоНазначения;
		ДокументОбъект.ОрганизацияНазначения = Строка.ОрганизацияНазначения;
		ДокументОбъект.Цель = Строка.Цель;
		ДокументОбъект.КомандировкаЗаСчетСредств = Строка.КомандировкаЗаСчетСредств;
		ДокументОбъект.Основание = Основание;
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		НомерТекущейСтроки = Строка.НомерСтроки - 1;
		ТекстСообщения = НСтр("ru = 'Не удалось обновить командировку %1.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.Командировка);
	    ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Сотрудники[" + НомерТекущейСтроки + "].Командировка" , , Отказ);
	КонецПопытки;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьИзОбучения" Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда 
				
				Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
				Модуль.ЗаполнитьКомандировкиСотрудниковИзДокументаОбучения(ЭтотОбъект, ДанныеЗаполнения);
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ДатаСобытия);
	
КонецФункции

#КонецОбласти

#КонецЕсли
