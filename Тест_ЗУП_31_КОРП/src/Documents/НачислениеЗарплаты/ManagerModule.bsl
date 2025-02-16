#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.НачислениеЗарплаты - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.НачислениеЗарплаты - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("ВидыУчетов") Тогда 
		ВидыУчетов = ДополнительныеПараметры.ВидыУчетов;
	КонецЕсли;
	
	ВременнаяРегистрацияДвижений = Ложь;
	Если ДополнительныеПараметры <> Неопределено И ДополнительныеПараметры.Свойство("ВременнаяРегистрацияДвижений") Тогда
		ВременнаяРегистрацияДвижений = Истина;
	КонецЕсли;
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	// Предусмотрен режим проведения по отдельным физическим лицам.
	СписокФизическихЛиц = Неопределено;
	Если ДополнительныеПараметры <> Неопределено  
		И ДополнительныеПараметры.Свойство("ФизическиеЛица")
		И ДополнительныеПараметры.ФизическиеЛица.Количество() > 0 Тогда
		СписокФизическихЛиц = ДополнительныеПараметры.ФизическиеЛица
	КонецЕсли;
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, РеквизитыДляПроведения.МесяцНачисления, СписокФизическихЛиц, СтруктураВидовУчета);
	
	Если СтруктураВидовУчета.Начисления Тогда
		РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления), ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
		РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
		РасчетЗарплатыРасширенный.СформироватьДвиженияНачисленийПоДоговорам(Движения, Отказ, РеквизитыДляПроведения.Организация, НачалоМесяца(РеквизитыДляПроведения.МесяцНачисления), ДанныеДляПроведения.НачисленияПоДоговорам);
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
			Модуль.СформироватьДвиженияНачислений(Движения, Отказ, ДанныеДляПроведения, РеквизитыДляПроведения.МесяцНачисления);
		КонецЕсли;
		ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, РеквизитыДляПроведения, Отказ);
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления), ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
		ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержанийДоПределаПоСотрудникам(Движения, Отказ, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.УдержанияДоПределаПоСотрудникам);
		РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
		
#Область РегистрацияДоходовВУчетеНДФЛ

		// - Регистрация бухучета начислений, выполняется до вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
						ДанныеДляПроведения.НачисленияПоСотрудникам, Неопределено, Неопределено);
						
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
						ДанныеДляПроведения.НачисленияПоДоговорамСРаспределением, Неопределено, Неопределено);
						
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
						Неопределено, ДанныеДляПроведения.УдержанияЗаймов, Неопределено);
						
		// НДФЛ
		ДатаОперации = КонецМесяца(РеквизитыДляПроведения.МесяцНачисления);
		Если РеквизитыДляПроведения.РежимДоначисления Тогда
			ДатаОперации = УчетНДФЛРасширенный.ДатаОперацииПоДокументу(РеквизитыДляПроведения.ПланируемаяДатаВыплаты, РеквизитыДляПроведения.МесяцНачисления);
		КонецЕсли;
		
		// - Регистрация начислений в учете НДФЛ.
		ПланируемаяДатаВыплаты = РасчетЗарплатыРасширенныйКлиентСервер.ПланируемаяДатаВыплатыЗарплаты(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления);
		УчетНДФЛРасширенный.СформироватьДоходыНДФЛПоНачислениям(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации,
			ПланируемаяДатаВыплаты, ДанныеДляПроведения.МенеджерВременныхТаблиц,
			РеквизитыДляПроведения.МесяцНачисления, , , , ДокументСсылка);
			
		// - Регистрация договоров в учете НДФЛ.
		Если РасчетЗарплатыРасширенный.ВыплатыПоДоговорамГПХМогутНеОблагатьсяНДФЛ() Тогда
			ОбратныйИндекс = ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ.Количество();
			Пока ОбратныйИндекс > 0 Цикл
				ОбратныйИндекс = ОбратныйИндекс - 1;
				Если ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ[ОбратныйИндекс].НеОблагаетсяНДФЛ Тогда
					ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ.Удалить(ОбратныйИндекс);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ГрантыНеоблагаемыеНДФЛ") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГрантыНеоблагаемыеНДФЛ");
			Модуль.ОтобратьДоходыПоДоговорамПодрядаОблагаемыеНДФЛ(ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ);
		КонецЕсли;
		
		УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления),
			ДанныеДляПроведения.НачисленияПоДоговорамДляУчетаНДФЛ, , Истина, ДокументСсылка);
		
		УчетНДФЛ.СформироватьДоходыНДФЛПоКодамДоходовИзТаблицыЗначений(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления),
			ДанныеДляПроведения.МатериальнаяВыгода, , Истина, ДокументСсылка);
		
		ОтражениеЗарплатыВБухучетеРасширенный.ДополнитьДоходыНДФЛСведениямиОРаспределенииПоСтатьямФинансирования(Движения);
		
		// Записываем движения, необходимо для регистрации удержаний в учете начисленной зарплаты.
		Движения.СведенияОДоходахНДФЛ.Записать();
		Движения.СведенияОДоходахНДФЛ.Записывать = Ложь;
				
