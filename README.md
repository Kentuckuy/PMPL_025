# NOTE FATHURRAHMAN — Aplikasi Catatan Multiplatform

Repositori ini berisi tugas dan praktikum mata kuliah **Pemrograman Multi Platform Lanjutan (IT312)**. Project dibuat dengan Flutter dan Dart. Versi utama di branch `main` adalah aplikasi catatan dengan autentikasi Firebase, penyimpanan Cloud Firestore, dan contoh integrasi fitur native Android melalui Platform Channel.

Dokumentasi ini mencatat fitur yang benar-benar tersedia di source code dan branch praktikum. Saat ada materi, fitur, atau perubahan cara menjalankan aplikasi yang baru, bagian terkait di README ini perlu ikut diperbarui.

## Status dan Materi Pertemuan

| Pertemuan | Materi | Implementasi yang tersedia | Arsip |
|---|---|---|---|
| 1 | Dart asynchronous: `Future`, `async`/`await`, dan `Stream` | Simulasi proses sinkron/asinkron dan aliran data dengan `StreamBuilder` | [Branch pertemuan-1](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-1) |
| 2 | REST API, Dio, state UI, dan pagination | Mengambil daftar post dari JSONPlaceholder, menangani loading/error/empty, serta infinite scroll | [Branch pertemuan-2](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-2) |
| 3 | Provider, pemisahan state, dan REST API Reqres | Login demo, `MultiProvider`, model pengguna, dan pemuatan daftar pengguna | [Branch pertemuan-3](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-3) |
| 4 | Firebase Authentication dan state autentikasi | Register, login, logout, `authStateChanges()`, serta pemetaan error Firebase | [Branch pertemuan-4](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-4) |
| 6 | Cloud Firestore realtime | CRUD catatan dan pembaruan daftar melalui snapshot stream | [Branch pertemuan-6](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-6) |
| 9 | Pengujian Flutter | Unit test, widget test, serta pengujian dengan fake service dan mock platform channel | [Branch pertemuan-9](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-9) |
| 10 | Platform Channel | Komunikasi Flutter–Android untuk membaca baterai dan menampilkan Toast native | [Branch pertemuan-10](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-10) |
| 11 | Build & Deploy Android | Ikon aplikasi, versioning, signing keystore, build APK/AAB, dan instalasi release | [Branch pertemuan-11](https://github.com/Kentuckuy/PMPL_025/tree/pertemuan-11) |

Tabel di atas hanya mencantumkan materi yang memiliki implementasi atau arsip branch di repositori ini. Materi pertemuan lain dapat ditambahkan setelah kode atau dokumentasinya tersedia.

## Gambaran Aplikasi Saat Ini

Branch `main` menggabungkan aplikasi catatan dan materi praktikum sebelumnya.

- **Nama aplikasi Android:** `NOTE FATHURRAHMAN`.
- **Autentikasi:** pengguna dapat membuat akun, masuk, dan keluar menggunakan email dan kata sandi Firebase Authentication.
- **Navigasi autentikasi:** status sesi dipantau melalui `authStateChanges()`. Pengguna yang belum masuk melihat halaman login; setelah masuk, aplikasi menampilkan halaman catatan.
- **Catatan:** pengguna dapat menambah, mengubah, dan menghapus catatan. Daftar diperbarui secara realtime dari Cloud Firestore dan diurutkan berdasarkan waktu terbaru.
- **Platform Channel Android:** demo dapat dibuka dari halaman login atau dari halaman catatan. Demo membaca tingkat baterai dan mengirim pesan Toast dari Flutter ke Android.
- **Materi API:** implementasi Dio, model pengguna, dan `DataProvider` dari praktikum REST API tetap tersedia sebagai materi pembelajaran. Alur utama branch `main` saat ini berfokus pada autentikasi dan catatan.

### Catatan data dan Firebase

- Catatan disimpan pada koleksi Firestore `notes`, dengan field `title`, `content`, dan `createdAt`.
- Implementasi saat ini belum menyimpan ID pemilik pada setiap catatan. Karena itu, catatan belum dipisahkan per akun; akses aktual bergantung pada Firestore Security Rules yang dipasang di project Firebase.
- Aktifkan metode **Email/Password** di Firebase Authentication dan buat database Firestore sebelum menjalankan fitur terkait.
- Atur Firestore Security Rules sesuai kebutuhan aplikasi dan wajibkan autentikasi untuk data pengguna. Jangan menggunakan aturan terbuka untuk deployment publik.
- Konfigurasi Firebase platform berada di `lib/firebase_options.dart` dan `android/app/google-services.json`. Jika memakai project Firebase lain, buat ulang konfigurasi untuk project tersebut.
- Bootstrap aplikasi mengatur `appVerificationDisabledForTesting`. Tinjau pengaturan ini sebelum penggunaan produksi.

## Teknologi dan Struktur Kode

- **Framework:** Flutter
- **Bahasa:** Dart
- **State management:** Provider
- **Autentikasi dan database:** Firebase Authentication dan Cloud Firestore
- **HTTP client untuk materi API:** Dio
- **Platform native:** Android Kotlin dan Flutter `MethodChannel`

```text
lib/
├── main.dart                         # Inisialisasi Firebase, provider, dan auth gating
├── firebase_options.dart             # Konfigurasi Firebase untuk platform Flutter
├── models/
│   ├── note_model.dart               # Model catatan Firestore
│   └── user_model.dart               # Model pengguna API
├── providers/
│   ├── auth_provider.dart            # State sesi autentikasi
│   ├── data_provider.dart            # State data API latihan
│   └── notes_provider.dart           # Stream dan operasi catatan
├── repositories/
│   └── auth_repository.dart          # Abstraksi alur autentikasi
├── screens/
│   ├── home_screen.dart              # Daftar catatan dan navigasi fitur
│   ├── login_screen.dart             # Form login dan registrasi
│   ├── note_editor_dialog.dart       # Dialog tambah/edit catatan
│   └── platform_channel_screen.dart  # Demo fitur native Android
├── services/
│   ├── api_service.dart              # Klien Dio untuk API Reqres
│   ├── auth_service.dart             # Layanan Firebase Authentication
│   ├── firestore_service.dart        # Operasi Cloud Firestore
│   └── platform_channel_service.dart # Pemanggilan MethodChannel
├── theme/
│   └── app_theme.dart                # Tema visual aplikasi
└── validators/
    └── auth_validator.dart           # Validasi email dan kata sandi

android/app/src/main/kotlin/           # Implementasi native Android
web/                                   # Konfigurasi aplikasi web/PWA
test/                                  # Unit test dan widget test
```

## Prasyarat

- Flutter SDK **3.47.4 atau lebih baru** dan Dart SDK **3.13.3 atau kompatibel**.
- Android Studio beserta Android SDK untuk menjalankan aplikasi di emulator atau perangkat Android.
- Google Chrome atau Microsoft Edge untuk menjalankan aplikasi web.
- Akses internet untuk mengakses Firebase dan API eksternal.

Periksa instalasi Flutter dan Android dengan:

```powershell
flutter doctor -v
```

## Menjalankan Aplikasi

Jalankan perintah dari folder utama repositori.

### Persiapan

```powershell
flutter pub get
```

### Web

```powershell
flutter run -d chrome --web-port 8080
```

Buka `http://localhost:8080` di browser pada komputer yang menjalankan aplikasi.

### Android

Hubungkan perangkat dengan USB debugging aktif atau nyalakan emulator. Lihat ID perangkat, lalu jalankan aplikasi:

```powershell
flutter devices
flutter run -d ID_PERANGKAT
```

Ganti `ID_PERANGKAT` dengan ID Android yang ditampilkan Flutter. Fitur Platform Channel hanya tersedia pada Android, bukan web.

### Membuat APK Android

```powershell
flutter analyze
flutter build apk --release
```

APK hasil build berada di:

```text
build\app\outputs\flutter-apk\app-release.apk
```

### Pertemuan 11 — Build & Deploy Android

Implementasi praktikum ini menaikkan versi menjadi `1.0.1+2` (`versionName` `1.0.1`, `versionCode` `2`), menambahkan ikon Android dari `assets/icon/icon.png`, dan mengatur signing release dari `android/key.properties` jika berkas tersebut tersedia.

Identitas Android `com.example.pertemuan_1` sengaja dipertahankan: `namespace`, `applicationId`, package `MainActivity.kt`, dan registrasi di `google-services.json` saat ini saling cocok. Jika identitas aplikasi diganti, daftarkan package baru di Firebase dan perbarui keempat konfigurasi tersebut bersama-sama.

#### Ikon aplikasi

Untuk membuat ulang ikon native Android setelah mengubah aset:

```powershell
dart run flutter_launcher_icons
```

Konfigurasi generator ada di `pubspec.yaml`. Ikon sumber berbentuk PNG persegi dan hasilnya disimpan pada resource launcher Android. Bila ikon lama masih terlihat di perangkat, hapus pemasangan aplikasi lalu pasang ulang agar cache launcher dibersihkan.

#### Signing keystore

Keystore adalah kunci privat untuk menandatangani aplikasi. Buat satu kali di PowerShell, simpan di luar repositori, dan amankan salinan cadangannya:

```powershell
keytool -genkey -v -keystore "$env:USERPROFILE\upload-keystore.jks" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Buat `android/key.properties` secara lokal (jangan commit) dengan isi berikut, lalu ganti nilai contoh dan path sesuai keystore:

```properties
storePassword=password-keystore
keyPassword=password-kunci
keyAlias=upload
storeFile=C:/Users/NamaAnda/upload-keystore.jks
```

Gradle memuat konfigurasi itu untuk signing release. `android/.gitignore` sudah mengecualikan `key.properties`, `*.jks`, dan `*.keystore`. Tanpa `key.properties`, build release memakai debug signing hanya untuk pengujian lokal dan menampilkan peringatan; jangan unggah atau bagikan artefak tersebut. Kehilangan keystore produksi dapat menghalangi pembaruan aplikasi yang sama.

#### Build, instal, dan distribusi

```powershell
flutter build apk --release
flutter build apk --release --split-per-abi
flutter build appbundle --release
flutter install --release
```

- APK universal untuk pengujian/perangkat: `build\app\outputs\flutter-apk\app-release.apk`.
- APK terpisah per arsitektur: `build\app\outputs\flutter-apk\app-<abi>-release.apk`.
- App Bundle untuk Google Play: `build\app\outputs\bundle\release\app-release.aab`.

Hubungkan emulator atau perangkat Android sebelum menjalankan `flutter install --release`. Periksa ikon dan aplikasi setelah terpasang. Untuk setiap unggahan baru, naikkan angka setelah `+` pada `version` di `pubspec.yaml`. Google Play menggunakan AAB; alur praktik yang disarankan adalah membuat aplikasi dan listing, unggah AAB ke Internal Testing, lalu promosikan ke Production setelah peninjauan.

Aplikasi yang terpasang tetap memerlukan internet untuk autentikasi dan sinkronisasi Firestore. Untuk distribusi publik, pastikan build ditandatangani dengan keystore rilis yang benar dan jangan gunakan fallback debug signing.

## Pengujian dan Analisis

Jalankan seluruh test:

```powershell
flutter test
```

Jalankan test tertentu, misalnya test dialog catatan:

```powershell
flutter test test\widget\note_editor_dialog_test.dart
```

Periksa analisis dan lint Dart:

```powershell
flutter analyze
```

Buat laporan coverage:

```powershell
flutter test --coverage
```

Test yang tersedia mencakup validasi autentikasi, repository/provider, model pengguna, widget login, widget dialog catatan, layar Platform Channel, dan layanan channel dengan mock.

## Platform Web dan Android

- Web dapat dijalankan di browser dan memiliki konfigurasi PWA di `web/manifest.json`.
- Platform Channel pada `android/app/src/main/kotlin/com/example/pertemuan_1/MainActivity.kt` menggunakan channel `com.example.app/battery`.
- Perubahan pada kode Kotlin native memerlukan penghentian dan peluncuran ulang aplikasi; hot reload tidak memuat ulang implementasi native.
- Web tidak menyediakan channel native Android untuk membaca baterai atau menampilkan Toast.

## Pembaruan README

Setiap penambahan materi atau perubahan fitur perlu disertai pembaruan pada bagian yang relevan di README ini:

1. Tambahkan atau perbarui baris materi dan status pada tabel pertemuan.
2. Jelaskan perilaku fitur dan batasannya berdasarkan implementasi aktual.
3. Perbarui struktur kode, prasyarat, konfigurasi, dan instruksi menjalankan aplikasi bila berubah.
4. Tambahkan atau perbarui instruksi test jika cakupan pengujian bertambah.
5. Tautkan branch arsip yang benar; jangan menandai materi selesai sebelum implementasi tersedia.

README ini menjelaskan kondisi branch `main`; branch pertemuan digunakan sebagai arsip snapshot praktikum.
