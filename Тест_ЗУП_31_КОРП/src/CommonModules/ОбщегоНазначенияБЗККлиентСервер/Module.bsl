////////////////////////////////////////////////////////////////////////////////
// Клиентские и серверные процедуры и функции общего назначения
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Задает обязательность заполнения поля формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного поля формы. 
//
// Параметры:
//  Форма           - УправляемаяФорма - форма.
//  ИмяЭлемента     - Строка - имя поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).  
//  Обязательное    - Булево - признак обязательности поля, по умолчанию Истина.
//  ПутьКДаннымПоля - Строка - путь к данным поля ввода, например: "Объект.МесяцНачисления".
//                    Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьПоляВводаФормы(Форма, ИмяЭлемента, Знач Обязательное = Истина, Знач ПутьКДанным = Неопределено) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ИмяПроцедуры = "ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы";
	ИмяПараметра = "ИмяЭлемента";
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		ИмяПараметра,
		ЭлементФормы,
		Новый ОписаниеТипов("ПолеФормы"));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение свойства ""Вид"" поля %3, переданного в параметре %2 в процедуру %1. Ожидается поле ввода.'"),
			ИмяПроцедуры, ИмяПараметра, ИмяЭлемента));
			
	Если Не Обязательное Тогда
		ЭлементФормы.АвтоОтметкаНезаполненного = Ложь;
		ЭлементФормы.ОтметкаНезаполненного     = Ложь;
	Иначе	
		ЭлементФормы.АвтоОтметкаНезаполненного = Истина;
		ЭлементФормы.ОтметкаНезаполненного     = Не ПоляВводаФормыЗаполнено(Форма, ЭлементФормы, ПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры	

// Задает обязательность заполнения таблицы формы.
// Устанавливает свойства АвтоОтметкаНезаполненного и ОтметкаНезаполненного таблицы формы. 
//
// Параметры:
//  Форма           - УправляемаяФорма - форма.
//  ИмяЭлемента     - Строка - имя таблицы формы.   
//  Обязательное    - Булево - признак обязательности поля, по умолчанию Истина.
//  ПутьКДаннымПоля - Строка - путь к данным таблицы, например: "Объект.МесяцНачисления".
//                    Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьТаблицыФормы(Форма, ИмяЭлемента, Знач Обязательная = Истина, Знач ПутьКДанным = Неопределено) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		"ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьТаблицыФормы",
		"ИмяЭлемента",
		ЭлементФормы,
		Новый ОписаниеТипов("ТаблицаФормы"));
		
	Если Не Обязательная Тогда
		ЭлементФормы.АвтоОтметкаНезаполненного = Ложь;
		ЭлементФормы.ОтметкаНезаполненного     = Ложь;
	Иначе	
		ЭлементФормы.АвтоОтметкаНезаполненного = Истина;
		ЭлементФормы.ОтметкаНезаполненного     = Не ТаблицаФормыЗаполнена(Форма, ЭлементФормы, ПутьКДанным);
	КонецЕсли;
	
КонецПроцедуры	

// Задает обязательность заполнения поля ввода в таблице формы (колонки).
// Устанавливает свойство АвтоОтметкаНезаполненного поля таблицы формы. 
// (свойство ОтметкаНезаполненного в поле таблицы всегда устанавливается автоматически).
//
// Параметры:
//  Форма           - УправляемаяФорма - форма.
//  ИмяЭлемента     - Строка - имя поля формы. Должно быть полем ввода (ВидПоляФормы.ПолеВвода).  
//  Обязательное    - Булево - признак обязательности поля, по умолчанию Истина.
//  ПутьКДаннымПоля - Строка - путь к данным поля ввода, например: "Объект.МесяцНачисления".
//                    Необязательный. Если не указан, то значение поля будет определено из свойств элемента.          
//
Процедура УстановитьОбязательностьПоляВводаТаблицыФормы(Форма, ИмяЭлемента, Знач Обязательное = Истина) Экспорт
	
	ЭлементФормы = Форма.Элементы.Найти(ИмяЭлемента);
	Если ЭлементФормы = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ИмяПроцедуры = "ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаТаблицыФормы";
	ИмяПараметра = "ИмяЭлемента";
	
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(
		ИмяПроцедуры,
		ИмяПараметра,
		ЭлементФормы,
		Новый ОписаниеТипов("ПолеФормы"));
		
	ОбщегоНазначенияКлиентСервер.Проверить(
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимое значение свойства ""Вид"" поля %3, переданного в параметре %2 в процедуру %1. Ожидается поле ввода.'"),
			ИмяПроцедуры, ИмяПараметра, ИмяЭлемента));
			
	ЭлементФормы.АвтоОтметкаНезаполненного = Обязательное;
	Если Не Обязательное Тогда
		ЭлементФормы.ОтметкаНезаполненного = Ложь;
	КонецЕсли;	
			
КонецПроцедуры	

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//  Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Подработки") Тогда
//  	МодульПодработок = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("Подработки");
//  	МодульПодработок.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево - Истина, если существует.
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ОбщегоНазначения.ПодсистемаСуществует(ПолноеИмяПодсистемы);
#Иначе
	Возврат ОбщегоНазначенияКлиент.ПодсистемаСуществует(ПолноеИмяПодсистемы);
#КонецЕсли

КонецФункции

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "Подработки",
//                 "ПодработкиКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль - общий модуль.
//
Функция ОбщийМодуль(Имя) Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Модуль = ОбщегоНазначения.ОбщийМодуль(Имя);
#Иначе
	Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль(Имя);
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

// Возвращает соответствие, ключами которого являются элементы массива, 
//  в качестве значений для всех ключей будет установлено Истина.
//
// Параметры:
//	Массив - Массив - элементы которого нужно поместить в Соответствие.
//
// Возвращаемое значение:
//	Соответствие.
//
Функция МассивВСоответствие(Массив) Экспорт
	Соответствие = Новый Соответствие;
	
	Для Каждого ЭлементМассива Из Массив Цикл
		Соответствие.Вставить(ЭлементМассива, Истина);
	КонецЦикла;	

	Возврат Соответствие;
КонецФункции	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоляВводаФормыЗаполнено(Форма, ЭлементФормы, Знач ПутьКДанным = Неопределено)
	
	ЗначениеПоля = Неопределено;
	
	ПутьРеквизита = ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным);
	
	Если ЗначениеЗаполнено(ПутьРеквизита) Тогда
		ЗначениеПоля = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьРеквизита);
	Иначе
#Если Клиент Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ТекстРедактирования доступен только в клиентском режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно
		Попытка
			ЗначениеПоля = ЭлементФормы.ТекстРедактирования;
		Исключение	
		КонецПопытки	
#КонецЕсли
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(ЗначениеПоля)
	
КонецФункции

Функция ТаблицаФормыЗаполнена(Форма, ЭлементФормы, Знач ПутьКДанным = Неопределено)
	
	КоличествоСтрок = Неопределено;
	
	ПутьРеквизита = ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным);
	
	Если ЗначениеЗаполнено(ПутьРеквизита) Тогда
		КоличествоСтрок = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьРеквизита).Количество();
	Иначе
#Если Клиент Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ВыделенныеСтроки доступны только в клиентском режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно
		Попытка
			КоличествоСтрок = ЭлементФормы.ВыделенныеСтроки.Количество()
		Исключение	
		КонецПопытки	
#КонецЕсли
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(КоличествоСтрок)
	
КонецФункции

Функция ПутьКДаннымЭлементаФормы(ЭлементФормы, ПутьКДанным)
	ПутьКДаннымЭлементаФормы = Неопределено;
	Если ЗначениеЗаполнено(ПутьКДанным)	Тогда
		ПутьКДаннымЭлементаФормы = ПутьКДанным
	Иначе	
#Если Сервер Тогда
		// Попытка нужна для работы в толстом клиенте в файл-серверном варианте:
		// ПутьКДанным доступен только в серверном режиме исполнения, 
		// а определить его в толстом файл-сервере невозможно
		Попытка
			ПутьКДаннымЭлементаФормы = ЭлементФормы.ПутьКДанным;
		Исключение	
		КонецПопытки	
#КонецЕсли
	КонецЕсли;	
	Возврат ПутьКДаннымЭлементаФормы
КонецФункции

#КонецОбласти