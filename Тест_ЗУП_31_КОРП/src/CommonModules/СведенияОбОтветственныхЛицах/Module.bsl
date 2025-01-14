
#Область ПрограммныйИнтерфейс

// Возвращает сведения об ответственных лицах организации.
//
// Параметры:
//		Организация - ссылка на организацию.
//		Сведения - строка с идентификаторами, разделенными запятыми.
//		ДатаСведений - дата получения сведений.
//
// Возвращаемое значение:
//		СтруктураДанных - структура со свойствами, совпадающими с параметром «Сведения».
//			Допустимые идентификаторы запрашиваемых значений:
//				Руководитель						- руководитель организации.
//				ДолжностьРуководителя				- должность руководителя.
//				ДолжностьРуководителяСтрокой		- представление должности руководителя.
//
//				ГлавныйБухгалтер					- главный бухгалтер организации.
//
//				Кассир								- кассир организации.
//				ДолжностьКассира					- должность кассира.
//				ДолжностьКассираСтрокой				- представление должности кассира.
//
//				РуководительКадровойСлужбы					- Руководитель кадровой службы организации.
//				ДолжностьРуководителяКадровойСлужбы			- должность руководителя кадровой службы организации.
//				ДолжностьРуководителяКадровойСлужбыСтрокой	- представление должности руководителя кадровой службы организации.
//
//				ОтветственныйЗаВУР 					- ответственный за военно-учетную работу.
//				ДолжностьОтветственногоЗаВУР 		- должность ответственного за военно-учетную работу.
//				ДолжностьОтветственногоЗаВУРСтрокой - представление должности ответственного за военно-учетную работу.
//
Функция СведенияОбОтветственныхЛицах(Организация, Сведения, ДатаСведений = Неопределено) Экспорт
	
	ФизическоеЛицоПустаяСсылка = Справочники.ФизическиеЛица.ПустаяСсылка();
	ДолжностьПустаяСсылка = Справочники.Должности.ПустаяСсылка();
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("Руководитель", ФизическоеЛицоПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьРуководителя", ДолжностьПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьРуководителяСтрокой", "");
	
	СтруктураДанных.Вставить("ГлавныйБухгалтер", ФизическоеЛицоПустаяСсылка);
	
	СтруктураДанных.Вставить("Кассир", ФизическоеЛицоПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьКассира", ДолжностьПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьКассираСтрокой", "");
	
	СтруктураДанных.Вставить("РуководительКадровойСлужбы", ФизическоеЛицоПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьРуководителяКадровойСлужбы", ДолжностьПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьРуководителяКадровойСлужбыСтрокой", "");
	
	СтруктураДанных.Вставить("ОтветственныйЗаВУР", ФизическоеЛицоПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьОтветственногоЗаВУР", ДолжностьПустаяСсылка);
	СтруктураДанных.Вставить("ДолжностьОтветственногоЗаВУРСтрокой", "");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		МодульОхранаТруда = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
		МодульОхранаТруда.ДополнитьСтруктуруСведенийОбОтветственныхЛицах(СтруктураДанных);
	КонецЕсли;
	
	// Преобразуем параметр Сведения из строки в массив идентификаторов.
	МассивНеобходимыхДанных = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(Сведения, " ",""), ",");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Период", ?(ДатаСведений = Неопределено, ТекущаяДатаСеанса(), ДатаСведений));
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ";
	
	ТекстЗапроса = ТекстЗапроса + "
	|	СведенияОбОтветственныхЛицахСрезПоследних.Организация КАК Организация";
	
	Для Каждого ЭлементМассиваПолей Из МассивНеобходимыхДанных Цикл
		
		ПозицияСловаСтрокой = СтрНайти(ВРег(ЭлементМассиваПолей), ВРег("Строкой"));
		Если ПозицияСловаСтрокой = 0 Тогда
			ПутьКДанным = ЭлементМассиваПолей;
		Иначе
			ПутьКДанным = Лев(ЭлементМассиваПолей, ПозицияСловаСтрокой - 1) + ".Наименование";
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + "
		|,
		|	СведенияОбОтветственныхЛицахСрезПоследних." + ПутьКДанным + " КАК " + ЭлементМассиваПолей;
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "
	|ИЗ
	|	РегистрСведений.СведенияОбОтветственныхЛицах.СрезПоследних(&Период, Организация = &Организация) КАК СведенияОбОтветственныхЛицахСрезПоследних";
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат СтруктураДанных;
	КонецЕсли;
	
	НеобходимыхДанные = Результат.Выбрать();
	НеобходимыхДанные.Следующий();
	
	Для Каждого ЭлементМассиваПолей Из МассивНеобходимыхДанных Цикл
		СтруктураДанных.Вставить(ЭлементМассиваПолей, НеобходимыхДанные[ЭлементМассиваПолей]);
	КонецЦикла;
	
	Возврат СтруктураДанных;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Получает "заказанные" значения по умолчанию.
