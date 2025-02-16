////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адаптация и увольнение".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ОтборыНазначения

// Выполняет с формой объекта назначения действия, необходимые для подключения подсистемы "Адаптация и увольнение".
//
// Параметры:
//	Форма - УправляемаяФорма - форма для подключения механизма.
//
Процедура ОбъектНазначенияПодготовитьФорму(Форма, ЭтоФормаПозицииШР = Ложь) Экспорт
	
	Если Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.МероприятияАдаптацииУвольнения) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнитьФормуОбъектаНазначения(Форма, ЭтоФормаПозицииШР);
	УстановитьДоступностьТаблиц(Форма);
	
КонецПроцедуры

// Выводит на форму мероприятия "Адаптации и увольнения", связанные с объектом назначения.
//
// Параметры:
//	Форма - УправляемаяФорма - форма для подключения механизма.
//	ЭтоФормаПозицииШР - Булево
//
Процедура ОбъектНазначенияПриПолученииДанных(Форма, ЭтоФормаПозицииШР = Ложь) Экспорт
	
	Если Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение() Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВРеквизитыФормы(Форма, ЭтоФормаПозицииШР);
	
КонецПроцедуры

Процедура ОбъектНазначенияПриЧтенииНаСервере(Форма, ЭтоФормаПозицииШР = Ложь) Экспорт
	
	Если Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектНазначенияПодготовитьФорму(Форма, ЭтоФормаПозицииШР);
	ОбъектНазначенияПриПолученииДанных(Форма, ЭтоФормаПозицииШР);
	
КонецПроцедуры

Процедура ОбъектНазначенияПриЗаписиНаСервере(Форма, ОбъектНазначения, Отказ) Экспорт
	
	Если Отказ 
		Или Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение()
		Или Не ЭлементыПодсистемыНаФорме(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ОтборыНазначенияМероприятийАдаптацииУвольнения.СоздатьМенеджерЗаписи();
	
	МероприятияПрежние = Новый Массив(Форма.МероприятияПрежние);
	МероприятияТекущие = Новый Массив;
	
	ТаблицаМероприятийВДанные(ОбъектНазначения, Форма.МероприятияАдаптации, МероприятияПрежние, МероприятияТекущие);
	ТаблицаМероприятийВДанные(ОбъектНазначения, Форма.МероприятияУвольнения, МероприятияПрежние, МероприятияТекущие);
	
	ОтмененныеМероприятия = ОбщегоНазначенияКлиентСервер.РазностьМассивов(МероприятияПрежние, МероприятияТекущие);
	МенеджерЗаписи = РегистрыСведений.ОтборыНазначенияМероприятийАдаптацииУвольнения.СоздатьМенеджерЗаписи();
	
	Для Каждого Мероприятие Из ОтмененныеМероприятия Цикл
		
		МенеджерЗаписи.ОбъектНазначения = ОбъектНазначения;
		МенеджерЗаписи.Мероприятие = Мероприятие;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПодготовитьФормуДолжности(Форма) Экспорт
	
	Если Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение()
		Или Не ПравоДоступа("Чтение", Метаданные.Справочники.МероприятияАдаптацииУвольнения) Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаСтраницы = Форма.Элементы.Найти("ГруппаСтраницы");
	
	Если ГруппаСтраницы <> Неопределено И ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет Тогда
		ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	ОбъектНазначенияПодготовитьФорму(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область НазначаемыеМероприятия

Процедура ЗаполнитьНазначаемыеМероприятия(Форма, ПараметрыЗаполнения, ОчиститьПередЗаполнением = Истина) Экспорт
	
	ДанныеМероприятий = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Объект.МероприятияАдаптацииУвольнения");
	АдаптацияУвольнение.ЗаполнитьКоллекциюНазначаемымиМероприятиями(ДанныеМероприятий, ПараметрыЗаполнения, ОчиститьПередЗаполнением);
	
КонецПроцедуры

Процедура КадровыйПереводЗаполнитьНазначаемыеМероприятия(Форма, ПараметрыЗаполнения) Экспорт
	
	Если Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНазначаемыеМероприятия(Форма, ПараметрыЗаполнения, Истина);
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.ДатаОкончанияСобытия) Тогда
		
		ПараметрыЗаполненияПослеПеревода = АдаптацияУвольнение.ПараметрыЗаполненияМероприятий();
		
		ПараметрыЗаполненияПослеПеревода.Организация = ПараметрыЗаполнения.ПредыдущаяОрганизация;
		ПараметрыЗаполненияПослеПеревода.ФизическоеЛицо = ПараметрыЗаполнения.ФизическоеЛицо;
		ПараметрыЗаполненияПослеПеревода.Позиция = ПараметрыЗаполнения.ПредыдущаяПозиция;
		ПараметрыЗаполненияПослеПеревода.Подразделение = ПараметрыЗаполнения.ПредыдущееПодразделение;
		ПараметрыЗаполненияПослеПеревода.Должность = ПараметрыЗаполнения.ПредыдущаяДолжность;
		ПараметрыЗаполненияПослеПеревода.ВидСобытия = Документы.РешениеОКадровомПереводе.ВидСобытияАдаптацииУвольнения();
		ПараметрыЗаполненияПослеПеревода.ДатаСобытия = ПараметрыЗаполнения.ДатаОкончанияСобытия + 86400;
		
		ПараметрыЗаполненияПослеПеревода.ПредыдущаяОрганизация = ПараметрыЗаполнения.Организация;
		ПараметрыЗаполненияПослеПеревода.ПредыдущаяПозиция = ПараметрыЗаполнения.Позиция;
		ПараметрыЗаполненияПослеПеревода.ПредыдущееПодразделение = ПараметрыЗаполнения.Подразделение;
		ПараметрыЗаполненияПослеПеревода.ПредыдущаяДолжность = ПараметрыЗаполнения.Должность;
		ПараметрыЗаполненияПослеПеревода.ПредыдущийВидКадровогоСобытия = Перечисления.ВидыКадровыхСобытий.Перемещение;
		
		ЗаполнитьНазначаемыеМероприятия(Форма, ПараметрыЗаполненияПослеПеревода, Ложь)
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийОбъектаОснования

Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	ТекущийОбъект = Форма.РеквизитФормыВЗначение("Объект");
	
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Отказ Тогда
		АдаптацияУвольнение.ПроверитьНаличиеДубляДокумента(ТекущийОбъект, Отказ);
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Объект"));
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма, ОбъектНазначения, ПараметрыЗаписи) Экспорт
	
	РешениеПриПолученииДанных(Форма);
	
	Если ПараметрыЗаписи.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		ЗапуститьОбновлениеЗаданийАдаптацииУвольнения(Форма.УникальныйИдентификатор, ОбъектНазначения.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КадровыеДокументы

Процедура ДополнитьФормуКадровогоДокумента(Форма, ДобавлятьЭлементыФормы = Истина, ДобавлятьРеквизитыФормы = Истина, ОтложенноеИзменение = Ложь) Экспорт
	
	Если Не АдаптацияУвольнение.ИспользуетсяАдаптацияУвольнение() Тогда
		Возврат;
	КонецЕсли;
	
	ГруппаРешение = Форма.Элементы.Найти("ГруппаРешение");
	
	Если ГруппаРешение = НеОпределено Тогда
		Возврат;
	КонецЕсли;
		
	Если ДобавлятьРеквизитыФормы Тогда
		
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("РешениеИнфоНадпись", Новый ОписаниеТипов("ФорматированнаяСтрока")));
		
		МассивИменРеквизитовФормы = Новый Массив;
		ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы);
		ЗарплатаКадры.ИзменитьРеквизитыФормы(Форма, ДобавляемыеРеквизиты, МассивИменРеквизитовФормы,, ОтложенноеИзменение);
		
	КонецЕсли;
	
	Если ДобавлятьЭлементыФормы И Форма.Элементы.Найти("РешениеИнфоНадпись") = Неопределено Тогда
		
		Элемент = Форма.Элементы.Вставить("РешениеИнфоНадпись", Тип("ПолеФормы"), ГруппаРешение);
		Элемент.Вид = ВидПоляФормы.ПолеНадписи;
		Элемент.ПутьКДанным = "РешениеИнфоНадпись";
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		Элемент.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_РешениеИнфоНадписьОбработкаНавигационнойСсылки");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтображениеНадписейВКадровомДокументе(Форма) Экспорт
	
	Если Форма.Элементы.Найти("РешениеИнфоНадпись") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Решение = Форма.Объект.Решение;
	
	Если ЗначениеЗаполнено(Решение) Тогда
		Форма.РешениеИнфоНадпись = Новый ФорматированнаяСтрока(Новый ФорматированнаяСтрока(Строка(Решение)), , , , "ДокументРешение");
	Иначе
		Форма.РешениеИнфоНадпись = Новый ФорматированнаяСтрока(Новый ФорматированнаяСтрока(НСтр("ru='Решение'")), , , , Решение.Метаданные().Имя);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаНавигационнойСсылкиРешенияЗавершение(Форма, Результат, ДополнительныеПараметры) Экспорт
	
	Форма.Объект.Решение = Результат;
	Форма.Модифицированность = Истина;
	
	УстановитьОтображениеНадписейВКадровомДокументе(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область Решения

Процедура РешениеПриПолученииДанных(Форма) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.КадровыеДокументы) Тогда
		Возврат;
	КонецЕсли;
	
	Решение = Форма.Объект.Ссылка;
	Приказ = АдаптацияУвольнение.СвязанныйСРешениемПриказ(Решение);
	
	Если ЗначениеЗаполнено(Приказ) Тогда
		Форма.КадровыйПриказИнфоНадпись = Новый ФорматированнаяСтрока(Строка(Приказ), , , , ПолучитьНавигационнуюСсылку(Приказ));
	Иначе
		Форма.КадровыйПриказИнфоНадпись = "";
	КонецЕсли;
	
	Форма.Элементы.КадровыйПриказИнфоНадпись.Видимость = ЗначениеЗаполнено(Форма.КадровыйПриказИнфоНадпись);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьФормуОбъектаНазначения(Форма, ЭтоФормаПозицииШР)
	
	Элементы = Форма.Элементы;
	Если ЭлементыПодсистемыНаФорме(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовкиГрупп = Форма.ЗаголовкиГруппСтраницыАдаптацияУвольнение();
	ЗаголовокПоляПредставление = ?(ЭтоФормаПозицииШР, НСтр("ru = 'Когда выполняется'"), НСтр("ru = 'Событие'"));
	ЗаголовокПоляМероприятие = НСтр("ru = 'Мероприятие'");
	ЗаголовокПоляНазначение = НСтр("ru = 'Для чего'");
	
	ДобавляемыеРеквизиты = Новый Массив;
	
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("МероприятияАдаптации",	Новый ОписаниеТипов("ТаблицаЗначений")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Мероприятие",			Новый ОписаниеТипов("СправочникСсылка.МероприятияАдаптацииУвольнения"), "МероприятияАдаптации"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("События",				Новый ОписаниеТипов("СписокЗначений"), "МероприятияАдаптации"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПредставлениеСобытий",	ОбщегоНазначения.ОписаниеТипаСтрока(100), "МероприятияАдаптации"));
	
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("МероприятияУвольнения",	Новый ОписаниеТипов("ТаблицаЗначений")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Мероприятие",			Новый ОписаниеТипов("СправочникСсылка.МероприятияАдаптацииУвольнения"), "МероприятияУвольнения"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("События",				Новый ОписаниеТипов("СписокЗначений"), "МероприятияУвольнения"));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПредставлениеСобытий",	ОбщегоНазначения.ОписаниеТипаСтрока(100), "МероприятияУвольнения"));
	
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("МероприятияПрежние",	Новый ОписаниеТипов()));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("МероприятиеПрежнее",	Новый ОписаниеТипов("СправочникСсылка.МероприятияАдаптацииУвольнения")));
	
	Если ЭтоФормаПозицииШР Тогда
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Назначение",	ОбщегоНазначения.ОписаниеТипаСтрока(30), "МероприятияАдаптации"));
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Назначение",	ОбщегоНазначения.ОписаниеТипаСтрока(30), "МероприятияУвольнения"));
	КонецЕсли;
	
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(Форма, МассивИменРеквизитовФормы);
	ЗарплатаКадры.ИзменитьРеквизитыФормы(Форма, ДобавляемыеРеквизиты, МассивИменРеквизитовФормы);
	
	Форма.МероприятияПрежние = Новый ФиксированныйМассив(Новый Массив);
	ГруппаМероприятия = Элементы.Найти("МероприятияАдаптацииУвольненияГруппа");
	
	ИмяГруппы = "МероприятияАдаптацииГруппа";
	ГруппаМероприятияАдаптации = Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), ГруппаМероприятия);
	ГруппаМероприятияАдаптации.Заголовок = ЗаголовкиГрупп[ИмяГруппы];
	ГруппаМероприятияАдаптации.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаМероприятияАдаптации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	
	ТаблицаМероприятийАдаптации = Элементы.Добавить("МероприятияАдаптации", Тип("ТаблицаФормы"), ГруппаМероприятияАдаптации);
	ТаблицаМероприятийАдаптации.ПутьКДанным = "МероприятияАдаптации";
	ТаблицаМероприятийАдаптации.Отображение = ОтображениеТаблицы.Список;
	ТаблицаМероприятийАдаптации.ИзменятьПорядокСтрок = Ложь;
	ТаблицаМероприятийАдаптации.УстановитьДействие("Выбор", "Подключаемый_МероприятияВыбор");
	ТаблицаМероприятийАдаптации.УстановитьДействие("ПередУдалением", "Подключаемый_МероприятияПередУдалением");
	ТаблицаМероприятийАдаптации.УстановитьДействие("ПередНачаломДобавления", "Подключаемый_МероприятияПередНачаломДобавления");
	ТаблицаМероприятийАдаптации.УстановитьДействие("ПриОкончанииРедактирования", "Подключаемый_МероприятияПриОкончанииРедактирования");
	
	ПолеМероприятие = Элементы.Добавить("МероприятияАдаптацииМероприятие", Тип("ПолеФормы"), ТаблицаМероприятийАдаптации);
	ПолеМероприятие.ПутьКДанным = "МероприятияАдаптации.Мероприятие";
	ПолеМероприятие.Заголовок = ЗаголовокПоляМероприятие;
	ПолеМероприятие.Вид = ВидПоляФормы.ПолеВвода;
	ПолеМероприятие.АвтоОтметкаНезаполненного = Истина;
	ПолеМероприятие.УстановитьДействие("НачалоВыбора", "Подключаемый_МероприятияМероприятиеНачалоВыбора");
	ПолеМероприятие.УстановитьДействие("ОбработкаВыбора", "Подключаемый_МероприятияМероприятиеОбработкаВыбора");
	
	ПолеПредставление = Элементы.Добавить("МероприятияАдаптацииПредставлениеСобытий", Тип("ПолеФормы"), ТаблицаМероприятийАдаптации);
	ПолеПредставление.ПутьКДанным = "МероприятияАдаптации.ПредставлениеСобытий";
	ПолеПредставление.Заголовок = ЗаголовокПоляПредставление;
	ПолеПредставление.Вид = ВидПоляФормы.ПолеНадписи;
	ПолеПредставление.Гиперссылка = Истина;
	ПолеПредставление.ГиперссылкаЯчейки = Истина;
	ПолеПредставление.ТолькоПросмотр = Истина;
	
	ИмяГруппы = "МероприятияУвольненияГруппа";
	ГруппаМероприятияУвольнения = Элементы.Добавить("МероприятияУвольненияГруппа", Тип("ГруппаФормы"), ГруппаМероприятия);
	ГруппаМероприятияУвольнения.Заголовок = ЗаголовкиГрупп[ИмяГруппы];
	ГруппаМероприятияУвольнения.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаМероприятияУвольнения.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	
	ТаблицаМероприятийУвольнения = Элементы.Добавить("МероприятияУвольнения", Тип("ТаблицаФормы"), ГруппаМероприятияУвольнения);
	ТаблицаМероприятийУвольнения.ПутьКДанным = "МероприятияУвольнения";
	ТаблицаМероприятийУвольнения.Отображение = ОтображениеТаблицы.Список;
	ТаблицаМероприятийУвольнения.ИзменятьПорядокСтрок = Ложь;
	ТаблицаМероприятийУвольнения.УстановитьДействие("Выбор", "Подключаемый_МероприятияВыбор");
	ТаблицаМероприятийУвольнения.УстановитьДействие("ПередУдалением", "Подключаемый_МероприятияПередУдалением");
	ТаблицаМероприятийУвольнения.УстановитьДействие("ПередНачаломДобавления", "Подключаемый_МероприятияПередНачаломДобавления");
	ТаблицаМероприятийУвольнения.УстановитьДействие("ПриОкончанииРедактирования", "Подключаемый_МероприятияПриОкончанииРедактирования");
	
	ПолеМероприятие = Элементы.Добавить("МероприятияУвольненияМероприятие", Тип("ПолеФормы"), ТаблицаМероприятийУвольнения);
	ПолеМероприятие.ПутьКДанным = "МероприятияУвольнения.Мероприятие";
	ПолеМероприятие.Заголовок = ЗаголовокПоляМероприятие;
	ПолеМероприятие.Вид = ВидПоляФормы.ПолеВвода;
	ПолеМероприятие.АвтоОтметкаНезаполненного = Истина;
	ПолеМероприятие.УстановитьДействие("НачалоВыбора", "Подключаемый_МероприятияМероприятиеНачалоВыбора");
	ПолеМероприятие.УстановитьДействие("ОбработкаВыбора", "Подключаемый_МероприятияМероприятиеОбработкаВыбора");
	
	ПолеПредставление = Элементы.Добавить("МероприятияУвольненияПредставлениеСобытий", Тип("ПолеФормы"), ТаблицаМероприятийУвольнения);
	ПолеПредставление.ПутьКДанным = "МероприятияУвольнения.ПредставлениеСобытий";
	ПолеПредставление.Заголовок = ЗаголовокПоляПредставление;
	ПолеПредставление.Вид = ВидПоляФормы.ПолеНадписи;
	ПолеПредставление.Гиперссылка = Истина;
	ПолеПредставление.ГиперссылкаЯчейки = Истина;
	ПолеПредставление.ТолькоПросмотр = Истина;
	
	Если ЭтоФормаПозицииШР Тогда
		
		ТаблицаМероприятийАдаптации.УстановитьДействие("ПередНачаломИзменения", "Подключаемый_МероприятияПередНачаломИзменения");
		ТаблицаМероприятийУвольнения.УстановитьДействие("ПередНачаломИзменения", "Подключаемый_МероприятияПередНачаломИзменения");
		
		ЗначенияВыбора = Новый Массив;
		ЗначенияВыбора.Добавить(АдаптацияУвольнениеКлиентСервер.НазначениеДляОрганизации());
		ЗначенияВыбора.Добавить(АдаптацияУвольнениеКлиентСервер.НазначениеДляПозиции());
		ЗначенияВыбора.Добавить(АдаптацияУвольнениеКлиентСервер.НазначениеДляПодразделения());
		ЗначенияВыбора.Добавить(АдаптацияУвольнениеКлиентСервер.НазначениеДляДолжности());
		ЗначенияВыбора.Добавить(АдаптацияУвольнениеКлиентСервер.НазначениеДляПодразделенияИДолжности());
		
		ПолеНазначение = Элементы.Добавить("МероприятияАдаптацииНазначение", Тип("ПолеФормы"), ТаблицаМероприятийАдаптации);
		ПолеНазначение.ПутьКДанным = "МероприятияАдаптации.Назначение";
		ПолеНазначение.Заголовок = ЗаголовокПоляНазначение;
		ПолеНазначение.Вид = ВидПоляФормы.ПолеВвода;
		ПолеНазначение.РежимВыбораИзСписка = Истина;
		ПолеНазначение.Ширина = 10;
		ПолеНазначение.СписокВыбора.ЗагрузитьЗначения(ЗначенияВыбора);
		ПолеНазначение.ТолькоПросмотр = Истина;
		
		ПолеНазначение = Элементы.Добавить("МероприятияУвольненияНазначение", Тип("ПолеФормы"), ТаблицаМероприятийУвольнения);
		ПолеНазначение.ПутьКДанным = "МероприятияУвольнения.Назначение";
		ПолеНазначение.Заголовок = ЗаголовокПоляНазначение;
		ПолеНазначение.Вид = ВидПоляФормы.ПолеВвода;
		ПолеНазначение.РежимВыбораИзСписка = Истина;
		ПолеНазначение.Ширина = 10;
		ПолеНазначение.СписокВыбора.ЗагрузитьЗначения(ЗначенияВыбора);
		ПолеНазначение.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДанныеВРеквизитыФормы(Форма, ЭтоФормаПозицииШР = Ложь)
	
	Если Не ЭлементыПодсистемыНаФорме(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаОбъект = Форма.Объект.Ссылка;
	
	МероприятияАдаптации = Форма.МероприятияАдаптации;
	МероприятияУвольнения = Форма.МероприятияУвольнения;
	
	МероприятияАдаптации.Очистить();
	МероприятияУвольнения.Очистить();
	
	ДанныеМероприятий = ДанныеМероприятийПоОбъектуНазначения(СсылкаНаОбъект);
	Форма.МероприятияПрежние = Новый ФиксированныйМассив(ДанныеМероприятий.ВыгрузитьКолонку("Мероприятие"));
	
	Если ЭтоФормаПозицииШР Тогда
		
		РеквизитыПозицииШР = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СсылкаНаОбъект, "Владелец,Подразделение,Должность");
		
		ДополнитьТаблицыМероприятиямиДляПозиции(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий);
		
		ДанныеМероприятийПоОрганизации = ДанныеМероприятийПоОбъектуНазначения(РеквизитыПозицииШР.Владелец);
		ДополнитьТаблицыМероприятиямиДляОрганизации(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятийПоОрганизации);
		
		ДанныеМероприятийПоПодразделению = ДанныеМероприятийПоОбъектуНазначения(РеквизитыПозицииШР.Подразделение);
		ДанныеМероприятийПоДолжности = ДанныеМероприятийПоОбъектуНазначения(РеквизитыПозицииШР.Должность);
		
		Если ЗначениеЗаполнено(ДанныеМероприятийПоПодразделению) 
			И ЗначениеЗаполнено(ДанныеМероприятийПоДолжности) Тогда
			
			ДанныеМероприятий = НоваяТаблицаМероприятий();
			
			МероприятияПоПозиции = ДанныеМероприятий.ВыгрузитьКолонку("Мероприятие");
			МероприятияПоПодразделению = ДанныеМероприятийПоПодразделению.ВыгрузитьКолонку("Мероприятие");
			МероприятияПоДолжности = ДанныеМероприятийПоДолжности.ВыгрузитьКолонку("Мероприятие");
			
			Для Каждого Мероприятие Из МероприятияПоПодразделению Цикл
				
				НазначеноДляПозиции = МероприятияПоПозиции.Найти(Мероприятие) <> НеОпределено;
				НазначеноДляДолжности = МероприятияПоДолжности.Найти(Мероприятие) <> НеОпределено;
				
				Если НазначеноДляПозиции Или НазначеноДляДолжности Тогда
					
					СтрокаДанныхПоПодразделению = ДанныеМероприятийПоПодразделению.Найти(Мероприятие, "Мероприятие");
					СтрокаДанныхПоДолжности = ДанныеМероприятийПоДолжности.Найти(Мероприятие, "Мероприятие");
					
					Если Не НазначеноДляПозиции И НазначеноДляДолжности Тогда
						ЗаполнитьЗначенияСвойств(ДанныеМероприятий.Добавить(), СтрокаДанныхПоДолжности);
					КонецЕсли;
					
					ДанныеМероприятийПоПодразделению.Удалить(СтрокаДанныхПоПодразделению);
					ДанныеМероприятийПоДолжности.Удалить(СтрокаДанныхПоДолжности);
					
				КонецЕсли;
				
			КонецЦикла;
			
			ДополнитьТаблицыМероприятиямиДляПодразделенияИДолжности(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий);
			
		КонецЕсли;
		
		ДополнитьТаблицыМероприятиямиДляПодразделения(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятийПоПодразделению);
		ДополнитьТаблицыМероприятиямиДляДолжности(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятийПоДолжности);
		
	Иначе
		
		ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий, Назначение = "")
	
	Для Каждого ДанныеМероприятия Из ДанныеМероприятий Цикл
		
		Если ДанныеМероприятия.ЭтоМероприятиеАдаптации Тогда
			
			СтрокиМероприятия = МероприятияАдаптации.НайтиСтроки(Новый Структура("Мероприятие", ДанныеМероприятия.Мероприятие));
			
			Если Не ЗначениеЗаполнено(СтрокиМероприятия) Тогда
				
				НоваяСтрока = МероприятияАдаптации.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеМероприятия);
				
				Если Не ПустаяСтрока(Назначение) Тогда
					НоваяСтрока.Назначение = Назначение;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДанныеМероприятия.ЭтоМероприятиеУвольнения Тогда
			
			СтрокиМероприятия = МероприятияУвольнения.НайтиСтроки(Новый Структура("Мероприятие", ДанныеМероприятия.Мероприятие));
			
			Если Не ЗначениеЗаполнено(СтрокиМероприятия) Тогда
				
				НоваяСтрока = МероприятияУвольнения.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеМероприятия);
				
				Если Не ПустаяСтрока(Назначение) Тогда
					НоваяСтрока.Назначение = Назначение;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьТаблицыМероприятиямиДляОрганизации(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий)
	
	ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий, АдаптацияУвольнениеКлиентСервер.НазначениеДляОрганизации());
	
КонецПроцедуры

Процедура ДополнитьТаблицыМероприятиямиДляПодразделения(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий)
	
	ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий, АдаптацияУвольнениеКлиентСервер.НазначениеДляПодразделения());
	
КонецПроцедуры

Процедура ДополнитьТаблицыМероприятиямиДляДолжности(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий)
	
	ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий, АдаптацияУвольнениеКлиентСервер.НазначениеДляДолжности());
	
КонецПроцедуры

Процедура ДополнитьТаблицыМероприятиямиДляПозиции(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий)
	
	ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий, АдаптацияУвольнениеКлиентСервер.НазначениеДляПозиции());
	
КонецПроцедуры

Процедура ДополнитьТаблицыМероприятиямиДляПодразделенияИДолжности(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий)
	
	ДополнитьТаблицыМероприятиями(МероприятияАдаптации, МероприятияУвольнения, ДанныеМероприятий, АдаптацияУвольнениеКлиентСервер.НазначениеДляПодразделенияИДолжности());
	
КонецПроцедуры

Функция НоваяТаблицаМероприятий()
	
	ТаблицаМероприятий = Новый ТаблицаЗначений;
	
	ТаблицаМероприятий.Колонки.Добавить("Мероприятие", Новый ОписаниеТипов("СправочникСсылка.МероприятияАдаптацииУвольнения"));
	ТаблицаМероприятий.Колонки.Добавить("События", Новый ОписаниеТипов("СписокЗначений"));
	ТаблицаМероприятий.Колонки.Добавить("ПредставлениеСобытий", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	ТаблицаМероприятий.Колонки.Добавить("ЭтоМероприятиеАдаптации", Новый ОписаниеТипов("Булево"));
	ТаблицаМероприятий.Колонки.Добавить("ЭтоМероприятиеУвольнения", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаМероприятий;
	
КонецФункции

Функция ДанныеМероприятийПоОбъектуНазначения(ОбъектНазначения)
	
	ТаблицаМероприятий = НоваяТаблицаМероприятий();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОбъектНазначения", ОбъектНазначения);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ОбъектыНазначения.Мероприятие КАК Мероприятие,
	|	МероприятияАдаптацииУвольнения.ВидМероприятия
	|ПОМЕСТИТЬ ВТМероприятия
	|ИЗ
	|	РегистрСведений.ОтборыНазначенияМероприятийАдаптацииУвольнения КАК ОбъектыНазначения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МероприятияАдаптацииУвольнения КАК МероприятияАдаптацииУвольнения
	|		ПО ОбъектыНазначения.Мероприятие = МероприятияАдаптацииУвольнения.Ссылка
	|ГДЕ
	|	ОбъектыНазначения.ОбъектНазначения = &ОбъектНазначения
	|	И НЕ МероприятияАдаптацииУвольнения.ВАрхиве
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставМероприятий.Мероприятие КАК Мероприятие,
	|	ВЫБОР
	|		КОГДА СобытияМероприятий.ВидСобытия ЕСТЬ NULL 
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСобытийАдаптацииУвольнения.ПустаяСсылка)
	|		ИНАЧЕ СобытияМероприятий.ВидСобытия
	|	КОНЕЦ КАК ВидСобытия,
	|	ВЫБОР
	|		КОГДА СобытияМероприятий.ВидСобытия ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КолВоСобытий,
	|	ВЫБОР
	|		КОГДА СоставМероприятий.ВидМероприятия <> ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийАдаптацииУвольнения.Увольнение)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоМероприятиеАдаптации,
	|	ВЫБОР
	|		КОГДА СоставМероприятий.ВидМероприятия <> ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийАдаптацииУвольнения.Адаптация)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоМероприятиеУвольнения
	|ИЗ
	|	ВТМероприятия КАК СоставМероприятий
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МероприятияАдаптацииУвольнения.События КАК СобытияМероприятий
	|		ПО СоставМероприятий.Мероприятие = СобытияМероприятий.Ссылка
	|ИТОГИ
	|	СУММА(КолВоСобытий),
	|	МАКСИМУМ(ЭтоМероприятиеАдаптации),
	|	МАКСИМУМ(ЭтоМероприятиеУвольнения)
	|ПО
	|	Мероприятие";
	
	Результат = Запрос.Выполнить();
	ВыборкаМероприятий = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаМероприятий.Следующий() Цикл
		
		СписокВидовСобытий = Новый СписокЗначений();
		
		Если ВыборкаМероприятий.КолВоСобытий > 0 Тогда
			
			ВыборкаВидовСобытий = ВыборкаМероприятий.Выбрать();
			Пока ВыборкаВидовСобытий.Следующий() Цикл
				СписокВидовСобытий.Добавить(ВыборкаВидовСобытий.ВидСобытия);
			КонецЦикла;
			
		КонецЕсли;
		
		ТекстПредставления = АдаптацияУвольнениеКлиентСервер.ТекстПредставленияСпискаВидовСобытий(СписокВидовСобытий);
		
		НоваяСтрока = ТаблицаМероприятий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаМероприятий);
		НоваяСтрока.События = СписокВидовСобытий;
		НоваяСтрока.ПредставлениеСобытий = ТекстПредставления;
		
	КонецЦикла;
	
	Возврат ТаблицаМероприятий;
	
КонецФункции

Функция ДанныеМероприятия(Мероприятие) Экспорт
	
	ДанныеМероприятия = Новый Структура;
	СписокВидовСобытий = Новый СписокЗначений;
	
	ЭтоМероприятиеАдаптации = Ложь;
	ЭтоМероприятиеУвольнения = Ложь;
	
	Если ЗначениеЗаполнено(Мероприятие) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Мероприятие", Мероприятие);
		
		Запрос.Текст = "ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА СобытияМероприятий.ВидСобытия ЕСТЬ NULL 
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыСобытийАдаптацииУвольнения.ПустаяСсылка)
		|		ИНАЧЕ СобытияМероприятий.ВидСобытия
		|	КОНЕЦ КАК ВидСобытия,
		|	ВЫБОР
		|		КОГДА Мероприятие.ВидМероприятия <> ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийАдаптацииУвольнения.Увольнение)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоМероприятиеАдаптации,
		|	ВЫБОР
		|		КОГДА Мероприятие.ВидМероприятия <> ЗНАЧЕНИЕ(Перечисление.ВидыМероприятийАдаптацииУвольнения.Адаптация)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоМероприятиеУвольнения
		|ИЗ
		|	Справочник.МероприятияАдаптацииУвольнения КАК Мероприятие
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.МероприятияАдаптацииУвольнения.События КАК СобытияМероприятий
		|		ПО Мероприятие.Ссылка = СобытияМероприятий.Ссылка
		|ГДЕ
		|	Мероприятие.Ссылка = &Мероприятие";
		
		Результат = Запрос.Выполнить();
		ВыборкаСобытий = Результат.Выбрать();
		
		ПерваяИтерация = Истина;
		
		Пока ВыборкаСобытий.Следующий() Цикл
			
			Если ПерваяИтерация Тогда
				
				ЭтоМероприятиеАдаптации = ВыборкаСобытий.ЭтоМероприятиеАдаптации;
				ЭтоМероприятиеУвольнения = ВыборкаСобытий.ЭтоМероприятиеУвольнения;
				
				ПерваяИтерация = Ложь;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаСобытий.ВидСобытия) Тогда
				СписокВидовСобытий.Добавить(ВыборкаСобытий.ВидСобытия);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ДанныеМероприятия.Вставить("ЭтоМероприятиеАдаптации", ЭтоМероприятиеАдаптации);
	ДанныеМероприятия.Вставить("ЭтоМероприятиеУвольнения", ЭтоМероприятиеУвольнения);
	ДанныеМероприятия.Вставить("ПредставлениеСобытий", АдаптацияУвольнениеКлиентСервер.ТекстПредставленияСпискаВидовСобытий(СписокВидовСобытий));
	ДанныеМероприятия.Вставить("События", СписокВидовСобытий);
	
	Возврат ДанныеМероприятия;
	
