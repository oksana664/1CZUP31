#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Начальное заполнение и обновление информационной базы.
Процедура НачальноеЗаполнение() Экспорт
	Обновить(ПолучитьМакет("ПредопределенныеЗначения").ПолучитьТекст());
КонецПроцедуры

// Обновляет данные регистра.
Процедура Обновить(ТекстXML) Экспорт
	ЗарплатаКадры.ОбновитьКлассификатор(ТекстXML);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать процедуру НачальноеЗаполнение.
Процедура ЗаполнитьПредельнуюВеличинуБазыСтраховыхВзносов() Экспорт
	НачальноеЗаполнение();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли