#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения.СведенияОДоходах, Истина, Истина);
	УчетСтраховыхВзносов.СформироватьИсчисленныеВзносы(Движения, Отказ, Организация, КонецМесяца(ПериодРегистрации), ДанныеДляПроведения.СтраховыеВзносы, , , Истина, ОснованиеДляДоначисления);
	УчетСтраховыхВзносов.СформироватьСтраховыеВзносыПоФизическимЛицам(Движения, Отказ, Организация, ПериодРегистрации, Ссылка, ДанныеДляПроведения.СтраховыеВзносы);
	
	ДанныеДляПроведения = ОтражениеЗарплатыВУчете.НоваяСтруктураРезультатыРасчетаЗарплаты();
	ДанныеДляПроведения.СтраховыеВзносы = Движения.СтраховыеВзносыПоФизическимЛицам.Выгрузить();
	СтрокаСписокТаблиц = "НачисленнаяЗарплатаИВзносы";
	ОтражениеЗарплатыВБухучете.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, НачалоМесяца(ПериодРегистрации), ДанныеДляПроведения, СтрокаСписокТаблиц);
	
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
	МассивПараметров.Добавить(Новый Структура("Взносы", "ФизическоеЛицо"));
	МассивПараметров.Добавить(Новый Структура("СведенияОДоходах", "ФизическоеЛицо"));
	МассивПараметров.Добавить(Новый Структура("ФизическиеЛица", "ФизическоеЛицо"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическимЛицам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеОДоходах.ФизическоеЛицо,
	|	ДанныеОДоходах.МесяцРасчетногоПериода КАК ДатаПолученияДохода,
	|	ДанныеОДоходах.ВидДохода,
	|	СУММА(ДанныеОДоходах.Сумма) КАК Сумма,
	|	СУММА(ДанныеОДоходах.Скидка) КАК Скидка,
	|	ДанныеОДоходах.ОблагаетсяЕНВД,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуЛетчикам,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуШахтерам,
	|	ДанныеОДоходах.ЯвляетсяДоходомФармацевта,
	|	ДанныеОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	ДанныеОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	ДанныеОДоходах.КлассУсловийТруда
	|ИЗ
	|	Документ.АктПроверкиСтраховыхВзносов.СведенияОДоходах КАК ДанныеОДоходах
	|ГДЕ
	|	ДанныеОДоходах.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОДоходах.ВидДохода,
	|	ДанныеОДоходах.ФизическоеЛицо,
	|	ДанныеОДоходах.ОблагаетсяЕНВД,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуЛетчикам,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуШахтерам,
	|	ДанныеОДоходах.ЯвляетсяДоходомФармацевта,
	|	ДанныеОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	ДанныеОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	ДанныеОДоходах.КлассУсловийТруда,
	|	ДанныеОДоходах.МесяцРасчетногоПериода";
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("СведенияОДоходах", Запрос.Выполнить().Выгрузить());
	ДанныеДляПроведения.Вставить("СтраховыеВзносы", УчетСтраховыхВзносов.ДанныеОВзносахИзДокумента(Ссылка,,,,Истина, "МесяцРасчетногоПериода"));
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли