
Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр ДвижениеМедикаментов Приход
	Движения.ДвижениеМедикаментов.Записывать = Истина;
	Для Каждого ТекСтрокаТЧПоступление Из ТЧПоступление Цикл
		Движение = Движения.ДвижениеМедикаментов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Медикаменты = ТекСтрокаТЧПоступление.Медикаменты;
		Движение.СрокГодности = ТекСтрокаТЧПоступление.СрокГодности;
		Движение.РегистрационныйНомер = ТекСтрокаТЧПоступление.РегистрационныйНомер;
		Движение.СерияПоставки = ТекСтрокаТЧПоступление.СерияПоставки;
		Движение.Количество = ТекСтрокаТЧПоступление.Количество;
		Движение.Сумма = ТекСтрокаТЧПоступление.Сумма;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры
