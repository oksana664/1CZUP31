#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ВзаиморасчетыССотрудникамиВызовСервераРасширенный.ВидыДокументовМежрасчетныхНачисленийОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ДоступныеПоМетаданным() Экспорт
	
	ДоступныеЗначения = Новый Массив;
	
	Для Каждого Значение Из Метаданные.Перечисления.ВидыДокументовМежрасчетныхНачислений.ЗначенияПеречисления Цикл
		Если Метаданные.Документы.Найти(Значение.Имя) <> Неопределено Тогда
			ДоступныеЗначения.Добавить(Перечисления.ВидыДокументовМежрасчетныхНачислений[Значение.Имя])
		КонецЕсли	
	КонецЦикла;
	
	Возврат ДоступныеЗначения
	
КонецФункции

Функция ДоступныеПоФункциональнымОпциям() Экспорт
	
	ДоступныеЗначения = Новый Массив;
	
	ДоступныеПоМетаданным = ДоступныеПоМетаданным();
	Для Каждого Значение Из Метаданные.Перечисления.ВидыДокументовМежрасчетныхНачислений.ЗначенияПеречисления Цикл
		Если Метаданные.Документы.Найти(Значение.Имя) <> Неопределено Тогда
			Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Метаданные.Документы[Значение.Имя]) Тогда
				ДоступныеЗначения.Добавить(Перечисления.ВидыДокументовМежрасчетныхНачислений[Значение.Имя])
			КонецЕсли	
		КонецЕсли	
	КонецЦикла;
	
	Возврат ДоступныеЗначения
	
КонецФункции

// Возвращает значение перечисления, соответствующее переданному документу.
// Параметр:
//	Документ - документ-объект или документ-ссылка.
//
// Возвращаемое значение:
//	значение перечисления ВидыДокументовМежрасчетныхНачислений.
//
Функция ПоДокументу(Документ) Экспорт
	
	ВидДокумента = Неопределено;
	
	ИмяДокумента = Документ.Метаданные().Имя;
	ИмяДокумента = СтрЗаменить(ИмяДокумента, "Списком", ""); // если "списком", то это тоже самое
		
	ЗначенияПеречисления = Метаданные.Перечисления.ВидыДокументовМежрасчетныхНачислений.ЗначенияПеречисления;
	ОбъектМетаданных = ЗначенияПеречисления.Найти(ИмяДокумента);
	Если ОбъектМетаданных <> Неопределено Тогда
		ИндексЗначения = ЗначенияПеречисления.Индекс(ОбъектМетаданных);
			Если ИндексЗначения <> -1 Тогда
				ВидДокумента = Перечисления.ВидыДокументовМежрасчетныхНачислений[ИндексЗначения];
			КонецЕсли	
	КонецЕсли;	
	
	Возврат ВидДокумента;
	
КонецФункции

#КонецОбласти

#КонецЕсли