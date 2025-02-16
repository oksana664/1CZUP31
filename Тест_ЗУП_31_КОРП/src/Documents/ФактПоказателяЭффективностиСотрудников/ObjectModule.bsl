
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = Документы.ФактПоказателяЭффективностиСотрудников.ПолучитьДанныеДляПроведения(Ссылка);
	КлючевыеПоказателиЭффективности.СформироватьДвиженияФактическиеЗначенияПоказателейЭффективностиСотрудников(Движения, ДанныеДляПроведения.ФактСотрудников);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЭтоСуммируемыйПоказатель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Показатель, "Суммируемый");
	Если ЭтоСуммируемыйПоказатель Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаФактаСотрудников = РегистрыНакопления.ФактическиеЗначенияПоказателейЭффективностиСотрудников.ТаблицаИзмеренийПланаСотрудников();
	
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		НоваяСтрока = ТаблицаФактаСотрудников.Добавить();
		НоваяСтрока.ДатаНачала = НачалоМесяца(Период);
		НоваяСтрока.ДатаОкончания = КонецМесяца(Период);
		НоваяСтрока.Сотрудник = СтрокаСотрудника.Сотрудник;
		НоваяСтрока.Показатель = Показатель;
	КонецЦикла; 
	
	ТаблицаВведеныхЗначений = КлючевыеПоказателиЭффективности.ВведенныеФактическиеЗначенияПоказателейСотрудников(ТаблицаФактаСотрудников, Ссылка);
	
	Для каждого СтрокаВведеныхЗначений Из ТаблицаВведеныхЗначений Цикл
		НайденныеСтроки = Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", СтрокаВведеныхЗначений.Сотрудник));
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Для сотрудника %1 уже введено плановое значение показателя %2.'"), СтрокаВведеныхЗначений.Сотрудник, Показатель);
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Сотрудники[%1].Сотрудник", Сотрудники.Индекс(НайденнаяСтрока)),, Отказ);
		КонецЦикла; 
	КонецЦикла;
	
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
	
	Возврат ОбменДаннымиЗарплатаКадрыРасширенный.ОграниченияРегистрацииПоПодразделениюИСотрудникам(
				ЭтотОбъект, Подразделение, МассивПараметров, Период);
	
КонецФункции

#КонецОбласти

#КонецЕсли
