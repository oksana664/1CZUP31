#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	РегистрироватьВзаиморасчеты = ПолучитьФункциональнуюОпцию("ИспользоватьВедомостиДляВыплатыПрочихДоходов") И РегистрироватьВыплатуВедомостью;
	СпособРасчетовСФизическимиЛицами = ?(РегистрироватьВзаиморасчеты,Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами,Неопределено);
	
	МесяцНачисления = НачалоМесяца(ПериодРегистрации);
		
	// НДФЛ
	ДатаОперацииПоНалогам = УчетНДФЛРасширенный.ДатаОперацииПоДокументу(ПланируемаяДатаВыплаты, ПериодРегистрации);
	УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, Организация, ДатаОперацииПоНалогам, ДанныеДляПроведения.ДанныеДляНДФЛДоходы, Ложь, Ложь, Ссылка);
	УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, Организация, ДатаОперацииПоНалогам, ДанныеДляПроведения.ДанныеДляНДФЛИВычетов, Ложь, Ложь, ПланируемаяДатаВыплаты);
	
	Если Не РегистрироватьВзаиморасчеты Тогда
		УчетНДФЛ.СформироватьУдержанныйНалогПоТаблицеЗначений(Движения, Отказ, Организация, ПланируемаяДатаВыплаты, ДанныеДляПроведения.ДанныеДляНДФЛ);
		УчетНДФЛРасширенный.УточнитьУчетНалогаПоЦеннымБумагам(Движения);
		УчетНДФЛРасширенный.ЗарегистрироватьНДФЛПеречисленныйПоПлатежномуДокументу(Движения, Отказ, Организация, ДатаПлатежаНДФЛ, ПеречислениеНДФЛРеквизиты);
	КонецЕсли;
	
	// - Регистрация начислений и удержаний.
	УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛ, Организация, ДатаОперацииПоНалогам);
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(Движения, Отказ, Организация, МесяцНачисления,
						ДанныеДляПроведения.Начисления, ДанныеДляПроведения.УдержанияКонтрагентов, ДанныеДляПроведения.НДФЛ, СпособРасчетовСФизическимиЛицами);
	
	ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоКонтрагентамАкционерам(
						Движения, Отказ, Организация, МесяцНачисления,
						ДанныеДляПроведения.Начисления,ДанныеДляПроведения.УдержанияКонтрагентов,ДанныеДляПроведения.НДФЛ,Истина);
							
	РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, Организация, ДатаОперацииПоНалогам, ДанныеДляПроведения.Удержания);
	ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
	РасчетЗарплатыРасширенный.СформироватьДвиженияУдержанийДоПределаПоСотрудникам(Движения, Отказ, МесяцНачисления, ДанныеДляПроведения.УдержанияДоПределаПоСотрудникам);
	РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
	
	// Страховые взносы
	УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.ДанныеДляВзносов, Истина);
	УчетСтраховыхВзносов.СформироватьИсчисленныеВзносы(ЭтотОбъект.Движения, Отказ, Организация, МесяцНачисления, ДанныеДляПроведения.СтраховыеВзносы);
	УчетСтраховыхВзносов.СформироватьСтраховыеВзносыПоФизическимЛицам(Движения, Отказ, Организация, МесяцНачисления, Ссылка, ДанныеДляПроведения.СтраховыеВзносы);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);

	ЗарплатаКадрыРасширенный.ПроверитьЗадвоениеФизическихЛицВТабличнойЧастиДокумента(
		ЭтотОбъект, "НачисленияУдержанияВзносы", Отказ);

	// Доходы с кодом НДФЛ 1010 (Дивиденды) регистрируются только документом "ДивидендыФизическимЛицам".
	ДивидендыНДФЛ = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыДоходовНДФЛ.Код1010");
	КодНДФЛ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотОбъект.ВидПрочегоДохода, "КодДоходаНДФЛ");
	Если КодНДФЛ = ДивидендыНДФЛ Тогда
		ТекстСообщения = "Доходы с кодом НДФЛ 1010 (Дивиденды) регистрируются только документом ""Дивиденды""";
		Поле = "Объект.ВидПрочегоДохода";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект.Ссылка, Поле, , Отказ);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВедомостиДляВыплатыПрочихДоходов") И ЭтотОбъект.РегистрироватьВыплатуВедомостью Тогда
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("ДатаПлатежаНДФЛ");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВсегоВыплачено = НачисленияУдержанияВзносы.Итог("КВыплате");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.РегистрацияПрочихДоходов.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
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
	МассивПараметров.Добавить(Новый Структура("НачисленияУдержанияВзносы", "ФизическоеЛицо"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическимЛицам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Документы.РегистрацияПрочихДоходов.СоздатьВТДанныеДокумента(Запрос.МенеджерВременныхТаблиц, Ссылка);
	Документы.РегистрацияПрочихДоходов.СоздатьВТНачисленияУдержанияДокумента(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, Организация, ПериодРегистрации);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленияДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	НачисленияДокумента.СтатьяФинансирования КАК СтатьяФинансирования,
	|	НачисленияДокумента.СтатьяРасходов КАК СтатьяРасходов
	|ИЗ
	|	ВТНачисленияДокумента КАК НачисленияДокумента";
	Выборка = Запрос.Выполнить().Выбрать();
	СтатьиФинансированияФизическихЛиц = Новый Соответствие;
	СтатьиРасходовФизическихЛиц = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		СтатьиФинансированияФизическихЛиц.Вставить(Выборка.ФизическоеЛицо, Выборка.СтатьяФинансирования);
		СтатьиРасходовФизическихЛиц.Вставить(Выборка.ФизическоеЛицо, Выборка.СтатьяРасходов);
	КонецЦикла;
	
	ДанныеДляПроведения.Вставить("ДанныеДляНДФЛДоходы", Документы.РегистрацияПрочихДоходов.ДанныеДляПроведениеНДФЛ(Запрос.МенеджерВременныхТаблиц));
	
	ДанныеДляПроведения.Вставить("ДанныеДляНДФЛ", ДанныеДляПроведения.ДанныеДляНДФЛДоходы.Скопировать());
	ДанныеДляПроведения.ДанныеДляНДФЛ.Колонки.Удалить("МесяцНалоговогоПериода");
	ДанныеДляПроведения.ДанныеДляНДФЛ.Колонки.ДатаПолученияДохода.Имя = "МесяцНалоговогоПериода";
	ДанныеДляПроведения.ДанныеДляНДФЛ.Колонки.СуммаДохода.Имя = "СуммаВыплаченногоДохода";
	
	ДанныеДляПроведения.ДанныеДляНДФЛ.Колонки.Добавить("УчитыватьВыплаченныйДоходВ6НДФЛ", Новый ОписаниеТипов("Булево"));
	ДанныеДляПроведения.ДанныеДляНДФЛ.ЗаполнитьЗначения(Истина, "УчитыватьВыплаченныйДоходВ6НДФЛ");
	ДанныеДляПроведения.ДанныеДляНДФЛДоходы.Колонки.Добавить("НеУчитыватьДоходВ6НДФЛ", Новый ОписаниеТипов("Булево"));
	ДанныеДляПроведения.ДанныеДляНДФЛДоходы.ЗаполнитьЗначения(Истина, "НеУчитыватьДоходВ6НДФЛ");
	
	ДанныеДляНДФЛИВычетов = Документы.РегистрацияПрочихДоходов.ДанныеДляПроведенияНДФЛИВычетов(Запрос.МенеджерВременныхТаблиц);
	ДанныеДляПроведения.Вставить("ДанныеДляНДФЛИВычетов", ?(ДанныеДляНДФЛИВычетов = Неопределено, ДанныеДляПроведения.ДанныеДляНДФЛ, ДанныеДляНДФЛИВычетов));
	
	ДанныеДляПроведения.Вставить("ДанныеДляВзносов", Документы.РегистрацияПрочихДоходов.ДанныеДляПроведенияВзносы(Запрос.МенеджерВременныхТаблиц));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.ФизическоеЛицо,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.Сумма,
	|	ДанныеДокумента.Начисление КАК Начисление,
	|	ДанныеДокумента.ДокументОснование,
	|	ДанныеДокумента.ОблагаетсяЕНВД,
	|	ДанныеДокумента.СтатьяФинансирования,
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.СпособОтраженияЗарплатыВБухучете
	|ИЗ
	|	ВТНачисленияДокумента КАК ДанныеДокумента";
	ДанныеДляПроведения.Вставить("Начисления", Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	ДанныеДокумента.Сумма КАК Сумма,
	|	ДанныеДокумента.НачислениеУдержание КАК НачислениеУдержание,
	|	ДанныеДокумента.ИсполнительныйДокумент КАК ДокументОснование,
	|	ДанныеДокумента.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|	ДанныеДокумента.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
	|			ТОГДА ДанныеДокумента.Получатель
	|		КОГДА ДанныеДокумента.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)
	|			ТОГДА ДанныеДокумента.ПлатежныйАгент
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Контрагент
	|ИЗ
	|	ВТУдержанияДокумента КАК ДанныеДокумента";
	ДанныеДляПроведения.Вставить("УдержанияКонтрагентов", Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеДокумента.Сумма КАК Результат,
	|	ДанныеДокумента.НачислениеУдержание КАК Удержание,
	|	ДанныеДокумента.ИсполнительныйДокумент КАК ДокументОснование,
	|	ДанныеДокумента.Получатель КАК Получатель,
	|	ДанныеДокумента.ПлатежныйАгент КАК ПлатежныйАгент,
	|	ДанныеДокумента.ДатаНачала КАК ДатаНачала,
	|	ДанныеДокумента.ДатаОкончания КАК ДатаОкончания
	|ИЗ
	|	ВТУдержанияДокумента КАК ДанныеДокумента";
	ДанныеДляПроведения.Вставить("Удержания", Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсполнительныеЛисты.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ИсполнительныеЛисты.СтатьяРасходов КАК СтатьяРасходов,
	|	ИсполнительныеЛисты.ИсполнительныйДокумент КАК ИсполнительныйДокумент,
	|	ИсполнительныеЛисты.Получатель КАК Получатель,
	|	ИсполнительныеЛисты.ПлатежныйАгент КАК ПлатежныйАгент,
	|	НАЧАЛОПЕРИОДА(ИсполнительныеЛисты.ДатаНачала, МЕСЯЦ) КАК МесяцУдержания,
	|	СУММА(ВЫБОР
	|			КОГДА ИсполнительныеЛисты.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
	|				ТОГДА ИсполнительныеЛисты.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаУдержания,
	|	СУММА(ВЫБОР
	|			КОГДА ИсполнительныеЛисты.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)
	|				ТОГДА ИсполнительныеЛисты.Сумма
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СуммаВознагражденияПлатежногоАгента
	|ИЗ
	|	ВТУдержанияДокумента КАК ИсполнительныеЛисты
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсполнительныеЛисты.СтатьяФинансирования,
	|	ИсполнительныеЛисты.СтатьяРасходов,
	|	ИсполнительныеЛисты.ИсполнительныйДокумент,
	|	ИсполнительныеЛисты.Получатель,
	|	ИсполнительныеЛисты.ПлатежныйАгент,
	|	НАЧАЛОПЕРИОДА(ИсполнительныеЛисты.ДатаНачала, МЕСЯЦ)
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ВЫБОР
	|				КОГДА ИсполнительныеЛисты.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ИсполнительныйЛист)
	|					ТОГДА ИсполнительныеЛисты.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ) <> 0
	|		ИЛИ СУММА(ВЫБОР
	|				КОГДА ИсполнительныеЛисты.КатегорияУдержания = ЗНАЧЕНИЕ(Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента)
	|					ТОГДА ИсполнительныеЛисты.Сумма
	|				ИНАЧЕ 0
	|			КОНЕЦ) <> 0)";
	ДанныеДляПроведения.Вставить("УдержанияПоИсполнительнымДокументам", Запрос.Выполнить().Выгрузить());
	
	// Удержания до предела по сотрудникам
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПредельныеСуммыУдержанийСотрудниковСрезПоследних.Организация КАК Организация,
	|	ПредельныеСуммыУдержанийСотрудниковСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ПредельныеСуммыУдержанийСотрудниковСрезПоследних.Удержание КАК Удержание,
	|	ПредельныеСуммыУдержанийСотрудниковСрезПоследних.ДокументОснование КАК ДокументОснование,
	|	ПредельныеСуммыУдержанийСотрудниковСрезПоследних.ПрекратитьПоДостижениюПредела КАК ПрекратитьПоДостижениюПредела
	|ПОМЕСТИТЬ ВТПредельныеСуммыУдержаний
	|ИЗ
	|	РегистрСведений.ПредельныеСуммыУдержанийСотрудников.СрезПоследних(
	|			,
	|			(Организация, ФизическоеЛицо, Удержание, ДокументОснование) В
	|				(ВЫБРАТЬ
	|					ЗаписиУдержаний.Организация,
	|					ЗаписиУдержаний.ФизическоеЛицо,
	|					ЗаписиУдержаний.НачислениеУдержание,
	|					ЗаписиУдержаний.ИсполнительныйДокумент
	|				ИЗ
	|					ВТУдержанияДокумента КАК ЗаписиУдержаний)) КАК ПредельныеСуммыУдержанийСотрудниковСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗаписиУдержаний.Организация КАК Организация,
	|	ЗаписиУдержаний.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗаписиУдержаний.НачислениеУдержание КАК Удержание,
	|	ЗаписиУдержаний.ИсполнительныйДокумент КАК ДокументОснование,
	|	ЗаписиУдержаний.Сумма КАК Сумма
	|ИЗ
	|	ВТУдержанияДокумента КАК ЗаписиУдержаний
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПредельныеСуммыУдержаний КАК ПредельныеСуммыУдержаний
	|		ПО ЗаписиУдержаний.Организация = ПредельныеСуммыУдержаний.Организация
	|			И ЗаписиУдержаний.ФизическоеЛицо = ПредельныеСуммыУдержаний.ФизическоеЛицо
	|			И ЗаписиУдержаний.НачислениеУдержание = ПредельныеСуммыУдержаний.Удержание
	|			И ЗаписиУдержаний.ИсполнительныйДокумент = ПредельныеСуммыУдержаний.ДокументОснование
	|			И (ПредельныеСуммыУдержаний.ПрекратитьПоДостижениюПредела)";
		
	ДанныеДляПроведения.Вставить("УдержанияДоПределаПоСотрудникам", Запрос.Выполнить().Выгрузить());
	
	ДанныеДляПроведения.Вставить("ЗадолженностьПоУдержаниям");
	РасчетЗарплатыРасширенный.ЗаполнитьПогашениеЗадолженностиПоУдержаниям(ДанныеДляПроведения, Ссылка, ПериодРегистрации);
	
	ДанныеДляПроведения.Вставить("НДФЛ", ДанныеДляПроведения.ДанныеДляНДФЛИВычетов.Скопировать());
	ДанныеДляПроведения.НДФЛ = ДанныеДляПроведения.ДанныеДляНДФЛИВычетов.Скопировать();
	ДанныеДляПроведения.НДФЛ.Колонки.Добавить("СтатьяФинансирования", Новый ОписаниеТипов("СправочникСсылка.СтатьиФинансированияЗарплата"));
	ДанныеДляПроведения.НДФЛ.Колонки.Добавить("СтатьяРасходов", Новый ОписаниеТипов("СправочникСсылка.СтатьиРасходовЗарплата"));
	ДанныеДляПроведения.НДФЛ.Колонки.Добавить("НачислениеУдержание", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыОсобыхНачисленийИУдержаний"));
	Для каждого СтрокаТЗ Из ДанныеДляПроведения.НДФЛ Цикл
		СтрокаТЗ.НачислениеУдержание  = Перечисления.ВидыОсобыхНачисленийИУдержаний.НДФЛДоходыКонтрагентов;
		СтрокаТЗ.СтатьяФинансирования = СтатьиФинансированияФизическихЛиц[СтрокаТЗ.ФизическоеЛицо];
		СтрокаТЗ.СтатьяРасходов 	  = СтатьиРасходовФизическихЛиц[СтрокаТЗ.ФизическоеЛицо];
	КонецЦикла;
	
	ДанныеДляПроведения.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	
	ИсчисленныеВзносы = УчетСтраховыхВзносов.ДанныеОВзносахИзДокумента(
							Ссылка,
							"Документ.РегистрацияПрочихДоходов.НачисленияУдержанияВзносы", 
							Ложь, , ,
							"Ссылка.ПериодРегистрации");
	
	ДанныеДляПроведения.Вставить("СтраховыеВзносы", ИсчисленныеВзносы);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Процедура РассчитатьНДФЛИВзносыДокумента(СписокФизическихЛиц = Неопределено) Экспорт
	
	НачатьТранзакцию();
	
	Если Проведен Тогда
		Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Иначе
		Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Документы.РегистрацияПрочихДоходов.СоздатьВТДанныеДокумента(Запрос.МенеджерВременныхТаблиц, Ссылка, СписокФизическихЛиц);
	Документы.РегистрацияПрочихДоходов.СоздатьВТНачисленияУдержанияДокумента(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, Организация, ПериодРегистрации);
	
	ДанныеДляНДФЛ = Документы.РегистрацияПрочихДоходов.ДанныеДляПроведениеНДФЛ(Запрос.МенеджерВременныхТаблиц);
	ДанныеДляВзносов = Документы.РегистрацияПрочихДоходов.ДанныеДляПроведенияВзносы(Запрос.МенеджерВременныхТаблиц);
	
	// НДФЛ
	
	// Вычеты к доходам
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Регистратор,
	|	ДанныеДокумента.НомерСтроки,
	|	ДанныеДокумента.ФизическоеЛицо,
	|	ДанныеДокумента.КодДохода,
	|	ДанныеДокумента.Сумма,
	|	ДанныеДокумента.КодВычета,
	|	0 КАК КоличествоДетей
	|ПОМЕСТИТЬ ВТНачисления
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.КодВычета <> ЗНАЧЕНИЕ(Справочник.ВидыВычетовНДФЛ.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	Начисления.ФизическоеЛицо
	|ИЗ
	|	ВТНачисления КАК Начисления";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		УчетНДФЛ.СоздатьВТВычетыКДоходамФизическихЛиц(Ссылка, Организация, ПланируемаяДатаВыплаты, Запрос.МенеджерВременныхТаблиц);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВычетыКДоходам.ФизическоеЛицо,
		|	ВычетыКДоходам.НомерСтроки,
		|	ВычетыКДоходам.КодДохода,
		|	ВычетыКДоходам.КодВычета,
		|	ВычетыКДоходам.СуммаВычета
		|ИЗ
		|	ВТВычетыКДоходамФизическихЛиц КАК ВычетыКДоходам";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокаДоходов = НачисленияУдержанияВзносы.Найти(Выборка.НомерСтроки, "НомерСтроки");
			Если СтрокаДоходов <> Неопределено Тогда
				СтрокаДоходов.СуммаВычета = Выборка.СуммаВычета;
			КонецЕсли; 
			
			СтруктураПоиска = Новый Структура("ФизическоеЛицо,КодДохода,КодВычета");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
			
			СтрокиДоходов = ДанныеДляНДФЛ.НайтиСтроки(СтруктураПоиска);
			Для каждого СтрокаДоходов Из СтрокиДоходов Цикл
				СтрокаДоходов.СуммаВычета = Выборка.СуммаВычета;
			КонецЦикла;
			
			СтруктураПоиска = Новый Структура("ФизическоеЛицо,НомерСтроки");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
			
			СтрокиДоходовДляВзносов = ДанныеДляВзносов.НайтиСтроки(СтруктураПоиска);
			Для каждого СтрокаДоходов Из СтрокиДоходовДляВзносов Цикл
				СтрокаДоходов.Скидка = Выборка.СуммаВычета;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Регистрация доходов для НДФЛ в привилегированном режиме
	УстановитьПривилегированныйРежим(Истина);
	
	Отказ = Ложь;
	ДатаОперацииПоНалогам = УчетНДФЛРасширенный.ДатаОперацииПоДокументу(Дата, ПериодРегистрации);
	УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(
		Движения, Отказ, Организация, ДатаОперацииПоНалогам, ДанныеДляНДФЛ, Истина, Ложь);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокумента.ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента";
	
	Запрос.Выполнить();
	
	РезультатРасчетаНДФЛ = УчетНДФЛ.РезультатРасчетаНДФЛ(Запрос.МенеджерВременныхТаблиц, Неопределено,
		Организация, ПериодРегистрации, Ложь);
	
	// Взносы
	
	Если ДоходОблагаетсяВзносами(Запрос.МенеджерВременныхТаблиц) Тогда
		// Регистрация доходов для старховых взносов в привилегированном режиме
		УстановитьПривилегированныйРежим(Истина);
		
		УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляВзносов, Истина);
		
		УстановитьПривилегированныйРежим(Ложь);
		
		РезультатРасчетаСтраховыхВзносов = УчетСтраховыхВзносов.РассчитатьВзносы(Неопределено, Организация, ПериодРегистрации, Запрос.МенеджерВременныхТаблиц);
		
	Иначе
		РезультатРасчетаСтраховыхВзносов = Новый Массив;
		
	КонецЕсли;
	
	ОтменитьТранзакцию();
	
	// Очищаем расчетные данные 
	ФизическиеЛицаПоКоторымОчищалисьДанные = Новый Массив;
	ПоляВзносовСтрокой = УчетСтраховыхВзносов.РассчитываемыеВзносы();
	НулевыеСуммыВзносов = Новый Структура(ПоляВзносовСтрокой);
	Для Каждого СтрокаДанных Из ДанныеДляНДФЛ Цикл
		Если ФизическиеЛицаПоКоторымОчищалисьДанные.Найти(СтрокаДанных.ФизическоеЛицо) = Неопределено Тогда
			УчетНДФЛКлиентСерверРасширенный.УдалитьДанныеНДФЛФизическогоЛица(ЭтотОбъект, СтрокаДанных.ФизическоеЛицо);
			ФизическиеЛицаПоКоторымОчищалисьДанные.Добавить(СтрокаДанных.ФизическоеЛицо);
		КонецЕсли;
		
		СтрокаНачислений = НачисленияУдержанияВзносы.Найти(СтрокаДанных.ФизическоеЛицо, "ФизическоеЛицо");
		Если СтрокаНачислений <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтрокаНачислений, НулевыеСуммыВзносов);
		КонецЕсли;
	КонецЦикла;
	
	// Перенос в документ результатов расчета НДФЛ
	МаксимальныйИдентификатор = УчетНДФЛФормы.МаксимальныйИдентификаторСтрокиНДФЛ(НДФЛ);
	Для каждого СтрокаРезультатаРасчетаНДФЛ Из РезультатРасчетаНДФЛ.НДФЛ Цикл
		
		Если ФизическиеЛицаПоКоторымОчищалисьДанные.Найти(СтрокаРезультатаРасчетаНДФЛ.ФизическоеЛицо) = Неопределено Тогда
			УчетНДФЛКлиентСерверРасширенный.УдалитьДанныеНДФЛФизическоголица(ЭтотОбъект, СтрокаРезультатаРасчетаНДФЛ.ФизическоеЛицо);
			ФизическиеЛицаПоКоторымОчищалисьДанные.Добавить(СтрокаРезультатаРасчетаНДФЛ.ФизическоеЛицо);
		КонецЕсли;
		
		МаксимальныйИдентификатор = МаксимальныйИдентификатор + 1;
		
		НоваяСтрокаНДФЛ = НДФЛ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаНДФЛ, СтрокаРезультатаРасчетаНДФЛ);
		НоваяСтрокаНДФЛ.ИдентификаторСтрокиНДФЛ = МаксимальныйИдентификатор;
		
		СтрокиВычетов = РезультатРасчетаНДФЛ.ПримененныеВычетыНаДетейИИмущественные.НайтиСтроки(
			Новый Структура("ИдентификаторСтрокиНДФЛ", СтрокаРезультатаРасчетаНДФЛ.ИдентификаторСтрокиНДФЛ));
			
		Для каждого СтрокаВычетов Из СтрокиВычетов Цикл
			НоваяСтрокаВычетов = ПримененныеВычетыНаДетейИИмущественные.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаВычетов, СтрокаВычетов);
			НоваяСтрокаВычетов.ИдентификаторСтрокиНДФЛ = НоваяСтрокаНДФЛ.ИдентификаторСтрокиНДФЛ;
		КонецЦикла;
		
	КонецЦикла;
	
	// Перенос в документ результатов расчета взносов
	Для каждого СтрокаРезультатаРасчета Из РезультатРасчетаСтраховыхВзносов Цикл
		
		СтрокиНачислений = НачисленияУдержанияВзносы.НайтиСтроки(Новый Структура("ФизическоеЛицо", СтрокаРезультатаРасчета.ФизическоеЛицо));
		Если СтрокиНачислений.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(СтрокиНачислений[0], СтрокаРезультатаРасчета);
		КонецЕсли;
		
	КонецЦикла;
	
	// Удержания
	РассчитатьУдержания(СписокФизическихЛиц);
	
КонецПроцедуры

Функция ДоходОблагаетсяВзносами(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НеоблагаемыеВидыДоходов", УчетСтраховыхВзносовРасширенный.ВидыДоходовНеоблагаемыеСтраховымиВзносами());
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьОблагаемыеДоходы
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.ВидДохода В(&НеоблагаемыеВидыДоходов)";
	
	Возврат Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура РассчитатьУдержания(СписокФизическихЛиц, НДФЛРасчитан = Истина) Экспорт
	
	// Проверим необходимость расчета удержаний
	ФизическиеЛица = Удержания.ВыгрузитьКолонку("ФизическоеЛицо");
	Если ФизическиеЛица.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли СписокФизическихЛиц <> Неопределено Тогда
		РасчетНеобходим = Ложь;
		Для Каждого ФизическоеЛицо Из СписокФизическихЛиц Цикл
			Если ФизическиеЛица.Найти(ФизическоеЛицо) <> Неопределено Тогда
				РасчетНеобходим = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не РасчетНеобходим Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 0
	|	РегистрацияПрочихДоходов.Ссылка,
	|	РегистрацияПрочихДоходов.Организация,
	|	РегистрацияПрочихДоходов.ВидПрочегоДохода,
	|	РегистрацияПрочихДоходов.КодВычетаНДФЛ,
	|	РегистрацияПрочихДоходов.ПланируемаяДатаВыплаты,
	|	РегистрацияПрочихДоходов.ПериодРегистрации,
	|	РегистрацияПрочихДоходов.Подразделение,
	|	РегистрацияПрочихДоходов.ОтношениеКЕНВД,
	|	РегистрацияПрочихДоходов.СтатьяФинансирования,
	|	РегистрацияПрочихДоходов.СтатьяРасходов,
	|	РегистрацияПрочихДоходов.СпособОтраженияЗарплатыВБухучете
	|ИЗ
	|	Документ.РегистрацияПрочихДоходов КАК РегистрацияПрочихДоходов
	|ГДЕ
	|	ЛОЖЬ";
	ТаблицаШапки = Запрос.Выполнить().Выгрузить();
	
	ЗаполнитьЗначенияСвойств(ТаблицаШапки.Добавить(), ЭтотОбъект);
	Запрос.УстановитьПараметр("РегистрацияПрочихДоходов", ТаблицаШапки);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияПрочихДоходов.Ссылка,
	|	РегистрацияПрочихДоходов.Организация,
	|	РегистрацияПрочихДоходов.ВидПрочегоДохода,
	|	РегистрацияПрочихДоходов.КодВычетаНДФЛ,
	|	РегистрацияПрочихДоходов.ПланируемаяДатаВыплаты,
	|	РегистрацияПрочихДоходов.ПериодРегистрации,
	|	РегистрацияПрочихДоходов.Подразделение,
	|	РегистрацияПрочихДоходов.ОтношениеКЕНВД,
	|	РегистрацияПрочихДоходов.СтатьяФинансирования,
	|	РегистрацияПрочихДоходов.СтатьяРасходов,
	|	РегистрацияПрочихДоходов.СпособОтраженияЗарплатыВБухучете
	|ПОМЕСТИТЬ ВТШапкаДокумента
	|ИЗ
	|	&РегистрацияПрочихДоходов КАК РегистрацияПрочихДоходов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДФЛ.ФизическоеЛицо,
	|	НДФЛ.Налог
	|ПОМЕСТИТЬ ВТНДФЛ
	|ИЗ
	|	&НДФЛ КАК НДФЛ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНДФЛ.ФизическоеЛицо,
	|	СУММА(ВТНДФЛ.Налог) КАК Налог
	|ПОМЕСТИТЬ ВТНДФЛИтоги
	|ИЗ
	|	ВТНДФЛ КАК ВТНДФЛ
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТНДФЛ.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Начисления.Начислено КАК СуммаДохода,
	|	Начисления.Начислено КАК Сумма,
	|	Начисления.НДФЛ КАК НДФЛ,
	|	Начисления.СуммаВычета КАК СуммаВычета,
	|	Начисления.НомерСтроки,
	|	Начисления.Удержано
	|ПОМЕСТИТЬ ВТДанныеНачисленийУдержаний
	|ИЗ
	|	&НачисленияУдержанияВзносы КАК Начисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ШапкаДокумента.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ШапкаДокумента.ВидПрочегоДохода КАК Справочник.ВидыПрочихДоходовФизическихЛиц).КодДоходаНДФЛ КАК КодДохода,
	|	ВидыДоходовНДФЛ.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	ШапкаДокумента.КодВычетаНДФЛ КАК КодВычета,
	|	Начисления.СуммаДохода КАК СуммаДохода,
	|	ШапкаДокумента.ПланируемаяДатаВыплаты КАК ПланируемаяДатаВыплаты,
	|	НАЧАЛОПЕРИОДА(ШапкаДокумента.ПланируемаяДатаВыплаты, МЕСЯЦ) КАК МесяцНалоговогоПериода,
	|	НАЧАЛОПЕРИОДА(ШапкаДокумента.ПериодРегистрации, МЕСЯЦ) КАК ПериодРегистрации,
	|	ШапкаДокумента.Подразделение КАК Подразделение,
	|	ВЫРАЗИТЬ(ШапкаДокумента.ВидПрочегоДохода КАК Справочник.ВидыПрочихДоходовФизическихЛиц).КодДоходаСтраховыеВзносы КАК ВидДохода,
	|	ШапкаДокумента.ОтношениеКЕНВД,
	|	Начисления.Сумма КАК Сумма,
	|	ЕСТЬNULL(Налоги.Налог, Начисления.НДФЛ) КАК НДФЛ,
	|	Начисления.СуммаВычета КАК СуммаВычета,
	|	ШапкаДокумента.ВидПрочегоДохода КАК Начисление,
	|	ШапкаДокумента.Ссылка КАК Ссылка,
	|	ШапкаДокумента.СтатьяФинансирования,
	|	ШапкаДокумента.СтатьяРасходов,
	|	ШапкаДокумента.СпособОтраженияЗарплатыВБухучете,
	|	Начисления.НомерСтроки,
	|	Начисления.Удержано
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	ВТДанныеНачисленийУдержаний КАК Начисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТШапкаДокумента КАК ШапкаДокумента
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыДоходовНДФЛ КАК ВидыДоходовНДФЛ
	|			ПО (ВЫРАЗИТЬ(ШапкаДокумента.ВидПрочегоДохода КАК Справочник.ВидыПрочихДоходовФизическихЛиц).КодДоходаНДФЛ = ВидыДоходовНДФЛ.Ссылка)
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНДФЛИтоги КАК Налоги
	|		ПО Начисления.ФизическоеЛицо = Налоги.ФизическоеЛицо
	|			И (&НДФЛРасчитан = ИСТИНА)";
	
	Если СписокФизическихЛиц = Неопределено Тогда
		Запрос.УстановитьПараметр("НачисленияУдержанияВзносы", НачисленияУдержанияВзносы.Выгрузить());
		Запрос.УстановитьПараметр("НДФЛ", НДФЛ.Выгрузить());
	Иначе
		НачисленияУдержанияВзносыДляЗапроса = НачисленияУдержанияВзносы.Выгрузить(Новый Массив);
		НДФЛДляЗапроса = НДФЛ.Выгрузить(Новый Массив);
		ПараметрыОтбора = Новый Структура("ФизическоеЛицо");
		Для Каждого ФизическоеЛицо Из СписокФизическихЛиц Цикл
			ПараметрыОтбора.ФизическоеЛицо = ФизическоеЛицо;
			Строки = НачисленияУдержанияВзносы.НайтиСтроки(ПараметрыОтбора);
			Для Каждого Строка Из Строки Цикл
				ЗаполнитьЗначенияСвойств(НачисленияУдержанияВзносыДляЗапроса.Добавить(), Строка);
			КонецЦикла;
			
			Строки = НДФЛ.НайтиСтроки(ПараметрыОтбора);
			Для Каждого Строка Из Строки Цикл
				ЗаполнитьЗначенияСвойств(НДФЛДляЗапроса.Добавить(), Строка);
			КонецЦикла;
		КонецЦикла;
		Запрос.УстановитьПараметр("НачисленияУдержанияВзносы", НачисленияУдержанияВзносыДляЗапроса);
		Запрос.УстановитьПараметр("НДФЛ", НДФЛДляЗапроса);
	КонецЕсли;
	Запрос.УстановитьПараметр("НДФЛРасчитан", НДФЛРасчитан);
	Запрос.Выполнить();
	
	Документы.РегистрацияПрочихДоходов.СоздатьВТНачисленияУдержанияДокумента(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, Организация, ПериодРегистрации);
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеДокумента.ФизическоеЛицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленияДокумента.ФизическоеЛицо,
	|	НачисленияДокумента.СтатьяФинансирования,
	|	НачисленияДокумента.СтатьяРасходов
	|ПОМЕСТИТЬ ВТБухучетФизическихЛиц
	|ИЗ
	|	ВТНачисленияДокумента КАК НачисленияДокумента";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.ФизическоеЛицо,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.Сумма,
	|	ДанныеДокумента.Начисление КАК Начисление,
	|	ДанныеДокумента.ДокументОснование,
	|	ДанныеДокумента.ОблагаетсяЕНВД,
	|	ДанныеДокумента.СтатьяФинансирования,
	|	ДанныеДокумента.СтатьяРасходов,
	|	ДанныеДокумента.СпособОтраженияЗарплатыВБухучете
	|ИЗ
	|	ВТНачисленияДокумента КАК ДанныеДокумента";
	
	ДанныеДляПроведения.Вставить("Начисления", Запрос.Выполнить().Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.ФизическоеЛицо,
	|	ДанныеДокумента.Подразделение,
	|	ДанныеДокумента.НДФЛ КАК Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛДоходыКонтрагентов) КАК НачислениеУдержание,
	|	БухучетФизическихЛиц.СтатьяФинансирования,
	|	БухучетФизическихЛиц.СтатьяРасходов
	|ИЗ
	|	ВТДанныеДокумента КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБухучетФизическихЛиц КАК БухучетФизическихЛиц
	|		ПО ДанныеДокумента.ФизическоеЛицо = БухучетФизическихЛиц.ФизическоеЛицо";
	
	ДанныеДляПроведения.Вставить("НДФЛ", Запрос.Выполнить().Выгрузить());
	
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияУдержанияПоКонтрагентамАкционерам(Движения, Ложь, Организация, НачалоМесяца(ПериодРегистрации), ДанныеДляПроведения.Начисления, , ДанныеДляПроведения.НДФЛ);
	
	МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(ПериодРегистрации, Организация);
	
	МенеджерВременныхТаблицУдержания = Новый МенеджерВременныхТаблиц;
	ЗарплатаКадры.СоздатьВТПоНаборуЗаписей(МенеджерВременныхТаблицУдержания, Движения.НачисленияУдержанияПоКонтрагентамАкционерам);
	Движения.НачисленияУдержанияПоКонтрагентамАкционерам.Очистить();
	
	ДанныеДляНДФЛ = Документы.РегистрацияПрочихДоходов.ДанныеДляПроведениеНДФЛ(Запрос.МенеджерВременныхТаблиц);
	ДатаОперацииПоНалогам = УчетНДФЛРасширенный.ДатаОперацииПоДокументу(Дата, ПериодРегистрации);
	УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Ложь, Организация, ДатаОперацииПоНалогам, ДанныеДляНДФЛ, Ложь, Ложь);
	ЗарплатаКадры.СоздатьВТПоНаборуЗаписей(МенеджерВременныхТаблицУдержания, Движения.СведенияОДоходахНДФЛ);
	Движения.СведенияОДоходахНДФЛ.Очистить();
	
	МенеджерРасчета.УстановитьМенеджерВременныхТаблиц(МенеджерВременныхТаблицУдержания);
	
	МенеджерРасчета.НастройкиРасчета.РассчитыватьУдержания = Истина;
	МенеджерРасчета.НастройкиУдержаний.РассчитыватьТолькоПоТекущемуДокументу = Истина;
	
	УдержанияДляРасчета = Новый Массив;	
	ФизическиеЛицаДокумента = Новый Массив;
	Если СписокФизическихЛиц = Неопределено Тогда
		УдержанияДляРасчета = Удержания.Выгрузить();
		УдержанияДляРасчета.ЗаполнитьЗначения(0, "Результат");
		
		ФизическиеЛицаДокумента = НачисленияУдержанияВзносы.ВыгрузитьКолонку("ФизическоеЛицо");
		Удержания.Очистить();
	Иначе
		Для Каждого ФизическоеЛицо Из СписокФизическихЛиц Цикл
			СтрокиУдержаний = Удержания.НайтиСтроки(Новый Структура("ФизическоеЛицо", ФизическоеЛицо));
			Для Каждого СтрокаУдержания Из СтрокиУдержаний Цикл
				СтрокаУдержания.Результат = 0;
				УдержанияДляРасчета.Добавить(СтрокаУдержания);
			КонецЦикла;
			ФизическиеЛицаДокумента = СписокФизическихЛиц;
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(УдержанияДляРасчета , МенеджерРасчета.Зарплата.Удержания);
	
	МенеджерРасчета.РассчитатьЗарплату();
	
	// Перенос в документ результатов расчета удержаний
	ИденитфикаторыУдержаний = Удержания.Выгрузить( , "ИдентификаторСтрокиВидаРасчета");
	ИденитфикаторыУдержаний.Сортировать("ИдентификаторСтрокиВидаРасчета Убыв");
	МаксимальныйИдентификатор = ?(ИденитфикаторыУдержаний.Количество() И ИденитфикаторыУдержаний[0].ИдентификаторСтрокиВидаРасчета <> 0, ИденитфикаторыУдержаний[0].ИдентификаторСтрокиВидаРасчета, 3*1000000);
	
	Отбор = Новый Структура("ФизическоеЛицо");
	Для Каждого ФизическоеЛицо Из ФизическиеЛицаДокумента Цикл
		Отбор.ФизическоеЛицо = ФизическоеЛицо;
		
		РасчитанныеСтрокиУдержаний = МенеджерРасчета.Зарплата.Удержания.НайтиСтроки(Отбор);
		Если РасчитанныеСтрокиУдержаний.Количество() = 0 Тогда
			СтрокаНачисленияУдержанияВзносы = НачисленияУдержанияВзносы.Найти(ФизическоеЛицо, "ФизическоеЛицо");
			СтрокаНачисленияУдержанияВзносы.Удержано = 0;
			
			СтрокиУдержаний = Удержания.НайтиСтроки(Отбор);
			Для Каждого СтрокаУдержания Из СтрокиУдержаний Цикл
				СтрокаУдержания.Результат = 0;
			КонецЦикла;
			
			Продолжить;
		КонецЕсли;
		
		СтрокиУдержаний = Удержания.НайтиСтроки(Отбор);
		Для Каждого СтрокаУдержания Из СтрокиУдержаний Цикл
			СтрокиПоказателей = Показатели.НайтиСтроки(Новый Структура("ИдентификаторСтрокиВидаРасчета", СтрокаУдержания.ИдентификаторСтрокиВидаРасчета));
			Для Каждого СтрокаПоказателей Из СтрокиПоказателей Цикл
				Показатели.Удалить(СтрокаПоказателей);
			КонецЦикла;
			Удержания.Удалить(СтрокаУдержания);
		КонецЦикла;
		
		Удержано = 0;
		Для Каждого СтрокаУдержания Из РасчитанныеСтрокиУдержаний Цикл
			МаксимальныйИдентификатор = МаксимальныйИдентификатор + 1;
			
			НовоеУдержание = Удержания.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеУдержание, СтрокаУдержания);
			НовоеУдержание.ИдентификаторСтрокиВидаРасчета = МаксимальныйИдентификатор;
			
			Для Каждого ЗначениеПоказателя Из СтрокаУдержания.Показатели Цикл
				СтрокаПоказателей = Показатели.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПоказателей, ЗначениеПоказателя);
				СтрокаПоказателей.ИдентификаторСтрокиВидаРасчета = МаксимальныйИдентификатор;
			КонецЦикла;
			
			Удержано = Удержано + СтрокаУдержания.Результат;
		КонецЦикла;
		
		СтрокаНачисленияУдержанияВзносы = НачисленияУдержанияВзносы.Найти(ФизическоеЛицо, "ФизическоеЛицо");
		СтрокаНачисленияУдержанияВзносы.Удержано = Удержано;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли