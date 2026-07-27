# Modul Ekstensi Kustom: Artikel Editor & SEO Analyzer ala Yoast / RankMath (`article-editor`)

> **Versi Dokumen**: 1.0  
> **Target Pengguna**: Developer Selanjutnya, AI Agent (Claude, ChatGPT, Codex, Cursor), dan Content Creator  
> **Lokasi Berkas**: `extensions/article-editor/src/module.vue`

---

## 1. Pengantar & Filosofi Desain

Modul **Artikel Editor** (`article-editor`) adalah ekstensi kustom bertipe *Custom Module* di dalam ekosistem Directus CMS. Modul ini diciptakan untuk menggantikan antarmuka tabel (Data Studio Grid) bawaan Directus pada koleksi `articles`, dengan tujuan memberikan pengalaman menulis dan manajemen konten yang setara dengan **WordPress Gutenberg Fullscreen Mode** dipadukan dengan **SEO Analyzer interaktif ala Yoast SEO / RankMath**.

### Mengapa Membutuhkan Modul Kustom?
1. **Pengalaman Menulis Bebas Distraksi (Distraction-Free Writing)**: Penulis konten membutuhkan ruang kerja yang luas dan tidak terganggu oleh sidebar atau menu admin saat sedang mengetik artikel panjang.
2. **Analisis SEO Secara *Real-Time* (On-Page SEO)**: Penulis dapat langsung melihat evaluasi kualitas judul, deskripsi, kata kunci (keywords), keterbacaan (readability), hingga pencegahan kanibalisasi kata kunci sebelum artikel diterbitkan.
3. **Alur Kerja Khusus (Custom Workflow)**: Menyediakan integrasi langsung untuk pemilihan *Featured Image* di dalam kanvas, pengelompokan *Pillar Content*, dan pengelolaan relasi iklan/sponsor (*Ads*) dalam satu layar terpadu.

---

## 2. Arsitektur Antarmuka & Sistem Layout Hybrid

Salah satu tantangan terbesar dalam pengembangan modul ekstensi Directus adalah menyeimbangkan antara **konsistensi navigasi CMS** dengan **kebutuhan fokus layar penuh saat menulis**. Untuk mengatasi hal ini, `article-editor` menerapkan **Sistem Layout Hybrid**:

```
+-------------------------------------------------------------------------+
| KONDISI 1: DAFTAR ARTIKEL (!currentArticle)                             |
| Dibungkus dengan <private-view title="Daftar Artikel">                 |
| +-------------------+-------------------------------------------------+ |
| | Navigasi Kiri     | Area Konten Utama (.dashboard-view)             | |
| | (#navigation)     | [ Pencarian Cepat (.dashboard-top-search) ]     | |
| |                   |                                                 | |
| | STATUS ARTIKEL:   | Tabel Daftar Artikel (WordPress Style):         | |
| | - Semua (X)       | | Judul | Keyword Fokus | Skor | Status | Tgl | | |
| | - Diterbitkan (X) | +-------+---------------+------+--------+-----+ | |
| | - Draft (X)       | | ...   | ...           | ...  | ...    | ... | | |
| | - Arsip (X)       | +-------+---------------+------+--------+-----+ | |
| +-------------------+-------------------------------------------------+ |
+-------------------------------------------------------------------------+

+-------------------------------------------------------------------------+
| KONDISI 2: MODE EDIT / TULIS BARU (currentArticle aktif)               |
| Overlay Layar Penuh (position: fixed !important; 100vw x 100vh)         |
| +---------------------------------------------------------------------+ |
| | Top Bar: [<- Kembali] [Toggle Toolbox Kiri] | Judul | [Panel Kanan] | | |
| +------------------------------------+--------------------------------+ |
| | KANVAS UTAMA (TipTap Editor)       | SIDEBAR KANAN (SEO Analyzer)   | |
| |                                    | - Lingkaran Skor SVG (0-100)   | |
| | [Gambar Cover Banner]              | - Smart Tag Input (Focus/LSI)  | |
| |                                    | - Tab: Basic SEO               | |
| | Judul Artikel Besar (H1)           | - Tab: Keyphrases & Cannibal   | |
| |                                    | - Tab: Readability             | |
| | Isi Konten Artikel...              | - Panel Pengaturan (Pillar,    | |
| |                                    |   Tanggal, Status)             | |
| +------------------------------------+--------------------------------+ |
+-------------------------------------------------------------------------+
```

### A. Halaman Daftar Artikel (Table List View)
- **Komponen Pembungkus**: Menggunakan `<private-view v-if="!currentArticle" title="Daftar Artikel">` bawaan Directus. Hal ini memastikan modul tetap memiliki standar header, ikon, dan struktur layout Directus Admin.
- **Tombol Aksi Ringkas (Icon-Only Button)**: Slot `#actions` pada header diisi dengan tombol ikon bulat (`+` / `add`) untuk memicu pembuatan artikel baru:
  ```html
  <template #actions>
    <v-button icon round @click="createNew" title="Tulis Baru"><v-icon name="add" /></v-button>
  </template>
  ```
- **Sidebar Navigasi Kiri (`#navigation`)**: Menampilkan daftar filter status artikel (**Semua, Diterbitkan, Draft, Arsip**) lengkap dengan hitungan jumlah artikel (*badge count*) yang diperbarui secara dinamis.
- **Pencarian Di Atas Tabel**: Kotak pencarian (`.dashboard-top-search`) diletakkan tepat di atas tabel agar pengguna dapat langsung mencari judul atau kata kunci tanpa perlu membuka sidebar kanan. **Sidebar kanan (`#sidebar`) sengaja ditiadakan** demi menciptakan ruang tabel yang lega dan bersih.

### B. Halaman Editor Layar Penuh (Fullscreen WordPress Gutenberg Mode)
- **CSS Takeover (Fixed Overlay)**: Begitu pengguna mengklik tombol `+` (Tulis Baru) atau memilih salah satu artikel untuk diedit, variabel `currentArticle` menjadi aktif dan `<private-view>` ditutup. Sebagai gantinya, kontainer `.editor-view` dimuat dengan gaya CSS khusus:
  ```css
  .editor-view {
    position: fixed !important;
    top: 0 !important;
    left: 0 !important;
    width: 100vw !important;
    height: 100vh !important;
    z-index: 99999 !important;
    background: #fff !important;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  ```
- **Efek Nyata**: Antarmuka navigasi utama Directus (left sidebar, top header, admin menu) tertutup sepenuhnya oleh editor. Pengguna berada dalam ruang kerja 100% bebas distraksi yang terbagi menjadi dua panel: **Kanvas Artikel (Kiri/Tengah)** dan **Panel SEO & Pengaturan (Kanan)**.
- **Tombol Kembali**: Menekan ikon panah kiri (`arrow_back`) di Top Bar akan mengubah `currentArticle = null`, menghapus overlay layar penuh, dan mengembalikan pengguna ke halaman tabel.

---

## 3. Fitur & Komponen Utama

### 1. TipTap Rich Text Editor & Word-Wrap Fix
Editor teks menggunakan pustaka **TipTap** (`@tiptap/vue-3`) dengan ekstensi standar (`starter-kit`, `image`, `table`, `underline`, `text-align`, dll).

> [!IMPORTANT]
> **Pencegahan Overflow Teks (Word-Wrap Fix)**  
> Pada implementasi awal, teks panjang tanpa spasi (misalnya URL atau string kode) dapat menembus batas kanvas kertas. Masalah ini diselesaikan dengan menerapkan aturan CSS penahan pemecahan kata secara paksa pada kontainer TipTap:
> ```css
> :deep(.ProseMirror) {
>   outline: none;
>   min-height: 450px;
>   word-wrap: break-word;
>   overflow-wrap: break-word;
>   word-break: break-word;
>   white-space: pre-wrap;
> }
> ```
> Selain itu, seluruh area `.dashboard-view` dan area gulir editor dijamin memiliki atribut `overflow-y: auto` dengan penanganan pembatas kanvas yang tepat.

### 2. Sistem Tag Keyword Interaktif (Smart Chip Tags)
Penginputan kata kunci tidak lagi menggunakan kolom teks biasa yang terpisah, melainkan menggunakan sistem **Smart Chip Tag Input** dalam satu kolom terpadu:
- **Cara Kerja**: Pengguna mengetik kata kunci lalu menekan tombol **Enter** atau **Koma (`,`)**.
- **Focus Keyword (★)**: Tag pertama yang dimasukkan otomatis ditandai dengan ikon bintang (`★`) dan disimpan ke dalam properti `focus_keyword`.
- **Secondary / LSI Keywords**: Tag kedua dan seterusnya otomatis disimpan sebagai array/string yang digabungkan koma ke dalam properti `secondary_keywords`.
- **Pewarnaan Dinamis Seketika (*Real-time Status Color*)**:
  - 🟢 **Hijau (`#00C853`)**: Kata kunci ditemukan di dalam **Judul (Title)** DAN **Konten Artikel**.
  - 🟠 **Oranye (`#FF9800`)**: Kata kunci ditemukan di dalam **Konten Artikel**, tetapi tidak ada di judul.
  - 🔴 **Merah (`#FF5252`)**: Kata kunci **sama sekali tidak ditemukan** di dalam konten artikel.
- **Tombol Hapus (X)**: Setiap chip tag dilengkapi tombol silang (`X`) kecil untuk menghapus keyword secara mandiri tanpa merusak urutan tag lainnya.

### 3. SEO & Readability Analyzer (100% Aturan Yoast / RankMath)
Modul ini mengevaluasi 15+ indikator SEO on-page setiap kali terjadi perubahan teks pada editor atau metadata. Skor akhir dihitung dari persentase keberhasilan kriteria.

#### Lingkaran Skor SVG Dinamis
Skor divisualisasikan melalui komponen SVG dengan animasi rotasi *stroke-dashoffset*:
```html
<svg width="76" height="76" viewBox="0 0 64 64">
  <circle cx="32" cy="32" r="24" fill="none" stroke="#e6eaf0" stroke-width="6" />
  <circle cx="32" cy="32" r="24" fill="none" :stroke="scoreColor" stroke-width="6" 
          stroke-linecap="round" :stroke-dasharray="circumference" 
          :stroke-dashoffset="offset" 
          style="transition: stroke-dashoffset 0.8s ease-in-out; transform: rotate(-90deg); transform-origin: center;" />
  <text x="32" y="32" fill="#0B2340" font-size="15" font-weight="700" text-anchor="middle" dominant-baseline="central">{{ score }}</text>
</svg>
```
- **>= 80 (Bagus / Green)**: Warna `#00C853`.
- **50 - 79 (Perlu Perbaikan / Orange)**: Warna `#FF9800`.
- **< 50 (Buruk / Red)**: Warna `#FF5252`.

#### Daftar Parameter Pengecekan (SEO Rules Engine)

| Kategori | Check ID | Nama Pengecekan | Kriteria Hijau (1 Poin) | Kriteria Oranye (0.5 Poin) | Kriteria Merah (0 Poin) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Basic SEO** | `title-len` | Panjang SEO Title | 30 - 60 karakter | < 30 atau > 60 karakter | Belum diisi (0 karakter) |
| | `desc-len` | Panjang Meta Description | 120 - 160 karakter | < 120 atau > 160 karakter | Belum diisi |
| | `title-power` | Power Words di Title | Mengandung kata pemicu CTR (terbaik, panduan, lengkap, rahasia, murah, promo, dll) | Tidak mengandung Power Word | - |
| | `title-number`| Angka di Title | Mengandung karakter angka (`\d`) | Tidak mengandung angka | - |
| | `title-sep` | Pemisah Brand (Separator) | Mengandung karakter `-` atau `\|` | Tidak mengandung pemisah | - |
| | `url-length` | Panjang Slug / URL | Panjang slug < 75 karakter | Panjang slug >= 75 karakter | - |
| **Keyphrases**| `kw-set` | Focus Keyword Diisi | Focus keyword telah ditentukan | - | Focus keyword kosong |
| | `kw-cannibal`| Keyword Cannibalization | Unik (tidak ditemukan di artikel lain via API) | - | **Kanibalisasi!** Keyword sudah dipakai di artikel lain |
| | `sec-kw` | Secondary Keywords | Semua secondary keywords ada di konten | Hanya sebagian ditemukan di konten | Tidak ada yang ditemukan / kosong |
| | `kw-title` | Keyword di Title | Focus keyword ada di dalam Title | - | Tidak ada di Title |
| | `kw-title-start`| Keyword di Awal Title | Focus keyword berada di 15 karakter pertama Title | Ada di Title tapi bukan di awal | - |
| | `kw-desc` | Keyword di Meta Desc | Focus keyword ada di Meta Description | Tidak ada di Meta Description | - |
| | `kw-url` | Keyword di Slug | Slug mengandung focus keyword yang di-slugify | Tidak ada di Slug | - |
| | `kw-first-para`| Keyword di 10% Awal Konten | Muncul di paragraf pertama / 10% awal teks | Tidak muncul di awal artikel | - |
| | `kw-content` | Keyword Density | Kepadatan keyword 0.5% - 2.5% | Kepadatan < 0.5% (terlalu rendah) | Kepadatan > 2.5% (Stuffing) / 0% |
| | `content-heading-kw`| Keyword di Subheading | Ditemukan pada minimal satu tag H2/H3 | Tidak ditemukan di Subheading | - |
| | `content-image-alt`| Keyword di Alt Text Gambar| Terdapat atribut `alt` gambar berisi keyword | Tidak ada gambar / alt tidak mengandung keyword| - |
| **Readability**| `content-len` | Jumlah Kata (Word Count) | >= 600 kata | 300 - 599 kata | < 300 kata (Terlalu pendek) |
| | `para-len` | Panjang Paragraf | Tidak ada paragraf > 150 kata | Terdapat paragraf > 150 kata | - |
| | `read-sentence`| Panjang Kalimat | Kalimat panjang (>20 kata) <= 25% | Kalimat panjang > 25% | - |
| | `read-trans` | Kata Transisi (Transition) | Penggunaan kata transisi >= 30% kalimat | Penggunaan kata transisi < 30% | - |
| | `read-toc` | Deteksi Daftar Isi (ToC) | Mengandung kata "daftar isi" / "table of content" / link `#` | Artikel > 600 kata tapi tidak memiliki ToC | - |
| | `content-heading`| Distribusi Subheading | Terdapat tag H2 atau H3 | Tidak memiliki Subheading sama sekali | - |
| | `content-image`| Penggunaan Media Gambar | Terdapat minimal 1 tag `<img` | Tidak ada gambar di dalam artikel | - |
| | `link-internal`| Tautan Internal | Mengandung link dengan href `/` atau domain `vodatrip.id` | Tidak memiliki tautan internal | - |
| | `link-external`| Tautan Eksternal | Mengandung link `http` ke domain luar | Tidak memiliki tautan eksternal | - |

> [!TIP]
> **Pengecekan Kanibalisasi Kata Kunci (*Keyword Cannibalization*)**  
> Pengecekan ini berjalan secara asinkron dengan teknik **Debounce (800ms)** agar tidak membebani server Directus saat penulis mengetik cepat. Sistem memanggil internal API Directus:
> ```javascript
> api.get('/items/articles', {
>   params: {
>     filter: { SEO: { _contains: `"focus_keyword":"${kw}"` } },
>     limit: 2,
>     fields: ['id', 'title']
>   }
> });
> ```
> Hasil respons difilter untuk mengecualikan ID artikel yang sedang diedit (`id !== currentArticle.id`). Jika ditemukan artikel lain dengan keyword yang sama, status berubah merah dengan peringatan kanibalisasi.

### 4. Sistem Konten Pilar (Pillar Content Management)
Modul ini menggantikan checkbox pilar sederhana dengan logika hierarki interaktif:
- **Toggle Konten Pilar (`is_pillar`)**: Saklar aktif/nonaktif untuk menandai apakah artikel ini merupakan artikel utama (Pillar/Hub).
- **Dropdown Artikel Induk (`pillar_parent`)**:
  - Jika `is_pillar == false` (artikel biasa/cluster): Sistem memanggil API `/items/articles?filter[is_pillar][_eq]=true&fields=id,title` untuk memuat semua artikel yang berstatus pilar. Penulis dapat memilih artikel mana yang menjadi induk dari artikel cluster ini.
  - Jika `is_pillar == true` (artikel ini adalah pilar): Dropdown `pillar_parent` otomatis disembunyikan dan nilainya dikosongkan (karena sebuah pilar tidak boleh memiliki induk pilar lain).

### 5. Gambar Cover & Bagian Iklan Sponsor (Ads Integration)
- **Cover Banner Di Dalam Kanvas**: Gambar cover (*Featured Image*) tidak hanya disimpan sebagai metadata rahasia, tetapi di-render langsung di dalam kanvas kertas di bawah judul artikel. Hal ini memberikan gambaran nyata kepada penulis bagaimana tampilan akhir artikel di website publik.
  - Dilengkapi tombol bergaya ikon tunggal: **Ikon Edit** (`edit`) untuk mengganti gambar melalui modal Directus File Picker, dan **Ikon Hapus** (`delete`) untuk mencopot gambar.
  - Perbaikan CSS `min-height: 240px; object-fit: contain;` mencegah bug collapse (`0px` height) pada kontainer flex.
- **Iklan & Sponsor (Ads Section)**: Relasi *one-to-many* ke tabel `ads` dikelola langsung di sidebar kanan editor.
  - Tombol tambah iklan menggunakan tombol ikon bulat (`+` / `add`) di pojok kanan judul section.
  - Penulis dapat memilih gambar banner sponsor dari Directus Library, mengisi deskripsi, serta menautkan URL tujuan iklan.

---

## 4. Panduan Pengembang (Developer Guide & Workflow)

Bagi developer selanjutnya atau AI Agent yang bertugas merawat atau memodifikasi modul ini, wajib mematuhi alur pengembangan berikut.

### A. Lokasi Kode & Struktur File
```
voda-tour-event/
└── extensions/
    └── article-editor/
        ├── package.json        # Dependensi (@tiptap/vue-3, dll)
        ├── src/
        │   ├── index.ts        # Registrasi modul (id: 'article-editor', icon: 'edit_document')
        │   └── module.vue      # Source of Truth: Vue 3 SFC (Template, Setup API, Style Scoped)
        └── dist/               # Hasil kompilasi bundle (index.mjs) yang dibaca oleh Directus
```

### B. Prosedur Build & Deployment ke Docker
Setiap kali melakukan perubahan pada berkas `src/module.vue` atau `src/index.ts`, kode **wajib dikompilasi ulang** dan disalin ke dalam container Docker Directus yang sedang berjalan. **Jangan pernah mengasumsikan perubahan pada `src/` langsung tayang tanpa di-build!**

Jalankan perintah berikut di terminal (berurutan):

1. **Kompilasi Ekstensi (Build)**:
   ```bash
   cd /home/famanca/voda-tour-event/extensions/article-editor
   npm run build
   ```
   *Pastikan proses berakhir dengan pesan `✔ Done` dan tidak ada error TypeScript/Vue.*

2. **Salin ke Container & Perbaiki Hak Akses (Deploy)**:
   ```bash
   cd /home/famanca/voda-tour-event
   docker cp extensions/article-editor/dist/. voda-directus:/directus/extensions/article-editor/dist/
   docker exec -u root voda-directus chmod -R 777 /directus/extensions
   ```

3. **Restart Container Directus (Wajib agar bundle baru dimuat)**:
   ```bash
   docker restart voda-directus
   ```

4. **Verifikasi Log (Opsional namun disarankan)**:
   ```bash
   sleep 5
   docker logs voda-directus --tail 15
   ```
   *Pastikan muncul log `INFO: Loaded extensions: directus-extension-article-editor, ...` dan `Server started at http://0.0.0.0:8055`.*

### C. Skema Data & Interaksi API (Directus SDK)
Modul ini berkomunikasi dengan backend Directus menggunakan `useApi()` dari `@directus/extensions-sdk`. Berikut adalah skema payload yang dikirimkan saat fungsi `saveArticle()` dipanggil:

```javascript
// Struktur Payload untuk tabel 'articles'
const payload = {
  title: currentArticle.value.title,
  slug: currentArticle.value.slug,
  content: currentArticle.value.content, // HTML string dari TipTap editor
  status: currentArticle.value.status,   // 'published' | 'draft' | 'archived'
  publish_date: currentArticle.value.publish_date,
  featured_image: currentArticle.value.featured_image, // UUID FK ke directus_files
  is_pillar: currentArticle.value.is_pillar || false,
  pillar_parent: currentArticle.value.is_pillar ? null : currentArticle.value.pillar_parent,
  
  // Kolom SEO bertipe JSON
  SEO: {
    focus_keyword: seoData.value.focus_keyword,
    secondary_keywords: seoData.value.secondary_keywords,
    title: seoData.value.title,
    metaDescription: seoData.value.metaDescription
  }
};

// Eksekusi Simpan (Buat Baru vs Perbarui)
if (currentArticle.value.id) {
  await api.patch(`/items/articles/${currentArticle.value.id}`, payload);
} else {
  const res = await api.post('/items/articles', payload);
  currentArticle.value.id = res.data.data.id;
}
```

---

## 5. Ringkasan Prinsip UI/UX (Wajib Dipertahankan)

1. **Seluruh Antarmuka dalam Bahasa Indonesia**: Tidak boleh ada label berbahasa Inggris untuk elemen yang menghadap pengguna. Gunakan istilah standar seperti *Tulis Baru*, *Simpan Artikel*, *Daftar Artikel*, *Gambar Cover*, *Konten Pilar*, *Kata Kunci Fokus*, *Tanggal Rilis*, dan *Status*.
2. **Prinsip Icon-Only untuk Tombol Aksi Kanan/Kecil**: Tombol aksi sekunder (tambah iklan, ganti cover, hapus cover, kembali, toggle panel) wajib menggunakan tombol ikon bulat (`icon round`) tanpa teks, guna menjaga tampilan tetap bersih dan tidak padat.
3. **Larangan Fitur Pratinjau (No Preview Clutter)**: Seluruh tombol atau tautan "Pratinjau" (table row action, top bar button, dan kotak SERP Google preview di sidebar) **telah dihapus secara sengaja** sesuai arahan desain. Jangan pernah menambahkan kembali fitur pratinjau tersebut agar penulis tetap fokus pada evaluasi metrik SEO dan penulisan konten di kanvas.