КонецФункции

Процедура УстановитьДоступностьТаблиц(Форма)
	
	Элементы = Форма.Элементы;
	
	ИзменениеРазрешено = ПравоДоступа("Изменение", Метаданные.Справочники.МероприятияАдаптацииУвольнения);
	
	Форма.Элементы.МероприятияАдаптации.Доступность = ИзменениеРазрешено И Не Форма.ТолькоПросмотр;
	Форма.Элементы.МероприятияУвольнения.Доступность = ИзменениеРазрешено И Не Форма.ТолькоПросмотр;
	
КонецПроцедуры

Процедура ЗапуститьОбновлениеЗаданийАдаптацииУвольнения(УникальныйИдентификаторФормы, ДокументОснование)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = СтрШаблон(НСтр("ru = 'Обновление заданий адаптации и увольнения по документу %1'"), ДокументОснование);
	
	ДлительныеОперации.ВыполнитьВФоне(
		"АдаптацияУвольнение.ОбновлениеЗаданийАдаптацииУвольнения",
		Новый Структура("ДокументОснование", ДокументОснование),
		ПараметрыВыполнения);
	
КонецПроцедуры

Процедура ТаблицаМероприятийВДанные(ОбъектНазначения, ТаблицаМероприятий, МероприятияПрежние, МероприятияТекущие)
	
	МенеджерЗаписи = РегистрыСведений.ОтборыНазначенияМероприятийАдаптацииУвольнения.СоздатьМенеджерЗаписи();
	
	Организация = Справочники.Организации.ПустаяСсылка();
	Если ТипЗнч(ОбъектНазначения) = Тип("СправочникСсылка.Организации") Тогда
		Организация = ОбъектНазначения;
	ИначеЕсли ТипЗнч(ОбъектНазначения) = Тип("СправочникСсылка.ПодразделенияОрганизаций")
		Или ТипЗнч(ОбъектНазначения) = Тип("СправочникСсылка.ШтатноеРасписание") Тогда
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектНазначения, "Владелец");
	КонецЕсли;
	
	Для Каждого СтрокаМероприятия Из ТаблицаМероприятий Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаМероприятия.Мероприятие) Тогда
			Продолжить;
		КонецЕсли;
		
		Если МероприятияТекущие.Найти(СтрокаМероприятия.Мероприятие) = НеОпределено Тогда
			
			МероприятияТекущие.Добавить(СтрокаМероприятия.Мероприятие);
			
			Если МероприятияПрежние.Найти(СтрокаМероприятия.Мероприятие) <> НеОпределено Тогда
				Продолжить;
			КонецЕсли;
			
			МенеджерЗаписи.ОбъектНазначения = ОбъектНазначения;
			МенеджерЗаписи.Мероприятие = СтрокаМероприятия.Мероприятие;
			МенеджерЗаписи.Прочитать();
			
			Если Не МенеджерЗаписи.Выбран() Тогда
				
				МенеджерЗаписи.ОбъектНазначения = ОбъектНазначения;
				МенеджерЗаписи.Мероприятие = СтрокаМероприятия.Мероприятие;
				МенеджерЗаписи.Организация = Организация;
				МенеджерЗаписи.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Функция ЭлементыПодсистемыНаФорме(Форма)
	
	Возврат Форма.Элементы.Найти("МероприятияАдаптацииГруппа") <> НеОпределено;
	
КонецФункции

#КонецОбласти
