
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияХарактеристикПерсонала");
		
		ПриПолученииДанныхНаСервере();
	КонецЕсли;
		
	ОбновитьСоставЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Значения.Количество() < 2 И Не ПараметрыЗаписи.Свойство("СПустымСпискомЗначений") Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		ТекстВопроса = НСтр("ru = 'Характеристика имеет менее двух значений.
			|Необходимо настроить значения характеристики для использования при анкетировании.
			|Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПриПолученииДанныхНаСервере();
	
	ОбновитьСоставЭлементовФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьЗначенияХарактеристикПерсонала(ТекущийОбъект);
	
	ЗаписатьВопросыОценкиХарактеристик();
			
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Для Каждого ТекущееЗначение Из ИзмененныеЗначения Цикл
		ОтобразитьИзменениеДанных(ТекущееЗначение.Значение, ВидИзмененияДанных.Изменение);
	КонецЦикла;
	ИзмененныеЗначения.Очистить();
	
	Оповестить("ЗаписьХарактеристикиПерсонала",,Объект.Ссылка);
	
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьПомеченныеНаУдаление(Команда)
	
	Элементы.ФормаПоказыватьПомеченныеНаУдаление.Пометка = Не Элементы.ФормаПоказыватьПомеченныеНаУдаление.Пометка;
	Если Элементы.ФормаПоказыватьПомеченныеНаУдаление.Пометка Тогда
		Элементы.Значения.ОтборСтрок = Новый ФиксированнаяСтруктура;
	Иначе
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("ПометкаУдаления", Ложь);
		Элементы.Значения.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначения

&НаКлиенте
Процедура ЗначенияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Значения.ТекущиеДанные;
	ТекущиеДанные.ПометкаУдаления = Ложь;
	ТекущиеДанные.ИндексКартинки = ИндексКартинкиЭлемента();
	
	Если Копирование Тогда
		ТекущиеДанные.Ссылка = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Значения.ТекущиеДанные;
	ТекущиеДанные.ПометкаУдаления = НЕ ТекущиеДанные.ПометкаУдаления;	
	ТекущиеДанные.ИндексКартинки = ?(ТекущиеДанные.ПометкаУдаления, ИндексКартинкиЭлементаПометкаУдаления(), ИндексКартинкиЭлемента());
	
КонецПроцедуры

&НаКлиенте
Процедура ВидХарактеристикиПриИзменении(Элемент)
	УстановитьСвойстваЭлементовПоведенческихИндикаторов(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВопросы

&НаКлиенте
Процедура ВопросыВопросНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Вопросы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ХарактеристикаПерсонала", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.МероприятияОценкиПерсонала.Форма.СписокВопросовДляАнкетирования", ПараметрыФормы, Элементы.Вопросы); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросыВопросОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Вопросы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Вопрос);
	ПараметрыФормы.Вставить("ХарактеристикаПерсонала", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.МероприятияОценкиПерсонала.Форма.НастройкаВопросовДляАнкетирования", ПараметрыФормы, ЭтаФорма); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Вопросы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Вопрос = ВыбранноеЗначение;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()

	ДоступныВопросы = ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ВопросыОценкиХарактеристикПерсонала);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокМероприятий, "Характеристика", Объект.Ссылка, Истина);
	
	ЗаполнитьЗначенияХарактеристик();
	ЗаполнитьСписокВопросов();
	
	УстановитьСвойстваЭлементовФормы();

КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()

	УстановитьСвойстваЭлементовПоведенческихИндикаторов(ЭтаФорма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовПоведенческихИндикаторов(Форма)

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ВопросыГруппа",
		"Доступность",
		(НЕ Форма.Объект.Ссылка.Пустая()) И (Форма.Объект.ВидХарактеристики = ПредопределенноеЗначение("Перечисление.ВидыХарактеристикПерсонала.ЛичноеКачество")));
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ВопросыДоступностьПоведенческихИндикаторовГруппа",
		"Видимость",
		Форма.Объект.ВидХарактеристики <> ПредопределенноеЗначение("Перечисление.ВидыХарактеристикПерсонала.ЛичноеКачество"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияХарактеристик()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияХарактеристикПерсонала.Ссылка,
		|	ЗначенияХарактеристикПерсонала.Наименование,
		|	ЗначенияХарактеристикПерсонала.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
		|	ЗначенияХарактеристикПерсонала.ПометкаУдаления,
		|	ВЫБОР
		|		КОГДА ЗначенияХарактеристикПерсонала.ПометкаУдаления
		|			ТОГДА &ИндексКартинкиЭлементаПометкаУдаления
		|		ИНАЧЕ &ИндексКартинкиЭлемента
		|	КОНЕЦ КАК ИндексКартинки
		|ИЗ
		|	Справочник.ЗначенияХарактеристикПерсонала КАК ЗначенияХарактеристикПерсонала
		|ГДЕ
		|	ЗначенияХарактеристикПерсонала.Владелец = &Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеквизитДопУпорядочивания";
	
	Запрос.УстановитьПараметр("Владелец", Объект.Ссылка);
	Запрос.УстановитьПараметр("ИндексКартинкиЭлемента", ИндексКартинкиЭлемента());
	Запрос.УстановитьПараметр("ИндексКартинкиЭлементаПометкаУдаления", ИндексКартинкиЭлементаПометкаУдаления());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Значения.Очистить();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаЗначения = Значения.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЗначения, Выборка);
		
	КонецЦикла;
	
	Если Элементы.ФормаПоказыватьПомеченныеНаУдаление.Пометка Тогда
		Элементы.Значения.ОтборСтрок = Новый ФиксированнаяСтруктура;
	Иначе
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("ПометкаУдаления", Ложь);
		Элементы.Значения.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВопросов()

	Если Не ДоступныВопросы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли; 
	
	Вопросы.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВопросыОценкиХарактеристикПерсонала.Вопрос КАК Вопрос
		|ИЗ
		|	РегистрСведений.ВопросыОценкиХарактеристикПерсонала КАК ВопросыОценкиХарактеристикПерсонала
		|ГДЕ
		|	ВопросыОценкиХарактеристикПерсонала.ХарактеристикаПерсонала = &ХарактеристикаПерсонала";
	
	Запрос.УстановитьПараметр("ХарактеристикаПерсонала", Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Вопросы.Добавить(), ВыборкаДетальныеЗаписи);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьЗначенияХарактеристикПерсонала(ТекущийОбъект)

	ТаблицаЗначений = Значения.Выгрузить();
	ТаблицаЗначений.Колонки.Добавить("НомерСтроки", Метаданные.Справочники.ЗначенияХарактеристикПерсонала.Реквизиты.РеквизитДопУпорядочивания.Тип);
	
	НомерСтроки = 0;
	
	Для Каждого СтрокаТаблицыЗначений Из ТаблицаЗначений Цикл
		
		НомерСтроки = НомерСтроки + 1;
		
		СтрокаТаблицыЗначений.НомерСтроки = НомерСтроки;
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НовыеЗначения.Наименование,
		|	НовыеЗначения.Ссылка,
		|	НовыеЗначения.НомерСтроки,
		|	НовыеЗначения.ПометкаУдаления
		|ПОМЕСТИТЬ ВТНовыеЗначения
		|ИЗ
		|	&НовыеЗначения КАК НовыеЗначения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НовыеЗначения.Наименование,
		|	НовыеЗначения.НомерСтроки КАК НомерСтроки,
		|	НовыеЗначения.ПометкаУдаления,
		|	ЗначенияХарактеристикПерсонала.Ссылка КАК Ссылка
		|ИЗ
		|	ВТНовыеЗначения КАК НовыеЗначения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗначенияХарактеристикПерсонала КАК ЗначенияХарактеристикПерсонала
		|		ПО НовыеЗначения.Ссылка = ЗначенияХарактеристикПерсонала.Ссылка
		|ГДЕ
		|	(НовыеЗначения.Наименование <> ЗначенияХарактеристикПерсонала.Наименование
		|			ИЛИ НовыеЗначения.НомерСтроки <> ЗначенияХарактеристикПерсонала.РеквизитДопУпорядочивания
		|			ИЛИ НовыеЗначения.ПометкаУдаления <> ЗначенияХарактеристикПерсонала.ПометкаУдаления
		|			ИЛИ ЗначенияХарактеристикПерсонала.Ссылка ЕСТЬ NULL)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("НовыеЗначения", ТаблицаЗначений);	
	Запрос.УстановитьПараметр("Владелец", ТекущийОбъект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			ОбъектЗначенияХарактеристики = Справочники.ЗначенияХарактеристикПерсонала.СоздатьЭлемент();
			ОбъектЗначенияХарактеристики.Владелец = ТекущийОбъект.Ссылка;
		Иначе
			ОбъектЗначенияХарактеристики = Выборка.Ссылка.ПолучитьОбъект();
		КонецЕсли;
		
		ОбъектЗначенияХарактеристики.Наименование = Выборка.Наименование;
		ОбъектЗначенияХарактеристики.РеквизитДопУпорядочивания = Выборка.НомерСтроки;
		ОбъектЗначенияХарактеристики.ПометкаУдаления = Выборка.ПометкаУдаления;
		ОбъектЗначенияХарактеристики.Записать();
		
		СтрокаЗначения = Значения[Выборка.НомерСтроки-1];
		СтрокаЗначения.Ссылка = ОбъектЗначенияХарактеристики.Ссылка;
		
		ИзмененныеЗначения.Добавить(ОбъектЗначенияХарактеристики.Ссылка);
				
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВопросыОценкиХарактеристик()

	Если Не ДоступныВопросы Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписейВопросыОценкиХарактеристик = РегистрыСведений.ВопросыОценкиХарактеристикПерсонала.СоздатьНаборЗаписей();
	
	НаборЗаписейВопросыОценкиХарактеристик.Отбор.ХарактеристикаПерсонала.Установить(Объект.Ссылка);
	Для каждого Вопрос Из Вопросы Цикл
		НоваяЗаписьНабора = НаборЗаписейВопросыОценкиХарактеристик.Добавить();
		НоваяЗаписьНабора.ХарактеристикаПерсонала = Объект.Ссылка;
		ЗаполнитьЗначенияСвойств(НоваяЗаписьНабора, Вопрос);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписейВопросыОценкиХарактеристик.Записать(Истина);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСоставЭлементовФормы(ТекстПредупреждения = "")
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияХарактеристикПерсонала")) Тогда
		Элементы.ГруппаЗначения.Видимость = Истина;
	Иначе
		Элементы.ГруппаЗначения.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИндексКартинкиЭлемента()
	Возврат 3;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИндексКартинкиЭлементаПометкаУдаления()
	Возврат 4;
КонецФункции

&НаКлиенте
Процедура ПередЗаписьюЗавершение(Ответ, ПараметрыЗаписи) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПараметрыЗаписи.Вставить("СПустымСпискомЗначений");
		Записать(ПараметрыЗаписи);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
