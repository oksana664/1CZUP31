
#Область СлужебныеПроцедурыИФункции

// Получает информацию о виде расчета.
Функция ПолучитьИнформациюОВидеРасчета(ВидРасчета) Экспорт
		
	Возврат ЗарплатаКадрыВнутренний.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
	
КонецФункции

// Возвращает ссылку на головную организацию.
Функция ГоловнаяОрганизация(Организация) Экспорт
	Возврат РегламентированнаяОтчетность.ГоловнаяОрганизация(Организация);
КонецФункции

// Функция определяет является ли организация юридическим лицом.
// 
Функция ЭтоЮридическоеЛицо(Организация) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") <> Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
КонецФункции

// Возвращает ссылку на "Регистрацию в налоговом органе" по состоянию на некоторую ДатаАктуальности.
Функция РегистрацияВНалоговомОргане(СтруктурнаяЕдиница, Знач ДатаАктуальности = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДатаСеанса()
	КонецЕсли;
	
	РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",	СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("ДатаАктуальности",	ДатаАктуальности);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияРегистрацийВНалоговомОрганеСрезПоследних.РегистрацияВНалоговомОргане
	|ИЗ
	|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане.СрезПоследних(&ДатаАктуальности, СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ИсторияРегистрацийВНалоговомОрганеСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.РегистрацияВНалоговомОргане;
		
	КонецЕсли;
	
	Если ТипЗнч(СтруктурнаяЕдиница) <> Тип("СправочникСсылка.Организации") Тогда
		
		ИменаРеквизитов = "Родитель,Владелец";
		Если ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
			ИменаРеквизитов = ИменаРеквизитов + ",ОбособленноеПодразделение";
		КонецЕсли;
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктурнаяЕдиница, ИменаРеквизитов);
		Если ТипЗнч(СтруктурнаяЕдиница) <> Тип("СправочникСсылка.ПодразделенияОрганизаций")
			Или ЗначенияРеквизитов.ОбособленноеПодразделение <> Истина Тогда
			
			Если ЗначениеЗаполнено(ЗначенияРеквизитов.Родитель) Тогда
				Возврат ЗарплатаКадрыПовтИсп.РегистрацияВНалоговомОргане(ЗначенияРеквизитов.Родитель, ДатаАктуальности);
			ИначеЕсли ЗначениеЗаполнено(ЗначенияРеквизитов.Владелец) Тогда
				Возврат ЗарплатаКадрыПовтИсп.РегистрацияВНалоговомОргане(ЗначенияРеквизитов.Владелец, ДатаАктуальности);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	
КонецФункции

// Возвращает ссылку на валюту в которой происходит расчет заработной платы (рубль РФ).
// Номинирование тарифов, надбавок, выплата зарплаты допускается в любой валюте, 
// но расчеты выполняются в валюте учета зарплаты.
Функция ВалютаУчетаЗаработнойПлаты() Экспорт

	Возврат Справочники.Валюты.НайтиПоКоду("643");

КонецФункции

// Возвращает массив ссылок на виды документов удостоверяющих личность.
//
Функция ВидыДокументовУдостоверяющихЛичностьФНС() Экспорт
	КодыДокументовСтрокой = УчетНДФЛКлиентСервер.КодыДопустимыхДокументовУдостоверяющихЛичность();
	
	КодыДокументов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КодыДокументовСтрокой, ",", , Истина);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодыДокументов", КодыДокументов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|ГДЕ
	|	ВидыДокументовФизическихЛиц.КодМВД В(&КодыДокументов)";
	
	ВидыДокументов = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВидыДокументов.Добавить(Выборка.Ссылка);	
	КонецЦикла;	
	
	Возврат ВидыДокументов;
		
КонецФункции	

// Возвращает настройки формирования печатных форм.
//
// Возвращаемое значение:
//		Структура - соответствует структуре ресурсов регистра сведений ДополнительныеНастройкиЗарплатаКадры.
//
Функция НастройкиПечатныхФорм() Экспорт
	
	Возврат РегистрыСведений.ДополнительныеНастройкиЗарплатаКадры.НастройкиПечатныхФорм();
	
КонецФункции

// Возвращает коллекцию элементов справочника ВидыКонтактнойИнформации с типом Адрес.
//
Функция ВидыРоссийскихАдресов() Экспорт
	
	РоссийскиеАдреса = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
		|	И ВидыКонтактнойИнформации.ТолькоНациональныйАдрес";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РоссийскиеАдреса.Вставить(Выборка.Ссылка, Истина);
	КонецЦикла; 
	
	Возврат РоссийскиеАдреса;
	
КонецФункции

// Получает размер минимальной оплаты труда.
//
// Параметры:
//	ДатаАктуальности - дата, на которую нужно получить МРОТ.
//
// Возвращаемое значение:
//	число, размер МРОТ на дату, или Неопределено, если МРОТ на дату не определен.
//
Функция МинимальныйРазмерОплатыТрудаРФ(ДатаАктуальности) Экспорт
	
	Возврат РегистрыСведений.МинимальнаяОплатаТрудаРФ.ДанныеМинимальногоРазмераОплатыТрудаРФ(ДатаАктуальности)["Размер"];
	
КонецФункции	

Функция МаксимальныйПриоритетСостоянийСотрудника() Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Увольнение", Перечисления.СостоянияСотрудника.Увольнение);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияСотрудника.Порядок
	|ИЗ
	|	Перечисление.СостоянияСотрудника КАК СостоянияСотрудника
	|ГДЕ
	|	СостоянияСотрудника.Ссылка = &Увольнение";	
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Возврат Выборка.Порядок;
КонецФункции	

// Проверяет принадлежность объекта метаданных к подсистемам. Проверка производится на вхождение
// в состав указанных подсистем и на вхождение в состав подсистем подчиненных указанным.
//
// Параметры:
//			ПолноеИмяОбъектаМетаданных 	- Строка, полное имя объекта метаданных (см. функцию НайтиПоПолномуИмени).
//			ИменаПодсистем				- Строка, имена подсистем, перечисленные через запятую.
//
// Возвращаемое значение:
//		Булево
//
Функция ОбъектМетаданныхВключенВПодсистемы(ПолноеИмяОбъектаМетаданных, ИменаПодсистем) Экспорт
	
	ЭтоОбъектПодсистемы = Ложь;
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	Если МетаданныеОбъекта <> Неопределено Тогда
		
		МассивИменПодсистем = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаПодсистем);
		Для каждого ИмяПодсистемы Из МассивИменПодсистем Цикл
			
			МетаданныеПодсистемы = Метаданные.Подсистемы.Найти(ИмяПодсистемы);
			Если МетаданныеПодсистемы <> Неопределено Тогда
				ЭтоОбъектПодсистемы = ОбъектМетаданныхВключенВПодсистему(МетаданныеПодсистемы, МетаданныеОбъекта);
			КонецЕсли; 
			
			Если ЭтоОбъектПодсистемы Тогда
				Прервать;
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЕсли; 
	
	Возврат ЭтоОбъектПодсистемы;
	
КонецФункции

// Проверяет вхождение объекта метаданных в подсистему. Рекурсивно проверяется вхождение
// объекта метаданных в подсистемы подчиненные указанной.
//
// Параметры:
//		МетаданныеПодсистемы	- Метаданные подсистемы.
//		МетаданныеОбъекта		- Метаданные объекта.
//
// Возвращаемое значение:
//		Булево
//
Функция ОбъектМетаданныхВключенВПодсистему(МетаданныеПодсистемы, МетаданныеОбъекта)
	
	ВходитВСостав = МетаданныеПодсистемы.Состав.Содержит(МетаданныеОбъекта);
	Если НЕ ВходитВСостав Тогда
		
		Для каждого МетаданныеПодчиненнойПодсистемы Из МетаданныеПодсистемы.Подсистемы Цикл
			
			ВходитВСостав = ОбъектМетаданныхВключенВПодсистему(МетаданныеПодчиненнойПодсистемы, МетаданныеОбъекта);
			Если ВходитВСостав Тогда
				Прервать;
			КонецЕсли; 
			
		КонецЦикла;
		
	КонецЕсли; 
	
	Возврат ВходитВСостав;
	
КонецФункции

// Строит соответствие тарифов страховых взносов на ОПС по категориям застрахованных лиц. 
//
// Параметры:
//  ОтчетныйГод - Число - год, для которого следует определить тариф;
//
// Возвращаемое значение:
//  Соответствие, ключом которого является категория ЗЛ (ПеречислениеСсылка.КатегорииЗастрахованныхЛицДляПФР), 
//					а значением - структура с полями ПФРСтраховая и ПФРНакопительная
//
Функция ТарифыВзносовПоКатегориямЗЛ(ОтчетныйГод) Экспорт

	Возврат ПерсонифицированныйУчет.ТарифыПоКатегориям(Дата(ОтчетныйГод, 1, 1))

КонецФункции 

// Строит соответствие кодов тарифов страховых взносов на ОПС кодам категорий застрахованных лиц. 
//
// Параметры:
//  ОтчетныйГод - Число - год, для которого следует определить тариф;
//
// Возвращаемое значение:
//  Соответствие, ключом которого является код категории ЗЛ (строка), а значением - код тарифа (строка).
//
Функция СоответствиеКодовТарифаКодамКатегорийЗастрахованных(ОтчетныйГод) Экспорт
	Возврат ПерсонифицированныйУчет.СоответствиеКодовТарифаКодамКатегорийЗастрахованных(ОтчетныйГод)
КонецФункции

#КонецОбласти
