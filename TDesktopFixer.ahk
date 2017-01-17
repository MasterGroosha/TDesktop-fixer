#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force ; При запуске нового экземпляра старый будет убит автоматически.


ShowHelp()
{
	Gui, New, 2  ; Создаём GUI
	Gui, 2:Font, s10, Verdana  ; Verdana, 10-й кегль
	Gui, 2:Add, Link, +Wrap Center W480, Telegram Desktop Fixer v1.0`nАвтор: @Groosha, 2017г.`n`nЭтот Fixer, будучи запущенным, заставляет открывать t.me и telegram.me ссылки в нужном приложении.`nПодробнее: <a href="https://t.me/tglive/382">t.me/tglive/382</a>`n`nЧтобы сменить каталог, удалите файл конфигурации, который лежит рядом с файлом программы.
	Gui, 2:Add, Button, X220 Y150 gbtnOK, OK
	Gui, 2:Show, W500 H200, Telegram Desktop Fixer - Справка
	WinActivate , Telegram Desktop Fixer - Справка
	; WinWait , Telegram Desktop Fixer - Help
	Return
	
	btnOK:
	Gui, Destroy ; Убираем окно
	Return
}


; Делаем трей и обработку нажатий на пункты в нём.
AddMenu()
{
#Persistent
Menu, Tray, NoStandard ; Убираем стандартные кнопки, доставшиеся от AHK
Menu, Tray, Add ,Справка, ButtonHelp
Menu, Tray, Add ,Выход, ButtonExit
Return

ButtonHelp:
ShowHelp()
Return

ButtonExit:
ExitApp 0
Return
}


FindFile()
; Функция ищет файл Telegram.exe. Если в папке его нет, надо выбрать каталог заново.
; Если есть, пишем в реестр и в конфиг. В следующий раз GUI не нужен будет.
{
	FileSelectFolder, Folder ; Показываем диалог
	if (Folder = "")
		{
			MsgBox, Выбран неправильный путь. Перезапустите приложение!
			IniWrite, ERROR, TDFixerConfig.ini, Default, Path
			ExitApp 0
		}
	else
		{
			tg_found := 0
			
			Loop Files, %Folder%\*.exe
				{
					; Смотрим, есть ли файл Telegram.exe в каталоге
					if (A_LoopFileName = "Telegram.exe")
					{
						tg_found := 1
						Break
					}
				}
			if (tg_found = 0)
			{
				MsgBox, В этом каталоге нет файла Telegram.exe. Пожалуйста, выберите правильный каталог!
				; Рекурсивно просим ещё раз найти файл
				FindFile()
				Return
			}
			else
			{
				; Преобразуем путь в нужный формат и пишем в реестр + в конфиг
				String := RegExReplace(Folder, "\\", "/") ; Путь с обратными слешами
				String2 := Format("""{1}\Telegram.exe"" -workdir ""{2}"" -- ""%1""", Folder, String)
				RegWrite, REG_SZ, HKEY_CURRENT_USER, SOFTWARE\Classes\tg\shell\open\command,, %String2%
				IniWrite, %Folder%, TDFixerConfig.ini, Default, Path
				MsgBox, Успешно установлен путь: %Folder%. Не забудьте поставить приложение в автозагрузку.
				ExitApp 0
			}
		}
	Return
}
	

; Функция показа диалога и записи значения в реестр/файл конфига
MainGui()
{
	Gui, New, 1  ; Создаём GUI
	Gui, 1:Font, s10, Verdana  ; Verdana, 10-й кегль
	Gui, 1:Add, Link, +Wrap Center W480, Это приложение позволяет исправить открытие t.me и telegram.me-ссылок не в том экземпляре Telegram Desktop, постоянно редактируя реестр.`nПожалуйста, воспользуйтесь кнопкой ниже, чтобы выбрать каталог с нужной копией TDesktop. Не забудьте после этого поставить ярлык приложения в автозагрузку!`nПодробнее: <a href="https://t.me/tglive/382">t.me/tglive/382</a>
	Gui, 1:Add, Button, X180 Y150 gchooseFolder, Выбрать каталог
	Gui, 1:Add, Link, gHelp X215 Y180, <a href="">Справка</a>
	Gui, 1:Show, W500 H210, Telegram Desktop Fixer
	WinActivate , Telegram Desktop Fixer
	WinWait , Telegram Desktop Fixer
	WinWaitClose, Telegram Desktop Fixer
	ExitApp
	Return
	
	; Окошко «Справка» по нажатию на ссылку
	Help:
	ShowHelp()
	Return
	
	chooseFolder:
	FindFile()
	Return
}


; Проверим наличие файла, если есть, читаем содержимое и пишем в реестр, потом выходим
IniRead, config_path, TDFixerConfig.ini, Default, Path, ERROR ; Если нет файла, то в config_path будет "ERROR"
if (config_path = "ERROR") ; Файла нет, надо показать GUI
{
	FileAppend,, TDFixerConfig.ini ; Создаём файл
	IniWrite, ERROR, TDFixerConfig.ini, Default, Path ; Ставим заглушку
	AddMenu()
	MainGui()
}
else 
{	
	; Добавляем меню в трее
	AddMenu()
	; Каждую минуту обновляем значение в реестре
	Loop,
	{
		backslash_path := RegExReplace(config_path, "\\", "/") ; Путь с обратными слешами
		path_to_write := Format("""{1}\Telegram.exe"" -workdir ""{2}"" -- ""%1""", config_path, backslash_path)
		RegWrite, REG_SZ, HKEY_CURRENT_USER, SOFTWARE\Classes\tg\shell\open\command,, %path_to_write%
		Sleep, 60000 ; Пауза между повторными записями (60 сек)
	}
	ExitApp 0
}
