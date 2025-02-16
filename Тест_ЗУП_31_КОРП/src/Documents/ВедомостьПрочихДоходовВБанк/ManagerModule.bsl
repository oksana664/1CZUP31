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


#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру, используемую для заполнения документа.
Функция ДанныеЗаполненияНезачисленнымиСтроками() Экспорт
	ДанныеЗаполненияНезачисленнымиСтроками = Новый Структура;
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("ЭтоДанныеЗаполненияНезачисленнымиСтроками");
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("Ведомость", Документы.ВедомостьПрочихДоходовВБанк.ПустаяСсылка());
	ДанныеЗаполненияНезачисленнымиСтроками.Вставить("Физлица", Новый Массив);
	Возврат ДанныеЗаполненияНезачисленнымиСтроками
КонецФункции

Функция ЭтоДанныеЗаполненияНезачисленнымиСтроками(ДанныеЗаполнения) Экспорт
	Возврат ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ЭтоДанныеЗаполненияНезачисленнымиСтроками")
КонецФункции

// Возвращает структуру документа, используемую для формирования файла обмена, печатного документа.
//
Функция ДанныеЗаполненияВедомости() Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("Документ", Документы.ВедомостьПрочихДоходовВБанк.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерДокумента", "");
	ДанныеЗаполнения.Вставить("НомерРеестра", "");
	ДанныеЗаполнения.Вставить("ДатаДокумента", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ПериодРегистрации", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ПолноеНаименованиеОрганизации", "");
	ДанныеЗаполнения.Вставить("ИННОрганизации", "");
	ДанныеЗаполнения.Вставить("КодПоОКПО", "");
	ДанныеЗаполнения.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ЗарплатныйПроект", Справочники.ЗарплатныеПроекты.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерДоговора", "");
	ДанныеЗаполнения.Вставить("ДатаДоговора", Дата("00010101"));
	ДанныеЗаполнения.Вставить("НомерРасчетногоСчетаОрганизации", "");
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ИспользоватьЭлектронныйДокументооборотСБанком", Ложь);
	ДанныеЗаполнения.Вставить("БИКБанка", "");
	ДанныеЗаполнения.Вставить("ФорматФайла", Перечисления.ФорматыФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("КодировкаФайла", Перечисления.КодировкаФайловОбменаПоЗарплатномуПроекту.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("ВидЗачисления", "01");
	ДанныеЗаполнения.Вставить("КоличествоЗаписей", 0);
	ДанныеЗаполнения.Вставить("СуммаИтого", 0);
	ДанныеЗаполнения.Вставить("СуммаПоДокументу", 0);
	ДанныеЗаполнения.Вставить("ИдПервичногоДокумента", "");
	ДанныеЗаполнения.Вставить("НомерПлатежногоПоручения", "");
	ДанныеЗаполнения.Вставить("ДатаПлатежногоПоручения", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ДатаФормирования", Дата("00010101"));
	ДанныеЗаполнения.Вставить("ИмяФайла", "");
	ДанныеЗаполнения.Вставить("ДанныеРеестра", "");
	ДанныеЗаполнения.Вставить("Руководитель", "");
	ДанныеЗаполнения.Вставить("РуководительДолжность", "");
	ДанныеЗаполнения.Вставить("ГлавныйБухгалтер", "");
	ДанныеЗаполнения.Вставить("Бухгалтер", "");
	
	ДанныеЗаполнения.Вставить("Сотрудники", Новый Массив);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Возвращает структуру строки документа, используемую для формирования файла обмена, печатного документа.
//
Функция ДанныеЗаполненияСтрокиВедомости() Экспорт
	
	ДанныеЗаполнения = Новый Структура();
	ДанныеЗаполнения.Вставить("ФизическоеЛицо", Справочники.ФизическиеЛица.ПустаяСсылка());
	ДанныеЗаполнения.Вставить("НомерСтроки", 0);
	ДанныеЗаполнения.Вставить("Фамилия", "");
	ДанныеЗаполнения.Вставить("Имя", "");
	ДанныеЗаполнения.Вставить("Отчество", "");
	ДанныеЗаполнения.Вставить("НомерЛицевогоСчета", "");
	ДанныеЗаполнения.Вставить("СуммаКВыплате", 0);
	ДанныеЗаполнения.Вставить("ОтделениеБанка", "");
	ДанныеЗаполнения.Вставить("ФилиалОтделенияБанка", "");
	ДанныеЗаполнения.Вставить("КодВалюты", "");
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Получает данные документа.
//
// Параметры:
//		МассивДокументов - Массив ссылок на документы, по которым требуется получить данные.
//		ДатаПолученияДанных - дата формирования файла.
//		ПлатежныйДокумент - Ссылка на платежный документ, в который входят ведомости.
//
// Возвращаемое значение:
//		Соответствие - где Ключ - ссылка на документ, Значение - структура документа.
//
Функция ДанныеВедомостиНаВыплатуЗарплатыВБанк(МассивДокументов, ДатаПолученияДанных = Неопределено, ПлатежныйДокумент = Неопределено, ТолькоПроведенные = Истина) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	Запрос.УстановитьПараметр("ДатаПолученияДанных", ДатаПолученияДанных);
	Запрос.УстановитьПараметр("ТолькоПроведенные", ТолькоПроведенные);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Ведомость.Ссылка КАК Документ,
	|	Ведомость.Номер КАК НомерДокумента,
	|	Ведомость.НомерРеестра КАК НомерРеестра,
	|	Ведомость.Дата КАК ДатаДокумента,
	|	Ведомость.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА &ДатаПолученияДанных = НЕОПРЕДЕЛЕНО
	|			ТОГДА Ведомость.Дата
	|		ИНАЧЕ &ДатаПолученияДанных
	|	КОНЕЦ КАК Период,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьСостав.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	МИНИМУМ(ВедомостьСостав.НомерСтроки) КАК НомерСтроки,
	|	СУММА(ВедомостьСписокВыплаты.КВыплате) КАК СуммаКВыплате,
	|	ЗарплатныеПроекты.ОтделениеБанка КАК ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.Валюта.Код КАК КодВалюты
	|ПОМЕСТИТЬ ВТСписокФизическихЛиц
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк КАК Ведомость
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьПрочихДоходовВБанк.Выплаты КАК ВедомостьСписокВыплаты
	|		ПО Ведомость.Ссылка = ВедомостьСписокВыплаты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьПрочихДоходовВБанк.Состав КАК ВедомостьСостав
	|		ПО (ВедомостьСписокВыплаты.Ссылка = ВедомостьСостав.Ссылка)
	|			И (ВедомостьСписокВыплаты.ИдентификаторСтроки = ВедомостьСостав.ИдентификаторСтроки)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО Ведомость.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ТолькоПроведенные
	|				ТОГДА Ведомость.Проведен
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И Ведомость.Ссылка В(&МассивДокументов)
	|
	|СГРУППИРОВАТЬ ПО
	|	Ведомость.Ссылка,
	|	Ведомость.Номер,
	|	Ведомость.Дата,
	|	Ведомость.Организация,
	|	ВЫБОР
	|		КОГДА &ДатаПолученияДанных = НЕОПРЕДЕЛЕНО
	|			ТОГДА Ведомость.Дата
	|		ИНАЧЕ &ДатаПолученияДанных
	|	КОНЕЦ,
	|	ВедомостьСостав.ФизическоеЛицо,
	|	ВедомостьСостав.НомерЛицевогоСчета,
	|	ЗарплатныеПроекты.ОтделениеБанка,
	|	ЗарплатныеПроекты.ФилиалОтделенияБанка,
	|	ЗарплатныеПроекты.Валюта.Код,
	|	Ведомость.НомерРеестра";
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТСписокФизическихЛиц");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "Фамилия,Имя,Отчество");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокФизическихЛиц.Документ КАК Документ,
	|	СписокФизическихЛиц.НомерДокумента КАК НомерДокумента,
	|	СписокФизическихЛиц.НомерРеестра КАК НомерРеестра,
	|	СписокФизическихЛиц.ДатаДокумента КАК ДатаДокумента,
	|	СписокФизическихЛиц.Организация КАК Организация,
	|	СписокФизическихЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СписокФизическихЛиц.НомерСтроки КАК НомерСтроки,
	|	КадровыеДанныеФизическихЛиц.Фамилия КАК Фамилия,
	|	КадровыеДанныеФизическихЛиц.Имя КАК Имя,
	|	КадровыеДанныеФизическихЛиц.Отчество КАК Отчество,
	|	СписокФизическихЛиц.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	СписокФизическихЛиц.СуммаКВыплате КАК СуммаКВыплате,
	|	СписокФизическихЛиц.ОтделениеБанка КАК ОтделениеБанка,
	|	СписокФизическихЛиц.ФилиалОтделенияБанка КАК ФилиалОтделенияБанка,
	|	СписокФизическихЛиц.КодВалюты КАК КодВалюты
	|ПОМЕСТИТЬ ВТДанныеСтрокДокументов
	|ИЗ
	|	ВТСписокФизическихЛиц КАК СписокФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО СписокФизическихЛиц.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И СписокФизическихЛиц.Период = КадровыеДанныеФизическихЛиц.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТКадровыеДанныеФизическихЛиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСписокФизическихЛиц
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВедомостьВБанк.Ссылка КАК Ссылка,
	|	ВедомостьВБанк.Номер КАК НомерДокумента,
	|	ВедомостьВБанк.НомерРеестра КАК НомерРеестра,
	|	ВедомостьВБанк.Дата КАК Дата,
	|	ВедомостьВБанк.ПериодРегистрации КАК ПериодРегистрации,
	|	Организации.Ссылка КАК Организация,
	|	ВЫБОР
	|		КОГДА Организации.НаименованиеПолное ПОДОБНО """"
	|			ТОГДА Организации.Наименование
	|		ИНАЧЕ Организации.НаименованиеПолное
	|	КОНЕЦ КАК ПолноеНаименованиеОрганизации,
	|	Организации.ИНН КАК ИННОрганизации,
	|	Организации.КодПоОКПО КАК КодПоОКПО,
	|	ЗарплатныеПроекты.Ссылка КАК ЗарплатныйПроект,
	|	ЗарплатныеПроекты.НомерДоговора КАК НомерДоговора,
	|	ЗарплатныеПроекты.ДатаДоговора КАК ДатаДоговора,
	|	ЗарплатныеПроекты.ОтделениеБанка КАК ОтделениеБанка,
	|	ЕСТЬNULL(ЗарплатныеПроекты.ИспользоватьЭлектронныйДокументооборотСБанком, ЛОЖЬ) КАК ИспользоватьЭлектронныйДокументооборотСБанком,
	|	КлассификаторБанков.Код КАК БИКБанка,
	|	ЗарплатныеПроекты.РасчетныйСчет КАК НомерРасчетногоСчетаОрганизации,
	|	ЗарплатныеПроекты.ФорматФайла КАК ФорматФайла,
	|	ЗарплатныеПроекты.КодировкаФайла КАК КодировкаФайла,
	|	ИтоговыеДанныеПоВедомости.КоличествоЗаписей КАК КоличествоЗаписей,
	|	ИтоговыеДанныеПоВедомости.СуммаИтого КАК СуммаИтого,
	|	ВедомостьВБанк.СуммаПоДокументу КАК СуммаПоДокументу,
	|	ВедомостьВБанк.Руководитель КАК Руководитель,
	|	ВедомостьВБанк.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
	|	ВедомостьВБанк.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
	|	ВедомостьВБанк.Бухгалтер КАК Бухгалтер
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк КАК ВедомостьВБанк
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО ВедомостьВБанк.Организация = Организации.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО ВедомостьВБанк.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанков КАК КлассификаторБанков
	|		ПО (ЗарплатныеПроекты.Банк = КлассификаторБанков.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ДанныеВедомостейДляОплатыЧерезБанк.Ссылка КАК Ведомость,
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДанныеВедомостейДляОплатыЧерезБанк.ФизическоеЛицо) КАК КоличествоЗаписей,
	|			СУММА(ДанныеВедомостейДляОплатыЧерезБанк.КВыплате) КАК СуммаИтого
	|		ИЗ
	|			Документ.ВедомостьПрочихДоходовВБанк.Выплаты КАК ДанныеВедомостейДляОплатыЧерезБанк
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДанныеВедомостейДляОплатыЧерезБанк.Ссылка) КАК ИтоговыеДанныеПоВедомости
	|		ПО ВедомостьВБанк.Ссылка = ИтоговыеДанныеПоВедомости.Ведомость
	|ГДЕ
	|	ВедомостьВБанк.Ссылка В(&МассивДокументов)";
	Запрос.Выполнить();	
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	ИменаПолейОтветственныхЛиц.Добавить("ГлавныйБухгалтер");
	ИменаПолейОтветственныхЛиц.Добавить("Бухгалтер");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Ложь, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Документ,
	|	ДанныеДокументов.НомерДокумента,
	|	ДанныеДокументов.НомерРеестра,
	|	ДанныеДокументов.Дата КАК ДатаДокумента,
	|	ДанныеДокументов.ПериодРегистрации,
	|	ДанныеДокументов.Организация,
	|	ДанныеДокументов.ПолноеНаименованиеОрганизации,
	|	ДанныеДокументов.ИННОрганизации,
	|	ДанныеДокументов.КодПоОКПО,
	|	ДанныеДокументов.ЗарплатныйПроект,
	|	ДанныеДокументов.НомерДоговора,
	|	ДанныеДокументов.ДатаДоговора,
	|	ДанныеДокументов.ОтделениеБанка,
	|	ДанныеДокументов.ИспользоватьЭлектронныйДокументооборотСБанком,
	|	ДанныеДокументов.БИКБанка,
	|	ДанныеДокументов.НомерРасчетногоСчетаОрганизации,
	|	ДанныеДокументов.ФорматФайла,
	|	ДанныеДокументов.КодировкаФайла,
	|	ДанныеДокументов.КоличествоЗаписей,
	|	ДанныеДокументов.СуммаИтого,
	|	ДанныеДокументов.СуммаПоДокументу,
	|	ЕСТЬNULL(ВТФИОГлавБухПоследние.РасшифровкаПодписи, """") КАК ГлавныйБухгалтер,
	|	ЕСТЬNULL(ВТФИОРуководителейПоследние.РасшифровкаПодписи, """") КАК Руководитель,
	|	ДанныеДокументов.РуководительДолжность,
	|	ЕСТЬNULL(ВТФИОБухгалтерПоследние.РасшифровкаПодписи, """") КАК Бухгалтер
	|ИЗ
	|	ВТДанныеДокументов КАК ДанныеДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОРуководителейПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОРуководителейПоследние.Ссылка
	|			И ДанныеДокументов.Руководитель = ВТФИОРуководителейПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОГлавБухПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОГлавБухПоследние.Ссылка
	|			И ДанныеДокументов.ГлавныйБухгалтер = ВТФИОГлавБухПоследние.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ВТФИОБухгалтерПоследние
	|		ПО ДанныеДокументов.Ссылка = ВТФИОБухгалтерПоследние.Ссылка
	|			И ДанныеДокументов.Бухгалтер = ВТФИОБухгалтерПоследние.ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеДокументов.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеДокументов.Дата, ГОД),
	|	ДанныеДокументов.НомерДокумента,
	|	ДанныеДокументов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеСтрокДокументов.Документ,
	|	ДанныеСтрокДокументов.НомерДокумента,
	|	ДанныеСтрокДокументов.НомерРеестра,
	|	ДанныеСтрокДокументов.ДатаДокумента,
	|	ДанныеСтрокДокументов.Организация,
	|	ДанныеСтрокДокументов.ФизическоеЛицо,
	|	ДанныеСтрокДокументов.Фамилия,
	|	ДанныеСтрокДокументов.Имя,
	|	ДанныеСтрокДокументов.Отчество,
	|	ДанныеСтрокДокументов.НомерЛицевогоСчета,
	|	ДанныеСтрокДокументов.СуммаКВыплате,
	|	ДанныеСтрокДокументов.ОтделениеБанка,
	|	ДанныеСтрокДокументов.ФилиалОтделенияБанка,
	|	ДанныеСтрокДокументов.КодВалюты
	|ИЗ
	|	ВТДанныеСтрокДокументов КАК ДанныеСтрокДокументов
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеСтрокДокументов.Организация,
	|	НАЧАЛОПЕРИОДА(ДанныеСтрокДокументов.ДатаДокумента, ГОД),
	|	ДанныеСтрокДокументов.НомерДокумента,
	|	ДанныеСтрокДокументов.Документ,
	|	ДанныеСтрокДокументов.НомерСтроки";
	
	РеквизитыПлатежногоДокумента = Неопределено;
	Если ПлатежныйДокумент <> Неопределено Тогда 
		РеквизитыПлатежногоДокумента = Новый Структура("ПлатежныйДокумент, Номер, Дата, Организация", ПлатежныйДокумент, "", Дата("00010101"), Неопределено);
		Выборка = РегистрыСведений.РеквизитыПлатежныхДокументовПеречисленияЗарплаты.Выбрать(Новый Структура("ПлатежныйДокумент", ПлатежныйДокумент));
		Если Выборка.Следующий() Тогда 
			ЗаполнитьЗначенияСвойств(РеквизитыПлатежногоДокумента, Выборка);
		КонецЕсли;
	КонецЕсли;
	
	ГодыВыгрузки = Новый Массив;
	СоответствиеДокументов = Новый Соответствие;
	Если РеквизитыПлатежногоДокумента <> Неопределено Тогда 
		ГодыВыгрузки.Добавить(Год(РеквизитыПлатежногоДокумента.Дата));
	КонецЕсли;
	Для Каждого ДокументСсылка Из МассивДокументов Цикл 
		ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Дата, Номер, Организация, НомерРеестра");
		Если РеквизитыПлатежногоДокумента = Неопределено Тогда 
			ГодВыгрузки = Год(ДанныеДокумента.Дата);
			Если ГодыВыгрузки.Найти(ГодВыгрузки) = Неопределено Тогда 
				ГодыВыгрузки.Добавить(ГодВыгрузки);
			КонецЕсли;
		КонецЕсли;
		СоответствиеДокументов.Вставить(ДокументСсылка, ДанныеДокумента);
	КонецЦикла;
	НомераРеестров = ОбменСБанкамиПоЗарплатнымПроектам.НомераРеестровДокументов(СоответствиеДокументов, ГодыВыгрузки, РеквизитыПлатежногоДокумента);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	КоличествоЗаписей = 0;
	СуммаИтого = 0;
	ДанныеДокументов = Новый Соответствие;
	ВыборкаДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()-1].Выбрать();
	ВыборкаСтрокДокументов = РезультатыЗапроса[РезультатыЗапроса.ВГраница()].Выбрать();
	Пока ВыборкаДокументов.Следующий() Цикл
		
		ДанныеДокумента = ДанныеЗаполненияВедомости();
		ЗаполнитьЗначенияСвойств(ДанныеДокумента, ВыборкаДокументов);
		
		КоличествоЗаписей = КоличествоЗаписей + ВыборкаДокументов.КоличествоЗаписей;
		СуммаИтого = СуммаИтого + ВыборкаДокументов.СуммаИтого;
		
		ДанныеДокумента.ДатаФормирования = ?(ДатаПолученияДанных = Неопределено, ДанныеДокумента.ДатаДокумента, ДатаПолученияДанных);
		Если ПлатежныйДокумент <> Неопределено Тогда
			ДанныеДокумента.ИдПервичногоДокумента = ПлатежныйДокумент.УникальныйИдентификатор();
			ДанныеДокумента.НомерПлатежногоПоручения = Прав(РеквизитыПлатежногоДокумента.Номер, 6);
			ДанныеДокумента.ДатаПлатежногоПоручения = РеквизитыПлатежногоДокумента.Дата;
			ДанныеДокумента.ДатаДокумента = РеквизитыПлатежногоДокумента.Дата;
			ДанныеДокумента.КоличествоЗаписей = КоличествоЗаписей;
			ДанныеДокумента.СуммаИтого = СуммаИтого;
			ДанныеДокумента.ДанныеРеестра = НомераРеестров[ПлатежныйДокумент];
			НомерРеестра = СтрЗаменить(ДанныеДокумента.ДанныеРеестра.НомерРеестра, Символы.НПП, "");
			ДанныеДокумента.НомерРеестра = НомерРеестра;
			НомерРеестра = Прав(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРеестра, 3), 3);
			ДанныеДокумента.ИмяФайла = ОбменСБанкамиПоЗарплатнымПроектам.ИмяФайлаОбменаСБанкамиПоЗарплатнымПроектам(ПлатежныйДокумент, ДанныеДокумента.ОтделениеБанка, НомерРеестра, "z");
		Иначе
			ДанныеДокумента.ИдПервичногоДокумента = ДанныеДокумента.Документ.УникальныйИдентификатор();
			ДанныеДокумента.ДанныеРеестра = НомераРеестров[ДанныеДокумента.Документ];
			НомерРеестра = СтрЗаменить(ДанныеДокумента.ДанныеРеестра.НомерРеестра, Символы.НПП, "");
			ДанныеДокумента.НомерРеестра = НомерРеестра;
			НомерРеестра = Прав(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРеестра, 3), 3);
			НомерРеестра = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРеестра, 3);
			ДанныеДокумента.ИмяФайла = ОбменСБанкамиПоЗарплатнымПроектам.ИмяФайлаОбменаСБанкамиПоЗарплатнымПроектам(ДанныеДокумента.Документ, ДанныеДокумента.ОтделениеБанка, НомерРеестра, "z");
		КонецЕсли;
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ЗаполнитьДанныеОплатыВедомостей(
			ДанныеДокумента.Документ, ДанныеДокумента.НомерПлатежногоПоручения, ДанныеДокумента.ДатаПлатежногоПоручения, ПлатежныйДокумент);
		
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеШапкиДокументаДляПолученияТекстаФайла(
			ДанныеДокумента, ДанныеДокумента.Документ, ?(ДатаПолученияДанных = Неопределено, ДанныеДокумента.ДатаДокумента, ДатаПолученияДанных));
		
		ВыборкаСтрокДокументов.Сбросить();
		Пока ВыборкаСтрокДокументов.НайтиСледующий(ВыборкаДокументов.Документ, "Документ") Цикл
			ДанныеСтрокиДокумента = ДанныеЗаполненияСтрокиВедомости();
			ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ДополнитьКолонкиДанныхСтрокДокументов(ДанныеСтрокиДокумента);
			ЗаполнитьЗначенияСвойств(ДанныеСтрокиДокумента, ВыборкаСтрокДокументов);
			
			ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ЗаполнитьКолонкиДанныхСтрокДокумента(ДанныеСтрокиДокумента);
			ДанныеДокумента.Сотрудники.Добавить(ДанныеСтрокиДокумента);
			ДанныеДокумента.Сотрудники[ДанныеДокумента.Сотрудники.Количество()-1].НомерСтроки = ДанныеДокумента.Сотрудники.Количество();
			Если ДанныеДокумента.ИспользоватьЭлектронныйДокументооборотСБанком И СтрДлина(ДанныеСтрокиДокумента.НомерЛицевогоСчета) <> 20 Тогда
				СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='По ведомости в банк №%1 от %2г. в строке №%3 у сотрудника %4 лицевой счет менее 20 цифр.
							|Если номер действительно не удовлетворяет этому требованию, возможно,
							|банк не поддерживает обмен по типовому стандарту - следует обратиться в банк'"), 
						ДанныеДокумента.НомерДокумента, 
						Формат(ДанныеДокумента.ДатаДокумента, "ДЛФ=D"),
						ДанныеСтрокиДокумента.НомерСтроки,
						ДанныеСтрокиДокумента.ФизическоеЛицо);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ДанныеДокумента.Документ,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Состав[%1].%2'"),
						ДанныеСтрокиДокумента.НомерСтроки-1,
						"НомерЛицевогоСчета"));
			КонецЕсли;
		КонецЦикла;
		ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОпределитьДанныеСтрокДокументовДляПолученияТекстаФайла(
			ДанныеДокумента, 
			?(ДатаПолученияДанных = Неопределено, ДанныеДокумента.ДатаДокумента, ДатаПолученияДанных));
		
		Если ПлатежныйДокумент <> Неопределено Тогда
			ДанныеДокумента.Документ = ПлатежныйДокумент;
			ДанныеПлатежногоДокумента = ДанныеДокументов.Получить(ПлатежныйДокумент);
			Если ДанныеПлатежногоДокумента <> Неопределено Тогда
				Для Каждого СтруктураСтроки Из ДанныеПлатежногоДокумента.Сотрудники Цикл
					НайденнаяСтрокаПоФизическомуЛицу = Неопределено;
					Для каждого СтруктураСтрокиДокумента Из ДанныеДокумента.Сотрудники Цикл
						Если СтруктураСтрокиДокумента.ФизическоеЛицо = СтруктураСтроки.ФизическоеЛицо
							И СтруктураСтрокиДокумента.НомерЛицевогоСчета = СтруктураСтроки.НомерЛицевогоСчета Тогда
							НайденнаяСтрокаПоФизическомуЛицу = СтруктураСтрокиДокумента;
							Прервать;
						КонецЕсли
					КонецЦикла;
					Если НайденнаяСтрокаПоФизическомуЛицу = Неопределено Тогда
						ДанныеДокумента.Сотрудники.Добавить(СтруктураСтроки);
						ДанныеДокумента.Сотрудники[ДанныеДокумента.Сотрудники.Количество()-1].НомерСтроки = ДанныеДокумента.Сотрудники.Количество();
					Иначе
						НайденнаяСтрокаПоФизическомуЛицу.СуммаКВыплате = НайденнаяСтрокаПоФизическомуЛицу.СуммаКВыплате + СтруктураСтроки.СуммаКВыплате;
					КонецЕсли;
				КонецЦикла;
				ДанныеДокумента.КоличествоЗаписей = ДанныеДокумента.Сотрудники.Количество();
			КонецЕсли;
		КонецЕсли;
		ДанныеДокументов.Вставить(ДанныеДокумента.Документ, ДанныеДокумента);
		
	КонецЦикла;
	
	Возврат ДанныеДокументов;
	
КонецФункции

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВедомостьПрочихДоходовВБанк;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

	
#Область СлужебныеПроцедурыИФункции

Функция РеквизитыОтветственныхЛиц() Экспорт
	
	Возврат ВзаиморасчетыССотрудниками.ВедомостьРеквизитыОтветственныхЛиц();
	
КонецФункции

// Возвращает соответствие физических лиц номерам лицевых счетов.
//
// Параметры:
//		Ведомости - массив ссылок на документы.
//		ЛицевыеСчета - массив с номерами лицевых счетов, для которых требуется найти физических лиц.
//
// Возвращаемое значение:
//		Соответствие, где ключ - это номер лицевого счета, значение - физическое лицо.
//
Функция ФизическиеЛицаЛицевыхСчетов(Ведомости, ЛицевыеСчета) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ведомости",    Ведомости);
	Запрос.УстановитьПараметр("ЛицевыеСчета", ЛицевыеСчета);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВедомостьСостав.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк.Состав КАК ВедомостьСостав
	|ГДЕ
	|	ВедомостьСостав.Ссылка В(&Ведомости)
	|	И ВедомостьСостав.НомерЛицевогоСчета В(&ЛицевыеСчета)";
	
	ФизическиеЛицаЛицевыхСчетов = Новый Соответствие;
	Выборка =  Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ФизическиеЛицаЛицевыхСчетов.Вставить(Выборка.НомерЛицевогоСчета, Выборка.ФизическоеЛицо);
	КонецЦикла;
	
	Возврат ФизическиеЛицаЛицевыхСчетов;
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	ВзаиморасчетыПоПрочимДоходам.ВедомостьВБанкДобавитьКомандыПечати(КомандыПечати)	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ВзаиморасчетыПоПрочимДоходам.ВедомостьВБанкПечать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
КонецПроцедуры

Функция ПечатьСпискаПеречисленийПоДокументам(МассивОбъектов, ОбъектыПечати, ПлатежныйДокумент = Неопределено) Экспорт
	
	ТабличныйДокумент = ПечатьСписокПеречислений(
		МассивОбъектов,
		ОбъектыПечати,
		ДанныеВедомостиНаВыплатуЗарплатыВБанк(МассивОбъектов, , ПлатежныйДокумент, Ложь));
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати, ДанныеДляПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВедомостьПрочихДоходовВБанк_СписокПеречислений";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_СписокПеречисленийНаЛицевыеСчета");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеДокументаДляПечати Из ДанныеДляПечати Цикл
		
		ДанныеДокумента = ДанныеДокументаДляПечати.Значение;
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ДанныеДокумента.Сотрудники.Количество();
		
		ОбластьМакетаШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		ОбластьМакетаШапка			= Макет.ПолучитьОбласть("Шапка");
		ОбластьМакетаСтрока 		= Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаИтогПоСтранице = Макет.ПолучитьОбласть("ИтогПоЛисту");
		ОбластьМакетаПодвал 		= Макет.ПолучитьОбласть("Подвал");
		
		// Массив с двумя строками - для разбиения на страницы.
		ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьМакетаСтрока);
		ВыводимыеОбласти.Добавить(ОбластьМакетаИтогПоСтранице);
		
		// выводим данные о документе
		ОбластьМакетаШапкаДокумента.Параметры.Дата = Формат(ДанныеДокумента.ДатаДокумента, "ДЛФ=D");
		ОбластьМакетаШапкаДокумента.Параметры.Организация = СокрЛП(ДанныеДокумента.ПолноеНаименованиеОрганизации);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		
		// Выводим данные по строкам документа.
		Для Каждого ДанныеДляПечатиСтроки Из ДанныеДокумента.Сотрудники Цикл
			
			ОбластьМакетаСтрока.Параметры.НомерСтроки = ДанныеДляПечатиСтроки.НомерСтроки;
			ОбластьМакетаСтрока.Параметры.НомерЛицевогоСчета = ДанныеДляПечатиСтроки.НомерЛицевогоСчета;
			ОбластьМакетаСтрока.Параметры.Физлицо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2 %3'"), ДанныеДляПечатиСтроки.Фамилия, ДанныеДляПечатиСтроки.Имя, ДанныеДляПечатиСтроки.Отчество);
			ОбластьМакетаСтрока.Параметры.Сумма = ДанныеДляПечатиСтроки.СуммаКВыплате;
			
			// разбиение на страницы
			ВыведеноСтрок = ВыведеноСтрок + 1;
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу.
			ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста И ВыведеноСтрок = ВсегоСтрокДокумента Тогда
				ВыводимыеОбласти.Добавить(ОбластьМакетаПодвал);
				ВывестиПодвалЛиста = Не ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				
				ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
				ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				ВыведеноСтраниц = ВыведеноСтраниц + 1;
				ИтогоНаСтранице = 0;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакетаСтрока);
			ИтогоНаСтранице = ИтогоНаСтранице + ДанныеДляПечатиСтроки.СуммаКВыплате;
			Итого = Итого + ДанныеДляПечатиСтроки.СуммаКВыплате;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		КонецЕсли;
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ДанныеДокумента);
		ОбластьМакетаПодвал.Параметры.Итого = Итого;
		
		// дополняем пустыми строками до конца страницы
		ОбщегоНазначенияБЗК.ОчиститьПараметрыТабличногоДокумента(ОбластьМакетаСтрока);
		ОбластиКонцаСтраницы = Новый Массив();
		ОбластиКонцаСтраницы.Добавить(ОбластьМакетаИтогПоСтранице);
		ОбластиКонцаСтраницы.Добавить(ОбластьМакетаПодвал);
		ОбщегоНазначенияБЗК.ДополнитьСтраницуТабличногоДокумента(ТабличныйДокумент, ОбластьМакетаСтрока, ОбластиКонцаСтраницы);  
		
		ТабличныйДокумент.Вывести(ОбластьМакетаИтогПоСтранице);
		ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДокумента.Документ);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#Область ФормированиеФайлаОбменаСБанками

// Формирует и прикрепляет файл обмена к документам с помощью подсистемы "Файлы".
//
// Параметры:
//		СтруктураПараметровДляФормированияФайла - Структура - должна содержать значения:
//			МассивДокументов - Массив ссылок на документы, по которым требуется сформировать файл.
//			МассивОписанийФайлов - Массив описаний сформированных файлов.
//
Процедура ВыгрузитьФайлыДляОбменаСБанком(СтруктураПараметровДляФормированияФайла) Экспорт
	
	ОбменСБанкамиПоЗарплатнымПроектам.ВыгрузитьФайлыДляОбменаСБанкомПоВедомости(СтруктураПараметровДляФормированияФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОграничениеДокумента

Функция ПредставлениеПометкиОграничения() Экспорт
	
	Возврат НСтр("ru = 'Передан для выплаты'");
	
КонецФункции

Функция ОперацияОграниченияДокумента() Экспорт
	
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВБанкОперацияОграниченияДокумента();
	
КонецФункции

#КонецОбласти

Функция ТекстЗапросаДанныеДляОплаты(ИмяПараметраВедомости = "Ведомости", ИмяПараметраФизическиеЛица = "ФизическиеЛица") Экспорт
	Возврат 
		ВзаиморасчетыПоПрочимДоходам.ВедомостьТекстЗапросаДанныеДляОплаты(
			Метаданные.Документы.ВедомостьПрочихДоходовВБанк.ПолноеИмя(), 
			ИмяПараметраВедомости, ИмяПараметраФизическиеЛица);
КонецФункции	

#КонецОбласти

#КонецЕсли