#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает пространство имен пакета XDTO для обмена ЭЛН с ФСС.
//   Может использоваться в БРО.
//
// Возвращаемое значение:
//   Строка - Пространство имен пакета XDTO для обмена ЭЛН с ФСС.
//
Функция ПространствоИмен() Экспорт
	Возврат "http://ru/ibs/fss/ln/ws/FileOperationsLn.wsdl";
КонецФункции

// Возвращает версию формата обмена ЭЛН с ФСС.
//   Может использоваться в БРО.
//
// Возвращаемое значение:
//   Строка - Версия формата обмена ЭЛН с ФСС.
//
Функция Версия() Экспорт
	Возврат "1.1";
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодготовкаНешифрованногоЗапроса

// Формирует параметры получения электронного листка нетрудоспособности.
//
// Параметры:
//   БольничныйЛист - ДокументОбъект.БольничныйЛист, ДанныеФормыСтруктура - Больничный.
//
// Возвращаемое значение:
//   Структура - Результат выгрузки в XML.
//       * Организация - СправочникСсылка.Организации - Организация, для которой получается ЭЛН.
//       * РегистрационныйНомерФСС - Строка - Рег. номер организации, для которой получается ЭЛН.
//       * ТекстXML - Строка - Сведения, необходимые для получения ЭЛН в формате XML.
//
Функция ВыгрузитьЗапросДляПолученияЭЛН(БольничныйЛист) Экспорт
	Отказ = Ложь;
	ДанныеБольничного = ДанныеБольничногоДляПолученияЭЛН(БольничныйЛист, Отказ);
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПакетXDTO = ФабрикаXDTO.Пакеты.Получить(ПространствоИмен());
	getPrivateLNData = ФабрикаXDTO.Создать(ПакетXDTO.КорневыеСвойства.Получить("getPrivateLNData").Тип);
	
	getPrivateLNData.lnCode = ДанныеБольничного.НомерЛисткаНетрудоспособности;
	getPrivateLNData.regNum = ДанныеБольничного.РегистрационныйНомерФСС;
	getPrivateLNData.snils  = ДанныеБольничного.СНИЛС;
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, getPrivateLNData, "getPrivateLNData");
	
	Результат = Новый Структура("Организация, РегистрационныйНомерФСС, ТекстXML");
	Результат.Организация             = БольничныйЛист.Организация;
	Результат.РегистрационныйНомерФСС = ДанныеБольничного.РегистрационныйНомерФСС;
	Результат.ТекстXML                = ЗаписьXML.Закрыть();
	
	Возврат Результат;
КонецФункции