// Параметры:
//		ЗаполняемыеЗначения - структура элементы которой имеют 
//			имена, идентифицирующие получаемые значения.
//		
//		Допустимые идентификаторы запрашиваемых значений:
//			Допустимые идентификаторы запрашиваемых значений:
//				Руководитель						- руководитель организации.
//				ДолжностьРуководителя				- должность руководителя.
//				ДолжностьРуководителяСтрокой		- представление должности руководителя.
//
//				ГлавныйБухгалтер					- главный бухгалтер организации.
//
//				Кассир								- кассир организации.
//				ДолжностьКассира					- должность кассира.
//				ДолжностьКассираСтрокой				- представление должности кассира.
//
//				РуководительКадровойСлужбы					- Руководитель кадровой службы организации.
//				ДолжностьРуководителяКадровойСлужбы			- должность руководителя кадровой службы организации.
//				ДолжностьРуководителяКадровойСлужбыСтрокой	- представление должности руководителя кадровой службы организации.
//
//				ОтветственныйЗаВУР 					- ответственный за военно-учетную работу.
//				ДолжностьОтветственногоЗаВУР 		- должность ответственного за военно-учетную работу.
//				ДолжностьОтветственногоЗаВУРСтрокой - представление должности ответственного за военно-учетную работу.
//
Процедура ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ДатаЗначений) Экспорт
	
	Сведения = "";
	
	Если ЗаполняемыеЗначения.Свойство("Руководитель") Тогда
		Сведения = Сведения + "Руководитель,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьРуководителя") Тогда
		Сведения = Сведения + "ДолжностьРуководителя,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьРуководителяСтрокой") Тогда
		Сведения = Сведения + "ДолжностьРуководителяСтрокой,";
	КонецЕсли;
	
	Если ЗаполняемыеЗначения.Свойство("ГлавныйБухгалтер") Тогда
		Сведения = Сведения + "ГлавныйБухгалтер,";
	КонецЕсли;
	
	Если ЗаполняемыеЗначения.Свойство("Кассир") Тогда
		Сведения = Сведения + "Кассир,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьКассира") Тогда
		Сведения = Сведения + "ДолжностьКассира,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьКассираСтрокой") Тогда
		Сведения = Сведения + "ДолжностьКассираСтрокой,";
	КонецЕсли;
	
	Если ЗаполняемыеЗначения.Свойство("ОтветственныйЗаВУР") Тогда
		Сведения = Сведения + "ОтветственныйЗаВУР,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьОтветственногоЗаВУР") Тогда
		Сведения = Сведения + "ДолжностьОтветственногоЗаВУР,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьОтветственногоЗаВУРСтрокой") Тогда
		Сведения = Сведения + "ДолжностьОтветственногоЗаВУРСтрокой,";
	КонецЕсли;
	
	Если ЗаполняемыеЗначения.Свойство("РуководительКадровойСлужбы") Тогда
		Сведения = Сведения + "РуководительКадровойСлужбы,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьРуководителяКадровойСлужбы") Тогда
		Сведения = Сведения + "ДолжностьРуководителяКадровойСлужбы,";
	КонецЕсли;
	Если ЗаполняемыеЗначения.Свойство("ДолжностьРуководителяКадровойСлужбыСтрокой") Тогда
		Сведения = Сведения + "ДолжностьРуководителяКадровойСлужбыСтрокой,";
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
		МодульОхранаТруда = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
		МодульОхранаТруда.ДополнитьСведенияПолучаемыеПоУмолчанию(Сведения, ЗаполняемыеЗначения);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Сведения) 
		И (ЗаполняемыеЗначения.Свойство("Организация") И ЗаполняемыеЗначения.Организация <> НеОпределено) Тогда
		СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Сведения, 1);
		ОтветственныеЛица = СведенияОбОтветственныхЛицах(ЗаполняемыеЗначения.Организация, Сведения, ДатаЗначений);
		ЗаполнитьЗначенияСвойств(ЗаполняемыеЗначения, ОтветственныеЛица);
	КонецЕсли;
	
КонецПроцедуры

