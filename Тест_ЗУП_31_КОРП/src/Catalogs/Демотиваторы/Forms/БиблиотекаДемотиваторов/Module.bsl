
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуДемотиваторов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДемотиваторы

&НаКлиенте
Процедура ДемотиваторыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеДемотиваторов(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыборВСпискеДемотиваторов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуДемотиваторов()
	
	БиблиотекаXML = Справочники.Демотиваторы.ПолучитьМакет("Библиотека").ПолучитьТекст();
	
	БиблиотекаТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаXML).Данные;
	
	Для Каждого ТекущаяСтрока Из БиблиотекаТаблица Цикл
		НоваяСтрока = Демотиваторы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки, ТекущаяСсылка)
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Демотиваторы[НомерСтроки];
		
		СтрокаВБазе = Справочники.Демотиваторы.НайтиПоНаименованию(ТекущиеДанные.Наименование, Истина);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.Демотиваторы.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Справочники.Демотиваторы.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		НоваяСтрока.Записать();
		
		Если НомерСтроки = Элементы.Демотиваторы.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеДемотиваторов(СтандартнаяОбработка = Неопределено)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСсылка = Неопределено;
	СохранитьВыбранныеСтроки(Элементы.Демотиваторы.ВыделенныеСтроки, ТекущаяСсылка);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлены демотиваторы'"));
	ОповеститьОВыборе(ТекущаяСсылка);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти