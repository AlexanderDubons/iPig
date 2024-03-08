
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЗначениеЗаполнено(Запись.Период)  Тогда
		НаборЗаписей = РегистрыСведений.ЖурналОпороса.СоздатьНаборЗаписей(); 
        НаборЗаписей.Отбор.НомерЖивотного.Установить(Запись.НомерЖивотного); 
		НаборЗаписей.Отбор.НомерОпороса.Установить(Запись.НомерОпороса); 
		НаборЗаписей.Отбор.ДатаВвода.Установить(Запись.ДатаВвода);
        НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("НомерЖивотного") Тогда
		Запись.НомерЖивотного 	= Параметры.НомерЖивотного;
		Запись.НомерОпороса 	= Параметры.НомерОпороса;  
		Запись.ДатаВвода		= Параметры.ДатаВвода;
		Запись.КодПороды 		= Параметры.Порода;
	КонецЕсли; 
	Запись.Период = НачалоДня(Запись.Период);
КонецПроцедуры

&НаСервере
Процедура НомерЖивотногоПриИзмененииНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КарточкаВнесенияДанныхСрезПоследних.КодПороды КАК КодПороды
		|ИЗ
		|	РегистрСведений.КарточкаВнесенияДанных.СрезПоследних КАК КарточкаВнесенияДанныхСрезПоследних
		|ГДЕ
		|	КарточкаВнесенияДанныхСрезПоследних.НомерЖивотного = &НомерЖивотного";
	Запрос.УстановитьПараметр("НомерЖивотного", Запись.НомерЖивотного);	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Запись.КодПороды = ВыборкаДетальныеЗаписи.КодПороды;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НомерЖивотногоПриИзменении(Элемент)
	НомерЖивотногоПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НомерЖивотногоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеПоСвиноматкам = _НастройкиКонфигурацииНаСервере.ПолучитьСписокСвиноматок(ВыбранноеЗначение);
	Если ДанныеПоСвиноматкам.Количество() <> 0 Тогда
		ВыбСтрокаМеню = ВыбратьИзМеню(ДанныеПоСвиноматкам); 
		Если ВыбСтрокаМеню <> Неопределено Тогда 
			Реквизиты = ВыбСтрокаМеню.Значение;
			Запись.НомерЖивотного = Реквизиты.НомерЖивотного;
			Запись.ДатаВвода	  = Реквизиты.ДатаВвода;
		КонецЕсли;
	Иначе
		Предупреждение("Свиноматки с таким номер нет");
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ДатаАбортаПриИзменении(Элемент)
	Запись.Период = НачалоДня(Запись.Период);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	НомерЖивотного = Запись.НомерЖивотного;
	Период = Запись.ДатаВвода;
	Попытка
		ОткрытьФорму("РегистрСведений.КарточкаСвиноматки.Форма.ФормаЗаписи", Новый Структура("Ключ, ФормаОткрыта", _НастройкиКонфигурацииНаСервере.ПолучитьКлючЗаписи(НомерЖивотного, Период),Истина),,,,,,);
	Исключение 
		//Сообщить(Строка(Строка.НомерЖивотного)+"_"+ Строка.Период);
	КонецПопытки; 
КонецПроцедуры
