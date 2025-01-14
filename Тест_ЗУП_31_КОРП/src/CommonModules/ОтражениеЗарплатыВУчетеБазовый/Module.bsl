////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в учете
// Базовая реализация изменяемого поведения.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Создает временную таблицу с полями
//  ФизическоеЛицо
//  ДокументОснование.
//  Контрагент
//  Удержание
//
Процедура СоздатьВТУдержанияПоСотрудникамКонтрагент(МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УдержанияПоСотрудникам.ФизическоеЛицо,
	|	УдержанияПоСотрудникам.ДокументОснование,
	|	УдержанияПоСотрудникам.Удержание,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент
	|ПОМЕСТИТЬ ВТУдержанияПоСотрудникамКонтрагент
	|ИЗ
	|	ВТУдержанияПоСотрудникам КАК УдержанияПоСотрудникам";
	
	Запрос.Выполнить();

КонецПроцедуры

Функция ТипыПоляДокументОснование() Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.ОснованиеНачисленияУдержания.Тип.Типы();
	
КонецФункции

#КонецОбласти
