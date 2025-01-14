#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияДляЗаполнения = Новый Структура;
	ЗначенияДляЗаполнения.Вставить("Организация",	"Объект.Организация");
	ЗначенияДляЗаполнения.Вставить("Подразделение",	"Объект.Подразделение");
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
	
	УстановитьДоступностьЭлементов(Элементы, УсловияСтрахованияСотрудников);
	
	СтандартнаяОбработка = Истина;
	ЗарплатаКадрыПереопределяемый.ЗаполнитьРеквизитОрганизацияПриОднофирменномУчете(ЭтотОбъект, СтандартнаяОбработка, "Организация");
	
	Если СтандартнаяОбработка Тогда 
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыБазовая") 
			И Не ЗначениеЗаполнено(Объект.Организация) Тогда 
			Объект.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПрикреплениеКПрограммамМедицинскогоСтрахования" Тогда
		ПрикреплениеКПрограммамСтрахованияЗаполнить();
	ИначеЕсли ИмяСобытия = "Запись_ОткреплениеОтПрограммМедицинскогоСтрахования" Тогда
		ОткреплениеОтПрограммСтрахованияЗаполнить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СтраховаяКомпанияПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСотрудниковНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", ГруппаСотрудников);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("УсловияСтрахованияСотрудниковЗакрытие", ЭтотОбъект);
	ОткрытьФорму("Справочник.ГруппыСотрудников.ФормаСписка", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСотрудниковПриИзменении(Элемент)
	ПриИзмененииОсновныхПолейНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УсловияСтрахованияСотрудниковПриИзменении(Элемент)
	
	Если УсловияСтрахованияСотрудников = 0 Тогда
		ГруппаСотрудников = Неопределено;
		ПриИзмененииОсновныхПолейНаСервере();
	КонецЕсли;
	
	УстановитьДоступностьЭлементов(Элементы, УсловияСтрахованияСотрудников);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыПрикреплениеСотрудников

&НаКлиенте
Процедура ПрикреплениеСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "ПрикреплениеСотрудниковКоманда" Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ТекущиеДанные.Команда = "Отложить" Тогда
			ТекущиеДанные.ПрикреплениеКПрограммеСтрахованияОтложено = Истина;
			ОтложитьСотрудника(ТекущиеДанные.Сотрудник);
			ТекущиеДанные.Команда = НСтр("ru = 'Возобновить'");
		Иначе
			ТекущиеДанные.ПрикреплениеКПрограммеСтрахованияОтложено = Ложь;
			ВозобновитьСотрудника(ТекущиеДанные.Сотрудник);
			ТекущиеДанные.Команда = НСтр("ru = 'Отложить'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыОткреплениеСотрудников

&НаКлиенте
Процедура ОткреплениеСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "ОткреплениеСотрудниковКоманда" Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если ТекущиеДанные.Команда = "Отложить" Тогда
			ТекущиеДанные.ОткреплениеОтПрограммыСтрахованияОтложено = Истина;
			ОтложитьСотрудника(ТекущиеДанные.Сотрудник);
			ТекущиеДанные.Команда = НСтр("ru = 'Возобновить'");
		Иначе
			ТекущиеДанные.ОткреплениеОтПрограммыСтрахованияОтложено = Ложь;
			ВозобновитьСотрудника(ТекущиеДанные.Сотрудник);
			ТекущиеДанные.Команда = НСтр("ru = 'Отложить'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрикреплениеСотрудниковПоказыватьОтложенныхСтрахователей(Команда)
	
	Элементы.ПрикреплениеСотрудниковПоказыватьОтложенныхСтрахователей.Пометка = Не Элементы.ПрикреплениеСотрудниковПоказыватьОтложенныхСтрахователей.Пометка;
	ПоказыватьОтложенныхСтрахователей = Элементы.ПрикреплениеСотрудниковПоказыватьОтложенныхСтрахователей.Пометка;
	УстановитьОтборСтрок(Элементы, "ПрикреплениеСотрудников", "ПрикреплениеКПрограммеСтрахованияОтложено", ПоказыватьОтложенныхСтрахователей);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикреплениеСотрудниковОбновить(Команда)
	ПрикреплениеКПрограммамСтрахованияЗаполнить();
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоУмолчанию(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ОрганизацияСсылка", Объект.Организация);
	ПараметрыОткрытия.Вставить("СтраховаяКомпания", Объект.СтраховаяКомпания);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("НастройкиПоУмолчаниюЗакрытие", ЭтотОбъект);
	ОткрытьФорму(МедицинскоеСтрахованиеКлиент.ИмяФормыНастройкиМедицинскогоСтрахования(),
		ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикреплениеСформировать(Команда)
	
	Отказ = ПроверитьНаКлиенте();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивСотрудников = Новый Массив;
	
	ПараметрыОтбораСтрок = Новый Структура;
	ПараметрыОтбораСтрок.Вставить("ПрикреплениеКПрограммеСтрахованияОтложено", Ложь);
	НайденныеСтроки = Объект.ПрикреплениеСотрудников.НайтиСтроки(ПараметрыОтбораСтрок);
	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		МассивСотрудников.Добавить(НайденнаяСтрока.Сотрудник);
	КонецЦикла;
	
	ОткрытьПрикреплениеСотрудников(, МассивСотрудников);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткреплениеСформировать(Команда)
	
	Отказ = ПроверитьНаКлиенте();
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивСотрудников = Новый Массив;
	
	ПараметрыОтбораСтрок = Новый Структура;
	ПараметрыОтбораСтрок.Вставить("ОткреплениеОтПрограммыСтрахованияОтложено", Ложь);
	НайденныеСтроки = Объект.ОткреплениеСотрудников.НайтиСтроки(ПараметрыОтбораСтрок);
	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		МассивСотрудников.Добавить(НайденнаяСтрока.Сотрудник);
	КонецЦикла;
	
	ОткрытьОткреплениеСотрудников(, МассивСотрудников);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСтрокуПрикрепления(Команда)
	
	ТекущиеДанные = Элементы.ПрикреплениеСотрудников.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьПрикреплениеСотрудников(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткреплениеСотрудниковОбновить(Команда)
	ОткреплениеОтПрограммСтрахованияЗаполнить();
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСтрокуОткрепления(Команда)
	
	ТекущиеДанные = Элементы.ОткреплениеСотрудников.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьОткреплениеСотрудников(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткреплениеСотрудниковПоказыватьОтложенныхСтрахователей(Команда)
	
	Элементы.ОткреплениеСотрудниковПоказыватьОтложенныхСтрахователей.Пометка = Не Элементы.ОткреплениеСотрудниковПоказыватьОтложенныхСтрахователей.Пометка;
	ПоказыватьОтложенныхСтрахователей = Элементы.ОткреплениеСотрудниковПоказыватьОтложенныхСтрахователей.Пометка;
	УстановитьОтборСтрок(Элементы, "ОткреплениеСотрудников", "ОткреплениеОтПрограммыСтрахованияОтложено", ПоказыватьОтложенныхСтрахователей);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтложитьСотрудника(Сотрудник)
	
	НаборЗаписей = РегистрыСведений.ОтложенноеМедицинскоеСтрахованиеСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Объект.Организация);
	НаборЗаписей.Отбор.СтраховаяКомпания.Установить(Объект.СтраховаяКомпания);
	НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Организация = Объект.Организация;
	НоваяЗапись.СтраховаяКомпания = Объект.СтраховаяКомпания;
	НоваяЗапись.Сотрудник = Сотрудник;
	НоваяЗапись.ФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
	
	НаборЗаписей.Записать();
	
	УстановитьТекстЗаголовкаПрикрепление();
	
КонецПроцедуры

&НаСервере
Процедура ВозобновитьСотрудника(Сотрудник)
	
	НаборЗаписей = РегистрыСведений.ОтложенноеМедицинскоеСтрахованиеСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Объект.Организация);
	НаборЗаписей.Отбор.СтраховаяКомпания.Установить(Объект.СтраховаяКомпания);
	НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
	
	НаборЗаписей.Записать();
	
	УстановитьТекстЗаголовкаПрикрепление();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОсновныхПолейНаСервере()
	
	МедицинскоеСтрахованиеФормы.ПрикреплениеПрочитатьНастройки(ЭтотОбъект);
	
	ПрикреплениеКПрограммамСтрахованияЗаполнить();
	УстановитьОтборСтрок(Элементы, "ПрикреплениеСотрудников", "ПрикреплениеКПрограммеСтрахованияОтложено", ПоказыватьОтложенныхСтрахователей);
	
	ОткреплениеОтПрограммСтрахованияЗаполнить();
	УстановитьОтборСтрок(Элементы, "ОткреплениеСотрудников", "ОткреплениеОтПрограммыСтрахованияОтложено", ПоказыватьОтложенныхСтрахователей);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(МедицинскоеСтрахование, "Организация", Объект.Организация,,, ЗначениеЗаполнено(Объект.Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(МедицинскоеСтрахование, "Подразделение", Объект.Подразделение,,, ЗначениеЗаполнено(Объект.Подразделение));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(МедицинскоеСтрахование, "СтраховаяКомпания", Объект.СтраховаяКомпания,,, ЗначениеЗаполнено(Объект.СтраховаяКомпания));
	
КонецПроцедуры

&НаСервере
Процедура ПрикреплениеКПрограммамСтрахованияЗаполнить(Сотрудники = Неопределено)
	
	СтруктураИменТаблиц = МедицинскоеСтрахованиеФормы.СтруктураИменТаблиц();
	СтруктураИменТаблиц.ИмяТаблицыСотрудники = "ПрикреплениеСотрудников";
	
	МедицинскоеСтрахованиеФормы.ПрикреплениеКПрограммамСтрахованияЗаполнить(ЭтотОбъект, СтруктураИменТаблиц, Сотрудники, Ложь, Ложь);
	
	УстановитьТекстЗаголовкаПрикрепление();
	
КонецПроцедуры

&НаСервере
Процедура ОткреплениеОтПрограммСтрахованияЗаполнить()
	
	Объект.ОткреплениеСотрудников.Очистить();
	
	// Получим сведения по сотрудникам, не прикрепленных к программам страхования
	
	Если Не ЗначениеЗаполнено(Объект.Организация) ИЛИ Не ЗначениеЗаполнено(Объект.СтраховаяКомпания) Тогда
		// Показываем только сводные сведения
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("СтраховаяКомпания", Объект.СтраховаяКомпания);
	Запрос.УстановитьПараметр("ДатаОкончанияСтрахования", Объект.ДатаОкончанияСтрахования);
	Запрос.УстановитьПараметр("ГруппаСотрудников", ГруппаСотрудников);
	Запрос.УстановитьПараметр("ОтборПоГруппеСотрудников", ЗначениеЗаполнено(ГруппаСотрудников));
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.Организация = Объект.Организация;
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ПараметрыПолученияСотрудников.Подразделение = Объект.Подразделение;
	КонецЕсли;
	ПараметрыПолученияСотрудников.НачалоПериода 	= Объект.ДатаНачалаСтрахования;
	ПараметрыПолученияСотрудников.ОкончаниеПериода	= Объект.ДатаОкончанияСтрахования;
	ПараметрыПолученияСотрудников.КадровыеДанные	= "Организация, ДатаУвольнения";
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник
	|ИЗ
	|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации";
	
	МассивСотрудников = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Сотрудник");
	
	Если ОткреплятьСотрудниковВОтпускеПоУходуЗаРебенком Тогда
		
		Состояния = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.СостоянияСотрудника.ОтпускПоУходуЗаРебенком);
		СостоянияСотрудников.СоздатьВТСостоянияСотрудников(
			Запрос.МенеджерВременныхТаблиц, МассивСотрудников, Состояния, Объект.ДатаНачалаСтрахования, Объект.ДатаОкончанияСтрахования);
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 0
		|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
		|	NULL КАК Начало
		|ПОМЕСТИТЬ ВТСостоянияСотрудников";
		Запрос.Выполнить();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГруппаСотрудников) Тогда
		ГруппыСотрудников.СоздатьВТГруппыСотрудников(Запрос.МенеджерВременныхТаблиц, МассивСотрудников);
	Иначе
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	NULL КАК Сотрудник,
		|	NULL КАК ФизическоеЛицо,
		|	NULL КАК Группа
		|ПОМЕСТИТЬ ВТГруппыСотрудников";
		
		Запрос.Выполнить();
		
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МИНИМУМ(Сотрудники.ДатаОткрепления) КАК ДатаОткрепления
	|ПОМЕСТИТЬ ВТОткрепляемыеСотрудники
	|ИЗ
	|	(ВЫБРАТЬ
	|		СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|		СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
	|		СотрудникиОрганизации.ДатаУвольнения КАК ДатаОткрепления
	|	ИЗ
	|		ВТСотрудникиОрганизации КАК СотрудникиОрганизации
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТГруппыСотрудников КАК ГруппыСотрудников
	|			ПО СотрудникиОрганизации.Сотрудник = ГруппыСотрудников.Сотрудник
	|	ГДЕ
	|		СотрудникиОрганизации.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
	|		И (НЕ &ОтборПоГруппеСотрудников
	|				ИЛИ ГруппыСотрудников.Группа = &ГруппаСотрудников)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СостоянияСотрудников.Сотрудник,
	|		СостоянияСотрудников.Сотрудник.ФизическоеЛицо,
	|		СостоянияСотрудников.Начало
	|	ИЗ
	|		ВТСостоянияСотрудников КАК СостоянияСотрудников
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТГруппыСотрудников КАК ГруппыСотрудников
	|			ПО СостоянияСотрудников.Сотрудник = ГруппыСотрудников.Сотрудник
	|	ГДЕ
	|		(НЕ &ОтборПоГруппеСотрудников
	|				ИЛИ ГруппыСотрудников.Группа = &ГруппаСотрудников)) КАК Сотрудники
	|
	|СГРУППИРОВАТЬ ПО
	|	Сотрудники.Сотрудник,
	|	Сотрудники.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиНеПрикрепленные.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ВТОтложенныеСотрудники
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиНеПрикрепленные
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтложенноеМедицинскоеСтрахованиеСотрудников КАК ОтложенноеМедицинскоеСтрахованиеСотрудников
	|		ПО СотрудникиНеПрикрепленные.Сотрудник = ОтложенноеМедицинскоеСтрахованиеСотрудников.Сотрудник
	|			И (ОтложенноеМедицинскоеСтрахованиеСотрудников.Организация = &Организация)
	|			И (ОтложенноеМедицинскоеСтрахованиеСотрудников.СтраховаяКомпания = &СтраховаяКомпания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрограммыМедицинскогоСтрахованияСотрудников.Организация КАК Организация,
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МАКСИМУМ(ПрограммыМедицинскогоСтрахованияСотрудников.Период) КАК Период
	|ПОМЕСТИТЬ ВТМаксимальныеПериодыПрограммСтрахования
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПрограммыМедицинскогоСтрахованияСотрудников КАК ПрограммыМедицинскогоСтрахованияСотрудников
	|		ПО (ПрограммыМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|ГДЕ
	|	ПрограммыМедицинскогоСтрахованияСотрудников.Период <= &ДатаОкончанияСтрахования
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрограммыМедицинскогоСтрахованияСотрудников.Организация,
	|	СотрудникиОрганизации.Сотрудник,
	|	ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация КАК Организация,
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,
	|	МАКСИМУМ(РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период) КАК Период
	|ПОМЕСТИТЬ ВТМаксимальныеПериодыРасширенийСтрахования
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РасширенияПрограммМедицинскогоСтрахованияСотрудников КАК РасширенияПрограммМедицинскогоСтрахованияСотрудников
	|		ПО (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|ГДЕ
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период <= &ДатаОкончанияСтрахования
	|
	|СГРУППИРОВАТЬ ПО
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация,
	|	СотрудникиОрганизации.Сотрудник,
	|	РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
	|	СотрудникиОрганизации.ДатаОткрепления КАК ДатаОткрепления,
	|	СотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА ОтложенныеСотрудники.Сотрудник ЕСТЬ НЕ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОтложенныйСотрудник
	|ИЗ
	|	ВТОткрепляемыеСотрудники КАК СотрудникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПрограммыМедицинскогоСтрахованияСотрудников КАК ПрограммыМедицинскогоСтрахованияСотрудников
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимальныеПериодыПрограммСтрахования КАК МаксимальныеПериодыПрограммСтрахования
	|			ПО ПрограммыМедицинскогоСтрахованияСотрудников.Период = МаксимальныеПериодыПрограммСтрахования.Период
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = МаксимальныеПериодыПрограммСтрахования.ФизическоеЛицо
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.Организация = МаксимальныеПериодыПрограммСтрахования.Организация
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПрограммыМедицинскогоСтрахованияСотрудников КАК ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение
	|			ПО (ПрограммыМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо
	|				И ПрограммыМедицинскогоСтрахованияСотрудников.Период = ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.Период
	|				И (ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.Регистратор ССЫЛКА Документ.ОткреплениеОтПрограммМедицинскогоСтрахования)
	|		ПО (ПрограммыМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|			И СотрудникиОрганизации.ДатаОткрепления > ПрограммыМедицинскогоСтрахованияСотрудников.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасширенияПрограммМедицинскогоСтрахованияСотрудников КАК РасширенияПрограммМедицинскогоСтрахованияСотрудников
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимальныеПериодыРасширенийСтрахования КАК МаксимальныеПериодыРасширенийСтрахования
	|			ПО РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период = МаксимальныеПериодыРасширенийСтрахования.Период
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = МаксимальныеПериодыРасширенийСтрахования.ФизическоеЛицо
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = МаксимальныеПериодыРасширенийСтрахования.Организация
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасширенияПрограммМедицинскогоСтрахованияСотрудников КАК РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение
	|			ПО (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо = РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период = РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.Период
	|				И (РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.Регистратор ССЫЛКА Документ.ОткреплениеОтПрограммМедицинскогоСтрахования)
	|		ПО (РасширенияПрограммМедицинскогоСтрахованияСотрудников.Организация = &Организация)
	|			И СотрудникиОрганизации.ФизическоеЛицо = РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо
	|			И СотрудникиОрганизации.ДатаОткрепления > РасширенияПрограммМедицинскогоСтрахованияСотрудников.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОтложенныеСотрудники КАК ОтложенныеСотрудники
	|		ПО СотрудникиОрганизации.Сотрудник = ОтложенныеСотрудники.Сотрудник
	|ГДЕ
	|	(ПрограммыМедицинскогоСтрахованияСотрудников.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|				И ПрограммыМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо ЕСТЬ NULL
	|			ИЛИ РасширенияПрограммМедицинскогоСтрахованияСотрудников.ФизическоеЛицо ЕСТЬ НЕ NULL 
	|				И РасширенияПрограммМедицинскогоСтрахованияСотрудниковУвольнение.ФизическоеЛицо ЕСТЬ NULL)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СотрудникиОрганизации.Сотрудник";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Сотрудник") Цикл
		НоваяСтрока = Объект.ОткреплениеСотрудников.Добавить();
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;
		НоваяСтрока.ДатаОткрепления = Выборка.ДатаОткрепления;
		НоваяСтрока.ОткреплениеОтПрограммыСтрахованияОтложено = Выборка.ОтложенныйСотрудник;
		НоваяСтрока.Команда = ?(Выборка.ОтложенныйСотрудник, НСтр("ru = 'Возобновить'"), НСтр("ru = 'Отложить'"));
	КонецЦикла;
	
	Объект.ОткреплениеСотрудников.Сортировать("Сотрудник");
	
	УстановитьТекстЗаголовкаОткрепление();
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьНаКлиенте()
	
	Отказ = Ложь;
	Если Не ЗначениеЗаполнено(Объект.ДатаНачалаСтрахования) Или Не ЗначениеЗаполнено(Объект.ДатаОкончанияСтрахования) Тогда
		ТекстОшибки = НСтр("ru = 'Не указан период страхования.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , , , Отказ);
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСтрок(Элементы, ИмяТаблицы, ИмяСвойства, ПоказыватьОтложенныхСтрахователей)
	
	СтруктураОтбора = ?(ПоказыватьОтложенныхСтрахователей, Неопределено, Новый ФиксированнаяСтруктура(ИмяСвойства, Ложь));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, ИмяТаблицы, "ОтборСтрок", СтруктураОтбора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗаголовкаПрикрепление()
	
	ТекстЗаголовка = НСтр("ru = 'Прикрепление к программам'");
	СтруктураОтбора = Новый Структура("ПрикреплениеКПрограммеСтрахованияОтложено", Ложь);
	НайденныеСтроки = Объект.ПрикреплениеСотрудников.НайтиСтроки(СтруктураОтбора);
	КоличествоСотрудников = НайденныеСтроки.Количество();
	Если КоличествоСотрудников > 0 Тогда
		ТекстЗаголовка = ТекстЗаголовка + " (" + КоличествоСотрудников + ")";
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПрикреплениеКПрограммамСтрахования", "Заголовок", ТекстЗаголовка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗаголовкаОткрепление()
	
	ТекстЗаголовка = НСтр("ru = 'Открепление от программ'");
	СтруктураОтбора = Новый Структура("ОткреплениеОтПрограммыСтрахованияОтложено", Ложь);
	НайденныеСтроки = Объект.ОткреплениеСотрудников.НайтиСтроки(СтруктураОтбора);
	КоличествоСотрудников = НайденныеСтроки.Количество();
	Если КоличествоСотрудников > 0 Тогда
		ТекстЗаголовка = ТекстЗаголовка + " (" + КоличествоСотрудников + ")";
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОткрепление", "Заголовок", ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоУмолчаниюЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Отмена Тогда
		ПриИзмененииОсновныхПолейНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрикреплениеСотрудников(ДанныеСтроки = Неопределено, Сотрудники = Неопределено)
	
	// Если ссылка на документ существует, то просто открываем его.
	ПараметрыОткрытия = Новый Структура;
	Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ДокументПрикрепления) Тогда
		ПараметрыОткрытия.Вставить("Ключ", ДанныеСтроки.ДокументПрикрепления);
	Иначе
		// Если документ пока не был создан, пытаемся подобрать подходящий, 
		// если не удалось - создаем новый.
		ДокументПрикрепления = Неопределено;
		Если ДанныеСтроки <> Неопределено Тогда
			ДокументПрикрепления = ДокументПрикрепленияСотрудников(
				Объект.Организация, Объект.СтраховаяКомпания, ДанныеСтроки.Сотрудник, Объект.Подразделение);
		КонецЕсли;
		ПараметрыОткрытия.Вставить("Ключ", ДокументПрикрепления);
		// На случай, если документ будет вновь созданным - передаем значения для заполнения.
		ЗначенияЗаполнения = Новый Структура;
		Если Не ЗначениеЗаполнено(ДокументПрикрепления) Тогда
			ЗначенияЗаполнения.Вставить("Организация", Объект.Организация);
			ЗначенияЗаполнения.Вставить("СтраховаяКомпания", Объект.СтраховаяКомпания);
			ЗначенияЗаполнения.Вставить("Подразделение", Объект.Подразделение);
		КонецЕсли;
		Если Сотрудники = Неопределено Тогда
			Если ДанныеСтроки <> Неопределено Тогда
				ЗначенияЗаполнения.Вставить("Сотрудники", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСтроки.Сотрудник));
			Иначе
				ЗначенияЗаполнения.Вставить("Сотрудники", Новый Массив);
			КонецЕсли;
		Иначе
			ЗначенияЗаполнения.Вставить("Сотрудники", Сотрудники);
		КонецЕсли;
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	ОткрытьФорму("Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокументПрикрепленияСотрудников(Организация, СтраховаяКомпания, Сотрудник, Подразделение)
	
	// Подбираем не проведенный документ для сотрудника (по организации и страховой компании), 
	// исходя из следующего приоритета
	// 1) Документ, в котором уже есть этот сотрудник
	// 2) Документ, в котором нет этого сотрудника, но в котором совпадает подразделение (если подразделение заполнено)
	// 3) Документ, в котором нет этого сотрудника, без учета подразделения и количества сотрудников.
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПрикреплениеКПрограммам.Ссылка КАК Ссылка,
	|	ПрикреплениеКПрограммам.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТПрикреплениеКПрограммам
	|ИЗ
	|	Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования КАК ПрикреплениеКПрограммам
	|ГДЕ
	|	ПрикреплениеКПрограммам.Организация = &Организация
	|	И ПрикреплениеКПрограммам.СтраховаяКомпания = &СтраховаяКомпания
	|	И ПрикреплениеКПрограммам.ПометкаУдаления = ЛОЖЬ
	|	И ПрикреплениеКПрограммам.Проведен = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрикреплениеКПрограммам.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования.Сотрудники КАК СотрудникиДокумента
	|				ГДЕ
	|					СотрудникиДокумента.Ссылка = ПрикреплениеКПрограммам.Ссылка
	|					И СотрудникиДокумента.Сотрудник = &Сотрудник)
	|			ТОГДА 1
	|		КОГДА &ПодразделениеЗаполнено
	|			ТОГДА ВЫБОР
	|					КОГДА ПрикреплениеКПрограммам.Подразделение = &Подразделение
	|						ТОГДА 2
	|					ИНАЧЕ 3
	|				КОНЕЦ
	|		ИНАЧЕ 4
	|	КОНЕЦ КАК Приоритет
	|ПОМЕСТИТЬ ВТПрикреплениеКПрограммамПриоритеты
	|ИЗ
	|	ВТПрикреплениеКПрограммам КАК ПрикреплениеКПрограммам
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ПрикреплениеКПрограммамПриоритеты.Приоритет) КАК Приоритет
	|ПОМЕСТИТЬ ВТМинимальныйПриоритет
	|ИЗ
	|	ВТПрикреплениеКПрограммамПриоритеты КАК ПрикреплениеКПрограммамПриоритеты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ПрикреплениеКПрограммамПриоритеты.Ссылка) КАК Ссылка
	|ИЗ
	|	ВТПрикреплениеКПрограммамПриоритеты КАК ПрикреплениеКПрограммамПриоритеты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМинимальныйПриоритет КАК МинимальныйПриоритет
	|		ПО (МинимальныйПриоритет.Приоритет = ПрикреплениеКПрограммамПриоритеты.Приоритет)
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(ПрикреплениеКПрограммамПриоритеты.Ссылка) ЕСТЬ НЕ NULL ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СтраховаяКомпания", СтраховаяКомпания);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ПодразделениеЗаполнено", ЗначениеЗаполнено(Подразделение));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьОткреплениеСотрудников(ДанныеСтроки = Неопределено, Сотрудники = Неопределено)
	
	// Если ссылка на документ существует, то просто открываем его.
	ПараметрыОткрытия = Новый Структура;
	Если ДанныеСтроки <> Неопределено И ЗначениеЗаполнено(ДанныеСтроки.ДокументОткрепления) Тогда
		ПараметрыОткрытия.Вставить("Ключ", ДанныеСтроки.ДокументОткрепления);
	Иначе
		// Если документ пока не был создан, пытаемся подобрать подходящий, 
		// если не удалось - создаем новый.
		ДокументПрикрепления = Неопределено;
		Если ДанныеСтроки <> Неопределено Тогда
			ДокументОткрепления = ДокументОткрепленияСотрудников(
				Объект.Организация, Объект.СтраховаяКомпания, ДанныеСтроки.Сотрудник, Объект.Подразделение);
		КонецЕсли;
		ПараметрыОткрытия.Вставить("Ключ", ДокументОткрепления);
		// На случай, если документ будет вновь созданным - передаем значения для заполнения.
		ЗначенияЗаполнения = Новый Структура;
		Если Не ЗначениеЗаполнено(ДокументОткрепления) Тогда
			ЗначенияЗаполнения.Вставить("Организация", Объект.Организация);
			ЗначенияЗаполнения.Вставить("СтраховаяКомпания", Объект.СтраховаяКомпания);
			ЗначенияЗаполнения.Вставить("Подразделение", Объект.Подразделение);
		КонецЕсли;
		Если Сотрудники = Неопределено Тогда
			Если ДанныеСтроки <> Неопределено Тогда
				ЗначенияЗаполнения.Вставить("Сотрудники", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеСтроки.Сотрудник));
			Иначе
				ЗначенияЗаполнения.Вставить("Сотрудники", Новый Массив);
			КонецЕсли;
		Иначе
			ЗначенияЗаполнения.Вставить("Сотрудники", Сотрудники);
		КонецЕсли;
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;
	ОткрытьФорму("Документ.ОткреплениеОтПрограммМедицинскогоСтрахования.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокументОткрепленияСотрудников(Организация, СтраховаяКомпания, Сотрудник, Подразделение)
	
	// Подбираем не проведенный документ для сотрудника (по организации и страховой компании), 
	// исходя из следующего приоритета
	// 1) Документ, в котором уже есть этот сотрудник
	// 2) Документ, в котором нет этого сотрудника, но в котором совпадает подразделение (если подразделение заполнено)
	// 3) Документ, в котором нет этого сотрудника, без учета подразделения и количества сотрудников.
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ОткреплениеОтПрограмм.Ссылка КАК Ссылка,
	|	ОткреплениеОтПрограмм.Подразделение КАК Подразделение
	|ПОМЕСТИТЬ ВТОткреплениеОтПрограмм
	|ИЗ
	|	Документ.ОткреплениеОтПрограммМедицинскогоСтрахования КАК ОткреплениеОтПрограмм
	|ГДЕ
	|	ОткреплениеОтПрограмм.Организация = &Организация
	|	И ОткреплениеОтПрограмм.СтраховаяКомпания = &СтраховаяКомпания
	|	И ОткреплениеОтПрограмм.ПометкаУдаления = ЛОЖЬ
	|	И ОткреплениеОтПрограмм.Проведен = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОткреплениеОтПрограмм.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ИСТИНА В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ИСТИНА
	|				ИЗ
	|					Документ.ОткреплениеОтПрограммМедицинскогоСтрахования.Сотрудники КАК СотрудникиДокумента
	|				ГДЕ
	|					СотрудникиДокумента.Ссылка = ОткреплениеОтПрограмм.Ссылка
	|					И СотрудникиДокумента.Сотрудник = &Сотрудник)
	|			ТОГДА 1
	|		КОГДА &ПодразделениеЗаполнено
	|			ТОГДА ВЫБОР
	|					КОГДА ОткреплениеОтПрограмм.Подразделение = &Подразделение
	|						ТОГДА 2
	|					ИНАЧЕ 3
	|				КОНЕЦ
	|		ИНАЧЕ 4
	|	КОНЕЦ КАК Приоритет
	|ПОМЕСТИТЬ ВТОткреплениеОтПрограммПриоритеты
	|ИЗ
	|	ВТОткреплениеОтПрограмм КАК ОткреплениеОтПрограмм
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(ОткреплениеОтПрограммПриоритеты.Приоритет) КАК Приоритет
	|ПОМЕСТИТЬ ВТМинимальныйПриоритет
	|ИЗ
	|	ВТОткреплениеОтПрограммПриоритеты КАК ОткреплениеОтПрограммПриоритеты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ОткреплениеОтПрограммПриоритеты.Ссылка) КАК Ссылка
	|ИЗ
	|	ВТОткреплениеОтПрограммПриоритеты КАК ОткреплениеОтПрограммПриоритеты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМинимальныйПриоритет КАК МинимальныйПриоритет
	|		ПО (МинимальныйПриоритет.Приоритет = ОткреплениеОтПрограммПриоритеты.Приоритет)
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(ОткреплениеОтПрограммПриоритеты.Ссылка) ЕСТЬ НЕ NULL ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СтраховаяКомпания", СтраховаяКомпания);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ПодразделениеЗаполнено", ЗначениеЗаполнено(Подразделение));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

&НаКлиенте
Процедура УсловияСтрахованияСотрудниковЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	ГруппаСотрудников = Результат;
	ПриИзмененииОсновныхПолейНаСервере();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Элементы, УсловияСтрахованияСотрудников)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСотрудников", "Доступность", УсловияСтрахованияСотрудников <> 0);
КонецПроцедуры

#КонецОбласти

