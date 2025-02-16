#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		МетаданныеОбъекта = ЭтотОбъект.Метаданные();
		Для Каждого ПараметрЗаполнения Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(ПараметрЗаполнения.Ключ)<>Неопределено Тогда
				ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
			Иначе
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ПараметрЗаполнения.Ключ) Тогда
					ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПодготовкаСпецоценкиУсловийТруда") Тогда
		
		ЭтотОбъект.ДокументОснование = ДанныеЗаполнения;
		
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			ЭтотОбъект.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Организация");
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодготовкаСпецоценкиУсловийТруда.Исполнитель,
		|	ПодготовкаСпецоценкиУсловийТруда.ДатаНачала,
		|	ПодготовкаСпецоценкиУсловийТруда.ДатаОкончания,
		|	ПодготовкаСпецоценкиУсловийТруда.РабочиеМеста.(
		|		РабочееМесто,
		|		ПредставлениеРабочегоМеста
		|	),
		|	ПодготовкаСпецоценкиУсловийТруда.АналогичныеМеста.(
		|		РабочееМесто,
		|		АналогичноеМесто
		|	),
		|	ПодготовкаСпецоценкиУсловийТруда.Комиссия.(
		|		ЧленКомиссии,
		|		Должность,
		|		РольВКомиссии
		|	)
		|ИЗ
		|	Документ.ПодготовкаСпецоценкиУсловийТруда КАК ПодготовкаСпецоценкиУсловийТруда
		|ГДЕ
		|	ПодготовкаСпецоценкиУсловийТруда.Ссылка = &ДокументОснование";
		
		ЭтотОбъект.РабочиеМеста.Очистить();
		ЭтотОбъект.АналогичныеМеста.Очистить();
		ЭтотОбъект.Комиссия.Очистить();
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЭтотОбъект.Исполнитель = Выборка.Исполнитель;
			ЭтотОбъект.ДатаНачала = Выборка.ДатаНачала;
			ЭтотОбъект.ДатаРезультатов = Выборка.ДатаОкончания;
			ВыборкаРабочихМест = Выборка.РабочиеМеста.Выбрать();
			Пока ВыборкаРабочихМест.Следующий() Цикл
				СтрокаРабочегоМеста = ЭтотОбъект.РабочиеМеста.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаРабочегоМеста, ВыборкаРабочихМест);
			КонецЦикла;
			ВыборкаАналогичныхМест = Выборка.АналогичныеМеста.Выбрать();
			Пока ВыборкаАналогичныхМест.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(ЭтотОбъект.АналогичныеМеста.Добавить(), ВыборкаАналогичныхМест);
			КонецЦикла;
			ВыборкаКомиссии = Выборка.Комиссия.Выбрать();
			Пока ВыборкаКомиссии.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(ЭтотОбъект.Комиссия.Добавить(), ВыборкаКомиссии);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Дата начала'"), , , Ложь);
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаРезультатов, "Объект.ДатаРезультатов", Отказ, НСтр("ru='Дата результатов'"), , , Ложь);
	
	КоличествоЧленовКомиссии = ЭтотОбъект.Комиссия.Количество();
	
	Если КоличествоЧленовКомиссии = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Не заполнен состав комиссии.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , "Объект", Отказ);
	Иначе
		Если Цел(КоличествоЧленовКомиссии/2) = КоличествоЧленовКомиссии/2 Тогда
			ТекстОшибки = НСтр("ru = 'Количество членов комиссии должно быть нечетным.'");
			Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Комиссия[%1].%2", Комиссия.Количество()-1, "НомерСтроки");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , Поле, "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	КоличествоПредседателей = 0;
	Для каждого СтрокаКомиссии Из Комиссия Цикл
		Если СтрокаКомиссии.РольВКомиссии = Перечисления.РолиЧленовКомиссииОхраныТруда.Председатель Тогда
			КоличествоПредседателей = КоличествоПредседателей + 1;
		КонецЕсли;
	КонецЦикла;
	Если КоличествоПредседателей > 1 Тогда
		ТекстОшибки = НСтр("ru = 'Председатель в комиссии должен быть один.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , "Объект", Отказ);
	ИначеЕсли КоличествоПредседателей = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Не указан председатель комиссии.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , "Объект", Отказ);
	КонецЕсли;
	
	Если ДатаНачала > ДатаРезультатов Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Дата результатов не может быть меньше даты начала проведения спецоценки условий труда'"), ЭтотОбъект, "ДатаРезультатов", ,Отказ);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РабочиеМеста", РабочиеМеста.Выгрузить());
	Запрос.УстановитьПараметр("АналогичныеМеста", АналогичныеМеста.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РабочиеМеста.РабочееМесто,
	|	РабочиеМеста.НомерСтроки,
	|	РабочиеМеста.ПредставлениеРабочегоМеста
	|ПОМЕСТИТЬ ВТРабочиеМеста
	|ИЗ
	|	&РабочиеМеста КАК РабочиеМеста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АналогичныеМеста.РабочееМесто,
	|	АналогичныеМеста.АналогичноеМесто
	|ПОМЕСТИТЬ ВТАналогичныеМеста
	|ИЗ
	|	&АналогичныеМеста КАК АналогичныеМеста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РабочиеМеста.РабочееМесто,
	|	РабочиеМеста.НомерСтроки,
	|	РабочиеМеста.АналогичноеМесто,
	|	РабочиеМеста.ГруппаАналогичныхМест
	|ИЗ
	|	(ВЫБРАТЬ
	|		РабочиеМеста.РабочееМесто КАК РабочееМесто,
	|		РабочиеМеста.НомерСтроки КАК НомерСтроки,
	|		ЛОЖЬ КАК АналогичноеМесто,
	|		НЕОПРЕДЕЛЕНО КАК ГруппаАналогичныхМест
	|	ИЗ
	|		ВТРабочиеМеста КАК РабочиеМеста
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРабочиеМеста КАК РабочиеМестаДубль
	|			ПО РабочиеМеста.РабочееМесто = РабочиеМестаДубль.РабочееМесто
	|				И РабочиеМеста.НомерСтроки <> РабочиеМестаДубль.НомерСтроки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РабочиеМеста.РабочееМесто,
	|		РабочиеМеста.НомерСтроки,
	|		ИСТИНА,
	|		ПредставленияРабочихМест.ПредставлениеРабочегоМеста
	|	ИЗ
	|		ВТРабочиеМеста КАК РабочиеМеста
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТАналогичныеМеста КАК АналогичныеМеста
	|				ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМеста КАК ПредставленияРабочихМест
	|				ПО АналогичныеМеста.РабочееМесто = ПредставленияРабочихМест.РабочееМесто
	|			ПО РабочиеМеста.РабочееМесто = АналогичныеМеста.АналогичноеМесто) КАК РабочиеМеста
	|
	|СГРУППИРОВАТЬ ПО
	|	РабочиеМеста.РабочееМесто,
	|	РабочиеМеста.НомерСтроки,
	|	РабочиеМеста.АналогичноеМесто,
	|	РабочиеМеста.ГруппаАналогичныхМест
	|
	|УПОРЯДОЧИТЬ ПО
	|	РабочиеМеста.РабочееМесто";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.СледующийПоЗначениюПоля("РабочееМесто") Цикл
		Если Выборка.АналогичноеМесто Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Рабочее место ""%1"" используется в группе аналогичных мест ""%2""'"),
				Выборка.РабочееМесто,
				Выборка.ГруппаАналогичныхМест);
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Рабочее место ""%1"" используется в нескольких строках:'") + " ",
				Выборка.РабочееМесто);
			Пока Выборка.Следующий() Цикл
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1 %2,'"),
					ТекстОшибки,
					Выборка.НомерСтроки);
			КонецЦикла;
			СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ТекстОшибки, 1);
		КонецЕсли;
		Поле = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("РабочиеМеста[%1].%2", Выборка.НомерСтроки-1, "РабочееМесто");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , Поле, "Объект", Отказ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("РабочиеМеста", ЭтотОбъект.РабочиеМеста.Выгрузить());
	Запрос.УстановитьПараметр("АналогичныеМеста", ЭтотОбъект.АналогичныеМеста.Выгрузить());
	
	// Очистим не используемые аналогичные места
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РабочиеМеста.РабочееМесто
	|ПОМЕСТИТЬ ВТРабочиеМеста
	|ИЗ
	|	&РабочиеМеста КАК РабочиеМеста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АналогичныеМеста.РабочееМесто,
	|	АналогичныеМеста.АналогичноеМесто
	|ПОМЕСТИТЬ ВТАналогичныеМеста
	|ИЗ
	|	&АналогичныеМеста КАК АналогичныеМеста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АналогичныеМеста.РабочееМесто,
	|	АналогичныеМеста.АналогичноеМесто
	|ИЗ
	|	ВТАналогичныеМеста КАК АналогичныеМеста
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМеста КАК РабочиеМеста
	|		ПО АналогичныеМеста.РабочееМесто = РабочиеМеста.РабочееМесто
	|ГДЕ
	|	РабочиеМеста.РабочееМесто ЕСТЬ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НайденныеСтроки = ЭтотОбъект.АналогичныеМеста.НайтиСтроки(
			Новый Структура("РабочееМесто, АналогичноеМесто", Выборка.РабочееМесто, Выборка.АналогичноеМесто));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ЭтотОбъект.АналогичныеМеста.Удалить(НайденнаяСтрока);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	СформироватьДвиженияПоРезультатамСпециальнойОценкиУсловийТруда(Движения, ДанныеДляПроведения);
	
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
	
	ПозицииДокумента = РабочиеМеста.ВыгрузитьКолонку("РабочееМесто");
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПозицииДокумента, АналогичныеМеста.ВыгрузитьКолонку("РабочееМесто"), Истина);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПозицииДокумента, АналогичныеМеста.ВыгрузитьКолонку("АналогичноеМесто"), Истина);
	
	Возврат ОбменДаннымиЗарплатаКадрыРасширенный.ОграниченияРегистрацииПоПозициямШтатногоРасписания(ЭтотОбъект, ПозицииДокумента, Организация);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПереченьРабочихМест() Экспорт
	
	РезультатыЗапроса = ОхранаТруда.ДанныеПоРабочимМестам(ЭтотОбъект.Организация, ЭтотОбъект.Дата);
	
	ЭтотОбъект.РабочиеМеста.Очистить();
	ЭтотОбъект.АналогичныеМеста.Очистить();
	
	Выборка = РезультатыЗапроса.Получить(РезультатыЗапроса.ВГраница() - 1).Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("РабочееМесто") Цикл
		НоваяСтрока = ЭтотОбъект.РабочиеМеста.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Пока Выборка.Следующий() Цикл
			Если ЗначениеЗаполнено(Выборка.АналогичноеМесто) Тогда
				НоваяСтрока = ЭтотОбъект.АналогичныеМеста.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ЭтотОбъект.Комиссия.Загрузить(РезультатыЗапроса.Получить(РезультатыЗапроса.ВГраница()-2).Выгрузить());
	
КонецПроцедуры

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РезультатыСпецоценкиУсловийТруда.ДатаРезультатов КАК Период,
	|	РезультатыСпецоценкиУсловийТрудаРабочиеМеста.РабочееМесто,
	|	РезультатыСпецоценкиУсловийТрудаРабочиеМеста.КлассУсловийТруда,
	|	ДОБАВИТЬКДАТЕ(РезультатыСпецоценкиУсловийТруда.ДатаРезультатов, ГОД, 5) КАК ДатаБлижайшейОценки,
	|	РезультатыСпецоценкиУсловийТрудаРабочиеМеста.Ссылка КАК Документ,
	|	РезультатыСпецоценкиУсловийТруда.Организация КАК Организация
	|ПОМЕСТИТЬ ВТРабочиеМеста
	|ИЗ
	|	Документ.РезультатыСпецоценкиУсловийТруда.РабочиеМеста КАК РезультатыСпецоценкиУсловийТрудаРабочиеМеста
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РезультатыСпецоценкиУсловийТруда КАК РезультатыСпецоценкиУсловийТруда
	|		ПО РезультатыСпецоценкиУсловийТрудаРабочиеМеста.Ссылка = РезультатыСпецоценкиУсловийТруда.Ссылка
	|ГДЕ
	|	РезультатыСпецоценкиУсловийТрудаРабочиеМеста.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РабочиеМеста.Период,
	|	РабочиеМеста.РабочееМесто,
	|	РабочиеМеста.КлассУсловийТруда,
	|	РабочиеМеста.ДатаБлижайшейОценки,
	|	РабочиеМеста.Организация
	|ИЗ
	|	ВТРабочиеМеста КАК РабочиеМеста
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РабочиеМеста.Период,
	|	РезультатыСпецоценкиУсловийТрудаАналогичныеМеста.АналогичноеМесто,
	|	РабочиеМеста.КлассУсловийТруда,
	|	РабочиеМеста.ДатаБлижайшейОценки,
	|	РабочиеМеста.Организация
	|ИЗ
	|	Документ.РезультатыСпецоценкиУсловийТруда.АналогичныеМеста КАК РезультатыСпецоценкиУсловийТрудаАналогичныеМеста
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРабочиеМеста КАК РабочиеМеста
	|		ПО РезультатыСпецоценкиУсловийТрудаАналогичныеМеста.РабочееМесто = РабочиеМеста.РабочееМесто
	|			И РезультатыСпецоценкиУсловийТрудаАналогичныеМеста.Ссылка = РабочиеМеста.Документ";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура СформироватьДвиженияПоРезультатамСпециальнойОценкиУсловийТруда(Движения, ДанныеДляПроведения)
	
	Выборка = ДанныеДляПроведения.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Движения.РезультатыСпециальнойОценкиУсловийТруда.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НоваяСтрока = Движения.ПлановыеДатыСпециальнойОценкиУсловийТруда.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	Движения.РезультатыСпециальнойОценкиУсловийТруда.Записывать = Истина;
	Движения.ПлановыеДатыСпециальнойОценкиУсловийТруда.Записывать = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

