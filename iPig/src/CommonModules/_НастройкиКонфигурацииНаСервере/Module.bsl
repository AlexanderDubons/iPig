Функция ПроверитьТекущуюДатуНаСервере() Экспорт
	Отказ = Ложь;
	СисИнфо = Новый СистемнаяИнформация;
	Если Константы.СистемнаяИнформация.Получить() = "" Тогда
		Константы.СистемнаяИнформация.Установить(СисИнфо.Процессор);
	Иначе
		СисИнфоКонст = Константы.СистемнаяИнформация.Получить();
		Если СисИнфоКонст <> СисИнфо.Процессор Тогда
			//Временно пока не решен вопрос с сетевой версией   
			Если Константы.УНП.Получить() <> 200278860 Тогда
				Константы.УНП.Установить(0);
				Константы.КлючЛицензии.Установить("");
				Константы.СистемнаяИнформация.Установить(СисИнфо.Процессор);
			КонецЕсли;
			//--------------------------------------------
		КонецЕсли;
	КонецЕсли;
	Попытка
		Если ТекущаяДата() >= ПолучитьДатуЛицензии() Тогда
			Отказ = Истина;
		КонецЕсли;
	Исключение
		Отказ = Истина;
	КонецПопытки;
	//Если Константы.ДатаПоследнегоВхода.Получить() <= ТекущаяДата()  Тогда
	//	Константы.ДатаПоследнегоВхода.Установить(ТекущаяДата());
	//Иначе     
	//	Отказ = Истина;
	//КонецЕсли;
	Возврат Отказ;
КонецФункции

Функция ПроверкаЗапускаКонфигурации() Экспорт
	Если ТекущаяДата() > ПолучитьДатуЛицензии() Тогда
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

Процедура СистемныеСообщенияКонфигурации() Экспорт 
	// Лицензия для кремко
	Если ТекущаяДата() + 14 * 24 * 60 * 60 > ПолучитьДатуЛицензии() Тогда
		Сообщить("Срок действия лицензии истекает " + ПолучитьДатуЛицензии(), СтатусСообщения.ОченьВажное);
	КонецЕсли;
	Если РасчетНомераНедели(НачалоГода(ТекущаяДата()), 1) = 52 Тогда
		Константы.КорректировкаНачалаГода.Установить(1);
	Иначе
		Константы.КорректировкаНачалаГода.Установить(0);
	КонецЕсли;
	Константы.ОтключитьКонтрольОшибок.Установить(Ложь);
КонецПроцедуры

Функция ПолучитьДатуЛицензии() Экспорт
	УНПОрганиазации = Константы.УНП.Получить();
	Ключ  = Константы.КлючЛицензии.Получить();
	Если Не ЗначениеЗаполнено(Ключ) Тогда
		Если УНПОрганиазации = 111 Тогда
			Возврат Дата('20290401');
		Иначе
			Возврат Дата('20240101');
		КонецЕсли;
	Иначе
		Возврат _НастройкиКонфигурацииНаСервере.ПолучитьКлючЛицензии(Ключ, , Истина);
	КонецЕсли;
КонецФункции
&НаСервере
Функция ПолучитьСписокСвиноматок(НомерЖивотного) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КарточкаВнесенияДанных.Период КАК Период,
				   |	КарточкаВнесенияДанных.КодПороды КАК КодПороды,
				   |	КарточкаВнесенияДанных.ДатаРождения КАК ДатаРождения
				   |ИЗ
				   |	РегистрСведений.КарточкаВнесенияДанных КАК КарточкаВнесенияДанных
				   |ГДЕ
				   |	КарточкаВнесенияДанных.НомерЖивотного = &НомерЖивотного
				   |	И КарточкаВнесенияДанных.ДатаВыбытие = ДАТАВРЕМЯ(1, 1, 1)";
	Запрос.УстановитьПараметр("НомерЖивотного", НомерЖивотного);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	СписокСвиноматок = Новый СписокЗначений;
	Пока РезультатЗапроса.Следующий() Цикл
		Результат = Новый Структура;
		Результат.Вставить("НомерЖивотного", НомерЖивотного);
		Результат.Вставить("ДатаВвода", НачалоДня(РезультатЗапроса.Период));
		Результат.Вставить("КодПороды", РезультатЗапроса.КодПороды);
		Результат.Вставить("ДатаРождения", РезультатЗапроса.ДатаРождения);
		СписокСвиноматок.Добавить(Результат, "Номер животного = " + НомерЖивотного + " Дата ввода = "
			+ РезультатЗапроса.Период, );
	КонецЦикла;
	Возврат СписокСвиноматок;
КонецФункции

&НаСервере
Функция ПолучитьСписокСвиноматокВсех(НомерЖивотного) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КарточкаВнесенияДанных.Период КАК Период,
				   |	КарточкаВнесенияДанных.КодПороды КАК КодПороды
				   |ПОМЕСТИТЬ ВтДанные
				   |ИЗ
				   |	РегистрСведений.КарточкаВнесенияДанных КАК КарточкаВнесенияДанных
				   |ГДЕ
				   |	КарточкаВнесенияДанных.НомерЖивотного = &НомерЖивотного
				   |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	КарточкаРодители.ДатаВвода,
				   |	КарточкаРодители.КодПороды
				   |ИЗ
				   |	Справочник.КарточкаРодители КАК КарточкаРодители
				   |ГДЕ
				   |	КарточкаРодители.НомерЖивотного = &НомерЖивотного
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ РАЗЛИЧНЫЕ
				   |	ВтДанные.Период КАК Период,
				   |	ВтДанные.КодПороды КАК КодПороды
				   |ИЗ
				   |	ВтДанные КАК ВтДанные";
	Запрос.УстановитьПараметр("НомерЖивотного", НомерЖивотного);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	СписокСвиноматок = Новый СписокЗначений;
	Пока РезультатЗапроса.Следующий() Цикл
		Результат = Новый Структура;
		Результат.Вставить("НомерЖивотного", НомерЖивотного);
		Результат.Вставить("ДатаВвода", НачалоДня(РезультатЗапроса.Период));
		Результат.Вставить("КодПороды", РезультатЗапроса.КодПороды);
		СписокСвиноматок.Добавить(Результат, "Номер животного = " + НомерЖивотного + " Дата ввода = "
			+ РезультатЗапроса.Период, );
	КонецЦикла;
	Возврат СписокСвиноматок;
КонецФункции
&НаСервере
Функция ПолучитьСписокХряковВсех(НомерЖивотного) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	КарточкаХряка.Период КАК Период,
				   |	КарточкаХряка.КодПороды КАК КодПороды
				   |ИЗ
				   |	РегистрСведений.КарточкаХряка КАК КарточкаХряка
				   |ГДЕ
				   |	КарточкаХряка.НомерЖивотного = &НомерЖивотного";
	Запрос.УстановитьПараметр("НомерЖивотного", НомерЖивотного);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	СписокСвиноматок = Новый СписокЗначений;
	Пока РезультатЗапроса.Следующий() Цикл
		Результат = Новый Структура;
		Результат.Вставить("НомерЖивотного", НомерЖивотного);
		Результат.Вставить("ДатаВвода", НачалоДня(РезультатЗапроса.Период));
		Результат.Вставить("КодПороды", РезультатЗапроса.КодПороды);
		СписокСвиноматок.Добавить(Результат, "Номер животного = " + НомерЖивотного + " Дата ввода = "
			+ РезультатЗапроса.Период, );
	КонецЦикла;
	Возврат СписокСвиноматок;
КонецФункции
Функция ПроверкаДанныхОрганизации() Экспорт
	УНПОрганизации = Константы.УНП.Получить();
	НаименованиеОрганизации = Константы.Организация.Получить();

	НаименованиеОрганизации_Заполнено 	= Не ПустаяСтрока(НаименованиеОрганизации);
	УНПОрганизации_Заполнено 			= (УНПОрганизации <> 0);

	Если Не (НаименованиеОрганизации_Заполнено И УНПОрганизации_Заполнено) Тогда
		Константы.ДниПослеВводаРемСвинки.Установить(90);
		Константы.ДниПослеОхотыБезСлучкиСвиноматки.Установить(35);
		Константы.ПериодСупоросностиСвиноматки.Установить(116);
		Константы.ДнейБезУЗИСвиноматки.Установить(35);
		Константы.ДнейПослеНегативногоУЗИСвиноматки.Установить(21);
		Константы.ДнейПослеАбортаБезПодсосныхСвиноматки.Установить(21);
		Константы.ПодсосныйПериодСвиноматки.Установить(21);
		Константы.ДниПослеОтъемаСвиноматки.Установить(7);
	КонецЕсли;
	Если Константы.МаксимальноеКоличествоЖиворожденных.Получить() = 0 Тогда
		Константы.МаксимальноеКоличествоЖиворожденных.Установить(36);
	КонецЕсли;
	Если Константы.НачалоОтсчетаНомераНедели.Получить() = 0 Тогда
		Константы.НачалоОтсчетаНомераНедели.Установить(1);
	КонецЕсли;

	НаборЗаписей = РегистрыСведений.НастройкаКарточкиГруппы.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		НоваяСтрока 			= НаборЗаписей.Добавить();
		НоваяСтрока.Название 	= "УЗИ 4 неделя";
		НоваяСтрока.Дни         = 28;
		НоваяСтрока.ТипСобытия  = Перечисления.ТипСобытия.Случка;
		НоваяСтрока.ПоказатьВКарте = Истина;

		НоваяСтрока 			= НаборЗаписей.Добавить();
		НоваяСтрока.Название 	= "Вакц 4 неделя до опороса";
		НоваяСтрока.Дни         = 28;
		НоваяСтрока.ТипСобытия  = Перечисления.ТипСобытия.Опорос;
		НоваяСтрока.ПоказатьВКарте = Истина;

		НоваяСтрока 			= НаборЗаписей.Добавить();
		НоваяСтрока.Название 	= "Вакц 7 неделя до опороса";
		НоваяСтрока.Дни         = 49;
		НоваяСтрока.ТипСобытия  = Перечисления.ТипСобытия.Опорос;
		НоваяСтрока.ПоказатьВКарте = Истина;

		НаборЗаписей.Записать();
	КонецЕсли;
	Возврат НаименованиеОрганизации_Заполнено И УНПОрганизации_Заполнено
КонецФункции
&НаСервере
Функция ПолучитьПородуХрякаНаСервере(НомерЖивотногоХряк) Экспорт

	Перем КодПороды, Стр;

	НаборЗаписейХряк = РегистрыСведений.КарточкаХряка.СоздатьНаборЗаписей();
	НаборЗаписейХряк.Отбор.НомерЖивотного.Установить(НомерЖивотногоХряк);
	НаборЗаписейХряк.Прочитать();
	КодПороды = Справочники.Порода.ПустаяСсылка();

	Для Каждого Стр Из НаборЗаписейХряк Цикл
		КодПороды = Стр.КодПороды;
	КонецЦикла;
	Возврат КодПороды;
КонецФункции
Функция ПолучитьНаименованиеОрганизацииНаСервере() Экспорт
	Возврат Константы.Организация.Получить();
КонецФункции

Функция ПолучитьВерсиюКонфигурацииНаСервере() Экспорт
	Возврат Метаданные.Версия;
КонецФункции
Функция СделатьКопиюБазыНаСервере() Экспорт
	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");

	Возврат ((Константы.ДатаПоследнейКопии.Получить() = Дата(1, 1, 1) Или Константы.ДатаПоследнейКопии.Получить() + 7
		* 24 * 60 * 60 <= ТекущаяДата()) И ПозицияПоиска = 1) И ПолучитьУНПНаСервере() <> 111
КонецФункции

Функция ФайлаваяБазаНаСервере() Экспорт
	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");

	Возврат ПозицияПоиска = 1
КонецФункции

Функция ПолучитьОбновлениеБазыНаСервере() Экспорт
	Возврат (Константы.ДатаПоследнегоОбновления.Получить() = Дата(1, 1, 1)
		Или Константы.ДатаПоследнегоОбновления.Получить() + 7 * 24 * 60 * 60 <= ТекущаяДата()
		Или Константы.РезультатОбновления = 1)
КонецФункции

Процедура УстановитьДатуОбновленияНаСервере() Экспорт
	Константы.ДатаПоследнегоОбновления.Установить(ТекущаяДатаСеанса());
КонецПроцедуры

Функция ПолучитьПутьСохраненияНаСервере() Экспорт
	//ИмяКаталога = ?(Константы.ПутьДляВыгрузкиИБ.Получить() = "",КаталогВременныхФайлов(),Константы.ПутьДляВыгрузкиИБ.Получить());
	//Если ПроверитьСуществованиеКаталога(ИмяКаталога) Тогда
	//	Возврат ИмяКаталога;
	//Иначе                  
	//	Возврат КаталогВременныхФайлов();
	//КонецЕсли; 
	Возврат КаталогВременныхФайлов();
КонецФункции

Функция ПолучитьУНПНаСервере() Экспорт
	Возврат Константы.УНП.Получить();
КонецФункции
Функция ПроверитьСуществованиеКаталога(ИмяКаталога) Экспорт

	КаталогНаДиске = Новый Файл(ИмяКаталога);
	Если КаталогНаДиске.Существует() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

Процедура ЗаписатьПутьККопииНаСервере(Путь) Экспорт
	Константы.ПутьКПоследнейКопии.Установить(Путь);
КонецПроцедуры
Процедура СоздатьИОтправитьПисьма(ИмяОтправителя, СписокВложений = Неопределено, СписокПолучателей, ТекстПисьма = "",
	ТемаПисьма = "") Экспорт

	Отказ = Ложь;

	Профиль=Новый ИнтернетПочтовыйПрофиль;
	Профиль.Таймаут 			= 5;
	Профиль.АдресСервераSMTP 	= "smtp.yandex.ru";
	Профиль.ПортSMTP         	= 465;
	Профиль.ИспользоватьSSLSMTP	= Истина;
	Профиль.АдресСервераIMAP 	= "imap.yandex.ru";
	Профиль.ПортIMAP         	= 993;
	Профиль.Пользователь     	= "iPig@konsulagro.by";
	Профиль.Пароль           	= "nihgslypimfoacav";
	Профиль.ПользовательSMTP 	= "iPig@konsulagro.by";
	Профиль.ПарольSMTP          = "nihgslypimfoacav";
	Профиль.АутентификацияSMTP	= СпособSMTPАутентификации.Login;

	Почта = Новый ИнтернетПочта;
	Письмо = Новый ИнтернетПочтовоеСообщение;
	Текст = Письмо.Тексты.Добавить(ТекстПисьма);
	Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	Письмо.Тема = ТемаПисьма;
	Письмо.Отправитель = "iPig@konsulagro.by";
	Письмо.ИмяОтправителя = ИмяОтправителя;

	Если ЗначениеЗаполнено(СписокПолучателей) Тогда
		Для Каждого Получатель Из СписокПолучателей Цикл
			Письмо.Получатели.Добавить(Получатель);
		КонецЦикла;
	КонецЕсли;

	Если ЗначениеЗаполнено(СписокВложений) Тогда
		Для Каждого ИмяФайла Из СписокВложений Цикл
			Попытка
				Письмо.Вложения.Добавить(ИмяФайла);
			Исключение
				Отказ = Истина;
				ТекстПисьма = ТекстПисьма + Символы.ПС + ИмяФайла;
				Константы.ПутьКПоследнейКопии.Установить("");
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;

	Попытка  
		//Если Не Отказ Тогда
		Почта.Подключиться(Профиль);
		Почта.Послать(Письмо);
		Почта.Отключиться(); 
		//КонецЕсли;
	Исключение
		Константы.РезультатКопии.Установить(1);
	КонецПопытки;
	Константы.РезультатКопии.Установить(0);
КонецПроцедуры

Процедура ПроверитьКопиюНаСервере() Экспорт
	Если Константы.ПутьКПоследнейКопии.Получить() <> "" Тогда
		СписокПолучателей = Новый СписокЗначений;
		СписокПолучателей.Добавить("iPig@konsulagro.by", "iPig@konsulagro.by");
		
		
		//ТекстПисьма = "Расчет цены" + Стр.ИмяФайла ;
		СисИнфо = Новый СистемнаяИнформация;
		ТекстПисьма = "Копия базы: " + Константы.Организация.Получить() + Символы.ПС + "Системная информация: "
			+ Константы.СистемнаяИнформация.Получить() + Символы.ПС + "Идентификатор клиента: "
			+ СисИнфо.ИдентификаторКлиента;

		ТемаПисьма = "Копия базы " + Константы.Организация.Получить();

		СписокВложений = Новый Массив;

		ФайлВЛожения = Константы.ПутьКПоследнейКопии.Получить();
		СписокВложений.Добавить(ФайлВЛожения);

		СоздатьИОтправитьПисьма(Константы.Организация.Получить(), СписокВложений, СписокПолучателей, ТекстПисьма,
			ТемаПисьма);

		Если Константы.РезультатКопии.Получить() = 0 Тогда
			Константы.ПутьКПоследнейКопии.Установить("");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры          

//
Процедура ЗаписатьДатуСозданияКопии() Экспорт

	Константы.ДатаПоследнейКопии.Установить(ТекущаяДата());

КонецПроцедуры // ЗаписатьДатуСозданияКопии()
&НаСервере
Функция ПолучитьКлючЗаписи(НомерЖивотного, Период) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КарточкаСвиноматкиСрезПоследних.Период КАК Период,
	|	КарточкаСвиноматкиСрезПоследних.НомерЖивотного КАК НомерЖивотного,
	|	КарточкаСвиноматкиСрезПоследних.ДатаРождения КАК ДатаРождения,
	|	КарточкаСвиноматкиСрезПоследних.КодПороды КАК КодПороды,
	|	КарточкаСвиноматкиСрезПоследних.IDНомер КАК IDНомер,
	|	КарточкаСвиноматкиСрезПоследних.УшнойВыщип КАК УшнойВыщип,
	|	КарточкаСвиноматкиСрезПоследних.ЛевыхСосков КАК ЛевыхСосков,
	|	КарточкаСвиноматкиСрезПоследних.ПравыхСосков КАК ПравыхСосков,
	|	КарточкаСвиноматкиСрезПоследних.НомерЖивотногоОтец КАК НомерЖивотногоОтец,
	|	КарточкаСвиноматкиСрезПоследних.ДатаРожденияОтец КАК ДатаРожденияОтец,
	|	КарточкаСвиноматкиСрезПоследних.НомерЖивотногоМать КАК НомерЖивотногоМать,
	|	КарточкаСвиноматкиСрезПоследних.ДатаРожденияМать КАК ДатаРожденияМать,
	|	КарточкаСвиноматкиСрезПоследних.Статус КАК Статус,
	|	КарточкаСвиноматкиСрезПоследних.ДатаАбортаОпороса КАК ДатаАбортаОпороса,
	|	КарточкаСвиноматкиСрезПоследних.Пролечено КАК Пролечено,
	|	КарточкаСвиноматкиСрезПоследних.ДатаВакцинации КАК ДатаВакцинации,
	|	КарточкаСвиноматкиСрезПоследних.НомерОпороса КАК НомерОпороса,
	|	КарточкаСвиноматкиСрезПоследних.DGTagId КАК DGTagId,
	|	КарточкаСвиноматкиСрезПоследних.DanAvlTagID КАК DanAvlTagID
	|ИЗ
	|	РегистрСведений.КарточкаСвиноматки.СрезПоследних КАК КарточкаСвиноматкиСрезПоследних
	|ГДЕ
	|	КарточкаСвиноматкиСрезПоследних.Период = &Период
	|	И КарточкаСвиноматкиСрезПоследних.НомерЖивотного = &НомерЖивотного";

	Запрос.УстановитьПараметр("НомерЖивотного", НомерЖивотного);
	Запрос.УстановитьПараметр("Период", Период);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗначениеКлюча = Новый Структура;
		ЗначениеКлюча.Вставить("НомерЖивотного", ВыборкаДетальныеЗаписи.НомерЖивотного);
		ЗначениеКлюча.Вставить("Период", ВыборкаДетальныеЗаписи.Период);
		ЗначениеКлюча.Вставить("ДатаРождения", ВыборкаДетальныеЗаписи.ДатаРождения);
		ЗначениеКлюча.Вставить("КодПороды", ВыборкаДетальныеЗаписи.КодПороды);
		ЗначениеКлюча.Вставить("IDНомер", ВыборкаДетальныеЗаписи.IDНомер);
		ЗначениеКлюча.Вставить("УшнойВыщип", ВыборкаДетальныеЗаписи.УшнойВыщип);
		ЗначениеКлюча.Вставить("ЛевыхСосков", ВыборкаДетальныеЗаписи.ЛевыхСосков);
		ЗначениеКлюча.Вставить("ПравыхСосков", ВыборкаДетальныеЗаписи.ПравыхСосков);
		ЗначениеКлюча.Вставить("НомерЖивотногоОтец", ВыборкаДетальныеЗаписи.НомерЖивотногоОтец);
		ЗначениеКлюча.Вставить("ДатаРожденияОтец", ВыборкаДетальныеЗаписи.ДатаРожденияОтец);
		ЗначениеКлюча.Вставить("НомерЖивотногоМать", ВыборкаДетальныеЗаписи.НомерЖивотногоМать);
		ЗначениеКлюча.Вставить("ДатаРожденияМать", ВыборкаДетальныеЗаписи.ДатаРожденияМать);
		ЗначениеКлюча.Вставить("Статус", ВыборкаДетальныеЗаписи.Статус);
		ЗначениеКлюча.Вставить("ДатаАбортаОпороса", ВыборкаДетальныеЗаписи.ДатаАбортаОпороса);
		ЗначениеКлюча.Вставить("Пролечено", ВыборкаДетальныеЗаписи.Пролечено);
		ЗначениеКлюча.Вставить("ДатаВакцинации", ВыборкаДетальныеЗаписи.ДатаВакцинации);
		ЗначениеКлюча.Вставить("НомерОпороса", ВыборкаДетальныеЗаписи.НомерОпороса);
		ЗначениеКлюча.Вставить("DGTagId", ВыборкаДетальныеЗаписи.DGTagId);
		ЗначениеКлюча.Вставить("DanAvlTagID", ВыборкаДетальныеЗаписи.DanAvlTagID);

	КонецЦикла;
	Возврат РегистрыСведений.КарточкаСвиноматки.СоздатьКлючЗаписи(ЗначениеКлюча);
КонецФункции
Функция КлючМенеджераЗаписиРС(ДанныеЗаписи, ИмяРС = "") Экспорт

   // Параметры:
   //  ДанныеЗаписи    - МенеджерЗаписи, Структура, Произвольный - коллекция с данными записи
   //  ИмяРС           - Строка - Имя регистра. Если не передано,
   //                    то метаданные регистра берутся из ДанныеЗаписи

	Если ПустаяСтрока(ИмяРС) Тогда
		РС_Метаданные = Метаданные.НайтиПоТипу(ТипЗнч(ДанныеЗаписи));
	Иначе
		РС_Метаданные = Метаданные.РегистрыСведений[ИмяРС];
	КонецЕсли;

	Значения_ключа = Новый Структура("Период");

	Для Каждого Измерение Из РС_Метаданные.Измерения Цикл
		Значения_ключа.Вставить(Измерение.Имя);
	КонецЦикла;

	ЗаполнитьЗначенияСвойств(Значения_ключа, ДанныеЗаписи);

   //Возвращает ключ менеджера записи регистра сведений
	Возврат РегистрыСведений[РС_Метаданные.Имя].СоздатьКлючЗаписи(Значения_ключа);//Ключ записи регистра

КонецФункции
&НаСервере
Процедура СброситьДатуПоследнейКопии() Экспорт

	Константы.ДатаПоследнейКопии.Установить(Дата(1, 1, 1, 0, 0, 0));

КонецПроцедуры
Функция ПолучитьДниСупоросностиНаСервере() Экспорт

	Возврат Константы.ПериодСупоросностиСвиноматки.Получить();

КонецФункции

Функция ПолучитьДанныеОЗапускиОбработкиОбновления() Экспорт
	Возврат КОнстанты.ЗапускОбработкиПриОбновлении.Получить();
КонецФункции
&НаСервере
Функция Base64_Encode(СтрокаДляКодирования)
	Возврат Base64Строка(ПолучитьДвоичныеДанныеИзСтроки(СтрокаДляКодирования));
КонецФункции

&НаСервере
Функция Base64_Decode(СтрокаДляКодирования)
	Возврат ПолучитьСтрокуИзДвоичныхДанных(Base64Значение(СтрокаДляКодирования));
КонецФункции
Функция ПолучитьКлючЛицензии(Ключ, Знач УНП = Ложь, Знач СрокДействия = Ложь) Экспорт
	//СтрКодирования = "";
	//х = 1;
	//Пока х <= СтрДлина(Объект.ИсходнаяСтрока) Цикл
	//	КодСимвола = КодСимвола(Объект.ИсходнаяСтрока,х);
	//	СтрКодирования = СтрКодирования + Символ(КодСимвола + х);   
	//	х = х + 1;
	//КонецЦикла; 
	//Объект.ШифрованнаяСтрока = Base64_Encode(СтрКодирования);

	ДекодированнаяСтрока = Base64_Decode(Ключ);
	х = 1;
	СтрКодирования = "";
	Пока х <= СтрДлина(ДекодированнаяСтрока) Цикл
		КодСимвола = КодСимвола(ДекодированнаяСтрока, х);
		СтрКодирования = СтрКодирования + Символ(КодСимвола - х);
		х = х + 1;
	КонецЦикла;

	СтрПозиция = СтрНайти(СтрКодирования, "/");

	Если УНП Тогда
		УНП = Лев(СтрКодирования, СтрПозиция - 1);
		Возврат УНП;
	ИначеЕсли СрокДействия Тогда
		ДатаЛицензии = Сред(СтрКодирования, СтрПозиция + 1);
		Возврат Дата(ДатаЛицензии);
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции

Функция ПолучитьСписокТЧСтрокой(ТЧ, Реквизит) Экспорт
	Список = Новый СписокЗначений;
	Для Каждого СтрТЧ Из ТЧ Цикл
		Если ЗначениеЗаполнено(СтрТЧ[Реквизит]) Тогда
			Если Список.НайтиПоЗначению(СтрТЧ[Реквизит]) = Неопределено Тогда
				Список.Добавить(СтрТЧ[Реквизит]);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СписокТЧСтрокой = "";
	Для Каждого Элем Из Список Цикл
		Если СписокТЧСтрокой <> "" Тогда
			СписокТЧСтрокой = СписокТЧСтрокой + ", " + СокрЛП(Элем);
		Иначе
			СписокТЧСтрокой = СокрЛП(Элем);
		КонецЕсли;
	КонецЦикла;
	Возврат СписокТЧСтрокой;
КонецФункции

Процедура УстановитьЗначениеОбновления(Результат) Экспорт
	Константы.РезультатОбновления.Установить(Результат);
КонецПроцедуры

Процедура ЗаписьДанныхРегистраВЖурналРегистрацийПриЗаписи(Источник, Отказ, Замещение) Экспорт
	Попытка
		ЗаписьЖурналаРегистрации(Строка(Источник) + " " + Источник.Отбор.НомерЖивотного.Значение,
			УровеньЖурналаРегистрации.Ошибка, Источник, "Изменение");
	Исключение
	КонецПопытки;
КонецПроцедуры
Процедура ЗаписьДанныхРегистраВЖурналРегистрацийПриУдалении(Источник, НомерЖивотного, ДатаСобытия, Событие) Экспорт
	ЗаписьЖурналаРегистрации(Строка(Источник) + " " + НомерЖивотного + " " + ДатаСобытия,
		УровеньЖурналаРегистрации.Ошибка, Источник, Событие);
КонецПроцедуры
Процедура ПроверкаПользователей() Экспорт

	Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0 Тогда
		НовыйПользователь 							= ПользователиИнформационнойБазы.СоздатьПользователя();
		НовыйПользователь.Имя 						= "Пользователь";
		НовыйПользователь.ПолноеИмя 				= "Пользователь";
		НовыйПользователь.Роли.Добавить(Метаданные.Роли.Администратор);
		НовыйПользователь.АутентификацияСтандартная = Истина;
		НовыйПользователь.ПоказыватьВСпискеВыбора 	= Истина;
		НовыйПользователь.Записать();
	КонецЕсли;

	Для Каждого Пользователь Из ПользователиИнформационнойБазы.ПолучитьПользователей() Цикл
		НайтиПользователя = Справочники.Пользователи.НайтиПоРеквизиту("УИД", Пользователь.УникальныйИдентификатор);
		Если НайтиПользователя = Справочники.Пользователи.ПустаяСсылка() Тогда
			ТекущийПользователь = Справочники.Пользователи.СоздатьЭлемент();
			ТекущийПользователь.Наименование  = Пользователь.Имя;
			//ТекущийПользователь.Пароль        = Пользователь.Пароль;
			ТекущийПользователь.УИД           = Пользователь.УникальныйИдентификатор;
			ТекущийПользователь.Записать();
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры



//Функция РасчетНомераНедели(Дата,ДеньНачалаНедели) Экспорт 
//	
//	ДатаРасчетаГода = ТекущаяДата();
//	НачалоГода = Дата(Год(ДатаРасчетаГода),1,1) -( ДеньНедели(Дата(Год(ДатаРасчетаГода),1,1)) - 2 +  ДеньНачалаНедели - 1)%7*(24*60*60); 
//	Если Дата < НачалоГода Тогда 
//		ДатаРасчетаГода = Дата; 
//	КонецЕсли; 
//	НачалоГода = Дата(Год(ДатаРасчетаГода),1,1) -( ДеньНедели(Дата(Год(ДатаРасчетаГода),1,1)) - 2 +  ДеньНачалаНедели - 1)%7*(24*60*60); 
//	НомерНедели = ЦЕЛ(((Дата - НачалоГода )/ (60*60*24))/7);
//	Если НомерНедели = 0 И ДеньНедели(Дата(Год(ДатаРасчетаГода),1,1)) = 1 Тогда		
//		Возврат 1
//	ИначеЕсли  НомерНедели = 0 Тогда
//		Возврат 52;
//	Иначе 
//		Если  ДеньНедели(Дата(Год(ДатаРасчетаГода),1,1)) = 1  Тогда
//			Возврат НомерНедели + 1;  
//		Иначе
//			Возврат НомерНедели;
//		КонецЕсли;
//	КонецЕсли;

//КонецФункции  
Функция КорректировкаНедели(Знач ДеньНачалаНедели) Экспорт

	Перем КорректировкаНедели;

	Если ДеньНачалаНедели = 1 Тогда
		КорректировкаНедели = 0;
	Иначе
		КорректировкаНедели = 7 - ДеньНачалаНедели + 1;
	КонецЕсли;
	Возврат КорректировкаНедели;

КонецФункции
Функция РасчетНомераНедели(Знач Дата, ДеньНачалаНедели) Экспорт
	Перем ЧетвергТойЖеНедели;
	Перем Год;
	Перем НомерНедели;
	КорректировкаНедели = КорректировкаНедели(ДеньНачалаНедели);

	Дата = Дата + КорректировкаНедели * 24 * 60 * 60;

	ЧетвергТойЖеНедели = Дата - (ДеньНедели(Дата) - 4) * 24 * 3600;
	Год = Год(ЧетвергТойЖеНедели);
	НомерНедели = Цел((ДеньГода(ЧетвергТойЖеНедели) - 1) / 7) + 1;

	Возврат НомерНедели;
КонецФункции
Функция ДатаПоНомеруНедели(Неделя, ДеньНачалаНедели) Экспорт
	Перем ЧетвёртоеЯнваряТогоЖеГода;
	Перем НачалоПервойНедели;
	Перем Год;
	Перем НомерНедели;

	КорректировкаНедели = КорректировкаНедели(ДеньНачалаНедели);

	Год = Число(Лев(Неделя, 4));
	НомерНедели = Число(Сред(Неделя, 7, 2));

	ЧетвёртоеЯнваряТогоЖеГода = Дата(Год, 1, 4);
	НачалоПервойНедели = ЧетвёртоеЯнваряТогоЖеГода - (ДеньНедели(ЧетвёртоеЯнваряТогоЖеГода) - 1) * 24 * 3600;

	Возврат НачалоПервойНедели + (НомерНедели - 1) * 7 * 24 * 3600 - КорректировкаНедели * 24 * 60 * 60;
КонецФункции


//Функция ДатаПоНомеруНедели(НомерНедели,   Год = Неопределено) Экспорт 
//	Если РасчетНомераНедели(Дата(?(Год=Неопределено, Год(ТекущаяДата()), Год),1,1),1)  = 52 Тогда
//		Корректировка = 1;
//	Иначе
//		Корректировка = 0;
//	КонецЕсли;
//	
//    Возврат НачалоНедели(Дата(?(Год=Неопределено, Год(ТекущаяДата()), Год),1,1)+((НомерНедели + Корректировка)-НеделяГода(Дата(?(Год = Неопределено, Год(ТекущаяДата()), Год), 1, 1))) * 604800);
//КонецФункции
 