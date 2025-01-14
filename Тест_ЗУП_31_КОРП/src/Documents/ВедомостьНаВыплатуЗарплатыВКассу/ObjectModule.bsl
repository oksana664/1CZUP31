#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВзаиморасчетыССотрудниками.ВедомостьПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВзаиморасчетыССотрудниками.ВедомостьОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает в ведомости переданную зарплату физических лиц
//
// Параметры:
//  ЗарплатаРаботников - ТаблицаЗначений - таблица значений с колонками:
//		* ФизическоеЛицо - СправочникСсылка.ФизическиеЛица
//		* Сумма - Число
//
Процедура УстановитьЗарплатуРаботников(ЗарплатаРаботников) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьУстановитьЗарплатуРаботников(ЭтотОбъект, ЗарплатаРаботников)
КонецПроцедуры

// Возвращает структуру параметров для ограничения регистрации объекта при обмене.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Зарплата", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	Возврат ВзаиморасчетыССотрудниками.ВедомостьМожноЗаполнитьЗарплату(ЭтотОбъект)
КонецФункции

Процедура ЗаполнитьЗарплату() Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьЗаполнитьЗарплату(ЭтотОбъект);
КонецПроцедуры	

Процедура ДополнитьЗарплату(ФизическиеЛица) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьДополнитьЗарплату(ЭтотОбъект, ФизическиеЛица);
КонецПроцедуры	

Процедура ОчиститьЗарплату() Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьОчиститьЗарплату(ЭтотОбъект);
КонецПроцедуры	

#КонецОбласти

Функция МестоВыплаты() Экспорт
	Возврат ВзаиморасчетыССотрудниками.ВедомостьВКассуМестоВыплаты(ЭтотОбъект)
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьВКассуУстановитьМестоВыплаты(ЭтотОбъект, Значение)
КонецПроцедуры

Процедура ЗаполнитьПоТаблицеЗарплат(ТаблицаЗарплат) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьЗаполнитьПоТаблицеЗарплат(ЭтотОбъект, ТаблицаЗарплат);
КонецПроцедуры

Процедура ДополнитьПоТаблицеЗарплат(ТаблицаЗарплат) Экспорт
	ВзаиморасчетыССотрудниками.ВедомостьДополнитьПоТаблицеЗарплат(ЭтотОбъект, ТаблицаЗарплат)
КонецПроцедуры

#КонецОбласти

#КонецЕсли