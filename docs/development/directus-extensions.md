# Panduan Pengembangan Ekstensi Directus (Custom Modules & Hooks)

> **Versi Dokumen**: 1.0  
> **Target Pembaca**: Developer Full-Stack & AI Agent (Claude, ChatGPT, Codex, Cursor)  
> **Ruang Lingkup**: Ekstensi Directus CMS (`/extensions/`)

---

## 1. Pengantar & Arsitektur Ekstensi

Proyek Voda Tour & Event tidak hanya menggunakan Directus sebagai Headless CMS standar via API, melainkan melakukan kustomisasi secara mendalam pada antarmuka admin (Data Studio) serta logika *backend* melalui sistem **Directus Extensions**.

Saat ini terdapat 4 ekstensi aktif di dalam direktori `extensions/`:

| Nama Ekstensi | Tipe | Lokasi Direktori | Fungsi & Kegunaan |
| :--- | :--- | :--- | :--- |
| **`article-editor`** | Custom Module | `extensions/article-editor/` | Modul manajemen artikel bergaya WordPress Gutenberg Fullscreen dengan fitur SEO Analyzer interaktif ala Yoast/RankMath dan pengelompokan Konten Pilar. |
| **`package-editor`** | Custom Module | `extensions/package-editor/` | Modul kustom untuk mengelola paket wisata (*tour packages*), jadwal perjalanan (*itinerary*), tier harga berdasarkan jumlah pax, dan fasilitas. |
| **`custom-seo-analyzer`** | Custom Interface | `extensions/custom-seo-analyzer/` | Interface SEO Analyzer versi awal (stand-alone panel). Aturan dan rumusnya kini telah diintegrasikan 100% ke dalam `article-editor`. |
| **`auto-compress-webp`** | Action Hook | `extensions/auto-compress-webp/` | *Hook backend* yang otomatis mengompresi dan mengonversi setiap gambar yang diunggah ke Directus menjadi format WebP berukuran ringkas. |

---

## 2. Alur Kerja Pengembangan & Deployment (Wajib Dipatuhi)

Directus yang berjalan di proyek ini di-host di dalam container Docker (`voda-directus`). Ekstensi Directus berbasis Vue 3 / Node.js tidak dapat dibaca langsung dari berkas kode mentah (`src/`), melainkan harus dikompilasi terlebih dahulu menjadi *bundle* JavaScript statis (`dist/index.mjs` atau `index.js`).

### A. Alur Kerja Standar (Standard Workflow)

Setiap kali Anda melakukan perubahan kode pada ekstensi apapun di dalam folder `extensions/<nama-ekstensi>/src/`, Anda **WAJIB** menjalankan 3 langkah deploy berikut:

#### Langkah 1: Kompilasi Ekstensi (Build)
Masuk ke direktori ekstensi yang dimodifikasi dan jalankan skrip build npm:
```bash
cd /home/famanca/voda-tour-event/extensions/<nama-ekstensi>
npm run build
```
*Catatan: Directus Extension SDK (`@directus/extensions-sdk`) akan memvalidasi TypeScript dan membungkus komponen Vue menjadi berkas `dist/index.mjs`.*

#### Langkah 2: Salin Berkas ke Container Docker (Deploy)
Salin hasil kompilasi dari folder `dist/` lokal ke dalam volume container Directus, lalu perbaiki hak akses berkas agar dapat dibaca oleh proses Directus:
```bash
cd /home/famanca/voda-tour-event
docker cp extensions/<nama-ekstensi>/dist/. voda-directus:/directus/extensions/<nama-ekstensi>/dist/
docker exec -u root voda-directus chmod -R 777 /directus/extensions
```

#### Langkah 3: Restart Container Directus
Proses Node.js Directus memuat ekstensi ke dalam memori hanya pada saat *startup* (booting awal). Anda wajib merestart container agar ekstensi baru dimuat:
```bash
docker restart voda-directus
```

#### Langkah 4: Verifikasi & Cek Log (Opsional namun Penting)
Tunggu sekitar 5 detik hingga container selesai booting, lalu periksa log untuk memastikan ekstensi berhasil dimuat tanpa error transpilasi:
```bash
sleep 5 && docker logs voda-directus --tail 15
```
*Pastikan Anda melihat baris:*
```
[INFO] Extensions loaded
[INFO] Loaded extensions: directus-extension-article-editor, directus-extension-auto-compress-webp, directus-extension-custom-seo-analyzer, directus-extension-package-editor, @directus-labs/seo-plugin
```

---

## 3. Aturan & Standar Penulisan Kode (Vue 3 in Directus)

Ekstensi antarmuka Directus dibangun menggunakan pustaka **Vue 3**. Namun, terdapat beberapa aturan khusus yang berbeda dengan pengembangan aplikasi Vue/Nuxt konvensional yang harus dipahami oleh developer dan AI Agent:

### 1. Gunakan Composition API dengan `setup()` (Bukan `<script setup>`)
Dalam banyak kasus integrasi `@directus/extensions-sdk`, penulisan Single File Component (SFC) paling stabil adalah menggunakan blok `<script>` biasa dengan fungsi `setup(props, { emit })` dan mengembalikan (*return*) objek/variabel ke template:
```vue
<template>
  <div class="my-custom-module">
    <v-button @click="doSomething">Klik Saya</v-button>
  </div>
</template>

<script>
import { ref, computed } from 'vue';
import { useApi } from '@directus/extensions-sdk';

export default {
  name: 'MyCustomModuleComponent',
  setup() {
    const api = useApi();
    const loading = ref(false);

    const doSomething = async () => {
      loading.value = true;
      // panggil API Directus internal
      await api.get('/items/articles');
      loading.value = false;
    };

    return { loading, doSomething };
  }
};
</script>

<style scoped>
/* style CSS khusus komponen ini */
</style>
```

### 2. Gunakan Komponen UI Bawaan Directus (Directus Component Library)
Directus Data Studio telah mendaftarkan komponen UI secara global. **Jangan menginstal atau menggunakan library UI eksternal (seperti Vuetify, Element Plus, atau Tailwind UI)** di dalam ekstensi Directus demi menjaga konsistensi tema gelap/terang dan ukuran bundle.

Gunakan komponen global berikut:
- **`<private-view title="Judul">`**: Komponen pembungkus utama halaman Directus. Menyediakan slot `#title-outer:prepend`, `#actions` (untuk tombol top bar), `#navigation` (untuk sidebar kiri), dan `#sidebar` (untuk sidebar detail kanan).
- **`<sidebar-detail icon="info" title="Judul" initial-open>`**: Komponen akordeon standar untuk mengisi slot `#sidebar` atau `#navigation`.
- **`<v-button>`**: Tombol aksi. Gunakan properti `icon round secondary` untuk tombol ikon bulat, atau `loading` & `disabled` saat proses asinkron.
- **`<v-icon name="icon_name" />`**: Menampilkan ikon Material Symbols / Google Icons (contoh: `add`, `edit`, `delete`, `search`, `check_circle`, `article`, `arrow_back`).
- **`<v-input v-model="val" placeholder="..." />`**: Input teks standar. Mendukung slot `#prepend` dan `#append`.
- **`<v-select v-model="val" :items="options" />`**: Dropdown pilihan. Format item: `[{ text: 'Label', value: 'val' }]`.
- **`<v-notice type="info|warning|danger|success">`**: Kotak pesan pemberitahuan.
- **`<v-progress-circular indeterminate />`**: Indikator loading berputar.
- **`<v-upload>` / `<v-dialog>` / `<v-card>`**: Untuk interaksi modal dan pemilihan berkas dari direktori media.

### 3. Komunikasi dengan Internal API Directus (`useApi`)
Jangan pernah menggunakan `fetch()` biasa atau `axios` dengan URL hardcode ke `http://localhost:8055` di dalam modul Vue. Selalu gunakan `useApi()` dari `@directus/extensions-sdk`.
- `const api = useApi();` mengembalikan instance Axios yang sudah dikonfigurasi secara otomatis dengan **Token Autentikasi Admin** yang sedang login dan *base URL* yang tepat.
- Contoh pemanggilan: `api.get('/items/articles', { params: { filter: { status: { _eq: 'published' } } } })`.

---

## 4. Tips Pemecahan Masalah (Troubleshooting & Pitfalls)

### A. Perubahan Kode Tidak Muncul di Browser
1. **Lupa Deploy / Restart**: Apakah Anda sudah menjalankan `npm run build` di folder ekstensi, `docker cp`, dan `docker restart voda-directus`?
2. **Cache Browser Yang Kuat**: Directus Admin sering menyimpan cache bundle ekstensi. Selalu gunakan **Shift + F5** (Windows/Linux) atau **Cmd + Shift + R** (Mac) untuk melakukan *Hard Refresh*.
3. **Error Saat Build**: Periksa terminal tempat Anda menjalankan `npm run build`. Jika terdapat sintaks yang salah, berkas `dist/index.mjs` lama tidak akan terperbarui.

### B. Bug Layout & Overflow (Khusus TipTap / Editor Teks)
Jika Anda menggunakan TipTap atau editor kaya teks di dalam ekstensi, perhatikan dua masalah umum berikut:
1. **Teks Panjang Menembus Kanvas**: Gunakan selector `:deep(.ProseMirror)` pada CSS scoped dan berikan properti pemecah kata paksa:
   ```css
   :deep(.ProseMirror) {
     word-wrap: break-word;
     overflow-wrap: break-word;
     word-break: break-word;
     white-space: pre-wrap;
   }
   ```
2. **Gambar Dalam Flexbox Menjadi Tinggi 0px (Collapse)**: Kontainer flexbox dengan `overflow: hidden` dapat membuat tinggi gambar menjadi `0px`. Solusinya adalah memberikan `min-height` eksplisit dan `height: auto` pada tag gambar atau kontainernya:
   ```css
   .image-container img {
     width: 100%;
     height: auto;
     min-height: 240px;
     object-fit: contain;
   }
   ```

### C. Z-Index pada Mode Fullscreen Overlay & Dialog Modal (ATURAN EMAS)
Saat membuat antarmuka *fullscreen takeover* ala WordPress Gutenberg (seperti pada `.editor-view` di `article-editor`), perhatikan dua aturan emas pengelolaan `z-index` agar tidak terjadi *deadlock* atau UI freeze:
1. **Gunakan Z-Index Terukur (`z-index: 150`)**: Jangan pernah memberikan `z-index: 99999` pada kontainer overlay layar penuh Anda! Navigasi kiri dan header admin Directus berada di kisaran `z-index: 20 - 100`. Dengan memberikan `z-index: 150`, overlay Anda sudah sempurna menutupi navigasi Directus, **namun tetap berada di bawah layer modal `<v-dialog>` bawaan Directus** (yang memiliki `z-index` sekitar `500 - 1000`). Jika overlay Anda lebih tinggi dari modal, modal akan terbuka di belakang overlay dan sistem *focus trap* akan membekukan layar!
2. **Jangan Menimpa Z-Index `.v-overlay` dan `.v-dialog` Secara Paksa**: Dalam tema Directus, `<v-overlay>` (background gelap/biru transparan) memiliki `z-index: 999`, sedangkan `<v-dialog>` (card konten modal) memiliki `z-index: 1000`. Jika Anda menimpa keduanya ke angka yang sama (misalnya dengan CSS global `.v-dialog, .v-overlay { z-index: 999999 !important; }`), overlay transparan akan bertumpuk di atas card dialog sehingga dialog terlihat tetapi tidak bisa diklik (*blocked by blue background*). Biarkan Directus mengelola hierarki z-index modalnya sendiri secara natif!
