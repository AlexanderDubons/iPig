&НаКлиенте
Процедура ТЧОпоросНомерЖивотногоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Запись = Элементы.ТЧОпорос.ТекущиеДанные;
	Запись.ДатаСобытия = ТекущаяДата();
	СтандартнаяОбработка = Ложь;
	ДанныеПоСвиноматкам = _НастройкиКонфигурацииНаСервере.ПолучитьСписокСвиноматок(ВыбранноеЗначение);
	Если ДанныеПоСвиноматкам.Количество() <> 0 Тогда
		Если ДанныеПоСвиноматкам.Количество() = 1 Тогда
			Запись.НомерЖивотного = ДанныеПоСвиноматкам[0].Значение.НомерЖивотного;
			Запись.ДатаВвода	  = ДанныеПоСвиноматкам[0].Значение.ДатаВвода;
			Запись.КодПороды	  = ДанныеПоСвиноматкам[0].Значение.КодПороды;
		Иначе
			ВыбСтрокаМеню = ВыбратьИзМеню(ДанныеПоСвиноматкам);
			Если ВыбСтрокаМеню <> Неопределено Тогда
				Реквизиты = ВыбСтрокаМеню.Значение;
				Запись.НомерЖивотного = Реквизиты.НомерЖивотного;
				Запись.ДатаВвода	  = Реквизиты.ДатаВвода;
				Запись.КодПороды	  = Реквизиты.КодПороды;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Предупреждение("Свиноматки с таким номер нет");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТЧОпоросМассаВсегоПриИзменении(Элемент)
	Запись = Элементы.ТЧОпорос.ТекущиеДанные;
	Если Запись.Живорожденные > КонстантаМаксимальноеКоличествоЖиворожденных() Тогда
		Предупреждение("Превышено максимальное количество живорожденных");
		Запись.Живорожденные = КонстантаМаксимальноеКоличествоЖиворожденных();
	КонецЕсли;
	Если Запись.Живорожденные <> 0 Тогда
		Запись.СреднийВес = Запись.МассаВсего / Запись.Живорожденные;
	КонецЕсли;
	Элементы.ТЧОпоросЖиворожденные.ТекстПодвала 	= ТЧСупоросность.Итог("Живорожденные");
	Элементы.ТЧОпоросМассаВсего.ТекстПодвала 		= ТЧСупоросность.Итог("МассаВсего");
	Элементы.ТЧОпоросСреднийВес.ТекстПодвала 		= ТЧСупоросность.Итог("СреднийВес");
	Элементы.ТЧОпоросМертвые.ТекстПодвала 			= ТЧСупоросность.Итог("Мертвые");
	Элементы.ТЧОпоросМуммии.ТекстПодвала 			= ТЧСупоросность.Итог("Муммии");
	Элементы.ТЧОпоросСлаборожденные.ТекстПодвала 	= ТЧСупоросность.Итог("Слаборожденные");
	Элементы.ТЧОпоросСвинки.ТекстПодвала 			= ТЧСупоросность.Итог("Свинки");
	Элементы.ТЧОпоросНомерЖивотного.ТекстПодвала 	= ТЧСупоросность.Количество();

КонецПроцедуры

&НаСервере
Функция КонстантаМаксимальноеКоличествоЖиворожденных()

	Возврат Константы.МаксимальноеКоличествоЖиворожденных.Получить();

КонецФункции

&НаКлиенте
Процедура ЗаписатьОпоросы(Команда)
	Для Каждого Запись Из ТЧСупоросность Цикл
		Попытка
			СоздатьЗаписиОпоросНаСервере(Запись.ДатаСобытия, Запись.НомерЖивотного, Запись.КодПороды, Запись.ДатаВвода,
				Запись.РезультатУЗИ, Запись.Работник, Запись.Место);
			_ОбработкаОповещенияНаКлиенте.ОткрытьФормуСвиноматки(Запись.НомерЖивотного, Запись.ДатаВвода);
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Данные внесены для свиноматки " + Запись.НомерЖивотного;
			Сообщение.Сообщить();
		Исключение
			Ошибка = ОписаниеОшибки();
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст =   "--------------------------------------" + Символы.ПС + "Данные не были внесены"
				+ Символы.ПС + Прав(Ошибка, СтрДлина(Ошибка) - СтрНайти(Ошибка, "}", НаправлениеПоиска.СКонца) - 2)
				+ Символы.ПС + "--------------------------------------";
			Сообщение.Сообщить();
		КонецПопытки;
	КонецЦикла;
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура СоздатьЗаписиОпоросНаСервере(ДатаОпороса, НомерЖивотного, КодПороды, ДатаВвода, РезультатУЗИ, Работник, Место)
	Перем Записи;

	Записи = РегистрыСведений.Супоросность.СоздатьМенеджерЗаписи();
	Записи.Период		  		= ДатаОпороса;
	Записи.НомерЖивотного 		= НомерЖивотного; 
	//Записи.КодПороды			= КодПороды;
	Записи.ДатаВвода	  		= ДатаВвода;  //Дописать  
	Записи.РезультатУЗИ         = РезультатУЗИ;
	Записи.Работник				= Работник;
	Записи.Место				= Место;
	Записи.Записать();
КонецПроцедуры