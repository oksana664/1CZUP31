#Область ОписаниеПеременных

&НаКлиенте
Перем ТипПлатформыНаКлиенте;

#КонецОбласти

#Область ОбработчикиСобытийФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;	
	
	// Формируем данные
	
	ШиринаПоУмолчанию = РазработкаЭлектронныхКурсовСлужебный.ШиринаВидеоПоУмолчанию();
	
	СформироватьТаблицуФорматов();	
	
	// Устанавливаем видимость элементов формы
	
	Если ЗначениеЗаполнено(Параметры.ЭлементРесурса)
		И ТипЗнч(Параметры.ЭлементРесурса) = Тип("СправочникСсылка.ЭлементыЭлектронныхРесурсов") Тогда		
		
		Элементы.ГруппаТаблицаФайлов.Видимость = Ложь;
		Элементы.ГруппаКомандыКонвертации.Видимость = Ложь;		
		Элементы.ГруппаФорматыФайла.Видимость = Истина;
		Элементы.ЗаданияФайл.Видимость = Ложь;
		
		// ФорматОригинала
		
		ИмяФайлаОригинала = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЭлементРесурса, "ИмяФайла");
		СтруктураИмениФайлаОригинала = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаОригинала);
		ФорматОригинала = ВРег(ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(СтруктураИмениФайлаОригинала.Расширение));		
		
		// СконвертированныеФорматы
		
		УстановитьНадписьСконвертированныхФорматовЭлемента();
		
		// Заголовок
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Конвертер видео файла ""%1""'"), Параметры.ЭлементРесурса);	
		
	Иначе
		
		Элементы.ГруппаТаблицаФайлов.Видимость = Истина;
		Элементы.ГруппаКомандыКонвертации.Видимость = Истина;
		Элементы.ГруппаФорматыФайла.Видимость = Ложь;
		
		Элементы.ЗаданияФайл.Видимость = Истина;
		
	КонецЕсли;	
		
	УстановитьДоступностьЭлементовФормы();	
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СистемнаяИнформация = Новый СистемнаяИнформация();

	ТипПлатформыНаКлиенте = СистемнаяИнформация.ТипПлатформы;
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Если (ТипПлатформыНаКлиенте = ТипПлатформы.Windows_x86) ИЛИ (ТипПлатформыНаКлиенте = ТипПлатформы.Windows_x86_64) И ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая Тогда
		Элементы.РежимОтладки.Видимость = Истина;
	Иначе
		Элементы.РежимОтладки.Видимость = Ложь;
	КонецЕсли;
	
	#Если ВебКлиент Тогда			
		
	Элементы.ГруппаКомандыКонвертации.Видимость = Ложь;
	Элементы.ГруппаЗадания.Видимость = Ложь;
	
	Элементы.СформироватьMP4.Доступность = Ложь;
	Элементы.СформироватьWEBM.Доступность = Ложь;
	
	#КонецЕсли
	
	Если Параметры.Автозапуск Тогда
		МассивИдентификаторовВсехСтрок = Новый Массив;
		Для каждого Строка Из ТаблицаФайлов Цикл
			МассивИдентификаторовВсехСтрок.Добавить(Строка.ПолучитьИдентификатор());
		КонецЦикла;
		СформироватьЗадания("MP4", МассивИдентификаторовВсехСтрок);
		Элементы.ГруппаТаблицы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ОтменитьПроцессКонвертации(ЗавершениеРаботы);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненаКонвертацияВидео" И Источник <> ЭтотОбъект Тогда
		СформироватьТаблицуФорматов();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФайлы

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Файлы

&НаКлиенте
Процедура ТаблицаФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТаблицаФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	ТекущаяСтрока = ТаблицаФайлов.НайтиПоИдентификатору(ВыбраннаяСтрока);		
	
	ОткрытьФорму("Справочник.ЭлементыЭлектронныхРесурсов.Форма.ФормаКонвертерВидео", Новый Структура("ЭлементРесурса", ТекущаяСтрока.ЭлементРесурса), ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадания

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Задания

&НаКлиенте
Процедура ЗаданияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив")
		ИЛИ  ПараметрыПеретаскивания.Значение.Количество() = 0
		ИЛИ ТипЗнч(ПараметрыПеретаскивания.Значение[0]) <> Тип("ДанныеФормыЭлементКоллекции")
		ИЛИ НЕ ПараметрыПеретаскивания.Значение[0].Свойство("ЭлементРесурса") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если  ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена
		ИЛИ ТипЗнч(ПараметрыПеретаскивания.Значение) <> Тип("Массив")
		ИЛИ ПараметрыПеретаскивания.Значение.Количество() = 0
		ИЛИ ТипЗнч(ПараметрыПеретаскивания.Значение[0]) <> Тип("ДанныеФормыЭлементКоллекции")
		ИЛИ НЕ ПараметрыПеретаскивания.Значение[0].Свойство("ЭлементРесурса") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	СформироватьЗадания(, ПараметрыПеретаскивания.Значение);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СформироватьЗаданияMP4(Команда)
	СформироватьЗадания("MP4");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаданияWEBM(Команда)
	СформироватьЗадания("WEBM");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗадания(Формат = Неопределено, ВыделенныеСтроки = Неопределено)
	
	Если ВыделенныеСтроки = Неопределено Тогда	
		ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	КонецЕсли;
	
	Если Формат = Неопределено Тогда
		Формат = "MP4"
	КонецЕсли;
	
	ФайлыДляКонвертации = Новый Массив;
	
	Для каждого ИдентификаторСроки Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ИдентификаторСроки) = Тип("Число") Тогда
			ТекущаяСтрока = ТаблицаФайлов.НайтиПоИдентификатору(ИдентификаторСроки);		
		Иначе
			ТекущаяСтрока = ИдентификаторСроки;
		КонецЕсли;
		
		ФайлыДляКонвертации.Добавить(Новый ФиксированнаяСтруктура(Новый Структура("ЭлементРесурса, ИмяФайла, БазовыйФормат", ТекущаяСтрока.ЭлементРесурса, ТекущаяСтрока.ИмяФайла, ТекущаяСтрока.БазовыйФормат)));
		
	КонецЦикла;
	
	Если ФайлыДляКонвертации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеКонвертации = Новый Структура("Формат, Файлы", Формат, Новый ФиксированныйМассив(ФайлыДляКонвертации));
	
	Если Параметры.Автозапуск Тогда		
		СформироватьЗаданияПродолжение(Новый ФиксированнаяСтруктура(Новый Структура("УстановитьШиринуПоУмолчанию", Ложь)), ДанныеКонвертации);		
	Иначе
		ОписаниеОповещенияВыбора = Новый ОписаниеОповещения("СформироватьЗаданияПродолжение", ЭтотОбъект, ДанныеКонвертации);
		ОткрытьФорму("Справочник.ЭлементыЭлектронныхРесурсов.Форма.ФормаВыбораНастроекКонвертации",, ЭтотОбъект,,,,ОписаниеОповещенияВыбора);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаданиеНаКонвертациюОдногоФайла(Формат)
	
	Если ТаблицаФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	СвойстваФайла = ТаблицаФайлов[0];
	
	ФайлыДляКонвертации = Новый Массив();	
	ФайлыДляКонвертации.Добавить(Новый ФиксированнаяСтруктура(Новый Структура("ЭлементРесурса, ИмяФайла, БазовыйФормат", СвойстваФайла.ЭлементРесурса, СвойстваФайла.ИмяФайла, СвойстваФайла.БазовыйФормат)));	
	
	ДанныеКонвертации = Новый Структура;
	ДанныеКонвертации.Вставить("Формат", Формат);
	ДанныеКонвертации.Вставить("Файлы", Новый ФиксированныйМассив(ФайлыДляКонвертации));
	
	Если Параметры.Автозапуск Тогда		
		СформироватьЗаданияПродолжение(Новый ФиксированнаяСтруктура(Новый Структура("УстановитьШиринуПоУмолчанию", Ложь)), ДанныеКонвертации);		
	Иначе				
		ОписаниеОповещенияВыбора = Новый ОписаниеОповещения("СформироватьЗаданияПродолжение", ЭтотОбъект, ДанныеКонвертации);
		ОткрытьФорму("Справочник.ЭлементыЭлектронныхРесурсов.Форма.ФормаВыбораНастроекКонвертации",, ЭтотОбъект,,,,ОписаниеОповещенияВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьЗаданияПродолжение(ВыбранныеНастройки, ДанныеКонвертации) Экспорт
	
	Если ТипЗнч(ВыбранныеНастройки) <> Тип("ФиксированнаяСтруктура") Тогда
		
		// Настройки не выбраны
		
		Если Параметры.Автозапуск Тогда
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;	
		
	// Заполняем таблицу заданий	
	
	Формат = ДанныеКонвертации.Формат;
	ФайлыДляКонвертации = ДанныеКонвертации.Файлы;
	
	НомерЗадания = 0;
	
	Для каждого СвойстваФайла Из ФайлыДляКонвертации Цикл	
			
		// Ищем существующее задание
		
		НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("ЭлементРесурса, Формат", СвойстваФайла.ЭлементРесурса, Формат));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			Продолжить; // Уже есть задание
		КонецЕсли;		
		
		// Добавляем новое задание
		
		НомерЗадания = НомерЗадания + 1;
		
		НоваяСтрока = Задания.Добавить();	
		НоваяСтрока.ЭлементРесурса = СвойстваФайла.ЭлементРесурса;
		НоваяСтрока.ИмяФайла = СвойстваФайла.ИмяФайла;
		НоваяСтрока.Формат = Формат;
		НоваяСтрока.Номер = НомерЗадания;
		НоваяСтрока.Картинка = 3;
		НоваяСтрока.БазовыйФормат = СвойстваФайла.БазовыйФормат;		
		НоваяСтрока.Настройки = ВыбранныеНастройки;
	
	КонецЦикла;
	
	УстановитьДоступностьЭлементовФормы();
	
	Если Параметры.Автозапуск Тогда
		НачатьВыполнениеКонвертации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьКонвертацию(Команда)			
	НачатьВыполнениеКонвертации();
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыполнениеКонвертации()			
	ВыполняетсяКонвертация = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗадания(Команда)
	
	ВыделенныеСтроки = Элементы.Задания.ВыделенныеСтроки;
	
	Для каждого ИдентификаторСроки Из ВыделенныеСтроки Цикл
		ТекущаяСтрока = Задания.НайтиПоИдентификатору(ИдентификаторСроки);
		Если ТекущаяСтрока.Выполняется Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Задание выполняется и не может быть удалено.
			|Отмените процесс конвертации.'"));
		Иначе
			Задания.Удалить(ТекущаяСтрока);
		КонецЕсли;
			
	КонецЦикла;
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФорматы(Команда)
	
	ВыделенныеСтроки = Элементы.ТаблицаФайлов.ВыделенныеСтроки;
	ВыбранныеФайлы = Новый Массив;
	
	Для каждого ИдентификаторСроки Из ВыделенныеСтроки Цикл	
		ТекущаяСтрока = ТаблицаФайлов.НайтиПоИдентификатору(ИдентификаторСроки);		
		ВыбранныеФайлы.Добавить(Новый ФиксированнаяСтруктура(Новый Структура("ЭлементРесурса", ТекущаяСтрока.ЭлементРесурса)));
	КонецЦикла;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьФорматыПродолжение(РазработкаЭлектронныхКурсовСлужебныйКлиентСервер.ДоступныеФорматыВидео(), ВыбранныеФайлы);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФормат(Формат)

	Если ТаблицаФайлов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	СвойстваФайла = ТаблицаФайлов[0];
	
	ВыбранныеФайлы = Новый Массив();	
	ВыбранныеФайлы.Добавить(Новый ФиксированнаяСтруктура(Новый Структура("ЭлементРесурса", СвойстваФайла.ЭлементРесурса)));
	
	МассивФорматов = Новый Массив;
	МассивФорматов.Добавить(Формат);
	
	УдалитьФорматыПродолжение(Новый ФиксированныйМассив(МассивФорматов), ВыбранныеФайлы);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФорматыПродолжение(Форматы, ВыбранныеФайлы)	
	
	Если Форматы <> Неопределено И Форматы.Количество() > 0 Тогда
		УдалитьФорматыНаСервере(Форматы, ВыбранныеФайлы);
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ЭлементРесурса) = Тип("СправочникСсылка.ЭлементыЭлектронныхРесурсов") Тогда
		Оповестить("ВыполненаКонвертацияВидео", Параметры.ЭлементРесурса, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьФорматыНаСервере(Знач ВыбранныеФорматы, Знач ВыбранныеФайлы)
	
	Для каждого СвойстваФайла Из ВыбранныеФайлы Цикл	
		
		ЭлементФайлаОбъект = СвойстваФайла.ЭлементРесурса.ПолучитьОбъект();
		
		Для каждого Формат Из ВыбранныеФорматы Цикл			
			ЭлементФайлаОбъект.УдалитьДанныеЭлементаПриЗаписи(Формат);
		КонецЦикла;
		
		ЭлементФайлаОбъект.Записать();
		
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения(); // Так как доступные форматы кэшируются
	
	СформироватьТаблицуФорматов();
	
	УстановитьДоступностьЭлементовФормы();	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьКонвертацию(Команда)
	ОтменитьПроцессКонвертации();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФайлы(Команда)
	СформироватьТаблицуФорматов();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьMP4(Команда)
	СформироватьЗаданиеНаКонвертациюОдногоФайла("MP4");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьWEBM(Команда)
	СформироватьЗаданиеНаКонвертациюОдногоФайла("WEBM");
КонецПроцедуры

&НаКлиенте
Процедура УдалитьMP4(Команда)
	УдалитьФормат("MP4");
КонецПроцедуры

&НаКлиенте
Процедура УдалитьWEBM(Команда)
	УдалитьФормат("WEBM");
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ПРОЦЕСС КОНВЕРТАЦИИ

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеКонвертации()  
	
	#Если НЕ ВебКлиент Тогда
		
	Если НЕ ВыполняетсяКонвертация Тогда
		Возврат;
	КонецЕсли;
		
	// Ищем задания для запуска
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется", Истина));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		
		НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Выполнено", Ложь, Ложь));
		
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			Задание = НайденныеСтроки[0];
			
			Задание.Выполняется = Истина;
			Задание.Картинка = 2;			
			Задание.Прогресс = "1%";
			ПрогрессАктивногоЗадания = 1;
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеСозданияРабочегоКаталога", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));
			НачатьСозданиеКаталога(ОписаниеОповещения, ПолучитьИмяВременногоФайла(""));			
			
			УстановитьДоступностьЭлементовФормы();
			
			ОпределитьКоличествоВыполненныхЗаданий();
			
		КонецЕсли;
		
	Иначе
		
		Для каждого Задание Из НайденныеСтроки Цикл
		
			// Делаем проверку, не завис ли процесс
			
			Если Задание.СчетчикРекурсии > 45 Тогда
				ОтменитьПроцессКонвертации();
				ПоказатьПредупреждение(, НСтр("ru = 'Процесс конвертации прерван. Вероятно, файл не может быть сконвертирован..'"));				
			КонецЕсли;			
		
		КонецЦикла;
		
	КонецЕсли;
	
	// Ищем задания для копирования начальных файлов
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 1));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеИнициализацииРабочегоКаталога", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));
		
		СвойстваЗадания = Новый Структура("ЭлементРесурса, Формат, ИмяФайла, БазовыйФормат", Задание.ЭлементРесурса, Задание.Формат, Задание.ИмяФайла, Задание.БазовыйФормат);
		ФайлыДляКопирования = ОписанияФайловДляВыгрузкиВРабочийКаталог(СвойстваЗадания, УникальныйИдентификатор, ЭлектронноеОбучениеСлужебныйКлиентСервер.ТипПлатформыВСтроку(ТипПлатформыНаКлиенте), РежимОтладки);
		
		НачатьПолучениеФайлов(ОписаниеОповещения, Новый Массив(ФайлыДляКопирования), Задание.РабочийКаталог, Ложь);
		
	КонецЕсли;
	
	// Ищем задания для получения информации о длительности видео
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 2));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];			
				
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьПоискИнформацииОДлительности", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));
		
		ЗапуститьПриложениеКонвертации(" -i " + ИмяОригинальногоФайла(Задание.БазовыйФормат) + " -report ", Задание.РабочийКаталог, ОписаниеОповещения);
		
	КонецЕсли;

	// Ищем задания, в которых надо найти информацию о длительности
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 3));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];	
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПоискИнформацииОДлительности", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));	
		
		НачатьПоискФайлов(ОписаниеОповещения, Задание.РабочийКаталог, "*.log", Ложь);		
		
	КонецЕсли;		
	
	// Ищем задания для запуска конвертации
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 4));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];	
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗапускаКонвертации", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));		
		
		ПараметрыЗапуска = " -progress progress.txt -i " + ИмяОригинальногоФайла(Задание.БазовыйФормат) ;
		
		Если Задание.Настройки <> Неопределено Тогда
			
			Если Задание.Настройки.УстановитьШиринуПоУмолчанию Тогда
				
				ПараметрыЗапуска = ПараметрыЗапуска + "  -vf scale="+  ЭлектронноеОбучениеСлужебныйКлиентСервер.ЧислоВСтроку(ШиринаПоУмолчанию) +":-2 ";
				
			КонецЕсли;
				
		КонецЕсли;
		
		ЗапуститьПриложениеКонвертации(ПараметрыЗапуска + " " + ИмяНовогоФайла(Задание.Формат), Задание.РабочийКаталог, ОписаниеОповещения);
		
	КонецЕсли;
	
	// Ищем задания для поиска текущего прогресса
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 5));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];	
		
		ФайлПрогресса = Новый Файл(Задание.РабочийКаталог + "progress.txt");
		
		Если ФайлПрогресса.Существует() Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьПрогрессКонвертации", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));		
			НачатьКопированиеФайла(ОписаниеОповещения, ФайлПрогресса.ПолноеИмя, ФайлПрогресса.ПолноеИмя + "_");			
		Иначе
			Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1;
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 2, Истина);			
		КонецЕсли;		
		
	КонецЕсли;
	
	// Ищем задания для сохранения результата в базу
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 6));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];	

		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПомещенияНовогоФайлаВХранилище", ЭтотОбъект, Новый Структура("ИдентификаторЗадания", Задание.ПолучитьИдентификатор()));
		
		Попытка
			НачатьПомещениеФайла(ОписаниеОповещения,,  Задание.РабочийКаталог + ИмяНовогоФайла(Задание.Формат), Ложь, УникальныйИдентификатор);
		Исключение
			Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1;
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 2, Истина);
			// Фиксация исключения не требуется. Будут еще попытки до исчерпания счетчика.
			// Если несколько попыток не будут успешны, будет вызвано исключение.
		КонецПопытки;
		
	КонецЕсли;
	
	// Ищем завершенные задания
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполняется, Этап", Истина, 7));

	Если НайденныеСтроки.Количество() > 0 Тогда

		Задание = НайденныеСтроки[0];		
		
		Задание.Выполняется = Ложь;
		Задание.Выполнено = Истина;		
		Задание.Картинка = 1;
		
		СформироватьТаблицуФорматов();
		
		УстановитьДоступностьЭлементовФормы();
		
		Попытка
			УдалитьФайлы(Задание.РабочийКаталог); // Удаляем рабочий каталог (синхронный метод)
		Исключение
			ЭлектронноеОбучениеСлужебныйКлиент.ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось удалить временный файл
				|%1 по причине: %2'"), Задание.РабочийКаталог, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()))
			);
		КонецПопытки;		
		
		Задание.РабочийКаталог = "";
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 0.1, Истина);
		
		Если ТипЗнч(Параметры.ЭлементРесурса) = Тип("СправочникСсылка.ЭлементыЭлектронныхРесурсов") Тогда
			Оповестить("ВыполненаКонвертацияВидео", Параметры.ЭлементРесурса, ЭтотОбъект);
		КонецЕсли;
		
		ОбновитьПовторноИспользуемыеЗначения(); // Так как доступные форматы кэшируются		
		
	КонецЕсли;
	
	// Закрываем конвертер
	
	НайденныеСтроки = Задания.НайтиСтроки(Новый Структура("Выполнено", Истина));
	
	Если Параметры.Автозапуск И НайденныеСтроки.Количество() = Задания.Количество() Тогда
		Закрыть();
	КонецЕсли;	
	
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСозданияРабочегоКаталога(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);
	Задание.РабочийКаталог = ЭлектронноеОбучениеСлужебныйКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталога);
	Задание.Этап = 1;
	Задание.Прогресс = "2%";
	ПрогрессАктивногоЗадания = 2;
	Задание.СчетчикРекурсии = 0;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИнициализацииРабочегоКаталога(ПолученныеФайлы, ДополнительныеПараметры) Экспорт

	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);
	Задание.Этап = 2;	
	Задание.Прогресс = "3%";
	ПрогрессАктивногоЗадания = 3;
	Задание.СчетчикРекурсии = 0;

	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 0.1, Истина);
	
КонецПроцедуры	

&НаКлиенте
Процедура НачатьПоискИнформацииОДлительности(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);
	
	Задание.Этап = 3;	
	Задание.Прогресс = "4%";
	ПрогрессАктивногоЗадания = 4;
	Задание.СчетчикРекурсии = 0;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 2, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ПоискИнформацииОДлительности(НайденныеФайлы, ДополнительныеПараметры) Экспорт

	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);	
	
	Если НайденныеФайлы.Количество() = 0 Тогда
		Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1; 
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 1, Истина);
		Возврат;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;			
	
	Попытка
		ТекстовыйДокумент.Прочитать(НайденныеФайлы[0].ПолноеИмя);
	Исключение
		Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1; 
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 1, Истина);		
		Возврат; // Ждем еще
	КонецПопытки;	
	
	ТекстЛогФайла = ТекстовыйДокумент.ПолучитьТекст();
	
	ПозицияDuration = Найти(ТекстЛогФайла, "Duration:");
	
	Если ПозицияDuration < 1 Тогда
		Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1; 
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 1, Истина);		
		Возврат;
	КонецЕсли;
	
	ПраваяЧастьЛогФайла = Сред(ТекстЛогФайла, ПозицияDuration + СтрДлина("Duration:"));
	
	ПозицияКонцаDuration = Найти(ПраваяЧастьЛогФайла, ",");
	
	ТекстDuration = СокрЛП(Сред(ПраваяЧастьЛогФайла, 1, ПозицияКонцаDuration-1));
	
	DurationМассив = ЭлектронноеОбучениеСлужебныйКлиентСервер.СтрокаВебРазделить(ТекстDuration, ":");
	
	DurationВСекундах = 0;
	
	Попытка
		DurationВСекундах = Число(DurationМассив[0])*60*60 + Число(DurationМассив[1])*60 + Число(DurationМассив[2]);
	Исключение
		Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1; 
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 1, Истина);		
		Возврат; // Ждем, пока не закончится счетчик рекурсии
	КонецПопытки;
	
	Если DurationВСекундах = 0 Тогда
		Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1; 
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 1, Истина);		
		Возврат;		
	КонецЕсли;
	
	Задание.Длительность = DurationВСекундах;	
	Задание.Этап = 4;
	Задание.Прогресс = "5%";
	ПрогрессАктивногоЗадания = 5;
	Задание.СчетчикРекурсии = 0;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 0.1, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаКонвертации(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);	

	Задание.Этап = 5;	
	Задание.Прогресс = "6%";
	ПрогрессАктивногоЗадания = 6;
	Задание.СчетчикРекурсии = 0;
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПрогрессКонвертации(СкопированныйФайл, ДополнительныеПараметры) Экспорт
	
	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);	
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	ТекстовыйДокумент.Прочитать(СкопированныйФайл);
	
	КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	
	// Ищем прогресс в числах
	
	НомерСтроки = КоличествоСтрок;
	ТекущаяПозицияВСекундах = 0;
	
	Пока НомерСтроки > 0 Цикл
		
		ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		
		ПозицияПеременной = Найти(ТекущаяСтрока, "out_time_ms=");
		
		Если ПозицияПеременной = 1 Тогда
			
			ТекущаяПозицияВСекундах = Число(СокрЛП(Сред(ТекущаяСтрока, СтрДлина("out_time_ms=")+1))) / 1000000;
			
			Прервать;
			
		КонецЕсли;			
		
		НомерСтроки = НомерСтроки - 1;
		
	КонецЦикла;
	
	Если Задание.Длительность = 0 Тогда
		ПрогрессЧисло = 0;
	Иначе
		ПрогрессЧисло = Окр((ТекущаяПозицияВСекундах / Задание.Длительность)*100, 0);
	КонецЕсли;
	
	Если ПрогрессЧисло < 6 Тогда
		ПрогрессЧисло = 6; // Так как до 6% идет подготовительный этап
	КонецЕсли;
	
	Если ПрогрессЧисло > 100 Тогда
		ПрогрессЧисло = 100;
	КонецЕсли;
	
	НовыйПрогресс = Строка(ПрогрессЧисло) + "%";
	
	Если Задание.Прогресс = НовыйПрогресс Тогда
		Задание.СчетчикРекурсии = Задание.СчетчикРекурсии + 1;
	Иначе
		Задание.СчетчикРекурсии = 0;
	КонецЕсли;
	
	Задание.Прогресс = НовыйПрогресс;
	ПрогрессАктивногоЗадания = ПрогрессЧисло;
	
	// Ищем прогресс по факту
	
	НомерСтроки = КоличествоСтрок;
	ЗначениеПрогрессаСтрока = "";
	
	Пока НомерСтроки > 0 Цикл
		
		ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки);
		
		ПозицияПеременной = Найти(ТекущаяСтрока, "progress=");
		
		Если ПозицияПеременной = 1 Тогда
			
			ЗначениеПрогрессаСтрока = СокрЛП(Сред(ТекущаяСтрока, СтрДлина("progress=")+1));
			
			Прервать;
			
		КонецЕсли;			
		
		НомерСтроки = НомерСтроки - 1;
		
	КонецЦикла;
	
	Если ЗначениеПрогрессаСтрока = "end" Тогда
		Задание.Этап = 6;
		Задание.СчетчикРекурсии = 0;
		Задание.Прогресс = "100%";
		ПрогрессАктивногоЗадания = 100;
		
		ОпределитьКоличествоВыполненныхЗаданий();
		
	КонецЕсли;
	
	// Завершаем	
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьКоличествоВыполненныхЗаданий()
	
	ВыполненоЗаданий = Задания.НайтиСтроки(Новый Структура("Выполнено", Истина)).Количество();
	ВсегоЗаданий = Задания.Количество();
	
	Если ВсегоЗаданий > 0 Тогда
		КоличествоЗаданийВыполнено = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Этап %1 из %2'"), Строка(ВыполненоЗаданий + 1), Строка(ВсегоЗаданий));
	Иначе
		КоличествоЗаданийВыполнено = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияНовогоФайлаВХранилище(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка сохранения файла: %1'");
	КонецЕсли;
	
	Задание = Задания.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗадания);
	
	СохранитьВБазеНовыйФайл(Адрес, Задание.Формат, Задание.ЭлементРесурса);
	
	Задание.Этап = 7;	
	Задание.СчетчикРекурсии = 0;

	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеКонвертации", 0.1, Истина);	
	
КонецПроцедуры

// КОНВЕРТАЦИЯ ВСПОМОГАТЕЛЬНОЕ

&НаКлиенте
Процедура ЗапуститьПриложениеКонвертации(ПараметрыКонвертации, РабочийКаталог, ОписаниеОповещения)
	
	ПрограммаКонвертации = ОписаниеПрограммыКонвертации(ТипПлатформыНаКлиенте, РежимОтладки);
	
	Если (ТипПлатформыНаКлиенте = ТипПлатформы.Windows_x86) ИЛИ (ТипПлатформыНаКлиенте = ТипПлатформы.Windows_x86_64) Тогда		
			
		WshShell = Новый COMОбъект("WScript.Shell");
		WshShell.CurrentDirectory = РабочийКаталог;
		WshShell.Run(РабочийКаталог + ПрограммаКонвертации.ИмяФайла + ПараметрыКонвертации, ?(ПрограммаКонвертации.РежимОтладки, 1, 0), 0);
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
		
	Иначе
		
		НачатьЗапускПриложения(ОписаниеОповещения, РабочийКаталог + ПрограммаКонвертации.ИмяФайла + ПараметрыКонвертации, РабочийКаталог, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроцессКонвертации(ЗавершениеРаботы = Ложь)
	
	#Если НЕ ВебКлиент Тогда
		
	ВыполняетсяКонвертация = Ложь;
		
	Для каждого Задание Из Задания Цикл
		
		Если Задание.Выполняется Тогда
			
			Если (ТипПлатформыНаКлиенте = ТипПлатформы.Windows_x86) ИЛИ (ТипПлатформыНаКлиенте = ТипПлатформы.Windows_x86_64) Тогда
				
				Попытка
					WshShell = Новый COMОбъект("WScript.Shell");
					WshShell.CurrentDirectory = Задание.РабочийКаталог;					
					WshShell.Run("taskkill /IM ffmpeg.exe /F", 0, 0);
				Исключение
					ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ЭлектронноеОбучениеСлужебныйКлиентСервер.СобытиеЖурналаРегистрацииЭлектронныхКурсов(), "Ошибка", "ОтменитьПроцессКонвертации(): " + ИнформацияОбОшибке() + Символы.ПС + ОписаниеОшибки());
				КонецПопытки;				
					
			КонецЕсли;
			
			Задание.СчетчикРекурсии = 0;
			Задание.Этап = 0;
			Задание.Длительность = 0;
			Задание.Картинка = 3;
			Задание.Прогресс = "";
			ПрогрессАктивногоЗадания = 0;
			Задание.Выполняется = Ложь;					
			
		КонецЕсли;			
		
	КонецЦикла;		
	
	Если НЕ ЗавершениеРаботы Тогда
		УстановитьДоступностьЭлементовФормы();
	КонецЕсли;
	
	Если Параметры.Автозапуск Тогда
		Закрыть();
	КонецЕсли;
	
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьВБазеНовыйФайл(АдресФайла, Формат, ЭлементРесурса) 
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
	
	ЭлементРесурсаОбъект = ЭлементРесурса.ПолучитьОбъект();
	ЭлементРесурсаОбъект.ЗаполнитьДанныеЭлементаПриЗаписи(ДвоичныеДанные, Формат, НРег(Формат));
	ЭлементРесурсаОбъект.Записать();	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОписанияФайловДляВыгрузкиВРабочийКаталог(Задание, УникальныйИдентификатор, ТипПлатформыСтрока, РежимОтладки)
	
	ТипПлатформыКлиента = ЭлектронноеОбучениеСлужебныйКлиентСервер.СтрокаВТипПлатформы(ТипПлатформыСтрока);
	ОписанияФайлов = Новый Массив;
	
	// Оригинальный файл видео
	
	ИмяОригинальногоФайла = ИмяОригинальногоФайла(Задание.БазовыйФормат);	
	
	АдресФайлаОригинала = Справочники.ЭлементыЭлектронныхРесурсов.ДанныеЭлементаДляРедактирования(Задание.ЭлементРесурса, Перечисления.ТипыЭлементовЭлектронныхРесурсов.Video, УникальныйИдентификатор);
	
	ОписанияФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяОригинальногоФайла, АдресФайлаОригинала));	
	
	// Программа конвертации
	
	ПрограммаКонвертации = ОписаниеПрограммыКонвертации(ТипПлатформыКлиента, РежимОтладки);
	
	Если ПрограммаКонвертации <> Неопределено Тогда
		
		ДвоичныеДанныеПрограммы = РазработкаЭлектронныхКурсовСлужебный.ДвоичныеДанныеПрограммы(ПрограммаКонвертации.Код);
		ХранениеДанныхПрограммы = ПоместитьВоВременноеХранилище(ДвоичныеДанныеПрограммы, УникальныйИдентификатор);
		
		ОписанияФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(ПрограммаКонвертации.ИмяФайла, ХранениеДанныхПрограммы));		
		
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(ОписанияФайлов);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяОригинальногоФайла(БазовыйФормат)
	Возврат ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением("original", НРег(БазовыйФормат))
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяНовогоФайла(Формат)
	Возврат ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением("new", НРег(Формат))
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеПрограммыКонвертации(ТипПлатформыКлиента, РежимОтладки)
	
	ИмяПрограммыКонвертации = "ffmpeg";
	
	Если (ТипПлатформыКлиента = ТипПлатформы.Windows_x86) ИЛИ (ТипПлатформыКлиента = ТипПлатформы.Windows_x86_64) Тогда
		
		СвойстваПрограммы = ШаблонСвойствПрограммыДляКонвертации();
		СвойстваПрограммы.Код = "КонвертерВидеоWindows";
		СвойстваПрограммы.ИмяФайла = ИмяПрограммыКонвертации + ".exe";
		СвойстваПрограммы.РежимОтладки = РежимОтладки;
		
		Возврат СвойстваПрограммы;
		
	КонецЕсли;
	
	Если (ТипПлатформыКлиента = ТипПлатформы.Linux_x86) ИЛИ (ТипПлатформыКлиента = ТипПлатформы.Linux_x86_64) Тогда
		
		СвойстваПрограммы = ШаблонСвойствПрограммыДляКонвертации();
		СвойстваПрограммы.Код = "КонвертерВидеоLinux";
		СвойстваПрограммы.ИмяФайла = ИмяПрограммыКонвертации;
		СвойстваПрограммы.РежимОтладки = РежимОтладки;
		
		Возврат СвойстваПрограммы;
		
	КонецЕсли;
	
	Если (ТипПлатформыКлиента = ТипПлатформы.MacOS_x86) ИЛИ (ТипПлатформыКлиента = ТипПлатформы.MacOS_x86_64) Тогда
		
		СвойстваПрограммы = ШаблонСвойствПрограммыДляКонвертации();
		СвойстваПрограммы.Код = "КонвертерВидеоMac";
		СвойстваПрограммы.ИмяФайла = ИмяПрограммыКонвертации;
		СвойстваПрограммы.РежимОтладки = РежимОтладки;
		
		Возврат СвойстваПрограммы;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ШаблонСвойствПрограммыДляКонвертации()
	Возврат Новый Структура("Код, ИмяФайла, РежимОтладки", "", "", Ложь);
КонецФункции

// ФАЙЛЫ

&НаСервере
Процедура СформироватьТаблицуФорматов()
	
	// Заполняем таблицу файлов
	
	Если ЗначениеЗаполнено(Параметры.ЭлементРесурса) Тогда				
		ФорматыВидеоФайлов = Справочники.ЭлементыЭлектронныхРесурсов.ФорматыВидеоФайловДляКонвертации(Параметры.ЭлементРесурса);		
	Иначе
		ФорматыВидеоФайлов = Справочники.ЭлементыЭлектронныхРесурсов.ФорматыВидеоФайловДляКонвертации();
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ФорматыВидеоФайлов, "ТаблицаФайлов");			

КонецПроцедуры

// ОБЩЕЕ

&НаСервере
Функция УстановитьДоступностьЭлементовФормы()	
	
	ЕстьАктивноеЗадание = Ложь;
	ЕстьНовоеЗадание = Ложь;
	
	Для каждого Строка Из Задания Цикл
	
		Если Строка.Выполняется Тогда
			ЕстьАктивноеЗадание = Истина;
		КонецЕсли;
		
		Если НЕ Строка.Выполняется И НЕ Строка.Выполнено Тогда
			ЕстьНовоеЗадание = Истина;
		КонецЕсли;		
		
	КонецЦикла;
	
	Элементы.УдалитьЗадания.Доступность = ?(Задания.Количество() > 0, Истина, Ложь);
	Элементы.КомандаНачатьКонвертацию.Доступность = ?(НЕ ЕстьАктивноеЗадание И ЕстьНовоеЗадание, Истина, Ложь);
	Элементы.ДекорацияПрогресс.Видимость = ЕстьАктивноеЗадание;
	Элементы.ГруппаАвтозапуск.Видимость = Параметры.Автозапуск;
	Элементы.ГруппаКомандыКонвертации.Доступность = ?(ТаблицаФайлов.Количество() > 0, Истина, Ложь);
	Элементы.КомандаУдалитьФорматы.Доступность = ?(ТаблицаФайлов.Количество() > 0, Истина, Ложь);
	Элементы.КомандаОтменитьКонвертацию.Доступность = ЕстьАктивноеЗадание;	
	
	Если ТипЗнч(Параметры.ЭлементРесурса) = Тип("СправочникСсылка.ЭлементыЭлектронныхРесурсов")
		И ЗначениеЗаполнено(Параметры.ЭлементРесурса) 
		И ТаблицаФайлов.Количество() > 0 Тогда
		
		СвойстваФайла = ТаблицаФайлов[0];
		
		Элементы.ДекорацияНетФорматаMP4.Видимость = НЕ СвойстваФайла.MP4;
		Элементы.ДекорацияНетФорматаWEBM.Видимость = НЕ СвойстваФайла.WEBM;
		
		Элементы.ДекорацияЕстьФорматMP4.Видимость = СвойстваФайла.MP4;
		Элементы.ДекорацияЕстьФорматWEBM.Видимость = СвойстваФайла.WEBM;
		
		Элементы.СформироватьMP4.Доступность = ?(НЕ СвойстваФайла.MP4, Истина, Ложь);
		Элементы.СформироватьWEBM.Доступность = ?(НЕ СвойстваФайла.WEBM, Истина, Ложь);
		
		Элементы.УдалитьMP4.Доступность = ?(СвойстваФайла.MP4, Истина, Ложь);
		Элементы.УдалитьWEBM.Доступность = ?(СвойстваФайла.WEBM, Истина, Ложь);
		
	КонецЕсли;
	
	УстановитьНадписьСконвертированныхФорматовЭлемента();
	
КонецФункции

&НаСервере
Процедура УстановитьНадписьСконвертированныхФорматовЭлемента()
	
	Если ЗначениеЗаполнено(Параметры.ЭлементРесурса)
		И ТипЗнч(Параметры.ЭлементРесурса) = Тип("СправочникСсылка.ЭлементыЭлектронныхРесурсов") Тогда
		
		// СконвертированныеФорматы
			
		СконвертированныеФорматы = "";
		
		Для каждого Строка Из ТаблицаФайлов Цикл
		
			Если Строка.MP4 Тогда
				СконвертированныеФорматы = СконвертированныеФорматы +  " MP4, ";
			КонецЕсли;
			
			Если Строка.WEBM Тогда
				СконвертированныеФорматы = СконвертированныеФорматы +  " WEBM, ";
			КонецЕсли;			
			
		КонецЦикла; 
		
		Если СтрДлина(СконвертированныеФорматы) > 0 Тогда
			СконвертированныеФорматы = Лев(СконвертированныеФорматы, СтрДлина(СконвертированныеФорматы)-2);
		Иначе
			СконвертированныеФорматы = НСтр("ru = 'Отсутствуют'");
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры


#КонецОбласти
