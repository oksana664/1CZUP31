
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗакрыватьПриВыборе = Ложь;
	ЗаполнитьТаблицуМотиваторов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМотиваторы

&НаКлиенте
Процедура МотиваторыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеМотиваторов(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыборВСпискеМотиваторов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуМотиваторов()
	
	БиблиотекаXML = Справочники.Мотиваторы.ПолучитьМакет("Библиотека").ПолучитьТекст();
	
	БиблиотекаТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(БиблиотекаXML).Данные;
	
	Для Каждого ТекущаяСтрока Из БиблиотекаТаблица Цикл
		НоваяСтрока = Мотиваторы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки, ТекущаяСсылка)
	
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Мотиваторы[НомерСтроки];
		
		СтрокаВБазе = Справочники.Мотиваторы.НайтиПоНаименованию(ТекущиеДанные.Наименование, Истина);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.Мотиваторы.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Справочники.Мотиваторы.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
		НоваяСтрока.Записать();
		
		Если НомерСтроки = Элементы.Мотиваторы.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = НоваяСтрока.Ссылка;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеМотиваторов(СтандартнаяОбработка = Неопределено)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСсылка = Неопределено;
	СохранитьВыбранныеСтроки(Элементы.Мотиваторы.ВыделенныеСтроки, ТекущаяСсылка);
	ПоказатьОповещениеПользователя(НСтр("ru = 'Добавлены мотиваторы'"));
	ОповеститьОВыборе(ТекущаяСсылка);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти