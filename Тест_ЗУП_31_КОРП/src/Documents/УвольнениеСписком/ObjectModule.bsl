#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, 
				ДанныеЗаполнения.Ссылка, "ДокументРассчитан");
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
			УстановитьПривилегированныйРежим(Истина);
			
			// Заполним таблицу перерасчета и показателей для нее
			ТаблицаПоказателей = ЭтотОбъект.Показатели.Выгрузить();
			ТаблицаРаспределенияНачислений = ЭтотОбъект.РаспределениеРезультатовНачислений.Выгрузить();
			ТаблицаРаспределенияУдержаний = ЭтотОбъект.РаспределениеРезультатовУдержаний.Выгрузить();
			ТаблицаРаспределенияТерриторий = ЭтотОбъект.РаспределениеПоТерриториямУсловиямТруда.Выгрузить();
			
			ОписаниеТаблицы = КадровыйУчетРасширенныйКлиентСервер.ОписаниеТаблицыПерерасчетов(Истина);
			ИдентификаторСтроки = ОписаниеТаблицы.НомерТаблицы * 1000000 + 1;
			Для каждого СтрокаНачисления Из ЭтотОбъект.Начисления Цикл
				НоваяСтрокаПерерасчета = ЭтотОбъект.НачисленияПерерасчет.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаПерерасчета, СтрокаНачисления);
				
				НоваяСтрокаПерерасчета.Сторно							= Истина;
				НоваяСтрокаПерерасчета.ФиксСторно						= Истина;
				НоваяСтрокаПерерасчета.СторнируемыйДокумент				= ИсправленныйДокумент;
				НоваяСтрокаПерерасчета.ИдентификаторСтрокиВидаРасчета	= ИдентификаторСтроки;
				НоваяСтрокаПерерасчета.Результат						= - НоваяСтрокаПерерасчета.Результат;
				НоваяСтрокаПерерасчета.СуммаВычета						= - НоваяСтрокаПерерасчета.СуммаВычета;
				НоваяСтрокаПерерасчета.РезультатВТомЧислеЗаСчетФБ		= - НоваяСтрокаПерерасчета.РезультатВТомЧислеЗаСчетФБ;
				НоваяСтрокаПерерасчета.ОтработаноДней					= - НоваяСтрокаПерерасчета.ОтработаноДней;
				НоваяСтрокаПерерасчета.ОтработаноЧасов					= - НоваяСтрокаПерерасчета.ОтработаноЧасов;
				НоваяСтрокаПерерасчета.ОплаченоДней						= - НоваяСтрокаПерерасчета.ОплаченоДней;
				НоваяСтрокаПерерасчета.ОплаченоЧасов					= - НоваяСтрокаПерерасчета.ОплаченоЧасов;
				
				ИдентификаторСтроки = ИдентификаторСтроки + 1;
				
				// Значения показателей заполняем по сторнируемому документу.
				СтрокиПоказателейНачисления = ТаблицаПоказателей.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника, ИдентификаторСтрокиВидаРасчета", СтрокаНачисления.ИдентификаторСтрокиСотрудника, СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
				Для Каждого СтрокаПоказателя Из СтрокиПоказателейНачисления Цикл
					НоваяСтрокаПоказателей = ЭтотОбъект.Показатели.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаПоказателей, СтрокаПоказателя);
					НоваяСтрокаПоказателей.ИдентификаторСтрокиСотрудника = НоваяСтрокаПерерасчета.ИдентификаторСтрокиСотрудника;
					НоваяСтрокаПоказателей.ИдентификаторСтрокиВидаРасчета = НоваяСтрокаПерерасчета.ИдентификаторСтрокиВидаРасчета;
				КонецЦикла;
				
				// Результаты распределения начислений по сторнируемому документу
				СтрокиРаспределенийНачисления = ТаблицаРаспределенияНачислений.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника, ИдентификаторСтроки", СтрокаНачисления.ИдентификаторСтрокиСотрудника, СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
				Для Каждого СтрокаРаспределения Из СтрокиРаспределенийНачисления Цикл
					НоваяСтрокаРаспределения = ЭтотОбъект.РаспределениеРезультатовНачислений.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаРаспределения, СтрокаРаспределения);
					НоваяСтрокаРаспределения.Результат = - СтрокаРаспределения.Результат;
					НоваяСтрокаРаспределения.ИдентификаторСтрокиСотрудника = НоваяСтрокаПерерасчета.ИдентификаторСтрокиСотрудника;
					НоваяСтрокаРаспределения.ИдентификаторСтроки = НоваяСтрокаПерерасчета.ИдентификаторСтрокиВидаРасчета;
				КонецЦикла;
				
				// Результаты распределения удержаний по сторнируемому документу
				СтрокиРаспределенийУдержания = ТаблицаРаспределенияУдержаний.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника, ИдентификаторСтроки", СтрокаНачисления.ИдентификаторСтрокиСотрудника, СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
				Для Каждого СтрокаРаспределения Из СтрокиРаспределенийУдержания Цикл
					НоваяСтрокаРаспределения = ЭтотОбъект.РаспределениеРезультатовУдержаний.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаРаспределения, СтрокаРаспределения);
					НоваяСтрокаРаспределения.Результат = - СтрокаРаспределения.Результат;
					НоваяСтрокаРаспределения.ИдентификаторСтрокиСотрудника = НоваяСтрокаПерерасчета.ИдентификаторСтрокиСотрудника;
					НоваяСтрокаРаспределения.ИдентификаторСтроки = НоваяСтрокаПерерасчета.ИдентификаторСтрокиВидаРасчета;
				КонецЦикла;
				
				// Результаты распределения по территориям по сторнируемому документу
				СтрокиРаспределенийТерритории = ТаблицаРаспределенияТерриторий.НайтиСтроки(Новый Структура("ИдентификаторСтрокиСотрудника, ИдентификаторСтроки", СтрокаНачисления.ИдентификаторСтрокиСотрудника, СтрокаНачисления.ИдентификаторСтрокиВидаРасчета));
				Для Каждого СтрокаРаспределения Из СтрокиРаспределенийТерритории Цикл
					НоваяСтрокаРаспределения = ЭтотОбъект.РаспределениеПоТерриториямУсловиямТруда.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаРаспределения, СтрокаРаспределения);
					НоваяСтрокаРаспределения.Результат = - СтрокаРаспределения.Результат;
					НоваяСтрокаРаспределения.ИдентификаторСтрокиСотрудника = НоваяСтрокаПерерасчета.ИдентификаторСтрокиСотрудника;
					НоваяСтрокаРаспределения.ИдентификаторСтроки = НоваяСтрокаПерерасчета.ИдентификаторСтрокиВидаРасчета;
				КонецЦикла;
				
			КонецЦикла;
			
			// Заполним таблицу перерасчета пособий и показателей для нее
			ИсправлениеДокументовРасчетЗарплаты.СформироватьДанныеПерерасчетаДляИсправленияПособий(
				ЭтотОбъект.ИсправленныйДокумент, ЭтотОбъект.ПериодРегистрации, ЭтотОбъект.Пособия, ЭтотОбъект.ПособияПерерасчет, ЭтотОбъект.НачисленияПерерасчет,
				КадровыйУчетРасширенныйКлиентСервер.ОписаниеТаблицыПособияПерерасчеты(Истина));
			
			УстановитьПривилегированныйРежим(Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.УвольнениеСписком.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьМножественностьСотрудниковФизическогоЛица(Отказ);
	Документы.Увольнение.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПроверитьМножественностьСотрудниковФизическогоЛица(Отказ)
	
	СотрудникиФизическихЛиц = Новый Соответствие;
	НомераСтрокСотрудников = Новый Соответствие;
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		НомераСтрокСотрудников.Вставить(СтрокаСотрудника.Сотрудник, СтрокаСотрудника.НомерСтроки);
		ФизическоеЛицо = СотрудникиКлиентСерверПовтИсп.ФизическиеЛицаСотрудников(СтрокаСотрудника.Сотрудник)[0];
		
		КоллекцияСотрудников = СотрудникиФизическихЛиц.Получить(ФизическоеЛицо);
		Если КоллекцияСотрудников = Неопределено Тогда
			КоллекцияСотрудников = Новый Массив;
			СотрудникиФизическихЛиц.Вставить(ФизическоеЛицо, КоллекцияСотрудников);
		КонецЕсли;
		
		КоллекцияСотрудников.Добавить(СтрокаСотрудника.Сотрудник);
		
	КонецЦикла;
	
	ПроверяемыеФизическиеЛица = Новый Массив;
	Для каждого ОписаниеСотрудниковФизическихЛиц Из СотрудникиФизическихЛиц Цикл
		
		Если ОписаниеСотрудниковФизическихЛиц.Значение.Количество() > 1 Тогда
			ПроверяемыеФизическиеЛица.Добавить(ОписаниеСотрудниковФизическихЛиц.Ключ);
		КонецЕсли;
		
	КонецЦикла;
	
	ФизическиеЛицаСУдержаниями = Новый Массив;
	Для каждого ПроверяемоеФизическоеЛицо Из ПроверяемыеФизическиеЛица Цикл
		
		СтрокиУдержаний = НДФЛ.НайтиСтроки(Новый Структура("ФизическоеЛицо", ПроверяемоеФизическоеЛицо));
		Если СтрокиУдержаний.Количество() > 0 Тогда
			ФизическиеЛицаСУдержаниями.Добавить(ПроверяемоеФизическоеЛицо);
			Продолжить;
		КонецЕсли;
		
		СтрокиУдержаний = Удержания.НайтиСтроки(Новый Структура("ФизическоеЛицо", ПроверяемоеФизическоеЛицо));
		Если СтрокиУдержаний.Количество() > 0 Тогда
			ФизическиеЛицаСУдержаниями.Добавить(ПроверяемоеФизическоеЛицо);
			Продолжить;
		КонецЕсли;
		
		СтрокиУдержаний = ПогашениеЗаймов.НайтиСтроки(Новый Структура("ФизическоеЛицо", ПроверяемоеФизическоеЛицо));
		Если СтрокиУдержаний.Количество() > 0 Тогда
			ФизическиеЛицаСУдержаниями.Добавить(ПроверяемоеФизическоеЛицо);
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ФизическиеЛицаСУдержаниями.Количество() > 0 Тогда
		
		ФИОФизическихЛиц = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(ФизическиеЛицаСУдержаниями, "Фамилия,Имя,Отчество");
		
		Для каждого ФизическоеЛицо Из ФизическиеЛицаСУдержаниями Цикл
			
			ТекстСообщения = НСтр("ru='Не поддерживается увольнение с нескольких мест работы в одном документе.
				|Для каждого места работы сотрудника %1 оформите отдельный документ увольнения'");
			
			ТекстСообщения = СтрШаблон(ТекстСообщения, ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИОФизическихЛиц.Получить(ФизическоеЛицо)));
			
			СотрудникиФизическогоЛица = СотрудникиФизическихЛиц.Получить(ФизическоеЛицо);
			НомераСтроки = НомераСтрокСотрудников.Получить(СотрудникиФизическогоЛица[0]);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, Ссылка, "Объект.Сотрудники[" + (НомераСтроки - 1) + "].Сотрудник", , Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.Увольнение.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ПериодРегистрации);
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СведенияПоСотрудникам = УчетСреднегоЗаработка.ТаблицаСведенийДокументаСреднегоЗаработка();
	Для Каждого Строка Из Сотрудники Цикл
		НоваяСтрока = СведенияПоСотрудникам.Добавить();
		НоваяСтрока.Сотрудник = Строка.Сотрудник;
		НоваяСтрока.ДатаНачалаСобытия = Строка.ДатаУвольнения;
	КонецЦикла;
	
	УчетСреднегоЗаработка.ЗаписатьСведенияДокументаПоСотрудникам(Ссылка, СведенияПоСотрудникам);
	
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
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ПериодРегистрации);
	
КонецФункции

#КонецОбласти

#КонецЕсли
