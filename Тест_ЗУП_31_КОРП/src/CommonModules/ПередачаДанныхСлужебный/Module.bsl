#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.1.1");
	СтруктураПоддерживаемыхВерсий.Вставить("DataTransfer", МассивВерсий);
	
КонецПроцедуры

Функция Получить(ПараметрыДоступа, ИзФизическогоХранилища = Ложь, ИдентификаторХранилища, Идентификатор) Экспорт
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ОшибкаПолучения = Ложь;
	ОписаниеФайла = Неопределено;
	ЗапрашиваемыйДиапазон = Неопределено;
	
	СтруктураURI = СтруктураURI(ПараметрыДоступа.URL);
	Соединение = Соединение(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	
	Если ИзФизическогоХранилища Тогда
		
		АдресРесурсаШаблон = "/hs/dt/volume/%1/%2";
		
	Иначе
		
		АдресРесурсаШаблон = "/hs/dt/storage/%1/%2";
		
	КонецЕсли;
	
	АдресРесурса = СтруктураURI.ПутьНаСервере + СтрШаблон(АдресРесурсаШаблон, ИдентификаторХранилища, Строка(Идентификатор));
	
	РазмерБлокаПолученияДанных = РазмерБлокаПолученияДанных();
	
	ЗапросРесурса = Новый HTTPЗапрос(АдресРесурса);
	ЗапросРесурса.Заголовки.Вставить("IBSession", "start");
	
	ОтветНаЗапросРесурса = Соединение.Получить(ЗапросРесурса);
	
	Если ОтветНаЗапросРесурса.КодСостояния = 400 Тогда
		
		ЗапросРесурса.Заголовки.Удалить("IBSession");
		ОтветНаЗапросРесурса = Соединение.Получить(ЗапросРесурса);
		
	КонецЕсли;
	
	Если ОтветНаЗапросРесурса.КодСостояния = 302 Тогда
		
		Location = ОтветНаЗапросРесурса.Заголовки.Получить("Location");
		SetCookie = ОтветНаЗапросРесурса.Заголовки.Получить("Set-Cookie");
		
		СтруктураURI = СтруктураURI(Location);
		Соединение = Соединение(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
		
		ЗапросДанных = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
		
		Если РазмерБлокаПолученияДанных > 0 Тогда
			
			ЗапрашиваемыйДиапазон = Новый Структура("Начало, Конец", 0, РазмерБлокаПолученияДанных - 1);
			ЗапросДанных.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(ЗапрашиваемыйДиапазон.Начало, "ЧН=0; ЧГ=0"), Формат(ЗапрашиваемыйДиапазон.Конец, "ЧН=0; ЧГ=0")));
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(SetCookie) Тогда
			
			ЗапросДанных.Заголовки.Вставить("Cookie", SetCookie);
			
		КонецЕсли;
		
		ОтветНаЗапросДанных = Соединение.Получить(ЗапросДанных);
		
		Если ОтветНаЗапросДанных.КодСостояния = 200 ИЛИ ОтветНаЗапросДанных.КодСостояния = 206 Тогда
			
			ПотокДанных = ФайловыеПотоки.Открыть(ИмяВременногоФайла, РежимОткрытияФайла.СоздатьНовый, ДоступКФайлу.Запись);
			Поток = ОтветНаЗапросДанных.ПолучитьТелоКакПоток();
			
			Если ОтветНаЗапросДанных.КодСостояния = 200 Тогда
				
				Поток.КопироватьВ(ПотокДанных);
				
			ИначеЕсли ОтветНаЗапросДанных.КодСостояния = 206 Тогда
				
				ПолученныйДиапазон = ПолученныйДиапазон(ОтветНаЗапросДанных.Заголовки.Получить("Content-Range"));
				Поток.КопироватьВ(ПотокДанных);
				
				Пока ПолученныйДиапазон.Конец < ПолученныйДиапазон.Размер - 1 Цикл
				
					ЗапрашиваемыйДиапазон = Новый Структура("Начало, Конец", ПолученныйДиапазон.Конец + 1, Мин(ПолученныйДиапазон.Конец + РазмерБлокаПолученияДанных, ПолученныйДиапазон.Размер - 1));
					
					Если ЗапрашиваемыйДиапазон.Конец = ПолученныйДиапазон.Размер - 1 И ЗначениеЗаполнено(SetCookie) Тогда
						
						ЗапросДанных.Заголовки.Вставить("IBSession", "finish");
						
					КонецЕсли;
					
					ЗапросДанных.Заголовки.Вставить("Range", СтрШаблон("bytes=%1-%2", Формат(ЗапрашиваемыйДиапазон.Начало, "ЧН=0; ЧГ=0"), Формат(ЗапрашиваемыйДиапазон.Конец, "ЧН=0; ЧГ=0")));
					ОтветНаЗапросДанных = Соединение.Получить(ЗапросДанных);
					
					Если ОтветНаЗапросДанных.КодСостояния = 206 Тогда
						
						Поток = ОтветНаЗапросДанных.ПолучитьТелоКакПоток();
						
						ПолученныйДиапазон = ПолученныйДиапазон(ОтветНаЗапросДанных.Заголовки.Получить("Content-Range"));
						
						ПотокДанных.Перейти(ПолученныйДиапазон.Начало, ПозицияВПотоке.Начало);
						Поток.КопироватьВ(ПотокДанных);
						
					Иначе
						
						ОшибкаПолучения = Истина;
						ОшибкаПриПолученииДанных(ОтветНаЗапросДанных);
						Прервать;
						
					КонецЕсли;
				
				КонецЦикла;
				
			Иначе
				
				ОшибкаПолучения = Истина;
				ОшибкаПриПолученииДанных(ОтветНаЗапросДанных);
				
			КонецЕсли;
			
			Поток.Закрыть();
			ПотокДанных.Закрыть();
			
			Если НЕ ОшибкаПолучения Тогда
				
				СвойстваФайла = Новый Файл(ИмяВременногоФайла);
			
				ОписаниеФайла = Новый Структура;
				ОписаниеФайла.Вставить("Имя", СвойстваФайла.Имя);
				ОписаниеФайла.Вставить("ПолноеИмя", СвойстваФайла.ПолноеИмя);
				
			КонецЕсли;
			
		Иначе
			
			ОшибкаПолучения = Истина;
			ОшибкаПриПолученииДанных(ОтветНаЗапросДанных);
			
		КонецЕсли;
		
	Иначе
		
		ОшибкаПолучения = Истина;
		ОшибкаПриПолученииДанных(ОтветНаЗапросРесурса);
		
	КонецЕсли;
	
	Если ОшибкаПолучения Тогда
		
		Попытка
			
			УдалитьФайлы(ИмяВременногоФайла);
			
		Исключение
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ОписаниеФайла;
	
КонецФункции

Функция Отправить(ПараметрыДоступа, ВФизическоеХранилище = Ложь, ИдентификаторХранилища, Данные, Знач ИмяФайла) Экспорт
	
	Результат = Неопределено;
	
	СтруктураURI = СтруктураURI(ПараметрыДоступа.URL);
	Соединение = Соединение(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
	
	Если ВФизическоеХранилище Тогда
		
		АдресРесурсаШаблон = "/hs/dt/volume/%1/%2";
		
	Иначе
		
		АдресРесурсаШаблон = "/hs/dt/storage/%1/%2";
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ИмяФайла) И ТипЗнч(Данные) = Тип("Файл") Тогда
		
		ИмяФайла = Данные.Имя;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(ИмяФайла) Тогда
		
		ФайлОбъект = Новый Файл(ПолучитьИмяВременногоФайла());
		ИмяФайла = ФайлОбъект.Имя;
		
	КонецЕсли;
	
	АдресРесурса = СтруктураURI.ПутьНаСервере + СтрШаблон(АдресРесурсаШаблон, ИдентификаторХранилища, ИмяФайла);
	
	РазмерБлокаОтправкиДанных = РазмерБлокаОтправкиДанных();
	
	ЗапросРесурса = Новый HTTPЗапрос(АдресРесурса);
	ЗапросРесурса.Заголовки.Вставить("IBSession", "start");
	
	ОтветНаЗапросРесурса = Соединение.ОтправитьДляОбработки(ЗапросРесурса);
	
	Если ОтветНаЗапросРесурса.КодСостояния = 400 Тогда
		
		ЗапросРесурса.Заголовки.Удалить("IBSession");
		ОтветНаЗапросРесурса = Соединение.ОтправитьДляОбработки(ЗапросРесурса);
		
	КонецЕсли;
	
	Если ОтветНаЗапросРесурса.КодСостояния = 200 Тогда
		
		Location = ОтветНаЗапросРесурса.Заголовки.Получить("Location");
		SetCookie = ОтветНаЗапросРесурса.Заголовки.Получить("Set-Cookie");
		
		СтруктураURI = СтруктураURI(Location);
		Соединение = Соединение(СтруктураURI, ПараметрыДоступа.UserName, ПараметрыДоступа.Password);
		
		ЗапросДанных = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
		
		Если ЗначениеЗаполнено(SetCookie) Тогда
			
			ЗапросДанных.Заголовки.Вставить("Cookie", SetCookie);
			
		КонецЕсли;
		
		Если РазмерБлокаОтправкиДанных > 0 Тогда
			
			Если ЭтоАдресВременногоХранилища(Данные) Тогда
				
				ПотокДанных = ПолучитьИзВременногоХранилища(Данные).ОткрытьПотокДляЧтения();
				
			ИначеЕсли ТипЗнч(Данные) = Тип("Строка") Тогда
				
				ПотокДанных = ФайловыеПотоки.Открыть(Данные, РежимОткрытияФайла.Открыть, ДоступКФайлу.Чтение);
				
			ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда
				
				ПотокДанных = ФайловыеПотоки.Открыть(Данные.ПолноеИмя, РежимОткрытияФайла.Открыть, ДоступКФайлу.Чтение);
				
			ИначеЕсли ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
				
				ПотокДанных = Данные.ОткрытьПотокДляЧтения();
				
			КонецЕсли;
			
			ОтправляемыйДиапазон = Новый Структура("Начало, Конец", 0, Мин(РазмерБлокаОтправкиДанных - 1, ПотокДанных.Размер() - 1));
			
			Пока Истина Цикл
				
				Буфер = Новый БуферДвоичныхДанных(ОтправляемыйДиапазон.Конец - ОтправляемыйДиапазон.Начало + 1);
				ПотокДанных.Перейти(ОтправляемыйДиапазон.Начало, ПозицияВПотоке.Начало);
				Прочитано = ПотокДанных.Прочитать(Буфер, 0, Буфер.Размер);
				ЗапросДанных.УстановитьТелоИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(Буфер));
			
				ЗапросДанных.Заголовки.Вставить("Content-Range", СтрШаблон("bytes %1-%2/%3", Формат(ОтправляемыйДиапазон.Начало, "ЧН=0; ЧГ=0"), Формат(ОтправляемыйДиапазон.Начало + Прочитано - 1, "ЧН=0; ЧГ=0"), Формат(ПотокДанных.Размер(), "ЧН=0; ЧГ=0")));
				
				Если ОтправляемыйДиапазон.Конец = ПотокДанных.Размер() - 1 И ЗначениеЗаполнено(SetCookie) Тогда
					
					ЗапросДанных.Заголовки.Вставить("IBSession", "finish");
					
				КонецЕсли;
				
				ОтветНаЗапросДанных = Соединение.Записать(ЗапросДанных);
				
				Если ОтветНаЗапросДанных.КодСостояния = 201 Тогда
					
				    ЧтениеJSON = Новый ЧтениеJSON;
				    ЧтениеJSON.УстановитьСтроку(ОтветНаЗапросДанных.ПолучитьТелоКакСтроку());
					ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON);
					
					Если ДанныеОтвета.Количество() = 1 И ДанныеОтвета.Свойство("id") Тогда
						
						Результат = ДанныеОтвета.id;
						
					Иначе
						
						Результат = ДанныеОтвета;
						
					КонецЕсли;
					
					ПотокДанных.Закрыть();
					Прервать;
					
				ИначеЕсли ОтветНаЗапросДанных.КодСостояния <> 202 Тогда
					
					ОшибкаПриОтправкеДанных(ОтветНаЗапросДанных);
					
					ПотокДанных.Закрыть();
					Прервать;
					
				КонецЕсли;
				
				ОтправляемыйДиапазон = Новый Структура("Начало, Конец", ОтправляемыйДиапазон.Конец + 1, Мин(ОтправляемыйДиапазон.Конец + РазмерБлокаОтправкиДанных, ПотокДанных.Размер() - 1));
				
			КонецЦикла;
			
		Иначе
			
			Если ЭтоАдресВременногоХранилища(Данные) Тогда
				
				ЗапросДанных.УстановитьТелоИзДвоичныхДанных(ПолучитьИзВременногоХранилища(Данные));
				
			ИначеЕсли ТипЗнч(Данные) = Тип("Строка") Тогда
				
				ЗапросДанных.УстановитьИмяФайлаТела(Данные);
				
			ИначеЕсли ТипЗнч(Данные) = Тип("Файл") Тогда
				
				ЗапросДанных.УстановитьИмяФайлаТела(Данные.ПолноеИмя);
				
			ИначеЕсли ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
				
				ЗапросДанных.УстановитьТелоИзДвоичныхДанных(Данные);
				
			КонецЕсли;
			
			ЗапросДанных.Заголовки.Вставить("IBSession", "finish");
			ОтветНаЗапросДанных = Соединение.Записать(ЗапросДанных);
			
			Если ОтветНаЗапросДанных.КодСостояния = 201 Тогда
				
			    ЧтениеJSON = Новый ЧтениеJSON;
			    ЧтениеJSON.УстановитьСтроку(ОтветНаЗапросДанных.ПолучитьТелоКакСтроку());
				ДанныеОтвета = ПрочитатьJSON(ЧтениеJSON);
				
				Если ДанныеОтвета.Количество() = 1 И ДанныеОтвета.Свойство("id") Тогда
					
					Результат = ДанныеОтвета.id;
					
				Иначе
					
					Результат = ДанныеОтвета;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ОшибкаПриОтправкеДанных(ОтветНаЗапросРесурса);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолученныйДиапазон(ContentRange) Экспорт
	
	Диапазон = Неопределено;
	ContentRange = СокрЛП(ContentRange);
	
	Если НЕ ПустаяСтрока(ContentRange) И СтрНачинаетсяС(ContentRange, "bytes ") Тогда
		
		ContentRange = Прав(ContentRange, СтрДлина(ContentRange) - СтрДлина("bytes "));
		МассивПодстрок = СтрРазделить(ContentRange, "/");
		Range = МассивПодстрок[0];
		Size = МассивПодстрок[1];
		МассивПодстрок = СтрРазделить(Range, "-");
		
		Попытка
			
			Начало = Число(МассивПодстрок[0]);
			Конец = Число(МассивПодстрок[1]);
			Размер = Число(Size);
			
			Диапазон = Новый Структура("Начало, Конец, Размер", Начало, Конец, Размер);
			
		Исключение
			
			Диапазон = Неопределено;
			
		КонецПопытки;
		
	КонецЕсли;
		
	Возврат Диапазон;
	
КонецФункции

Функция ПериодДействияВременногоИдентификатора() Экспорт
	
	ПериодДействияВременногоИдентификатора = 600; // 10 минут
	
	ПередачаДанныхВстраивание.ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора);
	ПередачаДанныхПереопределяемый.ПериодДействияВременногоИдентификатора(ПериодДействияВременногоИдентификатора);
	
	Возврат ПериодДействияВременногоИдентификатора;
	
КонецФункции

Функция РазмерБлокаПолученияДанных() Экспорт
	
	РазмерБлокаПолученияДанных = 1024 * 1024;
	
	ПередачаДанныхВстраивание.РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных);
	ПередачаДанныхПереопределяемый.РазмерБлокаПолученияДанных(РазмерБлокаПолученияДанных);
	
	Возврат РазмерБлокаПолученияДанных;

КонецФункции

Функция РазмерБлокаОтправкиДанных() Экспорт
	
	РазмерБлокаОтправкиДанных = 1024 * 1024;
	
	ПередачаДанныхВстраивание.РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных);
	ПередачаДанныхПереопределяемый.РазмерБлокаОтправкиДанных(РазмерБлокаОтправкиДанных);
	
	Возврат РазмерБлокаОтправкиДанных;

КонецФункции

Процедура ОшибкаПриПолученииДанных(Ответ) Экспорт
	
	ОбщийМодуль_ДемоОбработкаОшибок = Метаданные.ОбщиеМодули.Найти("_ДемоОбработкаОшибок");
	
	Если ОбщийМодуль_ДемоОбработкаОшибок <> Неопределено Тогда
		
		ОбщийМодуль_ДемоОбработкаОшибок = Вычислить(ОбщийМодуль_ДемоОбработкаОшибок.Имя);
		ОбщийМодуль_ДемоОбработкаОшибок.ЗаписьТехнологическогоЖурнала("ПолучениеДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
		
	КонецЕсли;
	
	ПередачаДанныхВстраивание.ОшибкаПриПолученииДанных(Ответ);
	ПередачаДанныхПереопределяемый.ОшибкаПриПолученииДанных(Ответ);
	
КонецПроцедуры

Процедура ОшибкаПриОтправкеДанных(Ответ) Экспорт
	
	ОбщийМодуль_ДемоОбработкаОшибок = Метаданные.ОбщиеМодули.Найти("_ДемоОбработкаОшибок");
	
	Если ОбщийМодуль_ДемоОбработкаОшибок <> Неопределено Тогда
	
		ОбщийМодуль_ДемоОбработкаОшибок = Вычислить(ОбщийМодуль_ДемоОбработкаОшибок.Имя);
		ОбщийМодуль_ДемоОбработкаОшибок.ЗаписьТехнологическогоЖурнала("ОтправкаДанных.Ошибка", Новый Структура("КодСостояния, Описание", Ответ.КодСостояния, Ответ.ПолучитьТелоКакСтроку()));
		
	КонецЕсли;
	
	ПередачаДанныхВстраивание.ОшибкаПриОтправкеДанных(Ответ);
	ПередачаДанныхПереопределяемый.ОшибкаПриОтправкеДанных(Ответ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураURI(Знач СтрокаURI)
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// Схема.
	Схема = "";
	Позиция = СтрНайти(СтрокаURI, "://");
	
	Если Позиция > 0 Тогда
		
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
		
	КонецЕсли;

	// Строка соединения и путь на сервере.
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = СтрНайти(СтрокаСоединения, "/");
	
	Если Позиция > 0 Тогда
		
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
		
	КонецЕсли;
		
	// Информация пользователя и имя сервера.
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = СтрНайти(СтрокаСоединения, "@");
	
	Если Позиция > 0 Тогда
		
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
		
	КонецЕсли;
	
	// Логин и пароль.
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = СтрНайти(СтрокаАвторизации, ":");
	
	Если Позиция > 0 Тогда
		
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
		
	КонецЕсли;
	
	// Хост и порт.
	Хост = ИмяСервера;
	Порт = "";
	Позиция = СтрНайти(ИмяСервера, ":");
	
	Если Позиция > 0 Тогда
		
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
		
		Если Не ТолькоЦифрыВСтроке(Порт) Тогда
			
			Порт = "";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(ПустаяСтрока(Порт), Неопределено, Число(Порт)));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки)
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Цифры = "0123456789";
	
	Возврат СтрРазделить(СтрокаПроверки, Цифры, Ложь).Количество() = 0;
	
КонецФункции

Функция Соединение(СтруктураURI, UserName, Password)
	
	ЗащищенноеСоединение = ?(СтруктураURI.Схема = "https", Новый ЗащищенноеСоединениеOpenSSL(, Новый СертификатыУдостоверяющихЦентровОС), Неопределено);
	Порт = ?(ЗначениеЗаполнено(СтруктураURI.Порт), Число(СтруктураURI.Порт), ?(ЗащищенноеСоединение = Неопределено, 80, 443));
	
	Возврат Новый HTTPСоединение(СтруктураURI.Хост, Порт, UserName, Password,, 60, ЗащищенноеСоединение);
	
КонецФункции

#КонецОбласти