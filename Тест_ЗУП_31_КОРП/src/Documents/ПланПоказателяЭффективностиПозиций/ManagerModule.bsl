#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс		

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ОписаниеКоманды = ЗарплатаКадрыРасширенный.ОписаниеКомандыСозданияДокумента(
		"Документ.ПланПоказателяЭффективностиПозиций",
		НСтр("ru = 'План показателя позиций'"));
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокумента(
		КомандыСозданияДокументов, ОписаниеКоманды);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения(Ссылка)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланПоказателяЭффективностиПозицийПозиции.Ссылка.Период КАК ПериодДействия,
		|	ПланПоказателяЭффективностиПозицийПозиции.Позиция КАК Позиция,
		|	ПланПоказателяЭффективностиПозицийПозиции.Ссылка.Показатель КАК Показатель,
		|	ПланПоказателяЭффективностиПозицийПозиции.Значение КАК Значение
		|ИЗ
		|	Документ.ПланПоказателяЭффективностиПозиций.Позиции КАК ПланПоказателяЭффективностиПозицийПозиции
		|ГДЕ
		|	ПланПоказателяЭффективностиПозицийПозиции.Ссылка = &Ссылка
		|	И ПланПоказателяЭффективностиПозицийПозиции.Ссылка.Показатель.ТребуетсяВводПлана";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("ПланПозиций", РезультатЗапроса.Выгрузить());
	
	Возврат ДанныеДляПроведения;

КонецФункции	

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДанныхИзФайла

// Устанавливает параметры загрузки.
//
Процедура УстановитьПараметрыЗагрузкиИзФайлаВТЧ(Параметры) Экспорт
	
КонецПроцедуры

