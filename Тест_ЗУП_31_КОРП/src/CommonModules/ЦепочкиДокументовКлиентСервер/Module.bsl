
#Область СлужебныйПрограммныйИнтерфейс

Функция СтруктураНавигационнойСсылки(НавигационнаяСсылка) Экспорт 
	
	СтруктураСтроки = СтрРазделить(НавигационнаяСсылка, "%");
	Если СтруктураСтроки.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Новый Структура("Режим, ИмяМетаданных, НавигационнаяСсылка, ФормироватьПараметрыПоСсылке",
			СтруктураСтроки[0], СтруктураСтроки[1], СтруктураСтроки[2], ?(СтруктураСтроки[3] = "1", Истина, Ложь));
	КонецЕсли;

КонецФункции

#КонецОбласти