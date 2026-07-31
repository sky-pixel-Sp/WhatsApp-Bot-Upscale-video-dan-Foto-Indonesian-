# Setup di Windows (CMD / PowerShell)

Kode bot-nya SAMA PERSIS dengan versi Termux (`index.js`) — udah dibikin cross-platform dari awal, jadi nggak perlu file terpisah. Yang beda cuma cara install dependency sistemnya.

## 1. Install Node.js
Download dari https://nodejs.org (pilih versi LTS), lalu install seperti biasa.

Cek di PowerShell/CMD:
```powershell
node --version
```

## 2. Install Python (dibutuhin yt-dlp)
Download dari https://www.python.org/downloads/ — **centang "Add Python to PATH"** waktu instalasi.

## 3. Install ffmpeg
Paling gampang pakai winget (udah ada bawaan Windows 10/11):
```powershell
winget install ffmpeg
```
Atau kalau punya Chocolatey:
```powershell
choco install ffmpeg
```
Atau manual: download build dari https://www.gyan.dev/ffmpeg/builds/ (pilih "release essentials"), ekstrak, lalu tambahkan folder `bin`-nya ke PATH (Settings → System → About → Advanced system settings → Environment Variables → Path → tambah path ke `ffmpeg\bin`).

Cek:
```powershell
ffmpeg -version
ffprobe -version
```

## 4. Install yt-dlp
```powershell
pip install -U yt-dlp
```
Cek:
```powershell
yt-dlp --version
```

## 5. Install dependency Node
Taruh `index.js` dan `package.json` di satu folder, buka PowerShell/CMD di folder itu:
```powershell
npm install --legacy-peer-deps
```
(`--legacy-peer-deps` tetap dibutuhin karena konflik versi jimp vs Baileys, sama kayak di Termux.)

## 6. Jalanin

**Cara manual:**
```powershell
node index.js
```

**Cara auto-run (double-click, gak perlu buka terminal manual):**
Ada 2 file launcher — taruh di folder yang sama dengan `index.js`:

- **`start.bat`** — tinggal double-click, kerja langsung di semua Windows tanpa setting tambahan. Ini yang paling direkomendasiin.
- **`start.ps1`** — versi PowerShell, tapi PowerShell secara default **memblokir eksekusi script** (`.ps1`) demi keamanan. Kalau mau pakai ini, jalanin sekali di PowerShell (as user biasa, gak perlu admin):
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
  ```
  baru bisa klik-kanan `start.ps1` → **Run with PowerShell**, atau jalanin `.\start.ps1` dari dalam PowerShell.

Kedua launcher otomatis `cd` ke folder tempat file itu berada duluan (jadi bisa taruh shortcut di Desktop, tetap kerja), dan kasih jeda "Tekan Enter" di akhir biar jendelanya gak langsung ketutup kalau ada error — jadi pesan errornya sempat kebaca.

Nanti muncul menu pilihan mode (WhatsApp bot / proses video lokal / proses foto lokal) — sama persis kayak di HP.

## Beda penting dari versi Termux

- **GPU acceleration BENERAN kepake di sini** (kalau laptopnya punya GPU NVIDIA). Deteksi GPU (`detectGpu()`) bakal coba cari `h264_nvenc` di ffmpeg — di Android itu SELALU gagal (nggak ada CUDA di HP), tapi di laptop dengan GPU NVIDIA yang benar dan ffmpeg build yang mendukung NVENC, ini bisa beneran aktif dan mempercepat proses render/upscale secara signifikan. Kualitas upscale-nya tetap sama (masih filter lanczos), tapi prosesnya jauh lebih cepat.
- **Kill proses saat timeout/cancel** pakai `taskkill /T /F` di Windows (bukan `pkill` yang Unix-only) — udah otomatis disesuaikan di kode, nggak perlu diapa-apain.
- **QR/pairing code, ffmpeg, yt-dlp, semua command** jalan sama persis — nggak ada logic yang perlu diubah manual.
- Kalau warna/progress bar di CLI lokal keliatan aneh (kotak-kotak bukannya warna), pakai **Windows Terminal** atau **PowerShell 7** — CMD lama/legacy console kadang nggak render kode warna ANSI dengan baik.

## Auth session
Folder `baileys_session` yang nyimpen login WhatsApp itu spesifik per-device — kalau pindah dari Termux ke laptop (atau sebaliknya), harus pairing ulang dari nol, nggak bisa copot-pasang foldernya begitu aja antar OS yang beda.
