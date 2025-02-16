
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Возвращает массив вид выплат, входящих в расчетную базу удержаний
//
Функция ВидыВыплатДополненияРасчетнойБазыУдержаний() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыВыплатБывшимСотрудникам.Ссылка КАК ВидВыплаты
	|ИЗ
	|	Справочник.ВидыВыплатБывшимСотрудникам КАК ВидыВыплатБывшимСотрудникам
	|ГДЕ
	|	ВидыВыплатБывшимСотрудникам.КодДоходаНДФЛ <> ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидВыплаты");
	
КонецФункции

// Возвращает массив видов выплат бывшим сотрудникам на период трудоустройства.
Функция ВидыВыплатНаПериодТрудоустройства() Экспорт
	Результат = Новый Массив;
	ДобавитьПредопределенныйВМассив(Результат, "Справочник.ВидыВыплатБывшимСотрудникам.СохраняемоеДенежноеСодержаниеНаПериодТрудоустройства");
	ДобавитьПредопределенныйВМассив(Результат, "Справочник.ВидыВыплатБывшимСотрудникам.СохраняемыйЗаработокНаВремяТрудоустройства");
	Возврат Результат;
КонецФункции

Процедура ДобавитьПредопределенныйВМассив(Массив, ИмяПредопределенного)
	Ссылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент(ИмяПредопределенного);
	Если Ссылка <> Неопределено Тогда
		Массив.Добавить(Ссылка);
	КонецЕсли;
КонецПроцедуры

Функция ОписаниеВидаВыплатБывшимСотрудникам()
	
	Возврат Новый Структура("
	|Наименование,
	|КодДоходаНДФЛ,
	|КодДоходаСтраховыеВзносы,
	|ПредопределенныйВидВыплатБывшимСотрудникам,
	|ИмяПредопределенныхДанных");
	
КонецФункции

Функция НовыйВидВыплатБывшимСотрудникам(ОписаниеВидаВыплатБывшимСотрудникам)
	
	ВидВыплатБывшимСотрудникамОбъект = Неопределено;
	Если ОписаниеВидаВыплатБывшимСотрудникам.ПредопределенныйВидВыплатБывшимСотрудникам Тогда 
		ВидВыплатБывшимСотрудникамСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыВыплатБывшимСотрудникам." + ОписаниеВидаВыплатБывшимСотрудникам.ИмяПредопределенныхДанных);
		Если ВидВыплатБывшимСотрудникамСсылка <> Неопределено Тогда 
			ВидВыплатБывшимСотрудникамОбъект = ВидВыплатБывшимСотрудникамСсылка.ПолучитьОбъект();
			Возврат ВидВыплатБывшимСотрудникамОбъект;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидВыплатБывшимСотрудникамОбъект = Неопределено Тогда 
		ВидВыплатБывшимСотрудникамОбъект = Справочники.ВидыВыплатБывшимСотрудникам.СоздатьЭлемент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВидВыплатБывшимСотрудникамОбъект, ОписаниеВидаВыплатБывшимСотрудникам);
	ВидВыплатБывшимСотрудникамОбъект.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат ВидВыплатБывшимСотрудникамОбъект;
	
КонецФункции

#Область БлокФункцийПервоначальногоЗаполненияИОбновленияИБ

// Процедура создает виды выплат бывшим сотрудникам
//
Процедура СоздатьВидыВыплатБывшимСотрудникам() Экспорт
	
	ОписаниеВидаВыплатБывшимСотрудникам = ОписаниеВидаВыплатБывшимСотрудникам();
	ОписаниеВидаВыплатБывшимСотрудникам.ПредопределенныйВидВыплатБывшимСотрудникам 	= Истина;
	ОписаниеВидаВыплатБывшимСотрудникам.ИмяПредопределенныхДанных	= "СохраняемыйЗаработокНаВремяТрудоустройства";
	ОписаниеВидаВыплатБывшимСотрудникам.Наименование				= НСтр("ru = 'Сохраняемый средний заработок на время трудоустройства'");
	ОписаниеВидаВыплатБывшимСотрудникам.КодДоходаСтраховыеВзносы	= Справочники.ВидыДоходовПоСтраховымВзносам.НеЯвляетсяОбъектом;
		
	НовыйВидВыплатБывшимСотрудникам(ОписаниеВидаВыплатБывшимСотрудникам);
	
КонецПроцедуры

// Процедура создает виды выплат бывшим сотрудникам в зависимости от настроек программы.
//
Процедура СоздатьВидыВыплатБывшимСотрудникамПоНастройкам() Экспорт
	
	НастройкиПрограммы = ЗарплатаКадрыРасширенный.НастройкиПрограммыБюджетногоУчреждения();
	
	Если НастройкиПрограммы.ИспользоватьРасчетСохраняемогоДенежногоСодержания Тогда
		
		// Сохраняемое денежное содержание на период трудоустройства
		ОписаниеВидаВыплатБывшимСотрудникам = ОписаниеВидаВыплатБывшимСотрудникам();
		ОписаниеВидаВыплатБывшимСотрудникам.ПредопределенныйВидВыплатБывшимСотрудникам 	= Истина;
		ОписаниеВидаВыплатБывшимСотрудникам.ИмяПредопределенныхДанных	= "СохраняемоеДенежноеСодержаниеНаПериодТрудоустройства";
		ОписаниеВидаВыплатБывшимСотрудникам.Наименование				= НСтр("ru = 'Сохраняемое денежное содержание на период трудоустройства'");
		ОписаниеВидаВыплатБывшимСотрудникам.КодДоходаСтраховыеВзносы	= Справочники.ВидыДоходовПоСтраховымВзносам.НеЯвляетсяОбъектом;
		
		НовыйВидВыплатБывшимСотрудникам(ОписаниеВидаВыплатБывшимСотрудникам);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
