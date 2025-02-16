
#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму ОтветственныхЛиц
// 
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, форму ответственныхлиц которой нужно открыть.
//
Процедура ОткрытьФормуСведенийОтветственныхЛиц(Организация) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Организация);
	ПараметрыОткрытия.Вставить("ОрганизацияСсылка", Организация);
	
	ОткрытьФорму("ОбщаяФорма.ОрганизацияОтветственныеЛица", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
