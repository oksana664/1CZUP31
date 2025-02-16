#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		МетаданныеОбъекта = ЭтотОбъект.Метаданные();
		Для Каждого ПараметрЗаполнения Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(ПараметрЗаполнения.Ключ)<>Неопределено Тогда
				ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
			Иначе
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ПараметрЗаполнения.Ключ) Тогда
					ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.НесчастныйСлучайНаПроизводстве") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НесчастныйСлучайНаПроизводствеПострадавшие.Ссылка,
		|	НесчастныйСлучайНаПроизводстве.Организация,
		|	НесчастныйСлучайНаПроизводстве.Подразделение,
		|	НесчастныйСлучайНаПроизводствеПострадавшие.Пострадавший
		|ПОМЕСТИТЬ ВТПострадавшие
		|ИЗ
		|	Документ.НесчастныйСлучайНаПроизводстве.Пострадавшие КАК НесчастныйСлучайНаПроизводствеПострадавшие
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НесчастныйСлучайНаПроизводстве КАК НесчастныйСлучайНаПроизводстве
		|		ПО НесчастныйСлучайНаПроизводствеПострадавшие.Ссылка = НесчастныйСлучайНаПроизводстве.Ссылка
		|ГДЕ
		|	НесчастныйСлучайНаПроизводствеПострадавшие.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Пострадавшие.Ссылка,
		|	Пострадавшие.Организация,
		|	Пострадавшие.Подразделение,
		|	Пострадавшие.Пострадавший,
		|	БольничныйЛист.Ссылка КАК БольничныйЛист
		|ИЗ
		|	ВТПострадавшие КАК Пострадавшие
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БольничныйЛист КАК БольничныйЛист
		|		ПО Пострадавшие.Пострадавший = БольничныйЛист.ФизическоеЛицо
		|			И (БольничныйЛист.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ТравмаНаПроизводстве))";
		
		Пострадавшие.Очистить();
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Организация = Выборка.Организация;
			Подразделение = Выборка.Подразделение;
			ДокументОснование = Выборка.Ссылка;
			
			Если Пострадавшие.Найти(Выборка.Пострадавший, "Пострадавший") = Неопределено Тогда
				НоваяСтрока = Пострадавшие.Добавить();
				НоваяСтрока.Пострадавший = Выборка.Пострадавший;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.БольничныйЛист) Тогда
				НоваяСтрока = БольничныеЛистыПострадавших.Добавить();
				НоваяСтрока.Пострадавший = Выборка.Пострадавший;
				НоваяСтрока.БольничныйЛист = Выборка.БольничныйЛист;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	МассивПострадавших = Пострадавшие.ВыгрузитьКолонку("Пострадавший");
	ДатаПроисшествия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДатаПроисшествия");
	КраткийСоставПострадавшие = ЗарплатаКадры.КраткийСоставФизЛиц(МассивПострадавших, ДатаПроисшествия);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаАкта, "Объект.ДатаАкта", Отказ, НСтр("ru='Дата акта'"), , , Ложь);
	
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
	МассивПараметров.Добавить(Новый Структура("Пострадавшие", "Пострадавший"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическимЛицам(ЭтотОбъект, Организация, МассивПараметров, ДатаПроисшествия);
	
КонецФункции

#КонецОбласти

#КонецЕсли

