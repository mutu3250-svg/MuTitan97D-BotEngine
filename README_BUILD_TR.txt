MU Titan 97D BotEngine v1 - Derleme Yardimcisi

Bu paket EXE/DLL degil; Windows uzerinde derlemeyi tek tikla baslatan yardimci dosyalardir.

Gerekenler:
1) Windows 10/11
2) Visual Studio 2017/2019/2022 veya Build Tools
3) C++ Desktop Development is yuku
4) VC++ 2017 v141 toolset kurulu olmasi onerilir
5) Windows SDK

Kullanim:
1) MuTitan97D_BotEngine_v1_FULL_SOURCE.zip paketini bir klasore cikarin.
2) Bu yardimci dosyalari ayni ana klasore kopyalayin. Ana klasorde Source klasoru gorunmeli.
3) BUILD_ALL.bat calistirin.
4) Derleme basarili olursa ciktilar burada olusur:
   _build_output\GameServer.exe
   _build_output\Main.dll

GameServer-only paketinde:
- BUILD_GAMESERVER_ONLY.bat kullanin.
- Main.dll derlenmez, sadece GameServer.exe hedeflenir.

Canliya alma:
1) Calisan server/client yedegini alin.
2) _build_output\GameServer.exe dosyasini MuServer\GameServer icine kopyalayin.
3) _build_output\Main.dll dosyasini Client icine kopyalayin.
4) Oyuna girip once /bot komutu ile test edin.
5) F7 icin yeni Main.dll gerekir. Sadece GameServer.exe kopyalanirsa F7 calismayabilir; /bot komutu yine test amacli calisir.

Hata olursa:
- build_gameserver.log
- build_main.log
- Visual Studio Error List ekran goruntusu
bunlari gonderin; v1.1 patch hazirlariz.
