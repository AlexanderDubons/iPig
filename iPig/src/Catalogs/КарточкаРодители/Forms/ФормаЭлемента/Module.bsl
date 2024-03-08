&НаСервере
Процедура IDНомерПриИзмененииНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КарточкаВнесенияДанных.НомерЖивотного КАК НомерЖивотного,
	|	КарточкаВнесенияДанных.ДатаРождения КАК ДатаРождения,
	|	КарточкаВнесенияДанных.Пол КАК Пол,
	|	КарточкаВнесенияДанных.КодПороды КАК КодПороды,
	|	КарточкаВнесенияДанных.Период КАК Период,
	|	КарточкаВнесенияДанных.РодителиОтец КАК РодителиОтец,
	|	КарточкаВнесенияДанных.РодителиМать КАК РодителиМать
	|ИЗ
	|	РегистрСведений.КарточкаВнесенияДанных КАК КарточкаВнесенияДанных
	|ГДЕ
	|	КарточкаВнесенияДанных.НомерЖивотного = &НомерЖивотного";

	Запрос.УстановитьПараметр("НомерЖивотного", Объект.НомерЖивотного);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Объект.ДатаВвода = ВыборкаДетальныеЗаписи.Период;
		Объект.ДатаРождения = ВыборкаДетальныеЗаписи.ДатаРождения;
		Объект.Пол = ВыборкаДетальныеЗаписи.Пол;
		Объект.КодПороды = ВыборкаДетальныеЗаписи.КодПороды;
		Объект.НомерЖивотногоОтец = ВыборкаДетальныеЗаписи.РодителиОтец;
		Объект.НомерЖивотногоМать = ВыборкаДетальныеЗаписи.РодителиМать;
	КонецЦикла;

	Объект.Наименование = Объект.НомерЖивотного;
КонецПроцедуры

&НаКлиенте
Процедура IDНомерПриИзменении(Элемент)
	IDНомерПриИзмененииНаСервере();
КонецПроцедуры
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//Вставить содержимое обработчика
КонецПроцедуры
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
КонецПроцедуры