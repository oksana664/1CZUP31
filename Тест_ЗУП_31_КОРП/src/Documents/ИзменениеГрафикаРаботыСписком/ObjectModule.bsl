#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru='Дата изменения'"), , , Ложь);
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.Подразделение				= Подразделение;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаОкончания;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ	= Неопределено;
	ПараметрыПолученияСотрудниковОрганизаций.ИсключаемыйРегистратор		= Ссылка;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	Если ДатаИзменения > ДатаОкончания
		И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Дата окончания не может быть меньше даты начала изменения графика работы'"), ЭтотОбъект, "ДатаОкончания", ,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеПроведения.СотрудникиДаты, Ссылка);
	
	КадровыйУчетРасширенный.СформироватьИсториюИзмененияГрафиков(Движения, ДанныеПроведения.СотрудникиДаты);
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеПроведения.ПлановыеНачисления);
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
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
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИзменениеГрафикаРаботыСписком") Тогда
		ЭтотОбъект.Дата = ТекущаяДатаСеанса();
		ЭтотОбъект.ДатаИзменения = ДанныеЗаполнения.ДатаИзменения;
		ЭтотОбъект.ДатаОкончания = ДанныеЗаполнения.ДатаОкончания;
		ЭтотОбъект.Организация = ДанныеЗаполнения.Организация;
		ЭтотОбъект.Подразделение = ДанныеЗаполнения.Подразделение;
		ЭтотОбъект.ГрафикРаботы = ДанныеЗаполнения.ГрафикРаботы;
		
		ЗаполнитьДокумент(ДанныеЗаполнения.ДатаИзменения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	
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
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ДатаИзменения);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокумент(ВремяРегистрации) Экспорт
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	Менеджер = Документы.ИзменениеГрафикаРаботыСписком;
	
	Сотрудники.Очистить();
	НачисленияСотрудников.Очистить();
	ПересчетТарифныхСтавок.Очистить();
	
	МассивСотрудников = Менеджер.СотрудникиДляИзмененияГрафика(Организация, Подразделение, ДатаИзменения);
	
	ТаблицаНачисленийСотрудников = Документы.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников(
		Ссылка, ДатаИзменения, МассивСотрудников);
		
	Менеджер.РассчитатьФОТ(Ссылка, Организация, ДатаИзменения, ГрафикРаботы, ТаблицаНачисленийСотрудников, ПересчетТарифныхСтавок);
		
	ТаблицаНачисленийСотрудниковВрем = ТаблицаНачисленийСотрудников.Скопировать();
	ТаблицаНачисленийСотрудниковВрем.Свернуть("Сотрудник, ФиксСтрока");
	Сотрудники.Загрузить(ТаблицаНачисленийСотрудниковВрем);
	НачисленияСотрудников.Загрузить(ТаблицаНачисленийСотрудников);
		
	ОценкаПроизводительности.ЗакончитьЗамерВремени("ЗаполнениеДокументаИзменениеГрафикаРаботыСписком",
		ВремяНачалаЗамера);
	
КонецПроцедуры

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаИзменения", ДатаИзменения);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ДатаИзменения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА &ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ &ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Сотрудник КАК Сотрудник,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Начисление КАК Начисление,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.ДокументОснование КАК ДокументОснование,
	|	ИСТИНА КАК Используется,
	|	ИСТИНА КАК ИспользуетсяПоОкончании,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Размер КАК Размер
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников КАК ИзменениеГрафикаРаботыСпискомНачисленияСотрудников
	|ГДЕ
	|	НЕ ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Начисление.ФОТНеРедактируется
	|	И ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ДатаИзменения КАК ДатаСобытия,
	|	ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Сотрудник КАК Сотрудник,
	|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ИзменениеГрафикаРаботыПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК Значение,
	|	ВЫБОР
	|		КОГДА ИзменениеГрафикаРаботыПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
	|		ИНАЧЕ ИзменениеГрафикаРаботыПересчетТарифныхСтавок.ВидТарифнойСтавки
	|	КОНЕЦ КАК ВидТарифнойСтавки,
	|	ВЫБОР
	|		КОГДА ИзменениеГрафикаРаботыСписком.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеГрафикаРаботыСписком.ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ ИзменениеГрафикаРаботыСписком.ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.ПересчетТарифныхСтавок КАК ИзменениеГрафикаРаботыПересчетТарифныхСтавок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеГрафикаРаботыСписком КАК ИзменениеГрафикаРаботыСписком
	|		ПО ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Ссылка = ИзменениеГрафикаРаботыСписком.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК СправочникСотрудники
	|		ПО ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Сотрудник = СправочникСотрудники.Ссылка
	|ГДЕ
	|	ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаИзменения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА ИзменениеГрафикаРаботыСписком.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеГрафикаРаботыСписком.ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ ИзменениеГрафикаРаботыСписком.ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо,
	|	ИзменениеГрафикаРаботыНачисленияСотрудников.Сотрудник КАК Сотрудник,
	|	ИзменениеГрафикаРаботыСписком.ГрафикРаботы КАК ГрафикРаботы,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников КАК ИзменениеГрафикаРаботыНачисленияСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеГрафикаРаботыСписком КАК ИзменениеГрафикаРаботыСписком
	|		ПО ИзменениеГрафикаРаботыНачисленияСотрудников.Ссылка = ИзменениеГрафикаРаботыСписком.Ссылка
	|ГДЕ
	|	ИзменениеГрафикаРаботыНачисленияСотрудников.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ИзменениеГрафикаРаботыНачисленияСотрудников.Сотрудник,
	|	ИзменениеГрафикаРаботыСписком.ДатаОкончания,
	|	ИзменениеГрафикаРаботыСписком.ГрафикРаботы";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура; 
	ДанныеДляПроведения.Вставить("ПлановыеНачисления",				РезультатыЗапроса[0].Выгрузить());
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок",	РезультатыЗапроса[1].Выгрузить());
	ДанныеДляПроведения.Вставить("СотрудникиДаты", 					РезультатыЗапроса[2].Выгрузить());
	
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
	|	ТаблицаДокумента.Ссылка.ДатаИзменения КАК ПериодДействия,
	|	ТаблицаДокумента.Ссылка КАК ДокументОснование
	|ПОМЕСТИТЬ ВТДанныеДокументов
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.Сотрудники КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Регистратор";
	
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.ИзменениеГрафикаРаботыСписком.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
	
КонецФункции

#КонецОбласти

#КонецЕсли
