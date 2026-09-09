# MU Titan 97D BotEngine v1 - GitHub Actions ile EXE/DLL Derleme

Bu paket GitHub'a yüklendiğinde Windows runner üzerinde otomatik derleme alır.

## Kullanım

1. GitHub'da yeni repository oluştur.
2. Bu paketin içindeki her şeyi repository kök dizinine yükle.
3. GitHub repository sayfasında **Actions** sekmesine gir.
4. Sol taraftan **Build MU Titan 97D BotEngine** workflow'unu seç.
5. **Run workflow** düğmesine bas.
6. Build tamamlanınca sayfanın altındaki **Artifacts** bölümünden şu çıktıyı indir:

```text
MuTitan97D-BotEngine-v1-Compiled
```

İçinde şunlar olur:

```text
GameServer.exe
Main.dll
build_gameserver.log
build_main.log
```

## Dosyaları nereye koyacaksın?

```text
GameServer.exe  -> MuServer\GameServer\ içine
Main.dll        -> Client klasörüne
```

## Test

Oyuna girdikten sonra önce komutla test et:

```text
/bot
```

Skill seçmek için örnek:

```text
/bot skill 41
```

F7 tuşu yeni Main.dll ile çalışır.

## Build hata verirse

Artifact oluşmazsa veya workflow kırmızı olursa, GitHub Actions loglarını veya şu dosyaları indirip ChatGPT'ye gönder:

```text
build_gameserver.log
build_main.log
```

Not: Proje Visual Studio v141 toolset kullanır. Workflow `windows-2019` üzerinde MSBuild ile Release Win32 build almaya ayarlanmıştır.