// Формирует параметры отправки реестра электронных листков нетрудоспособности.
//
// Параметры:
//   Документ - ДокументОбъект.РеестрДанныхЭЛНЗаполняемыхРаботодателем, ДанныеФормыСтруктура - Реестр.
//   ПомещатьВФайл - Булево - Истина, если результат надо поместить в файл и вернуть адрес во временном хранилище.
//   ИдентификаторФормы - УникальныйИдентификатор - Идентификатор формы. Обязательный, если ПомещатьВФайл = Истина.
//
// Возвращаемое значение:
//   Структура - Результат выгрузки в XML.
//       * Организация - СправочникСсылка.Организации - Организация, для которой отправляется реестр ЭЛН.
//       * РегистрационныйНомерФСС - Строка - Рег. номер организации, для которой отправляется реестр ЭЛН.
//       * ТекстXML - Строка - Данные реестра в формате XML (электронное представление),
//                             либо пустая строка если ПомещатьВФайл = Истина.
//       * Адрес - Строка - Адрес временного хранилища, по которому размещены двоичные данные файла реестра в формате XML,
//                          либо пустая строка если ПомещатьВФайл = Ложь.
//
Функция ВыгрузитьЗапросДляОтправкиРеестраЭЛН(Документ, ПомещатьВФайл, ИдентификаторФормы) Экспорт
	ПакетXDTO = ФабрикаXDTO.Пакеты.Получить(ПространствоИмен());
	
	prParseReestrFile = ФабрикаXDTO.Создать(ПакетXDTO.КорневыеСвойства.Получить("prParseReestrFile").Тип);
	
	request = ФабрикаXDTO.Создать(prParseReestrFile.Свойства().Получить("request").Тип);
	request.regNum = Документ.РегистрационныйНомерФСС;
	
	pXmlFile = ФабрикаXDTO.Создать(request.Свойства().Получить("pXmlFile").Тип);
	ROWSET   = ФабрикаXDTO.Создать(pXmlFile.Свойства().Получить("ROWSET").Тип);
	
	ТипROW = ROWSET.Свойства().Получить("ROW").Тип;
	
	ROWSET.version          = Версия();
	ROWSET.software         = Лев("1С:" + Метаданные.Синоним, 255);
	ROWSET.version_software = Лев(Метаданные.Версия, 15);
	
	ROWSET.author = Строка(Документ.РеестрСоставил);
	ROWSET.phone  = Строка(Документ.ТелефонСоставителя);
	ROWSET.email  = Строка(Документ.АдресЭлектроннойПочтыСоставителя);
	
	ФИО = Новый Структура("Руководитель, ГлавныйБухгалтер", Документ.Руководитель, Документ.ГлавныйБухгалтер);
	ЗаполнитьПолныеФИО(ФИО);
	
	Для Каждого ДанныеЛН Из Документ.ДанныеЭЛН Цикл
		
		ROW = ROWSET.ROW.Добавить(ФабрикаXDTO.Создать(ТипROW));
		
		УстановитьЗначениеЕслиЗаполнено(ROW.LN_CODE,    ДанныеЛН.НомерЛисткаНетрудоспособности);
		УстановитьЗначениеЕслиЗаполнено(ROW.SNILS,      СтрЗаменить(СтрЗаменить(ДанныеЛН.СНИЛС, "-","")," ",""));
		УстановитьЗначениеЕслиЗаполнено(ROW.INN_PERSON, ДанныеЛН.ИНН);
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPLOYER,   Строка(Документ.Организация));
		
		ROW.EMPL_FLAG = ?(ДанныеЛН.ВидЗанятости = Перечисления.ВидыЗанятости.ОсновноеМестоРаботы, 1 ,0);
		
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPL_REG_NO,        Документ.РегистрационныйНомерФСС);
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPL_PARENT_NO,     Документ.КодПодчиненностиФСС);
		УстановитьЗначениеЕслиЗаполнено(ROW.EMPL_REG_NO2,       Документ.ДополнительныйКодФСС);
		УстановитьЗначениеЕслиЗаполнено(ROW.APPROVE1,           ФИО.Руководитель);
		УстановитьЗначениеЕслиЗаполнено(ROW.APPROVE2,           ФИО.ГлавныйБухгалтер);
		УстановитьЗначениеЕслиЗаполнено(ROW.BASE_AVG_SAL,       ДанныеЛН.БазаДляРасчетаСреднегоЗаработка);
		УстановитьЗначениеЕслиЗаполнено(ROW.BASE_AVG_DAILY_SAL, ДанныеЛН.СреднийДневнойЗаработок);
		
		Если ДанныеЛН.СтажЛет <> 0 Или ДанныеЛН.СтажМесяцев <> 0 Тогда
			ROW.INSUR_YY = ДанныеЛН.СтажЛет;
			ROW.INSUR_MM = ДанныеЛН.СтажМесяцев;
		КонецЕсли;
		
		РазностьСтажей = УчетПособийСоциальногоСтрахования.ПодсчитатьРазностьСтажейВГодахИМесяцах(
			ДанныеЛН.СтажРасширенныйЛет,
			ДанныеЛН.СтажРасширенныйМесяцев,
			ДанныеЛН.СтажЛет,
			ДанныеЛН.СтажМесяцев);
		Если РазностьСтажей.РазностьЛет <> 0 Или РазностьСтажей.РазностьМесяцев <> 0 Тогда
			ROW.NOT_INSUR_YY = РазностьСтажей.РазностьЛет;
			ROW.NOT_INSUR_MM = РазностьСтажей.РазностьМесяцев;
		КонецЕсли;
		
		УстановитьЗначениеЕслиЗаполнено(ROW.CALC_CONDITION1,  ДанныеЛН.УсловияИсчисленияКод1);
		УстановитьЗначениеЕслиЗаполнено(ROW.CALC_CONDITION2,  ДанныеЛН.УсловияИсчисленияКод2);
		УстановитьЗначениеЕслиЗаполнено(ROW.CALC_CONDITION3,  ДанныеЛН.УсловияИсчисленияКод3);
		УстановитьЗначениеЕслиЗаполнено(ROW.FORM1_DT,         ДанныеЛН.ДатаАктаН1);
		УстановитьЗначениеЕслиЗаполнено(ROW.RETURN_DATE_EMPL, ДанныеЛН.ПриступитьКРаботеС);
		УстановитьЗначениеЕслиЗаполнено(ROW.DT1_LN,           ДанныеЛН.ДатаНачалаОплаты);
		УстановитьЗначениеЕслиЗаполнено(ROW.DT2_LN,           ДанныеЛН.ДатаОкончанияОплаты);
		
		ROW.EMPL_PAYMENT = ДанныеЛН.СуммаОплатыЗаСчетРаботодателя;
		ROW.FSS_PAYMENT  = ДанныеЛН.СуммаОплатыЗаСчетФСС;
		ROW.PAYMENT      = ДанныеЛН.СуммаОплатыЗаСчетРаботодателя + ДанныеЛН.СуммаОплатыЗаСчетФСС;
		
		Если ДанныеЛН.Исправление Тогда
			УстановитьЗначениеЕслиЗаполнено(ROW.CORRECTION_REASON, ДанныеЛН.КодПричиныИсправления);
			УстановитьЗначениеЕслиЗаполнено(ROW.CORRECTION_NOTE,   СокрЛП(ДанныеЛН.ОписаниеПричиныИсправления));
		КонецЕсли;
		
		УстановитьЗначениеЕслиЗаполнено(ROW.LN_HASH, ДанныеЛН.Хеш);
		
	КонецЦикла;
	
	prParseReestrFile.request = request;
	request.pXmlFile = pXmlFile;
	pXmlFile.ROWSET = ROWSET;
	
	ЗаписьXML = Новый ЗаписьXML;
	Если ПомещатьВФайл Тогда
		ПолноеИмяФайла = ПолучитьИмяВременногоФайла("xml");
		ЗаписьXML.ОткрытьФайл(ПолноеИмяФайла, "UTF-8");
	Иначе
		ЗаписьXML.УстановитьСтроку("UTF-8");
	КонецЕсли;
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ROWSET, "ROWSET");
	
	Результат = Новый Структура("Организация, РегистрационныйНомерФСС, ТекстXML, Адрес");
	Результат.Организация             = Документ.Организация;
	Результат.РегистрационныйНомерФСС = Документ.РегистрационныйНомерФСС;
	Результат.ТекстXML                = ЗаписьXML.Закрыть();
	
	Если ПомещатьВФайл Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
		Результат.Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторФормы);
		ОбщегоНазначения.УдалитьВременныйКаталог(ПолноеИмяФайла);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция ДанныеБольничногоДляПолученияЭЛН(БольничныйЛист, Отказ)
	Результат = Новый Структура("НомерЛисткаНетрудоспособности, РегистрационныйНомерФСС, СНИЛС");
	
	// Номер больничного листа.
	Результат.НомерЛисткаНетрудоспособности = БольничныйЛист.НомерЛисткаНетрудоспособности;
	
	// Регистрационный номер ФСС организации (страхователя).
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		БольничныйЛист.Организация,
		БольничныйЛист.Дата,
		"РегистрационныйНомерФСС");
	ОргСведения.Свойство("РегистрационныйНомерФСС", Результат.РегистрационныйНомерФСС);
	
	// СНИЛС сотрудника на которого оформлен листок нетрудоспособности.
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, БольничныйЛист.Сотрудник, "СтраховойНомерПФР");
	Если КадровыеДанные.Количество() > 0 Тогда
		Результат.СНИЛС = СтрЗаменить(СтрЗаменить(КадровыеДанные[0].СтраховойНомерПФР, "-", ""), " ", "");
	КонецЕсли;
	
	// Проверка результатов.
	Если Не ЗначениеЗаполнено(Результат.НомерЛисткаНетрудоспособности) Тогда
		Текст = НСтр("ru = 'Не заполнен номер листка нетрудоспособности'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "НомерЛисткаНетрудоспособности", "Объект", Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Результат.РегистрационныйНомерФСС) Тогда
		Текст = НСтр("ru = 'У организации не заполнен регистрационный номер ФСС'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Организация", "Объект", Отказ);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Результат.СНИЛС) Тогда
		Текст = НСтр("ru = 'У сотрудника не указан СНИЛС'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , "Сотрудник", "Объект", Отказ);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Получает полные ФИО физических лиц.
//
// Параметры:
//   СтруктураФИО - Структура - По указанным ключам структуры будут размещены полные ФИО.
//       * Ключ - Строка - Имя ключа, по которому будет размещено полное ФИО.
//       * Значение - СправочникСсылка.ФизическиеЛица - Ссылка физ. лица, для которого требуется получить ФИО.
//           После выполнения процедуры превращается в тип "Строка".
//
Процедура ЗаполнитьПолныеФИО(СтруктураФИО)
	МассивФизическихЛиц = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураФИО Цикл
		МассивФизическихЛиц.Добавить(КлючИЗначение.Значение);
	КонецЦикла;
	
	ТаблицаКадровыхДанных = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, МассивФизическихЛиц, "ФИОПолные");
	
	Для Каждого КлючИЗначение Из СтруктураФИО Цикл
		КадровыеДанныеФизическогоЛица = ТаблицаКадровыхДанных.Найти(КлючИЗначение.Значение, "ФизическоеЛицо");
		Если КадровыеДанныеФизическогоЛица <> Неопределено Тогда
			ФИО = КадровыеДанныеФизическогоЛица.ФИОПолные;
		ИначеЕсли ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			ФИО = Строка(КлючИЗначение.Значение);
		Иначе
			ФИО = "";
		КонецЕсли;
		СтруктураФИО.Вставить(КлючИЗначение.Ключ, ФИО);
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьЗначениеЕслиЗаполнено(ИзменяемоеЗначение, Значение)
	Если ЗначениеЗаполнено(Значение) Тогда
		ИзменяемоеЗначение = Значение;
	КонецЕсли;
КонецПроцедуры

Функция КодыПричинИсправления(КодыПричин = Неопределено) Экспорт
	Если ТипЗнч(КодыПричин) = Тип("СписокЗначений") Тогда
		Список = КодыПричин;
	Иначе
		Список = Новый СписокЗначений;
	КонецЕсли;
	
	Список.Добавить("01", НСтр("ru = 'Работником представлены дополнительные сведения для расчета'"));
	Список.Добавить("02", НСтр("ru = 'Работником представлено свидетельство ИНН'"));
	Список.Добавить("03", НСтр("ru = 'Изменены регистрационные данные работодателя/сведения о должностных лицах работодателя'"));
	Список.Добавить("04", НСтр("ru = 'Уточнены условия труда работника/условия исчисления пособия (включая Акт ф. Н-1)'"));
	Список.Добавить("05", НСтр("ru = 'Выявлены ошибки в расчете пособия/подсчете страхового стажа'"));
	Список.Добавить("06", НСтр("ru = 'Ошибка оператора'"));
	
	Для Каждого Элемент Из Список Цикл
		Элемент.Представление = Элемент.Значение + ". " + Элемент.Представление;
	КонецЦикла;
	
	Возврат Список;
КонецФункции

#КонецОбласти

#Область ЧтениеРасшифрованногоОтвета

Функция ЗагрузитьОтветСервисаФСС(Документ, Операция, АдресРасшифрованногоОтвета) Экспорт
	НастройкиWS = ЭлектронныйДокументооборотСКонтролирующимиОрганами.НастройкиОбменаФССЭЛН(Документ.Организация);
	Если НастройкиWS = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстРасшифрованногоОтвета = ПолучитьИзВременногоХранилища(АдресРасшифрованногоОтвета);
	УдалитьИзВременногоХранилища(АдресРасшифрованногоОтвета);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстРасшифрованногоОтвета);
	ОбъектXDTO = НастройкиWS.WSПрокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Если ОбъектXDTO = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	WSResult = Неопределено;
	Если Операция = "getPrivateLNData" Тогда
		WSResult = ОбъектXDTO.Body.getPrivateLNDataResponse.FileOperationsLnUserGetPrivateLNDataOut;
	ИначеЕсли Операция = "prParseReestrFile" Тогда
		WSResult = ОбъектXDTO.Body.prParseReestrFileResponse.WSResult;
	КонецЕсли;
	Если WSResult = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	ТекстыОшибокФСС = Новый Массив;
	
	Если Строка(WSResult.STATUS) <> "1" Тогда
		Отказ = Истина;
		Если ЗначениеЗаполнено(WSResult.MESS) Тогда
			ТекстыОшибокФСС.Добавить(WSResult.MESS);
		КонецЕсли;
	КонецЕсли;
	
	Если Операция = "getPrivateLNData" Тогда
		ЗагрузитьРезультатПолученияЭЛН(Документ, WSResult, Отказ);
	ИначеЕсли Операция = "prParseReestrFile" Тогда
		ЗагрузитьРезультатОтправкиРеестраЭЛН(Документ, WSResult, Отказ, ТекстыОшибокФСС);
	КонецЕсли;
	
	Если ТекстыОшибокФСС.Количество() > 0 Тогда
		ТекстОшибки = НСтр("ru = 'При обмене с ФСС возникли ошибки. Ответ ФСС:%1'");
		СообщитьОбОшибке(Отказ, ТекстОшибки, Символы.ПС + СтрСоединить(ТекстыОшибокФСС, Символы.ПС));
	КонецЕсли;
	
	Возврат Не Отказ;
КонецФункции

Функция ЗагрузитьЭЛНИзФайла(Документ, Операция, АдресДвоичныхДанных) Экспорт
	WSResult = ПрочитатьФайлXML(АдресДвоичныхДанных, Операция);
	
	Если Операция = "getPrivateLNData" Тогда
		Отказ = Ложь;
		ЗаполнитьСотрудникаИНомерЭЛН(Документ, WSResult, Отказ);
		ЗагрузитьРезультатПолученияЭЛН(Документ, WSResult, Отказ);
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Процедура ЗагрузитьРезультатПолученияЭЛН(Документ, WSResult, Отказ)
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	ПроверитьРезультатПолученияЭЛН(Документ, WSResult, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьДанныеЭЛН(Документ, WSResult);
КонецПроцедуры

Процедура ЗагрузитьРезультатОтправкиРеестраЭЛН(Документ, WSResult, Отказ, ТекстыОшибокФСС)
	Если WSResult.Свойства().Получить("INFO") <> Неопределено
		И WSResult.INFO.Свойства().Получить("ROWSET") <> Неопределено
		И WSResult.INFO.ROWSET.Свойства().Получить("ROW") <> Неопределено Тогда
		СписокРезультатов = КоллекцияОбъектовXDTO(WSResult.INFO.ROWSET.ROW);
		Для Каждого ОписаниеРезультата Из СписокРезультатов Цикл
			Если Строка(ОписаниеРезультата.STATUS) = "1" Тогда
				СтрокаДанныхЭЛН = Документ.ДанныеЭЛН.Найти(ОписаниеРезультата.LN_CODE, "НомерЛисткаНетрудоспособности");
				Если СтрокаДанныхЭЛН <> Неопределено Тогда
					СтрокаДанныхЭЛН.Хеш = ОписаниеРезультата.LN_HASH;
				КонецЕсли;
			Иначе
				Отказ = Истина;
				ОшибкиЛН = КоллекцияОбъектовXDTO(ОписаниеРезультата.ERRORS.ERROR);
				Для Каждого ОшибкаЛН Из ОшибкиЛН Цикл
					ТекстыОшибокФСС.Добавить(ОшибкаЛН.ERR_MESS);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Документ.СтатусДокумента = Перечисления.СтатусыЗаявленийИРеестровНаВыплатуПособий.ПринятФСС;
КонецПроцедуры

Процедура ПроверитьРезультатПолученияЭЛН(Документ, WSResult, Отказ)
	
	ДанныеЛН = КоллекцияОбъектовXDTO(WSResult.DATA.OUT_ROWSET.ROW)[0];
	
	// Проверка состояния.
	Состояние = СостояниеЭЛН(ДанныеЛН.LN_State);
	Если Состояние = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Ошибка в структуре сообщения ФСС: В поле ""%1"" недокументированное значение: ""%2"".'");
		СообщитьОбОшибке(Отказ, ТекстОшибки, "LN_State", ДанныеЛН.LN_State);
		Возврат;
	КонецЕсли;
	Если Состояние.Имя <> "Закрыт" И Состояние.Имя <> "НаправленНаМСЭ" И Состояние.Имя <> "ДополненДаннымиМСЭ" Тогда
		СообщитьОбОшибке(Отказ, НСтр("ru = 'Листок нетрудоспособности не может быть загружен, его состояние: ""%1"".'"), Состояние.Представление);
		Возврат;
	КонецЕсли;
	
	// Проверка кадровых данных сотрудника.
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Документ.Сотрудник, "Фамилия, Имя, Отчество, ДатаРождения", ДанныеЛН["LN_DATE"]);
	Найденные = КадровыеДанныеСотрудников.НайтиСтроки(Новый Структура("Сотрудник", Документ.Сотрудник));
	Если Найденные.Количество() > 0 Тогда
		КадровыеДанныеСотрудника = Найденные[0];
		
		Значения = Новый Структура("SURNAME, NAME, PATRONIMIC, BIRTHDAY");
		ЗаполнитьЗначенияСвойств(Значения, ДанныеЛН);
		
		Если ВРег(СокрЛП(Значения.SURNAME))       <> ВРег(СокрЛП(КадровыеДанныеСотрудника.Фамилия))
			Или ВРег(СокрЛП(Значения.NAME))       <> ВРег(СокрЛП(КадровыеДанныеСотрудника.Имя))
			Или ВРег(СокрЛП(Значения.PATRONIMIC)) <> ВРег(СокрЛП(КадровыеДанныеСотрудника.Отчество)) Тогда
			ТекстОшибки = НСтр("ru = 'ФИО указанные в листке нетрудоспособности (%1 %2 %3) не совпадают с ФИО сотрудника.'");
			СообщитьОбОшибке(Неопределено, ТекстОшибки, Значения.SURNAME, Значения.NAME, Значения.PATRONIMIC);
		КонецЕсли;
		
		ДанныеЛНДатаРождения = XMLЗначениеСПроверкойТипа(Значения.BIRTHDAY, Тип("Дата"));
		Если ДанныеЛНДатаРождения <> КадровыеДанныеСотрудника.ДатаРождения Тогда
			ТекстОшибки = НСтр("ru = 'Дата рождения указанная в листке нетрудоспособности (%1) не совпадает с датой рождения сотрудника.'");
			СообщитьОбОшибке(Неопределено, ТекстОшибки, Формат(ДанныеЛНДатаРождения, "ДЛФ=D"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеЭЛН(Документ, WSResult)
	
	ДанныеЛН = КоллекцияОбъектовXDTO(WSResult.DATA.OUT_ROWSET.ROW)[0];
	
	ИменаПолейИзСервиса = 
	"APPROVE1,
	|APPROVE2,
	|BASE_AVG_DAILY_SAL,
	|BASE_AVG_SAL,
	|BIRTHDAY,
	|BOZ_FLAG,
	|CALC_CONDITION1,
	|CALC_CONDITION2,
	|CALC_CONDITION3,
	|CALC_CONDITION4,
	|DATE1,
	|DATE2,
	|DT1_LN,
	|DT2_LN,
	|DUPLICATE_FLAG,
	|EMPL_FLAG,
	|EMPL_PARENT_NO,
	|EMPL_PAYMENT,
	|EMPL_REG_NO,
	|EMPL_REG_NO2,
	|EMPLOYER,
	|FORM1_DT,
	|FSS_PAYMENT,
	|GENDER,
	|HOSPITAL_BREACH,
	|HOSPITAL_DT1,
	|HOSPITAL_DT2,
	|INN_PERSON,
	|INSUR_MM,
	|INSUR_YY,
	|LN_CODE,
	|LN_DATE,
	|LN_HASH,
	|LN_RESULT,
	|LN_STATE,
	|LPU_ADDRESS,
	|LPU_EMPL_FLAG,
	|LPU_EMPLOYER,
	|LPU_NAME,
	|LPU_OGRN,
	|MSE_DT1,
	|MSE_DT2,
	|MSE_DT3,
	|MSE_INVALID_GROUP,
	|NAME,
	|NOT_INSUR_MM,
	|NOT_INSUR_YY,
	|PARENT_CODE,
	|PATRONIMIC,
	|PAYMENT,
	|PREGN12W_FLAG,
	|PREV_LN_CODE,
	|PRIMARY_FLAG,
	|REASON1,
	|REASON2,
	|REASON3,
	|RETURN_DATE_EMPL,
	|SERV1_AGE,
	|SERV1_FIO,
	|SERV1_MM,
	|SERV1_RELATION_CODE,
	|SERV2_AGE,
	|SERV2_FIO,
	|SERV2_MM,
	|SERV2_RELATION_CODE,
	|SNILS,
	|SURNAME,
	|VOUCHER_NO,
	|VOUCHER_OGRN";
	ДанныеИзСервиса = Новый Структура(ИменаПолейИзСервиса);
	ЗаполнитьЗначенияСвойств(ДанныеИзСервиса, ДанныеЛН);
	
	СоответствиеПолей = Документы.БольничныйЛист.СоответствиеПолейЭЛН();
	Для Каждого СвойствоДокумента Из СоответствиеПолей Цикл
		Документ[СвойствоДокумента.Ключ] = XMLЗначениеСПроверкойТипа(ДанныеИзСервиса[СвойствоДокумента.Значение], ТипЗнч(Документ[СвойствоДокумента.Ключ]));
	КонецЦикла;
	
	Документ.ЯвляетсяПродолжениемБолезни = Не XMLЗначениеСПроверкойТипа(ДанныеИзСервиса.PRIMARY_FLAG, Тип("Булево"));
	
	Если ДанныеИзСервиса.LN_RESULT <> Неопределено Тогда
		Значения = Новый Структура("MSE_RESULT, OTHER_STATE_DT, RETURN_DATE_LPU, NEXT_LN_CODE");
		ЗаполнитьЗначенияСвойств(Значения, ДанныеИзСервиса.LN_RESULT);
		ЗаполнитьЗначениеИзСтрокиXML(Документ.НовыйСтатусНетрудоспособного,     Значения.MSE_RESULT,      Тип("Строка"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.ДатаНовыйСтатусНетрудоспособного, Значения.OTHER_STATE_DT,  Тип("Дата"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.ПриступитьКРаботеС,               Значения.RETURN_DATE_LPU, Тип("Дата"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.НомерЛисткаПродолжения,           Значения.NEXT_LN_CODE,    Тип("Строка"));
	КонецЕсли;
	
	Если ДанныеИзСервиса.HOSPITAL_BREACH <> Неопределено Тогда
		Значения = Новый Структура("HOSPITAL_BREACH_CODE, HOSPITAL_BREACH_DT");
		ЗаполнитьЗначенияСвойств(Значения, ДанныеИзСервиса.HOSPITAL_BREACH);
		ЗаполнитьЗначениеИзСтрокиXML(Документ.КодНарушенияРежима,  Значения.HOSPITAL_BREACH_CODE, Тип("Строка"));
		ЗаполнитьЗначениеИзСтрокиXML(Документ.ДатаНарушенияРежима, Значения.HOSPITAL_BREACH_DT,   Тип("Дата"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Документ.НомерПервичногоЛисткаНетрудоспособности)
		И Документ.ЯвляетсяПродолжениемБолезни Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НомерЛисткаНетрудоспособности", Документ.НомерПервичногоЛисткаНетрудоспособности);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	БольничныйЛист.Ссылка
		|ИЗ
		|	Документ.БольничныйЛист КАК БольничныйЛист
		|ГДЕ
		|	БольничныйЛист.НомерЛисткаНетрудоспособности = &НомерЛисткаНетрудоспособности";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Документ.ПервичныйБольничныйЛист = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Номер = 0;
	ТаблицаПолныхПериодов = КоллекцияОбъектовXDTO(ДанныеЛН.TREAT_PERIODS.TREAT_FULL_PERIOD);
	Для Каждого СтрокаТаблицыПолныхПериодов Из ТаблицаПолныхПериодов Цикл
		
		ЗначенияПолныхПериодов = Новый Структура("TREAT_CHAIRMAN, TREAT_CHAIRMAN_ROLE");
		ЗаполнитьЗначенияСвойств(ЗначенияПолныхПериодов, СтрокаТаблицыПолныхПериодов);
		
		ТаблицаПериодов = КоллекцияОбъектовXDTO(СтрокаТаблицыПолныхПериодов.TREAT_PERIOD);
		Для Каждого СтрокаТаблицыПериодов Из ТаблицаПериодов Цикл
			Номер = Номер + 1;
			
			ЗначенияПериодов = Новый Структура("TREAT_DT1, TREAT_DT2, TREAT_DOCTOR_ROLE, TREAT_DOCTOR");
			ЗаполнитьЗначенияСвойств(ЗначенияПериодов, СтрокаТаблицыПериодов);
			
			Документ["ОсвобождениеДатаНачала" + Номер]     = XMLЗначениеСПроверкойТипа(ЗначенияПериодов.TREAT_DT1, Тип("Дата"));
			Документ["ОсвобождениеДатаОкончания" + Номер]  = XMLЗначениеСПроверкойТипа(ЗначенияПериодов.TREAT_DT2, Тип("Дата"));
			Документ["ОсвобождениеФИОВрача" + Номер]       = ЗначенияПериодов.TREAT_DOCTOR;
			Документ["ОсвобождениеДолжностьВрача" + Номер] = ЗначенияПериодов.TREAT_DOCTOR_ROLE;
			
			Документ["ОсвобождениеФИОВрачаПредседателяВК" + Номер]       = ЗначенияПолныхПериодов.TREAT_CHAIRMAN;
			Документ["ОсвобождениеДолжностьВрачаПредседателяВК" + Номер] = ЗначенияПолныхПериодов.TREAT_CHAIRMAN_ROLE;
			
			Если Номер = 3 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Номер = 3 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Документы.БольничныйЛист.ПослеЗагрузкиЭЛН(Документ, ДанныеИзСервиса);
	
КонецПроцедуры

// Расшифровывает код состояния ЛН.
Функция СостояниеЭЛН(LN_State)
	Состояние = Новый Структура("Код, Имя, Представление");
	Состояние.Код = LN_State;
	
	Если LN_State = "010" Тогда
		Состояние.Имя = "Открыт";
		Состояние.Представление = НСтр("ru = 'Открыт'");
		
	ИначеЕсли LN_State = "020" Тогда
		Состояние.Имя = "Продлен";
		Состояние.Представление = НСтр("ru = 'Продлен'");
		
	ИначеЕсли LN_State = "030" Тогда
		Состояние.Имя = "Закрыт";
		Состояние.Представление = НСтр("ru = 'Закрыт'");
		
	ИначеЕсли LN_State = "040" Тогда
		Состояние.Имя = "НаправленНаМСЭ";
		Состояние.Представление = НСтр("ru = 'Направлен на медико-социальную экспертизу'");
		
	ИначеЕсли LN_State = "050" Тогда
		Состояние.Имя = "ДополненДаннымиМСЭ";
		Состояние.Представление = НСтр("ru = 'Дополнен данными медико-социальной экспертизы'");
		
	ИначеЕсли LN_State = "060" Тогда
		Состояние.Имя = "ЗаполненСтрахователем";
		Состояние.Представление = НСтр("ru = 'Заполнен страхователем'");
		
	ИначеЕсли LN_State = "070" Тогда
		Состояние.Имя = "ПособиеНачисленоСтраховщиком";
		Состояние.Представление = НСтр("ru = 'Пособие начислено страховщиком (прямые выплаты страхового обеспечения)'");
		
	ИначеЕсли LN_State = "080" Тогда
		Состояние.Имя = "ПособиеВыплачено";
		Состояние.Представление = НСтр("ru = 'Пособие выплачено'");
		
	ИначеЕсли LN_State = "090" Тогда
		Состояние.Имя = "ДействияПрекращены";
		Состояние.Представление = НСтр("ru = 'Отменен'");
		
	Иначе
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат Состояние;
КонецФункции

Функция ПрочитатьФайлXML(АдресДвоичныхДанных, Операция)
	ПолноеИмяФайлаXML = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресДвоичныхДанных);
	ДвоичныеДанные.Записать(ПолноеИмяФайлаXML);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ПолноеИмяФайлаXML);
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЧтениеXML.Закрыть();
	УдалитьФайлы(ПолноеИмяФайлаXML);
	
	Если Операция = "getPrivateLNData" Тогда
		WSResult = ОбъектXDTO.Body.getPrivateLNDataResponse.FileOperationsLnUserGetPrivateLNDataOut;
	ИначеЕсли Операция = "prParseReestrFile" Тогда
		WSResult = ОбъектXDTO.Body.prParseReestrFileResponse.WSResult;
	Иначе
		WSResult = ОбъектXDTO;
	КонецЕсли;
	
	Возврат WSResult;
КонецФункции

Процедура ЗаполнитьСотрудникаИНомерЭЛН(Документ, WSResult, Отказ)
	ROW = КоллекцияОбъектовXDTO(WSResult.DATA.OUT_ROWSET.ROW)[0];
	
	Сведения = Новый Структура("LN_CODE, LN_DATE, SNILS, SURNAME, NAME, PATRONIMIC, BIRTHDAY");
	ЗаполнитьЗначенияСвойств(Сведения, ROW);
	
	Документ.НомерЛисткаНетрудоспособности = Сведения.LN_CODE;
	
	// Поиск физ. лица.
	Если ТипЗнч(Сведения.SNILS) = Тип("Строка") И ЗначениеЗаполнено(Сведения.SNILS) Тогда
		СНИЛС = СтрШаблон("%1-%2-%3 %4", Сред(Сведения.SNILS, 1, 3), Сред(Сведения.SNILS, 4, 3), Сред(Сведения.SNILS, 7, 3), Сред(Сведения.SNILS, 10, 2));
	Иначе
		СНИЛС = "";
	КонецЕсли;
	ФизЛицо = ФизЛицо(СНИЛС, Строка(Сведения.SURNAME), Строка(Сведения.NAME), Строка(Сведения.PATRONIMIC));
	Если Не ЗначениеЗаполнено(ФизЛицо) Тогда
		Отказ = Истина; // Важно определить физ. лицо, которому выдан ЭЛН.
		Возврат;
	КонецЕсли;
	
	Если ФизЛицо <> Документ.ФизическоеЛицо Тогда
		// Выбран сотрудник другого физ. лица, надо заполнить сотрудника (и организацию).
		Если ЗначениеЗаполнено(Сведения.LN_DATE) Тогда
			ДатаЭЛН = XMLЗначениеСПроверкойТипа(Сведения.LN_DATE, Тип("Дата"));
		Иначе
			ДатаЭЛН = Документ.Дата;
		КонецЕсли;
		РезультатПоиска = СотрудникОрганизации(Документ.Организация, ДатаЭЛН, ФизЛицо);
		Если РезультатПоиска.Успех Тогда
			ЗаполнитьЗначенияСвойств(Документ, РезультатПоиска, "Сотрудник, Организация");
			Документ.ФизическоеЛицо = ФизЛицо;
		Иначе
			СообщитьОбОшибке(Отказ, РезультатПоиска.ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ФизЛицо(СНИЛС, Фамилия, Имя, Отчество)
	Если Не ЗначениеЗаполнено(СНИЛС) Тогда
		ТекстОшибки = НСтр("ru = 'В файле не заполнен СНИЛС сотрудника.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.СтраховойНомерПФР = &СтраховойНомерПФР";
	Запрос.УстановитьПараметр("СтраховойНомерПФР", СНИЛС);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Фамилия)
		И ЗначениеЗаполнено(Имя)
		И ЗначениеЗаполнено(Отчество) Тогда
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ФизическиеЛица.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|ГДЕ
		|	ФизическиеЛица.Фамилия = &Фамилия
		|	И ФизическиеЛица.Имя = &Имя
		|	И ФизическиеЛица.Отчество = &Отчество
		|	И ФизическиеЛица.СтраховойНомерПФР = """"";
		Запрос.УстановитьПараметр("Фамилия", Фамилия);
		Запрос.УстановитьПараметр("Имя", Имя);
		Запрос.УстановитьПараметр("Отчество", Отчество);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У сотрудника ""%1"" не заполнен СНИЛС (в файле СНИЛС ""%2"").'"),
				Строка(Выборка.Ссылка),
				СНИЛС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не найден сотрудник с СНИЛС ""%1"" (%2 %3 %4). Проверьте что у сотрудника корректно заполнен СНИЛС.'"),
		СНИЛС,
		Фамилия,
		Имя,
		Отчество);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	Возврат Неопределено;
КонецФункции

Функция СотрудникОрганизации(ПредполагаемаяОрганизация, Дата, ФизЛицо)
	Результат = Новый Структура("Успех, ТекстОшибки, Сотрудник, Организация", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудников.СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизЛицо);
	ПараметрыПолученияСотрудников.ОкончаниеПериода = Дата;
	ПараметрыПолученияСотрудников.КадровыеДанные = "Организация, ДатаУвольнения";
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПолученияСотрудников);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВТСотрудникиОрганизации.ДатаУвольнения = &ПустаяДата
	|				ТОГДА &МаксимальнаяДата
	|			ИНАЧЕ ВТСотрудникиОрганизации.ДатаУвольнения
	|		КОНЕЦ) КАК ДатаУвольнения,
	|	ВТСотрудникиОрганизации.Организация КАК Организация
	|ПОМЕСТИТЬ ВТСотрудникиСДатами
	|ИЗ
	|	ВТСотрудникиОрганизации КАК ВТСотрудникиОрганизации
	|ГДЕ
	|	(ВТСотрудникиОрганизации.ДатаУвольнения = &ПустаяДата
	|			ИЛИ ВТСотрудникиОрганизации.ДатаУвольнения >= ДОБАВИТЬКДАТЕ(&ТекущаяДата, ГОД, -1))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСотрудникиОрганизации.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТСотрудникиСДатами.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА ВТСотрудникиСДатами.ДатаУвольнения >= &ТекущаяДата
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Работает,
	|	ВТСотрудникиСДатами.ДатаУвольнения КАК ДатаУвольнения,
	|	ВТСотрудникиОрганизации.Сотрудник КАК Сотрудник
	|ИЗ
	|	ВТСотрудникиСДатами КАК ВТСотрудникиСДатами
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК ВТСотрудникиОрганизации
	|		ПО ВТСотрудникиСДатами.Организация = ВТСотрудникиОрганизации.Организация
	|			И (ВЫБОР
	|				КОГДА ВТСотрудникиОрганизации.ДатаУвольнения = &ПустаяДата
	|					ТОГДА &МаксимальнаяДата
	|				ИНАЧЕ ВТСотрудникиОрганизации.ДатаУвольнения
	|			КОНЕЦ = ВТСотрудникиСДатами.ДатаУвольнения)";
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	Запрос.УстановитьПараметр("ТекущаяДата", Дата);
	Запрос.УстановитьПараметр("МаксимальнаяДата", '39991231235959');
	
	ВсеОрганизации = Запрос.Выполнить().Выгрузить();
	ОбщееКоличество = ВсеОрганизации.Количество();
	Если ОбщееКоличество = 0 Тогда
		Результат.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Сотрудник ""%1"" на ""%2"" не принят на работу.'"),
			ФизЛицо,
			Формат(Дата, "ДЛФ=D"));
	ИначеЕсли ОбщееКоличество = 1 Тогда
		Результат.Успех       = Истина;
		Результат.Организация = ВсеОрганизации[0].Организация;
		Результат.Сотрудник   = ВсеОрганизации[0].Сотрудник;
	Иначе
		ТекущиеРаботодатели = ВсеОрганизации.НайтиСтроки(Новый Структура("Работает", Истина));
		КоличествоАктивных = ТекущиеРаботодатели.Количество();
		Если КоличествоАктивных = 1 Тогда
			// Сотрудник работает в одной организации.
			Результат.Успех       = Истина;
			Результат.Организация = ТекущиеРаботодатели[0].Организация;
			Результат.Сотрудник   = ТекущиеРаботодатели[0].Сотрудник;
		Иначе
			// Сотрудник либо работал в нескольких организациях, либо работает в нескольких организациях.
			НайденнаяСтрока = ВсеОрганизации.Найти(ПредполагаемаяОрганизация, "Организация");
			Если НайденнаяСтрока <> Неопределено Тогда
				// Пользователь явно указал организацию.
				Результат.Успех       = Истина;
				Результат.Организация = НайденнаяСтрока.Организация;
				Результат.Сотрудник   = НайденнаяСтрока.Сотрудник;
			Иначе
				ПредставлениеОрганизаций = СтрСоединить(ВсеОрганизации.ВыгрузитьКолонку("Организация"), ", ");
				Результат.ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Требуется выбрать организацию, т.к. сотрудник ""%1"" на ""%2"" работает в нескольких организациях (%3).'"),
					ФизЛицо,
					Формат(Дата, "ДЛФ=D"),
					ПредставлениеОрганизаций);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

Функция XMLЗначениеСПроверкойТипа(Значение, Тип)
	Если Тип <> Тип("Строка") И ТипЗнч(Значение) = Тип("Строка") И Не ПустаяСтрока(Значение) Тогда
		Возврат XMLЗначение(Тип, Значение);
	Иначе
		Возврат Значение;
	КонецЕсли;
КонецФункции

Процедура ЗаполнитьЗначениеИзСтрокиXML(Приемник, ЗначениеВФорматеXML, ТипЗначения)
	Если ЗначениеВФорматеXML <> Неопределено И ЗначениеЗаполнено(ЗначениеВФорматеXML) Тогда
		Приемник = XMLЗначениеСПроверкойТипа(ЗначениеВФорматеXML, ТипЗначения);
	КонецЕсли;
КонецПроцедуры

Функция КоллекцияОбъектовXDTO(Значение)
	Если ТипЗнч(Значение) = Тип("ОбъектXDTO") Тогда
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	Иначе
		Возврат Значение;
	КонецЕсли;
КонецФункции

Процедура СообщитьОбОшибке(Отказ, ТекстОшибки, Параметр1 = Неопределено, Параметр2 = Неопределено, Параметр3 = Неопределено)
	Отказ = Истина;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстОшибки,
			Параметр1,
			Параметр2,
			Параметр3));
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
