MU Titan 97D - BotEngine v1
===========================

Bu paket, MuEmu-0.97k-kayito kaynak koduna ilk Auto Attack altyapısını ekler.

Eklenenler
----------
1) GameServer tarafı
   - BotManager.h
   - BotManager.cpp
   - GameServer.vcxproj ve filters dosyasına BotManager eklendi.
   - QueueTimer.h içine QUEUE_TIMER_BOT eklendi.
   - GameServer.cpp içinde 200 ms Bot timer başlatıldı.
   - GameMain.cpp içinde Bot timer callback'i eklendi.
   - Protocol.cpp içinde C1:FB:A7 bot toggle paketi eklendi.
   - Protocol.cpp içinde /bot ve /auto chat komutları yakalandı.
   - SkillManager.cpp manuel kullanılan son skill'i bot state içine kaydediyor.

2) Client/Main tarafı
   - Controller.cpp içinde F7 tuşu bot toggle paketi gönderir.
   - Protocol.h içine PMSG_BOT_TOGGLE_SEND eklendi.
   - Protocol.cpp içine CGBotToggleSend eklendi.

Kullanım
--------
1) Önce Source/MuServer/MuServer_Ex097.sln dosyasını aç.
2) GameServer projesini Rebuild et.
3) Sonra Source/Client/Client.sln dosyasını aç.
4) Main projesini Rebuild et.
5) Yeni Main.dll'i client içine koy.
6) Yeni GameServer.exe'yi server içine koy.

Oyun içi kullanım
-----------------
- F7: Auto Attack aç/kapat.
- /bot: Auto Attack aç/kapat. Client patch olmadan da test etmek için eklendi.
- /bot on: açar.
- /bot off: kapatır.
- /bot skill 41: kullanılacak skill'i Twisting Slash yapar.
- /bot range 8: arama mesafesini 8 yapar.

Skill notu
----------
F7 basıldığında client mevcut CurrentSkill değerini server'a yollar.
Ayrıca oyuncu manuel skill kullandığında GameServer bu skill'i BotEngine içine kaydeder.
Skill yoksa veya mana/BP/weapon/class şartı uygun değilse bot normal saldırıya düşer.

Sprint v1 kapsamı
-----------------
- F7 aç/kapat
- GameServer tick entegrasyonu
- En yakın monster arama
- Hedef seçme
- Hedef kaybolursa yeni hedef bulma
- Seçili skill ile saldırma denemesi
- Safe zone'da çalışmama
- Player/NPC hedef almama

Bilinçli olarak eklenmeyenler
-----------------------------
- Auto movement/yaklaşma yok. Hedef skill/attack range dışındaysa hedef bırakılır.
- Loot yok.
- Potion yok.
- Party bot yok.
- Offline bot yok.

Test sırası
-----------
1) Serverı aç.
2) Client ile gir.
3) Lorencia'da monster yanına git.
4) Önce /bot ile test et.
5) Sonra F7 ile test et.
6) Skill için önce skill seç ya da /bot skill 41 komutunu kullan.

Önemli
------
Bu paket kaynak kod patch'idir. Bu ortamda Visual Studio ile derleme yapamadığım için EXE/DLL derlenmiş olarak verilmedi.
