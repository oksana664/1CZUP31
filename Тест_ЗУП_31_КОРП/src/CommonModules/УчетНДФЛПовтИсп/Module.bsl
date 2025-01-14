
#Область СлужебныеПроцедурыИФункции

Функция КодыДоходовПоЦеннымБумагам(НалоговыйПериод) Экспорт
	
	СтрокаКодовДоходовПоЦеннымБумагам = "1010,1110,1120,1530,1531,1532,1533,1535,1536,1537,1538,1539,1540,1541,1543,1544,1545,1546,1547,1548,1549,1551,1552,1553,1554,2640,2641,2800";

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыДоходовНДФЛ.Ссылка
	|ИЗ
	|	Справочник.ВидыДоходовНДФЛ КАК ВидыДоходовНДФЛ
	|ГДЕ
	|	ВидыДоходовНДФЛ.КодПрименяемыйВНалоговойОтчетностиС2010Года В(&КодыДоходов)";
	Запрос.УстановитьПараметр("КодыДоходов", СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаКодовДоходовПоЦеннымБумагам));
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")
	
КонецФункции

Функция КодВычетаДляНалоговойОтчетности(НалоговыйПериод, КодВычета) Экспорт

	КодыДляНалоговойОтчетности = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КодВычета, "КодПрименяемыйВНалоговойОтчетностиС2016Года,КодПрименяемыйВНалоговойОтчетностиС2015Года,КодПрименяемыйВНалоговойОтчетностиС2011Года,КодПрименяемыйВНалоговойОтчетностиС2010Года");	
	Если НалоговыйПериод < 2011 Тогда
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2010Года
	ИначеЕсли НалоговыйПериод < 2015 Тогда
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2011Года
	ИначеЕсли НалоговыйПериод = 2015 Тогда
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2015Года
	Иначе
		Возврат КодыДляНалоговойОтчетности.КодПрименяемыйВНалоговойОтчетностиС2016Года
	КонецЕсли;
	
КонецФункции 

Функция ГруппаВычета(КодВычета) Экспорт

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КодВычета, "ГруппаВычета"); 
	
КонецФункции 

Функция КатегорияДоходаПоЕгоКоду(КодДоходаНДФЛ) Экспорт
	
	Если Не ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
		Возврат Перечисления.КатегорииДоходовНДФЛ.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", КодДоходаНДФЛ);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(РедактируемыеРеквизитыКодаДоходаНДФЛ.СоответствуетОплатеТруда, ВидыДоходовНДФЛ.СоответствуетОплатеТруда) КАК СоответствуетОплатеТруда,
	|	ВидыДоходовНДФЛ.КодПрименяемыйВНалоговойОтчетностиС2010Года КАК Код
	|ИЗ
	|	Справочник.ВидыДоходовНДФЛ КАК ВидыДоходовНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РедактируемыеРеквизитыКодаДоходаНДФЛ КАК РедактируемыеРеквизитыКодаДоходаНДФЛ
	|		ПО ВидыДоходовНДФЛ.Ссылка = РедактируемыеРеквизитыКодаДоходаНДФЛ.КодДохода
	|ГДЕ
	|	ВидыДоходовНДФЛ.Ссылка = &Ссылка";
	
	СтрокаОписанияДохода = Запрос.Выполнить().Выгрузить()[0];
	Если СтрокаОписанияДохода.СоответствуетОплатеТруда Тогда
		Возврат Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда;
	ИначеЕсли КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2530 Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2791 Тогда
		Возврат Перечисления.КатегорииДоходовНДФЛ.ДоходВНатуральнойФормеОтТрудовойДеятельности;
	ИначеЕсли КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2510
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2520
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2610
		Или СтрокаОписанияДохода.Код = "2620"
		Или СтрокаОписанияДохода.Код = "2630"
		Или СтрокаОписанияДохода.Код = "2640"
		Или СтрокаОписанияДохода.Код = "2641"
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2720 Тогда
		Возврат Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы;
	ИначеЕсли КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.КодДоходаПоУмолчанию
		Или СтрокаОписанияДохода.Код = "2001"
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2002
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2003
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2010
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2013
		Или КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код2014
		Или СтрокаОписанияДохода.Код = "2012"
		Или СтрокаОписанияДохода.Код = "2300" Тогда
		Возврат Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности;
	ИначеЕсли КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.Код1010 Тогда
		Возврат Перечисления.КатегорииДоходовНДФЛ.Дивиденды;
	Иначе
		Возврат Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходы;
	КонецЕсли;

КонецФункции

#КонецОбласти
