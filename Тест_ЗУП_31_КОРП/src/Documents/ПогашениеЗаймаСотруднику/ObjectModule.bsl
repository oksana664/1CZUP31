#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ЗаймыСотрудникамВХО.УточнятьФормуРасчетовПриВыдачеПогашенииЗайма(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ФормаРасчетов");
	КонецЕсли;
	
	ОстатокЗадолженности = ЗаймыСотрудникам.ОстатокЗадолженности(ДоговорЗайма, КонецДня(Дата) - 1, Ссылка);
	Если Сумма > ОстатокЗадолженности.ОбщаяСумма Тогда
		ТекстСообщения = НСтр("ru = 'Остаток задолженности на %1 составляет %2 руб. Погашенная сумма не может быть больше суммы задолженности.'");
	    ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(Дата, "ДЛФ=ДД"), ОстатокЗадолженности.ОбщаяСумма);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Сумма", "Объект", Отказ);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, 
			ЗаймыСотрудникам.ДанныеЗаполненияДокументаПоСотруднику(ДанныеЗаполнения));
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ДоговорЗаймаСотруднику") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, 
			ЗаймыСотрудникам.ДанныеЗаполненияДокументаПоДоговоруЗайма(ДанныеЗаполнения));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДоговорЗайма) Тогда		
		
		ДействующиеДоговоры = ЗаймыСотрудникам.ДействующиеДоговорыЗаймаПоФизическомуЛицу(Организация, ФизическоеЛицо, Дата);
		
		Если ДействующиеДоговоры <> Неопределено И ДействующиеДоговоры.Количество() = 1 Тогда
			ДоговорЗайма = ДействующиеДоговоры[0];
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗаймыСотрудникам.ЗарегистрироватьПогашениеЗайма(Движения, ДоговорЗайма, Сумма, Дата, Организация, ФизическоеЛицо, Ссылка, Отказ);
	
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
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическомуЛицу(ЭтотОбъект, Организация, ФизическоеЛицо, Дата);
КонецФункции

#КонецОбласти

#КонецЕсли