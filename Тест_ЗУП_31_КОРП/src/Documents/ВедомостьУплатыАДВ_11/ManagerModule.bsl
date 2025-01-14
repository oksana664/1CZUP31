
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

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииПолученияДанныхДляЗаполненияИПроведенияДокумента

Функция ВыгрузитьФайлыВоВременноеХранилище(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт
	ДанныеФайла = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);
	
	ОписаниеВыгруженногоФайла = ПерсонифицированныйУчет.ОписаниеВыгруженногоФайлаОтчетности();
	
	ОписаниеВыгруженногоФайла.Владелец = Ссылка;
	ОписаниеВыгруженногоФайла.АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
	ОписаниеВыгруженногоФайла.ИмяФайла = ДанныеФайла.ИмяФайла;
	ОписаниеВыгруженногоФайла.ПроверятьCheckXML = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьCheckUFA = Истина;
	
	ВыгруженныеФайлы = Новый Массив;
	ВыгруженныеФайлы.Добавить(ОписаниеВыгруженногоФайла);
	
	Возврат ВыгруженныеФайлы;
КонецФункции	

Функция ПолучитьДанныеОЗадолженности(ОтчетныйПериод, Организация) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОтложенноеПроведениеДокументов") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОтражениеДокументовВУчетеСтраховыхВзносов");
		Модуль.ОтразитьДокументыВУчетеСтраховыхВзносов(Организация);
	КонецЕсли;
	
	ТаблицаЗадолженности = Новый ТаблицаЗначений;
	ТаблицаЗадолженности.Колонки.Добавить("ТипСтроки");
	ТаблицаЗадолженности.Колонки.Добавить("Год");
	ТаблицаЗадолженности.Колонки.Добавить("СтраховаяЧасть");
	ТаблицаЗадолженности.Колонки.Добавить("НакопительнаяЧасть");
	ТаблицаЗадолженности.Колонки.Добавить("ДополнительныйТариф");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НачалоГода", Дата(ОтчетныйПериод, 1, 1));
	Запрос.УстановитьПараметр("КонецГода", КонецГода(Дата(ОтчетныйПериод, 1, 1)));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыПоСтраховымВзносамОстатки.ГодУплаты КАК ГодУплаты,
	|	СУММА(РасчетыПоСтраховымВзносамОстатки.НаСтраховуюЧастьПФР) КАК НаСтраховуюЧастьПФР,
	|	СУММА(РасчетыПоСтраховымВзносамОстатки.НаНакопительнуюЧастьПФР) КАК НаНакопительнуюЧастьПФР
	|ПОМЕСТИТЬ ВТОстаткиПоГодам
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОстатки.ГодЗадолженностиПоЕСН КАК ГодУплаты,
	|		РасчетыПоСтраховымВзносамОстатки.СуммаОстаток КАК НаСтраховуюЧастьПФР,
	|		0 КАК НаНакопительнуюЧастьПФР
	|	ИЗ
	|		РегистрНакопления.РасчетыСФондамиПоСтраховымВзносам.Остатки(
	|				&НачалоГода,
	|				Организация = &Организация И ГодЗадолженностиПоЕСН <> ДАТАВРЕМЯ(1,1,1) И ГодЗадолженностиПоЕСН < ДАТАВРЕМЯ(2010, 1, 1)
	|					И ВидОбязательногоСтрахованияСотрудников = ЗНАЧЕНИЕ(Перечисление.ВидыОбязательногоСтрахованияСотрудников.ПФРСтраховая)
	|					И (НЕ ЭтоСтраховыеВзносы)) КАК РасчетыПоСтраховымВзносамОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ГодЗадолженностиПоЕСН,
	|		0,
	|		РасчетыПоСтраховымВзносамОстатки.СуммаОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСФондамиПоСтраховымВзносам.Остатки(
	|				&НачалоГода,
	|				Организация = &Организация И ГодЗадолженностиПоЕСН <> ДАТАВРЕМЯ(1,1,1) И ГодЗадолженностиПоЕСН < ДАТАВРЕМЯ(2010, 1, 1)
	|					И ВидОбязательногоСтрахованияСотрудников = ЗНАЧЕНИЕ(Перечисление.ВидыОбязательногоСтрахованияСотрудников.ПФРНакопительная)
	|					И (НЕ ЭтоСтраховыеВзносы)) КАК РасчетыПоСтраховымВзносамОстатки) КАК РасчетыПоСтраховымВзносамОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоСтраховымВзносамОстатки.ГодУплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиСВыделеннойПереплатой.ГодУплаты,
	|	СУММА(ОстаткиСВыделеннойПереплатой.НаСтраховуюЧастьПФР) КАК НаСтраховуюЧастьПФР,
	|	СУММА(ОстаткиСВыделеннойПереплатой.НаНакопительнуюЧастьПФР) КАК НаНакопительнуюЧастьПФР
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОстаткиПоГодам.ГодУплаты КАК ГодУплаты,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР > 0
	|				ТОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НаСтраховуюЧастьПФР,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР > 0
	|				ТОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НаНакопительнуюЧастьПФР
	|	ИЗ
	|		ВТОстаткиПоГодам КАК ОстаткиПоГодам
	|	ГДЕ
	|		(ОстаткиПоГодам.НаСтраховуюЧастьПФР >= 0
	|				ИЛИ ОстаткиПоГодам.НаНакопительнуюЧастьПФР >= 0)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОстаткиПоГодам.ГодУплаты + 1,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР < 0
	|				ТОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР < 0
	|				ТОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		ВТОстаткиПоГодам КАК ОстаткиПоГодам
	|	ГДЕ
	|		(ОстаткиПоГодам.НаСтраховуюЧастьПФР <= 0
	|				ИЛИ ОстаткиПоГодам.НаНакопительнуюЧастьПФР <= 0)) КАК ОстаткиСВыделеннойПереплатой
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиСВыделеннойПереплатой.ГодУплаты";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.НаСтраховуюЧастьПФР) Или ЗначениеЗаполнено(Выборка.НаНакопительнуюЧастьПФР) Тогда
			СтрокаНачислено = ТаблицаЗадолженности.Добавить();
			СтрокаНачислено.Год = Выборка.ГодУплаты;
			СтрокаНачислено.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало;
			СтрокаНачислено.НакопительнаяЧасть = Окр(Выборка.НаНакопительнуюЧастьПФР);
			СтрокаНачислено.СтраховаяЧасть = Окр(Выборка.НаСтраховуюЧастьПФР);
		КонецЕсли;
	КонецЦикла;  
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(РасчетыПоСтраховымВзносамОбороты.НаСтраховуюЧастьПФР) КАК НаСтраховуюЧастьПФР,
	|	СУММА(РасчетыПоСтраховымВзносамОбороты.НаНакопительнуюЧастьПФР) КАК НаНакопительнуюЧастьПФР,
	|	РасчетыПоСтраховымВзносамОбороты.ГодУплаты КАК ГодУплаты
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОбороты.ГодЗадолженностиПоЕСН КАК ГодУплаты,
	|		РасчетыПоСтраховымВзносамОбороты.СуммаОборот КАК НаСтраховуюЧастьПФР,
	|		0 КАК НаНакопительнуюЧастьПФР
	|	ИЗ
	|		РегистрНакопления.РасчетыСФондамиПоСтраховымВзносам.Обороты(
	|				&НачалоГода,
	|				&КонецГода,
	|				,
	|				Организация = &Организация
	|					И ГодЗадолженностиПоЕСН <> 0
	|					И ГодЗадолженностиПоЕСН < 2010
	|					И ВидОбязательногоСтрахованияСотрудников = ЗНАЧЕНИЕ(Перечисление.ВидыОбязательногоСтрахованияСотрудников.ПФРСтраховая)
	|					И НЕ ЭтоСтраховыеВзносы) КАК РасчетыПоСтраховымВзносамОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОбороты.ГодЗадолженностиПоЕСН,
	|		0,
	|		РасчетыПоСтраховымВзносамОбороты.СуммаОборот
	|	ИЗ
	|		РегистрНакопления.РасчетыСФондамиПоСтраховымВзносам.Обороты(
	|				&НачалоГода,
	|				&КонецГода,
	|				,
	|				Организация = &Организация
	|					И ГодЗадолженностиПоЕСН <> 0
	|					И ГодЗадолженностиПоЕСН < 2010
	|					И ВидОбязательногоСтрахованияСотрудников = ЗНАЧЕНИЕ(Перечисление.ВидыОбязательногоСтрахованияСотрудников.ПФРНакопительная)
	|					И НЕ ЭтоСтраховыеВзносы) КАК РасчетыПоСтраховымВзносамОбороты) КАК РасчетыПоСтраховымВзносамОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоСтраховымВзносамОбороты.ГодУплаты";	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаНачислено = ТаблицаЗадолженности.Добавить();
		СтрокаНачислено.Год = Выборка.ГодУплаты;
		СтрокаНачислено.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод;
		СтрокаНачислено.НакопительнаяЧасть = Окр(Выборка.НаНакопительнуюЧастьПФР);
		СтрокаНачислено.СтраховаяЧасть = Окр(Выборка.НаСтраховуюЧастьПФР);
	КонецЦикла;  
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыПоСтраховымВзносамОстатки.ГодУплаты КАК ГодУплаты,
	|	СУММА(РасчетыПоСтраховымВзносамОстатки.НаСтраховуюЧастьПФР) КАК НаСтраховуюЧастьПФР,
	|	СУММА(РасчетыПоСтраховымВзносамОстатки.НаНакопительнуюЧастьПФР) КАК НаНакопительнуюЧастьПФР
	|ПОМЕСТИТЬ ВТОстаткиПоГодам
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОстатки.ГодЗадолженностиПоЕСН КАК ГодУплаты,
	|		РасчетыПоСтраховымВзносамОстатки.СуммаОстаток КАК НаСтраховуюЧастьПФР,
	|		0 КАК НаНакопительнуюЧастьПФР
	|	ИЗ
	|		РегистрНакопления.РасчетыСФондамиПоСтраховымВзносам.Остатки(
	|				&КонецГода,
	|				Организация = &Организация
	|					И ГодЗадолженностиПоЕСН <> 0
	|					И ГодЗадолженностиПоЕСН < 2010
	|					И ВидОбязательногоСтрахованияСотрудников = ЗНАЧЕНИЕ(Перечисление.ВидыОбязательногоСтрахованияСотрудников.ПФРСтраховая)
	|					И НЕ ЭтоСтраховыеВзносы) КАК РасчетыПоСтраховымВзносамОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		РасчетыПоСтраховымВзносамОстатки.ГодЗадолженностиПоЕСН,
	|		0,
	|		РасчетыПоСтраховымВзносамОстатки.СуммаОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСФондамиПоСтраховымВзносам.Остатки(
	|				&КонецГода,
	|				Организация = &Организация
	|					И ГодЗадолженностиПоЕСН <> 0
	|					И ГодЗадолженностиПоЕСН < 2010
	|					И ВидОбязательногоСтрахованияСотрудников = ЗНАЧЕНИЕ(Перечисление.ВидыОбязательногоСтрахованияСотрудников.ПФРНакопительная)
	|					И НЕ ЭтоСтраховыеВзносы) КАК РасчетыПоСтраховымВзносамОстатки) КАК РасчетыПоСтраховымВзносамОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоСтраховымВзносамОстатки.ГодУплаты
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ГодУплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиСВыделеннойПереплатой.ГодУплаты,
	|	СУММА(ОстаткиСВыделеннойПереплатой.НаСтраховуюЧастьПФР) КАК НаСтраховуюЧастьПФР,
	|	СУММА(ОстаткиСВыделеннойПереплатой.НаНакопительнуюЧастьПФР) КАК НаНакопительнуюЧастьПФР
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОстаткиПоГодам.ГодУплаты КАК ГодУплаты,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР > 0
	|				ТОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НаСтраховуюЧастьПФР,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР > 0
	|				ТОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НаНакопительнуюЧастьПФР
	|	ИЗ
	|		ВТОстаткиПоГодам КАК ОстаткиПоГодам
	|	ГДЕ
	|		(ОстаткиПоГодам.НаСтраховуюЧастьПФР >= 0
	|				ИЛИ ОстаткиПоГодам.НаНакопительнуюЧастьПФР >= 0)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОстаткиПоГодам.ГодУплаты + 1,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР < 0
	|				ТОГДА ОстаткиПоГодам.НаСтраховуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР < 0
	|				ТОГДА ОстаткиПоГодам.НаНакопительнуюЧастьПФР
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		ВТОстаткиПоГодам КАК ОстаткиПоГодам
	|	ГДЕ
	|		(ОстаткиПоГодам.НаСтраховуюЧастьПФР <= 0
	|				ИЛИ ОстаткиПоГодам.НаНакопительнуюЧастьПФР <= 0)) КАК ОстаткиСВыделеннойПереплатой
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиСВыделеннойПереплатой.ГодУплаты";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.НаСтраховуюЧастьПФР) Или ЗначениеЗаполнено(Выборка.НаНакопительнуюЧастьПФР) Тогда
			СтрокаНачислено = ТаблицаЗадолженности.Добавить();
			СтрокаНачислено.Год = Выборка.ГодУплаты;
			СтрокаНачислено.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец;
			СтрокаНачислено.НакопительнаяЧасть = Окр(Выборка.НаНакопительнуюЧастьПФР);
			СтрокаНачислено.СтраховаяЧасть = Окр(Выборка.НаСтраховуюЧастьПФР);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаЗадолженности;
КонецФункции

Функция СформироватьЗапросПоШапкеДокументаДляПечати(МассивСсылок)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ВедомостьУплатыАДВ_11";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = МассивСсылок;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьУплатыАДВ_11.Ссылка КАК Ссылка,
	|	ВедомостьУплатыАДВ_11.Организация КАК Организация,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.НаименованиеПолное КАК НаименованиеПолное,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК НаименованиеСокращенное,
	|	СведенияОбОрганизациях.ИНН КАК ИНН,
	|	СведенияОбОрганизациях.КПП КАК КПП,
	|	ВедомостьУплатыАДВ_11.ОтчетныйПериод КАК Год,
	|	ВедомостьУплатыАДВ_11.ОкончаниеОтчетногоПериода КАК ОкончаниеОтчетногоПериода,
	|	ВедомостьУплатыАДВ_11.Дата,
	|	ВедомостьУплатыАДВ_11.Руководитель КАК Руководитель,
	|	ВедомостьУплатыАДВ_11.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ВедомостьУплатыАДВ_11.НомерПачки,
	|	СведенияОбОрганизациях.КодПоОКПО КАК КодПоОКПО
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьУплатыАДВ_11 КАК ВедомостьУплатыАДВ_11
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ВедомостьУплатыАДВ_11.Организация = СведенияОбОрганизациях.Организация
	|			И ВедомостьУплатыАДВ_11.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	ВедомостьУплатыАДВ_11.Ссылка В(&МассивСсылок)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	Руководитель";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
		
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьУплатыАДВ_11.Ссылка КАК Ссылка,
	|	ВедомостьУплатыАДВ_11.РегистрационныйНомерПФР КАК РегНомерПФР,
	|	ВедомостьУплатыАДВ_11.НаименованиеПолное КАК НаименованиеПолное,
	|	ВедомостьУплатыАДВ_11.НаименованиеСокращенное КАК НаименованиеСокращенное,
	|	ВедомостьУплатыАДВ_11.ИНН КАК ИНН,
	|	ВедомостьУплатыАДВ_11.КПП КАК КПП,
	|	ВедомостьУплатыАДВ_11.КодПоОКПО КАК ОКПО,
	|	ВедомостьУплатыАДВ_11.Год КАК Год,
	|	ЕСТЬNULL(ВТФИОПоследние.РасшифровкаПодписи, """") КАК Руководитель,
	|	ВедомостьУплатыАДВ_11.ДолжностьРуководителя КАК ДолжностьРуководителя,
	|	ВедомостьУплатыАДВ_11.Дата,
	|	ВедомостьУплатыАДВ_11.НомерПачки
	|ИЗ
	|	ВТДанныеДокументов КАК ВедомостьУплатыАДВ_11
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОПоследние
	|		ПО ВедомостьУплатыАДВ_11.Ссылка = ВТФИОПоследние.Ссылка
	|			И ВедомостьУплатыАДВ_11.Руководитель = ВТФИОПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоСтрокаЗадолженности(МассивСсылок)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.Ссылка КАК Ссылка,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.НомерСтроки,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.Год КАК Год,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.СтраховаяЧасть,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.НакопительнаяЧасть,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.ДополнительныйТариф,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.ТипСтроки КАК ТипСтроки
	|ИЗ
	|	Документ.ВедомостьУплатыАДВ_11.СведенияОЗадолженности КАК ВедомостьУплатыАДВ_11СведенияОЗадолженности
	|ГДЕ
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.Ссылка В(&МассивСсылок)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	ТипСтроки,
	|	Год";
	
	Возврат Запрос.Выполнить();
КонецФункции	

#КонецОбласти

#Область ДляОбеспеченияФормированияВыходногоФайла

Функция СформироватьВыходнойФайл(ВыборкаПоШапкеДокумента, ВыборкаПоЗадолженности)
	
	// Формирование файла версии 07.00.

	// Загружаем формат файла сведений.
	ДеревоФорматаXML = ПолучитьОбщийМакет("ФорматПФР70XML");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();
	
	ДеревоФормата = ЗарплатаКадры.ЗагрузитьXMLВДокументDOM(ТекстФорматаXML);
	
	НомерДокументаВПачке = 1;
	// Создаем начальное дерево
	ДеревоВыгрузки = ЗарплатаКадры.СоздатьДеревоXML();
			
	УзелПФР = ПерсонифицированныйУчет.УзелФайлаПФР(ДеревоВыгрузки);
	
	ПерсонифицированныйУчет.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, ДеревоФормата, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР);
	
	// Добавляем реквизит ПачкаВходящихДокументов.
	УзелПачкаВходящихДокументов = ПерсонифицированныйУчет.ЗаполнитьНаборЗаписейВходящаяОпись(УзелПФР, ДеревоФормата, "ВЕДОМОСТЬ_УПЛАТЫ", ВыборкаПоШапкеДокумента, 1, НомерДокументаВПачке);
	
	НаборЗаписейВедомостьУплаты = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "ВЕДОМОСТЬ_УПЛАТЫ");		
	
	НомерДокументаВПачке = НомерДокументаВПачке + 1;
	НаборЗаписейВедомостьУплаты.НомерВПачке.Значение = НомерДокументаВПачке;
	
	// Страхователь
	НаборЗаписейСтрахователь = НаборЗаписейВедомостьУплаты.Страхователь.Значение;
	ПерсонифицированныйУчет.ЗаполнитьСоставительПачки(НаборЗаписейСтрахователь, ВыборкаПоШапкеДокумента);
	
	НаборЗаписейВедомостьУплаты.РасчетныйПериод.Значение = ВыборкаПоШапкеДокумента.ОтчетныйПериод;
	НаборЗаписейВедомостьУплаты.ДатаВедомости.Значение = Дата(ВыборкаПоШапкеДокумента.ОтчетныйПериод, 12, 31);
	НаборЗаписейВедомостьУплаты.ТипАДВ__11.Значение = "ПОЛНАЯ";	
	// ЧислоПачек
	НаборЗаписейВедомостьУплаты.ЧислоПачек.Значение = 0;
	
	// ЧислоЗастрахованныхЛиц
	НаборЗаписейВедомостьУплаты.ЧислоЗастрахованныхЛиц.Значение = 0;
	
	НаборЗаписейТариф = НаборЗаписейВедомостьУплаты.Тариф.Значение;
	НаборЗаписейТариф.КодКатегории = ПерсонифицированныйУчет.ПолучитьИмяЭлементаПеречисленияПоЗначению(ВыборкаПоШапкеДокумента.КодКатегории);
	
	// ЗадолженностьНаНачало
	ФорматЗадолженностьНаНачало = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(НаборЗаписейВедомостьУплаты.ЗадолженностьНаНачало);
	НаборЗаписейВедомостьУплаты.ЗадолженностьНаНачало.Значение.Удалить("СуммаЗаПериод");
	ФорматСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматЗадолженностьНаНачало.Значение.СуммаЗаПериод.Значение);
	
	// УплатаЗаПериод
	НаборЗаписейВедомостьУплаты.УплатаЗаПериод.Значение.Удалить("СуммаЗаПериод");
	
	// ЗадолженностьНаКонец
	НаборЗаписейВедомостьУплаты.ЗадолженностьНаКонец.Значение.Удалить("СуммаЗаПериод");
	
	НаборЗаписейВедомостьУплаты.ДатаЗаполнения.Значение = ВыборкаПоШапкеДокумента.Дата;
	УзелВедомостьУплаты = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "ВЕДОМОСТЬ_УПЛАТЫ","");
	ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелВедомостьУплаты, НаборЗаписейВедомостьУплаты);
	
	УзелЗадолженностьНаНачало = УзелВедомостьУплаты.Строки.Найти("ЗадолженностьНаНачало");
	УзелЗадолженностьНаНачало.Строки.Очистить();
	УзелНачисленоЗаПериод = УзелВедомостьУплаты.Строки.Найти("НачисленияЗаПериод");
	УзелУплатаЗаПериод = УзелВедомостьУплаты.Строки.Найти("УплатаЗаПериод");
	УзелУплатаЗаПериод.Строки.Очистить();
	УзелЗадолженностьНаКонец = УзелВедомостьУплаты.Строки.Найти("ЗадолженностьНаКонец");
	УзелЗадолженностьНаКонец.Строки.Очистить();
	
	// Обработаем расчеты по годам.
	ВсегоДолгНаНачалоСтраховаяЧасть = 0;
	ВсегоДолгНаНачалоНакопительнаяЧасть = 0;
	ВсегоДолгНаНачалоДополнительныйТариф = 0;
	ВсегоУплаченоСтраховаяЧасть = 0;
	ВсегоУплаченоНакопительнаяЧасть = 0;
	ВсегоУплаченоДополнительныйТариф = 0;
	ВсегоЗадолженностьСтраховаяЧасть = 0;
	ВсегоЗадолженностьНакопительнаяЧасть = 0;
	ВсегоЗадолженностьДополнительныйТариф = 0;
	
	ЧислоСтрокЗНЧЛ 		= 0;// Строки задолженности на начало.
	ЧислоСтрокУПЛЧ 		= 0;// Строки уплачено по годам
	ЧислоСтрокЗКНЦ 		= 0;// Строки задолженность на конец.
	ЧислоСтрокНачислено = 0;
	
	Пока ВыборкаПоЗадолженности.Следующий() Цикл
		
		Если ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало Тогда
			ЧислоСтрокЗНЧЛ = ЧислоСтрокЗНЧЛ + 1;
			
			НаборЗаписейСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматСуммаЗаПериод);
			
			НаборЗаписейСуммаЗаПериод.ТипСтроки.Значение = "ДЕТАЛЬНАЯ";
			НаборЗаписейСуммаЗаПериод.РасчетныйПериод.Значение = ВыборкаПоЗадолженности.Год;
			НаборЗаписейСтраховыеВзносы = НаборЗаписейСуммаЗаПериод.СтраховыеВзносы.Значение;
			НаборЗаписейСтраховыеВзносы.Страховые = ВыборкаПоЗадолженности.СтраховаяЧасть;
			НаборЗаписейСтраховыеВзносы.Накопительные = ВыборкаПоЗадолженности.НакопительнаяЧасть;
			НаборЗаписейСтраховыеВзносы.Дополнительные = ВыборкаПоЗадолженности.ДополнительныйТариф;
			
			ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗадолженностьНаНачало, "СуммаЗаПериод", ""), НаборЗаписейСуммаЗаПериод);
			
			ВсегоДолгНаНачалоСтраховаяЧасть = ВсегоДолгНаНачалоСтраховаяЧасть + ВыборкаПоЗадолженности.СтраховаяЧасть;
			ВсегоДолгНаНачалоНакопительнаяЧасть = ВсегоДолгНаНачалоНакопительнаяЧасть + ВыборкаПоЗадолженности.НакопительнаяЧасть;
			ВсегоДолгНаНачалоДополнительныйТариф = ВсегоДолгНаНачалоДополнительныйТариф + ВыборкаПоЗадолженности.ДополнительныйТариф;
			
		ИначеЕсли ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод Тогда
			ЧислоСтрокУПЛЧ = ЧислоСтрокУПЛЧ + 1;
			
			НаборЗаписейУплатаСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматСуммаЗаПериод);
			
			НаборЗаписейУплатаСуммаЗаПериод.ТипСтроки.Значение = "ДЕТАЛЬНАЯ";
			НаборЗаписейУплатаСуммаЗаПериод.РасчетныйПериод.Значение = ВыборкаПоЗадолженности.Год;
			НаборЗаписейУплатаСуммаЗаПериод.СтраховыеВзносы.Значение.Страховые = ВыборкаПоЗадолженности.СтраховаяЧасть;
			НаборЗаписейУплатаСуммаЗаПериод.СтраховыеВзносы.Значение.Накопительные = ВыборкаПоЗадолженности.НакопительнаяЧасть;
			НаборЗаписейУплатаСуммаЗаПериод.СтраховыеВзносы.Значение.Дополнительные = ВыборкаПоЗадолженности.ДополнительныйТариф;
			
			ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелУплатаЗаПериод, "СуммаЗаПериод",""), НаборЗаписейУплатаСуммаЗаПериод);
	
			ВсегоУплаченоСтраховаяЧасть = ВсегоУплаченоСтраховаяЧасть + ВыборкаПоЗадолженности.СтраховаяЧасть;
			ВсегоУплаченоНакопительнаяЧасть = ВсегоУплаченоНакопительнаяЧасть + ВыборкаПоЗадолженности.НакопительнаяЧасть;
			ВсегоУплаченоДополнительныйТариф = ВсегоУплаченоДополнительныйТариф + ВыборкаПоЗадолженности.ДополнительныйТариф;
			
		ИначеЕсли ВыборкаПоЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец Тогда 
			ЧислоСтрокЗКНЦ = ЧислоСтрокЗКНЦ + 1;
			
			НаборЗаписейДолгКонецСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматСуммаЗаПериод);
			
			НаборЗаписейДолгКонецСуммаЗаПериод.ТипСтроки.Значение = "ДЕТАЛЬНАЯ";
			НаборЗаписейДолгКонецСуммаЗаПериод.РасчетныйПериод.Значение = ВыборкаПоЗадолженности.Год;
			НаборЗаписейДолгКонецСуммаЗаПериод.СтраховыеВзносы.Значение.Страховые = ВыборкаПоЗадолженности.СтраховаяЧасть;
			НаборЗаписейДолгКонецСуммаЗаПериод.СтраховыеВзносы.Значение.Накопительные = ВыборкаПоЗадолженности.НакопительнаяЧасть;
			НаборЗаписейДолгКонецСуммаЗаПериод.СтраховыеВзносы.Значение.Дополнительные = ВыборкаПоЗадолженности.ДополнительныйТариф;
			
			ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗадолженностьНаКонец, "СуммаЗаПериод", ""), НаборЗаписейДолгКонецСуммаЗаПериод);
			
			ВсегоЗадолженностьСтраховаяЧасть = ВсегоЗадолженностьСтраховаяЧасть + ВыборкаПоЗадолженности.СтраховаяЧасть;
			ВсегоЗадолженностьНакопительнаяЧасть = ВсегоЗадолженностьНакопительнаяЧасть + ВыборкаПоЗадолженности.НакопительнаяЧасть;
			ВсегоЗадолженностьДополнительныйТариф = ВсегоЗадолженностьДополнительныйТариф + ВыборкаПоЗадолженности.ДополнительныйТариф;
			
		КонецЕсли; 
	КонецЦикла; 
		
	Если ЧислоСтрокЗНЧЛ = 0 Тогда
		УзелВедомостьУплаты.Строки.Удалить(УзелЗадолженностьНаНачало);
	Иначе
		НоваяСтрока = УзелЗадолженностьНаНачало.Строки.Вставить(0);
		НоваяСтрока.Имя = "Количество";
		НоваяСтрока.Значение = ЧислоСтрокЗНЧЛ + 1;
		// Добавление строки ИТОГО
		НаборЗаписейСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматСуммаЗаПериод);
		НаборЗаписейСуммаЗаПериод.Удалить("РасчетныйПериод");
		НаборЗаписейСуммаЗаПериод.ТипСтроки.Значение = "ИТОГО";
		НаборЗаписейСуммаЗаПериод.СтраховыеВзносы.Значение.Страховые = ВсегоДолгНаНачалоСтраховаяЧасть;
		НаборЗаписейСуммаЗаПериод.СтраховыеВзносы.Значение.Накопительные = ВсегоДолгНаНачалоНакопительнаяЧасть;
		НаборЗаписейСуммаЗаПериод.СтраховыеВзносы.Значение.Дополнительные = ВсегоДолгНаНачалоДополнительныйТариф;
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗадолженностьНаНачало, "СуммаЗаПериод", ""), НаборЗаписейСуммаЗаПериод);
			
	КонецЕсли;
	
	Если ЧислоСтрокНачислено = 0 Тогда
		УзелВедомостьУплаты.Строки.Удалить(УзелНачисленоЗаПериод);
	КонецЕсли;
	
	Если ЧислоСтрокУПЛЧ = 0 Тогда
		УзелВедомостьУплаты.Строки.Удалить(УзелУплатаЗаПериод);
	Иначе
		НоваяСтрока = УзелУплатаЗаПериод.Строки.Вставить(0);
		НоваяСтрока.Имя = "Количество";
		НоваяСтрока.Значение = ЧислоСтрокУПЛЧ + 1;
		// Добавление строки ИТОГО
		НаборЗаписейУплатаСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматСуммаЗаПериод);
		НаборЗаписейУплатаСуммаЗаПериод.Удалить("РасчетныйПериод");
		НаборЗаписейУплатаСуммаЗаПериод.ТипСтроки.Значение = "ИТОГО";
		НаборЗаписейУплатаСуммаЗаПериод.СтраховыеВзносы.Значение.Страховые = ВсегоУплаченоСтраховаяЧасть;
		НаборЗаписейУплатаСуммаЗаПериод.СтраховыеВзносы.Значение.Накопительные = ВсегоУплаченоНакопительнаяЧасть;
		НаборЗаписейУплатаСуммаЗаПериод.СтраховыеВзносы.Значение.Дополнительные = ВсегоУплаченоДополнительныйТариф;
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелУплатаЗаПериод, "СуммаЗаПериод",""), НаборЗаписейУплатаСуммаЗаПериод);
		
	КонецЕсли;
	Если ЧислоСтрокЗКНЦ = 0 Тогда
		УзелВедомостьУплаты.Строки.Удалить(УзелЗадолженностьНаКонец);
	Иначе
		НоваяСтрока = УзелЗадолженностьНаКонец.Строки.Вставить(0);
		НоваяСтрока.Имя = "Количество";
		НоваяСтрока.Значение = ЧислоСтрокЗКНЦ + 1;
		// Добавление строки ИТОГО
		НаборЗаписейДолгКонецСуммаЗаПериод = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ФорматСуммаЗаПериод);
		НаборЗаписейДолгКонецСуммаЗаПериод.Удалить("РасчетныйПериод");	
		НаборЗаписейДолгКонецСуммаЗаПериод.ТипСтроки.Значение = "ИТОГО";
		НаборЗаписейДолгКонецСуммаЗаПериод.СтраховыеВзносы.Значение.Страховые = ВсегоЗадолженностьСтраховаяЧасть;
		НаборЗаписейДолгКонецСуммаЗаПериод.СтраховыеВзносы.Значение.Накопительные = ВсегоЗадолженностьНакопительнаяЧасть;
		НаборЗаписейДолгКонецСуммаЗаПериод.СтраховыеВзносы.Значение.Дополнительные = ВсегоЗадолженностьДополнительныйТариф;
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелЗадолженностьНаКонец, "СуммаЗаПериод", ""), НаборЗаписейДолгКонецСуммаЗаПериод);
			
	КонецЕсли;
	
	// Преобразуем дерево в строковое описание XML.
	Возврат ПерсонифицированныйУчет.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки);
	
КонецФункции	

Функция СформироватьЗапросПоШапкеДокумента(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ВедомостьУплатыАДВ_11";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = Ссылка;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьУплатыАДВ_11.Дата,
	|	ВедомостьУплатыАДВ_11.Номер,
	|	СведенияОбОрганизациях.ЮридическоеФизическоеЛицо КАК ЮридическоеФизическоеЛицо,
	|	СведенияОбОрганизациях.ОГРН,
	|	СведенияОбОрганизациях.НаименованиеСокращенное,
	|	СведенияОбОрганизациях.НаименованиеПолное,
	|	СведенияОбОрганизациях.ИНН,
	|	СведенияОбОрганизациях.КПП,
	|	СведенияОбОрганизациях.КодПоОКПО,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	ВедомостьУплатыАДВ_11.ОтчетныйПериод,
	|	ВедомостьУплатыАДВ_11.ИмяФайлаДляПФР,
	|	ВедомостьУплатыАДВ_11.НомерПачки,
	|	ВедомостьУплатыАДВ_11.КодКатегории
	|ИЗ
	|	Документ.ВедомостьУплатыАДВ_11 КАК ВедомостьУплатыАДВ_11
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО ВедомостьУплатыАДВ_11.Организация = СведенияОбОрганизациях.Организация
	|			И ВедомостьУплатыАДВ_11.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|ГДЕ
	|	ВедомостьУплатыАДВ_11.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СФормироватьЗапросПоСтрокамЗадолженности(Ссылка)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.ТипСтроки,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.Год КАК Год,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.СтраховаяЧасть,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.НакопительнаяЧасть,
	|	ВедомостьУплатыАДВ_11СведенияОЗадолженности.ДополнительныйТариф
	|ИЗ
	|	Документ.ВедомостьУплатыАДВ_11.СведенияОЗадолженности КАК ВедомостьУплатыАДВ_11СведенияОЗадолженности
	|
	|УПОРЯДОЧИТЬ ПО
	|	Год";
	
	Возврат Запрос.Выполнить();
КонецФункции	

Процедура ОбработкаФормированияФайла(Объект) Экспорт
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента(Объект.Ссылка).Выбрать();
	ВыборкаПоСтрокамЗадолженности = СФормироватьЗапросПоСтрокамЗадолженности(Объект.Ссылка).Выбрать();
	
	ВыборкаПоШапкеДокумента.Следующий();
	
	ТекстФайла = СформироватьВыходнойФайл(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамЗадолженности);
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Объект.Ссылка, ВыборкаПоШапкеДокумента.ИмяФайлаДляПФР, ТекстФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПечатиДокумента

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// АДВ 11
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_11";
	КомандаПечати.Представление = НСтр("ru = 'АДВ 11'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаАДВ_11") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаАДВ_11", "Форма АДВ-11", СформироватьПечатнуюФормуАДВ_11(МассивОбъектов, ОбъектыПечати));	
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАДВ_11(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ВыборкаПоДокументам = СформироватьЗапросПоШапкеДокументаДляПечати(МассивОбъектов).Выбрать();
	
	ВыборкаПоСтрокаЗадолженности = СформироватьЗапросПоСтрокаЗадолженности(МассивОбъектов).Выбрать();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ВедомостьУплатыАДВ_11.ПФ_MXL_ФормаАДВ_11");
	
	ТабличныйДокумент.КлючПараметровПечати = "ВедомостьУплатыАДВ_11_ФормаАДВ_11";
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьГод   = Макет.ПолучитьОбласть("Год");
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	
	ОбластьУплачено = Макет.ПолучитьОбласть("Уплачено");
	ОбластьДолгНаКонец = Макет.ПолучитьОбласть("ДолгНаКонец");
	ОбластьЗадолженностьНаНачало = Макет.ПолучитьОбласть("ЗадолженностьНаНачало");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		ВыборкаПоСтрокаЗадолженности.Сбросить();
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ОбластьШапка.Параметры.КолПачек = 0;
		ОбластьШапка.Параметры.ЗастрахованныхЛиц = 0;
		
		ЕстьЗадолженностьНаНачало = Ложь;
		ЕстьЗадолженностьНаКонец  = Ложь;
		ЕстьУплата = Ложь;
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		СтруктураПоиска = Новый Структура("Ссылка", ВыборкаПоДокументам.Ссылка);
		
		ТабличныйДокументДолгНаНачало = Новый ТабличныйДокумент;
		ТабличныйДокументДолгНаКонец  = Новый ТабличныйДокумент;
		ТабличныйДокументУплата = Новый ТабличныйДокумент;
		
		Если ВыборкаПоСтрокаЗадолженности.НайтиСледующий(СтруктураПоиска) Тогда
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			ТабличныйДокументДолгНаНачало = Новый ТабличныйДокумент;
			ТабличныйДокументДолгНаКонец  = Новый ТабличныйДокумент;
			ТабличныйДокументУплата = Новый ТабличныйДокумент;
			
			ВыборкаПоСтрокаЗадолженности.СледующийПоЗначениюПоля("Ссылка");
			
			ОбластьИтого.Параметры.СтраховаяЧасть = 0;
			ОбластьИтого.Параметры.НакопительнаяЧасть = 0;
			ОбластьИтого.Параметры.ДополнительныйТариф = 0;
			Пока ВыборкаПоСтрокаЗадолженности.СледующийПоЗначениюПоля("ТипСтроки") Цикл
				ИтогоСтраховая = 0;
				ИтогоНакопительная = 0;
				ИтогоДополнительныйТариф = 0;
				
				Если ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало Тогда
					ТабличныйДокументДолгНаНачало.Вывести(ОбластьЗадолженностьНаНачало);
					ЕстьЗадолженностьНаНачало = Истина;
				ИначеЕсли ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод Тогда
					ТабличныйДокументУплата.Вывести(ОбластьУплачено);
					ЕстьУплата = Истина;
				ИначеЕсли ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец Тогда
					ТабличныйДокументДолгНаКонец.Вывести(ОбластьДолгНаКонец);
					ЕстьЗадолженностьНаКонец = Истина;
				КонецЕсли;	
				
				Пока ВыборкаПоСтрокаЗадолженности.СледующийПоЗначениюПоля("Год") Цикл
					
					ОбластьГод.Параметры.Заполнить(ВыборкаПоСтрокаЗадолженности);
					
					ИтогоСтраховая = ИтогоСтраховая + ВыборкаПоСтрокаЗадолженности.СтраховаяЧасть;
					ИтогоНакопительная = ИтогоНакопительная + ВыборкаПоСтрокаЗадолженности.НакопительнаяЧасть;
					ИтогоДополнительныйТариф = ИтогоДополнительныйТариф + ВыборкаПоСтрокаЗадолженности.ДополнительныйТариф;
						
					Если ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало Тогда
						ТабличныйДокументДолгНаНачало.Вывести(ОбластьГод);
					ИначеЕсли ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод Тогда
						ТабличныйДокументУплата.Вывести(ОбластьГод);	
					ИначеЕсли ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец Тогда
						ТабличныйДокументДолгНаКонец.Вывести(ОбластьГод);
					КонецЕсли;
					
				КонецЦикла;
				
				ОбластьИтого.Параметры.СтраховаяЧасть = ИтогоСтраховая;
				ОбластьИтого.Параметры.НакопительнаяЧасть = ИтогоНакопительная;
				ОбластьИтого.Параметры.ДополнительныйТариф = ИтогоДополнительныйТариф;
				
				Если ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаНачало Тогда
					ТабличныйДокументДолгНаНачало.Вывести(ОбластьИтого);
				ИначеЕсли ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.УплатаЗаПериод Тогда
					ТабличныйДокументУплата.Вывести(ОбластьИтого);
				ИначеЕсли ВыборкаПоСтрокаЗадолженности.ТипСтроки = Перечисления.РазделыАДВ11.ЗадолженностьНаКонец Тогда
					ТабличныйДокументДолгНаКонец.Вывести(ОбластьИтого);
				КонецЕсли;
				
			КонецЦикла
			
		КонецЕсли;
		
		ОбластьИтого.Параметры.СтраховаяЧасть = 0;
		ОбластьИтого.Параметры.НакопительнаяЧасть = 0;
		ОбластьИтого.Параметры.ДополнительныйТариф = 0;
		
		Если Не ЕстьЗадолженностьНаНачало Тогда 
			ТабличныйДокументДолгНаНачало.Вывести(ОбластьЗадолженностьНаНачало);
			ТабличныйДокументДолгНаНачало.Вывести(ОбластьИтого);
		КонецЕсли;
		Если Не ЕстьУплата Тогда
			ТабличныйДокументУплата.Вывести(ОбластьУплачено);
			ТабличныйДокументУплата.Вывести(ОбластьИтого);
		КонецЕсли;
		Если Не ЕстьЗадолженностьНаКонец Тогда
			ТабличныйДокументДолгНаКонец.Вывести(ОбластьДолгНаКонец);
			ТабличныйДокументДолгНаКонец.Вывести(ОбластьИтого);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ТабличныйДокументДолгНаНачало);
		ТабличныйДокумент.Вывести(ТабличныйДокументУплата);
		ТабличныйДокумент.Вывести(ТабличныйДокументДолгНаКонец);
		
		ОбластьПодвал.Параметры.Заполнить(ВыборкаПоДокументам);
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, МассивОбъектов);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли