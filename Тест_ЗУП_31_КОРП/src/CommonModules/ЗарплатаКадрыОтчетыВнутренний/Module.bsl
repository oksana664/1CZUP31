
#Область СлужебныеПроцедурыИФункции

Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ЗарплатаКадрыОтчетыРасширенный.НастроитьВариантыОтчетов(Настройки);
	
КонецПроцедуры

Процедура ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчета, НаАванс) Экспорт
	
	ЗарплатаКадрыОтчетыРасширенный.ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчета, НаАванс);
	
КонецПроцедуры

Процедура НастроитьВариантОтчетаРасчетныйЛисток(НастройкиОтчета) Экспорт
	
	ЗарплатаКадрыОтчетыРасширенный.НастроитьВариантОтчетаРасчетныйЛисток(НастройкиОтчета);
	
КонецПроцедуры

Процедура ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗарплатаКадрыОтчетыРасширенный.ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

Функция ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта) Экспорт
	
	Возврат ЗарплатаКадрыОтчетыРасширенный.ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта);
	
КонецФункции

Функция НаборыВнешнихДанныхАнализНачисленийИУдержаний() Экспорт
	
	Возврат ЗарплатаКадрыОтчетыРасширенный.НаборыВнешнихДанныхАнализНачисленийИУдержаний();
	
КонецФункции

Функция ЗапросДанныеДокументаФизическихЛиц() Экспорт
	
	Возврат ЗарплатаКадрыОтчетыРасширенный.ЗапросДанныеДокументаФизическихЛиц();
	
КонецФункции

Функция НачислениеДоговораГПХПоДокументуОснованию(ДокументОснование) Экспорт
	
	Возврат ЗарплатаКадрыОтчетыРасширенный.НачислениеДоговораГПХПоДокументуОснованию(ДокументОснование);
	
КонецФункции

#КонецОбласти
