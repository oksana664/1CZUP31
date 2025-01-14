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

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ТолькоПроведенные") И Параметры.ТолькоПроведенные Тогда
		Параметры.Отбор.Вставить("Проведен", Истина);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ВедомостьПрочихДоходовПеречислением;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

	
#Область СлужебныеПроцедурыИФункции

Функция РеквизитыОтветственныхЛиц() Экспорт
	
	РеквизитыОтветственныхЛиц = ВзаиморасчетыССотрудниками.ВедомостьРеквизитыОтветственныхЛиц();
	
	Возврат РеквизитыОтветственныхЛиц
	
КонецФункции	

Функция БанковскиеСчетаФизическихЛиц(ФизическиеЛица, Банк) Экспорт
	
	БанковскиеСчета = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛица);
	Запрос.УстановитьПараметр("Банк", Банк);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БанковскиеСчетаКонтрагентов.Ссылка КАК Ссылка,
	|	БанковскиеСчетаКонтрагентов.Владелец КАК Владелец
	|ИЗ
	|	Справочник.БанковскиеСчетаКонтрагентов КАК БанковскиеСчетаКонтрагентов
	|ГДЕ
	|	БанковскиеСчетаКонтрагентов.Владелец В(&ФизическиеЛица)
	|	И БанковскиеСчетаКонтрагентов.Банк = &Банк";
	
	Если НЕ ЗначениеЗаполнено(Банк) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И БанковскиеСчетаКонтрагентов.Банк = &Банк","");	
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		БанковскиеСчета.Вставить(Выборка.Владелец, Выборка.Ссылка);	
	КонецЦикла;	
	
	Возврат БанковскиеСчета
	
КонецФункции


