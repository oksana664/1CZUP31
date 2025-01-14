
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		
		УстановитьВидРасчета();
		
		Если Не ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
			Объект.ПериодРегистрации = КонецМесяца(ТекущаяДатаСеанса()) + 1;
		КонецЕсли;
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Ответственный", "Объект.Ответственный");
		Если Параметры.ЗначенияЗаполнения.Свойство("Организация") 
			И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.Организация) Тогда
			Объект.Организация = Параметры.ЗначенияЗаполнения.Организация;
		КонецЕсли;
		
		ЗначенияДляЗаполнения.Вставить("Организация", "Объект.Организация");
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли; 
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ПериодыОплаченныеДоНачалаЭксплуатации", ПараметрыЗаписи, Объект.Ссылка);
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
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	НастроитьОтображениеПодразделений();
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СотрудникиОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСотрудникПриИзменении(Элемент)
	ДополнитьСтрокуРасчета(Элементы.Начисления.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаНачалаПриИзменении(Элемент)
	ДополнитьСтрокуРасчета(Элементы.Начисления.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаОкончанияПриИзменении(Элемент)
	ДополнитьСтрокуРасчета(Элементы.Начисления.ТекущиеДанные);
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

#Область ОбработчикиКомандФормы

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
Процедура ПодборСотрудников(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", Истина);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыОткрытия.Вставить("АдресСпискаПодобранныхСотрудников", АдресСпискаПодобранныхСотрудников());
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ГоловнаяОрганизация", Объект.Организация);
	
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	
	ОткрытьФорму("Справочник.Сотрудники.ФормаВыбора", ПараметрыОткрытия, Элементы.Начисления, Истина);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()

	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
	
	УстановитьПараметрыВыбораВидуПериода();
	
	УстановитьФункциональныеОпцииФормы();
	
	УстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьПараметрыВыбораВидуПериода()
	
	ДопустимыеЗначенияВвода = Новый Массив;
	
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.Работа"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускОсновной"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ДополнительныйОтпуск"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ДополнительныйОтпускНеоплачиваемый"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускУчебныйОплачиваемый"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускУчебныйНеоплачиваемый"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускНеоплачиваемыйПоРазрешениюРаботодателя"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускНеоплачиваемыйПоЗаконодательству"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.Командировка"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтсутствиеССохранениемОплаты"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускПоБеременностиИРодам"));
	ДопустимыеЗначенияВвода.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСотрудника.ОтпускНаСанаторноКурортноеЛечение"));
	
	ПараметрыВыбораВидуПериода = Новый Массив;
	Для каждого ПараметрВыбора Из Элементы.НачисленияВидПериода.ПараметрыВыбора Цикл
		Если ПараметрВыбора.Имя = "Отбор.Ссылка" Тогда
			Продолжить;
		КонецЕсли;
		ПараметрыВыбораВидуПериода.Добавить(ПараметрВыбора);
	КонецЦикла; 
	
	ПараметрыВыбораВидуПериода.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(ДопустимыеЗначенияВвода)));
	
	Элементы.НачисленияВидПериода.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораВидуПериода);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация", Объект.Организация);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()

	СписокНачислений = ПланыВидовРасчета.Начисления.НачисленияПоКатегории(ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПредыдущимиДокументами"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВидРасчета",
		"Видимость",
		СписокНачислений.Количество() <> 1);

КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеПодразделений()
	
	Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям")
		И ЗначениеЗаполнено(Объект.Подразделение) Тогда
		
		ВидимостьПодразделенийВТабличнойЧасти = Ложь;
	Иначе
		ВидимостьПодразделенийВТабличнойЧасти = Истина;
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СотрудникиПодразделение",
		"Видимость",
		ВидимостьПодразделенийВТабличнойЧасти);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Организация",	"Объект.Организация");
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли;
		
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
		
		
		НастроитьОтображениеПодразделений();
		
	КонецЕсли;
		
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура СотрудникиОбработкаВыбораНаСервере(ВыбранныеСотрудники)

	Если ТипЗнч(ВыбранныеСотрудники) = Тип("Массив") Тогда
		СписокСотрудников = ВыбранныеСотрудники;
	Иначе
		СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранныеСотрудники);
	КонецЕсли;
	
	Для каждого Сотрудник Из СписокСотрудников Цикл
		
		Если Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли; 
		
		НоваяСтрокаСотрудников = Объект.Начисления.Добавить();
		НоваяСтрокаСотрудников.Сотрудник = Сотрудник;
		НоваяСтрокаСотрудников.ДатаНачала = Объект.ПериодРегистрации;
		НоваяСтрокаСотрудников.ДатаОкончания = Объект.ПериодРегистрации;
		
		ДополнитьСтрокуНаСервере(НоваяСтрокаСотрудников.ПолучитьИдентификатор(), ОписаниеТаблицыНачислений(), Истина, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтрокуРасчета(ТекущиеДанные)

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Сотрудник)
		ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.ДатаНачала)
		ИЛИ Не ЗначениеЗаполнено(ТекущиеДанные.ДатаОкончания) Тогда
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыРасширенныйКлиент.ДополнитьСтрокуРасчета(ЭтаФорма, ОписаниеТаблицыНачислений(), Истина, Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ДополнитьСтроку(ИдентификаторСтроки, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей) Экспорт
	ДополнитьСтрокуНаСервере(ИдентификаторСтроки, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей)
КонецПроцедуры

&НаСервере
Процедура ДополнитьСтрокуНаСервере(ИдентификаторСтроки, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей)

	РасчетЗарплатыРасширенныйФормы.ДополнитьСтрокуРасчета(
		ЭтаФорма,
		ОписаниеДокумента(ЭтотОбъект),
		ИдентификаторСтроки,
		ОписаниеТаблицыНачислений(),
		ЗаполнятьСведенияСотрудников,
		ЗаполнятьЗначенияПоказателей);
	
КонецПроцедуры

// Описания документа, таблиц документа, панелей документа.
&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеДокумента(Форма)
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеРасчетногоДокумента();
	
	Описание.НачисленияИмя = "Начисления";
	Описание.НачисленияКоманднаяПанельИмя = "НачисленияКоманднаяПанельГруппа";
	Описание.ВидНачисленияВШапке = Истина;
	Описание.ВидНачисленияИмя = "ВидРасчета";
	Описание.МесяцНачисленияИмя = "ПериодРегистрации";
	Описание.ОбязательныеПоля.Добавить(РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Месяц начисления'"), "МесяцНачисленияСтрокой"));
	
	Возврат Описание;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	Описание.СодержитПолеСотрудник = Истина;
	Описание.ИмяРеквизитаСотрудник = "Сотрудник";
	Описание.СодержитПолеВидРасчета = Ложь;
	Описание.ИмяРеквизитаВидРасчета = "ВидРасчета";
	Описание.ИмяРеквизитаПериод = "ПериодРегистрации";
	Описание.ОтменятьВсеИсправления	= Истина;
	Описание.ОтображатьПоляРаспределенияРезультатов	= Ложь;
	
	Возврат Описание;
	
КонецФункции

&НаСервере
Функция УстановитьВидРасчета()

	СписокНачислений = ПланыВидовРасчета.Начисления.НачисленияПоКатегории(ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПредыдущимиДокументами"));
	Если СписокНачислений.Количество() > 0 Тогда
		Объект.ВидРасчета = СписокНачислений[0];
	КонецЕсли;
	
КонецФункции

#КонецОбласти
