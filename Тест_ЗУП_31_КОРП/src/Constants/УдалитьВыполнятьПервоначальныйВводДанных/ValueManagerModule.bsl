#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ЭтотОбъект.Значение И Константы.ВыполнятьНачальнуюНастройкуПрограммы.Получить() Тогда
		Константы.ВыполнятьНачальнуюНастройкуПрограммы.Установить(Ложь);
	КонецЕсли;
	Константы.НеВыполнятьНачальнуюНастройкуПрограммы.Установить(Не ЭтотОбъект.Значение И Не Константы.ВыполнятьНачальнуюНастройкуПрограммы.Получить());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли