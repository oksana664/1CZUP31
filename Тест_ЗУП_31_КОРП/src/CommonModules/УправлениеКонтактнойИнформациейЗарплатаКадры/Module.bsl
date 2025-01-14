
#Область ПрограммныйИнтерфейс

// Функция возвращает юридический и фактический адреса, указанной организации.
//
// Параметры:
//			Организации			- Массив ссылок или ссылка на элемент справочника Организации.
//			ДатаАктуальности	- Дата
//
// Возвращаемое значение:
//			Соответствие:
//				Ключ 		- СправочникСсылка.Организации
//				Значение 	- Соответствие
//					Ключ - СправочникСсылка.ВидыКонтактнойИнформации
//					Значение - Структура
//						Представление
//						Город
//						ЗначенияПолей
//
Функция АдресаОрганизаций(Организации, Знач ДатаАктуальности = '00010101') Экспорт
	
	ВозвращаемоеЗначение = Новый Соответствие;
	
	Если Не ЗначениеЗаполнено(ДатаАктуальности) Тогда
		ДатаАктуальности = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ТипСправочникСсылкаОрганизации = Тип("СправочникСсылка.Организации");
	
	// Определение соответствия видов контактной информации в зависимости от 
	// типа объекта, содержащего контактную информацию.
	СоответствиеАдресовОрганизаций = Новый Соответствие;
	
	СоответствиеВидов = Новый Соответствие;
	СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации, Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
	СоответствиеВидов.Вставить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
	
	СоответствиеАдресовОрганизаций.Вставить(ТипСправочникСсылкаОрганизации, СоответствиеВидов);
	
	ЗарплатаКадрыПереопределяемый.ДополнитьСоответствиеАдресовОрганизаций(СоответствиеАдресовОрганизаций);
	
	// Деление организаций по типу объекта, содержащего контактную информацию.
	КоллекцияПоТипам = Новый Соответствие;
			
	Если ТипЗнч(Организации) = ТипСправочникСсылкаОрганизации Тогда
		КоллекцияПоТипам.Вставить(ТипСправочникСсылкаОрганизации, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Организации));
	Иначе
		КоллекцияПоТипам.Вставить(ТипСправочникСсылкаОрганизации, Организации);
	КонецЕсли;
	
	ЗарплатаКадрыПереопределяемый.ОпределитьТипыВладельцевАдресовОрганизаций(КоллекцияПоТипам);
	
	// Получение адресов
	Для каждого КоллекцияПоТипу Из КоллекцияПоТипам Цикл
		
		Если КоллекцияПоТипу.Ключ = Тип("СправочникСсылка.Организации") Тогда
			МассивСсылок = КоллекцияПоТипу.Значение;
			СоответствиеВидовКИ = СоответствиеАдресовОрганизаций.Получить(ТипСправочникСсылкаОрганизации);
		Иначе
			МассивСсылок = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияПоТипу.Значение, "Ключ");
			СоответствиеВидовКИ = СоответствиеАдресовОрганизаций.Получить(КоллекцияПоТипу.Ключ);
		КонецЕсли;
		
		ВидыАдресов = ОбщегоНазначения.ВыгрузитьКолонку(СоответствиеВидовКИ, "Ключ");
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		УправлениеКонтактнойИнформацией.СоздатьВТКонтактнаяИнформация(Запрос.МенеджерВременныхТаблиц, МассивСсылок, , ВидыАдресов, ДатаАктуальности);
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	КонтактнаяИнформация.Объект КАК Объект,
			|	КонтактнаяИнформация.Вид,
			|	КонтактнаяИнформация.Представление,
			|	КонтактнаяИнформация.ЗначенияПолей
			|ИЗ
			|	ВТКонтактнаяИнформация КАК КонтактнаяИнформация
			|ИТОГИ ПО
			|	Объект";
			
		ВыборкаОрганизаций = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОрганизаций.Следующий() Цикл
			
			СоответствиеАдресовОрганизации = Новый Соответствие;
			ВыборкаПоВидам = ВыборкаОрганизаций.Выбрать();
			Пока ВыборкаПоВидам.Следующий() Цикл
				
				СтруктураАдреса = СтруктураПустогоАдресаОрганизации();
				ЗаполнитьЗначенияСвойств(СтруктураАдреса, ВыборкаПоВидам);
				
				АдресСтруктура = ЗарплатаКадры.СтруктураАдресаИзXML(
					ВыборкаПоВидам.ЗначенияПолей, ВыборкаПоВидам.Вид);
					
				Сокращение = "";
				Если АдресСтруктура.Свойство("Город") И НЕ ПустаяСтрока(АдресСтруктура.Город) Тогда
					СтруктураАдреса.Город = АдресСтруктура.Город;
					АдресСтруктура.Свойство("ГородСокращение", Сокращение);
				ИначеЕсли АдресСтруктура.Свойство("НаселенныйПункт") И НЕ ПустаяСтрока(АдресСтруктура.НаселенныйПункт) Тогда
					СтруктураАдреса.Город = АдресСтруктура.НаселенныйПункт;
					АдресСтруктура.Свойство("НаселенныйПунктСокращение", Сокращение);
				ИначеЕсли АдресСтруктура.Свойство("Регион") И НЕ ПустаяСтрока(АдресСтруктура.Регион) Тогда
					СтруктураАдреса.Город = АдресСтруктура.Регион;
					АдресСтруктура.Свойство("РегионСокращение", Сокращение);
				КонецЕсли; 
				
				Если НЕ ПустаяСтрока(СтруктураАдреса.Город) И НЕ ПустаяСтрока(Сокращение) Тогда
					СтруктураАдреса.Город = Сокращение + ". " + Лев(СтруктураАдреса.Город, СтрДлина(СтруктураАдреса.Город) - СтрДлина(Сокращение) - 1);
				КонецЕсли; 
				
				ВидАдреса = СоответствиеВидовКИ.Получить(ВыборкаПоВидам.Вид);
				СоответствиеАдресовОрганизации.Вставить(ВидАдреса, СтруктураАдреса);
				
			КонецЦикла; 
			
			Если КоллекцияПоТипу.Ключ = Тип("СправочникСсылка.Организации") Тогда
				СсылкаНаОрганизацию = ВыборкаОрганизаций.Объект;
			Иначе
				СсылкаНаОрганизацию = КоллекцияПоТипу.Значение.Получить(ВыборкаОрганизаций.Объект);
			КонецЕсли;
			ВозвращаемоеЗначение.Вставить(СсылкаНаОрганизацию, СоответствиеАдресовОрганизации);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает структура адреса, поставляемую методом АдресаОрганизаций, по
// переданным параметрам Организации и виду адреса.
//
// Параметры:
//		АдресаОрганизаций - Коллекция адресов, полученная с помощью метода АдресаОрганизаций.
//		Организация
//		ВидАдреса - СправочникСсылка.ВидыКонтактнойИнформации
//
// ВозвращаемоеЗначение:
//		Структура - Ключи структуры описаны в описании метода АдресаОрганизаций.
//
Функция АдресОрганизации(АдресаОрганизаций, Организация, ВидАдреса) Экспорт
	
	АдресОрганизации = СтруктураПустогоАдресаОрганизации();
	
	АдресаОрганизации = АдресаОрганизаций.Получить(Организация);
	Если АдресаОрганизации <> Неопределено Тогда
		Адрес = АдресаОрганизации.Получить(ВидАдреса);
		Если Адрес <> Неопределено Тогда
				АдресОрганизации = Адрес;
		КонецЕсли; 
	КонецЕсли; 
		
	Возврат АдресОрганизации;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик для события формы ПриСозданииНаСервере, вызывает соответствующий метод подсистемы
// УправлениеКонтактнойИнформации. Дополняет элементы отображения полей ввода адресов, полями
// отображающими результаты проверки адресов на корректность.
//
// Параметры:
//    Форма                - УправляемаяФорма - Форма объекта-владельца, предназначенная для вывода контактной 
//                           информации.
//    Объект               - Объект-владелец контактной информации.
//    ПоложениеЗаголовкаКИ - Может принимать значения ПоложениеЗаголовкаЭлементаФормы.Лево 
//                           или ПоложениеЗаголовкаЭлементаФормы.Верх (по умолчанию).
//
Процедура ПриСозданииНаСервере(Форма, Объект, ИмяЭлементаДляРазмещения, ПоложениеЗаголовкаКИ = "") Экспорт
	
	Если ПоложениеЗаголовкаКИ <> ПоложениеЗаголовкаЭлементаФормы.Верх
		И ПоложениеЗаголовкаКИ <> ПоложениеЗаголовкаЭлементаФормы.Лево Тогда
		
		ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
	КонецЕсли;
	
	ДополнительныеПараметры = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформацией();
	ДополнительныеПараметры.ИмяЭлементаДляРазмещения = ИмяЭлементаДляРазмещения;
	ДополнительныеПараметры.ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаКИ;
	
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(Форма, Объект, ДополнительныеПараметры);
	
	ДополнитьФормуПолямиОтображенияПроверкиАдресов(Форма);
	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(Форма);
	
КонецПроцедуры

// Добавляет (удаляет) поле ввода или комментарий на форму.
//
Процедура ОбновитьКонтактнуюИнформацию(Форма, Результат, ЗависимостиВидовАдресов = Неопределено) Экспорт
	
	Если Результат <> Неопределено И Результат.Свойство("ДобавляемыйВид") Тогда
		ДополнитьФормуПолямиОтображенияПроверкиАдресов(Форма);
	КонецЕсли;
	
	ЗаполнитьЗависимыеАдреса(Форма, Результат, ЗависимостиВидовАдресов);
	
	ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(Форма);
	
КонецПроцедуры

// См. УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов.
//  Параметры ТипыКонтактнойИнформации, ВидыКонтактнойИнформации и Дата обязательные,
//  но могут принимать значение Неопределено.
//  Если Дата не заполнена, то используется текущая дата сеанса.
Функция КонтактнаяИнформацияОбъектов(СсылкиИлиОбъекты, ТипыКонтактнойИнформации, ВидыКонтактнойИнформации, Дата) Экспорт
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(
		СсылкиИлиОбъекты,
		ТипыКонтактнойИнформации,
		ВидыКонтактнойИнформации,
		?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
КонецФункции

// См. УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта.
//  Параметры ВидКонтактнойИнформации и Дата обязательные,
//  но могут принимать значение Неопределено.
//  Если Дата не заполнена, то используется текущая дата сеанса.
Функция КонтактнаяИнформацияОбъекта(СсылкаИлиОбъект, ВидКонтактнойИнформации, Дата, ТолькоПредставление = Истина) Экспорт
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		СсылкаИлиОбъект,
		ВидКонтактнойИнформации,
		?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()),
		ТолькоПредставление);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Дополняет форму, содержащую контактную информацию предупреждающими
// надписями для полей содержащих адрес.
//
Процедура ДополнитьФормуПолямиОтображенияПроверкиАдресов(Форма)

	КоллекцияПолейКонтактнойИнформации = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	Если КоллекцияПолейКонтактнойИнформации <> Неопределено Тогда
		
		РоссийскиеАдреса = ЗарплатаКадрыПовтИсп.ВидыРоссийскихАдресов();
		
		Для Каждого КонтактнаяИнформация Из КоллекцияПолейКонтактнойИнформации Цикл
			
			Элемент = Форма.Элементы.Найти(КонтактнаяИнформация.ИмяРеквизита);
			Если Элемент <> Неопределено Тогда
				
				// Для полей контактной информации, содержащих телефонные номера ограничивается ширина.
				Если КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон
					ИЛИ КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Факс
					ИЛИ КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
				
					Элемент.РастягиватьПоГоризонтали = Ложь;
					Элемент.Ширина = 20;
					
					Команда = Форма.Элементы.Найти("Команда" + КонтактнаяИнформация.ИмяРеквизита);
					Если Команда <> Неопределено Тогда
						
						Декорация = Форма.Элементы.Найти("Декорация" + Команда.Имя);
						Если Декорация = Неопределено Тогда
							
							Декорация = Форма.Элементы.Добавить("Декорация" + Команда.Имя, Тип("ДекорацияФормы"), Команда.Родитель);
							
							Декорация.Вид = ВидДекорацииФормы.Надпись;
							Декорация.Заголовок = "";
							
							Форма.Элементы.Переместить(Декорация, Команда.Родитель, Команда);
							
						КонецЕсли;
						
						Группа = Форма.Элементы.Найти("ГруппаГоризонтальная" + Элемент.Имя);
						Если Группа = Неопределено Тогда
							
							Группа = Форма.Элементы.Добавить("ГруппаГоризонтальная" + Элемент.Имя, Тип("ГруппаФормы"), Элемент.Родитель);
							
							Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
							Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
							Группа.ОтображатьЗаголовок = Ложь;
							Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
							
							Форма.Элементы.Переместить(Группа, Элемент.Родитель, Элемент);
							
							Форма.Элементы.Переместить(Элемент, Группа);
							
						КонецЕсли;
						
						Если Врег(Форма.ПараметрыКонтактнойИнформации.ГруппаКонтактнаяИнформация.ПоложениеЗаголовка) = Врег("Верх") Тогда
							
							ГруппаВертикальная = Форма.Элементы.Найти("ГруппаВертикальная" + Элемент.Имя);
							Если ГруппаВертикальная = Неопределено Тогда
								
								ГруппаВертикальная = Форма.Элементы.Добавить("ГруппаВертикальная" + Элемент.Имя, Тип("ГруппаФормы"), Элемент.Родитель);
								
								ГруппаВертикальная.Вид = ВидГруппыФормы.ОбычнаяГруппа;
								ГруппаВертикальная.ОтображатьЗаголовок = Ложь;
								ГруппаВертикальная.Отображение = ОтображениеОбычнойГруппы.Нет;
								
							КонецЕсли;
							
							Декорация = Форма.Элементы.Найти("Декорация" + ГруппаВертикальная.Имя);
							Если Декорация = Неопределено Тогда
								
								Декорация = Форма.Элементы.Добавить("Декорация" + ГруппаВертикальная.Имя, Тип("ДекорацияФормы"), ГруппаВертикальная);
								
								Декорация.Вид = ВидДекорацииФормы.Надпись;
								Декорация.Заголовок = "";
								
								Форма.Элементы.Переместить(Команда, ГруппаВертикальная);
								
							КонецЕсли;
							
						Иначе
							Форма.Элементы.Переместить(Команда, Группа);
						КонецЕсли;
						
					КонецЕсли;
					
				// Поля, содержащие адрес дополняются, полями отображающими результаты проверки адресов.
				ИначеЕсли КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
					
					Если Элемент.Вид = ВидПоляФормы.ПолеНадписи Тогда
						Элемент.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная);
					КонецЕсли;
					
					Если КонтактнаяИнформация.Вид = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица Тогда
						
						ИмяГруппыАдресаПоПрописке = "ГруппаАдресПоПрописке" + Элемент.Имя;
						ГруппаАдресаПоПрописке = Форма.Элементы.Найти(ИмяГруппыАдресаПоПрописке);
						Если ГруппаАдресаПоПрописке = Неопределено Тогда
							
							ГруппаАдресаПоПрописке = Форма.Элементы.Найти(ИмяГруппыАдресаПоПрописке);
							Если ГруппаАдресаПоПрописке = Неопределено Тогда
								
								ГруппаАдресаПоПрописке = Форма.Элементы.Добавить(ИмяГруппыАдресаПоПрописке, Тип("ГруппаФормы"));
								
								ГруппаАдресаПоПрописке.Вид = ВидГруппыФормы.ОбычнаяГруппа;
								ГруппаАдресаПоПрописке.ОтображатьЗаголовок = Ложь;
								ГруппаАдресаПоПрописке.Отображение = ОтображениеОбычнойГруппы.Нет;
								ГруппаАдресаПоПрописке.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
								
								Форма.Элементы.Переместить(ГруппаАдресаПоПрописке, Элемент.Родитель, Элемент);
								Форма.Элементы.Переместить(Элемент, ГруппаАдресаПоПрописке);
								
							КонецЕсли;
							
							ЭлементДатаРегистрации = Форма.Элементы.Найти("ДатаРегистрации" + Элемент.Имя);
							Если ЭлементДатаРегистрации = Неопределено Тогда
								
								ЭлементДатаРегистрации = Форма.Элементы.Добавить("ДатаРегистрации" + Элемент.Имя, Тип("ПолеФормы"), ГруппаАдресаПоПрописке);
								
								ЭлементДатаРегистрации.Вид = ВидПоляФормы.ПолеВвода;
								ЭлементДатаРегистрации.ПутьКДанным = "ФизическоеЛицо.ДатаРегистрации";
								ЭлементДатаРегистрации.РастягиватьПоГоризонтали = Ложь;
								
								Если Врег(Форма.ПараметрыКонтактнойИнформации.ГруппаКонтактнаяИнформация.ПоложениеЗаголовка) = Врег("Верх") Тогда
									ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Верх;
								Иначе
									ПоложениеЗаголовкаКИ = ПоложениеЗаголовкаЭлементаФормы.Лево;
								КонецЕсли;
								
								ЭлементДатаРегистрации.ПоложениеЗаголовка = ПоложениеЗаголовкаКИ;
								ЭлементДатаРегистрации.УстановитьДействие("ПриИзменении", "Подключаемый_ФизлицоДатаРегистрацииПриИзменении");
								
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЕсли;
					
					Если РоссийскиеАдреса.Получить(КонтактнаяИнформация.Вид) = Истина Тогда
						Элемент.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновляет предупреждающие надписи к элементу, содержащему адрес.
//
Процедура ОбновитьОтображениеПредупреждающихНадписейКонтактнойИнформации(Форма) Экспорт

	АдресныйКлассификаторЗагружен = Неопределено;
	ПроверенныеАдреса = Новый Соответствие;
	КоллекцияПолейКонтактнойИнформации = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	
	Если КоллекцияПолейКонтактнойИнформации <> Неопределено Тогда
		
		РоссийскиеАдреса = ЗарплатаКадрыПовтИсп.ВидыРоссийскихАдресов();
		Для Каждого КонтактнаяИнформация Из КоллекцияПолейКонтактнойИнформации Цикл
			
			Если КонтактнаяИнформация.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес
				И РоссийскиеАдреса.Получить(КонтактнаяИнформация.Вид) = Истина Тогда
				
				Если АдресныйКлассификаторЗагружен = Неопределено Тогда
					АдресныйКлассификаторЗагружен = АдресныйКлассификатор.АдресныйКлассификаторЗагружен();
				КонецЕсли; 
				
				Элемент = Форма.Элементы.Найти(КонтактнаяИнформация.ИмяРеквизита);
				Если Элемент <> Неопределено Тогда
					
					УстановитьОтображениеПоляАдреса(
						Форма[Элемент.Имя],
						КонтактнаяИнформация.ЗначенияПолей,
						Элемент,
						Форма,
						КонтактнаяИнформация.Вид,
						АдресныйКлассификаторЗагружен,
						ПроверенныеАдреса
					);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

// Осуществляет проверку заполненного элемента содержащего адрес и выводит
// предупреждающие надписи.
//
Процедура УстановитьОтображениеПоляАдреса(Адрес, СписокПолей, Элемент, Форма, ВидАдреса, АдресныйКлассификаторЗагружен = Неопределено, ПроверенныеАдреса = Неопределено) Экспорт
	
	СообщенияПроверки = "";
	ЦветТекстаПоля = ЦветаСтиля.ЦветТекстаПоля;
	
	Если ТипЗнч(ПроверенныеАдреса) = Тип("Соответствие") Тогда
		НастройкиОтображенияАдреса = ПроверенныеАдреса.Получить(Адрес);
	Иначе
		НастройкиОтображенияАдреса = Неопределено;
	КонецЕсли;
	
	Если НастройкиОтображенияАдреса = Неопределено Тогда
		
		Если Не ПустаяСтрока(Адрес) Тогда
		
			Если АдресныйКлассификаторЗагружен = Неопределено Тогда
				АдресныйКлассификаторЗагружен = АдресныйКлассификатор.АдресныйКлассификаторЗагружен();
			КонецЕсли;
			
			Если Не АдресныйКлассификаторЗагружен Тогда

				СообщенияПроверки = НСтр("ru = 'Адресный классификатор не загружен'");
				РезультатПроверки = Неопределено;

			Иначе
				
				РезультатПроверки = ЗарплатаКадрыВызовСервера.ПроверитьАдрес(СписокПолей, ВидАдреса);
				Если РезультатПроверки.Результат <> "Корректный" Тогда
					
					Для каждого ЭлементОписанияОшибки Из РезультатПроверки.СписокОшибок Цикл
						СообщенияПроверки = СообщенияПроверки + ЭлементОписанияОшибки.Представление + Символы.ПС;
					КонецЦикла;
					СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(СообщенияПроверки, 1);
					
					СообщенияПроверки = НСтр("ru = 'Адрес не соответствует адресному классификатору
						|'") + СообщенияПроверки;
					
				КонецЕсли;
				
			КонецЕсли;
			
			СообщенияПроверки = ?(ПустаяСтрока(СообщенияПроверки), НСтр("ru = 'Адрес введен правильно - в соответствии с требованиями'"), СообщенияПроверки);
			ЗаголовокОшибкиДополнительный = СтрПолучитьСтроку(СообщенияПроверки, 1);
			СообщенияПроверки = СокрЛП(Сред(СообщенияПроверки, СтрДлина(ЗаголовокОшибкиДополнительный) + 1));
			
			Если РезультатПроверки = Неопределено ИЛИ РезультатПроверки.Результат <> "Корректный" Тогда
				ЦветТекстаПоля = ЦветаСтиля.ПоясняющийОшибкуТекст;
			КонецЕсли; 
			
		КонецЕсли; 
		
	Иначе
		СообщенияПроверки = НастройкиОтображенияАдреса.СообщенияПроверки;
		ЦветТекстаПоля = НастройкиОтображенияАдреса.ЦветТекстаПоля;
	КонецЕсли;
	
	Если ТипЗнч(ПроверенныеАдреса) = Тип("Соответствие") Тогда
		ПроверенныеАдреса.Вставить(Адрес, Новый Структура("СообщенияПроверки,ЦветТекстаПоля", СообщенияПроверки, ЦветТекстаПоля));
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		Элемент.Имя,
		"ЦветТекста",
		ЦветТекстаПоля);
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		Элемент.Имя,
		СообщенияПроверки);

КонецПроцедуры

Функция СтруктураПустогоАдресаОрганизации()
	
	Возврат Новый Структура("Представление,Город,ЗначенияПолей", "", "", "");
	
КонецФункции

Процедура ЗаполнитьЗависимыеАдреса(Форма, Результат, ЗависимостиВидовАдресов)
	
	Если ЗависимостиВидовАдресов <> Неопределено
		И Результат <> Неопределено И Результат.Свойство("ИмяРеквизита") Тогда
		
		ИмяЭлемента = Результат.ИмяРеквизита;
		
		КоллекцияПолейКонтактнойИнформации = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
		Если КоллекцияПолейКонтактнойИнформации <> Неопределено Тогда
			
			СтруктураПоиска = Новый Структура("ИмяРеквизита", ИмяЭлемента);
			НайденныеСтрокиТекущегоАдреса = КоллекцияПолейКонтактнойИнформации.НайтиСтроки(СтруктураПоиска);
			Если НайденныеСтрокиТекущегоАдреса.Количество() > 0 Тогда
				
				СтрокаТекущегоАдреса = НайденныеСтрокиТекущегоАдреса[0];
				Если НЕ ПустаяСтрока(СтрокаТекущегоАдреса.ЗначенияПолей) Тогда
					
					КоллекцияЗависимыхВидов = ЗависимостиВидовАдресов.Получить(СтрокаТекущегоАдреса.Вид);
					Если КоллекцияЗависимыхВидов <> Неопределено Тогда
						
						Для каждого ЭлементКонтактнойИнформации Из КоллекцияПолейКонтактнойИнформации Цикл
							
							Для каждого ЗависимыйВид Из КоллекцияЗависимыхВидов Цикл
								Если ЭлементКонтактнойИнформации.Вид = ЗависимыйВид
									И ПустаяСтрока(ЭлементКонтактнойИнформации.ЗначенияПолей) Тогда
									
									ЭлементКонтактнойИнформации.ЗначенияПолей = СтрокаТекущегоАдреса.ЗначенияПолей;
									ЭлементКонтактнойИнформации.Представление = СтрокаТекущегоАдреса.Представление;
									Форма[ЭлементКонтактнойИнформации.ИмяРеквизита] = Форма[СтрокаТекущегоАдреса.ИмяРеквизита];
									
								КонецЕсли;
							КонецЦикла;
							
						КонецЦикла;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
