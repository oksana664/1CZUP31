
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		ЗначенияДляЗаполнения = Новый Структура(
			"Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Объект.МесяцИзменения = НачалоМесяца(ТекущаяДатаСеанса());
		
		ПриПолученииДанныхНаСервере();
		
		Если ЗначениеЗаполнено(НастройкаСпособРасчетаАванса) Тогда
			Объект.СпособРасчетаАванса = НастройкаСпособРасчетаАванса;
		КонецЕсли;
		
		УстановитьОтображениеРазмераАванса();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "АвансыСотрудниковСотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	ОбновитьПрежнееЗначениеВсехСотрудников();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Сообщения = ПолучитьСообщенияПользователю(Ложь);
		
		Для Каждого Сообщение Из Сообщения Цикл
			Если СтрНайти(Сообщение.Поле, "МесяцИзменения") Тогда
				Сообщение.Поле = "";
				Сообщение.ПутьКДанным = "МесяцИзмененияСтрокой";
			КонецЕсли;
			Если СтрНайти(Сообщение.Поле, "ПериодОкончания") Тогда
				Сообщение.Поле = "";
				Сообщение.ПутьКДанным = "МесяцОкончанияСтрокой";
			КонецЕсли;
		КонецЦикла;
		Отказ = Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ЭтаФорма.НастройкаСпособРасчетаАванса = Объект.СпособРасчетаАванса;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	СохранитьНастройки();
	
	ПрочитатьВремяРегистрации();
	ОбновитьПрежнееЗначениеВсехСотрудников();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ИзменениеАванса", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
    ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры 

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
    ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаАвансаПриИзменении(Элемент)
	СпособРасчетаАвансаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

///////////////////////////////////////////////////////
// редактирование месяца изменения строкой.
&НаКлиенте
Процедура МесяцИзмененияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.МесяцИзменения", "МесяцИзмененияСтрокой", Модифицированность);
	МесяцПриИзмененииНаСервере();
    ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцИзмененияНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.МесяцИзменения", "МесяцИзмененияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененияНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	МесяцПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.МесяцИзменения", "МесяцИзмененияСтрокой", Направление, Модифицированность);
	МесяцПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

///////////////////////////////////////////////////////
// редактирование месяца окончания строкой.

&НаКлиенте
Процедура МесяцОкончанияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодОкончания", "МесяцОкончанияСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодОкончания", "МесяцОкончанияСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодОкончания", "МесяцОкончанияСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыАвансыСотрудников

&НаКлиенте
Процедура АвансыСотрудниковПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элементы.АвансыСотрудников.ТекущиеДанные.Аванс = РазмерАванса(ЭтаФорма);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСотрудниковПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСотрудниковПослеУдаления(Элемент)
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура АвансыСотрудниковСотрудникПриИзменении(Элемент)
	
	АвансыСотрудниковСотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура АвансыСотрудниковАвансПриИзменении(Элемент)
	ОбновитьПрежнееЗначениеВыбранномуСотруднику(Элементы.АвансыСотрудников.ТекущиеДанные.Сотрудник);
КонецПроцедуры

&НаКлиенте
Процедура АвансыСотрудниковОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.АвансыСотрудников,
		Объект.Организация, Объект.Подразделение,
		Объект.МесяцИзменения, КонецМесяца(Объект.МесяцИзменения),
		, АдресСпискаПодобранныхСотрудников(), ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазмер(Команда)
	
	РежимРедактирования = Новый Структура;
	РежимРедактирования.Вставить("СпособРасчета", Объект.СпособРасчетаАванса);
	Если Объект.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ПроцентомОтТарифа") Тогда
		РежимРедактирования.Вставить("РазмерАванса", РазмерАвансаВПроцентах);
	Иначе
		РежимРедактирования.Вставить("РазмерАванса", РазмерАвансаВРублях);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("УстановитьРазмерЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ИзменениеАванса.Форма.УстановитьРазмер", РежимРедактирования, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазмерЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		Если Объект.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ПроцентомОтТарифа") Тогда
			ЭтаФорма.РазмерАвансаВПроцентах = Результат;
		ИначеЕсли Объект.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ФиксированнойСуммой") Тогда
			ЭтаФорма.РазмерАвансаВРублях = Результат;
		КонецЕсли;	
		
		ЗаполнитьАвансСотрудниковНаСервере();
		
		ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Заполнить;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ПрочитатьНастройки();
	
	ПрочитатьВремяРегистрации();
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.МесяцИзменения", "МесяцИзмененияСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодОкончания", "МесяцОкончанияСтрокой");
	
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);	
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура МесяцПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	ОбновитьПрежнееЗначениеВсехСотрудников();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура СпособРасчетаАвансаПриИзмененииНаСервере()
	
	ЗаполнитьАвансСотрудниковНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеРазмераАванса()
	
	ВидимостьЭлемента = Ложь;
	ЗаголовокЭлемента = "";
	МаксимальноеЗначение = Неопределено;
	
	Если Объект.СпособРасчетаАванса = Перечисления.СпособыРасчетаАванса.ФиксированнойСуммой Тогда
		ВидимостьЭлемента = Истина;
		ЗаголовокЭлемента = НСтр("ru = 'Аванс (руб.)'");
	ИначеЕсли Объект.СпособРасчетаАванса = Перечисления.СпособыРасчетаАванса.ПроцентомОтТарифа Тогда
		ВидимостьЭлемента = Истина;
		МаксимальноеЗначение = 100;
		ЗаголовокЭлемента = НСтр("ru = 'Аванс (%)'");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		ЭтаФорма.Элементы, "УстановитьРазмер", "Видимость", ВидимостьЭлемента);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		ЭтаФорма.Элементы,	"АвансыСотрудниковАванс", "Видимость", ВидимостьЭлемента);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		ЭтаФорма.Элементы, "АвансыСотрудниковАванс", "Заголовок", ЗаголовокЭлемента);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		ЭтаФорма.Элементы, "АвансыСотрудниковАванс", "МаксимальноеЗначение", МаксимальноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвансСотрудниковНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.УстановитьАванс(РазмерАванса(ЭтаФорма));
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	ОбновитьПрежнееЗначениеВсехСотрудников();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьСотрудников(РазмерАванса(ЭтаФорма));
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	ПрочитатьВремяРегистрации();
	ОбновитьПрежнееЗначениеВсехСотрудников();
	
	УстановитьОтображениеНадписей();
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РазмерАванса(Форма)
	
	Объект = Форма.Объект;
	
	Если Объект.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ПроцентомОтТарифа") Тогда
		Возврат Форма.РазмерАвансаВПроцентах;
	ИначеЕсли Объект.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ФиксированнойСуммой") Тогда
		Возврат Форма.РазмерАвансаВРублях;
	Иначе
		Возврат 0;
	КонецЕсли;	
	
КонецФункции

&НаСервере
Процедура АвансыСотрудниковСотрудникПриИзмененииНаСервере()
	
	ИдентификаторСтроки = Элементы.АвансыСотрудников.ТекущаяСтрока;
	СтрокаСотрудника = Объект.АвансыСотрудников.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	СтрокаСотрудника.ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Объект.Ссылка, СтрокаСотрудника.Сотрудник, Объект.МесяцИзменения);
	
	ОбновитьПрежнееЗначениеВыбранномуСотруднику(СтрокаСотрудника.Сотрудник);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПрежнееЗначениеВыбранномуСотруднику(Сотрудник)
	
	ОбновитьПрежнееЗначениеСпискуСотрудников(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПрежнееЗначениеВсехСотрудников()
	
	// "Прореживание" таблицы сотрудников.
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Объект.Организация;
	ПараметрыПолученияСотрудников.Подразделение = Объект.Подразделение;
	ПараметрыПолученияСотрудников.НачалоПериода = Объект.МесяцИзменения;
	ПараметрыПолученияСотрудников.ОкончаниеПериода = Объект.МесяцИзменения;
	
	НовыеСотрудники = КадровыйУчет.СотрудникиОрганизации(Истина, ПараметрыПолученияСотрудников);
	СотрудникиДляУдаления = Новый Массив;
	
	Для Каждого СтрокаСотрудника Из Объект.АвансыСотрудников Цикл
		
		Если НовыеСотрудники.Найти(СтрокаСотрудника.Сотрудник) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СотрудникиДляУдаления.Добавить(СтрокаСотрудника);
		
	КонецЦикла;
	
	Для Каждого СтрокаСотрудника Из СотрудникиДляУдаления Цикл
		Объект.АвансыСотрудников.Удалить(СтрокаСотрудника);
	КонецЦикла;
	
	ТаблицаСотрудников = Объект.АвансыСотрудников.Выгрузить( , "Сотрудник");
	ОбновитьПрежнееЗначениеСпискуСотрудников(ТаблицаСотрудников.ВыгрузитьКолонку("Сотрудник"));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПрежнееЗначениеСпискуСотрудников(Сотрудники)
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Для Каждого СтрокаСотрудника Из Объект.АвансыСотрудников Цикл
		
		Если Сотрудники.Найти(СтрокаСотрудника.Сотрудник) = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы = ТаблицаСотрудников.Добавить();
		СтрокаТаблицы.Сотрудник = СтрокаСотрудника.Сотрудник;
		СтрокаТаблицы.Период = СтрокаСотрудника.ВремяРегистрации;
		
	КонецЦикла;
	
	ДанныеОбАвансе = РасчетЗарплатыРасширенный.АвансыСотрудников(ТаблицаСотрудников, Объект.Ссылка);
	
	Для Каждого ТекущаяСтрока Из Объект.АвансыСотрудников Цикл
		
		Если ТаблицаСотрудников.Найти(ТекущаяСтрока.Сотрудник, "Сотрудник") = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущиеДанныеОбАвансе = ДанныеОбАвансе.Найти(ТекущаяСтрока.Сотрудник, "Сотрудник");
		
		Если ТекущиеДанныеОбАвансе = Неопределено Тогда
			ТекущаяСтрока.ПрежнееЗначение = "";
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока.ПрежнееЗначение = РасчетЗарплатыКлиентСервер.КомментарийИзмененияАванса(
		ТекущиеДанныеОбАвансе.СпособРасчетаАванса, ТекущиеДанныеОбАвансе.Аванс, Истина, Истина);
		
	КонецЦикла;
	
	УстановитьОтображениеРазмераАванса();
	
КонецПроцедуры 

&НаСервере
Процедура ОбработкаПодбораНаСервере(Знач Сотрудники)
	
	НовыеСотрудники = Новый Массив;
	
	Если ТипЗнч(Сотрудники) <> Тип("Массив") Тогда
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
	КонецЕсли;
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	Для Каждого Сотрудник Из Сотрудники Цикл
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = Объект.МесяцИзменения;
		НоваяСтрока.Сотрудник = Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Объект.Ссылка, СотрудникиДаты);
	
	Для Каждого Сотрудник Из Сотрудники Цикл
		
		СтрокиНачислений = Объект.АвансыСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		
		Если СтрокиНачислений.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаАвансыСотрудников = Объект.АвансыСотрудников.Добавить();
		СтрокаАвансыСотрудников.Сотрудник = Сотрудник;
		СтрокаАвансыСотрудников.Аванс = РазмерАванса(ЭтаФорма);
		СтрокаАвансыСотрудников.ВремяРегистрации = ВремяРегистрацииДокумента.Получить(Объект.МесяцИзменения).Получить(Сотрудник);
		
		НовыеСотрудники.Добавить(Сотрудник);
		
	КонецЦикла;
	
	ОбновитьПрежнееЗначениеСпискуСотрудников(НовыеСотрудники);
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.АвансыСотрудников.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("ДатаСобытия", Новый ОписаниеТипов("Дата"));
	
	Для Каждого СтрокаСотрудника Из Объект.АвансыСотрудников Цикл
		НоваяСтрока = СотрудникиДаты.Добавить();
		НоваяСтрока.ДатаСобытия = Объект.МесяцИзменения;
		НоваяСтрока.Сотрудник = СтрокаСотрудника.Сотрудник;
	КонецЦикла;
	
	ВремяРегистрацииДокумента = ЗарплатаКадрыРасширенный.ЗначенияВремениРегистрацииДокумента(Объект.Ссылка, СотрудникиДаты);
	ВремяРегистрацииСотрудников = ВремяРегистрацииДокумента.Получить(Объект.МесяцИзменения);
	
	Для Каждого СтрокаСотрудника Из Объект.АвансыСотрудников Цикл
		СтрокаСотрудника.ВремяРегистрации = ВремяРегистрацииСотрудников.Получить(СтрокаСотрудника.Сотрудник);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	УстановитьПривилегированныйРежим(Истина);
	СотрудникиДаты = Объект.АвансыСотрудников.Выгрузить(, "Сотрудник, ВремяРегистрации");							
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОКонкурирующихДокументахПлановыхНачислений(ЭтотОбъект, СотрудникиДаты, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройки()
	
	НастройкаСпособРасчетаАванса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документ.ИзменениеАванса", "НастройкаСпособРасчетаАванса");
	РазмерАвансаВПроцентах = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документ.ИзменениеАванса", "РазмерАвансаВПроцентах");
	РазмерАвансаВРублях = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документ.ИзменениеАванса", "РазмерАвансаВРублях");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Документ.ИзменениеАванса", "НастройкаСпособРасчетаАванса", НастройкаСпособРасчетаАванса);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Документ.ИзменениеАванса", "РазмерАвансаВПроцентах", РазмерАвансаВПроцентах);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Документ.ИзменениеАванса", "РазмерАвансаВРублях", РазмерАвансаВРублях);
	
КонецПроцедуры

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.АвансыСотрудников");
	Массив.Добавить("Объект.ФизическиеЛица");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Подразделение",	Нстр("ru = 'подразделения'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "МесяцИзменения",Нстр("ru = 'месяца изменения аванса'")));
	Возврат Массив
КонецФункции

#КонецОбласти