#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Список перечислений
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "ЗарплатаКадрыКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "СписокПеречислений";
	КомандаПечати.Представление = НСтр("ru = 'Список перечислений'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		УчетНДФЛРасширенный.ДобавитьКомандуПечатиРеестраПеречисленногоНалога(КомандыПечати)
	КонецЕсли;	
	
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СписокПеречислений") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СписокПеречислений", НСтр("ru = 'Список получателей'"), ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.НужноПечататьРеестрПеречисленногоНалога(КоллекцияПечатныхФорм) Тогда
		УчетНДФЛРасширенный.ВывестиРеестрПеречисленногоНалогаПоПлатежномуДокументу(КоллекцияПечатныхФорм, МассивОбъектов, ОбъектыПечати);	
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьСписокПеречислений(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВедомостьПрочихДоходовПеречислением_СписокПеречислений";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_СписокПеречисленийНаБанковскиеСчета"); 
	
	// получаем данные для печати
	ВыборкаШапок = ВыборкаДляПечатиШапки(МассивОбъектов);
	ВыборкаСтрок = ВыборкаДляПечатиТаблицы(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Подсчитываем количество страниц документа - для корректного разбиения на страницы.
		ВсегоСтрокДокумента = ВыборкаСтрок.Количество();

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
 		ОбластьМакетаШапкаДокумента.Параметры.Дата = Формат(ВыборкаШапок.Дата, "ДЛФ=D");
 		ОбластьМакетаШапкаДокумента.Параметры.Организация = СокрЛП(ВыборкаШапок.Организация);
		
		ТабличныйДокумент.Вывести(ОбластьМакетаШапкаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		
		ВыведеноСтраниц = 1; ВыведеноСтрок = 0; ИтогоНаСтранице = 0; Итого = 0;
		// Выводим данные по строкам документа.
		НомерСтроки = 0;
		ВыборкаСтрок.Сбросить();
		Пока ВыборкаСтрок.НайтиСледующий(ВыборкаШапок.Ссылка, "Ведомость") Цикл
			
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьМакетаСтрока.Параметры.Заполнить(ВыборкаСтрок);
			ОбластьМакетаСтрока.Параметры.НомерСтроки = НомерСтроки;
			ОбластьМакетаСтрока.Параметры.Физлицо = ВыборкаСтрок.Фамилия +" "+ ВыборкаСтрок.Имя +" "+ ВыборкаСтрок.Отчество;
			
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
			ИтогоНаСтранице = ИтогоНаСтранице + ВыборкаСтрок.Сумма;
			Итого = Итого + ВыборкаСтрок.Сумма;
			
		КонецЦикла;
		
		Если ВыведеноСтрок > 0 Тогда 
			ОбластьМакетаИтогПоСтранице.Параметры.ИтогоНаСтранице = ИтогоНаСтранице;
		КонецЕсли;
		
		ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаШапок);
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
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);
		
	КонецЦикла; // по документам
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует запрос по документу.
//
// Параметры: 
//  Ведомости - массив ДокументСсылка.ВедомостьНаВыплатуЗарплатыВБанк.
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечатиШапки(Ведомости) Экспорт
	Возврат ВзаиморасчетыПоПрочимДоходам.ВедомостьПрочихДоходовПеречислениемВыборкаДляПечатиШапки(Метаданные.Документы.ВедомостьПрочихДоходовПеречислением.ПолноеИмя(), Ведомости)
КонецФункции


// Формирует запрос по табличной части документа.
//
// Параметры: 
//  ДокументСсылка	- ссылка на документ.
//  ДатаДокумента	- дата документ.
//
// Возвращаемое значение:
//  Результат запроса
//
Функция ВыборкаДляПечатиТаблицы(Ведомости) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ведомости", Ведомости);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВедомостьВыплаты.Ссылка КАК Ссылка,
	|	ВедомостьВыплаты.Ссылка.Дата КАК Период,
	|	МИНИМУМ(ВедомостьСостав.НомерСтроки) КАК НомерСтроки,
	|	ВедомостьСостав.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьСостав.БанковскийСчет.НомерСчета КАК НомерСчета,
	|	СУММА(ВедомостьВыплаты.КВыплате) КАК Сумма
	|ПОМЕСТИТЬ ВТСписокФизическихЛиц
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовПеречислением.Выплаты КАК ВедомостьВыплаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьПрочихДоходовПеречислением.Состав КАК ВедомостьСостав
	|		ПО ВедомостьВыплаты.Ссылка = ВедомостьСостав.Ссылка
	|			И ВедомостьВыплаты.ИдентификаторСтроки = ВедомостьСостав.ИдентификаторСтроки
	|ГДЕ
	|	ВедомостьВыплаты.Ссылка В(&Ведомости)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьВыплаты.Ссылка,
	|	ВедомостьВыплаты.Ссылка.Дата,
	|	ВедомостьСостав.ФизическоеЛицо,
	|	ВедомостьСостав.БанковскийСчет.НомерСчета
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВедомостьВыплаты.КВыплате) > 0";
	
	Запрос.Выполнить();
	
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, "ВТСписокФизическихЛиц");
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, "Фамилия,Имя,Отчество");

	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокФизическихЛиц.Ссылка КАК Ведомость,
	|	СписокФизическихЛиц.НомерСчета КАК НомерСчета,
	|	КадровыеДанныеФизическихЛиц.Фамилия,
	|	КадровыеДанныеФизическихЛиц.Имя,
	|	КадровыеДанныеФизическихЛиц.Отчество,
	|	СписокФизическихЛиц.Сумма КАК Сумма
	|ИЗ
	|	ВТСписокФизическихЛиц КАК СписокФизическихЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
	|		ПО СписокФизическихЛиц.ФизическоеЛицо = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
	|			И СписокФизическихЛиц.Период = КадровыеДанныеФизическихЛиц.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокФизическихЛиц.НомерСтроки";

	Возврат Запрос.Выполнить().Выбрать();

КонецФункции


#КонецОбласти

#Область ОграничениеДокумента

Функция ПредставлениеПометкиОграничения() Экспорт
	
	Возврат НСтр("ru = 'Передан для выплаты'");
	
КонецФункции

Функция ОперацияОграниченияДокумента() Экспорт
	
	Возврат ОграничениеИспользованияДокументов.ОперацияОтсутствует();
	
КонецФункции

#КонецОбласти

Функция ТекстЗапросаДанныеДляОплаты(ИмяПараметраВедомости = "Ведомости", ИмяПараметраФизическиеЛица = "ФизическиеЛица") Экспорт
	Возврат 
		ВзаиморасчетыПоПрочимДоходам.ВедомостьТекстЗапросаДанныеДляОплаты(
			Метаданные.Документы.ВедомостьПрочихДоходовПеречислением.ПолноеИмя(), 
			ИмяПараметраВедомости, ИмяПараметраФизическиеЛица);
КонецФункции

#КонецОбласти

#КонецЕсли