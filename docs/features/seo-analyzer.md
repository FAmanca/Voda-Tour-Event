# Custom SEO Analyzer

## 1. Overview
The `custom-seo-analyzer` adalah ekstensi (custom interface) Directus buatan khusus yang berfungsi menyerupai Yoast SEO atau RankMath. Extension ini melakukan evaluasi konten artikel secara *real-time* untuk memberikan panduan optimasi on-page SEO yang terukur dan mudah dipahami. 

Antarmuka ini menyesuaikan dengan tema Directus yang digunakan dan membagi aspek evaluasi menjadi 3 tab utama:
- **Basic SEO**: Metadata, panjang title, dan meta deskripsi.
- **Keyphrases**: Optimasi kata kunci utama (Focus Keyword) dan kata kunci turunan (Secondary Keywords/LSI).
- **Readability & Content**: Keterbacaan, tautan, media, dan struktur konten.

---

## 2. Fitur & Antarmuka
- **Live Score & Status**: Menghitung skor SEO secara dinamis berdasarkan metrik yang telah dievaluasi, memberikan warna visual **Merah (Buruk), Oranye (Perlu Perbaikan), Hijau (Bagus)**.
- **SERP Preview**: Memberikan simulasi bagaimana tampilan hasil pencarian artikel di Google (Desktop/Mobile format).
- **Smart Tags Input**:
  - Kata kunci dimasukkan dalam format tag (ketik enter / koma).
  - **Tag Pertama**: Diberi ikon Bintang (★) sebagai **Focus Keyword Utama**.
  - **Tag Berikutnya**: Dianggap sebagai **Secondary Keywords**.
  - Setiap tag (chip) diwarnai secara *real-time* berdasarkan keberadaannya di dalam konten (Merah = tidak ada, Oranye = ada di konten tapi tidak di title, Hijau = memenuhi kriteria utama).

---

## 3. Rumus & Aturan Evaluasi

### A. Basic SEO

| Check ID | Evaluasi | Kondisi Hijau (Optimal) | Kondisi Oranye (Warning) | Kondisi Merah (Error) |
| :--- | :--- | :--- | :--- | :--- |
| `title-len` | Panjang SEO Title | 30 - 60 karakter | Ada teks tapi <30 atau >60 karakter | Belum diisi |
| `desc-len` | Panjang Meta Description | 120 - 160 karakter | Ada teks tapi <120 atau >160 karakter | Belum diisi |
| `title-power` | Power Words di Title | Terdapat kata sentimen positif/CTR pemicu | Tidak ada power word | - |
| `title-number` | Angka di Title | Mengandung angka | Tidak mengandung angka | - |
| `title-sep` | Separator Brand | Terdapat pemisah `\|` atau `-` | Tidak terdapat pemisah | - |
| `url-length` | Panjang URL / Slug | Panjang slug < 75 karakter | Panjang slug >= 75 karakter | - |

### B. Evaluasi Kata Kunci (Keyphrases)

| Check ID | Evaluasi | Kondisi Hijau (Optimal) | Kondisi Oranye (Warning) | Kondisi Merah (Error) |
| :--- | :--- | :--- | :--- | :--- |
| `kw-set` | Focus Keyword | Telah diisi | - | Kosong |
| `kw-cannibal` | Keyword Cannibalization | Unik (belum dipakai di artikel lain) | - | Digunakan di artikel lain |
| `sec-kw` | Secondary Keywords | Semua ditemukan di konten | Sebagian ditemukan di konten | Tidak ada yang ditemukan |
| `kw-title` | Keyword di Title | Ditemukan di Title | - | Tidak ditemukan |
| `kw-title-start`| Keyword di Awal Title | Berada di awal Title | Ditemukan tapi bukan di awal | - |
| `kw-desc` | Keyword di Deskripsi | Ditemukan di Meta Description | Tidak ditemukan | - |
| `kw-url` | Keyword di Slug | Slug mengandung focus keyword | Tidak ada di slug | - |
| `kw-first-para`| Keyword di Awal Konten | Muncul di ~10% awal konten / paragraf pertama | Tidak muncul di awal konten | - |
| `kw-content` | Keyword Density | 0.5% - 2.5% | < 0.5% (Terlalu rendah) | > 2.5% (Stuffing) / 0 (Tidak ada) |
| `content-heading-kw`| Keyword di Subheading | Ditemukan pada Subheading (H2/H3) | Tidak ditemukan di Subheading | - |
| `content-image-alt` | Keyword di Alt Image | Terdapat atribut `alt` gambar mengandung keyword | Tidak ada keyword pada alt gambar | - |

### C. Evaluasi Readability & Content

| Check ID | Evaluasi | Kondisi Hijau (Optimal) | Kondisi Oranye (Warning) | Kondisi Merah (Error) |
| :--- | :--- | :--- | :--- | :--- |
| `content-len` | Panjang Konten | >= 600 kata | 300 - 599 kata | < 300 kata (Terlalu pendek) |
| `para-len` | Panjang Paragraf | Semua paragraf <= 150 kata | Ada paragraf > 150 kata | - |
| `read-sentence` | Panjang Kalimat | Kalimat panjang (>20 kata) <= 25% | Kalimat panjang > 25% | - |
| `read-trans` | Kata Transisi | Penggunaan kata transisi >= 30% | Penggunaan kata transisi < 30% | - |
| `read-toc` | Daftar Isi (ToC) | Terdapat teks ToC atau navigasi `#` | Artikel > 600 kata tapi tak ada ToC | - |
| `content-heading` | Subheading H2/H3 | Terdapat H2 atau H3 | Tidak ada Subheading | - |
| `content-image` | Media Gambar | Mengandung tag gambar (`<img`) | Tidak ada gambar | - |
| `link-internal` | Tautan Internal | Ada link ke domain/situs sendiri | Tidak ada tautan internal | - |
| `link-external` | Tautan Eksternal | Ada link ke situs eksternal/otoritatif | Tidak ada tautan eksternal | - |

---

## 4. Sistem Penilaian (Scoring Calculation)

Setiap poin evaluasi (Check) yang dieksekusi akan ditotal dengan formula perhitungan berikut:

- **Bobot Nilai**:
  - Status `Green` = **1 Poin**
  - Status `Orange` = **0.5 Poin**
  - Status `Red` = **0 Poin**

- **Rumus Skor Akhir**:
  `Score = Math.round((Total Poin / Jumlah Kriteria Evaluasi) * 100)`

- **Warna Progress Bar/Badge**:
  - `Skor >= 80` = **Hijau (Bagus)** - `#00C853`
  - `Skor 50 - 79` = **Oranye (Perlu Perbaikan)** - `#FF9800`
  - `Skor < 50` = **Merah (Buruk)** - `#FF5252`

---

## 5. Implementasi Frontend (Astro)

Data dari `custom-seo-analyzer` disimpan ke kolom JSON dalam format:
```json
{
  "focus_keyword": "tour sumba",
  "secondary_keywords": "trip sumba murah, open trip sumba",
  "title": "Paket Tour Sumba Terbaik | Voda Tour",
  "metaDescription": "Dapatkan penawaran terbaik untuk tour Sumba selama 4 hari 3 malam bersama kami."
}
```

Di level Astro, data ini diekstrak dan disuntikkan ke dalam komponen `Layout.astro` melalui slot SEO, sehingga menghasilkan tag:
- `<title>`
- `<meta name="description" content="...">`
- Canonical Tag otomatis.
- JSON-LD Rich Snippets (Breadcrumbs, Article/Event schema).
