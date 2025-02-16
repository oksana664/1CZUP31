////////////////////////////////////////////////////////////////////////////////
// Подсистема "Статистика персонала".
// Процедуры и функции, предназначенные для обслуживания форм статистической отчетности.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает объект для хранения данных о численности
// Возвращаемое значение:
//	 Структура с полями
//		СреднесписочнаяЧисленностьРаботников,
//		СреднесписочнаяЧисленностьЖенщин,
//		СреднесписочнаяЧисленностьИнвалидов,
//		ЧисленностьРаботников,
//		ЧисленностьЖенщин,
//		ЧисленностьИнвалидов
Функция ДанныеОЧисленности() Экспорт
	Возврат Новый Структура(
		"СреднесписочнаяЧисленностьРаботников,СреднесписочнаяЧисленностьЖенщин,СреднесписочнаяЧисленностьИнвалидов,ЧисленностьРаботников,ЧисленностьЖенщин,ЧисленностьИнвалидов", 
		0, 0, 0, 0, 0, 0);
КонецФункции

// П-4

// Получает показатели, которые могут быть заполнены при заполнении отчета.
// 
// Параметры:
//  ПоказателиОтчета - структура
//
Процедура ОписаниеПоказателей_СтатистикаФормаП4_2013Кв1(ПоказателиОтчета) Экспорт
	
	СтатистикаПерсоналаВнутренний.ОписаниеПоказателей_СтатистикаФормаП4_2013Кв1(ПоказателиОтчета);
	
КонецПроцедуры

// Заполняет показатели отчета.
// 
// Параметры:
//  ПараметрыОтчета - структура.
//  Контейнер - структура - содержит все показатели отчета и их значения.
//
Процедура ЗначенияПоказателей_СтатистикаФормаП4_2013Кв1(ПараметрыОтчета, Контейнер) Экспорт
	
	СтатистикаПерсоналаВнутренний.ЗначенияПоказателей_СтатистикаФормаП4_2013Кв1(ПараметрыОтчета, Контейнер);
	
КонецПроцедуры

// Заполняет показатели отчета.
// 
// Параметры:
//  ПараметрыОтчета - структура.
//  Контейнер - структура - содержит все показатели отчета и их значения.
//
Процедура ЗначенияПоказателей_СтатистикаФормаП4_2017Кв1(ПараметрыОтчета, Контейнер) Экспорт
	
	СтатистикаПерсоналаВнутренний.ЗначенияПоказателей_СтатистикаФормаП4_2017Кв1(ПараметрыОтчета, Контейнер);
	
КонецПроцедуры

// П-4 (НЗ)

// Получает показатели, которые могут быть заполнены при заполнении отчета.
// 
// Параметры:
//  ПоказателиОтчета - структура
//
Процедура ОписаниеПоказателей_СтатистикаФормаП4НЗ_2015Кв1(ПоказателиОтчета) Экспорт
	
	СтатистикаПерсоналаВнутренний.ОписаниеПоказателей_СтатистикаФормаП4НЗ_2015Кв1(ПоказателиОтчета);
	
КонецПроцедуры

// Заполняет показатели отчета.
// 
// Параметры:
//  ПараметрыОтчета - структура.
//  Контейнер - структура - содержит все показатели отчета и их значения.
//
Процедура ЗначенияПоказателей_СтатистикаФормаП4НЗ_2015Кв1(ПараметрыОтчета, Контейнер) Экспорт
	
	СтатистикаПерсоналаВнутренний.ЗначенияПоказателей_СтатистикаФормаП4НЗ_2015Кв1(ПараметрыОтчета, Контейнер);
	
КонецПроцедуры

#КонецОбласти
