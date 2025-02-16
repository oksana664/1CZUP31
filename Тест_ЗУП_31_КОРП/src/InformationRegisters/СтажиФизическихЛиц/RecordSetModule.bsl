#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого СтрокаСоСтажем Из ЭтотОбъект Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаСоСтажем.ДатаОтсчета) Тогда
			СтрокаСоСтажем.ДатаОтсчета = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборТолькоПоФизическомуЛицу = Истина;
	Для Каждого ОтборНабора Из ЭтотОбъект.Отбор Цикл
		Если ОтборНабора.Имя = "ФизическоеЛицо" Тогда
			Продолжить;
		ИначеЕсли ОтборНабора.Использование Тогда
			ОтборТолькоПоФизическомуЛицу = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОтборТолькоПоФизическомуЛицу Тогда
		// Проверяем только записываемый набор.
		
		ВидыСтажа = ОбщегоНазначения.ВыгрузитьКолонку(ЭтотОбъект, "ВидСтажа", Истина);
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ВидыСтажа", ВидыСтажа);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыСтажа.Ссылка КАК ВидСтажа,
		|	ВидыСтажа.КатегорияСтажа КАК КатегорияСтажа
		|ИЗ
		|	Справочник.ВидыСтажа КАК ВидыСтажа
		|ГДЕ
		|	ВидыСтажа.Ссылка В(&ВидыСтажа)";
		
		ТаблицаВидовСтажа = Запрос.Выполнить().Выгрузить();
		
		МассивСтрокТаблицы = Новый Массив;
		Для Каждого СтрокаТаблицы Из ТаблицаВидовСтажа Цикл
			Если МассивСтрокТаблицы.Найти(СтрокаТаблицы) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если СтрокаТаблицы.КатегорияСтажа = Перечисления.КатегорииСтажа.Прочее Тогда
				Продолжить;
			КонецЕсли;
			СтруктураОтбора = Новый Структура("КатегорияСтажа", СтрокаТаблицы.КатегорияСтажа);
			СтрокиСтажа = ТаблицаВидовСтажа.НайтиСтроки(СтруктураОтбора);
			Если СтрокиСтажа.Количество() > 1 Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Стаж с категорией ""%1"" уже задан.'"),
				СтрокаТаблицы.КатегорияСтажа);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
				Для Каждого НайденнаяСтрокаТаблицы Из СтрокиСтажа Цикл
					МассивСтрокТаблицы.Добавить(НайденнаяСтрокаТаблицы);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		// Проверяем записываемый набор вместе со значениями в ИБ.
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ЗаписываемыйНабор", ЭтотОбъект.Выгрузить());
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаписываемыйНабор.ФизическоеЛицо,
		|	ЗаписываемыйНабор.ВидСтажа
		|ПОМЕСТИТЬ ВТНабор
		|ИЗ
		|	&ЗаписываемыйНабор КАК ЗаписываемыйНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаписываемыйНабор.ФизическоеЛицо,
		|	ЗаписываемыйНабор.ВидСтажа,
		|	ВидыСтажа.КатегорияСтажа
		|ПОМЕСТИТЬ ВТЗаписываемыйНабор
		|ИЗ
		|	ВТНабор КАК ЗаписываемыйНабор
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыСтажа КАК ВидыСтажа
		|		ПО ЗаписываемыйНабор.ВидСтажа = ВидыСтажа.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтажиФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СтажиФизическихЛиц.ВидСтажа КАК ВидСтажа,
		|	ВидыСтажа.КатегорияСтажа КАК КатегорияСтажа
		|ПОМЕСТИТЬ ВТВидыСтажа
		|ИЗ
		|	РегистрСведений.СтажиФизическихЛиц КАК СтажиФизическихЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗаписываемыйНабор КАК ЗаписываемыйНабор
		|		ПО СтажиФизическихЛиц.ФизическоеЛицо = ЗаписываемыйНабор.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыСтажа КАК ВидыСтажа
		|		ПО СтажиФизическихЛиц.ВидСтажа = ВидыСтажа.Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗаписываемыйНабор.ФизическоеЛицо,
		|	ЗаписываемыйНабор.ВидСтажа,
		|	ЗаписываемыйНабор.КатегорияСтажа
		|ИЗ
		|	ВТЗаписываемыйНабор КАК ЗаписываемыйНабор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВидыСтажа.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВидыСтажа.КатегорияСтажа КАК КатегорияСтажа,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыСтажа.ВидСтажа) КАК ВидСтажа
		|ИЗ
		|	ВТВидыСтажа КАК ВидыСтажа
		|
		|СГРУППИРОВАТЬ ПО
		|	ВидыСтажа.ФизическоеЛицо,
		|	ВидыСтажа.КатегорияСтажа
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыСтажа.ВидСтажа) > 1";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.КатегорияСтажа = Перечисления.КатегорииСтажа.Прочее Тогда
				Продолжить;
			КонецЕсли;
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Стаж с категорией ""%1"" уже задан.'"),	Выборка.КатегорияСтажа);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаписываемыйНабор", ЭтотОбъект.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаписываемыйНабор.ФизическоеЛицо,
	|	ЗаписываемыйНабор.ВидСтажа,
	|	ЗаписываемыйНабор.ДатаОтсчета,
	|	ЗаписываемыйНабор.РазмерМесяцев,
	|	ЗаписываемыйНабор.РазмерДней
	|ПОМЕСТИТЬ ВТНабор
	|ИЗ
	|	&ЗаписываемыйНабор КАК ЗаписываемыйНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(МАКСИМУМ(ВТНабор.ДатаОтсчета), ДЕНЬ, 1) КАК Дата
	|ПОМЕСТИТЬ ВТМаксимальнаяДатаОтсчета
	|ИЗ
	|	ВТНабор КАК ВТНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Стажи.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА ВидыСтажа.КатегорияСтажа = ЗНАЧЕНИЕ(Перечисление.КатегорииСтажа.Страховой)
	|			ТОГДА РАЗНОСТЬДАТ(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(Стажи.ДатаОтсчета, ДЕНЬ, -Стажи.РазмерДней), МЕСЯЦ, -Стажи.РазмерМесяцев), ВТМаксимальнаяДатаОтсчета.Дата, ДЕНЬ)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДнейСтажа,
	|	ВЫБОР
	|		КОГДА ВидыСтажа.КатегорияСтажа = ЗНАЧЕНИЕ(Перечисление.КатегорииСтажа.РасширенныйСтраховой)
	|			ТОГДА РАЗНОСТЬДАТ(ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(Стажи.ДатаОтсчета, ДЕНЬ, -Стажи.РазмерДней), МЕСЯЦ, -Стажи.РазмерМесяцев), ВТМаксимальнаяДатаОтсчета.Дата, ДЕНЬ)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДнейРасширенногоСтажа
	|ИЗ
	|	ВТНабор КАК Стажи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТМаксимальнаяДатаОтсчета КАК ВТМаксимальнаяДатаОтсчета
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыСтажа КАК ВидыСтажа
	|		ПО Стажи.ВидСтажа = ВидыСтажа.Ссылка
	|ГДЕ
	|	ВидыСтажа.КатегорияСтажа В (ЗНАЧЕНИЕ(Перечисление.КатегорииСтажа.РасширенныйСтраховой), ЗНАЧЕНИЕ(Перечисление.КатегорииСтажа.Страховой))
	|ИТОГИ
	|	СУММА(ДнейСтажа),
	|	СУММА(ДнейРасширенногоСтажа)
	|ПО
	|	ФизическоеЛицо";
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ВыборкаСтажей = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаСтажей.Следующий() Цикл
			Если ЗначениеЗаполнено(ВыборкаСтажей.ДнейРасширенногоСтажа) И ВыборкаСтажей.ДнейСтажа > ВыборкаСтажей.ДнейРасширенногоСтажа Тогда
				ТекстОшибки = НСтр("ru = '%1: Расширенный страховой стаж не может быть меньше обычного страхового'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВыборкаСтажей.ФизическоеЛицо);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,, Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ДатаОтсчетаПериодическихСведений = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.Период <> ДатаОтсчетаПериодическихСведений Тогда
			
			Если Запись.Период < Запись.ДатаОтсчета Тогда
				
				СтруктураЗаписи = Новый Структура("Период,ФизическоеЛицо,ВидСтажа");
				ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
				
				КлючЗаписи = РегистрыСведений.СтажиФизическихЛиц.СоздатьКлючЗаписи(СтруктураЗаписи);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='Период изменения сведений не может быть меньше даты отсчета стажа'"),
					КлючЗаписи, "Запись.Период", , Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
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
	
	ИменаПолей = ОбменДаннымиЗарплатаКадры.ИменаПолейОграниченияРегистрацииРегистраСведений();
	ИменаПолей.ФизическиеЛица = "ФизическоеЛицо";
	ИменаПолей.ДатыПолученияДанных = "Период";
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	
КонецФункции

#КонецОбласти 

#КонецЕсли
