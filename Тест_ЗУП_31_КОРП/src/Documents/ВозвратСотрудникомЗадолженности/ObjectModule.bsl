#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки.
	СуммаДокумента = Задолженности.Итог("Сумма");

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РазрезыВзаиморасчетов = "Сотрудник, Подразделение, СтатьяФинансирования, СтатьяРасходов";
	Взаиморасчеты = Движения.ВзаиморасчетыССотрудниками.ВыгрузитьКолонки(РазрезыВзаиморасчетов +", "+ "СуммаВзаиморасчетов");
	
	Для Каждого Задолженность Из Задолженности Цикл
		
		ЗарплатаКВыплате = Движения.ЗарплатаКВыплате.ДобавитьРасход();
		ЗарплатаКВыплате.Период = ПериодРегистрации;
		ЗаполнитьЗначенияСвойств(ЗарплатаКВыплате, ЭтотОбъект, "Организация, ФизическоеЛицо");
		ЗаполнитьЗначенияСвойств(ЗарплатаКВыплате, Задолженность);
		ЗарплатаКВыплате.СуммаКВыплате = - Задолженность.Сумма;
		
		Взаиморасчет = Взаиморасчеты.Добавить();
		ЗаполнитьЗначенияСвойств(Взаиморасчет, Задолженность);
		Взаиморасчет.СуммаВзаиморасчетов = - Задолженность.Сумма;
			
	КонецЦикла;
	
	Взаиморасчеты.Свернуть(РазрезыВзаиморасчетов, "СуммаВзаиморасчетов");
	Для Каждого Взаиморасчет Из Взаиморасчеты Цикл
		Запись = Движения.ВзаиморасчетыССотрудниками.ДобавитьРасход();
		Запись.Период = ПериодРегистрации;
		ЗаполнитьЗначенияСвойств(Запись, ЭтотОбъект, "Организация, ФизическоеЛицо");
		ЗаполнитьЗначенияСвойств(Запись, Взаиморасчет);
		Запись.ВидВзаиморасчетов				= Перечисления.ВидыВзаиморасчетовССотрудниками.ПогашениеЗадолженностиПоЗарплате;
		Запись.ГруппаНачисленияУдержанияВыплаты	= Перечисления.ГруппыНачисленияУдержанияВыплаты.Выплачено;
		
		ЗаписьБух = Движения.БухгалтерскиеВзаиморасчетыССотрудниками.ДобавитьРасход();
		ЗаполнитьЗначенияСвойств(ЗаписьБух, Запись);
		ЗаписьБух.Период = Дата;
	КонецЦикла;	

	Движения.ЗарплатаКВыплате.Записывать = Истина;
	Движения.ВзаиморасчетыССотрудниками.Записывать = Истина;
	Движения.БухгалтерскиеВзаиморасчетыССотрудниками.Записывать = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода 				= '00010101';
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= КонецМесяца(ПериодРегистрации);
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоТрудовымДоговорам	= Истина;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 		= Истина;
	
	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект")
	);
	
	Если Задолженности.Итог("Сумма") < 0 Тогда
		ТекстСообщения = НСтр("ru = 'Сумма возвращаемой задолженности должна быть положительной.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , , Отказ);
		
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
	МассивПараметров.Добавить(Новый Структура("Задолженности", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура Автозаполнение() Экспорт

	ПравилаПроверки = Новый Структура;
	ПравилаПроверки.Вставить("ПериодРегистрации",	НСтр("ru='Не указан месяц платежа'"));
	ПравилаПроверки.Вставить("Организация",			НСтр("ru='Не выбрана организация'"));
	ПравилаПроверки.Вставить("ФизическоеЛицо", 		НСтр("ru='Для заполнения документа необходимо указать сотрудника'"));

	Если ЗарплатаКадрыКлиентСервер.СвойстваЗаполнены(ЭтотОбъект, ПравилаПроверки, Истина) Тогда
		
		ЗадолженностиРаботника = ЗадолженностиРаботника(Ссылка, Организация, ФизическоеЛицо, КонецМесяца(ПериодРегистрации));
		Если ЗадолженностиРаботника.Итог("Сумма") > 0 Тогда
			Задолженности.Загрузить(ЗадолженностиРаботника);
		Иначе	
			Задолженности.Очистить();
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры //  Автозаполнение

Функция ЗадолженностиРаботника(Регистратор, Организация, ФизическоеЛицо, ДатаАктуальности)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор",		Регистратор);
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("ФизическоеЛицо",		ФизическоеЛицо);
	Запрос.УстановитьПараметр("ДатаАктуальности",	ДатаАктуальности);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Остатки.Сотрудник,
	|	Остатки.ПериодВзаиморасчетов,
	|	Остатки.Подразделение,
	|	Остатки.СтатьяФинансирования,
	|	Остатки.СтатьяРасходов,
	|	Остатки.ДокументОснование,
	|	-СУММА(Остатки.Сумма) КАК Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|		ЗарплатаКВыплатеОстатки.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|		ЗарплатаКВыплатеОстатки.Подразделение КАК Подразделение,
	|		ЗарплатаКВыплатеОстатки.ДокументОснование КАК ДокументОснование,
	|		ЗарплатаКВыплатеОстатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|		ЗарплатаКВыплатеОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|		ЗарплатаКВыплатеОстатки.СуммаКВыплатеОстаток КАК Сумма
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплате.Остатки(
	|				&ДатаАктуальности,
	|				Организация = &Организация
	|					И ФизическоеЛицо = &ФизическоеЛицо) КАК ЗарплатаКВыплатеОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗарплатаКВыплате.Сотрудник,
	|		ЗарплатаКВыплате.ПериодВзаиморасчетов,
	|		ЗарплатаКВыплате.Подразделение,
	|		ЗарплатаКВыплате.ДокументОснование,
	|		ЗарплатаКВыплате.СтатьяФинансирования,
	|		ЗарплатаКВыплате.СтатьяРасходов,
	|		ЗарплатаКВыплате.СуммаКВыплате
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|	ГДЕ
	|		ЗарплатаКВыплате.Регистратор = &Регистратор
	|		И ЗарплатаКВыплате.Период <= &ДатаАктуальности
	|		И ЗарплатаКВыплате.Организация = &Организация
	|		И ЗарплатаКВыплате.ФизическоеЛицо = &ФизическоеЛицо) КАК Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Сотрудник,
	|	Остатки.ПериодВзаиморасчетов,
	|	Остатки.Подразделение,
	|	Остатки.СтатьяФинансирования,
	|	Остатки.СтатьяРасходов,
	|	Остатки.ДокументОснование
	|
	|ИМЕЮЩИЕ
	|	СУММА(Остатки.Сумма) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Остатки.Сотрудник,
	|	Остатки.ПериодВзаиморасчетов,
	|	Остатки.Подразделение,
	|	Остатки.СтатьяФинансирования,
	|	Остатки.СтатьяРасходов,
	|	Остатки.ДокументОснование";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции	

#КонецОбласти

#КонецЕсли