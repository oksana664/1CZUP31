
#Область ПрограммныйИнтерфейс

// Заполняет дерево критериев оценки формы справочника
//
// Параметры 
//	КритерииОценкиДерево - ДанныеФормыДерево - дерево критериев оценки формы вопроса для собеседования. 
//	Ссылка - СправочникСсылка.ВопросыДляСобеседования - ссылка на вопрос для собеседования.
//
Процедура ЗаполнитьДеревоФормы(КритерииОценкиДерево, Ссылка) Экспорт 
	
	КритерииОценкиДерево.ПолучитьЭлементы().Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВопросыДляСобеседованияКлючевыеВопросы.ЭлементарныйВопрос КАК ЭлементарныйВопрос,
		|	ВопросыДляСобеседованияКлючевыеВопросы.ЭлементарныйВопрос.Формулировка КАК ЭлементарныйВопросНаименование,
		|	ВопросыДляСобеседованияКлючевыеВопросы.НомерСтроки КАК НомерСтроки,
		|	ВариантыОтветовАнкет.Ссылка КАК Ответ,
		|	ВариантыОтветовАнкет.Наименование КАК ОтветНаименование,
		|	ВариантыОтветовАнкет.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
		|	ВопросыДляСобеседованияКлючевыеВопросы.Предопределенный КАК Предопределенный,
		|	ВопросыДляСобеседованияКлючевыеВопросы.ЭлементарныйВопрос.ТребуетсяКомментарий КАК ТребуетсяКомментарий,
		|	ВопросыДляСобеседованияКлючевыеВопросы.ЭлементарныйВопрос.ПояснениеКомментария КАК ПояснениеКомментария
		|ИЗ
		|	Справочник.ВопросыДляСобеседования.КлючевыеВопросы КАК ВопросыДляСобеседованияКлючевыеВопросы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтветовАнкет КАК ВариантыОтветовАнкет
		|		ПО ВопросыДляСобеседованияКлючевыеВопросы.ЭлементарныйВопрос = ВариантыОтветовАнкет.Владелец
		|			И (НЕ ВариантыОтветовАнкет.ПометкаУдаления)
		|ГДЕ
		|	ВопросыДляСобеседованияКлючевыеВопросы.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки,
		|	РеквизитДопУпорядочивания
		|ИТОГИ ПО
		|	ЭлементарныйВопрос";
	
	Выборка0 = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка0.Следующий() Цикл
		НоваяСтрока0 = КритерииОценкиДерево.ПолучитьЭлементы().Добавить();
		НоваяСтрока0.Наименование = Выборка0.ЭлементарныйВопросНаименование;
		НоваяСтрока0.ЭлементарныйВопрос = Выборка0.ЭлементарныйВопрос;
		НоваяСтрока0.Уровень = 0;
		НоваяСтрока0.Предопределенный = Выборка0.Предопределенный;
		НоваяСтрока0.ТребуетсяКомментарий = Выборка0.ТребуетсяКомментарий;
		НоваяСтрока0.ПояснениеКомментария = Выборка0.ПояснениеКомментария;
				
		Выборка1 = Выборка0.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Порядок = 1;
		Пока Выборка1.Следующий() Цикл
			Если ЗначениеЗаполнено(Выборка1.Ответ) Тогда
				НоваяСтрока1 = НоваяСтрока0.ПолучитьЭлементы().Добавить();
				НоваяСтрока1.Наименование = Выборка1.ОтветНаименование;
				НоваяСтрока1.Ответ = Выборка1.Ответ;
				НоваяСтрока1.Уровень = 1;
				НоваяСтрока1.Порядок = Порядок;
				НоваяСтрока1.Предопределенный = Выборка1.Предопределенный;
				НоваяСтрока0.Предопределенный = Выборка1.Предопределенный;
				СтруктураПоиска = Новый Структура;
				СтруктураПоиска.Вставить("ЭлементарныйВопрос", НоваяСтрока0.ЭлементарныйВопрос);
				СтруктураПоиска.Вставить("ОтветНаВопрос", Выборка1.Ответ);
				Массив = Ссылка.Ключи.НайтиСтроки(СтруктураПоиска);
				НоваяСтрока1.КоличествоКлючей = Массив.Количество();
			КонецЕсли;
			Порядок = Порядок + 1;
		КонецЦикла;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти
