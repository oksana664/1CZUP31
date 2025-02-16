#Область СлужебныеПроцедурыИФункции

Функция МакетЭлектронногоКурса() Экспорт	
	Возврат ИзучениеЭлектронныхКурсовСлужебный.МакетЭлектронногоКурса();	
КонецФункции

Функция ДанныеПубликации(Знач ЭлектронныйКурс, Знач ФрагментКурса, Знач ДатаСуществующегоФайла = Неопределено) Экспорт
	
	Если ФрагментКурса = Неопределено ИЛИ ФрагментКурса = ЭлектронныйКурс Тогда		
		Возврат РегистрыСведений.ПубликацииЭлектронныхКурсов.Публикация(ЭлектронныйКурс, ДатаСуществующегоФайла);
	Иначе		
		Возврат ИзучениеЭлектронныхКурсовСлужебный.ДанныеПубликацииЭлектронногоКурса(ЭлектронныйКурс, ФрагментКурса, ДатаСуществующегоФайла);
	КонецЕсли;		
	
КонецФункции

Функция КоличествоСекундИзСтруктурыВременногоИнтервала(НоваяСтруктураПериода) Экспорт
	Возврат ИзучениеЭлектронныхКурсовСлужебныйSCORM.КоличествоСекундИзСтруктурыВременногоИнтервала(НоваяСтруктураПериода);
КонецФункции

Функция ПолнаяСтрокаИзКоличестваСекунд(ПродолжительностьВСекундах) Экспорт
	Возврат ИзучениеЭлектронныхКурсовСлужебныйSCORM.ПолнаяСтрокаИзКоличестваСекунд(ПродолжительностьВСекундах);
КонецФункции

#КонецОбласти