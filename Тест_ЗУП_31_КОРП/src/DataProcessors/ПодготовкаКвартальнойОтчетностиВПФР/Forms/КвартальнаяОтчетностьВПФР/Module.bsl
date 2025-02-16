
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПерсонифицированныйУчетФормы.КвартальнаяОтчетностьПФРДополнитьКомандыФормы(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		
		ЗначенияДляЗаполнения  = Новый Структура("Организация", "Организация");	
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Если НЕ ЗначениеЗаполнено(Организация) Тогда
			Организация = ЗарплатаКадры.ПерваяДоступнаяОрганизация();
		КонецЕсли; 
		
		Если Не ЗначениеЗаполнено(Организация) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьКорректирующуюФормуРСВ_1", "Доступность", Ложь);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьКомплекты", "Доступность", Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	АктивныйОтчетныйПериод = Справочники.КомплектыОтчетностиПерсучета.АктивныйОтчетныйПериод(Организация);
	
	АктивныйОтчетныйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(АктивныйОтчетныйПериод);
	
	ОбновитьДанныеФормы();
	
	ФормыКвартальнойОтчетностиВПФР.Порядок.Элементы.Очистить();
		
	ЭлементПорядка = ФормыКвартальнойОтчетностиВПФР.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Использование = Истина;
	ЭлементПорядка.Поле  = Новый ПолеКомпоновкиДанных("ОтчетныйПериод");
	ЭлементПорядка.ТипУпорядочивания  = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	
	ЭлементПорядка = ФормыКвартальнойОтчетностиВПФР.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Использование = Истина;
	ЭлементПорядка.Поле  = Новый ПолеКомпоновкиДанных("Приоритет");
	ЭлементПорядка.ТипУпорядочивания  = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	ЭлементПорядка = ФормыКвартальнойОтчетностиВПФР.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Использование = Истина;
	ЭлементПорядка.Поле  = Новый ПолеКомпоновкиДанных("ПриоритетСостояния");
	ЭлементПорядка.ТипУпорядочивания  = НаправлениеСортировкиКомпоновкиДанных.Возр;
	
	// ТехнологияСервиса.ИнформационныйЦентр
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ИнформационныйЦентрСервер");
		Модуль.ВывестиКонтекстныеСсылки(ЭтаФорма, Элементы.ИнформационныеСсылки);
	КонецЕсли;
	// Конец ТехнологияСервиса.ИнформационныйЦентр
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Обработка.ПодготовкаКвартальнойОтчетностиВПФР",
		"КвартальнаяОтчетностьВПФР",
		Неопределено, 
		НСтр("ru='Новости: Подготовка квартальной отчетности в ПФР'"),
		Ложь, 
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Ложь),
		ИдентификаторыСобытийПриОткрытии 
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере.
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗаписьКомплектаПФР"
		И Параметр = Организация Тогда
		
		ПриЗаписиКомплектаНаСервере();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияЗагрузкиКомплектов()
	
	ПроверитьВыполнениеЗадания(
		"Подключаемый_ПроверитьВыполнениеЗаданияЗагрузкиКомплектов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПользователя", "Организация", Организация);
	
	АктивныйОтчетныйПериод = Справочники.КомплектыОтчетностиПерсучета.АктивныйОтчетныйПериод(Организация);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьКорректирующуюФормуРСВ_1", "Доступность", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьКомплекты", "Доступность", Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьКорректирующуюФормуРСВ_1", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗагрузитьКомплекты", "Доступность", Ложь);
	КонецЕсли;
	
	ОбновитьДанныеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивныйОтчетныйПериодСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("АктивныйОтчетныйПериодСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "АктивныйОтчетныйПериод", "АктивныйОтчетныйПериодСтрока", '20100101', ,Оповещение);	
	
КонецПроцедуры

&НаКлиенте
Процедура АктивныйОтчетныйПериодСтрокаНачалоВыбораЗавершение(Отказ, ДополнительныеПараметры) Экспорт

	ОтчетныйПериодПриИзмененииНаСервере();
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыСписокКомплектовКвартальнойОтчетности

&НаКлиенте
Процедура СписокКомплектовКвартальнойОтчетностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	Если ТипЗнч(Элементы.ФормыКвартальнойОтчетностиВПФР.ТекущиеДанные.Ссылка) = Тип("СправочникСсылка.КомплектыОтчетностиПерсучета") Тогда
		ПерсонифицированныйУчетКлиент.ОткрытьКомплектКвартальнойОтчетности( Элементы.ФормыКвартальнойОтчетностиВПФР.ТекущиеДанные.Ссылка)
	Иначе
		ПараметрыОткрытия.Вставить("Ключ", Элементы.ФормыКвартальнойОтчетностиВПФР.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Документ.РегламентированныйОтчет.Форма.ФормаДокумента", ПараметрыОткрытия);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// ТехнологияСервиса.ИнформационныйЦентр
&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформационныйЦентрКлиент");
		Модуль.НажатиеНаИнформационнуюСсылку(ЭтаФорма, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформационныйЦентрКлиент");
		Модуль.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтаФорма.ИмяФормы);
	КонецЕсли;
	
КонецПроцедуры
// Конец ТехнологияСервиса.ИнформационныйЦентр

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначеннуюКоманду(Команда)
	ПерсонифицированныйУчетКлиент.КвартальнаяОтчетностьПФРВыполнитьНазначеннуюКоманду(ЭтотОбъект, Команда);	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИсходныйКомплектОтчетности(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеНовогоРСВ1");
	
	Если АктивныйОтчетныйПериод = '20150401' 
		И ПерсонифицированныйУчетКлиентСервер.ВыбиратьФорматОтчетностиЗа2Кв2015() Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПослеВыбораФорматаОтчета", ЭтотОбъект);
		
		ОткрытьФорму("Обработка.ПодготовкаКвартальнойОтчетностиВПФР.Форма.ДиалогВыбораФормата",, ЭтотОбъект, ,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
	Иначе	
		СоздатьКомплектОтчетности(АктивныйОтчетныйПериод, Ложь);
	КонецЕсли;			
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФорматаОтчета(Формат, ДополнительныеПараметры) Экспорт 
	Если Формат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СпециальныйДокумент2015 = (Формат = 2014);
	
	СоздатьКомплектОтчетности(АктивныйОтчетныйПериод, Ложь, СпециальныйДокумент2015);
		
КонецПроцедуры	

&НаКлиенте
Процедура СоздатьКорректирующуюФормуРСВ(Команда)
	
	КорректируемыйПериод = Неопределено;
	
	Оповещение = Новый ОписаниеОповещения("СоздатьКорректирующуюФормуРСВЗавершение", ЭтотОбъект);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "КорректируемыйПериод", "КорректируемыйПериодСтрока", , ,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректирующуюФормуРСВЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	Модифицированность = Ложь;
	
	Если Не ЗначениеЗаполнено(КорректируемыйПериод) Тогда
		Возврат;
	КонецЕсли;	
	
	Если КорректируемыйПериод >= '20140101' Тогда
		СоздатьКомплектОтчетности(КорректируемыйПериод, Истина);	
	Иначе	
		СоздатьКорректирующуюФормуРСВ2013(КорректируемыйПериод);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКомплектОтчетности(ОтчетныйПериод, КорректирующаяФорма = Ложь, СпециальныйДокумент2015 = Ложь)
	ПерсонифицированныйУчетКлиент.СоздатьКомплектКвартальнойОтчетностиВФорме(Организация, ОтчетныйПериод, КорректирующаяФорма, СпециальныйДокумент2015);
	
	Элементы.ФормыКвартальнойОтчетностиВПФР.Обновить();		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректирующуюФормуРСВ2013(КорректируемыйПериод)
		
	ОписаниеКорректирующейФормыРСВ_1 = ОписаниеКорректирующейФормыРСВ_1(Организация, АктивныйОтчетныйПериод, КорректируемыйПериод);	
	
	ОкончаниеОтчетногоПериода = ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(КорректируемыйПериод);
	
	Если ОписаниеКорректирующейФормыРСВ_1 = Неопределено Тогда
		
		КорректирующаяРСВ_1 = РегламентированнаяОтчетностьКлиент.СформироватьАвтоматическиРеглОтчет(
				"РегламентированныйОтчетРСВ1", 
				Организация, 
				ОкончаниеОтчетногоПериода,,
				Истина);
				
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("КорректирующаяРСВ_1", КорректирующаяРСВ_1);
		ДополнительныеПараметры.Вставить("ОбновитьДанныеРеглОтчета", Ложь);
		
		СоздатьКорректирующуюФормуРСВ2013Завершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
		
	Иначе
		
		КорректирующаяРСВ_1 = ОписаниеКорректирующейФормыРСВ_1.Ссылка;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("КорректирующаяРСВ_1", КорректирующаяРСВ_1);
		ДополнительныеПараметры.Вставить("ОбновитьДанныеРеглОтчета", Истина);
		
		ТекстВопроса = НСтр("ru = 'В текущем отчетном периоде уже была сформирована корректирующая форма РСВ-1 за %1.
                            |Обновить данные этого отчета?'");
							
		Оповещение = Новый ОписаниеОповещения("СоздатьКорректирующуюФормуРСВ2013Завершение", ЭтотОбъект, ДополнительныеПараметры);					
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, ,КодВозвратаДиалога.Да);
		
	КонецЕсли;						
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректирующуюФормуРСВ2013Завершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	КорректирующаяРСВ_1 = ДополнительныеПараметры.КорректирующаяРСВ_1;
	
	Если ДополнительныеПараметры.ОбновитьДанныеРеглОтчета Тогда 
		
		РегламентированнаяОтчетностьКлиент.ОбновитьДанныеРеглОтчета(
			"РегламентированныйОтчетРСВ1", 
			Организация, 
			ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(КорректируемыйПериод),
			КорректирующаяРСВ_1);	
		
	КонецЕсли;
		
	УстановитьСостояниеКорректирующейФормыРСВ(
		КорректирующаяРСВ_1,
		Организация, 
		АктивныйОтчетныйПериод, 
		КорректируемыйПериод, 
		ПредопределенноеЗначение("Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияСформированы"));	
		
	Элементы.ФормыКвартальнойОтчетностиВПФР.Обновить();		
	
	ПараметрыОткрытия = Новый Структура("Ключ", КорректирующаяРСВ_1);
	
	ОткрытьФорму("Документ.РегламентированныйОтчет.Форма.ФормаДокумента", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеРСВ_1(Команда)
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияНеБудутПередаваться"));
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияСформированы"));
	СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияОтправлены"));
	
	Оповещение = Новый ОписаниеОповещения("УстановитьСостояниеРСВ_1Завершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(Оповещение, СписокВыбора, Элементы.УстановитьСостояниеРСВ_1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеРСВ_1Завершение(Состояние, ДополнительныеПараметры) Экспорт 
	
	ДанныеТекущейСтроки = Элементы.ФормыКвартальнойОтчетностиВПФР.ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Состояние <> Неопределено Тогда
		
		Если ТипЗнч(ДанныеТекущейСтроки.Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
			
			УстановитьСостояниеКорректирующейФормыРСВ(
				ДанныеТекущейСтроки.Ссылка,
				Организация, 
				ДанныеТекущейСтроки.ПериодФормирования, 
				ДанныеТекущейСтроки.ОтчетныйПериод,
				Состояние.Значение);
		ИначеЕсли ТипЗнч(ДанныеТекущейСтроки.Ссылка) = Тип("СправочникСсылка.КомплектыОтчетностиПерсучета") Тогда 
			УстановитьСостояниеКомплектаОтчетности(ДанныеТекущейСтроки.Ссылка, Состояние.Значение);				
		КонецЕсли;			
		ПриЗаписиКомплектаНаСервере();	
			
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКомплекты(Команда)
	
	СтруктураПараметровВыбора = Новый Структура("ТипФайловСведений,Организация",
		ПредопределенноеЗначение("Перечисление.ТипыФайловСведенийФизическихЛиц.КвартальнаяОтчетностьВПФР"),
		Организация);
		
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьКомплектыПродолжение", ЭтотОбъект);	
	ОткрытьФорму("ОбщаяФорма.ВыборФайловСведенийФизическихЛиц", СтруктураПараметровВыбора, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКомплектыПродолжение(СоответствиеИмпортируемыхФайлов, ДополнительныеПараметры) Экспорт 
	
	Если СоответствиеИмпортируемыхФайлов = Неопределено ИЛИ СоответствиеИмпортируемыхФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Периоды = Новый Массив;
	Для Каждого ОписаниеФайлаАДВ Из СоответствиеИмпортируемыхФайлов Цикл 
		Если Не ОписаниеФайлаАДВ.Значение.ЭтоРСВ_1
			Или Не ОписаниеФайлаАДВ.Значение.ЭтоКорректирующаяФорма Тогда
			
			Периоды.Добавить(ОписаниеФайлаАДВ.Значение.Период);	
		КонецЕсли;	
	КонецЦикла;	

	ОписаниеКомплектов = ОписаниеАктивныхКомплектовЗаПериоды(Организация, Периоды);
	
	ЕстьОтправленныеКомплекты = Ложь;
	Для Каждого СвойстваКомплекта Из ОписаниеКомплектов Цикл
		Если СвойстваКомплекта.Значение.СостояниеКомплекта = ПредопределенноеЗначение("Перечисление.СостояниеКомплектаОтчетностиПерсучета.СведенияОтправлены") Тогда
			ЕстьОтправленныеКомплекты = Истина;
			Прервать;
		КонецЕсли;	
	КонецЦикла;	
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("СоответствиеИмпортируемыхФайлов", СоответствиеИмпортируемыхФайлов);
	ДополнительныеПараметры.Вставить("ОписаниеКомплектов", ОписаниеКомплектов);
	
	Если ЕстьОтправленныеКомплекты Тогда 
		
		ТекстВопроса = НСтр("ru = 'За загружаемые периоды есть комплекты, имеющие состояние ""Сведения отправлены"".
	                         |Заменить их загружаемыми комплектами?'");
							 
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьКомплектыЗавершение", ЭтотОбъект, ДополнительныеПараметры);					 
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	Иначе 
		ЗагрузитьКомплектыЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры)
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКомплектыЗавершение(Ответ, ДополнительныеПараметры) Экспорт 

	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;  
	
	СоответствиеИмпортируемыхФайлов = ДополнительныеПараметры.СоответствиеИмпортируемыхФайлов;
	ОписаниеКомплектов = ДополнительныеПараметры.ОписаниеКомплектов;
	
	Результат = РезультатЗагрузкиКомплектовВДлительнойОперации(СоответствиеИмпортируемыхФайлов, ОписаниеКомплектов);
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища		 = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияЗагрузкиКомплектов", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВзносах(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	ПараметрыФормы.Вставить("ОтчетныйПериод", АктивныйОтчетныйПериод);
	
	ОткрытьФорму("Обработка.ПодготовкаКвартальнойОтчетностиВПФР.Форма.СведенияОВзносахИЗадолженностиВПФР", ПараметрыФормы);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция РежимВыбораПериода(ВыбираемыйПериод) Экспорт
	Год = Год(ВыбираемыйПериод);
	Если Год < 2011 Тогда
		Возврат "Полугодие";
	Иначе
		Возврат "Квартал";
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура ОбновитьДанныеФормы()	
	УстановитьПараметрыДинамическихСписков();
	
	УстановитьСвойстваКнопкиСозданияКомплекта();
		
	ПерсонифицированныйУчетФормы.КвартальнаяОтчетностьПФРОбновитьДанныеФормы(ЭтотОбъект);
КонецПроцедуры	

&НаСервере
Процедура ПриЗаписиКомплектаНаСервере()
	АктивныйОтчетныйПериод = Справочники.КомплектыОтчетностиПерсучета.АктивныйОтчетныйПериод(Организация);
		
	ОбновитьДанныеФормы();
КонецПроцедуры	

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	ПараметрОрганизация = ФормыКвартальнойОтчетностиВПФР.Параметры.Элементы.Найти("Организация");
	
	ПараметрОрганизация.Значение = Организация;	
	ПараметрОрганизация.Использование = Истина;
	
	ПараметрАктивныйОтчетныйПериод = ФормыКвартальнойОтчетностиВПФР.Параметры.Элементы.Найти("АктивныйОтчетныйПериод");
	
	ПараметрАктивныйОтчетныйПериод.Значение = АктивныйОтчетныйПериод;
	ПараметрАктивныйОтчетныйПериод.Использование = Истина;
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ОписаниеАктивногоКомплектаПериода(Организация, ОтчетныйПериод)
	Возврат Справочники.КомплектыОтчетностиПерсучета.ОписаниеАктивногоКомплектаПериода(Организация, ОтчетныйПериод, Ложь);	
КонецФункции	

&НаСервере
Процедура УстановитьСвойстваКнопкиСозданияКомплекта()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКомплектовКвартальнойОтчетностиСоздатьКомплектОтчетности", "Доступность", Истина);	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьКорректирующуюФормуРСВ_1", "Доступность", Истина);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКомплектовКвартальнойОтчетностиСоздатьКомплектОтчетности", "Доступность", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СведенияОВзносах", "Доступность", Ложь);
		Возврат;
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СведенияОВзносах", "Доступность", Истина);
	КонецЕсли;	
	
	ОписаниеАктивногоКомплектаПериода = ОписаниеАктивногоКомплектаПериода(Организация, АктивныйОтчетныйПериод);
	
	Если ОписаниеАктивногоКомплектаПериода = Неопределено
		Или (ОписаниеАктивногоКомплектаПериода.СостояниеКомплекта = Перечисления.СостояниеКомплектаОтчетностиПерсучета.СведенияНеБудутПередаваться
		Или ОписаниеАктивногоКомплектаПериода.СостояниеКомплекта = Перечисления.СостояниеКомплектаОтчетностиПерсучета.СведенияНеСформированы) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКомплектовКвартальнойОтчетностиСоздатьКомплектОтчетности", "Доступность", Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКомплектовКвартальнойОтчетностиСоздатьКомплектОтчетности", "Доступность", Ложь);	
	КонецЕсли;		
	
	Если АктивныйОтчетныйПериод >= '20170101' Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокКомплектовКвартальнойОтчетностиСоздатьКомплектОтчетности", "Доступность", Ложь);	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СоздатьКорректирующуюФормуРСВ_1", "Доступность", Ложь);
	КонецЕсли;
	
	АктивныйОтчетныйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(АктивныйОтчетныйПериод, Истина);	
	
	ЗаголовокКнопкиСозданияОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Создать комплект за %1'"), АктивныйОтчетныйПериодСтрока); 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"СписокКомплектовКвартальнойОтчетностиСоздатьКомплектОтчетности", 
		"Заголовок", 
		ЗаголовокКнопкиСозданияОтчета);
	
КонецПроцедуры	
	
&НаСервереБезКонтекста
Функция ОписаниеКорректирующейФормыРСВ_1(Организация, ПериодФормирования, КорректируемыйПериод)
	Возврат Справочники.КомплектыОтчетностиПерсучета.ОписаниеКорректирующейФормыРСВ_1(Организация, ПериодФормирования, КорректируемыйПериод);	
КонецФункции	

&НаКлиенте
Процедура УстановитьСостояниеКомплектаОтчетности(Ссылка, Состояние)
	Оповестить("ИзменениеСостоянияКомплектаОтчетностиПФР", Новый Структура("Комплект, Состояние", Ссылка, Состояние));	
	
	УстановитьСостояниеКомплектаОтчетностиНаСервере(Ссылка, Состояние);
КонецПроцедуры	 

&НаСервереБезКонтекста
Процедура УстановитьСостояниеКомплектаОтчетностиНаСервере(Ссылка, Состояние)
	ТекущееСостояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СостояниеКомплекта");		
	
	Если ТекущееСостояние <> Состояние Тогда
		КомплектОбъект = Ссылка.ПолучитьОбъект();
		
		Попытка 
			КомплектОбъект.Заблокировать();
		Исключение
			ВызватьИсключение НСтр("ru = 'Не удалось изменить объекта комплекта. Возможно объект редактируется другим пользователем.'");
			Возврат;
		КонецПопытки;
		
		КомплектОбъект.СостояниеКомплекта = Состояние;
		
		КомплектОбъект.Записать();
	КонецЕсли;	
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьСостояниеКорректирующейФормыРСВ(РСВ_1, Организация, ПериодФормирования, КорректируемыйПериод, Состояние)
	Справочники.КомплектыОтчетностиПерсучета.УстановитьСостояниеКорректирующейФормыРСВ_1(РСВ_1, Организация, ПериодФормирования, КорректируемыйПериод, Состояние);		
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ОписаниеАктивныхКомплектовЗаПериоды(Организация, Периоды)
	Возврат Справочники.КомплектыОтчетностиПерсучета.ОписаниеАктивныхКомплектовЗаПериоды(Организация, Периоды, Ложь);	
КонецФункции

&НаСервере
Функция РезультатЗагрузкиКомплектовВДлительнойОперации(СоответствиеИмпортируемыхФайлов, ОписаниеАктивныхКомплектовПериодов)
	
	Для Каждого ОписаниеФайла Из СоответствиеИмпортируемыхФайлов Цикл
		ОписаниеФайлаОписи = ОписаниеФайла.Значение;
		
		ОписаниеФайлаОписи.Вставить("Комплект");
		
		ОписаниеКомплекта = ОписаниеАктивныхКомплектовПериодов.Получить(ОписаниеФайлаОписи.Период);
		
		Если ОписаниеКомплекта <> Неопределено Тогда
			ОписаниеФайлаОписи.Комплект = ОписаниеКомплекта.Ссылка;
		КонецЕсли;	
	КонецЦикла;	
	
	ПараметрыЗагрузкиКомплектов = Справочники.КомплектыОтчетностиПерсучета.СтруктураПараметровДляЗагрузитьКомплектыСведений();
	ПараметрыЗагрузкиКомплектов.СоответствиеИмпортируемыхФайлов = СоответствиеИмпортируемыхФайлов;
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	Справочники.КомплектыОтчетностиПерсучета.ЗагрузитьКомплектыСведений(ПараметрыЗагрузкиКомплектов, АдресХранилища);
	Результат = Новый Структура("ЗаданиеВыполнено", Истина);
		
	Если Результат.ЗаданиеВыполнено Тогда
		ПриЗаписиКомплектаНаСервере();
	КонецЕсли;
	
	Возврат Результат;

КонецФункции	

&НаКлиенте
Процедура ПроверитьВыполнениеЗадания(ИмяОбработчика, СтруктураОповещения = Неопределено, СсылкаОповещения = Неопределено)
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ПриЗаписиКомплектаНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				Если СтруктураОповещения <> Неопределено Тогда
					Оповестить(СтруктураОповещения.ИмяСобытия, СтруктураОповещения.Параметр, ЭтаФорма);
				КонецЕсли;
				Если СсылкаОповещения <> Неопределено Тогда
					ОповеститьОбИзменении(СсылкаОповещения);
				КонецЕсли;
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					ИмяОбработчика,
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтчетныйПериодПриИзмененииНаСервере()
	УстановитьСвойстваКнопкиСозданияКомплекта();
	ОбновитьДанныеФормы();	
КонецПроцедуры	

&НаКлиенте
Процедура ПоместитьНаУдаление(Команда)
	ДанныеТекущейСтроки = Элементы.ФормыКвартальнойОтчетностиВПФР.ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ПоместитьНаУдалениеНаСервере(ДанныеТекущейСтроки.Ссылка, ДанныеТекущейСтроки.ПериодФормирования, ДанныеТекущейСтроки.ОтчетныйПериод);
КонецПроцедуры

&НаСервере
Процедура ПоместитьНаУдалениеНаСервере(Ссылка, ПериодФормирования, КорректируемыйПериод)
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
		УстановитьСостояниеКорректирующейФормыРСВ(Ссылка, Организация, ПериодФормирования, КорректируемыйПериод, Перечисления.СостояниеКомплектаОтчетностиПерсучета.СведенияНеБудутПередаваться);
	Иначе
		КомплектОбъект = Ссылка.ПолучитьОбъект();
		Если КомплектОбъект.ПометкаУдаления Тогда
			КомплектОбъект.УстановитьПометкуУдаления(Ложь);
		Иначе
			КомплектОбъект.УстановитьПометкуУдаления(Истина);
		КонецЕсли;
	КонецЕсли;	
	
	Элементы.ФормыКвартальнойОтчетностиВПФР.Обновить();	
	ПриЗаписиКомплектаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии.
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии.

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#КонецОбласти
