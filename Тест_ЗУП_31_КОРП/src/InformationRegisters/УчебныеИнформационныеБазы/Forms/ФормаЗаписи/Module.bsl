
#Область ОбработчикиСобытийФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;	
	
	УстановитьДоступностьЭлементовФормы();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СпособПодключенияПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура АутентификацияWindowsИнформационнойБазыПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УстановитьПодключение(Команда)
	
	РезультатПодключения = УстановитьПодключениеНаСервере();
	
	Если РезультатПодключения.ОшибкаПроверки
		ИЛИ РезультатПодключения.ОшибкаПодключения Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПодключения.КраткоеОписаниеОшибки);
		
	Иначе
		
		Если Параметры.ОткрытаИзЭлектронногоРесурса Тогда
		
			Если Записать() Тогда
				Закрыть(Истина);
			КонецЕсли;
			
		Иначе
			
			ПоказатьПредупреждение(,НСтр("ru = 'Подключение успешно установлено'"));
			
		КонецЕсли;
			
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	Если ЗначениеЗаполнено(Запись.СпособПодключения) Тогда
		
		Элементы.ГруппаНастройкиПодключения.Видимость = Истина;
		
		Элементы.ИмяИнформационнойБазыНаСервере.Видимость = ?(Запись.СпособПодключения = Перечисления.СпособыПодключенияКУчебнойИнформационнойБазе.Сервер, Истина, Ложь);
		Элементы.ИмяСервераИнформационнойБазы.Видимость = ?(Запись.СпособПодключения = Перечисления.СпособыПодключенияКУчебнойИнформационнойБазе.Сервер, Истина, Ложь);
		Элементы.КаталогИнформационнойБазы.Видимость = ?(Запись.СпособПодключения = Перечисления.СпособыПодключенияКУчебнойИнформационнойБазе.Файл, Истина, Ложь);
		Элементы.АдресНаВебСервере.Видимость = ?(Запись.СпособПодключения = Перечисления.СпособыПодключенияКУчебнойИнформационнойБазе.ВебСервер, Истина, Ложь);
		Элементы.ПользовательИнформационнойБазы.Видимость = ?(Запись.АутентификацияWindowsИнформационнойБазы, Ложь, Истина);
		
	Иначе
		
		Элементы.ГруппаНастройкиПодключения.Видимость = Ложь;
		
	КонецЕсли;	
	
	Если Параметры.ОткрытаИзЭлектронногоРесурса Тогда
		
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		Элементы.ФормаЗаписать.Видимость = Ложь;
		
		Элементы.Пользователь.ТолькоПросмотр = Истина;
		Элементы.Конфигурация.ТолькоПросмотр = Истина;
		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция УстановитьПодключениеНаСервере()
	
	Возврат РегистрыСведений.УчебныеИнформационныеБазы.УстановитьПодключение(Неопределено, Запись);
	
КонецФункции

#КонецОбласти

