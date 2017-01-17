## TDesktop-Fixer

Это маленькое приложение на [AutoHotKey](http://ahkscript.org/) решает одну маленькую, но очень неприятную [проблему](https://telegram.me/tglive/382) в Telegram Desktop: если в системе есть несколько копий TDesktop, то открытие t.me или telegram.me-ссылок в браузере часто приводит к переходу не к той копии приложения, в которой это нужно.

Решение: раз в минуту перезаписывать ветку реестра, указывая в ней нужный каталог.

Как работает приложение:  
1. Запускаете exe-файл (смотрите в разделе «Releases»).  
2. Появится окно с описанием и предложением выбрать каталог.  
3. Нажимаете на кнопку и выбираете папку с нужным экземпляром Telegram Desktop (программа сама проверит, есть ли внутри файл Telegram.exe).  
4. Если всё прошло успешно, вас об этом уведомят и утилита закроется.  
5. При следующем запуске не будет никаких уведомлений, но в трее появится иконка приложения. Теперь раз в минуту оно будет автоматически перезаписывать реестр. Путь к нужной копии также будет сохранён в ini-файле, который появится после первого запуска программы. Если нужно поменять расположение TDesktop, удалите ini-файл и перезапустите программу.  
6. Чтобы это работало постоянно, добавьте ярлык TDesktop-Fixer'а в автозагрузку.  

**Внимание**: некоторые антивирусы (2), а также Windows SmartScreen расценивают мою программу, как вирус ([отчёт на Virustotal](https://www.virustotal.com/en/file/f3bd98115992461c0b721cca959463f29d0f20a21addaea4ab630dc94d55fbcf/analysis/1484607278/)). Полагаю, это связано с тем, что она редактирует реестр. Если сомневаетесь – читайте исходники (140 строк, не так уж и много), собирайте сами через Autohotkey и применяйте. Или не запускайте в принципе.  
Также я **не гарантирую**, что утилита нормально заработает на всех версиях Windows в сочетании с любыми браузерами. 