// Формирует временную таблицу ВТОтветственныеЛица, список организаций и периодов,
// по которым необходимо получить данные, берутся из временной таблицы в менеджере временных
// таблиц, переданном в качестве параметра. Временная таблица обязательно должна содержать
// колонки Организация и Период.
//
// Параметры:
//		МенеджерВременныхТаблиц - менеджер временных таблиц с таблицей отборов.
//		ИмяТаблицыОтборов - имя таблицы, содержащей колонки Организация и Период.
//		Сведения - строка с идентификаторами, разделенными запятыми.
//		ИмяПоляПериод - имя колонки, содержащей период, необязательный.
//
Процедура СоздатьВТОтветственныеЛица(МенеджерВременныхТаблиц, ИмяТаблицыОтборов, Сведения, ИмяПоляПериод = "Период") Экспорт 
	
	// Преобразуем параметр Сведения из строки в массив идентификаторов.
	МассивНеобходимыхДанных = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(Сведения, " ",""), ",");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДанныеОрганизаций." + ИмяПоляПериод + " КАК Период,
	|	ДанныеОрганизаций.Организация КАК Организация
	|ПОМЕСТИТЬ ВТСписокОрганизаций
	|ИЗ
	|	" + ИмяТаблицыОтборов + " КАК ДанныеОрганизаций
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИзмеренияДаты.Период КАК ЗаданныйПериод,
	|	ИзмеренияДаты.Организация КАК Организация,
	|	МАКСИМУМ(РегистрСведений.Период) КАК Период
	|ПОМЕСТИТЬ ВТМаксимальныеПериоды
	|ИЗ
	|	ВТСписокОрганизаций КАК ИзмеренияДаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбОтветственныхЛицах КАК РегистрСведений
	|		ПО (РегистрСведений.Период <= ИзмеренияДаты.Период
	|				ИЛИ ИзмеренияДаты.Период = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|			И (РегистрСведений.Организация = ИзмеренияДаты.Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИзмеренияДаты.Период,
	|	ИзмеренияДаты.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МаксимальныеПериоды.ЗаданныйПериод КАК Период,
	|	РегистрСведений.Период КАК ПериодЗаписи,
	|	МаксимальныеПериоды.Организация КАК Организация";
	
	Для Каждого ЭлементМассиваПолей Из МассивНеобходимыхДанных Цикл
		
		ПозицияСловаСтрокой = СтрНайти(ВРег(ЭлементМассиваПолей), ВРег("Строкой"));
		Если ПозицияСловаСтрокой = 0 Тогда
			ПутьКДанным = ЭлементМассиваПолей;
		Иначе
			ПутьКДанным = Лев(ЭлементМассиваПолей, ПозицияСловаСтрокой - 1) + ".Наименование";
		КонецЕсли;
		
		ТекстЗапроса = ТекстЗапроса + ",
		|	РегистрСведений." + ПутьКДанным + " КАК " + ЭлементМассиваПолей;
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + 
	"
	|ПОМЕСТИТЬ ВТОтветственныеЛица
	|ИЗ
	|	ВТМаксимальныеПериоды КАК МаксимальныеПериоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбОтветственныхЛицах КАК РегистрСведений
	|		ПО (РегистрСведений.Период = МаксимальныеПериоды.Период)
	|			И (РегистрСведений.Организация = МаксимальныеПериоды.Организация)
	|ГДЕ
	|	НЕ РегистрСведений.Период ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСписокОрганизаций
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТМаксимальныеПериоды";
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ЗаполнитьСведенияОбОтветственныхЛицах(СписокФизическихЛиц, СведенияОбОтветственных) Экспорт
	
	Если СписокФизическихЛиц.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийПериод", ТекущаяДатаСеанса());
		Запрос.УстановитьПараметр("СписокФизическихЛиц", СписокФизическихЛиц);
		
		Запрос.УстановитьПараметр("РольРуководитель", 				НСтр("ru='Руководитель'"));
		Запрос.УстановитьПараметр("РольГлавныйБухгалтер", 			НСтр("ru='Главный бухгалтер'"));
		Запрос.УстановитьПараметр("РольКассир",						НСтр("ru='Кассир'"));
		Запрос.УстановитьПараметр("РольРуководительКадровойСлужбы", НСтр("ru='Руководитель кадровой службы'"));
		Запрос.УстановитьПараметр("РольОтветственныйЗаВУР", 		НСтр("ru='Ответственный за ВУР'"));
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОбОтветственныхЛицахСрезПоследних.Период,
		|	СведенияОбОтветственныхЛицахСрезПоследних.Организация,
		|	СведенияОбОтветственныхЛицахСрезПоследних.Руководитель,
		|	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьРуководителя,
		|	СведенияОбОтветственныхЛицахСрезПоследних.ГлавныйБухгалтер,
		|	СведенияОбОтветственныхЛицахСрезПоследних.Кассир,
		|	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьКассира,
		|	СведенияОбОтветственныхЛицахСрезПоследних.РуководительКадровойСлужбы,
		|	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьРуководителяКадровойСлужбы,
		|	СведенияОбОтветственныхЛицахСрезПоследних.ОтветственныйЗаВУР,
		|	СведенияОбОтветственныхЛицахСрезПоследних.ДолжностьОтветственногоЗаВУР
		|ПОМЕСТИТЬ ВТСведенияОбОтветственныхЛицах
		|ИЗ
		|	РегистрСведений.СведенияОбОтветственныхЛицах.СрезПоследних(&ТекущийПериод, ) КАК СведенияОбОтветственныхЛицахСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СведенияОбОтветственныхЛицах.Организация КАК СтруктурнаяЕдиница,
		|	СведенияОбОтветственныхЛицах.Руководитель КАК ФизическоеЛицо,
		|	&РольРуководитель КАК РольОтветственногоЛица,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СведенияОбОтветственныхЛицах.ДолжностьРуководителя) КАК ПредставлениеДолжности
		|ИЗ
		|	ВТСведенияОбОтветственныхЛицах КАК СведенияОбОтветственныхЛицах
		|ГДЕ
		|	СведенияОбОтветственныхЛицах.Руководитель В(&СписокФизическихЛиц)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СведенияОбОтветственныхЛицах.Организация,
		|	СведенияОбОтветственныхЛицах.ГлавныйБухгалтер,
		|	&РольГлавныйБухгалтер,
		|	""""
		|ИЗ
		|	ВТСведенияОбОтветственныхЛицах КАК СведенияОбОтветственныхЛицах
		|ГДЕ
		|	СведенияОбОтветственныхЛицах.ГлавныйБухгалтер В(&СписокФизическихЛиц)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СведенияОбОтветственныхЛицах.Организация,
		|	СведенияОбОтветственныхЛицах.Кассир,
		|	&РольКассир,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СведенияОбОтветственныхЛицах.ДолжностьКассира)
		|ИЗ
		|	ВТСведенияОбОтветственныхЛицах КАК СведенияОбОтветственныхЛицах
		|ГДЕ
		|	СведенияОбОтветственныхЛицах.Кассир В(&СписокФизическихЛиц)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СведенияОбОтветственныхЛицах.Организация,
		|	СведенияОбОтветственныхЛицах.РуководительКадровойСлужбы,
		|	&РольРуководительКадровойСлужбы,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СведенияОбОтветственныхЛицах.ДолжностьРуководителяКадровойСлужбы)
		|ИЗ
		|	ВТСведенияОбОтветственныхЛицах КАК СведенияОбОтветственныхЛицах
		|ГДЕ
		|	СведенияОбОтветственныхЛицах.РуководительКадровойСлужбы В(&СписокФизическихЛиц)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СведенияОбОтветственныхЛицах.Организация,
		|	СведенияОбОтветственныхЛицах.ОтветственныйЗаВУР,
		|	&РольОтветственныйЗаВУР,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СведенияОбОтветственныхЛицах.ДолжностьОтветственногоЗаВУР)
		|ИЗ
		|	ВТСведенияОбОтветственныхЛицах КАК СведенияОбОтветственныхЛицах
		|ГДЕ
		|	СведенияОбОтветственныхЛицах.ОтветственныйЗаВУР В(&СписокФизическихЛиц)";
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
			МодульОхранаТруда = ОбщегоНазначения.ОбщийМодуль("ОхранаТруда");
			МодульОхранаТруда.ДополнитьЗапросСведенийОбОтветственныхЛицах(Запрос);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрокаСведений = СведенияОбОтветственных.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаСведений, Выборка, "СтруктурнаяЕдиница,ФизическоеЛицо");
			НоваяСтрокаСведений.ПредставлениеДолжности = Выборка.РольОтветственногоЛица;
			Если Не ПустаяСтрока(Выборка.ПредставлениеДолжности) Тогда
				НоваяСтрокаСведений.ПредставлениеДолжности = НоваяСтрокаСведений.ПредставлениеДолжности
					+ " (" + Выборка.ПредставлениеДолжности + ")";
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
