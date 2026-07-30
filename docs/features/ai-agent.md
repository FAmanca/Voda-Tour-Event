# AI Agent Discovery & Integration

Dokumentasi ini menjelaskan fitur-fitur yang telah diimplementasikan pada aplikasi web Voda Tour untuk mendukung penemuan (discovery) dan interaksi dengan agen AI, sesuai dengan standar dari Cloudflare.

## 1. Dukungan Middleware & Negosiasi Konten (Content Negotiation)
File `apps/web/src/middleware.ts` berfungsi untuk mencegat (intercept) setiap HTTP request.
- **Header Link**: Secara otomatis menyuntikkan header `Link` ke dalam response untuk memberi tahu agen AI lokasi file `.well-known`.
- **Markdown Negotiation**: Jika agen AI mengirimkan header `Accept: text/markdown` saat mengakses halaman web HTML, middleware akan mengonversi HTML hasil render menjadi format Markdown menggunakan library `turndown` sebelum mengirimkannya kembali. Hal ini sangat menghemat *token* dan memudahkan AI dalam membaca struktur halaman.

## 2. File `.well-known`
Untuk memudahkan agen AI dalam menemukan kapabilitas API, beberapa file statis ditempatkan di dalam folder `apps/web/public/.well-known/`:
- `api-catalog`: Berisi daftar endpoint API beserta dokumen OpenAPI-nya.
- `mcp/server-card.json`: Mendeklarasikan bahwa server mendukung protokol Model Context Protocol (MCP) dengan transport berbasis SSE (Server-Sent Events).
- `agent-skills/index.json`: Manifest untuk Agent Skills, mendefinisikan *skill* apa saja yang bisa digunakan AI.

## 3. WebMCP (Model Context Protocol via Web)
Protokol ini memungkinkan situs web untuk menyediakan kapabilitas (tools) secara langsung ke agen AI yang berjalan di *browser* pengguna (misal melalui *extension* browser).
Implementasi awal dilakukan dengan menyuntikkan skrip ke dalam `Layout.astro` yang memanggil `navigator.modelContext.provideContext()`. Skrip ini mendaftarkan *tool* pencarian paket (`search_tours`) yang dapat dieksekusi agen AI.

## Panduan Perawatan
- Jika ada penambahan fitur API baru, perbarui `api-catalog`.
- Jika ada fungsi spesifik yang ingin diberikan kepada AI (misal booking), tambahkan implementasinya di dalam konfigurasi `navigator.modelContext` di layout utama.
