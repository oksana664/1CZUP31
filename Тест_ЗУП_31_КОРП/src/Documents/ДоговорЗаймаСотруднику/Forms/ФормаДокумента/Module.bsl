
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Руководитель, ДолжностьРуководителя", 
			"Объект.Организация", "Объект.Ответственный", "Объект.Руководитель", "Объект.ДолжностьРуководителя");
			
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Объект.ДатаПредоставления = НачалоМесяца(ТекущаяДатаСеанса());
		Объект.ДатаОкончания = Объект.ДатаПредоставления;
		
		ПриПолученииДанныхНаСервере();
		
		Объект.ЗаемПоДоговоруВыданПолностью = Истина;
		
		ЭтаФорма.Срок = 1;
		
	КонецЕсли;
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаОтсрочки(ЭтаФорма, Объект.ДатаПредоставления);
	УстановитьВидимостьПолейВыдачиПогашенияЗайма();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПрочитатьДанныеФормы(ТекущийОбъект);
	
	ПриПолученииДанныхНаСервере();
	
	ПрочитатьСписокДокументовВыдачиЗайма();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.СпособПредоставления = Перечисления.СпособыПредоставленияЗаймаСотруднику.Единовременно Тогда
		ТекущийОбъект.ТраншиЗайма.Очистить();
	КонецЕсли;
	
	Если ТекущийОбъект.СпособПогашения = Перечисления.СпособыПогашенияЗаймаСотруднику.ПоОкончанииСрока Тогда
		ТекущийОбъект.РазмерПлатежа = 0;
		ТекущийОбъект.РазмерПогашения = 0;
	Иначе
		Если ТекущийОбъект.ВидПлатежей = Перечисления.ВидыПлатежейПогашенияЗаймаСотруднику.АннуитетныеПлатежи Тогда
			ТекущийОбъект.РазмерПогашения = 0;
		Иначе
			Если ТекущийОбъект.ВидПлатежей = Перечисления.ВидыПлатежейПогашенияЗаймаСотруднику.ТолькоПроценты Тогда
				ТекущийОбъект.РазмерПогашения = 0;
			КонецЕсли;
			ТекущийОбъект.РазмерПлатежа = 0;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПрочитатьДанныеФормы(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ДоговорЗаймаСотруднику", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ОбработкаЗаписиНовогоНаСервере();
	
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
Процедура СпособПредоставленияПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаТраншей(ЭтаФорма, Объект.СпособПредоставления);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВыдачиЗаймаДокументомДоговора(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	// Изменяется:
	// - размер погашения (при дифференцированных)
	// - размер платежа (при аннуитетных)
	// - размер процентов (при погашении только процентов).
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, Объект.ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);

КонецПроцедуры

&НаКлиенте
Процедура СрокПриИзменении(Элемент)
	
	// Изменяется:
	// - дата окончания
	// - размер погашения (при дифференцированных)
	// - размер платежа (при аннуитетных).
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаПредоставления", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентнаяСтавкаПриИзменении(Элемент)
	
	// Изменяется:
	// - размер платежа (при аннуитетных)
	// - размер процентов (при погашении только процентов).
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, Объект.ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
	ЗаймыСотрудникамКлиентСервер.УстановитьОтметкуНезаполненногоПогашенныхПроцентов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаемПоДоговоруВыданПолностьюПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВыдачиЗаймаДокументомДоговора(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПогашенияПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаЧастичногоПогашенияЗайма(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьНастройкиПогашения(ЭтаФорма, Объект.СпособПогашения, Объект.ВидПлатежей, Объект.ДатаПредоставления);
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПлатежейПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаЧастичногоПогашенияЗайма(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаРазмераПогашения(ЭтаФорма, Объект.ВидПлатежей);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, Объект.ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьОграниченияПлатежа(ЭтаФорма, Объект.ВидПлатежей);
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерПлатежаПриИзменении(Элемент)
	
	// изменяется:
	// - срок и дата окончания
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПолногоПогашенияЗайма(ЭтаФорма, Объект.СпособПогашения, Объект.ВидПлатежей, Срок, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьОграниченияПлатежа(ЭтаФорма, Объект.ВидПлатежей);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаПредоставления", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерПогашенияПриИзменении(Элемент)
	
	// изменяется:
	// - срок и дата окончания
	Объект.ОграничениеПлатежа = Макс(Объект.РазмерПогашения, Объект.ОграничениеПлатежа);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПолногоПогашенияЗайма(ЭтаФорма, Объект.СпособПогашения, Объект.ВидПлатежей, Срок, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаПредоставления", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредоставляетсяОтсрочкаПлатежаПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаОтсрочки(ЭтаФорма, Объект.ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьОграниченияПлатежа(ЭтаФорма, Объект.ВидПлатежей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничениеПлатежаПриИзменении(Элемент)

	// Нужно скорректировать размер погашения основного долга.
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	
	// Изменяется:
	// - срок и дата окончания
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПолногоПогашенияЗайма(ЭтаФорма, Объект.СпособПогашения, Объект.ВидПлатежей, Срок, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаПредоставления", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаемЧастичноПогашенПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаЧастичногоПогашенияЗайма(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.УстановитьОтметкуНезаполненногоПогашенныхПроцентов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыдачиПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПогашенияПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

#Область МесяцПредоставления

&НаКлиенте
Процедура МесяцПредоставленияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаПредоставления", "МесяцПредоставления", Модифицированность);
	
	ПриИзмененииМесяцаПредоставления();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцПредоставленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцПредоставленияНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаПредоставления", "МесяцПредоставления", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцПредоставленияНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаПредоставления();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцПредоставленияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаПредоставления", "МесяцПредоставления", Направление, Модифицированность);
	
	ПриИзмененииМесяцаПредоставления();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцПредоставленияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцПредоставленияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область МесяцОкончания

&НаКлиенте
Процедура МесяцОкончанияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания", Модифицированность);
	
	ПриИзмененииМесяцаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцОкончанияНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания", Направление, Модифицированность);
	
	ПриИзмененииМесяцаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область МесяцНачалаПогашенияПослеОтсрочки

&НаКлиенте
Процедура МесяцНачалаПогашенияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения", Модифицированность);
	
	ПриИзмененииМесяцаНачалаПогашения();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачалаПогашенияНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаНачалаПогашения();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения", Направление, Модифицированность);
	
	ПриИзмененииМесяцаНачалаПогашения();

КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область МесяцПредоставленияТранша

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные, "ДатаПредоставления", "МесяцПредоставленияСтрокой", Модифицированность);
	
	ПриИзмененииМесяцаПредоставленияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма, Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные, "ДатаПредоставления", "МесяцПредоставленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаПредоставленияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные, "ДатаПредоставления", "МесяцПредоставленияСтрокой", Направление, Модифицированность);
	
	ПриИзмененииМесяцаПредоставленияТранша();

КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыГрафикПредоставленияЗайма

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ЗаймыСотрудникамКлиентСервер.ГрафикПредоставленияЗаймаВосстановитьПорядокСтрок(Объект.ТраншиЗайма, "ДатаПредоставления", Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьПредставлениеТранша(ЭтаФорма, Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные);
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВыдачиЗаймаДокументомДоговора(ЭтаФорма);
	
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные;
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуТраншаПоУмолчанию(ТекущаяСтрока, Объект.ТраншиЗайма, Объект.ДатаПредоставления, Объект.ДатаОкончания);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ТекущаяСтрока.Срок, ТекущаяСтрока.ДатаПогашения, ТекущаяСтрока.ДатаПредоставления);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаСуммаТраншаПриИзменении(Элемент)
	
	Объект.Сумма = Объект.ТраншиЗайма.Итог("Сумма");
	
	ТекущаяСтрока = Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные;
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, Объект.ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаПослеУдаления(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВыдачиЗаймаДокументомДоговора(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыТраншиЗайма

&НаКлиенте
Процедура ТраншиЗаймаСрокПриИзменении(Элемент)
		
	ТекущаяСтрока = Элементы.ТраншиЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ТекущаяСтрока, "ДатаПредоставления", "ДатаПогашения", "МесяцПогашенияСтрокой", ТекущаяСтрока.Срок);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
		
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаРазмерПогашенияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТраншиЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоРазмеруПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ТекущаяСтрока, "ДатаПредоставления", "ДатаПогашения", "МесяцПогашенияСтрокой", ТекущаяСтрока.Срок);
	
КонецПроцедуры

#КонецОбласти

#Область МесяцОкончанияПогашенияТранша

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		Элементы.ТраншиЗайма.ТекущиеДанные, "ДатаПогашения", "МесяцПогашенияСтрокой", Модифицированность);
	
	ПриИзмененииМесяцаПогашенияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ТраншиЗаймаМесяцПогашенияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма, Элементы.ТраншиЗайма.ТекущиеДанные, "ДатаПогашения", "МесяцПогашенияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт

	ПриИзмененииМесяцаПогашенияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		Элементы.ТраншиЗайма.ТекущиеДанные, "ДатаПогашения", "МесяцПогашенияСтрокой", Направление, Модифицированность);
	
	ПриИзмененииМесяцаПогашенияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокументВыдачиЗайма(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ВнешниеХозяйственныеОперации.ЗаймыСотрудникамВХО") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗаймыСотрудникамВХОКлиент");
		Модуль.ОткрытьДокументВыдачиЗайма(ЭтотОбъект, ДокументыВыдачиЗайма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокДокументовВыдачиЗайма(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ВнешниеХозяйственныеОперации.ЗаймыСотрудникамВХО") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗаймыСотрудникамВХОКлиент");
		Модуль.ОткрытьСписокДокументовВыдачиЗайма(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаПредоставления", "МесяцПредоставления");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаПредоставления()
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаПредоставления", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВыдачиЗаймаДокументомДоговора(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаОкончания()
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(Срок, Объект.ДатаОкончания, Объект.ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаНачалаПогашения()
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.РассчитатьПогашеннуюСуммуЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаПредоставленияТранша()
	
	ТекущаяСтрока = Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(
		ТекущаяСтрока.Срок, ТекущаяСтрока.ДатаПогашения, ТекущаяСтрока.ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, Объект.ВидПлатежей, ДанныеЗайма());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаПогашенияТранша()
	
	ТекущаяСтрока = Элементы.ТраншиЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ТекущаяСтрока.Срок, ТекущаяСтрока.ДатаПогашения, ТекущаяСтрока.ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок, Объект.ВидПлатежей, Объект.ОграничениеПлатежа);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеФормы(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда 
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	ПредоставляетсяОтсрочкаПлатежа = ЗначениеЗаполнено(ТекущийОбъект.ДатаНачалаПогашения);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(Срок, ТекущийОбъект.ДатаОкончания, ТекущийОбъект.ДатаПредоставления);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаТраншей(ЭтаФорма, Объект.СпособПредоставления);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаРазмераПогашения(ЭтаФорма, Объект.ВидПлатежей);
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьНастройкиПогашения(ЭтаФорма, Объект.СпособПогашения, Объект.ВидПлатежей, Объект.ДатаПредоставления);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, Объект.ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ТраншиЗайма, "ДатаПредоставления", "МесяцПредоставленияСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ТраншиЗайма, "ДатаПогашения", "МесяцПогашенияСтрокой");
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьПредставленияТраншей(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокиПогашенияТраншей(ЭтаФорма);
	
	Если ЗаймыСотрудникам.ЕстьОперацииПоДоговоруЗайма(Объект.Ссылка, Объект.Ссылка) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеЗайма()
	
	ДанныеЗайма = Новый Структура;
	ДанныеЗайма.Вставить("МесяцПредоставления", Объект.ДатаПредоставления);
	ДанныеЗайма.Вставить("МесяцОкончания", Объект.ДатаОкончания);
	ДанныеЗайма.Вставить("ГодоваяСтавка", Объект.ПроцентнаяСтавка);
	ДанныеЗайма.Вставить("СуммаЗайма", Объект.Сумма);
	ДанныеЗайма.Вставить("СпособПредоставления", Объект.СпособПредоставления);
	ДанныеЗайма.Вставить("ТраншиЗайма", Объект.ТраншиЗайма);
	ДанныеЗайма.Вставить("СпособПогашения", Объект.СпособПогашения);
	ДанныеЗайма.Вставить("ВидПлатежей", Объект.ВидПлатежей);
	ДанныеЗайма.Вставить("РазмерПлатежа", Объект.РазмерПлатежа);
	ДанныеЗайма.Вставить("РазмерПогашения", Объект.РазмерПогашения);
	ДанныеЗайма.Вставить("МесяцНачалаПогашения", Объект.ДатаНачалаПогашения);
	ДанныеЗайма.Вставить("ОграничениеПлатежа", Объект.ОграничениеПлатежа);
	
	Возврат ДанныеЗайма;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьВидимостьПолейВыдачиПогашенияЗайма();
	
	ЗначенияДляЗаполнения = Новый Структура("Организация, Руководитель, ДолжностьРуководителя",
		"Объект.Организация", "Объект.Руководитель", "Объект.ДолжностьРуководителя");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"))
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолейВыдачиПогашенияЗайма() 
	
	ВыдачаЗаймаДокументомДоговораДоступна = ЗаймыСотрудникам.ДоступнаРегистрацияВыдачиЗаймаДокументомДоговорЗайма(Объект.Организация);
	
	Если Не ВыдачаЗаймаДокументомДоговораДоступна Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВыдачаЗаймаДокументомДоговораСтраницы", "Видимость", Ложь);
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗаемЧастичноПогашенГруппа", "Видимость", Ложь);
	КонецЕсли;
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаЧастичногоПогашенияЗайма(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаЗаписиНовогоНаСервере()
	
	ТолькоПросмотр = ЗаймыСотрудникам.ЕстьОперацииПоДоговоруЗайма(Объект.Ссылка, Объект.Ссылка);
	ПрочитатьСписокДокументовВыдачиЗайма();
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВыдачиЗаймаДокументомДоговора(ЭтаФорма); 
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьСписокДокументовВыдачиЗайма()
	
	ДокументыВыдачиЗайма.Очистить();
	
	СписокДокументов = ЗаймыСотрудникам.ДокументыВыдачиЗайма(Объект.Ссылка);
	
	Если СписокДокументов <> Неопределено Тогда 
		ДокументыВыдачиЗайма.ЗагрузитьЗначения(СписокДокументов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