#КонецОбласти
			
		УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, РеквизитыДляПроведения.Организация, ДатаОперации, ДанныеДляПроведения.НДФЛ, , , НачалоДня(КонецМесяца(РеквизитыДляПроведения.МесяцНачисления)));
		УчетНДФЛРасширенный.СформироватьСоциальныеВычетыПоУдержаниям(РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления), РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.Удержания);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.УчетНачисленнойЗарплаты Тогда
		// Учет начисленной зарплаты
		// - регистрация НДФЛ в учете начислений и удержаний.
		УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛПоСотрудникам, РеквизитыДляПроведения.Организация, ДатаОперации);
		УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛ(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.НДФЛПоСотрудникам, ДанныеДляПроведения.МенеджерВременныхТаблиц, РеквизитыДляПроведения.ПорядокВыплаты);
		УчетНачисленнойЗарплаты.ЗарегистрироватьКорректировкиВыплаты(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.КорректировкиВыплатыПоСотрудникам, ДанныеДляПроведения.МенеджерВременныхТаблиц, РеквизитыДляПроведения.ПорядокВыплаты);
		
		// - Регистрация бухучета удержаний и НДФЛ
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
						Неопределено, ДанныеДляПроведения.УдержанияПоСотрудникам, ДанныеДляПроведения.НДФЛПоСотрудникам);
		
		// - Регистрация договоров в учете начислений и удержаний.
		// (Специально сначала регистрируем договоры для использования этих сумм в качестве базы удержаний).
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
			ДанныеДляПроведения.НачисленияПоДоговорамСРаспределением, Неопределено, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
		
		// - Регистрация начислений и удержаний в учете начислений и удержаний.
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
			
		// - Регистрация отработанного времени в учете начислений и удержаний.
		УчетНачисленнойЗарплаты.ЗарегистрироватьОтработанноеВремя(
			Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам, РеквизитыДляПроведения.ПорядокВыплаты, Истина);
			
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
			Модуль.ЗарегистрироватьНачисленияУдержания(Движения, Отказ, ДанныеДляПроведения, РеквизитыДляПроведения.МесяцНачисления, РеквизитыДляПроведения.ПорядокВыплаты);
			Модуль.ЗарегистрироватьОтработанноеВремя(Движения, Отказ, ДанныеДляПроведения, РеквизитыДляПроведения.МесяцНачисления, РеквизитыДляПроведения.ПорядокВыплаты);
		КонецЕсли;
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		// - Регистрация начислений в доходах для страховых взносов.
		УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, , Истина, РеквизитыДляПроведения.Ссылка);
		
		// - Регистрация договоров в доходах для страховых взносов.
		СведенияОДоходахСтраховыеВзносы = УчетСтраховыхВзносовРасширенный.СведенияОДоходахПоДоговорамСтраховыеВзносы(
								РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц);
		
		УчетСтраховыхВзносов.СформироватьДоходыСтраховыеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, СведенияОДоходахСтраховыеВзносы, Истина);
	КонецЕсли;
	
	Если СтруктураВидовУчета.ИсчисленныеСтраховыеВзносы Тогда
		// - страховые взносы
		УчетСтраховыхВзносов.СформироватьИсчисленныеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.СтраховыеВзносы);
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		СтандартнаяОбработка = Истина;
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОтложенноеПроведениеДокументов") Тогда 
			Модуль = ОбщегоНазначения.ОбщийМодуль("ОтражениеДокументовВУчетеСтраховыхВзносов");
			Модуль.ЗарегистрироватьДокументДляОтраженияВУчетеСтраховыхВзносов(Движения, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, СтандартнаяОбработка);
		КонецЕсли;
		
		Если СтандартнаяОбработка Тогда 
			УчетСтраховыхВзносов.СформироватьСтраховыеВзносыПоФизическимЛицам(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, РеквизитыДляПроведения.Ссылка, ДанныеДляПроведения.СтраховыеВзносы);
		КонецЕсли;
		
		// Займы
		// - взаиморасчеты по займам
		ЗаймыСотрудникам.ЗарегистрироватьВзаиморасчетыПоЗаймам(Движения, ДанныеДляПроведения.ВзаиморасчетыПоЗаймам, Отказ);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.УчетНачисленнойЗарплаты Тогда
		// - Регистрация займов в учете заработной платы.
		УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьПогашениеЗаймов(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.УдержанияЗаймов, РеквизитыДляПроведения.ПорядокВыплаты);
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		// - Регистрация материальной выгоды в учете НДФЛ.
		
		УчетНДФЛ.СформироватьНалогиВычеты(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления), ДанныеДляПроведения.НалогНаМатериальнуюВыгоду);
		УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НалогНаМатериальнуюВыгоду, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.МесяцНачисления));
		УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛ(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.НалогНаМатериальнуюВыгоду, ДанныеДляПроведения.МенеджерВременныхТаблиц, РеквизитыДляПроведения.ПорядокВыплаты);
		
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
						Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления,
						Неопределено, Неопределено, ДанныеДляПроведения.НалогНаМатериальнуюВыгоду);
		
		УчетСтраховыхВзносов.СформироватьПособия(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.Пособия, ДанныеДляПроведения.ПособияПоУходу);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Или СтруктураВидовУчета.Начисления Тогда
		
		Если Не ВременнаяРегистрацияДвижений Тогда
			
			// Получение признака о том, что нужно удалить перерасчеты текущего периода
			УдалитьПерерасчетыТекущегоПериода = Неопределено;
			Если ДополнительныеПараметры <> Неопределено Тогда
				ДополнительныеПараметры.Свойство("УдалитьПерерасчетыТекущегоПериода", УдалитьПерерасчетыТекущегоПериода);
			КонецЕсли;
			УдалитьПерерасчетыТекущегоПериода = (УдалитьПерерасчетыТекущегоПериода = Истина);
			
			ПериодыРасчетаСотрудников =  Неопределено;
			Если ДополнительныеПараметры <> Неопределено Тогда
				ДополнительныеПараметры.Свойство("ПериодыРасчетаСотрудников", ПериодыРасчетаСотрудников);
			КонецЕсли;
			
			ПерерасчетЗарплаты.УдалениеПерерасчетов(РеквизитыДляПроведения.Ссылка, УдалитьПерерасчетыТекущегоПериода, ПериодыРасчетаСотрудников);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		УчетСреднегоЗаработка.ЗарегистрироватьДанныеСреднегоЗаработка(Движения, Отказ, ДанныеДляПроведения.НачисленияДляСреднегоЗаработка);
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.НачислениеЗарплаты;
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	Для Каждого ОписаниеЗаполнения Из ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц Цикл
		ОписаниеЗаполнения.ВключатьВКраткийСостав = Истина;
	КонецЦикла;
	
	Возврат ОписаниеСостава;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	РасчетЗарплатыРасширенныйВызовСервера.НачислениеЗарплатыОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("РежимДоначисления");
	Поля.Добавить("Дата");
	Поля.Добавить("Номер");
	Поля.Добавить("Ссылка");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Процедура ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища) Экспорт
	
	РезультатЗаполнения = Новый Структура;
	
	// Получение данных для заполнения табличных частей документа.
	ОписаниеДокумента = СтруктураПараметров.ОписаниеДокумента;
	Организация = СтруктураПараметров.Организация;
	МесяцНачисления = СтруктураПараметров.МесяцНачисления;
	
	ДополнительныеПараметры = РасчетЗарплатыРасширенный.ДополнительныеПараметрыЗаполненияТаблицДокумента();
	ДополнительныеПараметры.ДокументСсылка = СтруктураПараметров.ДокументСсылка;
	ДополнительныеПараметры.Подразделение = СтруктураПараметров.Подразделение;
	ДополнительныеПараметры.ОкончаниеПериода = СтруктураПараметров.ОкончаниеПериода;
	ДополнительныеПараметры.РежимНачисления = СтруктураПараметров.РежимНачисления;
	ДополнительныеПараметры.ПорядокВыплаты = СтруктураПараметров.ПорядокВыплаты;
	ДополнительныеПараметры.СотрудникиПериодДействияПерерасчет = СтруктураПараметров.СотрудникиПериодДействияПерерасчет;
	ДополнительныеПараметры.ИспользоватьВоеннуюСлужбу = СтруктураПараметров.ИспользоватьВоеннуюСлужбу;
	ДополнительныеПараметры.НачислениеЗарплатыВоеннослужащим = СтруктураПараметров.НачислениеЗарплатыВоеннослужащим;
	ДополнительныеПараметры.ОкончательныйРасчетНДФЛ = СтруктураПараметров.ОкончательныйРасчетНДФЛ;
	ДополнительныеПараметры.ПроверятьРегистрациюПроцентаЕНВД = СтруктураПараметров.ПроверятьРегистрациюПроцентаЕНВД;
	ДополнительныеПараметры.ДатаВыплаты = СтруктураПараметров.ДатаВыплаты;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
		Модуль.ПриЗаполненииДополнительныхПараметровДанныхДляНачисленияЗарплаты(ДополнительныеПараметры);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.МногопотоковоеЗаполнениеДокументов") Тогда 
		ДокументПроведен = ЗначениеЗаполнено(СтруктураПараметров.ДокументСсылка) 
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураПараметров.ДокументСсылка, "Проведен");
		Модуль = ОбщегоНазначения.ОбщийМодуль("МногопотоковоеЗаполнениеДокументов");
		Если Не РегистрыРасчета.Начисления.ЕстьДвиженияПоРегистратору(СтруктураПараметров.ДокументСсылка) И Модуль.ИспользоватьМногопотоковоеЗаполнениеДокументов() Тогда
			ДополнительныеПараметры.АдресХранилища = АдресХранилища;
			Модуль.ПодготовитьДанныеДляЗаполнения(ОписаниеДокумента, Организация, МесяцНачисления, ДополнительныеПараметры);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеЗаполнения = РасчетЗарплатыРасширенный.ДанныеДляЗаполненияТаблицДокумента(ОписаниеДокумента, Организация, МесяцНачисления, ДополнительныеПараметры);
	
	РезультатЗаполнения.Вставить("ДанныеДляЗаполненияТаблицДокумента", ДанныеЗаполнения);
	
	ПоместитьВоВременноеХранилище(РезультатЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ВыполнитьПроведение(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДокументОбъект = ЗарплатаКадры.ДесериализоватьОбъектИзДвоичныхДанных(СтруктураПараметров.ДанныеДокумента);
	ДокументОбъект.ДополнительныеСвойства.Вставить("УдалитьПерерасчетыТекущегоПериода", СтруктураПараметров.УдалитьПерерасчетыТекущегоПериода);
	
	Если СтруктураПараметров.Свойство("ПериодыРасчетаСотрудников") Тогда
		ДокументОбъект.ДополнительныеСвойства.Вставить("ПериодыРасчетаСотрудников", СтруктураПараметров.ПериодыРасчетаСотрудников);
	КонецЕсли; 
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
		Модуль.ЗаписатьВидОперацииДокумента(ДокументОбъект.Ссылка, СтруктураПараметров.ВидОперации);
	КонецЕсли;
	ПоместитьВоВременноеХранилище(ЗарплатаКадры.СериализоватьОбъектВДвоичныеДанные(ДокументОбъект), АдресХранилища);
	
КонецПроцедуры

Функция ПредставлениеТипаДоначислениеПерерасчет() Экспорт
	
	Возврат НСтр("ru='Доначисление, перерасчет'");
	
КонецФункции

#Область ПервоначальноеЗаполнениеИОбновлениеИнформационнойБазы

Процедура ЗаполнитьПланируемуюДатуВыплатыЗарплатыПоДоговорам() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НачисленияПоДоговорам.Ссылка
	|ИЗ
	|	Документ.НачислениеЗарплаты.НачисленияПоДоговорам КАК НачисленияПоДоговорам
	|ГДЕ
	|	НачисленияПоДоговорам.ПланируемаяДатаВыплаты <> ДАТАВРЕМЯ(1, 1, 1)";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		// Обновление уже выполнялось
		Возврат;
		
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачисленияПоДоговорам.Ссылка КАК Документ,
	|	НачисленияПоДоговорам.Ссылка.Организация КАК Организация,
	|	НачисленияПоДоговорам.Ссылка.МесяцНачисления КАК МесяцНачисления
	|ИЗ
	|	Документ.НачислениеЗарплаты.НачисленияПоДоговорам КАК НачисленияПоДоговорам
	|ГДЕ
	|	НачисленияПоДоговорам.ПланируемаяДатаВыплаты = ДАТАВРЕМЯ(1, 1, 1)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("Организация") Цикл
		
		Пока Выборка.Следующий() Цикл
			
			ПланируемаяДатаВыплатыЗарплаты = РасчетЗарплатыРасширенныйКлиентСервер.ПланируемаяДатаВыплатыЗарплаты(
				Выборка.Организация, Выборка.МесяцНачисления);
				
			ДокументОбъект = Выборка.Документ.ПолучитьОбъект();
			
			ДокументОбъект.ОбменДанными.Загрузка = Истина;
			
			Для каждого СтрокаНачисленияПоДоговорам Из ДокументОбъект.НачисленияПоДоговорам Цикл
				СтрокаНачисленияПоДоговорам.ПланируемаяДатаВыплаты = ПланируемаяДатаВыплатыЗарплаты;
			КонецЦикла;
			
			ДокументОбъект.Записать();
			
		КонецЦикла;
		
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ПредставлениеДокумента = Метаданные.Документы.НачислениеЗарплаты.Представление();
	
	ОписаниеКоманды = ЗарплатаКадрыРасширенный.ОписаниеКомандыСозданияДокумента(
		"Документ.НачислениеЗарплаты",
		ПредставлениеДокумента);
		
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокумента(
		КомандыСозданияДокументов, ОписаниеКоманды);
		
	ВидыОперацийРасчетаЗарплаты = Новый Массив;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
		ВидыОперацийРасчетаЗарплаты = Модуль.ВидыОперацийРасчетаЗарплаты();
	КонецЕсли; 
	
	ПорядокВидовОпераций = 1;
	Для Каждого ВидОперации Из ВидыОперацийРасчетаЗарплаты Цикл
		
		ВидОперацииСтрокой = Строка(ВидОперации);
		ОписаниеКоманды = ЗарплатаКадрыРасширенный.ОписаниеКомандыСозданияДокумента(
			"Документ.НачислениеЗарплаты",
			ВидОперацииСтрокой,
			ПредставлениеДокумента + ПорядокВидовОпераций);
		
		Параметры = Новый Структура;
		Параметры.Вставить("ВидОперации", ВидОперации);

		ОписаниеКоманды.Параметры = Параметры; 
		
		ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокумента(
			КомандыСозданияДокументов, ОписаниеКоманды);
			
		ПорядокВидовОпераций = ПорядокВидовОпераций + 1;
			
	КонецЦикла; 
	
КонецФункции

Процедура ЗаполнитьПредставлениеРаспределенияРезультатовРасчета(ДокументОбъект) Экспорт 
	
	ДокументОбъект.ПредставлениеРаспределенияРезультатовРасчета.Очистить();
	
	ПроверяемыеПоля = Новый Структура;
	ПроверяемыеПоля.Вставить("СтатьяФинансирования", Справочники.СтатьиФинансированияЗарплата.ПустаяСсылка());
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда
		ПроверяемыеПоля.Вставить("СтатьяРасходов", Справочники.СтатьиРасходовЗарплата.ПустаяСсылка());
	КонецЕсли;	
	ПроверяемыеПоля.Вставить("СпособОтраженияЗарплатыВБухучете", Справочники.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка());
		
	ЗаполнитьДанныеПредставленияРаспределенияРезультатовНачисленийУдержаний(ДокументОбъект, ДокументОбъект.РаспределениеРезультатовНачислений, ПроверяемыеПоля, Истина);
	
	ПроверяемыеПоля.Удалить("СпособОтраженияЗарплатыВБухучете");
	ПроверяемыеПоля.Вставить("Сотрудник", Справочники.Сотрудники.ПустаяСсылка());
	
	ЗаполнитьДанныеПредставленияРаспределенияРезультатовНачисленийУдержаний(ДокументОбъект, ДокументОбъект.РаспределениеРезультатовУдержаний, ПроверяемыеПоля, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПредставленияРаспределенияРезультатовНачисленийУдержаний(ДокументОбъект, РаспределениеРезультатов, ПроверяемыеПоля, РаспределениеНачислений)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("РаспределениеРезультатов", РаспределениеРезультатов);
					   
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаспределениеРезультатов.НомерСтроки,
	|	РаспределениеРезультатов.ИдентификаторСтроки,
	|	&ПроверяемыеПоля КАК ПроверяемыеПоля,
	|	РаспределениеРезультатов.Результат
	|ПОМЕСТИТЬ ВТРаспределениеРезультатов
	|ИЗ
	|	&РаспределениеРезультатов КАК РаспределениеРезультатов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаспределениеРезультатов.ИдентификаторСтроки,
	|	КОЛИЧЕСТВО(РаспределениеРезультатов.НомерСтроки) КАК КоличествоСтрок,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА &ПроверкаНаличияПустыхПолей
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ЕстьОшибкиЗаполнения
	|ПОМЕСТИТЬ ВТСгруппированныеДанныеПоИдентификаторам
	|ИЗ
	|	ВТРаспределениеРезультатов КАК РаспределениеРезультатов
	|
	|СГРУППИРОВАТЬ ПО
	|	РаспределениеРезультатов.ИдентификаторСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаспределениеРезультатов.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	РаспределениеРезультатов.НомерСтроки КАК НомерСтрокиРаспределения,
	|	СгруппированныеДанныеПоИдентификаторам.КоличествоСтрок КАК КоличествоЭлементовПредставления,
	|	СгруппированныеДанныеПоИдентификаторам.ЕстьОшибкиЗаполнения КАК ЕстьОшибкиЗаполнения,
	|	РаспределениеРезультатов.Результат КАК Результат
	|ИЗ
	|	ВТРаспределениеРезультатов КАК РаспределениеРезультатов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСгруппированныеДанныеПоИдентификаторам КАК СгруппированныеДанныеПоИдентификаторам
	|		ПО РаспределениеРезультатов.ИдентификаторСтроки = СгруппированныеДанныеПоИдентификаторам.ИдентификаторСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторСтроки,
	|	НомерСтрокиРаспределения";

	
	ПроверяемыеПоляТаблицы = "";
	ПроверкаНаличияПустыхПолей = "";
	
	Для Каждого КлючЗначение Из ПроверяемыеПоля Цикл
		
		Запрос.УстановитьПараметр(КлючЗначение.Ключ + "ПустаяСсылка", КлючЗначение.Значение);
		
		ПроверяемыеПоляТаблицы = ПроверяемыеПоляТаблицы + "
								|	РаспределениеРезультатов." + КлючЗначение.Ключ + ",";
								
		ПроверкаНаличияПустыхПолей = ПроверкаНаличияПустыхПолей + " ИЛИ РаспределениеРезультатов." + КлючЗначение.Ключ + " = &" + КлючЗначение.Ключ + "ПустаяСсылка";
							
	КонецЦикла;	
						
	ПроверкаНаличияПустыхПолей = Сред(ПроверкаНаличияПустыхПолей, 6);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПроверяемыеПоля КАК ПроверяемыеПоля,", ПроверяемыеПоляТаблицы);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПроверкаНаличияПустыхПолей", ПроверкаНаличияПустыхПолей); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.СледующийПоЗначениюПоля("ИдентификаторСтроки") Цикл
		
		НомерЭлементаПредставления = 0;
		Пока Выборка.Следующий() Цикл
			НомерЭлементаПредставления = НомерЭлементаПредставления + 1;
					
			СтрокаПредставленияРаспределения = ДокументОбъект.ПредставлениеРаспределенияРезультатовРасчета.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПредставленияРаспределения, Выборка);
			
			СтрокаПредставленияРаспределения.ПредставлениеРезультата = Формат(Выборка.Результат, "ЧДЦ=2; ЧРГ=; ЧН=' '");
			СтрокаПредставленияРаспределения.РаспределениеНачислений = РаспределениеНачислений;
			СтрокаПредставленияРаспределения.НомерЭлементаПредставления = НомерЭлементаПредставления;
		КонецЦикла;	
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеДляПроведения(РеквизитыДляПроведения, МесяцНачисления, СписокФизическихЛиц, СтруктураВидовУчета)
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	ОстальныеВидыУчета = Ложь;
	Для Каждого КлючИЗначение Из СтруктураВидовУчета Цикл
		Если КлючИЗначение.Ключ = "ДанныеДляРасчетаСреднего" Тогда 
			Продолжить;
		КонецЕсли;
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Булево") 
			И КлючИЗначение.Значение Тогда 
			ОстальныеВидыУчета = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОстальныеВидыУчета Тогда
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет,Пособия,ПособияПерерасчет,Льготы,ЛьготыПерерасчет", "Ссылка.МесяцНачисления", , СписокФизическихЛиц);
		РасчетЗарплатыРасширенный.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Удержания,УдержанияПерерасчет", СписокФизическихЛиц);
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,Пособия,НачисленияПоДоговорам,Льготы", СписокФизическихЛиц);
		РасчетЗарплатыРасширенный.ЗаполнитьПогашениеЗадолженностиПоУдержаниям(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.МесяцНачисления, ?(РеквизитыДляПроведения.РежимДоначисления, "УдержанияПерерасчет", "Удержания"));
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплата");
			ПараметрыУправленческаяЗарплата = Модуль.ДополнительныеПараметрыПодготовкиДанныхДляПроведения();
			ПараметрыУправленческаяЗарплата.ПолеДатыДействия = "Ссылка.МесяцНачисления"; 
			ПараметрыУправленческаяЗарплата.ПолеВидаНачисления = "Начисление"; 
			ПараметрыУправленческаяЗарплата.СписокФизическихЛиц = СписокФизическихЛиц;
			Модуль.ПриПодготовкеДанныхДляПроведенияДокументаРасчетаЗарплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ПараметрыУправленческаяЗарплата);
		КонецЕсли;
		
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеПоДоговорамПодряда(ДанныеДляПроведения, РеквизитыДляПроведения, СписокФизическихЛиц);
		
		ПособиеПлатитУчастникПилотногоПроекта = ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.МесяцНачисления);
		
		УчетПособийСоциальногоСтрахованияРасширенный.ЗаполнитьСведенияОПособияхПоУходуЗаРебенком(РеквизитыДляПроведения.Ссылка, ПособиеПлатитУчастникПилотногоПроекта, ДанныеДляПроведения, , "ПособияПерерасчет", СписокФизическихЛиц);
		
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, СписокФизическихЛиц);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, СписокФизическихЛиц);
		РасчетЗарплаты.ЗаполнитьДанныеСтраховыхВзносов(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, СписокФизическихЛиц);
		
		ЗаймыСотрудникам.ЗаполнитьДанныеДляПроведенияПоЗаймам(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, КонецМесяца(МесяцНачисления), , СписокФизическихЛиц);
		
	КонецЕсли;
	
	Если СтруктураВидовУчета.ДанныеДляРасчетаСреднего Тогда
		ДополнительныеПараметры = УчетСреднегоЗаработка.ДополнительныеПараметрыРегистрацииДанныхСреднегоЗаработка("Начисления,НачисленияПерерасчет,Пособия");
		УчетСреднегоЗаработка.ЗаполнитьТаблицыДляРегистрацииДанныхСреднегоЗаработка(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры, СписокФизическихЛиц);
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеЗарплаты.Ссылка,
	|	НачислениеЗарплаты.МесяцНачисления,
	|	НачислениеЗарплаты.Организация,
	|	НачислениеЗарплаты.ПланируемаяДатаВыплаты,
	|	НачислениеЗарплаты.РежимДоначисления,
	|	НачислениеЗарплаты.ПорядокВыплаты
	|ИЗ
	|	Документ.НачислениеЗарплаты КАК НачислениеЗарплаты
	|ГДЕ
	|	НачислениеЗарплаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.НомерСтроки,
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки,
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.Территория,
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.УсловияТруда,
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения,
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.Результат,
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.НачислениеЗарплаты.РаспределениеПоТерриториямУсловиямТруда КАК НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	НачислениеЗарплатыРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура()
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, МесяцНачисления, Организация, ПланируемаяДатаВыплаты, РежимДоначисления, ПорядокВыплаты, РаспределениеПоТерриториямУсловиямТруда");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

Процедура ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, РеквизитыДокумента, Отказ)
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Начисления.*
	               |ИЗ
	               |	Документ.НачислениеЗарплаты.Начисления КАК Начисления
	               |ГДЕ
	               |	Начисления.Ссылка = &Ссылка";
				   
	Начисления = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
	ПараметрыПроверки.Организация = РеквизитыДокумента.Организация;
	ПараметрыПроверки.ПериодРегистрации = РеквизитыДокумента.МесяцНачисления;
	ПараметрыПроверки.Документ = ДокументСсылка;
	ПараметрыПроверки.Начисления = Начисления;
	
	РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли