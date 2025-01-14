#Область СлужебныеПрограммныйИнтерфейс

Процедура ПроверитьЗаполнениеШкалы(СтрокиКоллекции, Отказ) Экспорт

	МассивЗначений = Новый Массив;
	
	Для каждого СтрокаКоллекции Из СтрокиКоллекции Цикл
		Если МассивЗначений.Найти(СтрокаКоллекции.ЗначениеДо) <> Неопределено Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		МассивЗначений.Добавить(СтрокаКоллекции.ЗначениеДо);
	КонецЦикла; 

КонецПроцедуры

Процедура УстановитьПозициюЭлементаВКоллекции(ОбщаяКоллекция, ОтборСтрок, Элемент, ОбратнаяШкала = Ложь) Экспорт 
	
	СтрокиКоллекции = ШкалаПоказателяПоОтбору(ОбщаяКоллекция, ОтборСтрок);
	ЗначениеЭлемента = Элемент.ЗначениеДо;
	
	КоличествоЭлементов = СтрокиКоллекции.Количество();
	
	Если КоличествоЭлементов <= 1 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЭлемента = ЗначениеПоследнегоПорогаШкалы(ОбратнаяШкала) Тогда
		НоваяПозиция = ОбщаяКоллекция.Индекс(СтрокиКоллекции[КоличествоЭлементов - 1]);
		Возврат;
	КонецЕсли;
	
	ТекущаяПозиция = ОбщаяКоллекция.Индекс(Элемент);
	МестоПозицииНайдено = Ложь;
	
	Для каждого ЭлементКоллекции Из СтрокиКоллекции Цикл
		ЭтоПоследнийЭлемент = (СтрокиКоллекции.Количество() = (ИндексСтрокиКоллекции(СтрокиКоллекции, ЭлементКоллекции) + 1));
		
		Если НЕ (ЭлементКоллекции.ЗначениеДо = ЗначениеПоследнегоПорогаШкалы(ОбратнаяШкала) И ЭтоПоследнийЭлемент) Тогда
			НоваяПозиция = ОбщаяКоллекция.Индекс(ЭлементКоллекции);
		КонецЕсли;
		
		НайденЭлементСБольшимЗначением = ?(ОбратнаяШкала, ЭлементКоллекции.ЗначениеДо < ЗначениеЭлемента, ЭлементКоллекции.ЗначениеДо > ЗначениеЭлемента);
		Если НайденЭлементСБольшимЗначением ИЛИ ЭлементКоллекции.ЗначениеДо = ЗначениеПоследнегоПорогаШкалы(ОбратнаяШкала) Тогда
			МестоПозицииНайдено = Истина;
		КонецЕсли;
		
		Если МестоПозицииНайдено Тогда
			Если НоваяПозиция > ТекущаяПозиция Тогда
				НоваяПозиция = НоваяПозиция - 1;
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Сдвиг = НоваяПозиция - ТекущаяПозиция;
	
	ОбщаяКоллекция.Сдвинуть(ТекущаяПозиция, Сдвиг);
	
КонецПроцедуры

Процедура УстановитьПредставлениеИнтервалаПоНижнейГранице(ТаблицаИнтервалов, ОбратнаяШкала = Ложь) Экспорт 
	
	Для каждого ТекущаяСтрока Из ТаблицаИнтервалов Цикл
		ТекущийИндекс = ИндексСтрокиКоллекции(ТаблицаИнтервалов, ТекущаяСтрока);
		
		Если ТекущаяСтрока.ЗначениеДо = ЗначениеПоследнегоПорогаШкалы(ОбратнаяШкала) Тогда
			Если ТекущийИндекс = 0 Тогда // первая строка
				ЗначениеПредставление = НСтр("ru = 'любое значение'");
				ТекущаяСтрока.ЗначениеПредставление = ЗначениеПредставление;
			Иначе
				ПредыдущаяСтрока = ТаблицаИнтервалов[ТекущийИндекс - 1];
				Если ПредыдущаяСтрока.ЗначениеДо = ЗначениеПоследнегоПорогаШкалы(ОбратнаяШкала) Тогда
					ТекущаяСтрока.ЗначениеПредставление = ПредыдущаяСтрока.ЗначениеПредставление;
				Иначе
					Если ОбратнаяШкала Тогда
						ТекущаяСтрока.ЗначениеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'менее %1'"), Строка(ПредыдущаяСтрока.ЗначениеДо));
					Иначе
						ТекущаяСтрока.ЗначениеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'свыше %1'"), Строка(ПредыдущаяСтрока.ЗначениеДо));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			Если ТекущийИндекс = 0 Тогда // первая строка
				ТекущаяСтрока.ЗначениеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'до %1'"), Строка(ТекущаяСтрока.ЗначениеДо));
			Иначе
				ПредыдущаяСтрока = ТаблицаИнтервалов[ТекущийИндекс - 1];
				Если ПредыдущаяСтрока.ЗначениеДо = ТекущаяСтрока.ЗначениеДо Тогда
					ТекущаяСтрока.ЗначениеПредставление = ПредыдущаяСтрока.ЗначениеПредставление;
				Иначе
					ТекущаяСтрока.ЗначениеПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'от %1 до %2'"), Строка(ПредыдущаяСтрока.ЗначениеДо), Строка(ТекущаяСтрока.ЗначениеДо));
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьПредставлениеИнтервалаОценки(ТабличнаяЧасть) Экспорт

	Для каждого ТекущаяСтрока Из ТабличнаяЧасть Цикл
		УстановитьПредставлениеИнтервалаОценкиВСтроке(ТекущаяСтрока);
	КонецЦикла; 

КонецПроцедуры

Процедура УстановитьПредставлениеИнтервалаОценкиВСтроке(ТекущиеДанные) Экспорт

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ИнтервалОценкиПредставлениеОт = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'от %1'"), ТекущиеДанные.ИнтервалОценкиОт);

	ТекущиеДанные.ИнтервалОценкиПредставлениеДо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'до %1'"), ТекущиеДанные.ИнтервалОценкиДо);
		
КонецПроцедуры

Процедура ЗаполнитьВторичныеРеквизитыСтрокиПоказателя(Форма, ТекущиеДанные) Экспорт

	Если Не ЗначениеЗаполнено(ТекущиеДанные.Показатель) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитов = Форма.СоответствиеПоказателей.Получить(ТекущиеДанные.Показатель);
	Если СтруктураРеквизитов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураРеквизитов);

КонецПроцедуры

Функция ШкалаПоказателяПоОтбору(ШкалаЗначений, ОтборСтрок) Экспорт

	Если ОтборСтрок = Неопределено Тогда
		Возврат ШкалаЗначений;
	Иначе
		Возврат ШкалаЗначений.НайтиСтроки(Новый Структура(ОтборСтрок));
	КонецЕсли;

КонецФункции

Процедура ОтсортироватьШкалуЗначений(ШкалаЗначений, ОбратнаяШкала) Экспорт
	ШкалаЗначений.Сортировать("ЗначениеДо" + ?(ОбратнаяШкала, " УБЫВ", ""));
КонецПроцедуры

Функция ВерхнийПорогШкалы() Экспорт
	Возврат 9999999999999.99;
КонецФункции

Функция НижнийПорогШкалы() Экспорт
	Возврат -9999999999999.99;
КонецФункции

Функция ЗначениеПоследнегоПорогаШкалы(ОбратнаяШкала) Экспорт

	Если ОбратнаяШкала Тогда
		Возврат НижнийПорогШкалы();
	Иначе
		Возврат ВерхнийПорогШкалы();
	КонецЕсли;

КонецФункции

Функция ТекстШкалыПоОтрезку(ЗначениеОт, ЗначениеДо) Экспорт 

	Если БесконечныйОтрезок(ЗначениеОт, ЗначениеДо) Тогда
		Возврат НСтр("ru = 'любое значение'");
	ИначеЕсли ЗначениеОт = НижнийПорогШкалы() Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'до %1.'"), ЗначениеДо);
	ИначеЕсли ЗначениеОт = ВерхнийПорогШкалы() Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'до %1.'"), ЗначениеДо);
	ИначеЕсли ЗначениеДо = НижнийПорогШкалы() Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'менее %1.'"), ЗначениеОт);
	ИначеЕсли ЗначениеДо = ВерхнийПорогШкалы() Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'свыше %1.'"), ЗначениеОт);
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'от %1 до %2.'"), ЗначениеОт, ЗначениеДо);
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИндексСтрокиКоллекции(ТаблицаИнтервалов, ТекущаяСтрока)

	Если ТипЗнч(ТаблицаИнтервалов) = Тип("Массив") Тогда
		Возврат ТаблицаИнтервалов.Найти(ТекущаяСтрока);
	Иначе
		Возврат ТаблицаИнтервалов.Индекс(ТекущаяСтрока);
	КонецЕсли;

КонецФункции

Функция БесконечныйОтрезок(ЗначениеОт, ЗначениеДо)

	Если ЗначениеОт = НижнийПорогШкалы() И ЗначениеДо = ВерхнийПорогШкалы()
		ИЛИ ЗначениеОт = ВерхнийПорогШкалы() И ЗначениеДо = НижнийПорогШкалы() Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

#КонецОбласти
