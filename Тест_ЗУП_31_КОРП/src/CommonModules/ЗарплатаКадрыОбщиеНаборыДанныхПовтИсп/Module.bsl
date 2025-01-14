
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТекстОбщегоЗапроса(ИсточникДанных) Экспорт
	
	Возврат ЗарплатаКадрыОбщиеНаборыДанныхВнутренний.ПолучитьТекстОбщегоЗапроса(ИсточникДанных);
	
КонецФункции

Функция ПолучитьЗапросПоПредставлению(ТекстЗапроса, СоответствиеПараметров) Экспорт
	
	Возврат КонтейнерТекстаЗапросаИПараметров(
		ЗарплатаКадрыОбщиеНаборыДанныхВнутренний.ПолучитьЗапросПоПредставлению(ТекстЗапроса, СоответствиеПараметров));
	
КонецФункции

Функция КонтейнерТекстаЗапросаИПараметров(Запрос)
	
	Если Запрос = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Контейнер = Новый Структура;
	Контейнер.Вставить("Текст", Запрос.Текст);
	Контейнер.Вставить("Параметры", ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Запрос.Параметры));
	
	Возврат Контейнер;
	
КонецФункции

#КонецОбласти
