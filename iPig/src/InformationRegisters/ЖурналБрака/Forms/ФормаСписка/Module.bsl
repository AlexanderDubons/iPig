
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	МенюВыбора = Новый СписокЗначений;
	МенюВыбора.Добавить(0,"Открыть карточку брака");
	МенюВыбора.Добавить(1,"Открыть карточку свиноматки");
	ВыбСтрокаМеню = ВыбратьИзМеню(МенюВыбора);  
	Попытка
		Если ВыбСтрокаМеню.Значение = 1 Тогда 
			СтандартнаяОбработка = Ложь;
			Попытка   
				НомерЖивотного 	= Элемент.ТекущиеДанные.НомерЖивотного;
				ДатаВвода		= Элемент.ТекущиеДанные.ДатаВвода;
				ОткрытьФорму("РегистрСведений.КарточкаСвиноматки.Форма.ФормаЗаписи", Новый Структура("Ключ, ФормаОткрыта", _НастройкиКонфигурацииНаСервере.ПолучитьКлючЗаписи(НомерЖивотного, ДатаВвода),Ложь),,,,,,);
			Исключение 
				//Сообщить(Строка(Строка.НомерЖивотного)+"_"+ Строка.Период);
			КонецПопытки;
		КонецЕсли   
	Исключение  
		СтандартнаяОбработка = Ложь;		
	КонецПопытки;
КонецПроцедуры
