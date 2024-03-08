
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
			Запись.КодПороды	  = Реквизиты.КодПороды;
		КонецЕсли;
	Иначе
		Предупреждение("Свиноматки с таким номер нет");
	КонецЕсли;

КонецПроцедуры

