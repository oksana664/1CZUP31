
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Вакансии") 
		И Параметры.Свойство("Сайт") Тогда
		
		Сайт = Параметры.Сайт;
		Вакансии = Новый ФиксированныйМассив(Параметры.Вакансии);
		
		ОбновитьДерево(Сайт);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДерева

&НаКлиенте
Процедура ДеревоВакансийПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоВакансий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДочерниеЭлементы = ТекущиеДанные.ПолучитьЭлементы();
	
	Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
		ДочернийЭлемент.Пометка = ТекущиеДанные.Пометка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВакансийВакансияВПрограммеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоВакансий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДочерниеЭлементы = ТекущиеДанные.ПолучитьЭлементы();
	
	Если ДочерниеЭлементы.Количество() > 0 Тогда
		
		Вакансия = ТекущиеДанные.ВакансияВПрограмме;
		
		Если ЗначениеЗаполнено(Вакансия) Тогда
			
			СтруктураВакансии = РеквизитыВакансииНаСервере(Вакансия);
			
			Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
				ДочернийЭлемент.ВакансияВПрограмме = СтруктураВакансии[ДочернийЭлемент.Путь];
			КонецЦикла;
			
		Иначе
			
			ОписаниеВакансии = Неопределено;
			Для Каждого ЭлементМассиваВакансии Из Вакансии Цикл
				Если Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.HeadHunter() Тогда
					Если ЭлементМассиваВакансии.Получить("id") = ТекущиеДанные.Путь Тогда
						ОписаниеВакансии = ЭлементМассиваВакансии;
						Прервать;
					КонецЕсли;
				ИначеЕсли Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.Rabota() Тогда
					Если  Формат(ЭлементМассиваВакансии.id, "ЧГ=") = ТекущиеДанные.Путь Тогда
						ОписаниеВакансии = ЭлементМассиваВакансии;
						Прервать;
					КонецЕсли;
				ИначеЕсли Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.SuperJob() Тогда
					Если ЭлементМассиваВакансии.id = ТекущиеДанные.Путь Тогда
						ОписаниеВакансии = ЭлементМассиваВакансии;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если Не ЗначениеЗаполнено(ОписаниеВакансии) Тогда
				Возврат;
			КонецЕсли;
			
			Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
				ДочернийЭлемент.ВакансияВПрограмме = РеквизитПубликацииСоответствующийРеквизитуВакансии(Сайт, ОписаниеВакансии, ДочернийЭлемент.Путь);
				ДочернийЭлемент.Пометка = Истина;
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗагрузить(Команда)
	
	Если ЗагрузитьВакансииНаСервере() Тогда
		
		Оповестить("ЗагруженыВакансии");
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьСнятьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьСнятьФлажки(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОпубликованныеВакансииСИдентификаторами(Сайт)
	
	Возврат ИнтеграцияРекрутинговыхСайтов.ОпубликованныеВакансииСИдентификаторами(Сайт);
	
КонецФункции

&НаСервере
Процедура ОбновитьДерево(Сайт)
	
	СтруктураДанныхВакансии = Справочники.Вакансии.СтруктураДанныхВакансии();
	СоответствиеИмениИСинонимаРеквизитовВакансий = Справочники.Вакансии.СоответствиеИмениИСинонимаРеквизитовВакансий();
	ЗагружаемыеРеквизиты = ИнтеграцияРекрутинговыхСайтов.ЗагружаемыеРеквизитыВакансии(Сайт);
	
	ОпубликованныеВакансииСИдентификаторами = ОпубликованныеВакансииСИдентификаторами(Сайт);
	
	Дерево = РеквизитФормыВЗначение("ДеревоВакансий");
	
	Для Каждого Вакансия Из Вакансии Цикл
		
		Если Вакансия = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаДерева = Дерево.Строки.Добавить();
		Если Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.HeadHunter() Тогда
			НоваяСтрокаДерева.ВакансияСайт = Вакансия.Получить("name");
			НоваяСтрокаДерева.Адрес = Вакансия.Получить("alternate_url");
			НоваяСтрокаДерева.Путь = Формат(Вакансия.Получить("id"), "ЧГ=0");
		ИначеЕсли Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.Rabota() Тогда
			НоваяСтрокаДерева.ВакансияСайт = Вакансия.name;
			НоваяСтрокаДерева.Адрес = Вакансия.link;
			НоваяСтрокаДерева.Путь = Формат(Вакансия.id, "ЧГ=0");
		ИначеЕсли Сайт = ИнтеграцияРекрутинговыхСайтовКлиентСервер.SuperJob() Тогда
			НоваяСтрокаДерева.ВакансияСайт = Вакансия.profession;
			НоваяСтрокаДерева.Адрес = Вакансия.link;
			НоваяСтрокаДерева.Путь = Формат(Вакансия.id, "ЧГ=0");
		КонецЕсли;
		
		СтрокаОпубликованнойВакансии = ОпубликованныеВакансииСИдентификаторами.Найти(Формат(НоваяСтрокаДерева.Путь, "ЧГ=0"), "ИдентификаторВакансии");
		Если СтрокаОпубликованнойВакансии <> Неопределено Тогда
			НоваяСтрокаДерева.ВакансияВПрограмме = СтрокаОпубликованнойВакансии.Вакансия;
		Иначе
			НоваяСтрокаДерева.ВакансияВПрограмме = Справочники.Вакансии.ПустаяСсылка();
			НоваяСтрокаДерева.Пометка = Истина;
		КонецЕсли;
		
		Для Каждого РеквизитВакансии Из СтруктураДанныхВакансии Цикл
			
			СтрокаПоляВакансии = НоваяСтрокаДерева.Строки.Добавить();
			СтрокаПоляВакансии.ВакансияСайт = СоответствиеИмениИСинонимаРеквизитовВакансий.Получить(РеквизитВакансии.Ключ);
			СтрокаПоляВакансии.Путь = РеквизитВакансии.Ключ;
			
			Если СтрокаОпубликованнойВакансии <> Неопределено Тогда
				СтрокаПоляВакансии.ВакансияВПрограмме = СтрокаОпубликованнойВакансии[РеквизитВакансии.Ключ];
			Иначе
				СтрокаПоляВакансии.ВакансияВПрограмме = РеквизитПубликацииСоответствующийРеквизитуВакансии(Сайт, Вакансия, РеквизитВакансии.Ключ);
				
				Если Не (Не ЗначениеЗаполнено(СтрокаПоляВакансии.ВакансияВПрограмме) 
					И (СтрокаПоляВакансии.Путь = "Условия"
					Или СтрокаПоляВакансии.Путь = "Требования"
					Или СтрокаПоляВакансии.Путь = "Обязанности")) Тогда
					СтрокаПоляВакансии.Пометка = Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			СтрокаПоляВакансии.Загружаемый = ЗагружаемыеРеквизиты.Найти(РеквизитВакансии.Ключ) <> Неопределено;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоВакансий");
	
КонецПроцедуры

&НаСервере
Функция РеквизитПубликацииСоответствующийРеквизитуВакансии(Сайт, Вакансия, Реквизит)
	
	Возврат ИнтеграцияРекрутинговыхСайтов.РеквизитПубликацииСоответствующийРеквизитуВакансии(Сайт, Вакансия, Реквизит);
	
КонецФункции

&НаСервере
Функция РеквизитыВакансииНаСервере(Вакансия) 
	
	СтруктураДанныхВакансии = Справочники.Вакансии.СтруктураДанныхВакансии();
	РеквизитыВакансии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Вакансия, СтруктураДанныхВакансии);
	
	Возврат РеквизитыВакансии;
	
