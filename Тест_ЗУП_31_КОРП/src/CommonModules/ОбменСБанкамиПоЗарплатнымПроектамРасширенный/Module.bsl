////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ЗарегистрироватьИзмененияЛицевыхСчетов(ЛицевыеСчетаФизическихЛиц, Организация, ДатаНачала) Экспорт
	
	Если ЛицевыеСчетаФизическихЛиц.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудники = КадровыйУчетРасширенный.СотрудникиФизическихЛиц(ЛицевыеСчетаФизическихЛиц.ВыгрузитьКолонку("ФизическоеЛицо"), Организация);
	
	ЗапрашиваемыеКадровыеДанные = "ФизическоеЛицо, ТекущаяОрганизация, ТекущееПодразделение";
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудники, ЗапрашиваемыеКадровыеДанные, ДатаНачала);
	
	Для каждого ДанныеЛицевогоСчета Из ЛицевыеСчетаФизическихЛиц Цикл
		
		Отбор = Новый Структура();
		Отбор.Вставить("ФизическоеЛицо", ДанныеЛицевогоСчета.ФизическоеЛицо);
		СтрокиФизическогоЛица = КадровыеДанные.НайтиСтроки(Отбор);
		Для каждого СтрокаФизическогоЛица Из СтрокиФизическогоЛица Цикл
			МестоВыплатыЗарплатыПодразделенияОрганизации = ВзаиморасчетыССотрудникамиРасширенный.МестоВыплатыЗарплатыПодразделенияОрганизации(
				СтрокаФизическогоЛица.ТекущееПодразделение);
			МестоВыплатыЗарплатыСотрудника = ВзаиморасчетыССотрудникамиРасширенный.МестоВыплатыЗарплатыСотрудника(
				СтрокаФизическогоЛица.Сотрудник, СтрокаФизическогоЛица.ФизическоеЛицо);
				Если МестоВыплатыЗарплатыПодразделенияОрганизации <> Неопределено 
					И МестоВыплатыЗарплатыПодразделенияОрганизации.Вид = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект
					И МестоВыплатыЗарплатыСотрудника.Вид = Перечисления.ВидыМестВыплатыЗарплаты.ПустаяСсылка() Тогда
					
				ИначеЕсли МестоВыплатыЗарплатыПодразделенияОрганизации <> Неопределено 
					И МестоВыплатыЗарплатыСотрудника.Вид <> Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект
					И МестоВыплатыЗарплатыПодразделенияОрганизации.Вид = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект Тогда
					
					МестоВыплатыЗарплатыСотрудника.Вид = Неопределено;
					ВзаиморасчетыССотрудникамиРасширенный.ЗаписатьМестоВыплатыЗарплаты(МестоВыплатыЗарплатыСотрудника);
					
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Сотруднику %1 установлено место выплаты по зарплатному проекту, как всему подразделению.'"),
						СтрокаФизическогоЛица.Сотрудник);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, СтрокаФизическогоЛица.Сотрудник);
					
				ИначеЕсли МестоВыплатыЗарплатыСотрудника.Вид <> Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект Тогда
					
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'По сотруднику %1 получено подтверждение открытия лицевого счета, но не установлено место выплаты по зарплатному проекту.'"),
						СтрокаФизическогоЛица.Сотрудник);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, СтрокаФизическогоЛица.Сотрудник);
					
				КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДеньВыплатыЗарплатыВОрганизации(Организация) Экспорт
	
	СтруктураСведений = Новый Структура;
	СтруктураСведений.Вставить("ДатаВыплатыЗарплатыНеПозжеЧем");
	СтруктураСведений.Вставить("ВыплачиватьЗарплатуВПоследнийДеньМесяца");
	
	СведенияОНастройкахОрганизации = РегистрыСведений.НастройкиЗарплатаКадрыРасширенная.СведенияОНастройкахОрганизации(Организация, СтруктураСведений);
	Если СведенияОНастройкахОрганизации.ВыплачиватьЗарплатуВПоследнийДеньМесяца Тогда
		Возврат 31;
	Иначе
		Возврат СведенияОНастройкахОрганизации.ДатаВыплатыЗарплатыНеПозжеЧем;
	КонецЕсли;
	
КонецФункции

Процедура ДополнитьКадровыеДанные(КадровыеДанные, ТекстЗапроса) Экспорт
	
	КадровыеДанные = КадровыеДанные + ", ТелефонМобильный, ТелефонМобильныйПредставление";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
	|ИЗ", ",
	|	КадровыеДанныеСотрудников.ТелефонМобильный КАК НомерМобильногоТелефона,
	|	КадровыеДанныеСотрудников.ТелефонМобильныйПредставление КАК НомерМобильногоТелефонаПредставление
	|ИЗ");
	
КонецПроцедуры

Процедура ДополнитьОписаниеФиксацииРеквизитовЗаявкиНаОткрытиеЛицевыхСчетов(ОписаниеФиксацииРеквизитов) Экспорт
	ОписаниеФиксацииРеквизитов.Вставить("СотрудникиНомерМобильногоТелефона",
		Документы.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ФиксацияОписаниеФиксацииРеквизита("НомерМобильногоТелефона", "ФизическоеЛицо"));
	ОписаниеФиксацииРеквизитов.Вставить("СотрудникиНомерМобильногоТелефонаПредставление",
		Документы.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ФиксацияОписаниеФиксацииРеквизита("НомерМобильногоТелефонаПредставление", "ФизическоеЛицо"));
КонецПроцедуры

Процедура ДополнитьПараметрыПолученияСотрудников(ПараметрыПолученияСотрудников) Экспорт
	ПараметрыПолученияСотрудников.РаботникиПоДоговорамГПХ = Истина;
КонецПроцедуры

Процедура ВыгрузитьФайлыДляОбменаСБанком(СтруктураПараметров, АдресХранилища) Экспорт
	
	СтруктураПараметров.Вставить("МассивОписанийФайлов", Новый Массив);
	
	Если Не ОграничениеИспользованияДокументов.ЕстьОграниченныеДокументы(СтруктураПараметров.МассивДокументов) Тогда
		
		МетаданныеПлатежногоДокумента = ОбменСБанкамиПоЗарплатнымПроектам.МетаданныеПлатежногоДокументаПеречисленияЗарплаты();
		
		ДокументыПоТипам = ОбщегоНазначенияБЗК.ОбъектыПоТипам(СтруктураПараметров.МассивДокументов);
		Для Каждого ДокументыПоТипу Из ДокументыПоТипам Цикл
			
			МетаданныеДокумента = Метаданные.НайтиПоТипу(ДокументыПоТипу.Ключ);
			Если (МетаданныеПлатежногоДокумента = Неопределено
				Или МетаданныеДокумента.ПолноеИмя() <> МетаданныеПлатежногоДокумента.ПолноеИмя()) Тогда			
				СтруктураПараметров.Вставить("МассивДокументов", ДокументыПоТипу.Значение);
				МенеджерДокумента = ОбщегоНазначенияБЗК.МенеджерОбъектаПоТипу(ДокументыПоТипу.Ключ);
				МенеджерДокумента.ВыгрузитьФайлыДляОбменаСБанком(СтруктураПараметров)
			Иначе
				Для Каждого ПлатежныйДокумент Из ДокументыПоТипу.Значение Цикл
					СтруктураПараметров.Вставить("МассивДокументов", ОбменСБанкамиПоЗарплатнымПроектам.ВедомостиПлатежногоДокументаПеречисленияЗарплаты(ПлатежныйДокумент));
					СтруктураПараметров.Вставить("ПлатежныйДокумент", ПлатежныйДокумент);
					ОбменСБанкамиПоЗарплатнымПроектам.ВыгрузитьФайлыДляОбменаСБанкомПоВедомости(СтруктураПараметров);
				КонецЦикла	
			КонецЕсли;
			
			Если ПолучитьФункциональнуюОпцию("АвтоматическиОграничиватьИспользованиеДокументов")
				И СтруктураПараметров.Свойство("ДанныеДокументов") И СтруктураПараметров.ДанныеДокументов.Количество() > 0 Тогда
				ОграничениеИспользованияДокументов.ОграничитьДокументыПослеВыгрузки(ДокументыПоТипу.Значение);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(СтруктураПараметров.МассивОписанийФайлов, АдресХранилища);
	
