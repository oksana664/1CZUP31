#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПараметрыПериодовСтажаПФР.ГоловнаяОрганизация,
	|	ПараметрыПериодовСтажаПФР.ФизическоеЛицо,
	|	ПараметрыПериодовСтажаПФР.ТипДоговора,
	|	ПараметрыПериодовСтажаПФР.Начало,
	|	ПараметрыПериодовСтажаПФР.Окончание,
	|	ПараметрыПериодовСтажаПФР.Приоритет,
	|	ПараметрыПериодовСтажаПФР.Сторно,
	|	ПараметрыПериодовСтажаПФР.ДокументОснование,
	|	ПараметрыПериодовСтажаПФР.ВидСтажаПФР,
	|	ПараметрыПериодовСтажаПФР.Организация,
	|	ПараметрыПериодовСтажаПФР.Подразделение,
	|	ПараметрыПериодовСтажаПФР.ДолжностьПоШтатномуРасписанию,
	|	ПараметрыПериодовСтажаПФР.ГрафикРаботы,
	|	ПараметрыПериодовСтажаПФР.Должность,
	|	ПараметрыПериодовСтажаПФР.КоличествоСтавок,
	|	ПараметрыПериодовСтажаПФР.ТерриториальныеУсловия,
	|	ПараметрыПериодовСтажаПФР.ОсобыеУсловияТруда,
	|	ПараметрыПериодовСтажаПФР.ОснованиеВыслугиЛет,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаВидСтажаПФР,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаОрганизация,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаПодразделение,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаДолжностьПоШтатномуРасписанию,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаДолжность,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаГрафикРаботы,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаКоличествоСтавок,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаТерриториальныеУсловия,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаОсобыеУсловияТруда,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаОснованиеВыслугиЛет,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаТерритория,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаУсловияТруда,
	|	ПараметрыПериодовСтажаПФР.Территория,
	|	ПараметрыПериодовСтажаПФР.УсловияТруда,
	|	ПараметрыПериодовСтажаПФР.Сотрудник,
	|	ПараметрыПериодовСтажаПФР.ВнутреннееСовместительство,
	|	ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаВнутреннееСовместительство
	|ПОМЕСТИТЬ ВТПредыдущиеДанныеРегистра
	|ИЗ
	|	РегистрСведений.ПараметрыПериодовСтажаПФР КАК ПараметрыПериодовСтажаПФР
	|ГДЕ
	|	ПараметрыПериодовСтажаПФР.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;	

	Если Не ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СравнениеСПредыдущимНабором.ГоловнаяОрганизация,
	|	СравнениеСПредыдущимНабором.ФизическоеЛицо,
	|	СравнениеСПредыдущимНабором.ТипДоговора,
	|	СравнениеСПредыдущимНабором.Начало,
	|	СравнениеСПредыдущимНабором.Окончание,
	|	СравнениеСПредыдущимНабором.Приоритет,
	|	СравнениеСПредыдущимНабором.Сторно,
	|	СравнениеСПредыдущимНабором.ДокументОснование,
	|	СравнениеСПредыдущимНабором.ВидСтажаПФР,
	|	СравнениеСПредыдущимНабором.Организация,
	|	СравнениеСПредыдущимНабором.Подразделение,
	|	СравнениеСПредыдущимНабором.ДолжностьПоШтатномуРасписанию,
	|	СравнениеСПредыдущимНабором.ГрафикРаботы,
	|	СравнениеСПредыдущимНабором.Должность,
	|	СравнениеСПредыдущимНабором.КоличествоСтавок,
	|	СравнениеСПредыдущимНабором.ТерриториальныеУсловия,
	|	СравнениеСПредыдущимНабором.ОсобыеУсловияТруда,
	|	СравнениеСПредыдущимНабором.ОснованиеВыслугиЛет,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаВидСтажаПФР,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаОрганизация,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаПодразделение,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаДолжностьПоШтатномуРасписанию,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаДолжность,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаГрафикРаботы,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаКоличествоСтавок,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаТерриториальныеУсловия,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаОсобыеУсловияТруда,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаОснованиеВыслугиЛет,
	|	СУММА(СравнениеСПредыдущимНабором.ФлагИзменений) КАК ФлагИзменений,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаТерритория,
	|	СравнениеСПредыдущимНабором.УсловияТруда,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаУсловияТруда,
	|	СравнениеСПредыдущимНабором.Территория,
	|	СравнениеСПредыдущимНабором.Сотрудник,
	|	СравнениеСПредыдущимНабором.ВнутреннееСовместительство,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаВнутреннееСовместительство
	|ПОМЕСТИТЬ ВТИзменившиесяДанные
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПредыдущиеДанныеРегистра.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|		ПредыдущиеДанныеРегистра.ФизическоеЛицо КАК ФизическоеЛицо,
	|		ПредыдущиеДанныеРегистра.ТипДоговора КАК ТипДоговора,
	|		ПредыдущиеДанныеРегистра.Начало КАК Начало,
	|		ПредыдущиеДанныеРегистра.Окончание КАК Окончание,
	|		ПредыдущиеДанныеРегистра.Приоритет КАК Приоритет,
	|		ПредыдущиеДанныеРегистра.Сторно КАК Сторно,
	|		ПредыдущиеДанныеРегистра.ДокументОснование КАК ДокументОснование,
	|		ПредыдущиеДанныеРегистра.ВидСтажаПФР КАК ВидСтажаПФР,
	|		ПредыдущиеДанныеРегистра.Организация КАК Организация,
	|		ПредыдущиеДанныеРегистра.Подразделение КАК Подразделение,
	|		ПредыдущиеДанныеРегистра.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	|		ПредыдущиеДанныеРегистра.ГрафикРаботы КАК ГрафикРаботы,
	|		ПредыдущиеДанныеРегистра.Должность КАК Должность,
	|		ПредыдущиеДанныеРегистра.КоличествоСтавок КАК КоличествоСтавок,
	|		ПредыдущиеДанныеРегистра.ТерриториальныеУсловия КАК ТерриториальныеУсловия,
	|		ПредыдущиеДанныеРегистра.ОсобыеУсловияТруда КАК ОсобыеУсловияТруда,
	|		ПредыдущиеДанныеРегистра.ОснованиеВыслугиЛет КАК ОснованиеВыслугиЛет,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаВидСтажаПФР КАК ИспользованиеРесурсаВидСтажаПФР,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаОрганизация КАК ИспользованиеРесурсаОрганизация,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаПодразделение КАК ИспользованиеРесурсаПодразделение,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаДолжностьПоШтатномуРасписанию КАК ИспользованиеРесурсаДолжностьПоШтатномуРасписанию,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаДолжность КАК ИспользованиеРесурсаДолжность,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаГрафикРаботы КАК ИспользованиеРесурсаГрафикРаботы,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаКоличествоСтавок КАК ИспользованиеРесурсаКоличествоСтавок,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаТерриториальныеУсловия КАК ИспользованиеРесурсаТерриториальныеУсловия,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаОсобыеУсловияТруда КАК ИспользованиеРесурсаОсобыеУсловияТруда,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаОснованиеВыслугиЛет КАК ИспользованиеРесурсаОснованиеВыслугиЛет,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаТерритория КАК ИспользованиеРесурсаТерритория,
	|		ПредыдущиеДанныеРегистра.УсловияТруда КАК УсловияТруда,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаУсловияТруда КАК ИспользованиеРесурсаУсловияТруда,
	|		ПредыдущиеДанныеРегистра.Территория КАК Территория,
	|		ПредыдущиеДанныеРегистра.Сотрудник КАК Сотрудник,
	|		ПредыдущиеДанныеРегистра.ВнутреннееСовместительство КАК ВнутреннееСовместительство,
	|		ПредыдущиеДанныеРегистра.ИспользованиеРесурсаВнутреннееСовместительство КАК ИспользованиеРесурсаВнутреннееСовместительство,
	|		1 КАК ФлагИзменений
	|	ИЗ
	|		ВТПредыдущиеДанныеРегистра КАК ПредыдущиеДанныеРегистра
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ПараметрыПериодовСтажаПФР.ГоловнаяОрганизация,
	|		ПараметрыПериодовСтажаПФР.ФизическоеЛицо,
	|		ПараметрыПериодовСтажаПФР.ТипДоговора,
	|		ПараметрыПериодовСтажаПФР.Начало,
	|		ПараметрыПериодовСтажаПФР.Окончание,
	|		ПараметрыПериодовСтажаПФР.Приоритет,
	|		ПараметрыПериодовСтажаПФР.Сторно,
	|		ПараметрыПериодовСтажаПФР.ДокументОснование,
	|		ПараметрыПериодовСтажаПФР.ВидСтажаПФР,
	|		ПараметрыПериодовСтажаПФР.Организация,
	|		ПараметрыПериодовСтажаПФР.Подразделение,
	|		ПараметрыПериодовСтажаПФР.ДолжностьПоШтатномуРасписанию,
	|		ПараметрыПериодовСтажаПФР.ГрафикРаботы,
	|		ПараметрыПериодовСтажаПФР.Должность,
	|		ПараметрыПериодовСтажаПФР.КоличествоСтавок,
	|		ПараметрыПериодовСтажаПФР.ТерриториальныеУсловия,
	|		ПараметрыПериодовСтажаПФР.ОсобыеУсловияТруда,
	|		ПараметрыПериодовСтажаПФР.ОснованиеВыслугиЛет,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаВидСтажаПФР,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаОрганизация,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаПодразделение,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаДолжностьПоШтатномуРасписанию,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаДолжность,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаГрафикРаботы,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаКоличествоСтавок,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаТерриториальныеУсловия,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаОсобыеУсловияТруда,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаОснованиеВыслугиЛет,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаТерритория,
	|		ПараметрыПериодовСтажаПФР.УсловияТруда,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаУсловияТруда,
	|		ПараметрыПериодовСтажаПФР.Территория,
	|		ПараметрыПериодовСтажаПФР.Сотрудник,
	|		ПараметрыПериодовСтажаПФР.ВнутреннееСовместительство,
	|		ПараметрыПериодовСтажаПФР.ИспользованиеРесурсаВнутреннееСовместительство,
	|		-1
	|	ИЗ
	|		РегистрСведений.ПараметрыПериодовСтажаПФР КАК ПараметрыПериодовСтажаПФР
	|	ГДЕ
	|		ПараметрыПериодовСтажаПФР.Регистратор = &Регистратор) КАК СравнениеСПредыдущимНабором
	|
	|СГРУППИРОВАТЬ ПО
	|	СравнениеСПредыдущимНабором.ФизическоеЛицо,
	|	СравнениеСПредыдущимНабором.ТипДоговора,
	|	СравнениеСПредыдущимНабором.Начало,
	|	СравнениеСПредыдущимНабором.Окончание,
	|	СравнениеСПредыдущимНабором.Приоритет,
	|	СравнениеСПредыдущимНабором.Сторно,
	|	СравнениеСПредыдущимНабором.ДокументОснование,
	|	СравнениеСПредыдущимНабором.ВидСтажаПФР,
	|	СравнениеСПредыдущимНабором.Организация,
	|	СравнениеСПредыдущимНабором.Подразделение,
	|	СравнениеСПредыдущимНабором.ДолжностьПоШтатномуРасписанию,
	|	СравнениеСПредыдущимНабором.ГрафикРаботы,
	|	СравнениеСПредыдущимНабором.Должность,
	|	СравнениеСПредыдущимНабором.ТерриториальныеУсловия,
	|	СравнениеСПредыдущимНабором.ОсобыеУсловияТруда,
	|	СравнениеСПредыдущимНабором.ОснованиеВыслугиЛет,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаВидСтажаПФР,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаОрганизация,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаПодразделение,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаДолжностьПоШтатномуРасписанию,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаДолжность,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаГрафикРаботы,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаКоличествоСтавок,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаТерриториальныеУсловия,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаОсобыеУсловияТруда,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаОснованиеВыслугиЛет,
	|	СравнениеСПредыдущимНабором.КоличествоСтавок,
	|	СравнениеСПредыдущимНабором.ГоловнаяОрганизация,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаТерритория,
	|	СравнениеСПредыдущимНабором.УсловияТруда,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаУсловияТруда,
	|	СравнениеСПредыдущимНабором.Территория,
	|	СравнениеСПредыдущимНабором.Сотрудник,
	|	СравнениеСПредыдущимНабором.ВнутреннееСовместительство,
	|	СравнениеСПредыдущимНабором.ИспользованиеРесурсаВнутреннееСовместительство
	|
	|ИМЕЮЩИЕ
	|	СУММА(СравнениеСПредыдущимНабором.ФлагИзменений) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИзменившиесяДанные.ГоловнаяОрганизация,
	|	ИзменившиесяДанные.ФизическоеЛицо,
	|	ИзменившиесяДанные.Сотрудник,
	|	ИзменившиесяДанные.ТипДоговора,
	|	ИзменившиесяДанные.Начало,
	|	ИзменившиесяДанные.Окончание
	|ПОМЕСТИТЬ ВТКлючиИзменившихсяДанных
	|ИЗ
	|	ВТИзменившиесяДанные КАК ИзменившиесяДанные";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Отбор.Регистратор.Значение);
	Запрос.Выполнить();

	УчетСтажаПФР.ОбновитьДанныеВторичногоРегистра(Запрос.МенеджерВременныхТаблиц);
КонецПроцедуры

#КонецОбласти

#КонецЕсли