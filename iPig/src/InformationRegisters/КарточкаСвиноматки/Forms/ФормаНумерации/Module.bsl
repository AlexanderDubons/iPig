&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДанныеВБазе = Ложь;
	ПородаОтец							= Параметры.ПородаОтец;
	ПородаМать							= Параметры.ПородаМать; 	
	//Вставить содержимое обработчика    
	НоваяСтрока 						= ТЧДанные.Добавить();
	НоваяСтрока.ДатаСобытия				= ТекущаяДата();
	НоваяСтрока.НомерЖивотного 			= Параметры.НомерЖивотного;
	НоваяСтрока.Порода					= Параметры.Порода;
	НоваяСтрока.КоличествоПоросят 		= Параметры.КоличествоПоросят;
	НоваяСтрока.НомерФермы          	= Константы.НомерФермыDG.Получить();
	НоваяСтрока.СерийныйНомерСвинкиОт 	= Константы.СерийныйНомерСвинкиОт.Получить();
	НоваяСтрока.СерийныйНомерСвинкиДо 	= Константы.СерийныйНомерСвинкиОт.Получить() + Параметры.КоличествоПоросят - 1;
	Если ПородаОтец = Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") И ПородаМать
		= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") Тогда
		НоваяСтрока.Порода	= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22");
	ИначеЕсли ПородаОтец = Справочники.Порода.НайтиПоРеквизиту("КодПороды", "11") И ПородаМать
		= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") Тогда
		НоваяСтрока.Порода	= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "12");
	КонецЕсли;
	КодПородыИФермы = ПолучитьКодПородыИФермыНаСервере();
 
	//КодПородыНомерФермы					= Константы.НомерФермыDG.Получить()
	НоваяСтрока.НомерТатуОт             = СтрЗаменить(КодПородыИФермы + Строка(НоваяСтрока.СерийныйНомерСвинкиОт), " ",
		"");
	НоваяСтрока.НомерТатуДо             = СтрЗаменить(КодПородыИФермы + Строка(НоваяСтрока.СерийныйНомерСвинкиДо), " ",
		"");
	КоличествоПоросят					= Параметры.КоличествоПоросят;
	НомерЖивотногоОтец					= Параметры.Отец;
	НомерЖивотногоМать					= Параметры.Мать;
	ДатаРождения                        = Параметры.ДатаРождения;
	ДатаВвода							= Параметры.ДатаВвода;

	ЗаполнитьДанныеПлемСтадо(Параметры.Мать, ДатаВвода);
	Если Не ДанныеВБазе Тогда
		ЗаполнитьТЧДанныеНаКлиенте(НоваяСтрока.КоличествоПоросят, НоваяСтрока.СерийныйНомерСвинкиОт,
			НоваяСтрока.НомерЖивотного);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьКодПородыИФермыНаСервере()

	Перем КодПородыИФермы, ПрефиксПороды, ЧисловойКодПороды;
	ПрефиксПороды = "";
	ЧисловойКодПороды = "";

	Если ПородаОтец = Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") И ПородаМать
		= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") Тогда
		ПрефиксПороды = "Y";
		ЧисловойКодПороды = "120";
	ИначеЕсли ПородаОтец = Справочники.Порода.НайтиПоРеквизиту("КодПороды", "11") И ПородаМать
		= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") Тогда
		ПрефиксПороды = "L";
		ЧисловойКодПороды = "100";
	КонецЕсли;
	КодПородыИФермы = ПрефиксПороды + Константы.НомерФермыDG.Получить() + ЧисловойКодПороды;
	Возврат КодПородыИФермы;

КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеПлемСтадо(Знач Мать, Знач ДатаВвода)
	НаборЗаписей = РегистрыСведений.ПлемСтадо.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РодителиМать.Установить(Мать);
	НаборЗаписей.Отбор.РодителиДатаВвода.Установить(ДатаВвода);
	НаборЗаписей.Отбор.ДатаРождения.Установить(ДатаРождения);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 0 Тогда
		Для Каждого Стр Из НаборЗаписей Цикл
			НоваяСтрока	 					= ТЧТату.Добавить();
			НоваяСтрока.DGTagID 			= Стр.DGTagId;
			НоваяСтрока.Пол					= ПредопределенноеЗначение("Перечисление.Пол.Свинка");
			НоваяСтрока.УшнойВыщип 			= Прав(Строка(НомерЖивотногоМать), 2);
			НоваяСтрока.НомерЖивотногоОтец 	= Стр.РодителиОтец;
			НоваяСтрока.ПородаОтец          = Стр.РодителиОтецПорода;
			НоваяСтрока.НомерЖивотногоМать  = Стр.РодителиМать;
			НоваяСтрока.ПородаМать          = Стр.РодителиМатьПорода;
			НоваяСтрока.Порода              = Стр.КодПороды;
			НоваяСтрока.IDНомер				= Стр.IDНомер;
		КонецЦикла;
		ДанныеВБазе = Истина;
		ТЧДанные[0].КоличествоПоросят = НаборЗаписей.Количество();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТЧДанныеКоличествоПоросятПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.ТЧДанные.ТекущиеДанные;

	КоличествоПоросятDG 	= ТекущаяСтрока.КоличествоПоросят;
	КодПородыИФермы 		= ПолучитьКодПородыИФермыНаСервере();
	Если КоличествоПоросятDG > КоличествоПоросят Тогда
		КоличествоПоросятDG 			= КоличествоПоросят;
		ТекущаяСтрока.КоличествоПоросят = КоличествоПоросятDG;
		Сообщить("Максимальное количество поросят " + Строка(КоличествоПоросят));
	КонецЕсли;
	ТекущаяСтрока.СерийныйНомерСвинкиОт 	= ТекущаяСтрока.СерийныйНомерСвинкиОт;
	ТекущаяСтрока.СерийныйНомерСвинкиДо 	= ТекущаяСтрока.СерийныйНомерСвинкиОт + КоличествоПоросятDG - 1;
	ТекущаяСтрока.НомерТатуОт             = СтрЗаменить(КодПородыИФермы + Строка(ТекущаяСтрока.СерийныйНомерСвинкиОт),
		" ", "");
	ТекущаяСтрока.НомерТатуДо             = СтрЗаменить(КодПородыИФермы + Строка(ТекущаяСтрока.СерийныйНомерСвинкиДо),
		" ", "");

	Если Не ДанныеВБазе Тогда
		ЗаполнитьТЧДанныеНаКлиенте(КоличествоПоросятDG, ТекущаяСтрока.СерийныйНомерСвинкиОт,
			ТекущаяСтрока.НомерЖивотного);
	КонецЕсли;

КонецПроцедуры
&НаСервере
Процедура ЗаполнитьТЧДанныеНаКлиенте(Знач КоличествоПоросятDG, Знач СерийныйНомерСвинкиОт, Знач НомерЖивотного,
	Знач ПрефиксСвинки = "")

	Перем НоваяСтрока, Счетчик;

	ТЧТату.Очистить();
	КодПородыИФермы 		= ПолучитьКодПородыИФермыНаСервере();
	Если Не ЗначениеЗаполнено(КодПородыИФермы) Тогда
		КодПородыИФермы = ПрефиксСвинки;
	КонецЕсли;

	Для Счетчик = 1 По КоличествоПоросятDG Цикл
		НоваяСтрока	 					= ТЧТату.Добавить();
		Если ЗначениеЗаполнено(Константы.НомерФермыDG.Получить()) Тогда
			НоваяСтрока.DGTagID 			= СтрЗаменить(КодПородыИФермы + Строка(СерийныйНомерСвинкиОт + Счетчик - 1),
				" ", "");
		Иначе
			НоваяСтрока.IDНомер				= СтрЗаменить(КодПородыИФермы + Строка(СерийныйНомерСвинкиОт + Счетчик
				- 1), " ", "");
		КонецЕсли;
		НоваяСтрока.Пол					= ПредопределенноеЗначение("Перечисление.Пол.Свинка");
		Если Константы.УшнойВыщипИзНомераСвиноматки.Получить() Тогда
			НоваяСтрока.УшнойВыщип 			= Прав(Строка(НомерЖивотного), 2);
		КонецЕсли;
		НоваяСтрока.НомерЖивотногоОтец 	= НомерЖивотногоОтец;
		НоваяСтрока.ПородаОтец          = ПородаОтец;
		НоваяСтрока.НомерЖивотногоМать  = НомерЖивотногоМать;
		НоваяСтрока.ПородаМать          = ПородаМать;
		Если ПородаОтец = Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") И ПородаМать
			= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") Тогда
			НоваяСтрока.Порода	= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22");
		ИначеЕсли ПородаОтец = Справочники.Порода.НайтиПоРеквизиту("КодПороды", "11") И ПородаМать
			= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "22") Тогда
			НоваяСтрока.Порода	= Справочники.Порода.НайтиПоРеквизиту("КодПороды", "12");
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ПолучитьНомерФермыНаСервере()

	Возврат Константы.НомерФермыDG.Получить();

КонецФункции
&НаКлиенте
Процедура ЗаписатьДанные(Команда)
	ЗаписатьДанныеНаСервере();
КонецПроцедуры
&НаСервере
Процедура ЗаписатьДанныеНаСервере()
	НаборЗаписей = РегистрыСведений.ПлемСтадо.СоздатьНаборЗаписей();
	Для Каждого Стр Из ТЧТату Цикл
		НоваяСтрока = НаборЗаписей.Добавить();
		DGTagID = Справочники.IDНомер.НайтиПоНаименованию(Стр.DGTagId);
		Если DGTagID = Справочники.IDНомер.ПустаяСсылка() Тогда
			НовыйИД = Справочники.IDНомер.СоздатьЭлемент();
			НовыйИД.Наименование = Стр.DGTagId;
			НовыйИД.Записать();
			DGTagID = НовыйИД.Ссылка;
		КонецЕсли;
		IDНомер = Справочники.IDНомер.НайтиПоНаименованию(Стр.IDНомер);
		Если IDНомер = Справочники.IDНомер.ПустаяСсылка() Тогда
			НовыйИД = Справочники.IDНомер.СоздатьЭлемент();
			НовыйИД.Наименование = Стр.IDНомер;
			НовыйИД.Записать();
			IDНомер = НовыйИД.Ссылка;
		КонецЕсли;
		НоваяСтрока.DGTagId 			= DGTagId;
		НоваяСтрока.IDНомер				= IDНомер;
		НоваяСтрока.ДатаРождения    	= ДатаРождения;
		НоваяСтрока.РодителиМать		= НомерЖивотногоМать;
		НоваяСтрока.РодителиДатаВвода	= ДатаВвода;
		НоваяСтрока.РодителиМатьПорода  = Стр.ПородаМать;
		НоваяСтрока.РодителиОтец		= Стр.НомерЖивотногоОтец;
		НоваяСтрока.РодителиОтецПорода	= Стр.ПородаОтец;
		НоваяСтрока.КодПороды			= Стр.Порода;
		НоваяСтрока.Стадо				= Сред(DGTagId.Наименование, 2, 4);
		НоваяСтрока.УшнойВыщип			= Стр.УшнойВыщип;
	КонецЦикла;
	НаборЗаписей.Записать();
	Константы.СерийныйНомерСвинкиОт.Установить(ТЧДанные[0].СерийныйНомерСвинкиДо + 1);
КонецПроцедуры

&НаКлиенте
Процедура ТЧДанныеНомерТатуОтПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.ТЧДанные.ТекущиеДанные;
	КоличествоПоросятDG 	= ТекущаяСтрока.КоличествоПоросят;
	НомерСвинкиОт = ТолькоЧисла(ТекущаяСтрока.НомерТатуОт);
	ПрефиксСвинки = СтрЗаменить(ТекущаяСтрока.НомерТатуОт, НомерСвинкиОт, "");
	КодПородыИФермы = ПрефиксСвинки;

	ТекущаяСтрока.СерийныйНомерСвинкиОт 	= НомерСвинкиОт;
	ТекущаяСтрока.СерийныйНомерСвинкиДо 	= ТекущаяСтрока.СерийныйНомерСвинкиОт + КоличествоПоросятDG - 1;
	ТекущаяСтрока.НомерТатуОт             = СтрЗаменить(КодПородыИФермы + Строка(ТекущаяСтрока.СерийныйНомерСвинкиОт),
		" ", "");
	ТекущаяСтрока.НомерТатуДо             = СтрЗаменить(КодПородыИФермы + Строка(ТекущаяСтрока.СерийныйНомерСвинкиДо),
		" ", "");

	Если Не ДанныеВБазе Тогда
		ЗаполнитьТЧДанныеНаКлиенте(КоличествоПоросятDG, ТекущаяСтрока.СерийныйНомерСвинкиОт,
			ТекущаяСтрока.НомерЖивотного, ПрефиксСвинки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ТолькоЧисла(СтрокаРазличныеСимволы)

	УдаляемыеСимволы = СтрСоединить(СтрРазделить(СтрокаРазличныеСимволы, "0123456789", Ложь));
	Возврат СтрСоединить(СтрРазделить(СтрокаРазличныеСимволы, УдаляемыеСимволы, Ложь));

КонецФункции