# Flutter TUS Feltöltő

Egy Proof of Concept (POC) Flutter alkalmazás, amely bemutatja a megbízható fájlfeltöltést a TUS (Folytatható Feltöltés) protokoll használatával.

## Jellemzők

- Fájl kiválasztása az eszköz tárhelyéről
- Fájl feltöltése TUS-kompatibilis szerverre
- Feltöltési folyamat megjelenítése
- Hálózati megszakítások kezelése

## Előfeltételek

- Flutter SDK
- Docker compose (a TUS szerver futtatásához) 
  - Docker Hub: [tusproject/tusd](https://hub.docker.com/r/tusproject/tusd/dockerfile)

## Setup

1. Klónozza a repository-t:
   ```
   git clone https://github.com/dioszedit/flutter-tus-uploader.git
   cd flutter-tus-uploader
   ```

2. Telepítse a függőségeket:
   ```
   flutter pub get
   ```

3. Docker compose segítségével indítsa el a TUS szervert:
   ```
   docker-compose up -d
   ```
4. Az adatok a `tus_data` mappában lesznek tárolva. A szervernek legyen hozzá írási jogosultsága.

5. Állítsa be a szerver URL-t `lib/services/tus_upload_service.dart` fájlban:
   ```
   // TUS Client url
   final String _tusClientUri = "https://your-host:1080/files/";
   ```

6. Futtassa a Flutter alkalmazást (támogatott eszközök a projektben: Android, iOS):
   ```
   flutter run
   ```

## Függőségek a projektben

- `tus_client_dart`: TUS protokoll kliens implementáció
- `file_picker`: Fájlok kiválasztásához az eszköz tárhelyéről
- `path_provider`: A fájlrendszerrel való munkához
- `url_launcher`: URL megnyitásához
- `cross_file`: Fájlokkal való munkához több platformon

## License
This project is open source and available under the [MIT License](LICENSE).