// Производит сопоставление данных, загружаемых в табличную часть ПолноеИмяТабличнойЧасти,
// с данными в ИБ, и заполняет параметры АдресТаблицыСопоставления и СписокНеоднозначностей.
//
// Параметры:
//   АдресЗагружаемыхДанных    - Строка - Адрес временного хранилища с таблицей значений, в которой
//                                        находятся загруженные данные из файла. Состав колонок:
//     * Идентификатор - Число - Порядковый номер строки;
//     * остальные колонки соответствуют колонкам макета ЗагрузкаИзФайла.
//   АдресТаблицыСопоставления - Строка - Адрес временного хранилища с пустой таблицей значений,
//                                        являющейся копией табличной части документа, 
//                                        которую необходимо заполнить из таблицы АдресЗагружаемыхДанных.
//   СписокНеоднозначностей - ТаблицаЗначений - Список неоднозначных значений, для которых в ИБ имеется несколько
//                                              подходящих вариантов.
//     * Колонка       - Строка - Имя колонки, в которой была обнаружена неоднозначность;
//     * Идентификатор - Число  - Идентификатор строки, в которой была обнаружена неоднозначность.
//   ПолноеИмяТабличнойЧасти   - Строка - Полное имя табличной части, в которую загружаются данные.
//   ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура СопоставитьЗагружаемыеДанные(АдресЗагружаемыхДанных, АдресТаблицыСопоставления, СписокНеоднозначностей, ПолноеИмяТабличнойЧасти, ДополнительныеПараметры) Экспорт
	
	Позиции =  ПолучитьИзВременногоХранилища(АдресТаблицыСопоставления);
	ЗагружаемыеДанные = ПолучитьИзВременногоХранилища(АдресЗагружаемыхДанных);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УдалитьВТ = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеДляСопоставления.Позиция КАК СТРОКА(100)) КАК Позиция,
		|	ДанныеДляСопоставления.Значение КАК Значение,
		|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ ДанныеДляСопоставления
		|ИЗ
		|	&ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Позиции.Ссылка КАК Позиция,
		|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ ВТНайденныеПозиции
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтатноеРасписание КАК Позиции
		|		ПО ДанныеДляСопоставления.Позиция = Позиции.Наименование
		|			И (НЕ Позиции.ГруппаПозицийПодразделения)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТНайденныеПозиции.Идентификатор КАК Идентификатор,
		|	КОЛИЧЕСТВО(ВТНайденныеПозиции.Идентификатор) КАК КоличествоСовпадений
		|ПОМЕСТИТЬ ВТКоличествоСовпадений
		|ИЗ
		|	ВТНайденныеПозиции КАК ВТНайденныеПозиции
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТНайденныеПозиции.Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТКоличествоСовпадений.Идентификатор КАК Идентификатор
		|ПОМЕСТИТЬ ВТНеоднозначности
		|ИЗ
		|	ВТКоличествоСовпадений КАК ВТКоличествоСовпадений
		|ГДЕ
		|	ВТКоличествоСовпадений.КоличествоСовпадений > 1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДляСопоставления.Идентификатор КАК Идентификатор,
		|	ВТНайденныеПозиции.Позиция КАК Позиция,
		|	ДанныеДляСопоставления.Значение КАК Значение
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНайденныеПозиции КАК ВТНайденныеПозиции
		|		ПО ДанныеДляСопоставления.Идентификатор = ВТНайденныеПозиции.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНеоднозначности КАК ВТНеоднозначности
		|		ПО ДанныеДляСопоставления.Идентификатор = ВТНеоднозначности.Идентификатор
		|ГДЕ
		|	ВТНеоднозначности.Идентификатор ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеДляСопоставления.Идентификатор,
		|	NULL,
		|	ДанныеДляСопоставления.Значение
		|ИЗ
		|	ДанныеДляСопоставления КАК ДанныеДляСопоставления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНеоднозначности КАК ВТНеоднозначности
		|		ПО ДанныеДляСопоставления.Идентификатор = ВТНеоднозначности.Идентификатор
		|
		|УПОРЯДОЧИТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТНеоднозначности.Идентификатор КАК Идентификатор
		|ИЗ
		|	ВТНеоднозначности КАК ВТНеоднозначности";

	Запрос.УстановитьПараметр("ДанныеДляСопоставления", ЗагружаемыеДанные);
	
	УдалитьВТ.Добавить("ДанныеДляСопоставления");
	УдалитьВТ.Добавить("ВТНайденныеПозиции");
	УдалитьВТ.Добавить("ВТКоличествоСовпадений");
	УдалитьВТ.Добавить("ВТНеоднозначности");
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	РезультатНайденных = РезультатыЗапроса[РезультатыЗапроса.Количество() - 2];
	РезультатНеоднозначностей = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	
	Выборка = РезультатНайденных.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Позиции.Добавить(), Выборка);
	КонецЦикла;
	
	Выборка = РезультатНеоднозначностей.Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Идентификатор") Цикл
		ЗаписьОНеоднозначности = СписокНеоднозначностей.Добавить();
		ЗаписьОНеоднозначности.Идентификатор = Выборка.Идентификатор; 
		ЗаписьОНеоднозначности.Колонка = "Позиция";
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Позиции, АдресТаблицыСопоставления);
	
	ЗарплатаКадры.УничтожитьВТ(Запрос.МенеджерВременныхТаблиц, УдалитьВТ);
	
КонецПроцедуры

// Возвращает список подходящих объектов ИБ для неоднозначного значения ячейки.
// 
// Параметры:
//   ПолноеИмяТабличнойЧасти  - Строка - Полное имя табличной части, в которую загружаются данные.
//  ИмяКолонки                - Строка - Имя колонки, в который возникла неоднозначность.
//  СписокНеоднозначностей    - Массив - Массив для заполнения с неоднозначными данными.
//  ЗагружаемыеЗначенияСтрока - Строка - Загружаемые данные на основании которых возникла неоднозначность.
//  ДополнительныеПараметры   - ЛюбойТип - Любые дополнительные сведения.
//
Процедура ЗаполнитьСписокНеоднозначностей(ПолноеИмяТабличнойЧасти, СписокНеоднозначностей, ИмяКолонки, ЗагружаемыеЗначенияСтрока, ДополнительныеПараметры) Экспорт
	
	Если ИмяКолонки = "Позиция" Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Позиции.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.ШтатноеРасписание КАК Позиции
			|ГДЕ
			|	Позиции.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Наименование", ЗагружаемыеЗначенияСтрока.Позиция);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокНеоднозначностей.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
