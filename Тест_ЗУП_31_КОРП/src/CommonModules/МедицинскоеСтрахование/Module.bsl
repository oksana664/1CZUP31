////////////////////////////////////////////////////////////////////////////////
// Подсистема "Медицинское страхование"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ИспользуетсяМедицинскоеСтрахованиеСотрудников() Экспорт
	Возврат Константы.ИспользоватьМедицинскоеСтрахованиеСотрудников.Получить();
КонецФункции

Процедура УстановитьИспользованиеМедицинскогоСтрахования(Использовать) Экспорт
	Константы.ИспользоватьМедицинскоеСтрахованиеСотрудников.Установить(Использовать);
КонецПроцедуры

Процедура ДополнитьФормуЭлементаСправочникаОрганизации(Форма, ИмяГруппыДляВставки = "ГруппаНастройкиМедицинскогоСтрахования") Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьМедицинскоеСтрахованиеСотрудников") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.УсловияМедицинскогоСтрахования) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКоманды = "НастройкиМедицинскогоСтрахования";
	Если Форма.Команды.Найти(ИмяКоманды) = Неопределено Тогда
		КомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
		КомандаФормы.Заголовок = НСтр("ru = 'Медицинское страхование'");
		КомандаФормы.Действие = "Подключаемый_" + ИмяКоманды;
	КонецЕсли;
	
	ГруппаФормы = Форма.Элементы.Найти(ИмяГруппыДляВставки);
	Если Форма.Элементы.Найти(ИмяКоманды) = Неопределено Тогда
		Элемент = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаФормы);
		Элемент.Вид = ВидКнопкиФормы.Гиперссылка;
		Элемент.ИмяКоманды = ИмяКоманды;
	КонецЕсли;
	
КонецПроцедуры

Функция ПередаваемыеСведенияВСтраховуюКомпанию() Экспорт
	
	Сведения = Новый ТаблицаЗначений;
	Сведения.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	Сведения.Колонки.Добавить("Тип", Новый ОписаниеТипов("ОписаниеТипов"));
	Сведения.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Сведения.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации"));
	Сведения.Колонки.Добавить("ТипКИ", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыКонтактнойИнформации"));
	Сведения.Колонки.Добавить("КадровыеСведения", Новый ОписаниеТипов("Булево"));
	Сведения.Колонки.Добавить("ДокументУдостоверяющийЛичность", Новый ОписаниеТипов("Булево"));
	Сведения.Колонки.Добавить("ОтображатьЭлемент", Новый ОписаниеТипов("Булево"));
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДатаРождения";
	НоваяСтрока.Представление = НСтр("ru = 'Дата рождения'");
	НоваяСтрока.Тип = ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата);
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументПредставление";
	НоваяСтрока.Представление = НСтр("ru = 'Документ удостоверяющий личность'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументВид";
	НоваяСтрока.Представление = НСтр("ru = 'Вид документа'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("СправочникСсылка.ВидыДокументовФизическихЛиц");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументСерия";
	НоваяСтрока.Представление = НСтр("ru = 'Серия документа'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументНомер";
	НоваяСтрока.Представление = НСтр("ru = 'Номер документа'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументДатаВыдачи";
	НоваяСтрока.Представление = НСтр("ru = 'Дата выдачи документа'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументКемВыдан";
	НоваяСтрока.Представление = НСтр("ru = 'Кем выдан документ'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументСрокДействия";
	НоваяСтрока.Представление = НСтр("ru = 'Срок действия документа'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "ДокументКодПодразделения";
	НоваяСтрока.Представление = НСтр("ru = 'Код подразделения документа'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("Строка");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ДокументУдостоверяющийЛичность = Истина;
	НоваяСтрока.ОтображатьЭлемент = Ложь;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "Страна";
	НоваяСтрока.Представление = НСтр("ru = 'Гражданство'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("СправочникСсылка.СтраныМира");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "Пол";
	НоваяСтрока.Представление = НСтр("ru = 'Пол'");
	НоваяСтрока.Тип = Новый ОписаниеТипов("ПеречислениеСсылка.ПолФизическогоЛица");
	НоваяСтрока.КадровыеСведения = Истина;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.АдресДляИнформированияФизическиеЛица;
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "КонтактнаяИнформация1";
	НоваяСтрока.Представление = ВидКонтактнойИнформации.Наименование;
	НоваяСтрока.Тип = Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации");
	НоваяСтрока.Ссылка = ВидКонтактнойИнформации;
	НоваяСтрока.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Адрес;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонДомашнийФизическиеЛица;
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "КонтактнаяИнформация2";
	НоваяСтрока.Представление = ВидКонтактнойИнформации.Наименование;
	НоваяСтрока.Тип = Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации");
	НоваяСтрока.Ссылка = ВидКонтактнойИнформации;
	НоваяСтрока.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица;
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "КонтактнаяИнформация3";
	НоваяСтрока.Представление = ВидКонтактнойИнформации.Наименование;
	НоваяСтрока.Тип = Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации");
	НоваяСтрока.Ссылка = ВидКонтактнойИнформации;
	НоваяСтрока.ТипКИ = Перечисления.ТипыКонтактнойИнформации.Телефон;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица;
	НоваяСтрока = Сведения.Добавить();
	НоваяСтрока.Имя = "КонтактнаяИнформация4";
	НоваяСтрока.Представление = ВидКонтактнойИнформации.Наименование;
	НоваяСтрока.Тип = Новый ОписаниеТипов("СправочникСсылка.ВидыКонтактнойИнформации");
	НоваяСтрока.Ссылка = ВидКонтактнойИнформации;
	НоваяСтрока.ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	НоваяСтрока.ОтображатьЭлемент = Истина;
	
	Возврат Сведения;
	
КонецФункции

Функция ПараметрыОтправкиПисьма(Форма, ВыбранныеПараметры, Получатели, ТемаПисьма) Экспорт
	
	НастройкиПечатныхФорм = Новый ТаблицаЗначений;
	НастройкиПечатныхФорм.Колонки.Добавить("Представление", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	НастройкиПечатныхФорм.Колонки.Добавить("Количество", ОбщегоНазначения.ОписаниеТипаЧисло(3));
	НастройкиПечатныхФорм.Колонки.Добавить("Печатать", Новый ОписаниеТипов("Булево"));
	НастройкиПечатныхФорм.Колонки.Добавить("ИмяМакета", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	НастройкиПечатныхФорм.Колонки.Добавить("Название", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	НастройкиПечатныхФорм.Колонки.Добавить("ИмяФайлаПечатнойФормы", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	НастройкиПечатныхФорм.Колонки.Добавить("ПолноеИмяОбъекта", ОбщегоНазначения.ОписаниеТипаСтрока(0));
	НастройкиПечатныхФорм.Колонки.Добавить("ТабличныйДокумент", Неопределено);
	НастройкиПечатныхФорм.Колонки.Добавить("СсылкаДокумента", Неопределено);
	НастройкиПечатныхФорм.Колонки.Добавить("ДополнительныеПараметры", Неопределено);
	
	КомандыПечати = УправлениеПечатью.КомандыПечатиФормы(Форма);
	Для каждого КомандаПечати Из КомандыПечати Цикл
		НоваяСтрока = НастройкиПечатныхФорм.Добавить();
		НоваяСтрока.ИмяМакета = КомандаПечати.Идентификатор;
		НоваяСтрока.ПолноеИмяОбъекта = КомандаПечати.МенеджерПечати;
		НоваяСтрока.СсылкаДокумента = Форма.Объект.Ссылка;
		НоваяСтрока.ИмяФайлаПечатнойФормы = "<Undefined xmlns="""" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:nil=""true""/>";
		НоваяСтрока.Количество = 1;
		НоваяСтрока.Название = КомандаПечати.Представление;
		НоваяСтрока.Печатать = Истина;
		НоваяСтрока.Представление = КомандаПечати.Представление;
		НоваяСтрока.ДополнительныеПараметры = КомандаПечати.ДополнительныеПараметры;
	КонецЦикла;
	
	СписокВложений = ПоместитьТабличныеДокументыВоВременноеХранилище(Форма, ВыбранныеПараметры, НастройкиПечатныхФорм);
	
	// Контроль уникальности имен.
	ШаблонИмениФайла = "%1%2.%3";
	ИспользованныеИменаФайлов = Новый Соответствие;
	Для Каждого Вложение Из СписокВложений Цикл
		ИмяФайла = Вложение.Представление;
		НомерИспользования = ?(ИспользованныеИменаФайлов[ИмяФайла] <> Неопределено,
			ИспользованныеИменаФайлов[ИмяФайла] + 1, 1);
		ИспользованныеИменаФайлов.Вставить(ИмяФайла, НомерИспользования);
		Если НомерИспользования > 1 Тогда
			Файл = Новый Файл(ИмяФайла);
			ИмяФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениФайла,
				Файл.ИмяБезРасширения, " (" + НомерИспользования + ")", Файл.Расширение);
		КонецЕсли;
		Вложение.Представление = ИмяФайла;
	КонецЦикла;
	
	Если ВыбранныеПараметры.Свойство("Получатели") Тогда
		Получатели = ВыбранныеПараметры.Получатели;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Получатель", Получатели);
	Результат.Вставить("Тема", ТемаПисьма);
	Результат.Вставить("Вложения", СписокВложений);
	Результат.Вставить("УдалятьФайлыПослеОтправки", Истина);
	
	ПечатныеФормы = Новый ТаблицаЗначений;
	ПечатныеФормы.Колонки.Добавить("Название");
	ПечатныеФормы.Колонки.Добавить("ТабличныйДокумент");
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		Если НастройкаПечатнойФормы.ТабличныйДокумент = Неопределено Тогда
			ТабличныйДокумент = ТабличныйДокументПоНастройкеПечатнойФормы(НастройкаПечатнойФормы);
		Иначе
			ТабличныйДокумент = НастройкаПечатнойФормы.ТабличныйДокумент;
		КонецЕсли;
		Если ПечатныеФормы.НайтиСтроки(Новый Структура("ТабличныйДокумент", ТабличныйДокумент)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВычислитьИспользованиеВывода(ТабличныйДокумент) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТабличныйДокумент.Защита Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТабличныйДокумент.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеПечатнойФормы = ПечатныеФормы.Добавить();
		ОписаниеПечатнойФормы.Название = НастройкаПечатнойФормы.Название;
		ОписаниеПечатнойФормы.ТабличныйДокумент = ТабличныйДокумент;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СтраховаяПремия(ЭлементСтрахования, ДатыСтрахования, ДатаРождения, ШкалаВозрастов, ЭтоСотрудник) Экспорт
	
	ДатаНачала = ДатыСтрахования.ДатаНачала;
	ДатаОкончания = ДатыСтрахования.ДатаОкончания;
	ДатаНачалаСтрахования = ДатыСтрахования.ДатаНачалаСтрахования;
	ДатаОкончанияСтрахования = ДатыСтрахования.ДатаОкончанияСтрахования;
	
	ДеньРожденияТекущийГод = Дата(Год(ДатаНачала), Месяц(ДатаРождения), День(ДатаРождения));
	КоличествоЛетНаНачалоПериода = Год(ДатаНачала) - Год(ДатаРождения) + ?(Месяц(ДатаРождения) > Месяц(ДатаНачала), -1,
		?(Месяц(ДатаРождения) = Месяц(ДатаНачала) И День(ДатаРождения) > День(ДатаНачала), -1, 0));
	КоличествоЛетНаТекущуюДатуРождения = Год(ДеньРожденияТекущийГод) - Год(ДатаРождения);
	КоэффициентНаНачалоПериода = 0;
	КоэффициентНаТекущуюДатуРождения = 0;
	Для Каждого СтрокаШкалы Из ШкалаВозрастов Цикл
		Если СтрокаШкалы.ЗначениеОт <= КоличествоЛетНаНачалоПериода И СтрокаШкалы.ЗначениеДо >= КоличествоЛетНаНачалоПериода Тогда
			КоэффициентНаНачалоПериода = СтрокаШкалы.ЗначениеПоказателя;
		КонецЕсли;
		Если СтрокаШкалы.ЗначениеОт <= КоличествоЛетНаТекущуюДатуРождения И СтрокаШкалы.ЗначениеДо >= КоличествоЛетНаТекущуюДатуРождения Тогда
			КоэффициентНаТекущуюДатуРождения = СтрокаШкалы.ЗначениеПоказателя;
		КонецЕсли;
	КонецЦикла;
	
	СтраховаяПремияСтрахователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементСтрахования, ?(ЭтоСотрудник, "СтраховаяПремияСотрудника", "СтраховаяПремияРодственника"));
	КоличествоДнейПериода = (ДатаОкончанияСтрахования - ДатаНачалаСтрахования) / ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах() + 1;
	Если КоэффициентНаНачалоПериода <> КоэффициентНаТекущуюДатуРождения Тогда
		КоличествоДней = (ДатаНачала - ДатаНачалаСтрахования - ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах()) / ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах() + 1;
		СтраховаяПремия = СтраховаяПремияСтрахователя / КоличествоДнейПериода * КоличествоДней * ?(КоэффициентНаНачалоПериода = 0, 1, КоэффициентНаНачалоПериода);
		КоличествоДней = (ДатаОкончания - ДатаНачала) / ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах() + 1;
		СтраховаяПремия = СтраховаяПремия + СтраховаяПремияСтрахователя / КоличествоДнейПериода * КоличествоДней * ?(КоэффициентНаТекущуюДатуРождения = 0, 1, КоэффициентНаТекущуюДатуРождения);
	Иначе
		КоличествоДней = (ДатаОкончания - ДатаНачала) / ЗарплатаКадрыКлиентСервер.ДлительностьСутокВСекундах() + 1;
		СтраховаяПремия = СтраховаяПремияСтрахователя / КоличествоДнейПериода * КоличествоДней * ?(КоэффициентНаНачалоПериода = 0, 1, КоэффициентНаНачалоПериода);
	КонецЕсли;
	
	Возврат СтраховаяПремия;
	
КонецФункции

#Область ЗащитаПерсональныхДанных

// Процедура обеспечивает сбор сведений о хранении данных, 
// относящихся к персональным.
//
// Параметры:
//		ТаблицаСведений - таблица значений с полями:
//			Объект 			- строка, содержащая полное имя объекта метаданных,
//			ПоляРегистрации - строка, в которой перечислены имена полей регистрации, 
//								отдельные поля регистрации отделяются запятой,
//								альтернативные - символом "|",
//			ПоляДоступа		- строка, в которой перечислены через запятую имена полей доступа.
//			ОбластьДанных	- строка с идентификатором области данных, необязательно для заполнения.
//
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "Сотрудники.Сотрудник";
	НовыеСведения.ПоляДоступа		= "Сотрудники.ПрограммыСтрахования,Сотрудники.РасширенияПрограммСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "Сотрудники.Сотрудник";
	НовыеСведения.ПоляДоступа		= "Сотрудники.СтраховаяПремия,Сотрудники.СуммаУдержания,Сотрудники.СуммаПредела";
	НовыеСведения.ОбластьДанных		= "Доходы";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "ПрограммыСтрахованияСотрудников.Сотрудник";
	НовыеСведения.ПоляДоступа		= "ПрограммыСтрахованияСотрудников.ПрограммаСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "РасширенияПрограммСтрахованияСотрудников.Сотрудник";
	НовыеСведения.ПоляДоступа		= "РасширенияПрограммСтрахованияСотрудников.РасширениеСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "Родственники.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "Родственники.ПрограммыСтрахования,Родственники.РасширенияПрограммСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "Родственники.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "Родственники.СтраховаяПремия";
	НовыеСведения.ОбластьДанных		= "Доходы";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "ПрограммыСтрахованияРодственников.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "ПрограммыСтрахованияРодственников.ПрограммаСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "РасширенияПрограммСтрахованияРодственников.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "РасширенияПрограммСтрахованияРодственников.РасширениеСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "СведенияСотрудников.Сотрудник";
	НовыеСведения.ПоляДоступа		= "СведенияСотрудников.СведениеЗначение";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "СведенияРодственников.ФизическоеЛицо";
	НовыеСведения.ПоляДоступа		= "СведенияРодственников.СведениеЗначение";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ОткреплениеОтПрограммМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "Сотрудники.Сотрудник";
	НовыеСведения.ПоляДоступа		= "Сотрудники.ДатаРождения,Сотрудники.ПрограммыСтрахования,Сотрудники.РасширенияПрограммСтрахования,Сотрудники.ДатаОткрепления";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ОткреплениеОтПрограммМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "Сотрудники.Сотрудник";
	НовыеСведения.ПоляДоступа		= "Сотрудники.СтраховаяПремия";
	НовыеСведения.ОбластьДанных		= "Доходы";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ОткреплениеОтПрограммМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "ПрограммыСтрахованияСотрудников.Сотрудник";
	НовыеСведения.ПоляДоступа		= "ПрограммыСтрахованияСотрудников.ПрограммаСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект			= "Документ.ОткреплениеОтПрограммМедицинскогоСтрахования";
	НовыеСведения.ПоляРегистрации	= "РасширенияПрограммСтрахованияСотрудников.Сотрудник";
	НовыеСведения.ПоляДоступа		= "РасширенияПрограммСтрахованияСотрудников.РасширениеСтрахования";
	НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзмененияДанных

// См. ДатыЗапретаИзмененияПереопределяемый.ПриЗаполненииРазделовДатЗапретаИзменения.
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "МедицинскоеСтрахование";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("20bfa77a-4395-4d2d-a4e6-d32ceab316f0");
	Раздел.Представление = НСтр("ru = 'Медицинское страхование'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	
КонецПроцедуры

Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПрикреплениеКПрограммамМедицинскогоСтрахования",	"Дата", "МедицинскоеСтрахование", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОткреплениеОтПрограммМедицинскогоСтрахования",	"Дата", "МедицинскоеСтрахование", "Организация");
	
КонецПроцедуры

#КонецОбласти

#Область НастройкиВариантовОтчетов

// Определяет разделы, в которых доступна панель отчетов.
//
// Параметры:
//   Разделы (Массив) из (ОбъектМетаданных).
//
// Описание:
//   В Разделы необходимо добавить метаданные тех разделов,
//   в которых размещены команды вызова панелей отчетов.
//
// Например:
//	Разделы.Добавить(Метаданные.Подсистемы.ИмяПодсистемы);
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
// Описание см. ЗарплатаКадрыВариантыОтчетов.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.МедицинскоеСтрахование);
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.МедицинскоеСтрахование, "МедицинскоеСтрахование");
	Вариант.ФункциональныеОпции.Добавить("ИспользоватьМедицинскоеСтрахованиеСотрудников");
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.МедицинскоеСтрахование, "ПрограммыСтрахования");
	Вариант.ФункциональныеОпции.Добавить("ИспользоватьМедицинскоеСтрахованиеСотрудников");
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииОбъектовСКомандамиПечати.
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ПрикреплениеКПрограммамМедицинскогоСтрахования);
	СписокОбъектов.Добавить(Документы.ОткреплениеОтПрограммМедицинскогоСтрахования);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПараметрыОтправкиПисьма

Функция ТабличныйДокументПоНастройкеПечатнойФормы(НастройкаПечатнойФормы)
	
	МассивОбъектов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НастройкаПечатнойФормы.СсылкаДокумента);
	
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(НастройкаПечатнойФормы.ИмяМакета);
	ОбъектыПечати = Новый СписокЗначений;
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	ПараметрыПечати = НастройкаПечатнойФормы.ДополнительныеПараметры;
	
	ПечатнаяФорма = Новый ТабличныйДокумент;
	Если НастройкаПечатнойФормы.ПолноеИмяОбъекта = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" Тогда
		ПараметрыИсточника = Новый Структура;
		ПараметрыИсточника.Вставить("ИдентификаторКоманды", НастройкаПечатнойФормы.ИмяМакета);
		ПараметрыИсточника.Вставить("ОбъектыНазначения", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(НастройкаПечатнойФормы.СсылкаДокумента));
		УправлениеПечатью.ПечатьПоВнешнемуИсточнику(
			НастройкаПечатнойФормы.ДополнительныеПараметры.Ссылка, ПараметрыИсточника, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	Иначе
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(НастройкаПечатнойФормы.ПолноеИмяОбъекта);
		МенеджерОбъекта.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	Для Каждого ЭлементКоллекции Из КоллекцияПечатныхФорм Цикл
		НастройкаПечатнойФормы.ТабличныйДокумент = ЭлементКоллекции.ТабличныйДокумент;
		ПечатнаяФорма = ЭлементКоллекции.ТабличныйДокумент;
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ПоместитьТабличныеДокументыВоВременноеХранилище(Форма, ПереданныеНастройки, НастройкиПечатныхФорм)
	Перем ЗаписьZipФайла, ИмяАрхива;
	
	НастройкиСохранения = НастройкиСохранения();
	ЗаполнитьЗначенияСвойств(НастройкиСохранения, ПереданныеНастройки);
	
	Результат = Новый Массив;
	
	// подготовка архива
	Если НастройкиСохранения.УпаковатьВАрхив Тогда
		ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяАрхива);
	КонецЕсли;
	
	// подготовка временной папки
	ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ИмяВременнойПапки);
	ИспользованныеИменаФайлов = Новый Соответствие;
	
	ВыбранныеФорматыСохранения = НастройкиСохранения.ФорматыСохранения;
	ПереводитьИменаФайловВТранслит = НастройкиСохранения.ПереводитьИменаФайловВТранслит;
	ТаблицаФорматов = УправлениеПечатью.НастройкиФорматовСохраненияТабличногоДокумента();
	
	// сохранение печатных форм
	ОбработанныеПечатныеФормы = Новый Массив;
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		Если НастройкаПечатнойФормы.ТабличныйДокумент = Неопределено Тогда
			ПечатнаяФорма = ТабличныйДокументПоНастройкеПечатнойФормы(НастройкаПечатнойФормы);
		Иначе
			ПечатнаяФорма = НастройкаПечатнойФормы.ТабличныйДокумент;
		КонецЕсли;
		Если ОбработанныеПечатныеФормы.Найти(ПечатнаяФорма) = Неопределено Тогда
			ОбработанныеПечатныеФормы.Добавить(ПечатнаяФорма);
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ВычислитьИспользованиеВывода(ПечатнаяФорма) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.Защита Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПечатнаяФорма.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПечатныеФормыПоОбъектам = Новый Соответствие;
		ПечатныеФормыПоОбъектам.Вставить(Форма.Объект.Ссылка, ПечатнаяФорма);
		Для Каждого СоответствиеОбъектаПечатнойФорме Из ПечатныеФормыПоОбъектам Цикл
			ПечатнаяФорма = СоответствиеОбъектаПечатнойФорме.Значение;
			Для Каждого ТипФайла Из ВыбранныеФорматыСохранения Цикл
				НастройкиФормата = ТаблицаФорматов.НайтиСтроки(Новый Структура("ТипФайлаТабличногоДокумента", ТипФайла))[0];
				
				Если СоответствиеОбъектаПечатнойФорме.Ключ <> "ОбъектыПечатиНеЗаданы" Тогда
					ИмяФайла = ИмяФайлаПечатнойФормыОбъекта(СоответствиеОбъектаПечатнойФорме.Ключ, ОбщегоНазначения.ЗначениеИзСтрокиXML(НастройкаПечатнойФормы.ИмяФайлаПечатнойФормы));
					Если ИмяФайла = Неопределено Тогда
						ИмяФайла = ИмяФайлаПечатнойФормыПоУмолчанию(СоответствиеОбъектаПечатнойФорме.Ключ, НастройкаПечатнойФормы.Название);
					КонецЕсли;
				Иначе
					ИмяФайла = НастройкаПечатнойФормы.Название;
				КонецЕсли;
				ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
				
				Если ПереводитьИменаФайловВТранслит Тогда
					ИмяФайла = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(ИмяФайла);
				КонецЕсли;
				
				ИмяФайла = ИмяФайла + "." + НастройкиФормата.Расширение;
				
				ПолноеИмяФайла = УникальноеИмяФайла(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ИмяФайла);
				ПечатнаяФорма.Записать(ПолноеИмяФайла, ТипФайла);
				
				Если ТипФайла = ТипФайлаТабличногоДокумента.HTML Тогда
					ВставитьКартинкиВHTML(ПолноеИмяФайла);
				КонецЕсли;
				
				Если ЗаписьZipФайла <> Неопределено Тогда 
					ЗаписьZipФайла.Добавить(ПолноеИмяФайла);
				Иначе
					ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
					ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, Форма.УникальныйИдентификатор);
					ОписаниеФайла = Новый Структура;
					ОписаниеФайла.Вставить("Представление", ИмяФайла);
					ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
					Если ТипФайла = ТипФайлаТабличногоДокумента.ANSITXT Тогда
						ОписаниеФайла.Вставить("Кодировка", "windows-1251");
					КонецЕсли;
					Результат.Добавить(ОписаниеФайла);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	// Если архив подготовлен, записываем и помещаем его во временное хранилище.
	Если ЗаписьZipФайла <> Неопределено Тогда 
		ЗаписьZipФайла.Записать();
		ФайлАрхива = Новый Файл(ИмяАрхива);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяАрхива);
		ПутьВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, Форма.УникальныйИдентификатор);
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("Представление", ПолучитьИмяФайлаДляАрхива(Форма, НастройкиПечатныхФорм, ПереводитьИменаФайловВТранслит));
		ОписаниеФайла.Вставить("АдресВоВременномХранилище", ПутьВоВременномХранилище);
		Результат.Добавить(ОписаниеФайла);
	КонецЕсли;
	
	УдалитьФайлы(ИмяВременнойПапки);
	Если ЗначениеЗаполнено(ИмяАрхива) Тогда
		УдалитьФайлы(ИмяАрхива);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НастройкиСохранения()
	
	НастройкиСохранения = Новый Структура;
	НастройкиСохранения.Вставить("ФорматыСохранения", Новый Массив);
	НастройкиСохранения.Вставить("УпаковатьВАрхив", Ложь);
	НастройкиСохранения.Вставить("ПереводитьИменаФайловВТранслит", Ложь);
	
	Возврат НастройкиСохранения;
	
КонецФункции

Функция ИмяФайлаПечатнойФормыОбъекта(ОбъектПечати, ИмяФайлаПечатнойФормы)
	Если ТипЗнч(ИмяФайлаПечатнойФормы) = Тип("Соответствие") Тогда
		Возврат Строка(ИмяФайлаПечатнойФормы[ОбъектПечати]);
	ИначеЕсли ТипЗнч(ИмяФайлаПечатнойФормы) = Тип("Строка") И Не ПустаяСтрока(ИмяФайлаПечатнойФормы) Тогда
		Возврат ИмяФайлаПечатнойФормы;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ВычислитьИспользованиеВывода(ТабличныйДокумент)
	Если ТабличныйДокумент.Вывод = ИспользованиеВывода.Авто Тогда
		Возврат ?(ПравоДоступа("Вывод", Метаданные), ИспользованиеВывода.Разрешить, ИспользованиеВывода.Запретить);
	Иначе
		Возврат ТабличныйДокумент.Вывод;
	КонецЕсли;
КонецФункции

Функция ИмяФайлаПечатнойФормыПоУмолчанию(ОбъектПечати, НазваниеПечатнойФормы)
	
	Если ОбщегоНазначения.ЭтоДокумент(Метаданные.НайтиПоТипу(ТипЗнч(ОбъектПечати))) Тогда
		ПараметрыДляВставки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектПечати, "Дата,Номер");
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
			МодульПрефиксацияОбъектовКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПрефиксацияОбъектовКлиентСервер");
			ПараметрыДляВставки.Номер = МодульПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ПараметрыДляВставки.Номер);
		КонецЕсли;
		ПараметрыДляВставки.Дата = Формат(ПараметрыДляВставки.Дата, "ДЛФ=D");
		ПараметрыДляВставки.Вставить("НазваниеПечатнойФормы", НазваниеПечатнойФормы);
		Шаблон = НСтр("ru = '[НазваниеПечатнойФормы] № [Номер] от [Дата]'");
	Иначе
		ПараметрыДляВставки = Новый Структура;
		ПараметрыДляВставки.Вставить("НазваниеПечатнойФормы",НазваниеПечатнойФормы);
		ПараметрыДляВставки.Вставить("ПредставлениеОбъекта", ОбщегоНазначения.ПредметСтрокой(ОбъектПечати));
		ПараметрыДляВставки.Вставить("ТекущаяДата",Формат(ТекущаяДатаСеанса(), "ДЛФ=D"));
		Шаблон = НСтр("ru = '[НазваниеПечатнойФормы] - [ПредставлениеОбъекта] - [ТекущаяДата]'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ПараметрыДляВставки);
	
КонецФункции

Функция УникальноеИмяФайла(ИмяФайла)
	
	Файл = Новый Файл(ИмяФайла);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	Расширение = Файл.Расширение;
	Папка = Файл.Путь;
	
	Счетчик = 1;
	Пока Файл.Существует() Цикл
		Счетчик = Счетчик + 1;
		Файл = Новый Файл(Папка + ИмяБезРасширения + " (" + Счетчик + ")" + Расширение);
	КонецЦикла;
	
	Возврат Файл.ПолноеИмя;

КонецФункции

Процедура ВставитьКартинкиВHTML(ИмяФайлаHTML)
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.Прочитать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	ТекстHTML = ТекстовыйДокумент.ПолучитьТекст();
	
	ФайлHTML = Новый Файл(ИмяФайлаHTML);
	
	ИмяПапкиКартинок = ФайлHTML.ИмяБезРасширения + "_files";
	ПутьКПапкеКартинок = СтрЗаменить(ФайлHTML.ПолноеИмя, ФайлHTML.Имя, ИмяПапкиКартинок);
	
	// Ожидается, что в папке будут только картинки.
	ФайлыКартинок = НайтиФайлы(ПутьКПапкеКартинок, "*");
	
	Для Каждого ФайлКартинки Из ФайлыКартинок Цикл
		КартинкаТекстом = Base64Строка(Новый ДвоичныеДанные(ФайлКартинки.ПолноеИмя));
		КартинкаТекстом = "data:image/" + Сред(ФайлКартинки.Расширение,2) + ";base64," + Символы.ПС + КартинкаТекстом;
		
		ТекстHTML = СтрЗаменить(ТекстHTML, ИмяПапкиКартинок + "\" + ФайлКартинки.Имя, КартинкаТекстом);
	КонецЦикла;
		
	ТекстовыйДокумент.УстановитьТекст(ТекстHTML);
	ТекстовыйДокумент.Записать(ИмяФайлаHTML, КодировкаТекста.UTF8);
	
КонецПроцедуры

Функция ПолучитьИмяФайлаДляАрхива(Форма, НастройкиПечатныхФорм, ПереводитьИменаФайловВТранслит)
	
	Результат = "";
	
	Для Каждого НастройкаПечатнойФормы Из НастройкиПечатныхФорм Цикл
		
		Если Не НастройкаПечатнойФормы.Печатать Тогда
			Продолжить;
		КонецЕсли;
		
		Если НастройкаПечатнойФормы.ТабличныйДокумент = Неопределено Тогда
			ПечатнаяФорма = ТабличныйДокументПоНастройкеПечатнойФормы(НастройкаПечатнойФормы);
		Иначе
			ПечатнаяФорма = НастройкаПечатнойФормы.ТабличныйДокумент;
		КонецЕсли;
		
		Если ВычислитьИспользованиеВывода(ПечатнаяФорма) = ИспользованиеВывода.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(Результат) Тогда
			Результат = НастройкаПечатнойФормы.Название;
		Иначе
			Результат = НСтр("ru = 'Документы'");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПереводитьИменаФайловВТранслит Тогда
		Результат = СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(Результат);
	КонецЕсли;
	
	Возврат Результат + ".zip";
	
КонецФункции

#КонецОбласти

#КонецОбласти
