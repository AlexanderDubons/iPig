Процедура ПриЗаписи(Отказ, Замещение)

	ЗаписатьПоследнееСобытиеВРегистр();
КонецПроцедуры

Процедура ЗаписатьПоследнееСобытиеВРегистр()

	Перем Запись, ЗаписьСтатус, НаборЗаписей;

	Для Каждого Запись Из ЭтотОбъект Цикл

		НаборЗаписей = РегистрыСведений.ПоследнееСобытие.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДатаВвода.Установить(Запись.ДатаВвода);
		НаборЗаписей.Отбор.НомерЖивотного.Установить(Запись.НомерЖивотного);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 0 Тогда
			ЗаписьСтатус = РегистрыСведений.ПоследнееСобытие.СоздатьМенеджерЗаписи();
			ЗаписьСтатус.ДатаВвода 				= Запись.ДатаВвода;
			ЗаписьСтатус.НомерЖивотного 		= Запись.НомерЖивотного;
			ЗаписьСтатус.ДатаПоследнегоСобытия 	=  Запись.Период;
			ЗаписьСтатус.ПоследнееСобытие 		= Перечисления.ПоследнееСобытие.Случка;
			ЗаписьСтатус.УшнойВыщип				= Запись.УшнойВыщип;
			ЗаписьСтатус.НомерЖивотногоХряк	 	= Запись.НомерЖивотногоХряк;
			ЗаписьСтатус.НомерОпороса     		= Запись.НомерОпороса;
			ЗаписьСтатус.Записать(Истина);
		Иначе
			Для Каждого ЗаписьСтатус Из НаборЗаписей Цикл
				Если (Запись.НомерОпороса >= ЗаписьСтатус.НомерОпороса) И (Запись.Период
					> ЗаписьСтатус.ДатаПоследнегоСобытия) Тогда
					ЗаписьСтатус.ДатаВвода 				= Запись.ДатаВвода;
					ЗаписьСтатус.НомерЖивотного 		= Запись.НомерЖивотного;
					ЗаписьСтатус.ДатаПоследнегоСобытия 	= Запись.Период;
					ЗаписьСтатус.ПоследнееСобытие 		= Перечисления.ПоследнееСобытие.Случка;
					ЗаписьСтатус.НомерЖивотногоХряк	 	= Запись.НомерЖивотногоХряк;
					ЗаписьСтатус.УшнойВыщип				= Запись.УшнойВыщип;
					ЗаписьСтатус.НомерОпороса    		= Запись.НомерОпороса;
				КонецЕсли;
			КонецЦикла;
			НаборЗаписей.Записать(Истина);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	Для Каждого Запись Из ЭтотОбъект Цикл
		НаборЗаписей = РегистрыСведений.ПоследнееСобытие.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДатаВвода.Установить(Запись.ДатаВвода);
		НаборЗаписей.Отбор.НомерЖивотного.Установить(Запись.НомерЖивотного);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 1 Тогда
			Если НаборЗаписей[0].ПоследнееСобытие = Перечисления.ПоследнееСобытие.Случка
				И НаборЗаписей[0].ДатаПоследнегоСобытия >= Запись.Период И Запись.НомерОпороса = 0 Тогда
				Сообщить("Для свиноматки " + Запись.НомерЖивотного + " Дата случки должна быть больше " + Формат(
					НаборЗаписей[0].ДатаПоследнегоСобытия, "ДФ=dd.MM.yy"));
				Если Не Константы.ОтключитьКонтрольОшибок.Получить() Тогда
					Отказ = Истина;
					ВызватьИсключение ("Для свиноматки " + Запись.НомерЖивотного + " Дата случки должна быть больше "
						+ Формат(НаборЗаписей[0].ДатаПоследнегоСобытия, "ДФ=dd.MM.yy"));
				КонецЕсли;
			ИначеЕсли НаборЗаписей[0].ПоследнееСобытие = Перечисления.ПоследнееСобытие.Опорос И Запись.НомерОпороса = 0 Тогда
				Сообщить("Для свиноматки " + Запись.НомерЖивотного + " не внесен отъем.");
				Если Не Константы.ОтключитьКонтрольОшибок.Получить() Тогда
					Отказ = Истина;
					ВызватьИсключение ("Для свиноматки " + Запись.НомерЖивотного + " не внесен отъем.");
				КонецЕсли;
			ИначеЕсли НаборЗаписей[0].ПоследнееСобытие = Перечисления.ПоследнееСобытие.Отъем И (Запись.НомерОпороса = 0
				Или НаборЗаписей[0].НомерОпороса < Запись.НомерОпороса) И (НаборЗаписей[0].ДатаПоследнегоСобытия
				>= Запись.Период) Тогда
				Сообщить("Для свиноматки " + Запись.НомерЖивотного + " Дата случки должна быть больше " + Формат(
					НаборЗаписей[0].ДатаПоследнегоСобытия, "ДФ=dd.MM.yy"));
				Если Не Константы.ОтключитьКонтрольОшибок.Получить() Тогда
					Отказ = Истина;
					ВызватьИсключение ("Для свиноматки " + Запись.НомерЖивотного + " Дата случки должна быть больше "
						+ Формат(НаборЗаписей[0].ДатаПоследнегоСобытия, "ДФ=dd.MM.yy"));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры