////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать РаботаСФайламиПереопределяемый.ПриОпределенииСправочниковХраненияФайлов.
// Позволяет переопределить справочники хранения файлов по типам владельцев.
// 
// Параметры:
//  ТипВладелецФайла  - Тип - тип ссылки объекта, к которому добавляется файл.
//
//  ИменаСправочников - Соответствие - содержит в ключах имена справочников.
//                      При вызове содержит стандартное имя одного справочника,
//                      помеченного, как основной (если существует).
//                      Основной справочник используется для интерактивного
//                      взаимодействия с пользователем. Чтобы указать основной
//                      справочник, нужно установить Истина в значение соответствия.
//                      Если установить Истина более одного раза, тогда будет ошибка.
//
Процедура ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников) Экспорт
КонецПроцедуры

// Устарела. Следует использовать РаботаСФайламиПереопределяемый.ПриОпределенииНастроек.
// Формирует массив метаданных, которые не должны выводиться в настройках очистки файлов.
//
// Параметры:
//   МассивИсключений   - Массив - метаданные, которые не должны выводиться в настройках очистки файлов.
//
// Пример:
//   МассивИсключений.Добавить(Метаданные.Справочники.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы);
//
Процедура ПриОпределенииОбъектовИсключенияОчисткиФайлов(МассивИсключений) Экспорт

КонецПроцедуры

// Устарела. Следует использовать РаботаСФайламиПереопределяемый.ПриОпределенииНастроек.
// Формирует массив метаданных, которые не должны выводиться в настройках синхронизации файлов.
//
// Параметры:
//   МассивИсключений   -Массив - метаданные, которые не должны выводиться в настройках синхронизации файлов.
//
// Пример:
//   МассивИсключений.Добавить(Метаданные.Справочники.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы);
//
Процедура ПриОпределенииОбъектовИсключенияСинхронизацииФайлов(МассивИсключений) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

