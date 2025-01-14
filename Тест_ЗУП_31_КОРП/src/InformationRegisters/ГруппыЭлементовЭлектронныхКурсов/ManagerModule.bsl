#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ГруппаДляХраненияПодчиненныхЭлементов(Знач ЭлектронныйКурс, ТипПодчиненногоЭлемента) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЭлектронныйКурс)
		ИЛИ НЕ ЗначениеЗаполнено(ТипПодчиненногоЭлемента) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	// Определяем тип группы
	
	Если ТипЗнч(ТипПодчиненногоЭлемента) = Тип("Строка") Тогда
		ТипПодчиненногоЭлемента = Тип(ТипПодчиненногоЭлемента);
	КонецЕсли;
	
	Если ТипЗнч(ТипПодчиненногоЭлемента) = Тип("ОписаниеТипов") Тогда
		
		МассивТипов = ТипПодчиненногоЭлемента.Типы();
		
		Если МассивТипов.Количество() = 0 ИЛИ МассивТипов.Количество() > 1 Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ТипПодчиненногоЭлемента = МассивТипов[0];
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГруппыЭлементовЭлектронныхКурсов.Группа КАК Группа
		|ИЗ
		|	РегистрСведений.ГруппыЭлементовЭлектронныхКурсов КАК ГруппыЭлементовЭлектронныхКурсов
		|ГДЕ
		|	ГруппыЭлементовЭлектронныхКурсов.ЭлектронныйКурс = &ЭлектронныйКурс
		|	И ТИПЗНАЧЕНИЯ(ГруппыЭлементовЭлектронныхКурсов.Группа) = &Тип";

	Запрос.УстановитьПараметр("Тип", ТипПодчиненногоЭлемента);
	Запрос.УстановитьПараметр("ЭлектронныйКурс", ЭлектронныйКурс);

	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		
		Возврат Неопределено;
		
	Иначе
		ВыборкаДетальныеЗаписи = Результат.Выбрать();

		ВыборкаДетальныеЗаписи.Следующий();
		
		Возврат ВыборкаДетальныеЗаписи.Группа;
		
	КонецЕсли;
	
КонецФункции

Процедура СохранитьГруппуДляХраненияПодчиненныхЭлементов(Знач ЭлектронныйКурс, Знач Группа) Экспорт
	
	НаборЗаписей = РегистрыСведений.ГруппыЭлементовЭлектронныхКурсов.СоздатьНаборЗаписей();
		
	НаборЗаписей.Отбор.ЭлектронныйКурс.Установить(ЭлектронныйКурс);
	НаборЗаписей.Отбор.Группа.Установить(Группа);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	
	НоваяЗапись.ЭлектронныйКурс = ЭлектронныйКурс;
	НоваяЗапись.Группа = Группа;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ВсеГруппыЭлектронногоКурса(Знач ЭлектронныйКурс) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыЭлементовЭлектронныхКурсов.Группа КАК Группа
		|ИЗ
		|	РегистрСведений.ГруппыЭлементовЭлектронныхКурсов КАК ГруппыЭлементовЭлектронныхКурсов
		|ГДЕ
		|	ГруппыЭлементовЭлектронныхКурсов.ЭлектронныйКурс = &ЭлектронныйКурс";
	
	Запрос.УстановитьПараметр("ЭлектронныйКурс", ЭлектронныйКурс);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Группа");
	
КонецФункции

#КонецОбласти

#КонецЕсли