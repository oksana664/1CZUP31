
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		УстановитьБаллыОценкамПриСозданииНовой();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьБаллыОценкамПриСозданииНовой()
	
	Если НЕ ЗначениеЗаполнено(Владелец) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОценкиОбучения.Ссылка КАК Ссылка,
		|	ОценкиОбучения.Балл КАК Балл
		|ИЗ
		|	Справочник.ОценкиОбучения КАК ОценкиОбучения
		|ГДЕ
		|	ОценкиОбучения.Владелец = &Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	Балл УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ОценкиОбучения.Ссылка) КАК ВсегоОценок
		|ИЗ
		|	Справочник.ОценкиОбучения КАК ОценкиОбучения
		|ГДЕ
		|	ОценкиОбучения.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	РезультатЗапроса = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1];
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ВсегоОценок = Выборка.ВсегоОценок;
	
	Если ВсегоОценок = 0 Тогда
		Балл = 100;
		Возврат;
	КонецЕсли;
	
	ЦенаДеления = 100/ВсегоОценок;
	Счетчик = ВсегоОценок;
	
	Результат = РезультатыЗапроса[РезультатыЗапроса.Количество() - 2];
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбучениеРазвитие.УстановитьБаллОценкеОбучения(Выборка.Ссылка, Окр(ЦенаДеления * Счетчик, 0));
		Счетчик = Счетчик - 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли