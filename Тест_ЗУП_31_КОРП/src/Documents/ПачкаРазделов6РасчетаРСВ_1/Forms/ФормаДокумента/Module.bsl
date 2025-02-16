#Область ОписаниеПеременных

&НаКлиенте
Перем НомерТекущейСтроиЗаписиОСтаже;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаписиОСтажеТекст = НСтр("ru = 'Записи о стаже'");
	ПерсонифицированныйУчетФормы.ДокументыКвартальнойОтчетностиПриСозданииНаСервере(ЭтаФорма, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения(), Ложь);
	Если Параметры.Ключ.Пустая() Тогда
		ПриПолученииДанныхНаСервере(РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.ПачкаРазделов6РасчетаРСВ_1")));
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПерсонифицированныйУчетФормы.ДокументыКвартальнойОтчетностиПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект, Ложь);
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбъектВДанныеФормы(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ПерсонифицированныйУчетКлиент.ДокументыКвартальнойОтчетностиПослеЗаписи(ЭтаФорма);
	Оповестить("Запись_ПачкаРазделов6РасчетаРСВ_1", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ТекущийОбъект = РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.ПачкаРазделов6РасчетаРСВ_1"));
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда 
		Отказ = Истина;
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Объект");
	
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
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(Объект.ОтчетныйПериод, ПериодСтрока, Направление, '20140101');		
КонецПроцедуры

&НаКлиенте
Процедура КорректируемыйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(Объект.КорректируемыйПериод, КорректируемыйПериодСтрока, Направление, '20140101');
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	ТипСведенийСЗВПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСотрудники

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	СотрудникиСотрудникПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Сотрудники.ТекущийЭлемент = Элементы.СотрудникиФизическоеЛицо
		И Не ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.Сотрудник) Тогда
		
		Возврат;
	КонецЕсли;	
		
	ОткрытьФормуРедактированияКарточкиДокумента();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда 
		ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВСтрокеТаблицы(ЭтотОбъект, Элементы.Сотрудники.ТекущиеДанные, ОписаниеКолонокЗаголовковТаблицыСотрудники());
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Оповещение = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуЗавершение", ЭтотОбъект, Команда);
	ПроверитьСЗапросомДальнейшегоДействия(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуЗавершение(Результат, Команда) Экспорт
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
Процедура КвартальнаяОтчетностьПФР(Команда)
	ПерсонифицированныйУчетКлиент.ОткрытьРабочееМестоКвартальнойОтчетности(Объект.Организация, Объект.ОтчетныйПериод, Комплект);
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ОчиститьСообщения();

	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	Если Не ТаблицаДополнена Тогда 
		ИменаТаблиц = Новый Массив;
		ИменаТаблиц.Добавить("Сотрудники");

		ПерсонифицированныйУчетФормы.ДобавитьЗаголовкиКПолямТаблицФормы(ЭтотОбъект, ИменаТаблиц, ОписаниеКолонокЗаголовковТаблицФормы());
		
		ТаблицаДополнена = Истина;
	КонецЕсли;	
	
	ПерсонифицированныйУчетФормы.ДокументыКвартальнойОтчетностиПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	
	КорректируемыйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.КорректируемыйПериод);

	ОбъектВДанныеФормы(ТекущийОбъект);
	
	УстановитьДоступностьПолейСтажаЗаработка(ЭтаФорма);
	
	УстановитьВидимостьПолейТаблицыСотрудники();
	
КонецПроцедуры

&НаСервере
Процедура ОбъектВДанныеФормы(ТекущийОбъект)
	СтрокиПоСотрудникам = Новый Соответствие;
	
	Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		СтрокиПоСотрудникам.Вставить(СтрокаСотрудник.Сотрудник, СтрокаСотрудник);	
	КонецЦикла;	
	
	Для Каждого СтрокаЗаработокДокумента Из ТекущийОбъект.СведенияОЗаработке Цикл 		
		СтрокаСотрудник = СтрокиПоСотрудникам[СтрокаЗаработокДокумента.Сотрудник];
		
		Если СтрокаСотрудник <> Неопределено
			И СтрокаЗаработокДокумента.Месяц <> 0 Тогда
			
			СтрокаСотрудник.Заработок = СтрокаСотрудник.Заработок + СтрокаЗаработокДокумента.Заработок;
			СтрокаСотрудник.ОблагаетсяВзносамиДоПредельнойВеличины = СтрокаСотрудник.ОблагаетсяВзносамиДоПредельнойВеличины + СтрокаЗаработокДокумента.ОблагаетсяВзносамиДоПредельнойВеличины;
			СтрокаСотрудник.ОблагаетсяВзносамиСвышеПредельнойВеличины = СтрокаСотрудник.ОблагаетсяВзносамиСвышеПредельнойВеличины + СтрокаЗаработокДокумента.ОблагаетсяВзносамиСвышеПредельнойВеличины;
			СтрокаСотрудник.ПоДоговорамГПХДоПредельнойВеличины = СтрокаСотрудник.ПоДоговорамГПХДоПредельнойВеличины + СтрокаЗаработокДокумента.ПоДоговорамГПХДоПредельнойВеличины;
		КонецЕсли;	
	КонецЦикла;	
	
	ПерсонифицированныйУчетКлиентСервер.УстановитьЗаголовкиВТаблице(ЭтотОбъект, Объект.Сотрудники, ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПолейСтажаЗаработка(Форма)	
	Форма.Элементы.РегистрационныйНомерПФРвКорректируемыйПериод.Доступность = Форма.Объект.ТипСведенийСЗВ <> ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ");
	Форма.Элементы.КорректируемыйПериод.Доступность = Форма.Объект.ТипСведенийСЗВ <> ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ");
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
    ЗапрашиваемыеЗначения.Вставить("Квартал", "Объект.ОтчетныйПериод");
	
	Возврат ЗапрашиваемыеЗначения;
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 	

&НаСервере
Процедура СотрудникиСотрудникПриИзмененииНаСервере()
	ПерсонифицированныйУчет.ДокументыСЗВСотрудникПриИзменении(Элементы.Сотрудники, Объект, ТекущийСотрудник, Истина);	
КонецПроцедуры	

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	Объект.Сотрудники.Очистить();
	Объект.СведенияОЗаработке.Очистить();
	Объект.ЗаписиОСтаже.Очистить();
	Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Очистить();
	Объект.КорректирующиеСведения.Очистить();
	ПерсонифицированныйУчетФормы.ОрганизацияПриИзменении(ЭтаФорма, ЗапрашиваемыеЗначенияЗаполненияПоОрганизации());
КонецПроцедуры

&НаСервере
Процедура ТипСведенийСЗВПриИзмененииНаСервере()
	ПерсонифицированныйУчетКлиентСервер.ДокументыСведенийОВзносахИСтажеУстановитьКорректируемыйПериод(ЭтаФорма);
	
	Если Объект.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Объект.КорректируемыйПериод = '20140101';
		КорректируемыйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.КорректируемыйПериод);
	КонецЕсли;
	
	УстановитьДоступностьПолейСтажаЗаработка(ЭтаФорма);
	
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		
		Объект.ЗаписиОСтаже.Очистить();
		Объект.СведенияОЗаработке.Очистить();
		Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Очистить();
		
		Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
			СтрокаСотрудник.НачисленоСтраховая = 0;		
		КонецЦикла;	
	КонецЕсли;	

	УстановитьВидимостьПолейТаблицыСотрудники();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияКарточкиДокумента()
	ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
	
	ДанныеШапкиТекущегоДокумента = Объект;
	
	Период = Объект.ОтчетныйПериод;
	
	Если ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ <> ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ") Тогда
		
		Период = ДанныеШапкиТекущегоДокумента.КорректируемыйПериод;
	КонецЕсли;	
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда	
		ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище();
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("АдресВоВременномХранилище", АдресДанныхТекущегоДокументаВХранилище);
		ПараметрыОткрытияФормы.Вставить("РедактируемыйДокументСсылка", ДанныеШапкиТекущегоДокумента.Ссылка);
		ПараметрыОткрытияФормы.Вставить("Сотрудник", ДанныеТекущейСтроки.Сотрудник);
		ПараметрыОткрытияФормы.Вставить("ТипСведенийСЗВ", ДанныеШапкиТекущегоДокумента.ТипСведенийСЗВ);
		ПараметрыОткрытияФормы.Вставить("Организация", ДанныеШапкиТекущегоДокумента.Организация);
		ПараметрыОткрытияФормы.Вставить("Период", Период);
		ПараметрыОткрытияФормы.Вставить("ИсходныйНомерСтроки", 0);
		ПараметрыОткрытияФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		ПараметрыОткрытияФормы.Вставить("НеОтображатьОшибки", Истина);
		
		ОткрытьФорму("Обработка.ПодготовкаКвартальнойОтчетностиВПФР.Форма.ФормаРедактированияРаздела6РСВ_1", ПараметрыОткрытияФормы, ЭтаФорма);	
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВоВременноеХранилище()
	Если Элементы.Сотрудники.ТекущаяСтрока = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;	
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено Тогда
		АдресДанныхТекущегоДокументаВХранилище = "";
		Возврат;
	КонецЕсли;
	
	ДанныеСотрудника = Новый Структура;
	ДанныеСотрудника.Вставить("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	ДанныеСотрудника.Вставить("СтраховойНомерПФР", ДанныеТекущейСтрокиПоСотруднику.СтраховойНомерПФР);
	ДанныеСотрудника.Вставить("Фамилия", ДанныеТекущейСтрокиПоСотруднику.Фамилия);
	ДанныеСотрудника.Вставить("Имя", ДанныеТекущейСтрокиПоСотруднику.Имя);
	ДанныеСотрудника.Вставить("Отчество", ДанныеТекущейСтрокиПоСотруднику.Отчество);
	ДанныеСотрудника.Вставить("СотрудникУволен", ДанныеТекущейСтрокиПоСотруднику.СотрудникУволен);
	ДанныеСотрудника.Вставить("НачисленоСтраховая", ДанныеТекущейСтрокиПоСотруднику.НачисленоСтраховая);
	ДанныеСотрудника.Вставить("УплаченоСтраховая", 0);
	ДанныеСотрудника.Вставить("НачисленоНакопительная", 0);
	ДанныеСотрудника.Вставить("УплаченоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоначисленоСтраховая", ДанныеТекущейСтрокиПоСотруднику.ДоначисленоСтраховая);
	ДанныеСотрудника.Вставить("ДоначисленоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоУплаченоНакопительная", 0);
	ДанныеСотрудника.Вставить("ДоУплаченоСтраховая", 0);
	ДанныеСотрудника.Вставить("ФиксНачисленныеВзносы", ДанныеТекущейСтрокиПоСотруднику.ФиксНачисленныеВзносы);
	ДанныеСотрудника.Вставить("ФиксУплаченныеВзносы", Ложь);
	ДанныеСотрудника.Вставить("ФиксСтаж", ДанныеТекущейСтрокиПоСотруднику.ФиксСтаж);
	ДанныеСотрудника.Вставить("ФиксЗаработок", ДанныеТекущейСтрокиПоСотруднику.ФиксЗаработок);
	ДанныеСотрудника.Вставить("СведенияОЗаработке", Новый Массив);
	ДанныеСотрудника.Вставить("СведенияОЗаработкеНаВредныхИТяжелыхРаботах", Новый Массив);
    ДанныеСотрудника.Вставить("ЗаписиОСтаже", Новый Массив);
	ДанныеСотрудника.Вставить("ИсходныйНомерСтроки", ДанныеТекущейСтрокиПоСотруднику.ИсходныйНомерСтроки);
	ДанныеСотрудника.Вставить("КорректирующиеСведения", Новый Массив);
	
	ЗначенияРеквизитовХраненияОшибок = ПерсонифицированныйУчетКлиентСервер.ЗначенияРеквизитовХраненияОшибокВСтруктуру(
											ЭтаФорма, 
											ДанныеТекущейСтрокиПоСотруднику,
											"Объект.Сотрудники");
											
	ДанныеСотрудника.Вставить("ЗначенияРеквизитовХраненияОшибок", ЗначенияРеквизитовХраненияОшибок);	
	
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	
	СтрокиСведенияОЗаработке = Объект.СведенияОЗаработке.НайтиСтроки(СтруктураПоиска);
		
	Для Каждого СтрокаЗаработок Из СтрокиСведенияОЗаработке Цикл
		СтруктураПолейСведенияОЗаработке = СтруктураПолейСведенияОЗаработке();
		ЗаполнитьЗначенияСвойств(СтруктураПолейСведенияОЗаработке, СтрокаЗаработок);
		СтруктураПолейСведенияОЗаработке.ИдентификаторИсходнойСтроки = СтрокаЗаработок.ПолучитьИдентификатор(); 
		
		ЗначенияРеквизитовХраненияОшибок = ПерсонифицированныйУчетКлиентСервер.ЗначенияРеквизитовХраненияОшибокВСтруктуру(
												ЭтаФорма, 
												СтрокаЗаработок,
												"Объект.СведенияОЗаработке");	
		
		ДанныеСотрудника.СведенияОЗаработке.Добавить(СтруктураПолейСведенияОЗаработке);
	КонецЦикла;	
	
	СтрокиСведенияОЗаработкеПоКлассамУсловий = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.НайтиСтроки(СтруктураПоиска);
		
	Для Каждого СтрокаЗаработок Из СтрокиСведенияОЗаработкеПоКлассамУсловий Цикл
		СтруктураПолейСведенияОЗаработке = СтруктураПолейСведенияОЗаработкеНаВредныхИТяжелыхРаботах();
		ЗаполнитьЗначенияСвойств(СтруктураПолейСведенияОЗаработке, СтрокаЗаработок);
		СтруктураПолейСведенияОЗаработке.ИдентификаторИсходнойСтроки = СтрокаЗаработок.ПолучитьИдентификатор(); 	
		
		ЗначенияРеквизитовХраненияОшибок = ПерсонифицированныйУчетКлиентСервер.ЗначенияРеквизитовХраненияОшибокВСтруктуру(
												ЭтаФорма, 
												СтрокаЗаработок,
												"Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах");	
		
		ДанныеСотрудника.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Добавить(СтруктураПолейСведенияОЗаработке);
	КонецЦикла;	
	
	СтрокиЗаписиОСтаже = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаСтаж Из СтрокиЗаписиОСтаже Цикл
		СтруктураПолейЗаписиОСтаже = СтруктураПолейЗаписиОСтаже();
		ЗаполнитьЗначенияСвойств(СтруктураПолейЗаписиОСтаже, СтрокаСтаж);
		СтруктураПолейЗаписиОСтаже.ИдентификаторИсходнойСтроки = СтрокаСтаж.ПолучитьИдентификатор(); 
		
		ЗначенияРеквизитовХраненияОшибок = ПерсонифицированныйУчетКлиентСервер.ЗначенияРеквизитовХраненияОшибокВСтруктуру(
												ЭтаФорма, 
												СтрокаСтаж,
												"Объект.ЗаписиОСтаже");	
		
		ДанныеСотрудника.ЗаписиОСтаже.Добавить(СтруктураПолейЗаписиОСтаже);
	КонецЦикла;	
	
	СтрокиДанныхРаздела66 = Объект.КорректирующиеСведения.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого СтрокаРаздела66 Из СтрокиДанныхРаздела66 Цикл
		СтруктураПолейРаздела66 = СтруктураПолейРаздела66();
		ЗаполнитьЗначенияСвойств(СтруктураПолейРаздела66, СтрокаРаздела66);											
		
		ДанныеСотрудника.КорректирующиеСведения.Добавить(СтруктураПолейРаздела66);
	КонецЦикла;	

	Если ЗначениеЗаполнено(АдресДанныхТекущегоДокументаВХранилище) Тогда
		ПоместитьВоВременноеХранилище(ДанныеСотрудника, АдресДанныхТекущегоДокументаВХранилище);	
	Иначе	
		АдресДанныхТекущегоДокументаВХранилище = ПоместитьВоВременноеХранилище(ДанныеСотрудника, УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Функция СтруктураПолейСведенияОЗаработке()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("КатегорияЗастрахованныхЛиц");
	СтруктураПолей.Вставить("Месяц");
	СтруктураПолей.Вставить("Заработок");
	СтруктураПолей.Вставить("ОблагаетсяВзносами");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиДоПредельнойВеличины");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиСвышеПредельнойВеличины");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиЗаЗанятыхНаПодземныхИВредныхРаботах");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиЗаЗанятыхНаТяжелыхИПрочихРаботах");
	СтруктураПолей.Вставить("ПоДоговорамГПХДоПредельнойВеличины");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");
	
	Возврат СтруктураПолей;
КонецФункции

&НаСервере
Функция СтруктураПолейСведенияОЗаработкеНаВредныхИТяжелыхРаботах()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Месяц");
	СтруктураПолей.Вставить("КлассУсловийТруда");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиЗаЗанятыхНаПодземныхИВредныхРаботах");
	СтруктураПолей.Вставить("ОблагаетсяВзносамиЗаЗанятыхНаТяжелыхИПрочихРаботах");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");
	
	Возврат СтруктураПолей;
КонецФункции

&НаСервере
Функция СтруктураПолейЗаписиОСтаже()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НомерОсновнойЗаписи");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ДатаНачалаПериода");
	СтруктураПолей.Вставить("ДатаОкончанияПериода");
	СтруктураПолей.Вставить("ОсобыеУсловияТруда");
	СтруктураПолей.Вставить("КодПозицииСписка");
	СтруктураПолей.Вставить("ОснованиеИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ПервыйПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ВторойПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ТретийПараметрИсчисляемогоСтажа");
	СтруктураПолей.Вставить("ОснованиеВыслугиЛет");
	СтруктураПолей.Вставить("ПервыйПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ВторойПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТретийПараметрВыслугиЛет");
	СтруктураПолей.Вставить("ТерриториальныеУсловия");
	СтруктураПолей.Вставить("ПараметрТерриториальныхУсловий");
	СтруктураПолей.Вставить("ИдентификаторИсходнойСтроки");

	Возврат СтруктураПолей;	
КонецФункции

&НаСервере
Функция СтруктураПолейРаздела66()
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("КорректируемыйПериод");
	СтруктураПолей.Вставить("НомерДополнительнойЗаписи");
	СтруктураПолей.Вставить("ДоначисленоСтраховая");
	СтруктураПолей.Вставить("ДоначисленоНакопительная");
	СтруктураПолей.Вставить("ДоначисленоНаОПС");
	
	Возврат СтруктураПолей;	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеКолонокЗаголовковТаблицФормы()
	ОписаниеКолонокЗаголовковТаблиц = Новый Соответствие;
	
	ОписаниеКолонокЗаголовковТаблиц.Вставить("Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());  
	
	Возврат ОписаниеКолонокЗаголовковТаблиц;
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеКолонокЗаголовковТаблицыСотрудники()
	ОписаниеЗаголовковКолонок = Новый Массив;
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиНачисленоСтраховая";
	ОписаниеЗаголовка.Заголовок = "Начислено";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
		
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиДоначисленоСтраховая";
	ОписаниеЗаголовка.Заголовок = "Доначислено";
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);
	
	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиОблагаетсяВзносамиДоПредельнойВеличины";
	ОписаниеЗаголовка.Заголовок = "До пред.";
	ОписаниеЗаголовка.Ширина = 8;
		
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);

	ОписаниеЗаголовка = ПерсонифицированныйУчетКлиентСервер.СтруктураОписанияКолонокЗаголовков();
	ОписаниеЗаголовка.ПолеТаблицы = "СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины";
	ОписаниеЗаголовка.Заголовок = "Свыше пред.";
	ОписаниеЗаголовка.Ширина = 11;
	
	ОписаниеЗаголовковКолонок.Добавить(ОписаниеЗаголовка);

	Возврат ОписаниеЗаголовковКолонок;
		
КонецФункции

&НаСервере
Процедура  УстановитьВидимостьПолейТаблицыСотрудники()
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость = Ложь;
		Элементы.СотрудникиЗаработок.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиДоПредельнойВеличины.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины.Видимость = Истина;
	ИначеЕсли Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ Тогда
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиЗаработок.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиДоПредельнойВеличины.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины.Видимость = Истина;
	ИначеЕсли Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Ложь;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиЗаработок.Видимость = Ложь;
		Элементы.СотрудникиОблагаетсяВзносамиДоПредельнойВеличины.Видимость = Ложь;
		Элементы.СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины.Видимость = Ложь;	
	КонецЕсли;
	
	ПерсонифицированныйУчетФормы.УстановитьВидимостьКолонокЗаголовков(ЭтотОбъект, "Сотрудники", ОписаниеКолонокЗаголовковТаблицыСотрудники());
КонецПроцедуры

&НаСервере
Функция ОписаниеЭлементовСИндикациейОшибок() Экспорт
	ОписаниеЭлементовИндикацииОшибок = Новый Соответствие;	
	Возврат ОписаниеЭлементовИндикацииОшибок;
КонецФункции	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", ДанныеТекущегоДокумента.Сотрудник));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	
	СтрокиЗаработка = Объект.СведенияОЗаработке.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаЗаработокСотрудника Из СтрокиЗаработка Цикл
		Объект.СведенияОЗаработке.Удалить(Объект.СведенияОЗаработке.Индекс(СтрокаЗаработокСотрудника));
	КонецЦикла;
	
	СуществущиеСтрокиЗаработка = Новый Массив;
	
	ДанныеТекущейСтрокиПоСотруднику.Заработок = 0;
	ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины = 0;
	ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины = 0;
	ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины = 0;
	
	Для Каждого СтрокаЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработке Цикл
		СтрокаЗаработокОбъекта = Объект.СведенияОЗаработке.Добавить();
		СтрокаЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		
		ЗаполнитьЗначенияСвойств(СтрокаЗаработокОбъекта, СтрокаЗаработок);
		
		Если СтрокаЗаработокОбъекта.Месяц <> 0 Тогда
			ДанныеТекущейСтрокиПоСотруднику.Заработок = ДанныеТекущейСтрокиПоСотруднику.Заработок + СтрокаЗаработок.Заработок;
			ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины + СтрокаЗаработок.ОблагаетсяВзносамиДоПредельнойВеличины;
			ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины + СтрокаЗаработок.ОблагаетсяВзносамиСвышеПредельнойВеличины;
			ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины + СтрокаЗаработок.ПоДоговорамГПХДоПредельнойВеличины;
		КонецЕсли;
	КонецЦикла;
		
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
	КонецЦикла;
	
	СуществущиеСтрокиСтажа = Новый Массив;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.НайтиПоИдентификатору(СтрокаСтаж.ИдентификаторИсходнойСтроки);
		
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
		СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
			
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
	
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
		
	СтрокиВредногоЗаработка = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаВредныйЗаработокСотрудника Из СтрокиВредногоЗаработка Цикл
		Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Удалить(Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Индекс(СтрокаВредныйЗаработокСотрудника));
	КонецЦикла;
	
	СтрокиВредногоЗаработкаПоСотруднику = Новый Массив;
	Для Каждого СтрокаВредныйЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработкеНаВредныхИТяжелыхРаботах Цикл
		СтрокаВредныйЗаработокОбъекта = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Добавить();
		СтрокаВредныйЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		
		ЗаполнитьЗначенияСвойств(СтрокаВредныйЗаработокОбъекта, СтрокаВредныйЗаработок);
		
	КонецЦикла;
	
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ Тогда
		СтрокиДанныхРаздела66 = Объект.КорректирующиеСведения.НайтиСтроки(СтруктураПоиска);
	
		Для Каждого СтрокаРаздела66Объекта Из СтрокиДанныхРаздела66 Цикл
			Объект.КорректирующиеСведения.Удалить(Объект.КорректирующиеСведения.Индекс(СтрокаРаздела66Объекта));
		КонецЦикла;
	
		Для Каждого СтрокаРаздела66 Из ДанныеТекущегоДокумента.КорректирующиеСведения Цикл
			СтрокаРаздела66Объекта = Объект.КорректирующиеСведения.Добавить();
			СтрокаРаздела66Объекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
			
			ЗаполнитьЗначенияСвойств(СтрокаРаздела66Объекта, СтрокаРаздела66);
		КонецЦикла;
	
	КонецЕсли;	
			
	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПроверкаЗаполненияДокумента(Отказ = Ложь)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ПроверитьДанныеДокумента(Отказ);
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействия(ОповещениеЗавершения = Неопределено)
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ПроверкаЗаполненияДокумента(Отказ);	
	
	ДополнительныеПараметры = Новый Структура("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если Отказ Тогда 
		ТекстВопроса = НСтр("ru = 'В комплекте обнаружены ошибки.
							|Продолжить (не рекомендуется)?'");
							
		Оповещение = Новый ОписаниеОповещения("ПроверитьСЗапросомДальнейшегоДействияЗавершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, НСтр("ru = 'Предупреждение.'"));
	Иначе 
		ПроверитьСЗапросомДальнейшегоДействияЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);				
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПроверитьСЗапросомДальнейшегоДействияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;			
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти
