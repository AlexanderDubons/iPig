&НаКлиенте
Процедура ПериодОтбораПриИзменении(Элемент)
	Перем ЭлементыОтбора;

	Список.Отбор.Элементы.Очистить();
	ЭлементыГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ЭлементыГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ЭлементыГруппаОтбора.Использование = Истина;

	ЭлементыОтбора = ЭлементыГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементыОтбора.Использование 	= Не (ПериодОтбора.ДатаНачала = '00010101000000');
	ЭлементыОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Период");
	ЭлементыОтбора.ВидСравнения 	= ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементыОтбора.ПравоеЗначение   = ПериодОтбора.ДатаНачала;

	ЭлементыОтбора = ЭлементыГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементыОтбора.Использование 	= Не (ПериодОтбора.ДатаОкончания = '00010101000000');
	ЭлементыОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Период");
	ЭлементыОтбора.ВидСравнения 	= ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	ЭлементыОтбора.ПравоеЗначение   = ПериодОтбора.ДатаОкончания;

	КоличествоЗаписей = "Кол. осеменений: " + СписокВТЗнаСервере();

КонецПроцедуры

&НаСервере
Функция СписокВТЗнаСервере()
// реквизит1 - динамический список на форме
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки, , , Тип(
		"ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаРезультат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	МассивСсылок = ТаблицаРезультат.ВыгрузитьКолонку(0);  // выгружаем ссылки в массив для передачи клиенту
	Возврат массивСсылок.Количество();
КонецФункции
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	КоличествоЗаписей = "Кол. осеменений: " + СписокВТЗнаСервере();
КонецПроцедуры
&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	УдалениеНомерЖивотного 	= Элемент.ТекущиеДанные.НомерЖивотного;
	УдалениеДатаВвода		= Элемент.ТекущиеДанные.ДатаВвода;
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	_ОбработкаОповещенияНаКлиенте.ОткрытьФормуСвиноматки(УдалениеНомерЖивотного, УдалениеДатаВвода);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	МенюВыбора = Новый СписокЗначений;
	МенюВыбора.Добавить(0, "Открыть карточку аборта");
	МенюВыбора.Добавить(1, "Открыть карточку свиноматки");
	ВыбСтрокаМеню = ВыбратьИзМеню(МенюВыбора);
	Попытка
		Если ВыбСтрокаМеню.Значение = 1 Тогда
			СтандартнаяОбработка = Ложь;
			Попытка
				НомерЖивотного 	= Элемент.ТекущиеДанные.НомерЖивотного;
				ДатаВвода		= Элемент.ТекущиеДанные.ДатаВвода;
				ОткрытьФорму("РегистрСведений.КарточкаСвиноматки.Форма.ФормаЗаписи",
					Новый Структура("Ключ, ФормаОткрыта", _НастройкиКонфигурацииНаСервере.ПолучитьКлючЗаписи(
					НомерЖивотного, ДатаВвода), Ложь), , , , , , );
			Исключение 
				//Сообщить(Строка(Строка.НомерЖивотного)+"_"+ Строка.Период);
			КонецПопытки;
		КонецЕсли;
	Исключение
		СтандартнаяОбработка = Ложь;
	КонецПопытки;
КонецПроцедуры