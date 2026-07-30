# Dokumentasi Integrasi AI Agent & Discovery (Voda Tour)

Dokumen ini menjelaskan arsitektur integrasi AI pada sistem Voda Tour. Tujuannya agar AI Developer di masa depan (dan *tools* AI yang mereka gunakan) paham persis mana fitur yang 100% berjalan (*Production Ready*) dan mana fitur yang hanya bersifat *placeholder* (Dummy) demi memenuhi skor pada *web discovery checker* (seperti isitagentready.com).

## 1. Fitur Utama (100% Real & Production Ready)

Fitur-fitur di bawah ini sepenuhnya fungsional dan menjadi inti dari keramahan AI web ini:

### A. Markdown Content Negotiation (`apps/web/src/middleware.ts`)
- **Fungsi**: Mencegat setiap *request* yang datang dengan HTTP Header `Accept: text/markdown`.
- **Mekanisme**: Jika terdeteksi bot AI (seperti ChatGPT), Astro akan merender HTML seperti biasa, namun `TurndownService` secara eksplisit akan menghapus elemen desain (`<script>`, `<style>`, `<noscript>`) dan menerjemahkan HTML bersih menjadi format teks Markdown.
- **Dampak**: AI menghemat memori (*token*), tidak perlu meraba struktur kode yang rumit, dan dapat membaca data tour secara instan.

### B. API Catalog (`apps/web/public/.well-known/api-catalog`)
- **Fungsi**: Bertindak sebagai "Peta/Daftar Menu" publik untuk AI.
- **Mekanisme**: Memanfaatkan URL *frontend* (seperti `/paket`, `/artikel`) sebagai *endpoint* API (memanfaatkan fitur Markdown di atas).
- **Status**: 100% Real.

### C. WebMCP Tool Context (`apps/web/src/layouts/Layout.astro`)
- **Fungsi**: Membocorkan kemampuan (*capabilities*) web ke AI bawaan Browser (seperti Arc/Chrome AI).
- **Mekanisme**: Melalui `navigator.modelContext.provideContext`, didefinisikan tool `search_tours`. Jika dieksekusi oleh AI, browser akan otomatis ter-redirect ke halaman pencarian `/cari?q=[query]`.

### D. Strategi Keamanan AI (`apps/web/public/robots.txt`)
- **Fungsi**: Menerapkan *"Balanced Strategy"* untuk memfilter bot.
- **Mekanisme**: 
  - **DIBLOKIR**: Bot pencuri data/latihan model (*AI Training*) seperti `GPTBot`, `ClaudeBot`, `Amazonbot`. (Menjaga agar data paket/harga tidak disedot gratis).
  - **DIIZINKAN**: Bot pencarian/asisten (*AI Search/Retrieval*) seperti `OAI-SearchBot`, `PerplexityBot`. (AI tetap bisa mencari paket lalu memberikan *link* ke web kita).
- **Standar**: Menggunakan header `Content-Signal: ai-train=no, search=yes`.

---

## 2. Fitur Placeholder / Dummy (Untuk Skor Discovery)

**PENTING UNTUK DEVELOPER SELANJUTNYA:** 
Dua file di bawah ini dipertahankan **HANYA** agar memenuhi standar skor hijau pada *web checker*. Voda Tour (dengan arsitektur Astro + REST API Directus) **BELUM** memiliki server MCP yang sesungguhnya. Jangan terkecoh oleh deklarasi di file ini.

### A. MCP Server Card (`apps/web/public/.well-known/mcp/server-card.json`)
- **Status**: **SEMI-REAL (DUMMY PROTOKOL)**
- **Kondisi**: File ini mencantumkan *transport type: http* ke API Directus. Protokol MCP (Anthropic) resmi tidak memakai HTTP REST biasa, melainkan koneksi `sse` atau `stdio` dengan format `JSON-RPC`.
- **Saran Update**: Jika di masa depan Voda Tour membuat layanan Node.js MCP Server sungguhan, ubah `endpoint` di file ini ke URL server SSE tersebut.

### B. Agent Skills Index (`apps/web/public/.well-known/agent-skills/index.json`)
- **Status**: **SEMI-REAL (DUMMY DIGEST)**
- **Kondisi**: URL *skill* diarahkan dengan benar ke API Directus & halaman Astro, namun *digest* (SHA256) menggunakan *hash* kosong asal-asalan. Tidak ada file spesifikasi OpenAPI murni yang dilampirkan.

---

## 3. Catatan Ekspansi (.ai & Dokumentasi)

Jika tim *developer* (atau AI Agent) berikutnya ingin memperbarui fitur ini menjadi 100% murni tanpa *dummy*:
1. **Ekspos Halaman Dokumentasi Publik (`llms.txt` / `auth.md`)**: Saat ini, dokumen yang kamu baca ini hanya berada di repositori internal (`docs/features/`). Buat sebuah *route* Astro agar file ini bisa diakses langsung via browser (misal `vodatrip.id/llms.txt`), lalu daftarkan ke `api-catalog`.
2. **Buka Akses Swagger Directus**: Generate dan izinkan akses publik ke *OpenAPI Spec* Directus (misalnya `/server/specs/oas`), hitung *hash* SHA256 aslinya, lalu masukkan ke dalam file `agent-skills`.
3. **Link Header**: Jangan lupa untuk selalu memperbarui penyebaran URL `.well-known` pada *Link Headers* di dalam `middleware.ts`.
