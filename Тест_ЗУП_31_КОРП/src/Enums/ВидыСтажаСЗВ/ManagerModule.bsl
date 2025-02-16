
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("КатегорияНачисления") Тогда
		Возврат;
	КонецЕсли;
	
	// Настройка выбора по категории начисления.
	СтандартнаяОбработка = Ложь;
	
	КатегорияНачисления = Параметры.КатегорияНачисления;
	
	ДанныеВыбора = Новый СписокЗначений;
	Если КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска 
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаКомандировки
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаДнейУходаЗаДетьмиИнвалидами
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПоСреднемуЗаработку Тогда
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.ВключаетсяВСтраховойСтаж);
	ИначеЕсли КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускБезОплаты Тогда
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.ОтпускБезСохраненияЗарплаты);
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.ЧАЭС);
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.НЕОПЛ);
	ИначеЕсли КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.БолезньБезОплаты
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.НеявкаПоБолезни Тогда
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.ВременнаяНетрудоспособность);
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.НЕОПЛ);
	ИначеЕсли КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.НеявкаПоНевыясненнымПричинам 
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Прогул 
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ПростойПоВинеРаботника Тогда
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.НеВключаетсяВСтраховойСтаж);
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.НЕОПЛ);
	ИначеЕсли КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоВинеРаботодателя 
		Или КатегорияНачисления = Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаПростояПоНезависящимОтРаботодателяПричинам Тогда
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.ВключаетсяВСтраховойСтаж);
		ДанныеВыбора.Добавить(Перечисления.ВидыСтажаСЗВ.НеВключаетсяВСтраховойСтаж);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