КонецФункции

&НаСервере
Функция ЗагрузитьВакансииНаСервере()
	
	Дерево = РеквизитФормыВЗначение("ДеревоВакансий");
	Если Не ПроверитьЗаполнениеПолей(Дерево) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
	
		ЗагрузкаПрошлаУспешно = Истина;
		
		СтруктураДанныхВакансии = Справочники.Вакансии.СтруктураДанныхВакансии();
		
		Для Каждого СтрокаВакансия Из Дерево.Строки Цикл
			
			Если Не СтрокаВакансия.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаВакансия.ВакансияВПрограмме) Тогда
				НоваяВакансия = СтрокаВакансия.ВакансияВПрограмме.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(СтруктураДанныхВакансии, НоваяВакансия);
			Иначе
				НоваяВакансия = Справочники.Вакансии.СоздатьЭлемент();
			КонецЕсли;
			
			Для Каждого ПодчиненнаяСтрока Из СтрокаВакансия.Строки Цикл 
				Если ПодчиненнаяСтрока.Пометка Тогда
					СтруктураДанныхВакансии[ПодчиненнаяСтрока.Путь] = ПодчиненнаяСтрока.ВакансияВПрограмме;
				КонецЕсли;
			КонецЦикла;
			
			НоваяВакансия.Заполнить(СтруктураДанныхВакансии);
			Если Не ЗначениеЗаполнено(НоваяВакансия.Код) Тогда
				НоваяВакансия.УстановитьНовыйКод();
			КонецЕсли;
			
			Если НоваяВакансия.ПроверитьЗаполнение() Тогда
				НоваяВакансия.Записать();
				ИнтеграцияРекрутинговыхСайтов.ЗаписьВРегистрИнформацииОПубликации(НоваяВакансия.Ссылка, Сайт, СтрокаВакансия.Путь, СтрокаВакансия.Адрес);  
				ИнтеграцияРекрутинговыхСайтов.ЗаписьВРегистрДанныеПубликацииВакансий(Вакансии, НоваяВакансия.Ссылка, Сайт, СтрокаВакансия.Путь);
			Иначе
				ЗагрузкаПрошлаУспешно = Ложь;
			КонецЕсли;
		
		КонецЦикла;
		
		Если ЗагрузкаПрошлаУспешно Тогда
			ЗафиксироватьТранзакцию();
		Иначе
			ОтменитьТранзакцию();
		КонецЕсли;
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка при записи вакансии'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()) + " " + НоваяВакансия,
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение НСтр("ru = 'Ошибка при записи вакансии'") + " " + НоваяВакансия;
		
	КонецПопытки;
	
	Возврат ЗагрузкаПрошлаУспешно;
	
КонецФункции

&НаКлиенте
Процедура УстановитьСнятьФлажки(Пометка)
	
	Для Каждого СтрокаВакансии Из ДеревоВакансий.ПолучитьЭлементы() Цикл
		
		СтрокаВакансии.Пометка = Пометка;
		Для Каждого ПодчиненнаяСтрока Из СтрокаВакансии.ПолучитьЭлементы() Цикл
			ПодчиненнаяСтрока.Пометка = Пометка;
		КонецЦикла;
		
	КонецЦикла
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор, "ДеревоВакансий.Загружаемый", Истина);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВакансийВакансияСайт.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВакансийВакансияВПрограмме.Имя);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеПолей(Дерево)
	
	Отказ = Ложь;
	
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		
		Если Не СтрокаДерева.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаДереваПодчиненная Из СтрокаДерева.Строки Цикл
			
			Если СтрокаДереваПодчиненная.Пометка
				И Не ЗначениеЗаполнено(СтрокаДереваПодчиненная.ВакансияВПрограмме) Тогда
				
				ТекстСообщения = НСтр("ru = 'Заполните поле ""%1"" для вакансии ""%2"".'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаДереваПодчиненная.ВакансияСайт, СтрокаДерева.ВакансияСайт);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти