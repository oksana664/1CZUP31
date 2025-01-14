#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КПП");
	КонецЕсли;
	
	РегламентированнаяОтчетность.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Оплаты", "Сотрудник"));
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, Дата);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбъектЗафиксирован() Экспорт
	Возврат НЕ ПрямыеВыплатыПособийСоциальногоСтрахования.СтатусПозволяетРедактироватьДокумент(СтатусДокумента);
КонецФункции

Функция ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеОплат = Истина, МассивОплат = Неопределено) Экспорт
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	ПараметрыФиксации = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Метаданные().ПолноеИмя()).ПараметрыФиксацииВторичныхДанных();
	
	Если ДанныеОрганизации И ОбновитьДанныеСтрахователя(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ДанныеОплат И ОбновитьДанныеОплат(ПараметрыФиксации, МассивОплат) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован
КонецФункции

Функция ОбновитьДанныеСтрахователя(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаРеквизиты = "РегистрационныйНомерФСС,ДополнительныйКодФСС,КодПодчиненностиФСС,НаименованиеТерриториальногоОрганаФСС,ИНН,КПП";
	СтрокаРеквизиты = СтрокаРеквизиты + ",Руководитель,ДолжностьРуководителя,ТелефонСоставителя,АдресОрганизации,АдресЭлектроннойПочтыОрганизации";
	СтрокаРеквизиты = СтрокаРеквизиты + ",НаименованиеБанка,НомерЛицевогоСчета,НомерСчета,БИКБанка";
	РеквизитыДокумента = Новый Структура(СтрокаРеквизиты);
	
	СтрокаРеквизитыОрганизации = "РегистрационныйНомерФСС, КодПодчиненностиФСС, ДополнительныйКодФСС, НаименованиеТерриториальногоОрганаФСС";
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, СтрокаРеквизитыОрганизации);
	
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, РеквизитыОрганизации, СтрокаРеквизитыОрганизации);
	
	ЗаполняемыеЗначения = Новый Структура("Организация,Руководитель,ДолжностьРуководителя,ГлавныйБухгалтер", Организация);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ЗаполняемыеЗначения.Свойство("Руководитель", РеквизитыДокумента.Руководитель);
	ЗаполняемыеЗначения.Свойство("ДолжностьРуководителя", РеквизитыДокумента.ДолжностьРуководителя);
	
	МассивОрганизаций = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организация);
	ДатаПолученияСведений = ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса());
	
	Сведения = Новый СписокЗначений;
	Сведения.Добавить("", "ИННЮЛ");
	Сведения.Добавить("", "КППЮЛ");
	Сведения.Добавить("", "БанкСчетНомер");
	Сведения.Добавить("", "БанкСчетНаимБанка");
	Сведения.Добавить("", "БанкСчетБИКБанка");
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДатаПолученияСведений, Сведения);
	ОргСведения.Свойство("ИННЮЛ", 					РеквизитыДокумента.ИНН);
	ОргСведения.Свойство("КППЮЛ", 					РеквизитыДокумента.КПП);
	ОргСведения.Свойство("БанкСчетНомер", 			РеквизитыДокумента.НомерСчета);
	ОргСведения.Свойство("БанкСчетНаимБанка", 		РеквизитыДокумента.НаименованиеБанка);
	ОргСведения.Свойство("БанкСчетБИКБанка", 		РеквизитыДокумента.БИКБанка);
	
	АдресаОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		МассивОрганизаций,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
		ДатаПолученияСведений);
	Если АдресаОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.АдресОрганизации = АдресаОрганизации[0].ЗначенияПолей;
	Иначе
		РеквизитыДокумента.АдресОрганизации = "";
	КонецЕсли;
	
	ТелефоныОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		МассивОрганизаций,
		Перечисления.ТипыКонтактнойИнформации.Телефон,
		Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации,
		ДатаПолученияСведений);
	Если ТелефоныОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.ТелефонСоставителя = ТелефоныОрганизации[0].ЗначенияПолей;
	Иначе
		РеквизитыДокумента.ТелефонСоставителя = "";
	КонецЕсли;
	
	АдресаЭлектроннойПочтыОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		МассивОрганизаций,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
		Справочники.ВидыКонтактнойИнформации.EmailОрганизации,
		ДатаПолученияСведений);
	Если АдресаЭлектроннойПочтыОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.АдресЭлектроннойПочтыОрганизации = АдресаЭлектроннойПочтыОрганизации[0].Представление;
	Иначе
		РеквизитыДокумента.АдресЭлектроннойПочтыОрганизации = "";
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ОбновитьДанныеОплат(ПараметрыФиксации, МассивОплат)
	ДанныеОплат = ПрямыеВыплатыПособийСоциальногоСтрахования.ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(ЭтотОбъект);
	Если ДанныеОплат = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДанныеОплат", ДанныеОплат.Выгрузить());
	Запрос.УстановитьПараметр("МассивОплат", ?(МассивОплат = Неопределено, Оплаты.Выгрузить().ВыгрузитьКолонку("ДокументОснование"), МассивОплат));
	
	ОписаниеФиксацииРеквизитов = ПараметрыФиксации.ОписаниеФиксацииРеквизитов;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеСтрок.ДокументОснование КАК ДокументОснование,";
	Для каждого ОписаниеРеквизита Из ОписаниеФиксацииРеквизитов Цикл
		Если ОписаниеРеквизита.Значение.ИмяГруппы <> "Оплаты" Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + "
		|	ДанныеСтрок." + ОписаниеРеквизита.Значение.ИмяРеквизита + " КАК " + ОписаниеРеквизита.Значение.ИмяРеквизита + ",";
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТВторичныеДанные
	|ИЗ
	|	&ДанныеОплат КАК ДанныеСтрок
	|ГДЕ
	|	ДанныеСтрок.ДокументОснование В(&МассивОплат)";
	
	Запрос.Выполнить();
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, "Оплаты");
КонецФункции

Процедура ЗаполнитьДокумент() Экспорт
	Оплаты.Очистить();
	
	ДанныеОплат = ПрямыеВыплатыПособийСоциальногоСтрахования.ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(ЭтотОбъект);
	
	Если ДанныеОплат <> Неопределено Тогда
		Оплаты.Загрузить(ДанныеОплат.Выгрузить());
	КонецЕсли;
КонецПроцедуры

Функция ДанныеСтроки(ДокументОснование = Неопределено) Экспорт
	Данные = ПрямыеВыплатыПособийСоциальногоСтрахования.ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(ЭтотОбъект, ДокументОснование);
	
	ДанныеСтроки = Данные.Выбрать();
	Если ДанныеСтроки.Следующий() Тогда
		Возврат ДанныеСтроки
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#КонецЕсли
