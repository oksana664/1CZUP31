
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДополнитьФорму();
	ПрочитатьДанныеГрейдов();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Лев(Поле.Имя, 15) = "НачисленияГрейд" Тогда 
		
		НомерКолонки = Число(Сред(Поле.Имя, 16));
		ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
		
		ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НачислениеПоказатель", ТекущиеДанные.НачислениеПоказатель);
		ПараметрыФормы.Вставить("НомерКолонки", НомерКолонки);
		ПараметрыФормы.Вставить("ИспользованиеРазрешено", ТекущиеДанные[ИмяКолонки + "ИспользованиеРазрешено"]);
		ПараметрыФормы.Вставить("РазмерМин", ТекущиеДанные[ИмяКолонки + "РазмерМин"]);
		ПараметрыФормы.Вставить("РазмерМакс", ТекущиеДанные[ИмяКолонки + "РазмерМакс"]);
		ПараметрыФормы.Вставить("ПоказателиГрейда", ЗначенияПоказателейГрейдов.Получить(НомерКолонки));
		
		Если ТекущиеДанные.ТипЗначения = 0 Тогда 
			ОткрытьФорму("Обработка.РаботаСГрейдами.Форма.РедактированиеОграниченияФОТ", ПараметрыФормы, Элементы.Начисления);
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ТекущиеДанные.НачислениеПоказатель) Тогда 
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(ТекущиеДанные.НачислениеПоказатель) = Тип("ПланВидовРасчетаСсылка.Начисления") Тогда
			ОткрытьФорму("Обработка.РаботаСГрейдами.Форма.РедактированиеНачисления", ПараметрыФормы, Элементы.Начисления);
		Иначе 
			ОткрытьФорму("Обработка.РаботаСГрейдами.Форма.РедактированиеПоказателя", ПараметрыФормы, Элементы.Начисления);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.ТипЗначения = 0 И Копирование Тогда 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда 
		НоваяСтрока = Начисления.Добавить();
		НоваяСтрока.НачислениеПоказатель = ВыбранноеЗначение;
		ЗаполнитьДанныеГрейдовПоУмолчанию(НоваяСтрока);
		Начисления.Сортировать("ТипЗначения");
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	НачисленияОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНачислениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДанныеГрейдовПоУмолчанию(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда 
		
		ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
		
		Если ТекущиеДанные = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		ЗаполнитьДанныеГрейдовПоУмолчанию(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Начисления.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипЗначения = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Отказ = Ложь;
	СохранитьДанныеГрейдов(Отказ);
	
	Если Не Отказ Тогда 
		Оповестить("ИзмененыДанныеГрейдов", , ЭтотОбъект.ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНачисление(Команда)
	
	Отбор = Новый Структура("ЯвляетсяЛьготой", Ложь);
	ПараметрыФормы = Новый Структура("Отбор, РежимВыбора", Отбор, Истина);
	ОткрытьФорму("ПланВидовРасчета.Начисления.ФормаВыбора", ПараметрыФормы, Элементы.Начисления, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоказатель(Команда)
	
	ПараметрыФормы = Новый Структура("РежимВыбора", Истина);
	ОткрытьФорму("Справочник.ПоказателиРасчетаЗарплаты.ФормаВыбора", ПараметрыФормы, Элементы.Начисления, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЛьготу(Команда)
	
	Отбор = Новый Структура("КатегорияНачисленияИлиНеоплаченногоВремени", ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.Льгота"));
	ПараметрыФормы = Новый Структура("Отбор, РежимВыбора", Отбор, Истина);
	ОткрытьФорму("ПланВидовРасчета.Начисления.ФормаВыбора", ПараметрыФормы, Элементы.Начисления, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДополнитьФорму()
	
	// Добавление реквизитов
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтотОбъект, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтотОбъект, МассивИменРеквизитовФормы, "Начисления");
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Грейды.Ссылка,
	               |	Грейды.Наименование
	               |ИЗ
	               |	Справочник.Грейды КАК Грейды
	               |ГДЕ
	               |	НЕ Грейды.ПометкаУдаления
	               |	И НЕ Грейды.ВАрхиве
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Грейды.РеквизитДопУпорядочивания";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоГрейдов = Выборка.Количество();
	
	НомераКолонок = Новый Соответствие;
	
	Сч = 1;
	ДобавляемыеРеквизиты = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		ИмяКолонки = ИмяКолонкиГрейда(Сч);
		
		ГрейдРеквизит = Новый РеквизитФормы(
			ИмяКолонки, Новый ОписаниеТипов("Строка"), "Начисления", Выборка.Наименование);
		ДобавляемыеРеквизиты.Добавить(ГрейдРеквизит);
		
		ИспользованиеРазрешеноРеквизит = Новый РеквизитФормы(
			ИмяКолонки + "ИспользованиеРазрешено", Новый ОписаниеТипов("Булево"), "Начисления");
		ДобавляемыеРеквизиты.Добавить(ИспользованиеРазрешеноРеквизит);
		
		ЗначениеМинРеквизит = Новый РеквизитФормы(
			ИмяКолонки + "РазмерМин", Новый ОписаниеТипов("Число"), "Начисления");
		ДобавляемыеРеквизиты.Добавить(ЗначениеМинРеквизит);
		
		ЗначениеМаксРеквизит = Новый РеквизитФормы(
			ИмяКолонки + "РазмерМакс", Новый ОписаниеТипов("Число"), "Начисления");
		ДобавляемыеРеквизиты.Добавить(ЗначениеМаксРеквизит);
		
		НомераКолонок.Вставить(Выборка.Ссылка, Сч);
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	НомераКолонокГрейдов = Новый ФиксированноеСоответствие(НомераКолонок);
	
	ЗарплатаКадры.ИзменитьРеквизитыФормы(ЭтотОбъект, ДобавляемыеРеквизиты, МассивИменРеквизитовФормы);
	
	// Добавление элементов формы
	Для Сч = 1 По КоличествоГрейдов Цикл
		
		ИмяКолонки = ИмяКолонкиГрейда(Сч);
		
		Если Элементы.Найти("Начисления" + ИмяКолонки) = Неопределено Тогда 
			Значение = Элементы.Добавить("Начисления" + ИмяКолонки, Тип("ПолеФормы"), Элементы.Начисления);
			Значение.Вид = ВидПоляФормы.ПолеНадписи;
			Значение.ГиперссылкаЯчейки = Истина;
			Значение.ПутьКДанным = "Начисления." + ИмяКолонки;
			Значение.ОтображатьВШапке = Истина;
			Значение.Ширина = 10;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеГрейдов()
	
	Начисления.Очистить();
	
	// Ограничение ФОТ
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Грейды.Ссылка КАК Грейд,
	               |	ЕСТЬNULL(ОграничениеФОТГрейдов.ОграничиватьФОТ, ЛОЖЬ) КАК ОграничиватьФОТ,
	               |	ЕСТЬNULL(ОграничениеФОТГрейдов.ФОТМин, 0) КАК ФОТМин,
	               |	ЕСТЬNULL(ОграничениеФОТГрейдов.ФОТМакс, 0) КАК ФОТМакс
	               |ИЗ
	               |	Справочник.Грейды КАК Грейды
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОграничениеФОТГрейдов КАК ОграничениеФОТГрейдов
	               |		ПО Грейды.Ссылка = ОграничениеФОТГрейдов.Грейд
	               |ГДЕ
	               |	НЕ Грейды.ПометкаУдаления
	               |	И НЕ Грейды.ВАрхиве
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Грейды.РеквизитДопУпорядочивания";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	НоваяСтрока = Начисления.Добавить();
	
	Пока Выборка.Следующий() Цикл 
		
		НомерКолонки = НомераКолонокГрейдов[Выборка.Грейд];
		ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
		
		НоваяСтрока[ИмяКолонки + "ИспользованиеРазрешено"] = Выборка.ОграничиватьФОТ;
		НоваяСтрока[ИмяКолонки + "РазмерМин"] = Выборка.ФОТМин;
		НоваяСтрока[ИмяКолонки + "РазмерМакс"] = Выборка.ФОТМакс;
		
		ЗаполнитьПредставлениеОграниченияФОТ(НоваяСтрока, НомерКолонки);
		
	КонецЦикла;
	
	// Начисления и показатели
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияПоказателейРасчетаЗарплатыГрейдов.Грейд,
	               |	ЗначенияПоказателейРасчетаЗарплатыГрейдов.Показатель,
	               |	ЗначенияПоказателейРасчетаЗарплатыГрейдов.ЗначениеМин,
	               |	ЗначенияПоказателейРасчетаЗарплатыГрейдов.ЗначениеМакс
	               |ИЗ
	               |	РегистрСведений.ЗначенияПоказателейРасчетаЗарплатыГрейдов КАК ЗначенияПоказателейРасчетаЗарплатыГрейдов
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ИспользованиеНачисленийПоказателейГрейдов.Грейд,
	               |	ИспользованиеНачисленийПоказателейГрейдов.НачислениеПоказатель КАК НачислениеПоказатель,
	               |	ИспользованиеНачисленийПоказателейГрейдов.ИспользованиеРазрешено,
	               |	ИспользованиеНачисленийПоказателейГрейдов.РазмерМин,
	               |	ИспользованиеНачисленийПоказателейГрейдов.РазмерМакс,
	               |	ВЫБОР
	               |		КОГДА ИспользованиеНачисленийПоказателейГрейдов.НачислениеПоказатель ССЫЛКА ПланВидовРасчета.Начисления
	               |			ТОГДА ВЫБОР
	               |					КОГДА ИспользованиеНачисленийПоказателейГрейдов.НачислениеПоказатель.ЯвляетсяЛьготой
	               |						ТОГДА 3
	               |					ИНАЧЕ 1
	               |				КОНЕЦ
	               |		ИНАЧЕ 2
	               |	КОНЕЦ КАК ТипЗначения
	               |ИЗ
	               |	РегистрСведений.ИспользованиеНачисленийПоказателейГрейдов КАК ИспользованиеНачисленийПоказателейГрейдов
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТипЗначения
	               |ИТОГИ
	               |	МАКСИМУМ(ТипЗначения)
	               |ПО
	               |	НачислениеПоказатель";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатыЗапроса[0].Выбрать();
	
	ПоказателиГрейдов = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		НомерКолонки = НомераКолонокГрейдов.Получить(Выборка.Грейд);
		ПоказателиГрейда = ПоказателиГрейдов[НомерКолонки];
		Если ПоказателиГрейда = Неопределено Тогда 
			ПоказателиГрейда = Новый Соответствие;
			ПоказателиГрейдов.Вставить(НомерКолонки, ПоказателиГрейда);
		КонецЕсли;
		ПоказателиГрейда.Вставить(Выборка.Показатель, Новый Структура("ЗначениеМин, ЗначениеМакс", Выборка.ЗначениеМин, Выборка.ЗначениеМакс));
	КонецЦикла;
	
	ЗначенияПоказателейГрейдов = Новый ФиксированноеСоответствие(ПоказателиГрейдов);
	
	ВыборкаПоНачислениям = РезультатыЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоНачислениям.Следующий() Цикл 
		НоваяСтрока = Начисления.Добавить();
		НоваяСтрока.ТипЗначения = ВыборкаПоНачислениям.ТипЗначения;
		Выборка = ВыборкаПоНачислениям.Выбрать();
		Пока Выборка.Следующий() Цикл
			НомерКолонки = НомераКолонокГрейдов.Получить(Выборка.Грейд);
			Если НомерКолонки = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
			НоваяСтрока.НачислениеПоказатель = Выборка.НачислениеПоказатель;
			НоваяСтрока[ИмяКолонки + "ИспользованиеРазрешено"] = Выборка.ИспользованиеРазрешено;
			НоваяСтрока[ИмяКолонки + "РазмерМин"] = Выборка.РазмерМин;
			НоваяСтрока[ИмяКолонки + "РазмерМакс"] = Выборка.РазмерМакс;
			ЗаполнитьПредставлениеЗначенияКолонки(НоваяСтрока, НомерКолонки);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НачисленияОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	ДанныеНачислений = Начисления.НайтиПоИдентификатору(Элементы.Начисления.ТекущаяСтрока);
	
	ИмяКолонки = ИмяКолонкиГрейда(ВыбранноеЗначение.НомерКолонки);
	
	ДанныеНачислений[ИмяКолонки + "ИспользованиеРазрешено"] = ВыбранноеЗначение.ИспользованиеРазрешено;
	ДанныеНачислений[ИмяКолонки + "РазмерМин"] = ВыбранноеЗначение.РазмерМин;
	ДанныеНачислений[ИмяКолонки + "РазмерМакс"] = ВыбранноеЗначение.РазмерМакс;
	
	Если ВыбранноеЗначение.Свойство("ОграничениеФОТ") Тогда 
		ЗаполнитьПредставлениеОграниченияФОТ(ДанныеНачислений, ВыбранноеЗначение.НомерКолонки);
		Модифицированность = Истина;
	    Возврат;
	КонецЕсли;
	
	Если ВыбранноеЗначение.ИспользованиеРазрешено Тогда
		
		ПоказателиГрейдов = Новый Соответствие(ЗначенияПоказателейГрейдов);
		ПоказателиГрейда = ПоказателиГрейдов[ВыбранноеЗначение.НомерКолонки];
		Если ПоказателиГрейда = Неопределено Тогда 
			ПоказателиГрейда = Новый Соответствие;
			ПоказателиГрейдов.Вставить(ВыбранноеЗначение.НомерКолонки, ПоказателиГрейда);
		КонецЕсли;
		Если ВыбранноеЗначение.ПоказателиГрейда <> Неопределено Тогда 
			Для Каждого КлючИЗначение Из ВыбранноеЗначение.ПоказателиГрейда Цикл 
				ПоказателиГрейда.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла;
		КонецЕсли;
		
		ЗначенияПоказателейГрейдов = Новый ФиксированноеСоответствие(ПоказателиГрейдов);
		
	КонецЕсли;
	
	ЗаполнитьПредставлениеЗначенияКолонки(ДанныеНачислений, ВыбранноеЗначение.НомерКолонки);
	
	Модифицированность = Истина;
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция ИмяКолонкиГрейда(НомерКолонки)
	
	Возврат "Грейд" + НомерКолонки;

КонецФункции

&НаСервере
Процедура ЗаполнитьПредставлениеЗначенияКолонки(ДанныеНачислений, НомерКолонки)
	
	ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
	ИспользованиеРазрешено = ДанныеНачислений[ИмяКолонки + "ИспользованиеРазрешено"];
	РазмерМин = ДанныеНачислений[ИмяКолонки + "РазмерМин"];
	РазмерМакс = ДанныеНачислений[ИмяКолонки + "РазмерМакс"];
	
	Если Не ИспользованиеРазрешено Тогда
		ДанныеНачислений[ИмяКолонки] = НСтр("ru = 'Не используется'");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеНачислений.НачислениеПоказатель) Тогда
		ДанныеНачислений[ИмяКолонки] = "";
		Возврат;
	КонецЕсли;
	
	ЭтоНачисление = ТипЗнч(ДанныеНачислений.НачислениеПоказатель) = Тип("ПланВидовРасчетаСсылка.Начисления");
	
	ЗначенияПоказателейГрейда = ЗначенияПоказателейГрейдов.Получить(НомерКолонки);
	
	Рассчитывается = Ложь;
	ЗначенияПоказателей = Новый Соответствие;
	
	Если ЭтоНачисление Тогда 
		ВидРасчетаИнфо = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(ДанныеНачислений.НачислениеПоказатель);
		Рассчитывается = ВидРасчетаИнфо.Рассчитывается;
		Для Каждого ОписаниеПоказателя Из ВидРасчетаИнфо.Показатели Цикл 
			Если ОписаниеПоказателя.ЗапрашиватьПриВводе Тогда
				ЗначенияПоказателя = Неопределено;
				Если ЗначенияПоказателейГрейда <> Неопределено Тогда 
					ЗначенияПоказателя = ЗначенияПоказателейГрейда.Получить(ОписаниеПоказателя.Показатель);
				КонецЕсли;
				Если ЗначенияПоказателя = Неопределено Тогда 
					ЗначенияПоказателя = Новый Структура("ЗначениеМин, ЗначениеМакс", 0, 0);
				КонецЕсли;	
				ЗначенияПоказателей.Вставить(ОписаниеПоказателя.Показатель, ЗначенияПоказателя);
			КонецЕсли;
		КонецЦикла;
	Иначе 
		ЗначенияПоказателя = Неопределено;
		Если ЗначенияПоказателейГрейда <> Неопределено Тогда 
			ЗначенияПоказателя = ЗначенияПоказателейГрейда.Получить(ДанныеНачислений.НачислениеПоказатель);
		КонецЕсли;
		Если ЗначенияПоказателя = Неопределено Тогда 
			ЗначенияПоказателя = Новый Структура("ЗначениеМин, ЗначениеМакс", 0, 0);
		КонецЕсли;	
		ЗначенияПоказателей.Вставить(ДанныеНачислений.НачислениеПоказатель, ЗначенияПоказателя);
	КонецЕсли;
	
	ПредставлениеЗначения = "";
	
	Если ЭтоНачисление И Не Рассчитывается Тогда 
		ПредставлениеЗначения = ?(РазмерМин = РазмерМакс, РазмерМин, "" + РазмерМин + " - " + РазмерМакс);
	Иначе
		Если ЗначенияПоказателей.Количество() = 0 Тогда 
			ПредставлениеЗначения = НСтр("ru = 'Используется'");
		ИначеЕсли ЗначенияПоказателей.Количество() = 1 Тогда
			Для Каждого КлючИЗначение Из ЗначенияПоказателей Цикл
				ЗначенияПоказателя = КлючИЗначение.Значение;
				ПредставлениеЗначения = ?(ЗначенияПоказателя.ЗначениеМин = ЗначенияПоказателя.ЗначениеМакс, 
					?(ЗначенияПоказателя.ЗначениеМин = 0, НСтр("ru = 'Используется'"), ЗначенияПоказателя.ЗначениеМин),
					"" + ЗначенияПоказателя.ЗначениеМин + " - " + ЗначенияПоказателя.ЗначениеМакс);
			КонецЦикла;
		Иначе
			ЕстьЗаполненныеЗначения = Ложь;
			Для Каждого КлючИЗначение Из ЗначенияПоказателей Цикл 
				ЗначенияПоказателя = КлючИЗначение.Значение;
				ПредставлениеЗначенияПоказателя = ?(ЗначенияПоказателя.ЗначениеМин = ЗначенияПоказателя.ЗначениеМакс, 
					ЗначенияПоказателя.ЗначениеМин, "" + ЗначенияПоказателя.ЗначениеМин + " - " + ЗначенияПоказателя.ЗначениеМакс);
				ПредставлениеЗначения = ПредставлениеЗначения 
					+ ?(ПредставлениеЗначения = "" Или ПредставлениеЗначенияПоказателя = "", "", ", ")
					+ ?(ПредставлениеЗначенияПоказателя = "", "", Строка(КлючИЗначение.Ключ) + " (" + ПредставлениеЗначенияПоказателя + ")");
					Если ЗначенияПоказателя.ЗначениеМин <> 0 Или ЗначенияПоказателя.ЗначениеМакс <> 0 Тогда 
						ЕстьЗаполненныеЗначения = Истина;
					КонецЕсли;
			КонецЦикла;
			Если Не ЕстьЗаполненныеЗначения Тогда 
				ПредставлениеЗначения = НСтр("ru = 'Используется'");
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
	ДанныеНачислений[ИмяКолонки] = ПредставлениеЗначения;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеОграниченияФОТ(ДанныеНачислений, НомерКолонки)
	
	ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
	
	Если Не ДанныеНачислений[ИмяКолонки + "ИспользованиеРазрешено"] Тогда 
		ДанныеНачислений[ИмяКолонки] = НСтр("ru = 'Не используется'");
	Иначе 
		ДанныеНачислений[ИмяКолонки] = "" + ДанныеНачислений[ИмяКолонки + "РазмерМин"] + " - " + ДанныеНачислений[ИмяКолонки + "РазмерМакс"];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеГрейдов(Отказ)
	
	ПроверитьЗаполнениеТаблицыНачисления(Отказ);
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	// Ограничение ФОТ
	ДанныеФОТ = Начисления[0];
	
	Для Каждого КлючИЗначение Из НомераКолонокГрейдов Цикл 
		
		Грейд = КлючИЗначение.Ключ;
		НомерКолонки = КлючИЗначение.Значение;
		
		ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
		
		НаборЗаписей = РегистрыСведений.ОграничениеФОТГрейдов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Грейд.Установить(Грейд);

		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Грейд = Грейд;
		НоваяЗапись.ОграничиватьФОТ = ДанныеФОТ[ИмяКолонки + "ИспользованиеРазрешено"];
		НоваяЗапись.ФОТМин = ?(НоваяЗапись.ОграничиватьФОТ, ДанныеФОТ[ИмяКолонки + "РазмерМин"], 0);
		НоваяЗапись.ФОТМакс = ?(НоваяЗапись.ОграничиватьФОТ, ДанныеФОТ[ИмяКолонки + "РазмерМакс"], 0);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	// Начисления и показатели
	МассивНачисленийПоказателей = ОбщегоНазначения.ВыгрузитьКолонку(Начисления, "НачислениеПоказатель");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивНачисленийПоказателей", МассивНачисленийПоказателей);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	НачисленияПоказатели.Ссылка КАК НачислениеПоказатель,
	               |	НачисленияПоказатели.Показатель КАК Показатель
	               |ИЗ
	               |	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
	               |ГДЕ
	               |	НачисленияПоказатели.ЗапрашиватьПриВводе
	               |	И НачисленияПоказатели.Ссылка В(&МассивНачисленийПоказателей)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ПоказателиРасчетаЗарплаты.Ссылка,
	               |	ПоказателиРасчетаЗарплаты.Ссылка
	               |ИЗ
	               |	Справочник.ПоказателиРасчетаЗарплаты КАК ПоказателиРасчетаЗарплаты
	               |ГДЕ
	               |	ПоказателиРасчетаЗарплаты.Ссылка В(&МассивНачисленийПоказателей)";
				   
	ТаблицаНачисленийПоказателей = Запрос.Выполнить().Выгрузить();			   
	
	Для Каждого КлючИЗначение Из НомераКолонокГрейдов Цикл 
		
		Грейд = КлючИЗначение.Ключ;
		НомерКолонки = КлючИЗначение.Значение;
		
		ИмяКолонки = ИмяКолонкиГрейда(НомерКолонки);
		
		// Использование начислений и показателей.
		НаборЗаписей = РегистрыСведений.ИспользованиеНачисленийПоказателейГрейдов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Грейд.Установить(Грейд);
		
		ИспользуемыеНачисленияПоказатели = Новый Соответствие;
		
		Для Каждого ДанныеНачислений Из Начисления Цикл 
			
			Если ДанныеНачислений.ТипЗначения = 0 Тогда 
				Продолжить;
			КонецЕсли;
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Грейд = Грейд;
			НоваяЗапись.НачислениеПоказатель = ДанныеНачислений.НачислениеПоказатель;
			НоваяЗапись.ИспользованиеРазрешено = ДанныеНачислений[ИмяКолонки + "ИспользованиеРазрешено"];
			НоваяЗапись.РазмерМин = ДанныеНачислений[ИмяКолонки + "РазмерМин"];
			НоваяЗапись.РазмерМакс = ДанныеНачислений[ИмяКолонки + "РазмерМакс"];
			
			Если ДанныеНачислений[ИмяКолонки + "ИспользованиеРазрешено"] Тогда 
				ИспользуемыеНачисленияПоказатели.Вставить(ДанныеНачислений.НачислениеПоказатель, Истина);
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
		// Значения показателей
		НаборЗаписей = РегистрыСведений.ЗначенияПоказателейРасчетаЗарплатыГрейдов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Грейд.Установить(Грейд);
		
		УникальныеПоказатели = Новый Соответствие;
		Для Каждого СтрокаНачисленийПоказателей Из ТаблицаНачисленийПоказателей Цикл 
			Если УникальныеПоказатели[СтрокаНачисленийПоказателей.Показатель] = Неопределено 
				И ИспользуемыеНачисленияПоказатели[СтрокаНачисленийПоказателей.НачислениеПоказатель] <> Неопределено Тогда 
				
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Грейд = Грейд;
				НоваяЗапись.Показатель = СтрокаНачисленийПоказателей.Показатель;
				
				ПоказателиГрейда = ЗначенияПоказателейГрейдов.Получить(НомерКолонки);
				Если ПоказателиГрейда <> Неопределено Тогда 
					ЗначенияПоказателя = ПоказателиГрейда[СтрокаНачисленийПоказателей.Показатель];
					Если ЗначенияПоказателя <> Неопределено Тогда 
						НоваяЗапись.ЗначениеМин = ЗначенияПоказателя.ЗначениеМин;
						НоваяЗапись.ЗначениеМакс = ЗначенияПоказателя.ЗначениеМакс;
					КонецЕсли;
				КонецЕсли;
				
				УникальныеПоказатели.Вставить(СтрокаНачисленийПоказателей.Показатель, Истина);
				
			КонецЕсли;
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	Модифицированность = Ложь;
	
	ПрочитатьДанныеГрейдов();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеТаблицыНачисления(Отказ)
	
	УникальныеНачисленияПоказатели = Новый Соответствие;
	
	ИндексСтроки = -1;
	
	Для Каждого ДанныеНачисления Из Начисления Цикл 
		
		ИндексСтроки = ИндексСтроки + 1;
		
		Если ДанныеНачисления.ТипЗначения = 0 Тогда 
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеНачисления.НачислениеПоказатель) Тогда 
			ТекстОшибки = НСтр("ru = 'Не указано начисление (показатель).'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Начисления[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].НачислениеПоказатель", , Отказ);
			Продолжить;
		КонецЕсли;
		
		Если УникальныеНачисленияПоказатели[ДанныеНачисления.НачислениеПоказатель] = Неопределено Тогда
			УникальныеНачисленияПоказатели.Вставить(ДанныеНачисления.НачислениеПоказатель, Истина);
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о начислении (показателе) %1 была введена в списке ранее.'"), ДанныеНачисления.НачислениеПоказатель);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "Начисления[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].НачислениеПоказатель", , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Ограничение ФОТ'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Начисления.ТипЗначения");
	ЭлементОтбора.ПравоеЗначение = 0;
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("НачисленияНачисление");
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаКнопки);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Начисления.ТипЗначения");
	ЭлементОтбора.ПравоеЗначение = 0;
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Начисления");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Результат, ДополнительныеПараметры) Экспорт 
	
	Отказ = Ложь;
	СохранитьДанныеГрейдов(Отказ);
	
	Если Не Отказ Тогда 
		Оповестить("ИзмененыДанныеГрейдов", , ЭтотОбъект.ВладелецФормы);
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДанныеГрейдовПоУмолчанию(ТекущиеДанные)
	
	Для Каждого КлючИЗначение Из НомераКолонокГрейдов Цикл 
		ИмяКолонки = ИмяКолонкиГрейда(КлючИЗначение.Значение);
		ТекущиеДанные[ИмяКолонки + "ИспользованиеРазрешено"] = Ложь;
		ТекущиеДанные[ИмяКолонки + "РазмерМин"] = 0;
		ТекущиеДанные[ИмяКолонки + "РазмерМакс"] = 0;
		ТекущиеДанные[ИмяКолонки] = НСтр("ru = 'Не используется'");
	КонецЦикла;
	
	Если ТипЗнч(ТекущиеДанные.НачислениеПоказатель) = Тип("ПланВидовРасчетаСсылка.Начисления") Тогда
		Если Не ЗначениеЗаполнено(ТекущиеДанные.НачислениеПоказатель) Тогда 
			ТекущиеДанные.ТипЗначения = 1;
			Возврат;
		КонецЕсли;
		ОписаниеНачисления = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ПолучитьИнформациюОВидеРасчета(ТекущиеДанные.НачислениеПоказатель);
		Если ОписаниеНачисления.ЯвляетсяЛьготой Тогда 
			ТекущиеДанные.ТипЗначения = 3;
		Иначе 
			ТекущиеДанные.ТипЗначения = 1;
		КонецЕсли;
	Иначе 
		ТекущиеДанные.ТипЗначения = 2;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
