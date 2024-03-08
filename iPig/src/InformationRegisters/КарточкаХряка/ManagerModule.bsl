Функция ПолучитьДанныеРодителей(НомерЖивотного, ДатаВвода) Экспорт
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КарточкаХряка.НомерЖивотногоОтец КАК НомерЖивотногоОтец,
	|	КарточкаХряка.НомерЖивотногоМать КАК НомерЖивотногоМать,
	|	КарточкаХряка.ДатаРождения КАК ДатаРождения,
	|	КарточкаХряка.КодПороды КАК КодПороды
	|ИЗ
	|	РегистрСведений.КарточкаХряка КАК КарточкаХряка
	|ГДЕ
	|	КарточкаХряка.НомерЖивотного = &НомерЖивотного
	|	И КарточкаХряка.Период = &ДатаВвода";

	Запрос.УстановитьПараметр("ДатаВвода", ДатаВвода);
	Запрос.УстановитьПараметр("НомерЖивотного", НомерЖивотного);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	ДанныеРодителей = Новый Структура;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДанныеРодителей.Вставить("Отец", ВыборкаДетальныеЗаписи.НомерЖивотногоОтец);
		ДанныеРодителей.Вставить("Мать", ВыборкаДетальныеЗаписи.НомерЖивотногоМать);
		ДанныеРодителей.Вставить("ДатаРождения", ВыборкаДетальныеЗаписи.ДатаРождения);
		ДанныеРодителей.Вставить("КодПороды", ВыборкаДетальныеЗаписи.КодПороды);
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	Возврат ДанныеРодителей;
КонецФункции