КонецПроцедуры


Процедура ВедомостьПрочихДоходовВБанкПередЗаписью(ВедомостьОбъект) Экспорт
	
	Если Не ЗначениеЗаполнено(ВедомостьОбъект.ЗарплатныйПроект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВедомостьОбъект.НомерРеестра) Тогда
		СтруктураВедомостьОбъект = Новый Структура;
		СтруктураВедомостьОбъект.Вставить("Дата", ВедомостьОбъект.Дата);
		СтруктураВедомостьОбъект.Вставить("Номер", ВедомостьОбъект.Номер);
		СтруктураВедомостьОбъект.Вставить("Организация", ВедомостьОбъект.Организация);
		СтруктураВедомостьОбъект.Вставить("НомерРеестра", ВедомостьОбъект.НомерРеестра);
		
		СоответствиеДокументов = Новый Соответствие;
		СоответствиеДокументов.Вставить(ВедомостьОбъект, СтруктураВедомостьОбъект);
		ГодыВыгрузки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Год(ВедомостьОбъект.Дата));
		НомераРеестров = ОбменСБанкамиПоЗарплатнымПроектам.НомераРеестровДокументов(СоответствиеДокументов, ГодыВыгрузки, Неопределено);
		ДанныеРеестра = НомераРеестров.Получить(ВедомостьОбъект);
		Если ДанныеРеестра <> Неопределено Тогда
			ВедомостьОбъект.НомерРеестра = ДанныеРеестра.НомерРеестра;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ведомость", ВедомостьОбъект.Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Ведомость.Организация КАК Организация,
	|	Ведомость.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ВедомостьСписокВыплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(ВедомостьСписокВыплаты.КВыплате) КАК КВыплате,
	|	ВедомостьСписокВыплаты.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	Ведомость.Проведен КАК Проведен
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк.Выплаты КАК ВедомостьСписокВыплаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьПрочихДоходовВБанк КАК Ведомость
	|		ПО ВедомостьСписокВыплаты.Ссылка = Ведомость.Ссылка
	|ГДЕ
	|	ВедомостьСписокВыплаты.Ссылка = &Ведомость
	|
	|СГРУППИРОВАТЬ ПО
	|	Ведомость.Организация,
	|	Ведомость.ЗарплатныйПроект,
	|	ВедомостьСписокВыплаты.ФизическоеЛицо,
	|	ВедомостьСписокВыплаты.НомерЛицевогоСчета,
	|	Ведомость.Проведен";
	
	ВедомостьОбъект.ДополнительныеСвойства.Вставить("ДанныеВедомостиПередЗаписью", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ВедомостьПрочихДоходовВБанкПриЗаписи(ВедомостьОбъект, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(ВедомостьОбъект.ЗарплатныйПроект)
		Или Не ВедомостьОбъект.ДополнительныеСвойства.Свойство("ДанныеВедомостиПередЗаписью") Тогда
		ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьСостояниеЗачисленияЗарплатыПоДокументу(ВедомостьОбъект.Ссылка, Отказ);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ведомость", ВедомостьОбъект.Ссылка);
	Запрос.УстановитьПараметр("ДанныеВедомостиПередЗаписью", ВедомостьОбъект.ДополнительныеСвойства.ДанныеВедомостиПередЗаписью);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеВедомостиПередЗаписью.Организация КАК Организация,
	|	ДанныеВедомостиПередЗаписью.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ДанныеВедомостиПередЗаписью.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДанныеВедомостиПередЗаписью.КВыплате КАК КВыплате,
	|	ДанныеВедомостиПередЗаписью.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ДанныеВедомостиПередЗаписью.Проведен КАК Проведен
	|ПОМЕСТИТЬ ВТДанныеВедомостиПередЗаписью
	|ИЗ
	|	&ДанныеВедомостиПередЗаписью КАК ДанныеВедомостиПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВедомостьПрочихДоходовВБанк.Организация КАК Организация,
	|	ВедомостьПрочихДоходовВБанк.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ВедомостьСписокВыплаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	СУММА(ВедомостьСписокВыплаты.КВыплате) КАК КВыплате,
	|	ВедомостьСписокВыплаты.НомерЛицевогоСчета КАК НомерЛицевогоСчета,
	|	ВедомостьПрочихДоходовВБанк.Проведен КАК Проведен
	|ПОМЕСТИТЬ ВТДанныеВедомостиПриЗаписи
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк.Выплаты КАК ВедомостьСписокВыплаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВедомостьПрочихДоходовВБанк КАК ВедомостьПрочихДоходовВБанк
	|		ПО ВедомостьСписокВыплаты.Ссылка = ВедомостьПрочихДоходовВБанк.Ссылка
	|ГДЕ
	|	ВедомостьСписокВыплаты.Ссылка = &Ведомость
	|
	|СГРУППИРОВАТЬ ПО
	|	ВедомостьПрочихДоходовВБанк.Организация,
	|	ВедомостьПрочихДоходовВБанк.ЗарплатныйПроект,
	|	ВедомостьСписокВыплаты.ФизическоеЛицо,
	|	ВедомостьСписокВыплаты.НомерЛицевогоСчета,
	|	ВедомостьПрочихДоходовВБанк.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Поле
	|ИЗ
	|	ВТДанныеВедомостиПередЗаписью КАК ДанныеВедомостиПередЗаписью
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТДанныеВедомостиПриЗаписи КАК ДанныеВедомостиПриЗаписи
	|		ПО ДанныеВедомостиПередЗаписью.Организация = ДанныеВедомостиПриЗаписи.Организация
	|			И ДанныеВедомостиПередЗаписью.ЗарплатныйПроект = ДанныеВедомостиПриЗаписи.ЗарплатныйПроект
	|			И ДанныеВедомостиПередЗаписью.ФизическоеЛицо = ДанныеВедомостиПриЗаписи.ФизическоеЛицо
	|			И ДанныеВедомостиПередЗаписью.КВыплате = ДанныеВедомостиПриЗаписи.КВыплате
	|			И ДанныеВедомостиПередЗаписью.НомерЛицевогоСчета = ДанныеВедомостиПриЗаписи.НомерЛицевогоСчета
	|			И ДанныеВедомостиПередЗаписью.Проведен = ДанныеВедомостиПриЗаписи.Проведен
	|ГДЕ
	|	(ДанныеВедомостиПередЗаписью.ФизическоеЛицо ЕСТЬ NULL
	|			ИЛИ ДанныеВедомостиПриЗаписи.ФизическоеЛицо ЕСТЬ NULL)";
	
	Если Не Запрос.Выполнить().Пустой() Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ВедомостьНаВыплатуЗарплатыВБанк.Ссылка КАК Ведомость,
		|	ПлатежныеДокументыПеречисленияЗарплаты.ПлатежныйДокумент КАК ПлатежныйДокумент
		|ИЗ
		|	Документ.ВедомостьНаВыплатуЗарплатыВБанк КАК ВедомостьНаВыплатуЗарплатыВБанк
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлатежныеДокументыПеречисленияЗарплаты КАК ПлатежныеДокументыПеречисленияЗарплаты
		|		ПО ВедомостьНаВыплатуЗарплатыВБанк.Ссылка = ПлатежныеДокументыПеречисленияЗарплаты.Ведомость
		|ГДЕ
		|	ВедомостьНаВыплатуЗарплатыВБанк.Ссылка = &Ведомость";
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ДанныеРеестра = Неопределено;
			Если Не ПустаяСтрока(ВедомостьОбъект.НомерРеестра) Тогда
				ДанныеРеестра = Новый Структура("Год, НомерРеестра", Год(ВедомостьОбъект.Дата), ВедомостьОбъект.НомерРеестра);
			КонецЕсли;
			ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьСостояниеЗачисленияЗарплатыПоДокументу(ВедомостьОбъект.Ссылка, Отказ, , ДанныеРеестра);
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			Пока Выборка.Следующий() Цикл
				ДанныеРеестра = Неопределено;
				МетаданныеПлатежногоДокумента = ОбменСБанкамиПоЗарплатнымПроектам.МетаданныеПлатежногоДокументаПеречисленияЗарплаты();
				Если МетаданныеПлатежногоДокумента.Реквизиты.Найти("НомерРеестра") <> Неопределено Тогда
					ДанныеПлатежногоДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.ПлатежныйДокумент, "Дата, НомерРеестра");
					Если Не ПустаяСтрока(ДанныеПлатежногоДокумента.НомерРеестра) Тогда
						ДанныеРеестра = Новый Структура("Год, НомерРеестра", Год(ДанныеПлатежногоДокумента.Дата), ДанныеПлатежногоДокумента.НомерРеестра);
					КонецЕсли;
				КонецЕсли;
				ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьСостояниеЗачисленияЗарплатыПоДокументу(Выборка.ПлатежныйДокумент, Отказ, , ДанныеРеестра);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	
	ТипИсточника = ТипЗнч(Источник);
	
	Если ТипИсточника = Тип("ДокументСсылка.ВедомостьПрочихДоходовВБанк")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ВедомостьПрочихДоходовВБанк") Тогда
		
		ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.СписокНаЗачислениеДенежныхСредствНаСчетаСотрудников;
		ПараметрыЭД.Направление = Перечисления.НаправленияЭД.Исходящий;
		ПараметрыЭД.Организация = Источник.Организация;
		ПараметрыЭД.Банк = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.ЗарплатныйПроект, "Банк");
		
	КонецЕсли;
	
КонецПроцедуры

// Получает ключевые реквизиты объекта по текстовому представлению.
//
// Параметры:
//  ИмяОбъекта - Строка, текстовое представление объекта, ключевые реквизиты которого необходимо получить.
//
// Возвращаемое значение:
//  СтруктураКлючевыхРеквизитов - перечень параметров объекта.
//
Процедура ПолучитьСтруктуруКлючевыхРеквизитовОбъекта(ИмяОбъекта, СтруктураКлючевыхРеквизитов) Экспорт
	
	Если ИмяОбъекта = "Документ.ВедомостьПрочихДоходовВБанк" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, ЗарплатныйПроект, НомерРеестра, ПометкаУдаления");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("ФизическоеЛицо, КВыплате, НомерЛицевогоСчета");
		СтруктураКлючевыхРеквизитов.Вставить("Выплаты", СтрокаРеквизитовОбъекта);
		
	Иначе
		ОбменСБанкамиПоЗарплатнымПроектамБазовый.ПолучитьСтруктуруКлючевыхРеквизитовОбъекта(ИмяОбъекта, СтруктураКлючевыхРеквизитов);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДополнитьСоставКомандЭДО(СоставКомандЭДО) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВзаиморасчетыПоПрочимДоходам") Тогда
		СоставКомандЭДО.Добавить("Документ.ВедомостьНаВыплатуЗарплатыВБанк");
	КонецЕсли;	

КонецПроцедуры

Процедура ДополнитьСуммуПоДокументу(СуммаПоДокументу, МассивВедомостей) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВедомостей", МассивВедомостей);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(Выплаты.КВыплате), 0) КАК СуммаПоДокументу
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк.Выплаты КАК Выплаты
	|ГДЕ
	|	Выплаты.Ссылка В(&МассивВедомостей)";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СуммаПоДокументу = СуммаПоДокументу + Выборка.СуммаПоДокументу;
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьТаблицуВедомостей(ТаблицаВедомостей, МассивВедомостей) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивВедомостей", МассивВедомостей);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВедомостьПрочихДоходовВБанк.Организация КАК Организация,
	|	ВедомостьПрочихДоходовВБанк.ЗарплатныйПроект КАК ЗарплатныйПроект,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВедомостьПрочихДоходовВБанк.СпособВыплаты) КАК СпособВыплатыНаименование,
	|	НЕОПРЕДЕЛЕНО КАК СпособВыплаты,
	|	ВедомостьПрочихДоходовВБанк.ПериодРегистрации КАК МесяцВыплаты
	|ИЗ
	|	Документ.ВедомостьПрочихДоходовВБанк КАК ВедомостьПрочихДоходовВБанк
	|ГДЕ
	|	ВедомостьПрочихДоходовВБанк.Ссылка В(&МассивВедомостей)";
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(Запрос.Выполнить().Выгрузить(), ТаблицаВедомостей);

КонецПроцедуры

Процедура УточнитьТекстЗапросаДинамическогоСпискаЗачислениеЗарплаты(ЗачислениеЗарплаты) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВзаиморасчетыПоПрочимДоходам") Тогда
		
		ТекстЗапроса = ЗачислениеЗарплаты.ТекстЗапроса;
		ДополнениеТекстЗапроса ="
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВедомостьПрочихДоходовВБанк.Организация,
		|	ВедомостьПрочихДоходовВБанк.Ссылка,
		|	ВедомостьПрочихДоходовВБанк.Номер,
		|	ВедомостьПрочихДоходовВБанк.Дата,
		|	ВедомостьПрочихДоходовВБанк.ЗарплатныйПроект,
		|	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка),
		|	ВедомостьПрочихДоходовВБанк.ПериодРегистрации,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВедомостьПрочихДоходовВБанк.СпособВыплаты),
		|	"""",
		|	"""",
		|	ВедомостьПрочихДоходовВБанк.СуммаПоДокументу
		|ИЗ
		|	Документ.ВедомостьПрочихДоходовВБанк КАК ВедомостьПрочихДоходовВБанк
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ОБЪЕДИНИТЬ ВСЕ",ДополнениеТекстЗапроса);
		ЗачислениеЗарплаты.ТекстЗапроса = ТекстЗапроса;
		
	КонецЕсли;
	
КонецПроцедуры


#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
//
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
КонецПроцедуры

Процедура СформироватьДвиженияПоДокументамОплаты(ДокументОплаты) Экспорт
	
	// Регистрация выдачи зарплаты.
	Если ПолучитьФункциональнуюОпцию("ИспользоватьВнешниеХозяйственныеОперацииЗарплатаКадры") Тогда
		
		ВедомостьОбъект = ДокументОплаты.ПолучитьОбъект();
		
		Отказ = Ложь;
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Ведомости = Новый Массив;
		Ведомости.Добавить(ДокументОплаты);
		ВзаиморасчетыССотрудниками.СоздатьВТДанныеВедомостейДляОплатыДокументом(Запрос.МенеджерВременныхТаблиц, Истина, ДокументОплаты, Ведомости, Неопределено, Ложь);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОплачиваемыеДанныеВедомостей.Ведомость,
		|	ОплачиваемыеДанныеВедомостей.ФизическоеЛицо,
		|	ОплачиваемыеДанныеВедомостей.СуммаКВыплате КАК СуммаВыплаты
		|ПОМЕСТИТЬ ВТСписокСотрудников
		|ИЗ
		|	ВТДанныеВедомостейДляОплатыДокументом КАК ОплачиваемыеДанныеВедомостей";
		
		ОплатаВедомостей = Запрос.Выполнить();
		
		УчетНДФЛ.РассчитатьИЗарегистрироватьУдержанныеНалоги(
			ДокументОплаты, 
			ВедомостьОбъект.Движения, 
			Отказ, 
			ВедомостьОбъект.Организация,
			ВедомостьОбъект.Дата, 
			Запрос.МенеджерВременныхТаблиц,
			Ложь);
		
		Если ВедомостьОбъект.ПеречислениеНДФЛВыполнено Тогда
			УчетНДФЛРасширенный.ЗарегистрироватьНДФЛПеречисленныйПоПлатежномуДокументу(ВедомостьОбъект.Движения, Отказ,
					ВедомостьОбъект.Организация, ВедомостьОбъект.Дата, ВедомостьОбъект.ПеречислениеНДФЛРеквизиты);
		КонецЕсли;
		
		Если Не Отказ Тогда
			Для каждого КоллекцияДвижения Из ВедомостьОбъект.Движения Цикл
				КоллекцияДвижения.ОбменДанными.Загрузка = Истина;
			КонецЦикла;
			ВедомостьОбъект.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
