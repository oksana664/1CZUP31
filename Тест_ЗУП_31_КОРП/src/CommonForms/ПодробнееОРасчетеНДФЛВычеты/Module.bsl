
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ФамилияИнициалы = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(Строка(Параметры.ФизическоеЛицо));
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (вычеты к налогам)'"), ФамилияИнициалы);
	
	ДанныеВычетов = ПолучитьИзВременногоХранилища(Параметры.ДанныеВычетов);
	Вычеты.Загрузить(ДанныеВычетов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВычеты

&НаКлиенте
Процедура ВычетыПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Вычеты.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Начисление) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВычетыПриАктивизацииСтроки(Элемент)
	
	УстановитьПараметрыВыбора(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Модифицированность Тогда
		Оповестить("ИзмененыВычетыНДФЛ", РезультатРедактированияВычетов(), ЭтаФорма);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбора(Форма)
	
	Элементы = Форма.Элементы;
	ТекущиеДанные = Элементы.Вычеты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СписокГруппВычетов = Новый Массив;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Начисление) Тогда 
		СписокГруппВычетов.Добавить(ПредопределенноеЗначение("Перечисление.ГруппыВычетовПоНДФЛ.СтандартныеНаДетей"));
		СписокГруппВычетов.Добавить(ПредопределенноеЗначение("Перечисление.ГруппыВычетовПоНДФЛ.Имущественные"));
		СписокГруппВычетов.Добавить(ПредопределенноеЗначение("Перечисление.ГруппыВычетовПоНДФЛ.СоциальныеПоУведомлениюНО"));
		СписокГруппВычетов.Добавить(ПредопределенноеЗначение("Перечисление.ГруппыВычетовПоНДФЛ.Стандартные"));
	Иначе 
		СписокГруппВычетов.Добавить(ПредопределенноеЗначение("Перечисление.ГруппыВычетовПоНДФЛ.ПустаяСсылка"));
	КонецЕсли;
	
	СписокПараметровВыбора = Новый Массив;
	СписокПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.ГруппаВычета", Новый ФиксированныйМассив(СписокГруппВычетов)));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, 
		"ВычетыКодВычета", "ПараметрыВыбора", Новый ФиксированныйМассив(СписокПараметровВыбора));
	
КонецПроцедуры

&НаСервере
Функция РезультатРедактированияВычетов()
	
	Возврат ПоместитьВоВременноеХранилище(Вычеты.Выгрузить());
	
КонецФункции

#КонецОбласти

