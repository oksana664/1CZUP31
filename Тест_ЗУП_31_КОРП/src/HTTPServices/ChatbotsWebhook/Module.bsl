
Функция Any(Запрос)
	
	СтруктураОтвета = Чатботы.ОбработатьВходящийHTTPЗапрос(Запрос);
	
	HTTPОтвет = Новый HTTPСервисОтвет(СтруктураОтвета.КодСостояния);
	HTTPОтвет.Причина = СтруктураОтвета.Причина;
	
	Возврат HTTPОтвет;
	
КонецФункции