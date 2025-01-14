#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьМесяца(Ссылка, МесяцИндексации, "Объект.МесяцИндексации", Отказ, НСтр("ru='Месяц индексации'"), , , Ложь);
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= МесяцИндексации;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= МесяцИндексации;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ДанныеПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеПроведения.СотрудникиДаты, Ссылка);
	
	Если ДанныеПроведения["КоэффициентыИндексации"].Количество() > 0 Тогда
		Движения.КоэффициентИндексацииЗаработка.Загрузить(ДанныеПроведения["КоэффициентыИндексации"]);
		Движения.КоэффициентИндексацииЗаработка.Записывать = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоДовольствия") Тогда		
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоДовольствия");
		Модуль.ЗарегистрироватьКоэффициентыИндексацииДенежногоДовольствия(Движения, Отказ, МесяцИндексации, ДанныеПроведения.КоэффициентыИндексацииДенежногоДовольствия);
	КонецЕсли;
		
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеПроведения.ЗначенияПоказателей);
	
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИндексацияШтатногоРасписания") Тогда
		
		ЭтотОбъект.Дата = ТекущаяДатаСеанса();
		ЭтотОбъект.МесяцИндексации = ДанныеЗаполнения.МесяцИндексации;
		ЭтотОбъект.Организация = ДанныеЗаполнения.Организация;
		ЭтотОбъект.Подразделение = ДанныеЗаполнения.Подразделение;
		ЭтотОбъект.КоэффициентИндексации = ДанныеЗаполнения.КоэффициентИндексации;
		
		ЭтотОбъект.Показатели.Загрузить(ДанныеЗаполнения.ИндексируемыеПоказатели.Выгрузить());
		
		ЗаполнитьДокумент(ЗарплатаКадрыРасширенный.ВремяРегистрацииДокумента(Ссылка, МесяцИндексации));
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокумент(ДатаИндексации, СохранятьИсправления = Ложь) Экспорт
	
	Менеджер = Документы.ИндексацияЗаработка;
	
	Если СохранятьИсправления Тогда
		ОтредактированныеПоказатели = ЗначенияПоказателей.Выгрузить();
	Иначе
		ОтредактированныеПоказатели = Неопределено;
	КонецЕсли;
	
	Сотрудники.Очистить();
	НачисленияСотрудников.Очистить();
	ЗначенияПоказателей.Очистить();
	ПересчетТарифныхСтавок.Очистить();
	
	МассивСотрудников = Менеджер.СотрудникиДляИндексации(Организация, Подразделение, ДатаИндексации, ЗначениеЗаполнено(ВидИндексацииГосударственныхСлужащих),ИндексацияВоеннослужащих);
	
	ВремяРегистрацииСотрудников = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудниковДокумента(Ссылка, МассивСотрудников, ДатаИндексации);
	
	ТекущиеПоказателиСотрудников = Менеджер.ТекущиеПоказателиСотрудников(Ссылка, 
																		Показатели.Выгрузить(, "Показатель").ВыгрузитьКолонку("Показатель"), 
																		ДатаИндексации, 
																		МассивСотрудников,
																		ВремяРегистрацииСотрудников);
	
	РезультатИндексации = Менеджер.ИндексированныеЗначенияПоказателейСотрудников(ТекущиеПоказателиСотрудников, 
																		КоэффициентИндексации, 
																		ОтредактированныеПоказатели, 
																		Показатели.Выгрузить(, "Показатель,СпособОкругления"),
																		ИндексацияВоеннослужащих,
																		ВидИндексацииГосударственныхСлужащих);	
																		
	ТаблицаНачисленийСотрудников = Менеджер.НачисленияСотрудников(Ссылка, 
																ДатаИндексации, 
																РезультатИндексации.КоэффициентыИндексацииСотрудников.ВыгрузитьКолонку("Сотрудник"),
																ВремяРегистрацииСотрудников);
																
	ПересчетТарифныхСтавок.Очистить();																
	Менеджер.РассчитатьФОТ(Ссылка, Организация, ДатаИндексации, 
		ТаблицаНачисленийСотрудников, РезультатИндексации.ЗначенияПоказателейСотрудников, ПересчетТарифныхСтавок, ВремяРегистрацииСотрудников);
	
	ИзвестныеПоказатели = ЗарплатаКадрыРасширенный.ПоказателиРасчетаСовокупныхТарифныхСтавок();
	Для Каждого СтрокаПоказателя Из РезультатИндексации.ЗначенияПоказателейСотрудников Цикл 
		НоваяСтрока = ИзвестныеПоказатели.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПоказателя);
		НоваяСтрока.Период = ВремяРегистрацииСотрудников.Получить(НоваяСтрока.Сотрудник);
	КонецЦикла;
		
	ЗначенияПоказателей.Загрузить(РезультатИндексации.ЗначенияПоказателейСотрудников);
	Сотрудники.Загрузить(РезультатИндексации.КоэффициентыИндексацииСотрудников);
	НачисленияСотрудников.Загрузить(ТаблицаНачисленийСотрудников);

КонецПроцедуры

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Параметры = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	Параметры.Организация 		= Организация;
	Параметры.Подразделение 	= Подразделение;
	Параметры.НачалоПериода 	= МесяцИндексации;
	Параметры.ОкончаниеПериода 	= МесяцИндексации;
	Параметры.КадровыеДанные 	= "ФизическоеЛицо";
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Параметры);
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", МесяцИндексации);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НачисленияПоказатели.Ссылка КАК Ссылка,
		|	НачисленияПоказатели.Ссылка.ФОТНеРедактируется КАК ФОТНеРедактируется
		|ПОМЕСТИТЬ ИндексируемыеНачисления
		|ИЗ
		|	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИндексацияЗаработка.Показатели КАК ИндексацияЗаработкаПоказатели
		|		ПО НачисленияПоказатели.Показатель = ИндексацияЗаработкаПоказатели.Показатель
		|ГДЕ
		|	ИндексацияЗаработкаПоказатели.Ссылка = &Ссылка
		|	И НачисленияПоказатели.ЗапрашиватьПриВводе
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Период КАК ДатаСобытия,
		|	ИндексацияЗаработкаНачисленияСотрудников.Сотрудник КАК Сотрудник,
		|	ИндексацияЗаработкаНачисленияСотрудников.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИндексацияЗаработкаНачисленияСотрудников.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ИндексацияЗаработкаНачисленияСотрудников.Начисление КАК Начисление,
		|	ИндексацияЗаработкаНачисленияСотрудников.ДокументОснование КАК ДокументОснование,
		|	ИСТИНА КАК Используется,
		|	ИндексацияЗаработкаНачисленияСотрудников.Размер КАК Размер
		|ИЗ
		|	Документ.ИндексацияЗаработка.НачисленияСотрудников КАК ИндексацияЗаработкаНачисленияСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления КАК Начисления
		|		ПО ИндексацияЗаработкаНачисленияСотрудников.Начисление = Начисления.Ссылка
		|ГДЕ
		|	ИндексацияЗаработкаНачисленияСотрудников.Ссылка = &Ссылка
		|	И НЕ Начисления.ФОТНеРедактируется
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&Период,
		|	ИндексацияЗаработкаНачисленияСотрудников.Сотрудник,
		|	ИндексацияЗаработкаНачисленияСотрудников.Сотрудник.ФизическоеЛицо,
		|	ИндексацияЗаработкаНачисленияСотрудников.Сотрудник.ГоловнаяОрганизация,
		|	ИндексацияЗаработкаНачисленияСотрудников.Начисление,
		|	ИндексацияЗаработкаНачисленияСотрудников.ДокументОснование,
		|	ИСТИНА,
		|	ИндексацияЗаработкаНачисленияСотрудников.Размер
		|ИЗ
		|	Документ.ИндексацияЗаработка.НачисленияСотрудников КАК ИндексацияЗаработкаНачисленияСотрудников
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИндексируемыеНачисления КАК ИндексируемыеНачисления
		|		ПО ИндексацияЗаработкаНачисленияСотрудников.Начисление = ИндексируемыеНачисления.Ссылка
		|ГДЕ
		|	ИндексацияЗаработкаНачисленияСотрудников.Ссылка = &Ссылка
		|	И ИндексируемыеНачисления.ФОТНеРедактируется";
		
	ДанныеДляПроведения = Новый Структура; 
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	ИндексацияЗаработкаСотрудники.Сотрудник,
		|	ИндексацияЗаработкаСотрудники.КоэффициентИндексации КАК Коэффициент
		|ИЗ
		|	Документ.ИндексацияЗаработка.Сотрудники КАК ИндексацияЗаработкаСотрудники
		|ГДЕ
		|	ИндексацияЗаработкаСотрудники.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Организация КАК Организация,
		|	СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИндексацияЗаработкаПоказатели.Сотрудник КАК Сотрудник,
		|	ИндексацияЗаработкаПоказатели.Показатель,
		|	ИндексацияЗаработкаПоказатели.ДокументОснование,
		|	ИндексацияЗаработкаПоказатели.Значение,
		|	&Период КАК ДатаСобытия
		|ИЗ
		|	Документ.ИндексацияЗаработка.ЗначенияПоказателей КАК ИндексацияЗаработкаПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК СотрудникиОрганизации
		|		ПО ИндексацияЗаработкаПоказатели.Сотрудник = СотрудникиОрганизации.Сотрудник
		|ГДЕ
		|	ИндексацияЗаработкаПоказатели.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Период КАК ДатаСобытия,
		|	ПересчетТарифныхСтавок.Сотрудник КАК Сотрудник,
		|	ПересчетТарифныхСтавок.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК Значение,
		|	ВЫБОР
		|		КОГДА ПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка = 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
		|		ИНАЧЕ ПересчетТарифныхСтавок.ВидТарифнойСтавки
		|	КОНЕЦ КАК ВидТарифнойСтавки,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИндексацияЗаработка.ПересчетТарифныхСтавок КАК ПересчетТарифныхСтавок
		|ГДЕ
		|	ПересчетТарифныхСтавок.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	&Период КАК ДатаСобытия,
		|	НачисленияСотрудников.Сотрудник КАК Сотрудник
		|ИЗ
		|	Документ.ИндексацияЗаработка.НачисленияСотрудников КАК НачисленияСотрудников
		|ГДЕ
		|	НачисленияСотрудников.Ссылка = &Ссылка";
		
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения.Вставить("КоэффициентыИндексации", 			РезультатыЗапроса[0].Выгрузить());
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей",				РезультатыЗапроса[1].Выгрузить());
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок", 	РезультатыЗапроса[2].Выгрузить());
	ДанныеДляПроведения.Вставить("СотрудникиДаты", 					РезультатыЗапроса[3].Выгрузить());
			
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоДовольствия") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоДовольствия");
		КоэффициентыИндексацииДенежногоДовольствия = Модуль.ТаблицаКоэффициентовИндексацииДенежногоДовольствияСотрудников(ЗначенияПоказателей.Выгрузить(), ИндексацияВоеннослужащих, ВидИндексацииГосударственныхСлужащих);
		ДанныеДляПроведения.Вставить("КоэффициентыИндексацииДенежногоДовольствия", КоэффициентыИндексацииДенежногоДовольствия);
		
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	ТаблицаДокумента.Ссылка.МесяцИндексации КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ИндексацияЗаработка.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
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
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, МесяцИндексации);
	
КонецФункции

#КонецОбласти

#КонецЕсли
