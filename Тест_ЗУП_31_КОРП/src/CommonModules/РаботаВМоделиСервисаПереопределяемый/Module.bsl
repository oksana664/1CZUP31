#Область ПрограммныйИнтерфейс

// Вызывается при удалении области данных.
// В процедуре необходимо удалить данные области данных, которые не
// могут быть удалены стандартным механизмом.
//
// Параметры:
//   ОбластьДанных - Число - значение разделителя удаляемой области данных.
// 
Процедура ПриУдаленииОбластиДанных(Знач ОбластьДанных) Экспорт
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
//   ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ().
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	// РегламентированнаяОтчетность
	РаботаВМоделиСервисаБРО.ПолучитьТаблицуПараметровИБ(ТаблицаПараметров);
	// Конец РегламентированнаяОтчетность
	
КонецПроцедуры

// Вызывается перед попыткой получения значений параметров ИБ из одноименных
// констант.
//
// Параметры:
//   ИменаПараметров - Массив - имена параметров, значения которых необходимо получить.
//     В случае если значение параметра получается в данной процедуре, необходимо удалить имя обработанного параметра из
//     массива.
//   ЗначенияПараметров - Структура - значения параметров.
//
Процедура ПриПолученииЗначенийПараметровИБ(Знач ИменаПараметров, Знач ЗначенияПараметров) Экспорт
	
КонецПроцедуры

// Вызывается перед попыткой записи значений параметров ИБ в одноименные
// константы.
//
// Параметры:
//   ЗначенияПараметров - Структура - значения параметров которые требуется установить.
//     В случае если значение параметра устанавливается в данной процедуре из структуры необходимо удалить соответствую
//     пару КлючИЗначение.
//
Процедура ПриУстановкеЗначенийПараметровИБ(Знач ЗначенияПараметров) Экспорт
	
КонецПроцедуры

// Вызывается при включении разделения данных по областям данных,
// при первом запуске конфигурации с параметром "ИнициализироватьРазделеннуюИБ" ("InitializeSeparatedIB").
// 
// В частности, здесь следует размещать код по включению регламентных заданий, 
// используемых только при включенном разделении данных, 
// и соответственно, по выключению заданий, используемых только при выключенном разделении данных.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	ЗарплатаКадрыРасширенный.ПриВключенииРазделенияПоОбластямДанных();
КонецПроцедуры

// Устанавливает пользователю права по умолчанию.
// Вызывается при работе в модели сервиса, в случае обновления в менеджере
// сервиса прав пользователя без прав администрирования.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - пользователь, которому
//   требуется установить права по умолчанию.
//
Процедура УстановитьПраваПоУмолчанию(Пользователь) Экспорт
	
	ЗарплатаКадрыРасширенный.УстановитьПраваПоУмолчанию(Пользователь);
	
КонецПроцедуры

#КонецОбласти
