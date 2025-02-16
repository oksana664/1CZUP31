
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПриПолученииДанныхНаСервере();
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МероприятиеПриИзменении(Элемент)
	
	УстановитьРеквизитыФормыПоМероприятию();
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#Область Отклики

&НаКлиенте
Процедура Отклик_Пойду(Команда)
	ОбработатьДействиеНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.Согласие"));
КонецПроцедуры

&НаКлиенте
Процедура Отклик_ВозможноПойду(Команда)
	ОбработатьДействиеНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.ВозможноеСогласие"));
КонецПроцедуры

&НаКлиенте
Процедура Отклик_НеПойду(Команда)
	ОбработатьДействиеНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.Отказ"));
КонецПроцедуры

&НаКлиенте
Процедура Отклик_НеЗнаю(Команда)
	ОбработатьДействиеНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.ПустаяСсылка"));
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()

	ФизическоеЛицо = Параметры.ФизическоеЛицо;
	УстановитьРеквизитыФормыПоМероприятию();

КонецПроцедуры

&НаСервере
Процедура УстановитьРеквизитыФормыПоМероприятию()
	ИнфоНадписьМероприятия = ОбучениеРазвитие.ИнфоНадписьМероприятия(Объект.Мероприятие);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДействиеНаКлиенте(Отклик)

	Если НЕ ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Текущему пользователю не сопоставлено физическое лицо, запись отклика невозможна.'"));
		Возврат;
	КонецЕсли;
	
	ЗаписатьОтклик(Объект.Ссылка, ФизическоеЛицо, Отклик);
	
	ПараметрыЗакрытия = Новый Структура("Публикация, Отклик");
	ПараметрыЗакрытия.Публикация = Объект.Ссылка;
	ПараметрыЗакрытия.Отклик = Отклик;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОтклик(Публикация, ФизическоеЛицо, Отклик)
	ОбучениеРазвитие.ЗаписатьОтклик(Публикация, ФизическоеЛицо, Отклик);
КонецПроцедуры

#КонецОбласти 