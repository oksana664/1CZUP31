#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат; 
	КонецЕсли;		
	
	Если ЭтоГруппа Тогда
		Возврат;	
	КонецЕсли;
	
	Если ВесВопроса < 0 Тогда
		ВесВопроса = 0;
	КонецЕсли;
	
	Если ВесВопроса > 100 Тогда
		ВесВопроса = 100;
	КонецЕсли;	
	
	Если НЕ РазрешитьРедактироватьНаименование И ЗначениеЗаполнено(СсылкаНаЭлементКурса) Тогда
		Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаЭлементКурса, "Наименование");
	КонецЕсли;
	
	РазработкаЭлектронныхКурсовСлужебный.ПроверитьВозможностьЗаписиЭлементаПередЗаписью(ЭтотОбъект, Отказ);
	РазработкаЭлектронныхКурсовСлужебный.УстановитьДатуИзмененияПередЗаписью(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	РазработкаЭлектронныхКурсовСлужебный.УстановитьКодКратныйДесятиПриУстановкеНовогоКода(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

#КонецОбласти


#КонецЕсли
