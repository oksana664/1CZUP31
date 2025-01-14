#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСоответствиеВидовУведомленийИменамОтчетов() Экспорт 
	СоответствиеИмен = Новый Соответствие;
	
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН] = "РегламентированноеУведомлениеПрекращениеУСН";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН] = "РегламентированноеУведомлениеПереходНаУСН";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН] = "РегламентированноеУведомлениеУтратаПраваУСН";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6] = "РегламентированноеУведомлениеУчастиеВРоссийскихОрганизациях";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки] = "РегламентированноеУведомлениеИсключениеПроверки";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС] = "РегламентированноеУведомлениеПостановкаОбъектаНВОС";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК] = "РегламентированноеУведомлениеКИК";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН] = "РегламентированноеУведомлениеОтказОтУСН";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН] = "РегламентированноеУведомлениеИзменениеПараметраУСН";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2] = "РегламентированноеУведомлениеСообщениеОбУчастии";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4] = "РегламентированноеУведомлениеРеорганизацияЛиквидация";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1] = "РегламентированноеУведомлениеЕНВД1";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2] = "РегламентированноеУведомлениеЕНВД2";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3] = "РегламентированноеУведомлениеЕНВД3";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4] = "РегламентированноеУведомлениеЕНВД4";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО] = "РегламентированноеУведомлениеУ_ИО";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2] = "РегламентированноеУведомлениеТС2";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1] = "РегламентированноеУведомлениеТС1";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме] = "РегламентированноеУведомлениеПрекращениеПатент";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент] = "РегламентированноеУведомлениеУтратаПраваПатент";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатента] = "РегламентированноеУведомлениеПолучениеПатента";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма] = "РегламентированноеУведомлениеПолучениеПатента";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет] = "РегламентированноеУведомлениеВыборНалоговогоОргана";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1] = "РегламентированноеУведомлениеСозданиеОбособленныхПодразделений";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2] = "РегламентированноеУведомлениеЗакрытиеОбособленныхПодразделений";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР11001] = "РегламентированноеУведомлениеФормаР11001";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР13001] = "РегламентированноеУведомлениеФормаР13001";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР14001] = "РегламентированноеУведомлениеФормаР14001";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР21001] = "РегламентированноеУведомлениеФормаР21001";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР24001] = "РегламентированноеУведомлениеФормаР24001";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам] = "РегламентированноеУведомлениеВыплатыПодразделенийФизЛицам";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО] = "РегламентированноеУведомлениеС_ИО";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов] = "РегламентированноеУведомлениеНевозможностьПредоставления";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога] = "РегламентированноеУведомлениеВозвратНалога";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога] = "РегламентированноеУведомлениеЗачетНалога";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости] = "РегламентированноеУведомлениеДекларацияХарактеристикаОбъекта";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС] = "РегламентированноеУведомлениеПредоставлениеРассрочки";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов] = "РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента] = "РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны] = "РегламентированноеУведомлениеСогласиеНаРаскрытиеНалоговойТайны";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУчастникаСколково] = "РегламентированноеУведомлениеУчастникаСколковоОсвобождениеНалогообложения";
	СоответствиеИмен[Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента] = "РегламентированноеУведомлениеПолучениеДокументаНалоговогоРезидента";
	
	Возврат СоответствиеИмен;
КонецФункции

Функция ВидыУведомленийВФНС() Экспорт
	ВидыУведомленийВФНС = Новый Соответствие;
	
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатента, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУчастникаСколково, Истина);
	ВидыУведомленийВФНС.Вставить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента, Истина);
	
	Возврат ВидыУведомленийВФНС;
КонецФункции

Функция ВидыУведомленийДляИП() Экспорт 
	Результат = Новый Массив;
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатента);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР21001);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР24001);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента);
	
	Возврат Результат;
КонецФункции

Функция ВидыУведомленийДляОрганизации() Экспорт 
	Результат = Новый Массив;
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР11001);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР13001);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР14001);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны);
	
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУчастникаСколково);
	Результат.Добавить(Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента);
	
	Возврат Результат;
КонецФункции

Функция ПолучитьСоответствиеОтчетаПоКНД() Экспорт 
	СоответствиеКНД = Новый Соответствие;
	СоответствиеКНД.Вставить("1150058", "РегламентированноеУведомлениеВозвратНалога");
	СоответствиеКНД.Вставить("1111054", "РегламентированноеУведомлениеВыборНалоговогоОргана");
	СоответствиеКНД.Вставить("1112536", "РегламентированноеУведомлениеВыплатыПодразделенийФизЛицам");
	СоответствиеКНД.Вставить("1111022", "РегламентированноеУведомлениеЕНВД1");
	СоответствиеКНД.Вставить("1112012", "РегламентированноеУведомлениеЕНВД2");
	СоответствиеКНД.Вставить("1111050", "РегламентированноеУведомлениеЕНВД3");
	СоответствиеКНД.Вставить("1112017", "РегламентированноеУведомлениеЕНВД4");
	СоответствиеКНД.Вставить("1111052", "РегламентированноеУведомлениеЗакрытиеОбособленныхПодразделений");
	СоответствиеКНД.Вставить("1150057", "РегламентированноеУведомлениеЗачетНалога");
	СоответствиеКНД.Вставить("1150016", "РегламентированноеУведомлениеИзменениеПараметраУСН");
	СоответствиеКНД.Вставить("1120416", "РегламентированноеУведомлениеКИК");
	СоответствиеКНД.Вставить("1110056", "РегламентированноеУведомлениеНалоговаяЛьготаРегИнвестПроекты");
	СоответствиеКНД.Вставить("1125045", "РегламентированноеУведомлениеНевозможностьПредоставления");
	СоответствиеКНД.Вставить("1150002", "РегламентированноеУведомлениеОтказОтУСН");
	СоответствиеКНД.Вставить("1150001", "РегламентированноеУведомлениеПереходНаУСН");
	СоответствиеКНД.Вставить("1150010", "РегламентированноеУведомлениеПолучениеПатента");
	СоответствиеКНД.Вставить("1111620", "РегламентированноеУведомлениеПостановкаСнятиеВКачествеАгента");
	СоответствиеКНД.Вставить("1150026", "РегламентированноеУведомлениеПрекращениеПатент");
	СоответствиеКНД.Вставить("1150024", "РегламентированноеУведомлениеПрекращениеУСН");
	СоответствиеКНД.Вставить("1111047", "РегламентированноеУведомлениеРеорганизацияЛиквидация");
	СоответствиеКНД.Вставить("1120413", "РегламентированноеУведомлениеС_ИО");
	СоответствиеКНД.Вставить("1110058", "РегламентированноеУведомлениеСогласиеНаРаскрытиеНалоговойТайны");
	СоответствиеКНД.Вставить("1111053", "РегламентированноеУведомлениеСозданиеОбособленныхПодразделений");
	СоответствиеКНД.Вставить("1110010", "РегламентированноеУведомлениеСообщениеОбУчастии");
	СоответствиеКНД.Вставить("1110050", "РегламентированноеУведомлениеТС1");
	СоответствиеКНД.Вставить("1110051", "РегламентированноеУведомлениеТС2");
	СоответствиеКНД.Вставить("1120411", "РегламентированноеУведомлениеУ_ИО");
	СоответствиеКНД.Вставить("1150025", "РегламентированноеУведомлениеУтратаПраваПатент");
	СоответствиеКНД.Вставить("1150003", "РегламентированноеУведомлениеУтратаПраваУСН");
	СоответствиеКНД.Вставить("1120412", "РегламентированноеУведомлениеУчастиеВРоссийскихОрганизациях");
	СоответствиеКНД.Вставить("1150017", "РегламентированноеУведомлениеУчастникаСколковоОсвобождениеНалогообложения");
	СоответствиеКНД.Вставить("1111501", "РегламентированноеУведомлениеФормаР11001");
	СоответствиеКНД.Вставить("1111502", "РегламентированноеУведомлениеФормаР13001");
	СоответствиеКНД.Вставить("1111516", "РегламентированноеУведомлениеФормаР14001");
	СоответствиеКНД.Вставить("1112501", "РегламентированноеУведомлениеФормаР21001");
	СоответствиеКНД.Вставить("1112502", "РегламентированноеУведомлениеФормаР24001");
	СоответствиеКНД.Вставить("1111048", "РегламентированноеУведомлениеПолучениеДокументаНалоговогоРезидента");
	
	Возврат СоответствиеКНД;
КонецФункции
#КонецОбласти
