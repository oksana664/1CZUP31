#Область ПрограммныйИнтерфейс

// Дозаполнение параметров структуры с настройками.
//
// Параметры:
//   Настройки - Структура - Описание в ОМ.РезервОтпусков.НастройкиРезервовОтпусков().
//   Организация - Спр.Организации.СправочникСсылка - Организация.
//   Период - Дата - Период дат.
//
Процедура ЗаполнитьНастройкиРезервовОтпусков(Настройки, Организация, Период) Экспорт
	
	
	
КонецПроцедуры

// Уточняет необходимость выполнять расчет резервов, устанавливается в Ложь, 
// когда резервы рассчитываются в другой программе.
//
// Параметры:
//	РезервыРассчитываются - тип булево.
//
Процедура ПолучитьЗначениеРезервыРассчитываются(РезервыРассчитываются) Экспорт
	
	
КонецПроцедуры

// Уточняет возможность использования автоматического расчета резервов, 
// устанавливается в Ложь, когда авторасчет резервов отключен.
//
// Возвращаемой значение:
//	Сведения об использовании авторасчета - тип булево.
//
Функция РезервыРассчитываютсяАвтоматически() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Процедура предназначена для формирования движений по месту внедрения.
//
// Параметры:
//	Объект - конкретный экземпляр документа Начисление оценочных обязательств по отпускам (ДокументОбъект.НачислениеОценочныхОбязательствПоОтпускам)
//	Отказ  - булево, признак отказа от проведения документа.
//	РежимПроведения - режим проведения документа.
//
Процедура СформироватьДвижения(Объект, Отказ, РежимПроведения) Экспорт

КонецПроцедуры

// Процедура предназначена для дополнения таблицы параметров данными об остатках отпусков 
// и ФОТ с учетом специфики места внедрения.
//
// Параметры:
//   Организация - Спр.Организации.СправочникСсылка - Организация.
//   Период - Дата - Период дат.
//   ОстаткиОтпусков - таблица значений.
//		Структура таблицы ОстаткиОтпусков.
//			Организация
//			Подразделение
//			МестоВСтруктуреПредприятия
//			Сотрудник
//			СпособОтраженияЗарплатыВБухучете
//			СтатьяФинансирования
//			ОблагаетсяЕНВД
//			ОстатокОтпусков
//			СреднийЗаработок
//
Процедура ДополнитьТаблицуОстатковОтпусков(Организация, Период, ОстаткиОтпусков) Экспорт
	
КонецПроцедуры

#КонецОбласти

