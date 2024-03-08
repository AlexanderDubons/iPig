
&НаСервере
Функция ОКНаСервере() 
	Константы.Организация.Установить(НаборКонстант.Организация);
	Константы.УНП.Установить(НаборКонстант.УНП);
	УНП = _НастройкиКонфигурацииНаСервере.ПолучитьКлючЛицензии(Ключ,Истина) ;  	
	
	Попытка
		Если _НастройкиКонфигурацииНаСервере.ПолучитьУНПНаСервере() = Число(УНП) И Ключ <> "" Тогда
			Константы.КлючЛицензии.Установить(Ключ); 
			Возврат Истина;
		Иначе
			СообщитьОбОшибкеНаСервере()
		КонецЕсли;  
	Исключение 
		СообщитьОбОшибкеНаСервере();		
	КонецПопытки;  
	
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура СообщитьОбОшибкеНаСервере()
	
	Перем Сообщение;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Ключ не действителен или не введен";
	Сообщение.Поле = "Ключ";
	Сообщение.УстановитьДанные(Ключ);
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда) 
	ОчиститьСообщения(); 
	РезультатВыполнения = ОКНаСервере(); 
	Записать();
	Если РезультатВыполнения Тогда 	    
    	Закрыть(ОКНаСервере()); 	    
	КонецЕсли;
КонецПроцедуры
