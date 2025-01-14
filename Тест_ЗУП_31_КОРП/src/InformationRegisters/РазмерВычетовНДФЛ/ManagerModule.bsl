#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начальное заполнение и обновление информационной базы.
Процедура НачальноеЗаполнение() Экспорт
	Обновить(ПолучитьМакет("ПредопределенныеЗначения").ПолучитьТекст());
КонецПроцедуры

// Обновляет данные регистра.
Процедура Обновить(ТекстXML) Экспорт
	Если ЗарплатаКадры.ОбновитьКлассификатор(ТекстXML) Тогда
		РегистрыСведений.РазмерВычетовНДФЛВторичный.ЗаполнитьВторичныеДанные();
	КонецЕсли;
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать процедуру НачальноеЗаполнение.
Процедура ЗаполнитьРазмерыВычетовНДФЛ() Экспорт
	НачальноеЗаполнение();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли