#Область СлужебныеПроцедурыИФункции
Процедура ОбработкаВнесенияДанных(Результат, ДополнительныеПараметры) Экспорт
	РезультатПроверки = _НастройкиКонфигурацииНаСервере.ПроверкаДанныхОрганизации();
	Если Не РезультатПроверки Тогда
		ЗавершитьРаботуСистемы(Ложь);
	Иначе
		Отказ = _НастройкиКонфигурацииНаСервере.ПроверкаЗапускаКонфигурации();
		Если Отказ Тогда
			ЗавершитьРаботуСистемы(Ложь);
		КонецЕсли;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Результат) Тогда
		ЗавершитьРаботуСистемы();
	КонецЕсли;
КонецПроцедуры
Процедура СделатьКопиюЗавершениеЗавершение(КодВозврата, ДополнительныеПараметры) Экспорт

	_НастройкиКонфигурацииНаСервере.ЗаписатьПутьККопииНаСервере(ДополнительныеПараметры);
	_НастройкиКонфигурацииНаСервере.ЗаписатьДатуСозданияКопии();
КонецПроцедуры
Асинх Процедура РезультатПоискаФайлов() Экспорт
	Перем НайденныеФайлы, СтрФайла;
#Если Не ВебКлиент Тогда
	Shell = Неопределено;
	РабочийСтол = Неопределено;
	ПолучитьАдресРабочегоСтола(Shell, РабочийСтол);

	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	ПозицияПоиска = СтрНайти(Врег(СтрокаСоединенияСБД), "FILE=");
	НайденныеФайлыЯрлык = ЖДАТЬ НайтиФайлыАсинх(РабочийСтол,"iPig.lnk",Истина);
	Если ПозицияПоиска = 1 И НайденныеФайлыЯрлык.Количество() = 0 Тогда
			//КаталогВременныхФайлов 	= Ждать КаталогВременныхФайловАсинх();
		КаталогПользователя 	= СтрЗаменить(РабочийСтол, "\Desktop", "\");
		НайденныеФайлы = ЖДАТЬ НайтиФайлыАсинх(КаталогПользователя,"ibases.v8i",Истина);
		Для Каждого СтрФайла Из НайденныеФайлы Цикл
			ТекстовыйФайл = Новый ТекстовыйДокумент;
			Ждать ТекстовыйФайл.ПрочитатьАсинх(СтрФайла.ПолноеИмя);
			Результат = СтрЧислоВхождений(ТекстовыйФайл.ПолучитьТекст(), "Connect=");
			Если Результат = 1 Тогда
				НайденныеФайлыЯрлык = ЖДАТЬ НайтиФайлыАсинх(РабочийСтол,"1C Предприятие.lnk",Истина);
				Ждать УдалитьФайлыАсинх(РабочийСтол,"1C Предприятие.lnk");
				СоздатьЯрлыкIPig();
			Иначе
				СоздатьЯрлыкIPig();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
#КонецЕсли
КонецПроцедуры

Процедура СоздатьЯрлыкIPig()

	Shell = Неопределено;
	РабочийСтол = Неопределено;
	ПолучитьАдресРабочегоСтола(Shell, РабочийСтол);

	
	//Создание файла ярлыка
	Ярлык = Shell.CreateShortcut(РабочийСтол + "\iPig.lnk"); 			
	//Рабочая папка
	Ярлык.WorkingDirectory = Shell.ExpandEnvironmentStrings("C:\Program Files\1cv8\common\");  
	//Объект
	Ярлык.TargetPath = """C:\Program Files\1cv8\common\1cestart.exe""";

	Ярлык.Arguments = " enterprise /F" + КаталогИБ() + " /N" + "Пользователь"; 	
	//Путь к файлу с иконкой                                                
	БиблиотекаКартинок.iPigIco.Записать(Shell.ExpandEnvironmentStrings("%appdata%\iPig.ico"));
	Ярлык.IconLocation = Shell.ExpandEnvironmentStrings("%appdata%\iPig.ico, 0");   
	//Комментарий
	Ярлык.Description = "iPig";	
	//Запись файла ярлыка
	Ярлык.Save();

КонецПроцедуры

Процедура ПолучитьАдресРабочегоСтола(Shell, РабочийСтол)

	РабочийСтол = "";
	Попытка
		Shell  = Новый COMОбъект("WScript.Shell");
		РабочийСтол = Shell.SpecialFolders.Item("Desktop");
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось создать объект WScript.Shell";
		Сообщение.Сообщить();
	КонецПопытки;
	
	//Получение пути к директории "Рабочий стол"
	
	//РабочийСтол = "C:\Users\Public\Desktop\";

КонецПроцедуры

Функция КаталогИБ()
	СтрокаСоединенияСБД = СтрокаСоединенияИнформационнойБазы();
	// в зависимости от того файловый это вариант БД или нет,  по-разному отображается путь в БД 
	ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "FILE=");
	Если ПозицияПоиска = 1 Тогда
		// Файловая	
		Возврат Сред(СтрокаСоединенияСБД, 7, СтрДлина(СтрокаСоединенияСБД) - 8) + "\";
	Иначе 
		// Серверная - Используем КаталогВременныхФайлов() 
		Возврат КаталогВременныхФайлов();
	КонецЕсли;
КонецФункции

Процедура СделатьКопиюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		_НастройкиКонфигурацииНаСервере.СброситьДатуПоследнейКопии();

		
		//@skip-check type-not-defined
		Текст = Новый ЗаписьТекста(ДополнительныеПараметры.КаталогВременныхФайлов + "\update.bat", // имя

			КодировкаТекста.ANSI, // кодировка

			Символы.ПС, // разделитель строк (необ.)

			Ложь // перезаписывать файл, а не дописывать в конец (необ.)
		);
		Текст.ЗаписатьСтроку("echo off");
		Текст.ЗаписатьСтроку("cls");
		Текст.ЗаписатьСтроку("chcp 1251");

		Текст.ЗаписатьСтроку("rem -- Убивам процесс 1С если он такой есть");
		Текст.ЗаписатьСтроку("taskkill /f /im 1cv8c.exe");

		Текст.ЗаписатьСтроку("rem -- определяем какая платформа 1С стоит х86 или х64,");
		Текст.ЗаписатьСтроку("rem -- пути у них разные");
		Текст.ЗаписатьСтроку("IF EXIST ""%programfiles%\1cv8\common\1cestart.exe"" (");
		Текст.ЗаписатьСтроку("	set path_1C=""%programfiles%\1cv8\common\1cestart.exe""");
		Текст.ЗаписатьСтроку("	) ELSE (");
		Текст.ЗаписатьСтроку("	set path_1C=""%programfiles(x86)%\1cv8\common\1cestart.exe""");
		Текст.ЗаписатьСтроку("	)");
		Текст.ЗаписатьСтроку("rem -----------------------------------------------");

		Текст.ЗаписатьСтроку("rem -- Данные пользователя");
		Текст.ЗаписатьСтроку("set user_1C=""Пользователь""");
		Текст.ЗаписатьСтроку("set pswd_1C=""""");
		Текст.ЗаписатьСтроку("rem -- Название базы");
		НазваниеФайла = ДополнительныеПараметры.ПутьКФайлуОбновления;
		Текст.ЗаписатьСтроку("set cfu_file=" + """" + НазваниеФайла + """");
		Текст.ЗаписатьСтроку("rem -- путь базы бэкапа");
		Текст.ЗаписатьСтроку("set name_base_backup=" + ПолучитьПредставлениеИнформационнойБазы());

		Текст.ЗаписатьСтроку("setlocal");

		Текст.ЗаписатьСтроку("rem -- выгрузка базы данных");
		Текст.ЗаписатьСтроку(
			"%path_1C% CONFIG /F%name_base_backup% /N%user_1C% /P%pswd_1C% /UpdateCfg %cfu_file% /UpdateDBCfg /Out update.log");
		Текст.ЗаписатьСтроку("TIMEOUT /T 60 /NOBREAK ");
		Текст.ЗаписатьСтроку("%path_1C% enterprise /F%name_base_backup% /N%user_1C% /P%pswd_1C%");
		Текст.Закрыть();
		НачатьЗапускПриложения(Новый ОписаниеОповещения("СделатьКопиюЗавершениеОбновления",
			_ОбработкаОповещенияНаКлиенте), "update.bat", ДополнительныеПараметры.КаталогВременныхФайлов);
	Иначе
	КонецЕсли;

КонецПроцедуры
Процедура СделатьКопиюЗавершениеОбновления(КодВозврата, ДополнительныеПараметры1) Экспорт
КонецПроцедуры
Функция ПолучитьПредставлениеИнформационнойБазы()

	СтрокаСоединенияСБД =  СтрокаСоединенияИнформационнойБазы();
	ЭтоФайловаяИБ = Найти(Врег(СтрокаСоединенияСБД), "FILE=") = 1;
	Если ЭтоФайловаяИБ Тогда
		ПутьКБД = Сред(СтрокаСоединенияСБД, 6, СтрДлина(СтрокаСоединенияСБД) - 6);
		ФайловаяБД = Истина;
	Иначе
		// надо к имени сервера прибавить имя пути информационной базы
		ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "SRVR=");

		Если ПозицияПоиска <> 1 Тогда
			Возврат Неопределено;
		КонецЕсли;

		ПозицияТочкиСЗапятой = Найти(СтрокаСоединенияСБД, ";");
		НачальнаяПозицияКопирования = 6 + 1;
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;

		ИмяСервера = Сред(СтрокаСоединенияСБД, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования
			- НачальнаяПозицияКопирования + 1);

		СтрокаСоединенияСБД = Сред(СтрокаСоединенияСБД, ПозицияТочкиСЗапятой + 1);
		
		// позиция имени сервера
		ПозицияПоиска = Найти(Врег(СтрокаСоединенияСБД), "REF=");

		Если ПозицияПоиска <> 1 Тогда
			Возврат Неопределено;
		КонецЕсли;

		НачальнаяПозицияКопирования = 6;
		ПозицияТочкиСЗапятой = Найти(СтрокаСоединенияСБД, ";");
		КонечнаяПозицияКопирования = ПозицияТочкиСЗапятой - 2;

		ИмяИБНаСервере = Сред(СтрокаСоединенияСБД, НачальнаяПозицияКопирования, КонечнаяПозицияКопирования
			- НачальнаяПозицияКопирования + 1);

		ПутьКБД = ИмяСервера + "/ " + ИмяИБНаСервере;
		ФайловаяБД = Ложь;
	КонецЕсли;
	Возврат ПутьКБД;
КонецФункции
Процедура ОткрытьФормуСвиноматки(НомерЖивотного, ДатаВвода) Экспорт
	Попытка
		ОткрытьФорму("РегистрСведений.КарточкаСвиноматки.Форма.ФормаЗаписи", Новый Структура("Ключ, ФормаОткрыта",
			_НастройкиКонфигурацииНаСервере.ПолучитьКлючЗаписи(НомерЖивотного, ДатаВвода), Истина), , , , , , );
	Исключение 
		//Сообщить(Строка(Строка.НомерЖивотного)+"_"+ Строка.Период);
	КонецПопытки;

КонецПроцедуры

Процедура ВыполнитьПослеЗакрытия(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если Не ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		ЗавершитьРаботуСистемы();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти