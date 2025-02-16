////////////////////////////////////////////////////////////////////////////////
// Подсистема "Управленческая зарплата"
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриИзмененииНастройкиУправленческойЗарплатыПозицииШтатногоРасписания(Форма, Элемент) Экспорт
	
	ИспользоватьУправленческиеНачисленияПриИзмененииНастройкиПозицииШтатногоРасписания(Форма, Элемент);
	ДоначислятьДоУправленческогоУчетаПриИзмененииНастройкиПозицииШтатногоРасписания(Форма, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриемНаРаботу

Процедура ПриемНаРаботуУправленческиеНачисленияВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийВыбор(
		Форма, Элемент, Поле, СтандартнаяОбработка, 1, Форма.Объект.Сотрудник, Форма.Объект.ДатаПриема);
	
КонецПроцедуры

Процедура ПриемНаРаботуУправленческиеНачисленияПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриНачалеРедактирования(Форма, "УправленческиеНачисления", 1);
	
КонецПроцедуры

Процедура ПриемНаРаботуУправленческиеНачисленияПриОкончанииРедактирования(Форма, Элемент, НоваяСтрока, ОтменаРедактирования) Экспорт
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеТаблицыВидовРасчета = УправленческаяЗарплатаКлиентСервер.ПриемНаРаботуОписаниеТаблицыУправленческихНачислений();
	Если ЗарплатаКадрыРасширенныйКлиент.ВводПлановыхНачисленийРассчитатьФОТПриОкончанииРедактирования(Форма, Элемент, 1, ОписаниеТаблицыВидовРасчета) Тогда
		Форма.ВыполнитьРасчетФОТ();
	Иначе
		ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьИтогФОТДокумента(Форма.ФОТ, Форма, ОписаниеТаблицыВидовРасчета)
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриемНаРаботуУправленческиеНачисленияНачислениеПриИзменении(Форма, Элемент) Экспорт
	
	ОписаниеТаблицыВидовРасчета = УправленческаяЗарплатаКлиентСервер.ПриемНаРаботуОписаниеТаблицыУправленческихНачислений();
	
	ДополнительныеПараметры = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыЗаполненияЗначенийПоказателейТарифныхСеток();
	ДополнительныеПараметры.ДатаСведений = Форма.ВремяРегистрации;
	ДополнительныеПараметры.ТарифнаяСетка = Форма.ТарифнаяСетка;
	ДополнительныеПараметры.ТарифнаяСеткаНадбавки = Форма.ТарифнаяСеткаНадбавки;
	ДополнительныеПараметры.РазрядКатегория = Форма.РазрядКатегория;
	ДополнительныеПараметры.РазрядКатегорияНадбавки = Форма.Объект.РазрядКатегория;
	ДополнительныеПараметры.ПКУ = Форма.Объект.ПКУ;
	
	ЗарплатаКадрыРасширенныйКлиент.ВводПлановыхНачисленийНачислениеПриИзменении(Форма, ОписаниеТаблицыВидовРасчета, 1, Форма.Объект.Сотрудник, ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область КадровыйПеревод

Процедура КадровыйПереводУправленческиеНачисленияВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийВыбор(
		Форма, Элемент, Поле, СтандартнаяОбработка, 1, Форма.Объект.Сотрудник, Форма.Объект.ДатаНачала);
	
КонецПроцедуры

Процедура КадровыйПереводУправленческиеНачисленияПриАктивизацииСтроки(Форма, Элемент) Экспорт
	
	ОписаниеКоманднойПанелиНачислений = КадровыйПереводОписаниеКоманднойПанелиНачислений();
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриАктивизацииСтроки(
		Форма, "УправленческиеНачисления", "УправленческиеНачисленияНачисление", 1, ОписаниеКоманднойПанелиНачислений);
	
КонецПроцедуры

Процедура КадровыйПереводУправленческиеНачисленияПередУдалением(Форма, Элемент, Отказ) Экспорт
	
	Отказ = Истина;
	ОписаниеКоманднойПанелиНачислений = КадровыйПереводОписаниеКоманднойПанелиНачислений();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийОтменитьНачисление(Форма, "УправленческиеНачисления", 1, ОписаниеКоманднойПанелиНачислений, , Форма.Объект.ДатаНачала);
	Форма.ВыполнитьРасчетФОТ();
	
КонецПроцедуры

Процедура КадровыйПереводУправленческиеНачисленияПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриНачалеРедактирования(Форма, "УправленческиеНачисления", 1, , НоваяСтрока);
	
КонецПроцедуры

Процедура КадровыйПереводУправленческиеНачисленияПриОкончанииРедактирования(Форма, Элемент, НоваяСтрока, ОтменаРедактирования) Экспорт
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеТаблицыНачислений = УправленческаяЗарплатаКлиентСервер.КадровыйПереводОписаниеТаблицыУправленческихНачислений();
	
	Если ЗарплатаКадрыРасширенныйКлиент.ВводПлановыхНачисленийРассчитатьФОТПриОкончанииРедактирования(Форма, Элемент, 1, ОписаниеТаблицыНачислений) Тогда
		Форма.ВыполнитьРасчетФОТ();
	Иначе
		ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьИтогФОТДокумента(Форма.ФОТ, Форма, ОписаниеТаблицыНачислений)
	КонецЕсли;
	
КонецПроцедуры

Процедура КадровыйПереводУправленческиеНачисленияНачислениеПриИзменении(Форма, Элемент) Экспорт
	
	ОписаниеТаблицыВидовРасчета = УправленческаяЗарплатаКлиентСервер.КадровыйПереводОписаниеТаблицыУправленческихНачислений();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийНачислениеПриИзменении(
		Форма, ОписаниеТаблицыВидовРасчета, 1, Форма.Объект.Сотрудник, Форма.ТарифнаяСетка, Форма.РазрядКатегория,
		Форма.Объект.ДатаНачала, Форма.ТарифнаяСеткаНадбавки, Форма.Объект.РазрядКатегория);
	
КонецПроцедуры

Функция КадровыйПереводОписаниеКоманднойПанелиНачислений()
	
	ОписаниеКоманднойПанелиНачислений = ЗарплатаКадрыРасширенныйКлиент.ОписаниеКоманднойПанелиНачислений();
	ОписаниеКоманднойПанелиНачислений.СтраницыКоманднойПанелиНачислений = "СтраницыКоманднойПанелиУправленческихНачислений";
	ОписаниеКоманднойПанелиНачислений.СтраницаДобавитьОтменить 			= "СтраницаДобавитьОтменитьУправленческие";
	ОписаниеКоманднойПанелиНачислений.СтраницаДобавитьПродолжить 		= "СтраницаДобавитьПродолжитьУправленческие";
	ОписаниеКоманднойПанелиНачислений.СтраницаДобавитьУдалить 			= "СтраницаДобавитьУдалитьУправленческие";
	Возврат ОписаниеКоманднойПанелиНачислений;
	
КонецФункции

#КонецОбласти

#Область ШтатноеРасписание

Процедура ИспользоватьУправленческиеНачисленияПриИзмененииНастройкиПозицииШтатногоРасписания(Форма, Элемент) 
	
	Если Элемент.Имя <> "ИспользоватьУправленческиеНачисления" Тогда
		Возврат;
	КонецЕсли;
	
	УправленческаяЗарплатаКлиентСервер.УстановитьВидимостьУправленческихНачисленийПозицииШтатногоРасписания(Форма);
	
	ИспользоватьУправленческиеНачисления = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, 
		"НастройкиРасчетаУправленческойЗарплатыПозицийШтатногоРасписания.ИспользоватьУправленческиеНачисления");
	
	Если Не ИспользоватьУправленческиеНачисления Тогда
		
		ДоначислятьДоУправленческогоУчета = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
			Форма, "НастройкиРасчетаУправленческойЗарплатыПозицийШтатногоРасписания.ДоначислятьДоУправленческогоУчета");
		
		Если ДоначислятьДоУправленческогоУчета <> Ложь Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(
				Форма, "НастройкиРасчетаУправленческойЗарплатыПозицийШтатногоРасписания.ДоначислятьДоУправленческогоУчета", Ложь);
			
			ПриИзмененииДоначисленияДоУправленческогоУчета(Форма);
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправленческаяЗарплатаКлиентСервер.ШтатноеРасписаниеУстановитьОтображениеЭлементовФормы(Форма);
	
КонецПроцедуры

Процедура ДоначислятьДоУправленческогоУчетаПриИзмененииНастройкиПозицииШтатногоРасписания(Форма, Элемент) 
	
	Если Элемент.Имя <> "ДоначислятьДоУправленческогоУчета" Тогда
		Возврат;
	КонецЕсли;
	
	ПриИзмененииДоначисленияДоУправленческогоУчета(Форма);
	
КонецПроцедуры

Процедура ПриИзмененииДоначисленияДоУправленческогоУчета(Форма)
	
	ДоначислятьДоУправленческогоУчета = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(
		Форма, 
		"НастройкиРасчетаУправленческойЗарплатыПозицийШтатногоРасписания.ДоначислятьДоУправленческогоУчета");
	
	ОтборСтрок = Новый Структура("Начисление", Форма.НачислениеДоначислениеДоУправленческогоУчета);
	НайденныеСтроки = Форма.Объект.Начисления.НайтиСтроки(ОтборСтрок);
	
	// Добавляем/удаляем начисление в/из состав регламентированных
	Если ДоначислятьДоУправленческогоУчета Тогда
		
		Если НайденныеСтроки.Количество() = 0 Тогда
		
			СтрокаДоначисления = Форма.Объект.Начисления.Добавить();
			СтрокаДоначисления.Начисление = Форма.НачислениеДоначислениеДоУправленческогоУчета;
			
		Иначе
			СтрокаДоначисления = НайденныеСтроки[0];
		КонецЕсли;
		
		УправленческаяЗарплатаКлиентСервер.УстановитьРазмерДоплатыДоУправленческихНачислений(Форма, СтрокаДоначисления);
		
	ИначеЕсли ЗначениеЗаполнено(Форма.НачислениеДоначислениеДоУправленческогоУчета) Тогда
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			Форма.Объект.Начисления.Удалить(Строка);
		КонецЦикла;
		
	КонецЕсли;
	
	// Пересчитываем ФОТ
	ЗарплатаКадрыРасширенныйКлиент.ПодключитьОбработчикОжиданияАвтоматическогоРасчета(Форма, "РассчитатьФОТНаКлиенте", "РассчитатьУправленческие");
	
КонецПроцедуры

Процедура УправленческиеНачисленияПриАктивизацииСтроки(Форма, Элемент) Экспорт
	
	Если Форма.ВнешниеДанные Тогда
		УправлениеШтатнымРасписаниемКлиент.НачисленияПриАктивизацииСтроки(Форма, ОписаниеКоманднойПанелиНачислений())
	КонецЕсли;
	
КонецПроцедуры

Процедура УправленческиеНачисленияПередУдалением(Форма, Элемент, Отказ) Экспорт
	
	Если Форма.ВнешниеДанные Тогда
		УправлениеШтатнымРасписаниемКлиент.НачисленияПередУдалением(Форма, Отказ, ОписаниеКоманднойПанелиНачислений(), "УправленческиеНачисления");
		ВыполнитьРасчетФОТ(Форма);
	КонецЕсли; 
	
КонецПроцедуры

Процедура УправленческиеНачисленияПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриНачалеРедактирования(Форма, "УправленческиеНачисления", 0, , НоваяСтрока И Форма.ВнешниеДанные);
	
КонецПроцедуры

Процедура УправленческиеНачисленияПриОкончанииРедактирования(Форма, Элемент, НоваяСтрока, ОтменаРедактирования) Экспорт
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеТаблицыУправленческихНачислений = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачисленийПозицииШтатногоРасписания();
	Если Форма.ИспользоватьВилкуСтавок Тогда
		
		КоличествоПоказателей = ЗарплатаКадрыРасширенныйКлиентСервер.МаксимальноеКоличествоПоказателейПоОписаниюТаблицы(
			Форма, ОписаниеТаблицыУправленческихНачислений,, 0);
			
		Для НомерПоказателя = 1 По КоличествоПоказателей Цикл
			
			ПутьКЗначениюМин = "МинимальноеЗначение" + НомерПоказателя;
			ЗначениеМин = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Элемент.ТекущиеДанные, ПутьКЗначениюМин);
			
			ПутьКЗначениюМакс = "МаксимальноеЗначение" + НомерПоказателя;
			ЗначениеМакс = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Элемент.ТекущиеДанные, ПутьКЗначениюМакс);
			
			Если ЗначениеМин > ЗначениеМакс Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Элемент.ТекущиеДанные, ПутьКЗначениюМакс, ЗначениеМин);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли; 
	
	ИзмененыНачисления = Форма.Модифицированность;

	Если ЗарплатаКадрыРасширенныйКлиент.ВводПлановыхНачисленийРассчитатьФОТПриОкончанииРедактирования(Форма, Элемент, 0, ОписаниеТаблицыУправленческихНачислений) Тогда
		ВыполнитьРасчетФОТ(Форма);
	КонецЕсли;
	
	УправлениеШтатнымРасписаниемКлиентСервер.УстановитьВидимостьКомандыИзменитьНачисленияСотрудников(Форма);
	
КонецПроцедуры

Процедура УправленческиеНачисленияПослеУдаления(Форма, Элемент) Экспорт
	
	Если Форма.ВнешниеДанные Тогда
		УправлениеШтатнымРасписаниемКлиент.РедактированиеСостоянияШРПриИзмененииНачислений(Форма, "Объект.УправленческиеНачисления", "Позиции", "УправленческиеНачисления", Истина);
	КонецЕсли;
	
	ВыполнитьРасчетФОТ(Форма);
	
КонецПроцедуры

Процедура УправленческиеНачисленияНачислениеПриИзменении(Форма, Элемент) Экспорт
	
	ОписаниеТаблицыВидовРасчета = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачисленийПозицииШтатногоРасписания();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийНачислениеПриИзменении(
		Форма, ОписаниеТаблицыВидовРасчета, 0, , , , УправлениеШтатнымРасписаниемКлиентСервер.ДатаСобытия(Форма, ОбщегоНазначенияКлиент.ДатаСеанса()), , , Истина);
	
КонецПроцедуры

Функция ОписаниеКоманднойПанелиНачислений()
	
	ОписаниеКоманднойПанелиНачислений = ЗарплатаКадрыРасширенныйКлиент.ОписаниеКоманднойПанелиНачислений();
	
	ОписаниеКоманднойПанелиНачислений.СтраницыКоманднойПанелиНачислений = "СтраницыКоманднойПанелиУправленческихНачислений";
	ОписаниеКоманднойПанелиНачислений.СтраницаДобавитьОтменить			= "СтраницаДобавитьОтменитьУправленческие";
	ОписаниеКоманднойПанелиНачислений.СтраницаДобавитьПродолжить		= "СтраницаДобавитьПродолжитьУправленческие";
	ОписаниеКоманднойПанелиНачислений.СтраницаДобавитьУдалить			= "СтраницаДобавитьУдалитьУправленческие";
	
	Возврат ОписаниеКоманднойПанелиНачислений
	
КонецФункции

Процедура ВыполнитьРасчетФОТ(Форма)
	
	ЗарплатаКадрыРасширенныйКлиент.ПодключитьОбработчикОжиданияАвтоматическогоРасчета(Форма, "РассчитатьФОТНаКлиенте");
	
КонецПроцедуры

#КонецОбласти

#Область ДокументНачислениеЗарплаты

Процедура ПриОкончанииРедактированияСтрокиНачисленияЗарплаты(Форма) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыКлиент.СтрокаРасчетаПриОкончанииРедактирования(Форма, ОписаниеТаблицы);
	
КонецПроцедуры

Процедура ПриИзмененииСотрудникаСтрокиНачисленияЗарплаты(Форма) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыРасширенныйКлиент.ДополнитьСтрокуРасчета(Форма, ОписаниеТаблицы, Истина, Истина);
	
КонецПроцедуры

Процедура ПриИзмененииНачисленияСтрокиНачисленияЗарплаты(Форма, ОписаниеДокумента) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	ОписаниеТаблицы.ИмяРеквизитаПериод = ОписаниеДокумента.МесяцНачисленияИмя;
	ЗарплатаКадрыРасширенныйКлиент.ВводНачисленийНачислениеПриИзменении(Форма, ОписаниеТаблицы, 2);
	РасчетЗарплатыРасширенныйКлиент.ДополнитьСтрокуРасчета(Форма, ОписаниеТаблицы, Истина, Истина);
	
КонецПроцедуры

Процедура ПослеУдаленияСтрокиНачисленияЗарплаты(Форма, Сотрудник) Экспорт
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	Форма.РассчитатьСотрудника(Сотрудник, ОписаниеТаблицы);
КонецПроцедуры

Процедура ПриИзмененииДатыНачалаСтрокиНачисленияЗарплаты(Форма) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыРасширенныйКлиент.ДополнитьСтрокуРасчета(Форма, ОписаниеТаблицы, Истина, Истина);
	
КонецПроцедуры

Процедура ПриИзмененииДатыОкончанияСтрокиНачисленияЗарплаты(Форма) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыРасширенныйКлиент.ДополнитьСтрокуРасчета(Форма, ОписаниеТаблицы, Ложь, Истина);
	
КонецПроцедуры

Процедура ПриНажатииКнопкиПоказатьПодробностиРасчета(Форма, КнопкаПодробностиРасчета) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыРасширенныйКлиентСервер.ДокументыВыполненияНачисленийУстановитьРежимОтображенияПодробно(Форма, Не КнопкаПодробностиРасчета.Пометка, ОписаниеТаблицы);
	
КонецПроцедуры

Процедура ПриОтменеИсправленияНачисленияЗарплаты(Форма) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыКлиент.ОтменитьИсправление(Форма, ОписаниеТаблицы);
	
КонецПроцедуры

Процедура ПриОтменеВсехИсправленийНачисленияЗарплаты(Форма) Экспорт
	
	ОписаниеТаблицы = УправленческаяЗарплатаКлиентСервер.ОписаниеТаблицыУправленческихНачислений();
	РасчетЗарплатыКлиент.ОтменитьВсеИсправления(Форма, ОписаниеТаблицы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
