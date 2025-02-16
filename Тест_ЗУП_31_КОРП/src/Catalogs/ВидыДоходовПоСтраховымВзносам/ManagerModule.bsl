#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	УчетСтраховыхВзносовВызовСервера.ВидыДоходовПоСтраховымВзносамОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьВидыДоходовПоСтраховымВзносам();
	
КонецПроцедуры

Процедура ЗаполнитьВидыДоходовПоСтраховымВзносам()

	ОписатьВидДоходаПоСтраховымВзносам("НеЯвляетсяОбъектом",												"Доходы, не являющиеся объектом обложения страховыми взносами",																Ложь, 	Ложь,	Ложь,	Ложь,	8); 
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликом",												"Доходы, целиком не облагаемые страховыми взносами, кроме пособий за счет ФСС и денежного довольствия военнослужащих",					Ложь, 	Ложь, 	Ложь, 	Ложь,	2); 
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС",													"Государственные пособия обязательного социального страхования, выплачиваемые за счет ФСС",									Ложь, 	Ложь, 	Ложь, 	Ложь,	4);
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС_НС",												"Государственные пособия по обязательному страхованию от несчастных случаев и профзаболеваний",								Ложь, 	Ложь, 	Ложь, 	Ложь,	5);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеДовольствиеВоеннослужащих",									"Денежное довольствие военнослужащих и приравненных к ним лиц рядового и начальствующего состава МВД и других ведомств",					Ложь, 	Ложь, 	Ложь, 	Ложь,	19);
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликомПрокуроров",										"Доходы прокуроров, следователей и судей, целиком не облагаемые страховыми взносами",										Ложь,	Ложь, 	Ложь, 	Ложь,	21); 
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликом",													"Доходы, целиком облагаемые страховыми взносами",																			Истина, Истина, Истина, Истина,	1);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроров",										"Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами в ПФР",								Ложь, 	Истина, Истина, Истина,	20); 
	
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносами",										"Возмещаемые ФСС компенсации, облагаемые страховыми взносами",																Истина, Истина, Истина, Истина,	9);
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносамиПрокуроров",							"Возмещаемые ФСС компенсации, облагаемые страховыми взносами, выплачиваемые прокурорам, следователям и судьям",						Ложь, 	Истина, Истина, Истина, 24); 
	ОписатьВидДоходаПоСтраховымВзносам("Матпомощь",															"Материальная помощь, облагаемая страховыми взносами частично",																Истина, Истина, Истина, Истина,	6,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПрокуроров",												"Материальная помощь прокуроров, следователей и судей, облагаемая страховыми взносами частично",								Ложь, 	Истина, Истина, Истина,	22,	Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенка",										"Материальная помощь при рождении ребенка, облагаемая страховыми взносами частично",										Истина, Истина, Истина, Истина,	7,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенкаПрокуроров",								"Материальная помощь при рождении ребенка прокурорам, следователям и судьям, облагаемая страховыми взносами частично",					Ложь, 	Истина, Истина, Истина,	23,	Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору",				"Доходы студентов за работу в студотряде по трудовому договору",															Ложь,	Истина, Истина, Истина,	25); 

	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору",	"Доходы студентов за работу в студотряде по гражданско-правовому договору",													Ложь, 	Истина, Ложь, 	Ложь,	26);
	
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХ",														"Договоры гражданско-правового характера",																					Истина,	Истина, Ложь, 	Ложь,	3); 
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведения",								"Создание аудиовизуальных произведений (видео-, теле- и кинофильмов)",														Истина,	Истина, Ложь, 	Ложь,	12,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведения",									"Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна",						Истина, Истина, Ложь, 	Ложь,	14,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведения",							"Создание других музыкальных произведений, в том числе подготовленных к опубликованию",										Истина, Истина, Ложь, 	Ложь,	13,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведений",									"Исполнение произведений литературы и искусства",																			Истина,	Истина, Ложь, 	Ложь,	10,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведения",									"Создание литературных произведений, в том числе для театра, кино, эстрады и цирка",										Истина, Истина, Ложь, 	Ложь,	15,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведение",						"Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых, камерных, оригинальной музыки для кино и др.",			Истина,	Истина, Ложь, 	Ложь,	16,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТруды",												"Создание научных трудов и разработок",																						Истина,	Истина, Ложь, 	Ложь,	17,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытия",													"Открытия, изобретения и создание промышленных образцов (процент суммы дохода, полученного за первые два года использования)", 				Истина,	Истина, Ложь, 	Ложь,	11,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптуры",												"Создание произведений скульптуры, монументально- декоративной живописи, декоративно-прикладного и оформительского искусства, станковой живописи и др.",	Истина,	Истина, Ложь, 	Ложь,	18,	Истина,	Истина);
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликомНеОблагаемыеФСС_НС",								"Доходы, целиком облагаемые страховыми взносами на ОПС, ОМС и соц.страхование, не облагаемые взносами на страхование от несчастных случаев",		Истина, Истина, Истина, Ложь,	27);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС",					"Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами в ПФР и взносами на страхование от несчастных случаев",		Ложь, 	Истина, Истина, Ложь,	28); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХОблагаемыеФСС_НС",										"Договоры гражданско-правового характера, облагаемые взносами на страхование от несчастных случаев",							Истина,	Истина, Ложь, 	Истина,	29); 
	
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведенияОблагаемыеФСС_НС",				"Создание аудиовизуальных произведений (видео-, теле- и кинофильмов), облагаемые взносами на страхование от несчастных случаев",				Истина,	Истина, Ложь, 	Истина,	32,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведенияОблагаемыеФСС_НС",					"Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна, обл.взносами на страхование от несч.случаев",	Истина, Истина, Ложь, 	Истина,	34,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведенияОблагаемыеФСС_НС",			"Создание других музыкальных произведений, в том числе подготовленных к опубликованию, облагаемые взносами на страхование от несчастных случаев",		Истина, Истина, Ложь, 	Истина,	33,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведенийОблагаемыеФСС_НС",					"Исполнение произведений литературы и искусства, облагаемые взносами на страхование от несчастных случаев",							Истина,	Истина, Ложь, 	Истина,	30,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведенияОблагаемыеФСС_НС",					"Создание литературных произведений, в том числе для театра, кино, эстрады и цирка, облагаемые взносами на страхование от несчастных случаев",		Истина, Истина, Ложь, 	Истина,	35,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведениеОблагаемыеФСС_НС",		"Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых и др., обл.взносами на страхование от несч.случаев",		Истина,	Истина, Ложь, 	Истина,	36,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТрудыОблагаемыеФСС_НС",								"Создание научных трудов и разработок, облагаемые взносами на страхование от несчастных случаев",								Истина,	Истина, Ложь, 	Истина,	37,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытияОблагаемыеФСС_НС",									"Открытия, изобретения и создание промышленных образцов, облагаемые взносами на страхование от несчастных случаев",		 				Истина,	Истина, Ложь, 	Истина,	31,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптурыОблагаемыеФСС_НС",								"Создание произведений скульптуры, монументально-декоративной живописи и др., облагаемые взносами на страхование от несчастных случаев",			Истина,	Истина, Ложь, 	Истина,	38,	Истина,	Истина);
	
КонецПроцедуры

Процедура ОписатьВидДоходаПоСтраховымВзносам(ИмяПредопределенныхДанных, Наименование, ВходитВБазуПФР, ВходитВБазуФОМС, ВходитВБазуФСС, ВходитВБазуФСС_НС, ДопУпорядочивание = 0, ОблагаетсяВзносамиЧастично = Ложь, АвторскиеВознаграждения = Ложь)

	СсылкаПредопределенного = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Объект = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Объект = Справочники.ВидыДоходовПоСтраховымВзносам.СоздатьЭлемент();
		Объект.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;

	Объект.Наименование = Наименование;
	
	Если Объект.ВходитВБазуПФР <> ВходитВБазуПФР Тогда
		Объект.ВходитВБазуПФР = ВходитВБазуПФР
	КонецЕсли;
	Если Объект.ВходитВБазуФОМС <> ВходитВБазуФОМС Тогда
		Объект.ВходитВБазуФОМС = ВходитВБазуФОМС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС <> ВходитВБазуФСС Тогда
		Объект.ВходитВБазуФСС = ВходитВБазуФСС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС_НС <> ВходитВБазуФСС_НС Тогда
		Объект.ВходитВБазуФСС_НС = ВходитВБазуФСС_НС
	КонецЕсли;
	Если Объект.ОблагаетсяВзносамиЧастично <> ОблагаетсяВзносамиЧастично Тогда
		Объект.ОблагаетсяВзносамиЧастично = ОблагаетсяВзносамиЧастично
	КонецЕсли;
	Если Объект.АвторскиеВознаграждения <> АвторскиеВознаграждения Тогда
		Объект.АвторскиеВознаграждения = АвторскиеВознаграждения
	КонецЕсли;
	Если ЗначениеЗаполнено(ДопУпорядочивание) И Не ЗначениеЗаполнено(Объект.РеквизитДопУпорядочивания) Тогда
		Объект.РеквизитДопУпорядочивания = ДопУпорядочивание
	КонецЕсли;

	Если Объект.Модифицированность() Тогда
		
		Объект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
		
	КонецЕсли;

КонецПроцедуры

Функция НеДоступныеЭлементыПоЗначениямФункциональныхОпций() Экспорт
	
	НеДоступныеЗначения = Новый Массив;
	
	ИмяОпции = "ИспользоватьРасчетДенежногоСодержанияПрокуроров";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.КомпенсацииОблагаемыеВзносамиПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликомПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПриРожденииРебенкаПрокуроров);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользуетсяТрудСтудентов";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользоватьВоеннуюСлужбу";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеДовольствиеВоеннослужащих);
		
	КонецЕсли; 
	
	Возврат НеДоступныеЗначения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
