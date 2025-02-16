
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФизическоеЛицо = СамообслуживаниеСотрудников.ФизическоеЛицоПользователя();
	
	Если Не ЭлектронноеОбучение.ИспользоватьЭлектронноеОбучение() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЭлектронныеКурсыГруппа", "Видимость", Ложь);
	КонецЕсли;
	
	УстановитьПараметрыЭлектронныхКурсов();
	ЗаполнитьСписокПубликаций();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытиеФормыЭлектронногоКурса" Тогда
		Элементы.ЭлектронныеКурсы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьЭлектронныйКурс(Команда)
	
	ДанныеСтроки = Элементы.ЭлектронныеКурсы.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьВыбранныйЭлектронныйКурс(ДанныеСтроки.ЭлектронныйКурс, ДанныеСтроки.Регистратор);
	
КонецПроцедуры

&НаКлиенте
Процедура Отклик_Пойду(Команда)
	ОбработатьОткликНаПубликациюНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.Согласие"));
КонецПроцедуры

&НаКлиенте
Процедура Отклик_ВозможноПойду(Команда)
	ОбработатьОткликНаПубликациюНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.ВозможноеСогласие"));
КонецПроцедуры

&НаКлиенте
Процедура Отклик_НеПойду(Команда)
	ОбработатьОткликНаПубликациюНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.Отказ"));
КонецПроцедуры

&НаКлиенте
Процедура Отклик_НеЗнаю(Команда)
	ОбработатьОткликНаПубликациюНаКлиенте(ПредопределенноеЗначение("Перечисление.ВариантыОткликовСотрудников.ПустаяСсылка"));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ЭлектронныеКурсыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеСтроки = Элементы.ЭлектронныеКурсы.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьВыбранныйЭлектронныйКурс(ДанныеСтроки.ЭлектронныйКурс, ДанныеСтроки.Регистратор);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПубликацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура(
		"ТолькоПросмотр, 
		|Ключ, 
		|ФизическоеЛицо");
	ПараметрыФормы.ТолькоПросмотр = Истина;
	ПараметрыФормы.Ключ = Элементы.ТаблицаПубликаций.ТекущиеДанные.Публикация;
	ПараметрыФормы.ФизическоеЛицо = ФизическоеЛицо;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьЗакрытиеПубликации", ЭтаФорма);
	ОткрытьФорму("Документ.ПубликацияМероприятияОбученияРазвития.Форма.ФормаПубликации", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор, , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыЭлектронныхКурсов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ЭлектронныеКурсы, "ФизическоеЛицо", ФизическоеЛицо);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ЭлектронныеКурсы, "ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВыбранныйЭлектронныйКурс(ЭлектронныйКурс, ДокументОбученияРазвития)
	
	ИзучениеЭлектронныхКурсовКлиент.ИзучитьЭлектронныйКурс(ЭлектронныйКурс, ДокументОбученияРазвития, ФизическоеЛицо);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПубликаций()
	
	ДоступныеПубликации = ОбучениеРазвитие.ОткрытыеПубликацииДляФизическогоЛица(ФизическоеЛицо, ТекущаяДатаСеанса()).Выгрузить();
	Если ДоступныеПубликации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПубликаций.Загрузить(ДоступныеПубликации);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьОтклик(Публикация, ФизическоеЛицо, Отклик)
	ОбучениеРазвитие.ЗаписатьОтклик(Публикация, ФизическоеЛицо, Отклик);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеПубликации(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РезультатЗакрытия.Свойство("Публикация") 
		Или Не ЗначениеЗаполнено(РезультатЗакрытия.Публикация) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не РезультатЗакрытия.Свойство("Отклик") Тогда
		Возврат;
	КонецЕсли;

	НайденныеСтроки = ТаблицаПубликаций.НайтиСтроки(Новый Структура("Публикация", РезультатЗакрытия.Публикация));
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].Отклик = РезультатЗакрытия.Отклик;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОткликНаПубликациюНаКлиенте(Отклик)

	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Текущему пользователю не сопоставлено физическое лицо, запись отклика невозможна.'"));
		Возврат;
	КонецЕсли;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ТаблицаПубликаций.ВыделенныеСтроки Цикл
		ТекущиеДанные = ТаблицаПубликаций.НайтиПоИдентификатору(ВыделеннаяСтрока);
		ТекущиеДанные.Отклик = Отклик;
		ЗаписатьОтклик(ТекущиеДанные.Публикация, ФизическоеЛицо, Отклик);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти
