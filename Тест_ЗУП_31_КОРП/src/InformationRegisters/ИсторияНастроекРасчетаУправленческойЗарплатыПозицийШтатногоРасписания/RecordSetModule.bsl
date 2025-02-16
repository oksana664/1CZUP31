#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИсторияНастроекРасчетаЗарплаты.ПозицияШтатногоРасписания,
		|	МАКСИМУМ(ИсторияНастроекРасчетаЗарплаты.Дата) КАК Дата
		|ПОМЕСТИТЬ ВТМаксимальныеДаты
		|ИЗ
		|	РегистрСведений.ИсторияНастроекРасчетаУправленческойЗарплатыПозицийШтатногоРасписания КАК ИсторияНастроекРасчетаЗарплаты
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияНастроекРасчетаЗарплаты.ПозицияШтатногоРасписания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсторияНастроекРасчетаЗарплаты.ПозицияШтатногоРасписания КАК Позиция,
		|	ИсторияНастроекРасчетаЗарплаты.ИспользоватьУправленческиеНачисления,
		|	ИсторияНастроекРасчетаЗарплаты.ДоначислятьДоУправленческогоУчета
		|ИЗ
		|	ВТМаксимальныеДаты КАК МаксимальныеДаты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияНастроекРасчетаУправленческойЗарплатыПозицийШтатногоРасписания КАК ИсторияНастроекРасчетаЗарплаты
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиРасчетаУправленческойЗарплатыПозицийШтатногоРасписания КАК НастройкиРасчетаЗарплаты
		|			ПО ИсторияНастроекРасчетаЗарплаты.ПозицияШтатногоРасписания = НастройкиРасчетаЗарплаты.Позиция
		|		ПО МаксимальныеДаты.ПозицияШтатногоРасписания = ИсторияНастроекРасчетаЗарплаты.ПозицияШтатногоРасписания
		|			И МаксимальныеДаты.Дата = ИсторияНастроекРасчетаЗарплаты.Дата
		|ГДЕ
		|	(ИсторияНастроекРасчетаЗарплаты.ИспользоватьУправленческиеНачисления <> ЕСТЬNULL(НастройкиРасчетаЗарплаты.ИспользоватьУправленческиеНачисления, ЛОЖЬ)
		|			ИЛИ ИсторияНастроекРасчетаЗарплаты.ДоначислятьДоУправленческогоУчета <> ЕСТЬNULL(НастройкиРасчетаЗарплаты.ДоначислятьДоУправленческогоУчета, ЛОЖЬ))";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = РегистрыСведений.НастройкиРасчетаУправленческойЗарплатыПозицийШтатногоРасписания.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Позиция.Установить(Выборка.Позиция);
			
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			
			НаборЗаписей.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли