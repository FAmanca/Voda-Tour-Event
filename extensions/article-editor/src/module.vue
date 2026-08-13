<template>
  <div class="article-editor-module">
    <!-- DASHBOARD VIEW: LIST ARTIKEL DENGAN SIDEBAR DIRECTUS -->
    <private-view v-if="!currentArticle" title="Daftar Artikel">
      <template #title-outer:prepend>
        <v-button class="header-icon" rounded disabled icon="article" />
      </template>
      <template #actions>
        <div style="position: relative; display: inline-block;">
          <v-button icon round @click="handleCreateClick" title="Tulis Baru"><v-icon name="add" /></v-button>
          <div v-if="offlineDrafts.length > 0" style="position: absolute; top: -5px; right: -5px; background-color: #ef4444; color: white; border-radius: 50%; width: 20px; height: 20px; display: flex; justify-content: center; align-items: center; font-size: 11px; font-weight: bold; box-shadow: 0 2px 4px rgba(239, 68, 68, 0.4); pointer-events: none;">
            {{ offlineDrafts.length }}
          </div>
        </div>
      </template>
      <template #navigation>
        <div class="directus-nav-sidebar">
          <div class="nav-section-title">STATUS ARTIKEL</div>
          <div class="nav-list">
            <button class="nav-item" :class="{ active: activeFilter === 'all' }" @click="activeFilter = 'all'">
              <span style="display: flex; align-items: center; gap: 8px;"><v-icon name="list" small /> Semua</span> <span class="badge">{{ articles.length }}</span>
            </button>
            <button class="nav-item" :class="{ active: activeFilter === 'published' }" @click="activeFilter = 'published'">
              <span style="display: flex; align-items: center; gap: 8px;"><v-icon name="check_circle" small /> Diterbitkan</span> <span class="badge">{{ articles.filter(a => a.status === 'published').length }}</span>
            </button>
            <button class="nav-item" :class="{ active: activeFilter === 'scheduled' }" @click="activeFilter = 'scheduled'">
              <span style="display: flex; align-items: center; gap: 8px;"><v-icon name="schedule" small /> Dijadwalkan</span> <span class="badge">{{ articles.filter(a => a.status === 'scheduled').length }}</span>
            </button>
            <button class="nav-item" :class="{ active: activeFilter === 'draft' }" @click="activeFilter = 'draft'">
              <span style="display: flex; align-items: center; gap: 8px;"><v-icon name="edit_note" small /> Draft</span> <span class="badge">{{ articles.filter(a => a.status === 'draft').length }}</span>
            </button>
            <button class="nav-item" :class="{ active: activeFilter === 'archived' }" @click="activeFilter = 'archived'">
              <span style="display: flex; align-items: center; gap: 8px;"><v-icon name="archive" small /> Arsip</span> <span class="badge">{{ articles.filter(a => a.status === 'archived').length }}</span>
            </button>
          </div>
        </div>
      </template>

      <div class="dashboard-view">
        <div class="dashboard-top-search">
          <v-input v-model="searchQuery" placeholder="Cari artikel atau kata kunci...">
            <template #prepend><v-icon name="search" /></template>
          </v-input>
        </div>
        <div class="dashboard-content" v-if="!loading">
        <div class="table-responsive" v-if="filteredArticles.length > 0">
          <table class="wp-table">
            <thead>
              <tr>
                <th style="width: 40%;">Judul</th>
                <th style="width: 20%;">Kata Kunci Fokus</th>
                <th style="width: 15%;">Skor SEO</th>
                <th style="width: 10%;">Status</th>
                <th style="width: 15%;">Tanggal</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="article in paginatedArticles" :key="article.id" class="wp-row">
                <td class="col-title">
                  <div class="title-wrapper">
                    <span class="title-text" @click="editArticle(article)">
                      {{ article.title || 'Tanpa Judul' }}
                    </span>
                    <span v-if="article.is_pillar" class="pillar-badge" title="Artikel ini adalah Konten Pilar">
                      Pilar
                    </span>
                  </div>
                  <div class="row-actions">
                    <span class="action-edit" @click="editArticle(article)">Edit</span> |
                    <span class="action-duplicate" @click.stop="duplicateArticle(article)">Duplikat</span> |
                    <span class="action-delete" @click.stop="confirmDelete(article)">Hapus</span>
                  </div>
                </td>
                <td class="col-kw">
                  <span v-if="article.SEO?.focus_keyword" class="kw-pill">{{ article.SEO.focus_keyword }}</span>
                  <span v-else class="text-muted">-</span>
                </td>
                <td class="col-seo">
                  <div class="seo-indicator" :class="article.computedSeoColor">
                    <span class="dot"></span>
                    <span class="score-num">{{ article.computedSeoScore }} / 100</span>
                    <span class="score-lbl">({{ article.computedSeoLabel }})</span>
                  </div>
                </td>
                <td class="col-status">
                  <span class="status-badge" :class="article.status">
                    {{ article.status === 'published' ? 'Diterbitkan' : (article.status === 'scheduled' ? 'Dijadwalkan' : (article.status === 'draft' ? 'Draft' : 'Arsip')) }}
                  </span>
                </td>
                <td class="col-date">
                  <div class="date-text">{{ formatDate(article.publish_date) }}</div>
                  <div class="date-sub">{{ article.status === 'published' ? 'Tanggal Rilis' : (article.status === 'scheduled' ? 'Jadwal Rilis' : 'Terakhir Diubah') }}</div>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="pagination-controls" v-if="totalPages > 1">
            <v-button @click="currentPage--" :disabled="currentPage === 1" secondary>Sebelumnya</v-button>
            <span class="page-info">Halaman {{ currentPage }} dari {{ totalPages }}</span>
            <v-button @click="currentPage++" :disabled="currentPage === totalPages" secondary>Selanjutnya</v-button>
          </div>
        </div>
        <div v-else class="empty-state">
          <v-icon name="article" x-large />
          <p>Belum ada artikel yang sesuai dengan filter ini. Klik "Tulis Baru" untuk membuat artikel.</p>
        </div>
      </div>
      <div v-else class="loading-state">
        <v-progress-circular indeterminate />
      </div>
    </div>
    </private-view>

    <!-- EDITOR VIEW: WORDPRESS GUTENBERG FULL-PAGE CLEAN CANVAS -->
    <div v-else class="editor-view">
      <!-- Top Bar (Tombol toggle di sebelah kiri & kanan berupa ikon saja) -->
      <div class="editor-top-bar">
        <div class="top-bar-left">
          <v-button icon round secondary @click="closeEditor" title="Kembali ke Daftar Artikel"><v-icon name="arrow_back" /></v-button>
          <v-button icon round secondary @click="showLeftToolbox = !showLeftToolbox" :title="showLeftToolbox ? 'Tutup Toolbox Kiri' : 'Buka Toolbox Kiri'"><v-icon name="view_sidebar" /></v-button>
          <div class="divider-vertical"></div>
          <v-button icon round secondary @click="editor.chain().focus().undo().run()" :disabled="!editor || !editor.can().undo()" title="Undo (Ctrl+Z)"><v-icon name="undo" /></v-button>
          <v-button icon round secondary @click="editor.chain().focus().redo().run()" :disabled="!editor || !editor.can().redo()" title="Redo (Ctrl+Y)"><v-icon name="redo" /></v-button>
        </div>
        <div class="editor-title">{{ currentArticle.title || 'Artikel Baru' }}</div>
        <div class="top-actions">

          <v-button icon round secondary @click="showRightSidebar = !showRightSidebar" :title="showRightSidebar ? 'Tutup Panel Kanan' : 'Buka Panel Kanan'"><v-icon name="side_navigation" /></v-button>
          <v-button @click="saveArticle" :loading="isSaving" :disabled="isSaving" icon="save">Simpan Artikel</v-button>
        </div>
      </div>

      <!-- Main Layout (3-Pane Full Page) -->
      <div class="editor-layout">
        <!-- Left Pane: Toolbox Block Inserter (Informatif & Ready to Use) -->
        <div v-show="showLeftToolbox" class="editor-toolbox-pane">
          <div class="toolbox-header">
            <div class="toolbox-title"><v-icon name="widgets" small /> Toolbox Lengkap</div>
            <v-button icon round small secondary @click="showLeftToolbox = false" title="Tutup Toolbox"><v-icon name="close" small /></v-button>
          </div>
          <div class="toolbox-search">
            <v-input v-model="toolboxSearch" placeholder="Cari alat atau blok..." small>
              <template #prepend><v-icon name="search" small /></template>
            </v-input>
          </div>
          <div class="toolbox-list">
            <div v-for="(cat, idx) in filteredToolboxCategories" :key="idx" class="toolbox-category">
              <div class="cat-name">{{ cat.name }}</div>
              <div class="cat-items">
                <div v-for="item in cat.items" :key="item.id" class="tool-item" @click="item.action()" :title="item.desc">
                  <div class="tool-icon"><v-icon :name="item.icon" small /></div>
                  <div class="tool-info">
                    <div class="tool-title">{{ item.title }}</div>
                    <div class="tool-desc">{{ item.desc }}</div>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="filteredToolboxCategories.length === 0" class="toolbox-empty">
              Alat tidak ditemukan.
            </div>
          </div>
        </div>

        <!-- Center Pane: Editor Canvas (Full Page White Workspace, Wrapping ke bawah tanpa crop) -->
        <div class="editor-main-pane">
          <div class="canvas-container">
            <input v-model="currentArticle.title" class="paper-title-input" placeholder="Judul Artikel..." @input="generateSlug" />
            
            <!-- Featured Image (Cover Image) Banner di bawah judul ala frontend Astro -->
            <div v-if="currentArticle.featured_image" class="canvas-cover-box">
              <img :src="getImageSrc(currentArticle.featured_image)" alt="Cover Image" class="canvas-cover-img" />
              <div class="canvas-cover-actions">
                <v-button small icon round @click="openMediaDialog('cover')" title="Ganti Cover"><v-icon name="edit" /></v-button>
                <v-button small icon round secondary @click="currentArticle.featured_image = null" title="Hapus Cover"><v-icon name="delete" /></v-button>
              </div>
            </div>
            <div v-else class="canvas-cover-placeholder" @click="openMediaDialog('cover')" title="Klik untuk menambahkan Gambar Cover artikel">
              <v-icon name="add_photo_alternate" class="cover-placeholder-icon" />
              <span>Tambahkan Gambar Cover (Featured Image)</span>
            </div>

            <!-- Bubble Menu: muncul saat teks dipilih -->
            <bubble-menu :editor="editor" :tippy-options="{ duration: 100 }" v-if="editor" class="bubble-menu-box">
              <!-- Text Format -->
              <button @click="editor.chain().focus().toggleBold().run()" :class="{ 'is-active': editor.isActive('bold') }" title="Bold (Ctrl+B)"><v-icon name="format_bold" small/></button>
              <button @click="editor.chain().focus().toggleItalic().run()" :class="{ 'is-active': editor.isActive('italic') }" title="Italic (Ctrl+I)"><v-icon name="format_italic" small/></button>
              <button @click="editor.chain().focus().toggleUnderline().run()" :class="{ 'is-active': editor.isActive('underline') }" title="Underline (Ctrl+U)"><v-icon name="format_underlined" small/></button>
              <button @click="editor.chain().focus().toggleStrike().run()" :class="{ 'is-active': editor.isActive('strike') }" title="Strike"><v-icon name="format_strikethrough" small/></button>
              <button @click="editor.chain().focus().toggleHighlight().run()" :class="{ 'is-active': editor.isActive('highlight') }" title="Highlight Teks" class="btn-highlight">▌</button>
              <button @click="editor.chain().focus().toggleCode().run()" :class="{ 'is-active': editor.isActive('code') }" title="Code Inline"><v-icon name="code" small/></button>
              <button @click="editor.chain().focus().toggleSubscript().run()" :class="{ 'is-active': editor.isActive('subscript') }" title="Subscript (x₂)">x₂</button>
              <button @click="editor.chain().focus().toggleSuperscript().run()" :class="{ 'is-active': editor.isActive('superscript') }" title="Superscript (x²)">x²</button>
              <button @click="setLink" :class="{ 'is-active': editor.isActive('link') }" title="Tautkan URL"><v-icon name="link" small/></button>
              <div class="divider"></div>
              <!-- Alignment -->
              <button @click="editor.chain().focus().setTextAlign('left').run()" :class="{ 'is-active': editor.isActive({ textAlign: 'left' }) }" title="Rata Kiri"><v-icon name="format_align_left" small/></button>
              <button @click="editor.chain().focus().setTextAlign('center').run()" :class="{ 'is-active': editor.isActive({ textAlign: 'center' }) }" title="Rata Tengah"><v-icon name="format_align_center" small/></button>
              <button @click="editor.chain().focus().setTextAlign('right').run()" :class="{ 'is-active': editor.isActive({ textAlign: 'right' }) }" title="Rata Kanan"><v-icon name="format_align_right" small/></button>
              <div class="divider"></div>
              <!-- Headings -->
              <button @click="editor.chain().focus().toggleHeading({ level: 1 }).run()" :class="{ 'is-active': editor.isActive('heading', { level: 1 }) }" title="Heading 1 (H1)">H1</button>
              <button @click="editor.chain().focus().toggleHeading({ level: 2 }).run()" :class="{ 'is-active': editor.isActive('heading', { level: 2 }) }" title="Heading 2 (H2)">H2</button>
              <button @click="editor.chain().focus().toggleHeading({ level: 3 }).run()" :class="{ 'is-active': editor.isActive('heading', { level: 3 }) }" title="Heading 3 (H3)">H3</button>
              <button @click="editor.chain().focus().toggleHeading({ level: 4 }).run()" :class="{ 'is-active': editor.isActive('heading', { level: 4 }) }" title="Heading 4 (H4)">H4</button>
              <div class="divider" v-if="editor.can().toggleCaption()"></div>
              <button @click="editor.chain().focus().toggleCaption().run()" v-if="editor.can().toggleCaption()" :class="{ 'is-active': editor.isActive('figure') }" title="Tampilkan/Sembunyikan Caption Gambar"><v-icon name="subtitles" small/> Caption</button>
            </bubble-menu>

            <!-- Floating Menu: muncul saat klik baris kosong ala WordPress -->
            <floating-menu :editor="editor" :tippy-options="{ duration: 100, placement: 'right' }" v-if="editor" class="floating-menu-box">
              <button @click="editor.chain().focus().toggleHeading({ level: 2 }).run()" title="Heading 2">## H2</button>
              <button @click="editor.chain().focus().toggleHeading({ level: 3 }).run()" title="Heading 3">### H3</button>
              <button @click="editor.chain().focus().toggleHeading({ level: 4 }).run()" title="Heading 4">#### H4</button>
              <div class="divider"></div>
              <button @click="editor.chain().focus().toggleBulletList().run()" title="Bullet List"><v-icon name="format_list_bulleted" small/> List</button>
              <button @click="editor.chain().focus().toggleOrderedList().run()" title="Numbered List"><v-icon name="format_list_numbered" small/> Angka</button>
              <button @click="editor.chain().focus().toggleBlockquote().run()" title="Quote"><v-icon name="format_quote" small/> Kutipan</button>
              <button @click="editor.chain().focus().toggleCodeBlock().run()" title="Code Block"><v-icon name="code" small/> Kode</button>
              <button @click="editor.chain().focus().setHorizontalRule().run()" title="Garis Pemisah"><v-icon name="horizontal_rule" small/> Garis</button>
              <div class="divider"></div>
              <button @click="insertToc" class="btn-toc" title="Sisipkan Daftar Isi"><v-icon name="toc" small/> TOC</button>
              <button @click="openMediaDialog('inline')" class="btn-img" title="Sisipkan Gambar"><v-icon name="image" small/> Gambar</button>
              <button @click="editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run()" class="btn-tbl" title="Tabel 3x3"><v-icon name="table_chart" small/> Tabel</button>
              <button @click="openYoutubeModal" class="btn-yt" title="Embed YouTube"><v-icon name="smart_display" small/> YT</button>
            </floating-menu>

            <editor-content :editor="editor" class="paper-content" />

            <!-- Word Count & Reading Time Status Bar -->
            <div v-if="editor" class="editor-status-bar">
              <span><v-icon name="format_size" small /> {{ wordCount }} kata</span>
              <span><v-icon name="schedule" small /> ~{{ readingTime }} menit baca</span>
              <span class="autosave-status" :class="autoSaveStatus">
                <v-icon :name="autoSaveStatus === 'saved' ? 'cloud_done' : autoSaveStatus === 'saving' ? 'sync' : 'edit'" small />
                {{ autoSaveStatus === 'saved' ? 'Tersimpan otomatis' : autoSaveStatus === 'saving' ? 'Menyimpan...' : 'Ada perubahan' }}
              </span>
            </div>
          </div>
        </div>

        <!-- Right Pane: Sidebar (Dokumen & SEO RankMath style, Bisa di-toggle) -->
        <div v-show="showRightSidebar" class="editor-sidebar-pane">
          <div class="sidebar-tabs">
            <div class="tab" :class="{ active: sidebarTab === 'document' }" @click="sidebarTab = 'document'">Dokumen</div>
            <div class="tab" :class="{ active: sidebarTab === 'seo' }" @click="sidebarTab = 'seo'">SEO ({{ seoScore }})</div>
          </div>

          <div class="sidebar-content">
            <!-- DOKUMEN TAB -->
            <div v-show="sidebarTab === 'document'" class="doc-panel">
              <div class="panel-section">
                <label>Status</label>
                <v-select v-model="currentArticle.status" :items="[
                  { text: 'Published (Diterbitkan)', value: 'published' },
                  { text: 'Scheduled (Dijadwalkan)', value: 'scheduled' },
                  { text: 'Draft (Konsep)', value: 'draft' },
                  { text: 'Archived (Diarsipkan)', value: 'archived' }
                ]" />
              </div>
              
              <div class="panel-section" v-if="currentArticle.status === 'scheduled'">
                <label>Tanggal Jadwal Tayang</label>
                <v-input v-model="currentArticle.publish_date" type="datetime-local" />
              </div>

              <div class="panel-section">
                <label>URL / Slug</label>
                <v-input v-model="currentArticle.slug" />
              </div>

              <div class="panel-section">
                <label>Gambar Cover (Featured Image)</label>
                <div class="featured-image-box">
                  <div v-if="currentArticle.featured_image" class="image-preview-wrapper">
                    <img :src="getImageSrc(currentArticle.featured_image)" class="image-preview" />
                    <v-button class="remove-image-btn" icon round secondary @click="currentArticle.featured_image = null" title="Hapus Gambar"><v-icon name="delete" /></v-button>
                  </div>
                  <v-button v-else @click="openMediaDialog('cover')" block icon="add_photo_alternate">Pilih Gambar Cover</v-button>
                </div>
              </div>

              <div class="panel-section">
                <label>Konten Pilar (Pillar Article)</label>
                <div class="checkbox-wrapper">
                  <input type="checkbox" id="is_pillar" v-model="currentArticle.is_pillar" />
                  <label for="is_pillar">Artikel ini adalah Konten Pilar Utama</label>
                </div>
                
                <div v-if="!currentArticle.is_pillar" class="mt-4">
                  <label>Pilih Induk Pilar</label>
                  <v-select v-model="currentArticle.pillar_parent" :items="pillarOptions" show-deselect placeholder="Pilih artikel induk pilar..." />
                </div>
              </div>

              <div class="panel-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                  <label style="margin-bottom: 0;">Iklan & Sponsor (Ads)</label>
                  <v-button small icon round secondary @click="addAd" title="Tambah Iklan"><v-icon name="add" /></v-button>
                </div>
                <div class="ads-list">
                  <div v-for="(ad, index) in ads" :key="index" class="ad-item">
                    <div class="ad-header">
                      <span>Iklan {{ index + 1 }}</span>
                      <v-icon name="close" class="remove-ad" @click="removeAd(index)" title="Hapus Iklan" />
                    </div>
                    <v-input v-model="ad.url" placeholder="URL Target Link..." class="mb-2" />
                    <v-input v-model="ad.description" placeholder="Deskripsi Singkat..." class="mb-2" />
                    <div class="ad-image">
                      <img v-if="ad.image" :src="getImageSrc(ad.image)" @click="openMediaDialog('ad', index)" class="ad-img-thumb" />
                      <v-button v-else @click="openMediaDialog('ad', index)" small block icon="image">Pilih Gambar Iklan</v-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- SEO TAB (YOAST / RANKMATH CLONE) -->
            <div v-show="sidebarTab === 'seo'" class="seo-panel">
              <!-- Score Header -->
              <div class="seo-score-header">
                <svg width="76" height="76" viewBox="0 0 64 64" class="score-circle">
                  <circle cx="32" cy="32" r="24" fill="none" stroke="#e6eaf0" stroke-width="6" />
                  <circle cx="32" cy="32" r="24" fill="none" :stroke="scoreColor" stroke-width="6" stroke-linecap="round" :stroke-dasharray="circumference" :stroke-dashoffset="offset" style="transition: stroke-dashoffset 0.8s ease-in-out; transform: rotate(-90deg); transform-origin: center;" />
                  <text x="32" y="32" fill="#0B2340" font-size="15" font-weight="700" text-anchor="middle" dominant-baseline="central">{{ Math.round(seoScore) }}</text>
                </svg>
                <div class="score-text">
                  <div class="score-label">Skor SEO Analyzer</div>
                  <div class="score-value" :style="{ color: scoreColor }">{{ scoreLabel }}</div>
                </div>
              </div>

              <!-- Keyword Tag Input -->
              <div class="panel-section">
                <label>Kata Kunci (Focus & Secondary Keywords)</label>
                <div class="tag-input-container">
                  <div class="tags-list">
                    <div v-for="(kw, index) in keywordsList" :key="index" class="tag" :class="getKeywordStatus(kw, index)">
                      <span v-if="index === 0" class="tag-star" title="Focus Keyword Utama">★</span>
                      {{ kw }}
                      <v-icon name="close" small class="tag-close" @click="removeKeyword(index)" />
                    </div>
                    <input v-model="newKeyword" @keydown.enter.prevent="addKeyword" @keydown.188.prevent="addKeyword" placeholder="Ketik kata kunci & Enter..." class="tag-input" />
                  </div>
                </div>
                <div class="tag-help">Kata kunci pertama otomatis menjadi <b>Focus Keyword ★</b>. Sisanya adalah Secondary/LSI. Pisahkan dengan Enter atau Koma.</div>
              </div>


              <!-- SEO Meta Inputs -->
              <div class="panel-section">
                <label>SEO Title (Judul Meta)</label>
                <v-input v-model="currentArticle.SEO.title" placeholder="Masukkan judul khusus SEO..." />
                <div class="char-count" :class="getCharColor(currentArticle.SEO.title?.length || 0, 30, 60)">
                  {{ currentArticle.SEO.title?.length || 0 }} / 60 karakter (Optimal: 30 - 60)
                </div>
              </div>
              <div class="panel-section">
                <label>Meta Description</label>
                <v-textarea v-model="currentArticle.SEO.metaDescription" rows="3" placeholder="Masukkan deskripsi rangkuman artikel..." />
                <div class="char-count" :class="getCharColor(currentArticle.SEO.metaDescription?.length || 0, 120, 160)">
                  {{ currentArticle.SEO.metaDescription?.length || 0 }} / 160 karakter (Optimal: 120 - 160)
                </div>
              </div>

              <!-- SEO Checklist (Dasar | Kata Kunci | Keterbacaan) -->
              <div class="seo-checks">
                <div class="check-tabs">
                  <div class="ctab" :class="{ active: checkTab === 'basic' }" @click="checkTab = 'basic'">Dasar</div>
                  <div class="ctab" :class="{ active: checkTab === 'keyword' }" @click="checkTab = 'keyword'">Kata Kunci</div>
                  <div class="ctab" :class="{ active: checkTab === 'readability' }" @click="checkTab = 'readability'">Keterbacaan</div>
                </div>
                <div class="checks-list">
                  <div v-for="check in currentChecks" :key="check.id" class="check-item">
                    <div class="check-dot" :class="check.status"></div>
                    <div class="check-text">{{ check.text }}</div>
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Directus Media Library Dialog (Cover / Inline / Iklan) -->
    <v-dialog v-model="showMediaDialog" @esc="showMediaDialog = false">
      <v-card class="media-library-card">
        <v-card-title class="media-header">
          <span>Directus Media Library ({{ mediaTarget === 'cover' ? 'Gambar Cover' : (mediaTarget === 'ad' ? 'Gambar Iklan' : 'Gambar Konten') }})</span>
          <div>
            <input type="file" ref="fileInput" @change="handleFileUpload" accept="image/*" style="display:none" />
            <button class="btn-upload" @click="$refs.fileInput.click()" :disabled="isUploading">
              <v-icon name="upload" small /> {{ isUploading ? 'Mengunggah...' : 'Unggah Gambar dari Komputer' }}
            </button>
          </div>
        </v-card-title>
        <v-card-text class="media-content">
          <div class="media-search-bar">
            <v-input v-model="mediaSearchQuery" placeholder="Cari nama file gambar di library Directus..." class="w-full">
              <template #prepend><v-icon name="search" /></template>
            </v-input>
          </div>
          <div v-if="loadingMedia" class="media-loading">
            <v-progress-circular indeterminate />
            <span>Memuat koleksi gambar...</span>
          </div>
          <div v-else-if="filteredMediaFiles.length === 0" class="media-empty">
            <v-icon name="image_not_supported" x-large />
            <p>Gambar tidak ditemukan. Klik tombol "Unggah Gambar dari Komputer" di atas untuk menambahkan gambar baru ke Directus Library.</p>
          </div>
          <div v-else class="media-grid">
            <div v-for="file in filteredMediaFiles" :key="file.id" class="media-item" :class="{ selected: selectedMediaFile?.id === file.id }" @click="selectedMediaFile = file; confirmMediaSelect();">
              <div class="thumb-wrap">
                <img :src="`/assets/${file.id}?width=200&height=200&fit=cover&format=webp&quality=80`" :alt="file.title || file.filename_download" loading="lazy" />
              </div>
              <div class="media-info">
                <div class="media-name" :title="file.filename_download">{{ file.title || file.filename_download }}</div>
                <div class="media-date">{{ formatDate(file.created_on) }}</div>
              </div>
            </div>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-button secondary @click="showMediaDialog = false">Tutup</v-button>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Delete Confirmation Dialog -->
    <v-dialog v-model="showDeleteDialog" @esc="showDeleteDialog = false">
      <v-card>
        <v-card-title>Konfirmasi Hapus Artikel</v-card-title>
        <v-card-text>
          Apakah Anda yakin ingin menghapus artikel <b>"{{ articleToDelete?.title || 'Tanpa Judul' }}"</b>? Tindakan ini tidak dapat dibatalkan.
        </v-card-text>
        <v-card-actions>
          <v-button secondary @click="showDeleteDialog = false">Batal</v-button>
          <v-button kind="danger" @click="executeDelete">Hapus Permanen</v-button>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Offline Drafts Dialog -->
    <v-dialog v-model="showOfflineDraftsDialog" @esc="showOfflineDraftsDialog = false">
      <v-card>
        <v-card-title>
          <div style="display: flex; align-items: center; gap: 8px;">
            <v-icon name="cloud_off" style="color: #f59e0b;" /> 
            Draf Offline Ditemukan
          </div>
        </v-card-title>
        <v-card-text>
          Ada <b>{{ offlineDrafts.length }}</b> draf yang belum tersimpan ke server. Apakah Anda ingin melanjutkan draf ini atau membuat artikel baru dari nol?
          <div style="margin-top: 16px; display: flex; flex-direction: column; gap: 12px; max-height: 400px; overflow-y: auto;">
            <div v-for="draft in offlineDrafts" :key="draft.key" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px; display: flex; justify-content: space-between; align-items: center;">
              <div style="width: 70%;">
                <div style="font-weight: 600; color: #0b2340; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">{{ draft.title }}</div>
                <div style="font-size: 12px; color: #64748b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">{{ draft.contentSnippet }}</div>
              </div>
              <div style="display: flex; gap: 8px;">
                <v-button secondary icon round @click="deleteOfflineDraft(draft.key)" title="Hapus Draf"><v-icon name="delete" /></v-button>
                <v-button @click="restoreOfflineDraft(draft.key)">Lanjutkan</v-button>
              </div>
            </div>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-button secondary @click="showOfflineDraftsDialog = false">Tutup</v-button>
          <v-button @click="createNewBlank">Buat Artikel Baru Kosong</v-button>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- === SLASH COMMAND MENU === -->
    <teleport to="body">
      <transition name="slash-fade">
        <div
          v-if="showSlashMenu"
          class="slash-menu"
          :style="{ left: slashMenuPos.x + 'px', top: slashMenuPos.y + 'px' }"
          @mousedown.prevent
        >
          <div class="slash-header">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Ketik untuk filter blok...
          </div>
          <div class="slash-list" ref="slashMenuListRef">
            <div
              v-for="(cmd, idx) in filteredSlashCommands"
              :key="cmd.id"
              class="slash-item"
              :class="{ active: idx === slashMenuIndex }"
              @mouseenter="slashMenuIndex = idx"
              @mousedown.prevent="executeSlashCommand(cmd)"
            >
              <div class="slash-icon"><v-icon :name="cmd.icon" small /></div>
              <div class="slash-info">
                <div class="slash-label">{{ cmd.label }}</div>
                <div class="slash-desc">{{ cmd.desc }}</div>
              </div>
            </div>
            <div v-if="filteredSlashCommands.length === 0" class="slash-empty">Tidak ada blok ditemukan</div>
          </div>
          <div class="slash-footer">↑↓ Navigasi &nbsp;·&nbsp; Enter Pilih &nbsp;·&nbsp; Esc Tutup</div>
        </div>
      </transition>
    </teleport>

    <!-- === YOUTUBE MODAL === -->
    <teleport to="body">
      <transition name="link-modal">
        <div v-if="showYoutubeModal" class="link-modal-backdrop" @mousedown.self="showYoutubeModal = false">
          <div class="link-modal-box" role="dialog" aria-modal="true" aria-label="Sisipkan Video YouTube" style="max-width:460px">
            <div class="lm-header">
              <div class="lm-header-icon" style="background:linear-gradient(135deg,#FF0000 0%,#cc0000 100%)">
                <svg width="18" height="13" viewBox="0 0 16 11" fill="none"><path d="M15.665 1.72A2 2 0 0 0 14.26.3C13.01 0 8 0 8 0S2.99 0 1.74.3A2 2 0 0 0 .336 1.72C0 2.98 0 5.6 0 5.6s0 2.62.336 3.88A2 2 0 0 0 1.74 10.9C2.99 11.2 8 11.2 8 11.2s5.01 0 6.26-.3a2 2 0 0 0 1.405-1.42C16 8.22 16 5.6 16 5.6s0-2.62-.335-3.88z" fill="white"/><path d="M6.4 8l4.16-2.4L6.4 3.2V8z" fill="#FF0000"/></svg>
              </div>
              <h3 class="lm-title">Embed Video YouTube</h3>
              <button class="lm-close" @click="showYoutubeModal = false">&times;</button>
            </div>
            <div class="lm-body">
              <div class="lm-field">
                <label class="lm-label">URL YouTube <span class="lm-required">*</span></label>
                <div class="lm-input-wrap" :class="{ error: youtubeUrlError }">
                  <input
                    ref="youtubeInputRef"
                    v-model="youtubeUrlVal"
                    type="url"
                    class="lm-input"
                    placeholder="https://www.youtube.com/watch?v=... atau https://youtu.be/..."
                    @keydown.enter.prevent="applyYoutube"
                    @keydown.escape.prevent="showYoutubeModal = false"
                    @input="youtubeUrlError = ''"
                  />
                </div>
                <span v-if="youtubeUrlError" class="lm-error-text">{{ youtubeUrlError }}</span>
                <div style="font-size:11px;color:#94a3b8;margin-top:4px;">💡 Juga bisa: tempel URL YouTube langsung di editor lalu tekan Spasi untuk auto-convert</div>
              </div>
            </div>
            <div class="lm-footer">
              <div class="lm-footer-right">
                <button class="lm-btn lm-btn-secondary" @click="showYoutubeModal = false">Batal</button>
                <button class="lm-btn lm-btn-primary" @click="applyYoutube" style="background:linear-gradient(135deg,#FF0000,#cc0000);box-shadow:0 4px 12px rgba(255,0,0,0.3)">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                  Sisipkan Video
                </button>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </teleport>

    <!-- === LINK MODAL === -->
    <teleport to="body">
      <transition name="link-modal">
        <div v-if="showLinkModal" class="link-modal-backdrop" @mousedown.self="closeLinkModal">
          <div class="link-modal-box" role="dialog" aria-modal="true" aria-label="Sisipkan Tautan">
            <div class="lm-header">
              <div class="lm-header-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>
              </div>
              <h3 class="lm-title">{{ linkModal.isEditing ? 'Edit Tautan' : 'Sisipkan Tautan' }}</h3>
              <button class="lm-close" @click="closeLinkModal" title="Tutup">&times;</button>
            </div>

            <div class="lm-body">
              <!-- URL Input -->
              <div class="lm-field">
                <label class="lm-label">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
                  URL Tautan <span class="lm-required">*</span>
                </label>
                <div class="lm-input-wrap" :class="{ error: linkModal.urlError }">
                  <input
                    ref="linkUrlInput"
                    v-model="linkModal.url"
                    type="url"
                    class="lm-input"
                    placeholder="https://contoh.com/halaman-tujuan"
                    @keydown.enter.prevent="applyLink"
                    @keydown.escape.prevent="closeLinkModal"
                    @input="linkModal.urlError = ''"
                  />
                </div>
                <span v-if="linkModal.urlError" class="lm-error-text">{{ linkModal.urlError }}</span>
              </div>

              <!-- Teks Tautan (hanya jika tidak ada selection) -->
              <div class="lm-field" v-if="!linkModal.hasSelection">
                <label class="lm-label">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polyline points="4 7 4 4 20 4 20 7"/><line x1="9" y1="20" x2="15" y2="20"/><line x1="12" y1="4" x2="12" y2="20"/></svg>
                  Teks Tautan
                </label>
                <div class="lm-input-wrap">
                  <input
                    v-model="linkModal.text"
                    type="text"
                    class="lm-input"
                    placeholder="Teks yang akan ditampilkan (kosongkan = pakai URL)"
                    @keydown.enter.prevent="applyLink"
                    @keydown.escape.prevent="closeLinkModal"
                  />
                </div>
              </div>

              <!-- Opsi Lanjutan -->
              <div class="lm-advanced" @click="linkModal.showAdvanced = !linkModal.showAdvanced">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" :style="{ transform: linkModal.showAdvanced ? 'rotate(90deg)' : 'rotate(0deg)', transition: 'transform 0.2s' }"><polyline points="9 18 15 12 9 6"/></svg>
                Opsi Lanjutan
              </div>
              <div v-show="linkModal.showAdvanced" class="lm-advanced-panel">
                <div class="lm-field">
                  <label class="lm-label">Buka di</label>
                  <div class="lm-radio-group">
                    <label class="lm-radio">
                      <input type="radio" v-model="linkModal.target" value="_self" />
                      <span class="lm-radio-label">Tab Sama</span>
                    </label>
                    <label class="lm-radio">
                      <input type="radio" v-model="linkModal.target" value="_blank" />
                      <span class="lm-radio-label">Tab Baru</span>
                    </label>
                  </div>
                </div>
                <div class="lm-field">
                  <label class="lm-label">Atribut Rel</label>
                  <div class="lm-checkbox-group">
                    <label class="lm-checkbox">
                      <input type="checkbox" v-model="linkModal.relNofollow" />
                      <span>nofollow <small>(tidak teruskan otoritas SEO)</small></span>
                    </label>
                    <label class="lm-checkbox">
                      <input type="checkbox" v-model="linkModal.relNoopener" />
                      <span>noopener <small>(keamanan tab baru)</small></span>
                    </label>
                    <label class="lm-checkbox">
                      <input type="checkbox" v-model="linkModal.relSponsored" />
                      <span>sponsored <small>(tautan berbayar / iklan)</small></span>
                    </label>
                    <label class="lm-checkbox">
                      <input type="checkbox" v-model="linkModal.relUgc" />
                      <span>ugc <small>(user generated content)</small></span>
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <div class="lm-footer">
              <button v-if="linkModal.isEditing" class="lm-btn lm-btn-danger" @click="removeLink">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                Hapus Tautan
              </button>
              <div class="lm-footer-right">
                <button class="lm-btn lm-btn-secondary" @click="closeLinkModal">Batal</button>
                <button class="lm-btn lm-btn-primary" @click="applyLink">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>
                  {{ linkModal.isEditing ? 'Perbarui Tautan' : 'Sisipkan Tautan' }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </teleport>
    
    <div v-if="toastMessage" class="toast-notification">
      {{ toastMessage }}
    </div>
  </div>
</template>

<script>
import { ref, reactive, computed, watch, nextTick, onMounted, onUnmounted } from 'vue';
import { useApi } from '@directus/extensions-sdk';
import { useEditor, EditorContent, BubbleMenu, FloatingMenu } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';
import Heading from '@tiptap/extension-heading';
import Underline from '@tiptap/extension-underline';
import TextAlign from '@tiptap/extension-text-align';
import Link from '@tiptap/extension-link';
import { ImageResize, Figure, Figcaption } from 'tiptap-extension-resize-image';
import Placeholder from '@tiptap/extension-placeholder';
import Table from '@tiptap/extension-table';
import TableRow from '@tiptap/extension-table-row';
import TableCell from '@tiptap/extension-table-cell';
import TableHeader from '@tiptap/extension-table-header';
import Highlight from '@tiptap/extension-highlight';
import Subscript from '@tiptap/extension-subscript';
import Superscript from '@tiptap/extension-superscript';
import CharacterCount from '@tiptap/extension-character-count';
import { Node, Extension, mergeAttributes, InputRule } from '@tiptap/core';

// Custom Table of Contents Node (POLOS / PLAIN LIST dengan Judul yang BISA DIEDIT)
const TableOfContentsNode = Node.create({
  name: 'tableOfContents',
  group: 'block',
  atom: true,
  addAttributes() {
    return {
      title: {
        default: 'Daftar Isi',
      },
      headings: {
        default: [],
      }
    };
  },
  parseHTML() {
    return [
      { tag: 'div[data-type="toc"]' },
      { tag: 'div.toc-plain' }
    ];
  },
  renderHTML({ HTMLAttributes, node }) {
    const titleText = node.attrs.title || 'Daftar Isi';
    const headings = node.attrs.headings || [];
    if (headings.length === 0) {
      return ['div', mergeAttributes(HTMLAttributes, { 'data-type': 'toc', class: 'toc-plain', style: 'margin: 20px 0;' }),
        ['div', { style: 'font-weight:700; color:#0b2340; margin-bottom:8px; font-size:18px;' }, titleText],
        ['div', { style: 'color:#64748b; font-size:14px; font-style:italic;' }, '(Belum ada Heading 2 atau Heading 3 dalam artikel ini)']
      ];
    }
    const listItems = headings.map(h => {
      const pad = h.level === 3 ? '20px' : '0px';
      return ['li', { style: `margin-left:${pad}; margin-bottom:6px;` },
        ['a', { href: `#${h.id}`, style: 'color:#0284c7; text-decoration:none; font-size:15px; font-weight:500;' }, h.text]
      ];
    });
    return ['div', mergeAttributes(HTMLAttributes, { 'data-type': 'toc', class: 'toc-plain', style: 'margin: 20px 0;' }),
      ['div', { style: 'font-weight:700; color:#0b2340; margin-bottom:12px; font-size:18px;' }, titleText],
      ['ul', { style: 'list-style-type:disc; padding-left:20px; margin:0;' }, ...listItems]
    ];
  },
  addNodeView() {
    return ({ editor, getPos, node }) => {
      const dom = document.createElement('div');
      dom.className = 'toc-plain-nodeview';
      dom.style.cssText = 'margin: 20px 0; background: transparent;';
      
      const titleInput = document.createElement('input');
      titleInput.type = 'text';
      titleInput.value = node.attrs.title || 'Daftar Isi';
      titleInput.className = 'toc-editable-title';
      titleInput.placeholder = 'Judul Daftar Isi (dapat diedit)...';
      titleInput.style.cssText = 'font-weight:700; color:#0b2340; font-size:18px; border:none; outline:none; background:transparent; width:100%; margin-bottom:8px; font-family:inherit; border-bottom: 1px dashed transparent; transition: border-color 0.2s; padding: 2px 0;';
      titleInput.title = 'Klik untuk mengubah judul Daftar Isi ini';
      
      titleInput.addEventListener('focus', () => {
        titleInput.style.borderBottomColor = '#cbd5e1';
      });
      titleInput.addEventListener('blur', () => {
        titleInput.style.borderBottomColor = 'transparent';
      });
      titleInput.addEventListener('input', (e) => {
        if (typeof getPos === 'function') {
          const pos = getPos();
          if (typeof pos === 'number') {
            editor.view.dispatch(editor.state.tr.setNodeMarkup(pos, undefined, { ...node.attrs, title: e.target.value }));
          }
        }
      });
      
      const listContainer = document.createElement('div');
      
      const renderList = () => {
        const headings = node.attrs.headings || [];
        if (headings.length === 0) {
          listContainer.innerHTML = `<div style="color:#64748b; font-size:14px; font-style:italic;">(Belum ada Heading 2 atau Heading 3. Ketik ## atau ### di baris baru untuk membuat heading otomatis)</div>`;
        } else {
          let html = `<ul style="list-style-type:disc; padding-left:20px; margin:0; display:flex; flex-direction:column; gap:6px;">`;
          headings.forEach(h => {
            const pad = h.level === 3 ? '20px' : '0px';
            html += `<li style="margin-left:${pad};"><a href="#${h.id}" style="color:#0284c7; text-decoration:none; font-size:15px; font-weight:500;" onclick="event.preventDefault(); const el = document.getElementById('${h.id}'); if(el) el.scrollIntoView({behavior:'smooth'});">${h.text}</a></li>`;
          });
          html += `</ul>`;
          listContainer.innerHTML = html;
        }
      };
      
      dom.appendChild(titleInput);
      dom.appendChild(listContainer);
      renderList();
      
      return {
        dom,
        update: (updatedNode) => {
          if (updatedNode.type.name !== 'tableOfContents') return false;
          node = updatedNode;
          if (document.activeElement !== titleInput) {
            titleInput.value = node.attrs.title || 'Daftar Isi';
          }
          renderList();
          return true;
        }
      };
    };
  },
  addInputRules() {
    return [
      new InputRule({
        find: /^\/(toc|table-of-content|daftar-isi)\s$/,
        handler: ({ state, range }) => {
          const { tr } = state;
          tr.replaceWith(range.from, range.to, this.type.create());
        },
      }),
    ];
  },
});

// Custom Heading agar selalu punya attribute ID untuk anchor scroll
const CustomHeading = Heading.extend({
  addAttributes() {
    return {
      ...this.parent?.(),
      id: {
        default: null,
        parseHTML: element => element.getAttribute('id'),
        renderHTML: attributes => {
          if (!attributes.id) return {};
          return { id: attributes.id };
        },
      },
    };
  },
});

// ===== YouTube Embed Node =====
const YouTubeNode = Node.create({
  name: 'youtube',
  group: 'block',
  atom: true,
  draggable: true,
  addAttributes() {
    return { videoId: { default: null } };
  },
  parseHTML() {
    return [{ tag: 'div[data-youtube-id]' }];
  },
  renderHTML({ node }) {
    const vid = node.attrs.videoId;
    if (!vid) return ['div', { class: 'youtube-embed-wrapper' }];
    return ['div', { 'data-youtube-id': vid, class: 'youtube-embed-wrapper' },
      ['iframe', {
        src: `https://www.youtube.com/embed/${vid}?rel=0`,
        frameborder: '0', allowfullscreen: 'true',
        allow: 'accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture',
        title: 'YouTube Video', class: 'youtube-embed-iframe',
      }]
    ];
  },
  addNodeView() {
    return ({ node }) => {
      const dom = document.createElement('div');
      dom.className = 'youtube-nodeview';
      dom.contentEditable = 'false';
      const render = () => {
        const vid = node.attrs.videoId;
        if (vid) {
          dom.innerHTML = `<div class="yt-ratio-box"><iframe src="https://www.youtube.com/embed/${vid}?rel=0" frameborder="0" allowfullscreen allow="accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture" title="YouTube Video"></iframe><div class="yt-badge"><svg width="14" height="10" viewBox="0 0 16 11" fill="none"><path d="M15.665 1.72A2 2 0 0 0 14.26.3C13.01 0 8 0 8 0S2.99 0 1.74.3A2 2 0 0 0 .336 1.72C0 2.98 0 5.6 0 5.6s0 2.62.336 3.88A2 2 0 0 0 1.74 10.9C2.99 11.2 8 11.2 8 11.2s5.01 0 6.26-.3a2 2 0 0 0 1.405-1.42C16 8.22 16 5.6 16 5.6s0-2.62-.335-3.88z" fill="#FF0000"/><path d="M6.4 8l4.16-2.4L6.4 3.2V8z" fill="white"/></svg> YouTube</div></div>`;
        } else {
          dom.innerHTML = '<div style="padding:24px;text-align:center;color:#94a3b8;font-size:13px;">Video tidak tersedia</div>';
        }
      };
      render();
      return { dom, update: (u) => { if (u.type.name !== 'youtube') return false; node = u; render(); return true; } };
    };
  },
  addInputRules() {
    return [new InputRule({
      find: /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})(?:[^\s]*)? $/,
      handler: ({ state, range, match }) => {
        const node = this.type.create({ videoId: match[1] });
        state.tr.replaceWith(range.from, range.to, node);
      },
    })];
  },
});

export default {
  components: {
    EditorContent,
    BubbleMenu,
    FloatingMenu,
  },
  setup() {
    const api = useApi();
    
    // Dashboard State
    const articles = ref([]);
    const loading = ref(true);
    const searchQuery = ref('');
    const activeFilter = ref('all');
    
    // Delete Confirmation
    const showDeleteDialog = ref(false);
    const articleToDelete = ref(null);
    
    // Editor State
    const currentArticle = ref(null);
    const isSaving = ref(false);
    const sidebarTab = ref('document');
    const checkTab = ref('basic');
    const pillarArticles = ref([]);
    
    // Toggle Panels
    const showLeftToolbox = ref(true);
    const showRightSidebar = ref(true);
    const toolboxSearch = ref('');
    
    // Directus Media Library State
    const showMediaDialog = ref(false);
    const mediaTarget = ref('cover'); // 'cover', 'inline', 'ad'
    const selectAdImageIndex = ref(-1);
    const mediaFiles = ref([]);
    const loadingMedia = ref(false);
    const mediaSearchQuery = ref('');
    const selectedMediaFile = ref(null);
    const isUploading = ref(false);
    const fileInput = ref(null);
    
    const toastMessage = ref('');
    const offlineDrafts = ref([]);
    const showOfflineDraftsDialog = ref(false);

    const scanOfflineDrafts = () => {
      const drafts = [];
      for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key.startsWith('voda_article_backup_')) {
          try {
            const data = JSON.parse(localStorage.getItem(key));
            drafts.push({
              key,
              title: data.title || '(Tanpa Judul)',
              contentSnippet: data.content ? data.content.replace(/<[^>]*>?/gm, '').substring(0, 50) + '...' : 'Tidak ada konten'
            });
          } catch(e) {
            console.error(e);
          }
        }
      }
      offlineDrafts.value = drafts;
    };
    let tocSyncTimeout = null;
    let cannibalTimeout = null;

    // Link Modal State
    const showLinkModal = ref(false);
    const linkUrlInput = ref(null);
    const linkModal = reactive({
      url: '',
      text: '',
      target: '_blank',
      relNofollow: false,
      relNoopener: true,
      relSponsored: false,
      relUgc: false,
      hasSelection: false,
      isEditing: false,
      showAdvanced: false,
      urlError: '',
    });

    // ===== Slash Command State =====
    const showSlashMenu = ref(false);
    const slashQuery = ref('');
    const slashMenuPos = reactive({ x: 0, y: 0 });
    const slashMenuIndex = ref(0);
    const slashMenuListRef = ref(null);
    let slashStartPos = null;

    // ===== YouTube Modal State =====
    const showYoutubeModal = ref(false);
    const youtubeUrlVal = ref('');
    const youtubeUrlError = ref('');
    const youtubeInputRef = ref(null);

    // ===== Slash Command TipTap Extension (defined here to close over reactive state) =====
    const SlashCommandExtension = Extension.create({
      name: 'slashCommand',
      addKeyboardShortcuts() {
        return {
          Escape: () => {
            if (showSlashMenu.value) { showSlashMenu.value = false; slashStartPos = null; return true; }
            return false;
          },
          ArrowDown: () => {
            if (!showSlashMenu.value) return false;
            const len = filteredSlashCommands.value.length;
            if (len === 0) return true;
            slashMenuIndex.value = (slashMenuIndex.value + 1) % len;
            nextTick(() => scrollSlashItem());
            return true;
          },
          ArrowUp: () => {
            if (!showSlashMenu.value) return false;
            const len = filteredSlashCommands.value.length;
            if (len === 0) return true;
            slashMenuIndex.value = (slashMenuIndex.value - 1 + len) % len;
            nextTick(() => scrollSlashItem());
            return true;
          },
          Enter: () => {
            if (showSlashMenu.value && filteredSlashCommands.value.length > 0) {
              executeSlashCommand(filteredSlashCommands.value[slashMenuIndex.value]);
              return true;
            }
            return false;
          },
        };
      },
      onUpdate() {
        const { state } = this.editor;
        const { selection } = state;
        const { $from } = selection;
        if ($from.parent.type.name !== 'paragraph') {
          if (showSlashMenu.value) { showSlashMenu.value = false; slashStartPos = null; }
          return;
        }
        const lineText = $from.parent.textContent;
        if (lineText.startsWith('/')) {
          slashQuery.value = lineText.slice(1);
          slashMenuIndex.value = 0;
          slashStartPos = $from.start();
          try {
            const coords = this.editor.view.coordsAtPos(selection.from);
            slashMenuPos.x = coords.left;
            slashMenuPos.y = coords.bottom + 6;
          } catch (e) {}
          showSlashMenu.value = true;
        } else {
          if (showSlashMenu.value) { showSlashMenu.value = false; slashStartPos = null; }
        }
      },
    });

    // Auto-save State
    const autoSaveStatus = ref('saved'); // 'saved' | 'unsaved' | 'saving'
    let autoSaveTimer = null;

    // TipTap Editor
    const editor = useEditor({
      extensions: [
        StarterKit.configure({
          heading: false, // Gunakan CustomHeading
        }),
        CustomHeading.configure({
          levels: [1, 2, 3, 4, 5, 6],
        }),
        Underline,
        Highlight.configure({ multicolor: false }),
        Subscript,
        Superscript,
        CharacterCount,
        TextAlign.configure({
          types: ['heading', 'paragraph', 'imageResize'],
        }),
        Link.configure({
          openOnClick: false,
          autolink: true,
        }),
        ImageResize.configure({
          allowBase64: true,
        }),
        Figure,
        Figcaption.configure({
          placeholder: 'Tulis caption gambar di sini...',
        }),
        Placeholder.configure({
          placeholder: 'Ketik \'/\' untuk menu perintah, atau mulai mengetik...',
          emptyEditorClass: 'is-editor-empty',
        }),
        Table.configure({
          resizable: false,
        }),
        TableRow,
        TableHeader,
        TableCell,
        TableOfContentsNode,
        YouTubeNode,
        SlashCommandExtension,
      ],
      content: '',
      onUpdate: () => {
        if (currentArticle.value) {
          currentArticle.value.content = editor.value.getHTML();
          runSeoAnalysis();
          syncTocAndHeadings();
        }
      }
    });

    // Sync TOC Headings & Assign ID otomatis ke H2 / H3
    const syncTocAndHeadings = () => {
      if (!editor.value || !editor.value.state) return;
      if (tocSyncTimeout) clearTimeout(tocSyncTimeout);
      
      tocSyncTimeout = setTimeout(() => {
        const { doc, tr } = editor.value.state;
        const headings = [];
        let modified = false;
        
        doc.descendants((node, pos) => {
          if (node.type.name === 'heading' && (node.attrs.level === 2 || node.attrs.level === 3)) {
            const text = node.textContent;
            const id = `heading-${headings.length}`;
            if (node.attrs.id !== id) {
              tr.setNodeMarkup(pos, undefined, { ...node.attrs, id });
              modified = true;
            }
            headings.push({ text, level: node.attrs.level, id });
          }
        });

        doc.descendants((node, pos) => {
          if (node.type.name === 'tableOfContents') {
            const currentHeadings = node.attrs.headings || [];
            const isSame = currentHeadings.length === headings.length && 
              currentHeadings.every((h, i) => h.text === headings[i].text && h.level === headings[i].level && h.id === headings[i].id);
            if (!isSame) {
              tr.setNodeMarkup(pos, undefined, { ...node.attrs, headings });
              modified = true;
            }
          }
        });

        if (modified) {
          editor.value.view.dispatch(tr);
        }
      }, 150);
    };

    // Left Toolbox Categories (Lengkap Sekali & Informatif)
    const toolboxCategories = computed(() => [
      {
        name: 'Teks & Paragraf',
        items: [
          { id: 'p', title: 'Paragraf', desc: 'Teks standar untuk menulis konten', icon: 'notes', action: () => editor.value.chain().focus().setParagraph().run() },
          { id: 'h2', title: 'Heading 2 (H2)', desc: 'Subjudul utama untuk bagian penting', icon: 'title', action: () => editor.value.chain().focus().toggleHeading({ level: 2 }).run() },
          { id: 'h3', title: 'Heading 3 (H3)', desc: 'Sub-bagian di bawah H2', icon: 'title', action: () => editor.value.chain().focus().toggleHeading({ level: 3 }).run() },
          { id: 'h4', title: 'Heading 4 (H4)', desc: 'Sub-bagian detail lanjutan', icon: 'title', action: () => editor.value.chain().focus().toggleHeading({ level: 4 }).run() }
        ]
      },
      {
        name: 'Struktur & Daftar',
        items: [
          { id: 'bullet', title: 'Daftar Poin', desc: 'Daftar berbaris dengan simbol bullet', icon: 'format_list_bulleted', action: () => editor.value.chain().focus().toggleBulletList().run() },
          { id: 'ordered', title: 'Daftar Angka', desc: 'Daftar berurutan dengan nomor urut', icon: 'format_list_numbered', action: () => editor.value.chain().focus().toggleOrderedList().run() },
          { id: 'quote', title: 'Kutipan', desc: 'Teks kutipan atau highlight khusus', icon: 'format_quote', action: () => editor.value.chain().focus().toggleBlockquote().run() },
          { id: 'code', title: 'Blok Kode', desc: 'Teks atau skrip pemrograman', icon: 'code', action: () => editor.value.chain().focus().toggleCodeBlock().run() },
          { id: 'hr', title: 'Garis Pembatas', desc: 'Garis horizontal pemisah topik', icon: 'horizontal_rule', action: () => editor.value.chain().focus().setHorizontalRule().run() }
        ]
      },
      {
        name: 'Media, Tabel & Navigasi',
        items: [
          { id: 'toc', title: 'Daftar Isi (TOC)', desc: 'Navigasi otomatis berdasar H2 dan H3', icon: 'toc', action: () => insertToc() },
          { id: 'image', title: 'Gambar', desc: 'Pilih atau unggah dari Directus Library', icon: 'image', action: () => openMediaDialog('inline') },
          { id: 'table', title: 'Tabel 3x3', desc: 'Tabel data dengan baris dan kolom', icon: 'table_chart', action: () => editor.value.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run() },
          { id: 'tbl-col', title: 'Tambah Kolom Tabel', desc: 'Sisipkan kolom baru di sisi kanan', icon: 'add_box', action: () => editor.value.chain().focus().addColumnAfter().run() },
          { id: 'tbl-row', title: 'Tambah Baris Tabel', desc: 'Sisipkan baris baru di bagian bawah', icon: 'add_box', action: () => editor.value.chain().focus().addRowAfter().run() },
          { id: 'tbl-del', title: 'Hapus Tabel', desc: 'Hapus tabel yang sedang dipilih', icon: 'delete', action: () => editor.value.chain().focus().deleteTable().run() },
          { id: 'youtube', title: 'YouTube Embed', desc: 'Sisipkan video YouTube ke dalam artikel', icon: 'smart_display', action: () => openYoutubeModal() }
        ]
      }
    ]);

    const filteredToolboxCategories = computed(() => {
      if (!toolboxSearch.value) return toolboxCategories.value;
      const q = toolboxSearch.value.toLowerCase();
      return toolboxCategories.value.map(cat => ({
        ...cat,
        items: cat.items.filter(i => i.title.toLowerCase().includes(q) || i.desc.toLowerCase().includes(q))
      })).filter(cat => cat.items.length > 0);
    });

    // Ads Data
    const ads = ref([]);

    // SEO Data
    const keywordsList = ref([]);
    const newKeyword = ref('');
    const cannibalizedCount = ref(0);

    const seoResults = reactive({
      basic: [],
      keyword: [],
      readability: []
    });

    const seoScore = ref(0);

    const circumference = 2 * Math.PI * 24;
    const offset = computed(() => {
      return circumference - (seoScore.value / 100) * circumference;
    });

    const scoreColor = computed(() => {
      if (seoScore.value >= 80) return '#00C853';
      if (seoScore.value >= 50) return '#FF9800';
      return '#FF5252';
    });
    
    const scoreLabel = computed(() => {
      if (seoScore.value >= 80) return 'Bagus';
      if (seoScore.value >= 50) return 'Perlu Perbaikan';
      return 'Buruk';
    });

    // Lifecycle
    onMounted(() => {
      scanOfflineDrafts();
      fetchArticles();
      fetchPillars();
    });
    
    onUnmounted(() => {
      if (tocSyncTimeout) clearTimeout(tocSyncTimeout);
      if (cannibalTimeout) clearTimeout(cannibalTimeout);
      if (autoSaveTimer) clearTimeout(autoSaveTimer);
      if (editor.value) {
        editor.value.destroy();
      }
    });

    // Computed
    const currentPage = ref(1);
    const itemsPerPage = ref(10);
    watch([searchQuery, activeFilter], () => { currentPage.value = 1; });

    const filteredArticles = computed(() => {
      let list = articles.value;
      if (activeFilter.value !== 'all') {
        list = list.filter(a => a.status === activeFilter.value);
      }
      if (searchQuery.value) {
        const q = searchQuery.value.toLowerCase();
        list = list.filter(a => 
          (a.title || '').toLowerCase().includes(q) || 
          (a.SEO?.focus_keyword || '').toLowerCase().includes(q)
        );
      }
      return list;
    });

    const totalPages = computed(() => Math.ceil(filteredArticles.value.length / itemsPerPage.value) || 1);
    const paginatedArticles = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage.value;
      return filteredArticles.value.slice(start, start + itemsPerPage.value);
    });

    const filteredMediaFiles = computed(() => {
      if (!mediaSearchQuery.value) return mediaFiles.value;
      const q = mediaSearchQuery.value.toLowerCase();
      return mediaFiles.value.filter(f => 
        (f.title || '').toLowerCase().includes(q) || 
        (f.filename_download || '').toLowerCase().includes(q)
      );
    });

    const pillarOptions = computed(() => {
      return pillarArticles.value
        .filter(p => !currentArticle.value || p.id !== currentArticle.value.id)
        .map(p => ({ text: p.title, value: p.id }));
    });

    const currentChecks = computed(() => {
      return seoResults[checkTab.value] || [];
    });

    // Reusable Full SEO Calculation Helper (Agar 100% konsisten & akurat di tabel maupun editor)
    const computeFullSeoScore = (art, fk = '', sks = [], cannibalCount = 0) => {
      const title = art.SEO?.title || '';
      const desc = art.SEO?.metaDescription || '';
      const content = art.content || '';
      const slug = art.slug || '';
      const docTitle = art.title || '';
      
      const fkLower = fk ? fk.toLowerCase() : '';
      const sksLower = sks.map(k => k.toLowerCase().trim());

      const powerWords = ['terbaik', 'rahasia', 'panduan', 'lengkap', 'mudah', 'cepat', 'gratis', 'terbaru', 'murah', 'tips', 'trik', 'terpercaya', 'top', 'rekomendasi', 'promo', 'diskon'];
      const transWords = ['namun', 'oleh karena itu', 'selain itu', 'sehingga', 'dengan demikian', 'sementara itu', 'walaupun demikian', 'akan tetapi', 'selanjutnya', 'kemudian', 'bahkan', 'sebaliknya', 'karena itu', 'oleh sebab itu', 'tambahan pula', 'lebih lanjut', 'sebagai contoh', 'misalnya'];

      const contentLower = content.toLowerCase();
      const plainText = content.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
      const words = plainText.split(' ').filter(w => w.length > 0);
      const wordCount = words.length;

      let pts = 0;
      let total = 0;
      const results = { basic: [], keyword: [], readability: [] };

      const addRes = (cat, id, status, text) => {
        results[cat].push({ id, status, text });
        total += 1;
        if (status === 'green') pts += 1;
        else if (status === 'orange') pts += 0.5;
      };

      // DASAR
      if (title.length === 0) addRes('basic', 'title-len', 'red', 'SEO Title belum diisi');
      else if (title.length >= 30 && title.length <= 60) addRes('basic', 'title-len', 'green', `SEO Title optimal (${title.length}/60 karakter)`);
      else addRes('basic', 'title-len', 'orange', `Panjang SEO Title tidak optimal (${title.length} karakter), disarankan 30 - 60 karakter`);

      if (desc.length === 0) addRes('basic', 'desc-len', 'red', 'Meta Description belum diisi');
      else if (desc.length >= 120 && desc.length <= 160) addRes('basic', 'desc-len', 'green', `Meta Description optimal (${desc.length}/160 karakter)`);
      else addRes('basic', 'desc-len', 'orange', `Panjang Meta Description tidak optimal (${desc.length} karakter), disarankan 120 - 160 karakter`);

      const hasPower = powerWords.some(w => docTitle.toLowerCase().includes(w));
      if (hasPower) addRes('basic', 'title-power', 'green', 'Title mengandung Power Word / Sentiment (meningkatkan CTR Google)');
      else addRes('basic', 'title-power', 'orange', 'Tambahkan Power Word (seperti "Terbaik", "Panduan", dll) pada Title');

      if (/\d/.test(docTitle)) addRes('basic', 'title-number', 'green', 'Title mengandung angka');
      else addRes('basic', 'title-number', 'orange', 'Gunakan angka pada Title untuk CTR yang lebih baik');

      if (/[-|]/.test(docTitle)) addRes('basic', 'title-sep', 'green', 'Title menggunakan pemisah brand (| atau -)');
      else addRes('basic', 'title-sep', 'orange', 'Gunakan pemisah seperti | atau - untuk nama brand di Title');

      if (slug.length < 75 && slug.length > 0) addRes('basic', 'url-length', 'green', 'URL / Slug cukup pendek dan ringkas');
      else addRes('basic', 'url-length', 'orange', 'URL / Slug terlalu panjang, buat lebih ringkas tanpa stop words');

      // KEYWORDS
      if (!fkLower) {
        addRes('keyword', 'kw-set', 'red', 'Focus Keyword utama belum diisi');
      } else {
        addRes('keyword', 'kw-set', 'green', `Focus Keyword Utama: "${fk}"`);
        
        if (cannibalCount > 0) addRes('keyword', 'kw-cannibal', 'red', `Keyword Cannibalization! Focus keyword ini sudah dipakai di ${cannibalCount} artikel lain.`);
        else addRes('keyword', 'kw-cannibal', 'green', 'Focus keyword unik, tidak terjadi cannibalization dengan artikel lain.');

        const fullTitle = (docTitle + ' ' + title).toLowerCase();
        if (fullTitle.includes(fkLower)) {
          if (fullTitle.startsWith(fkLower)) addRes('keyword', 'kw-title-start', 'green', 'Focus keyword berada tepat di awal Title');
          else addRes('keyword', 'kw-title', 'green', 'Title mengandung Focus keyword');
        } else {
          addRes('keyword', 'kw-title', 'red', 'Title tidak mengandung Focus keyword utama');
        }

        if (desc.toLowerCase().includes(fkLower)) addRes('keyword', 'kw-desc', 'green', 'Meta Description mengandung Focus keyword');
        else addRes('keyword', 'kw-desc', 'orange', 'Meta Description tidak mengandung Focus keyword');

        const fkSlug = fkLower.replace(/\s+/g, '-');
        if (slug.includes(fkSlug)) addRes('keyword', 'kw-url', 'green', 'URL / Slug mengandung Focus keyword');
        else addRes('keyword', 'kw-url', 'orange', 'URL / Slug tidak mengandung Focus keyword');

        const first10 = words.slice(0, Math.max(10, Math.floor(wordCount * 0.1))).join(' ');
        if (first10.includes(fkLower)) addRes('keyword', 'kw-first-para', 'green', 'Focus keyword muncul di paragraf 10% awal konten');
        else addRes('keyword', 'kw-first-para', 'orange', 'Focus keyword tidak ditemukan di awal konten');

        const fkCount = (plainText.toLowerCase().match(new RegExp(fkLower, 'g')) || []).length;
        const density = wordCount > 0 ? (fkCount / wordCount) * 100 : 0;
        if (density >= 0.5 && density <= 2.5) addRes('keyword', 'kw-content', 'green', `Keyword density optimal (${density.toFixed(1)}%)`);
        else if (density > 2.5) addRes('keyword', 'kw-content', 'red', `Keyword density terlalu tinggi (${density.toFixed(1)}%), bahaya indikasi stuffing`);
        else addRes('keyword', 'kw-content', 'orange', `Keyword density terlalu rendah (${density.toFixed(1)}%)`);

        const headings = contentLower.match(/<h[2-6][^>]*>(.*?)<\/h[2-6]>/g) || [];
        if (headings.some(h => h.includes(fkLower))) addRes('keyword', 'content-heading-kw', 'green', 'Subheading (H2/H3) mengandung Focus keyword');
        else addRes('keyword', 'content-heading-kw', 'orange', 'Subheading (H2/H3) belum mengandung Focus keyword');

        const imgs = contentLower.match(/<img[^>]+alt="([^"]*)"/g) || [];
        if (imgs.some(i => i.includes(fkLower))) addRes('keyword', 'content-image-alt', 'green', 'Atribut alt gambar mengandung Focus keyword');
        else addRes('keyword', 'content-image-alt', 'orange', 'Atribut alt gambar belum mengandung Focus keyword');
      }

      if (sksLower.length === 0) {
        addRes('keyword', 'sec-kw', 'orange', 'Tambahkan Secondary Keywords (LSI) untuk cakupan pencarian yang lebih luas');
      } else {
        const found = sksLower.filter(k => contentLower.includes(k));
        if (found.length === sksLower.length) addRes('keyword', 'sec-kw', 'green', 'Semua Secondary Keywords ditemukan di dalam konten artikel');
        else if (found.length > 0) addRes('keyword', 'sec-kw', 'orange', `Beberapa Secondary Keywords (${found.length}/${sksLower.length}) ditemukan di dalam konten`);
        else addRes('keyword', 'sec-kw', 'red', 'Secondary Keywords belum ditemukan di dalam konten');
      }

      // KETERBACAAN
      if (wordCount === 0) addRes('readability', 'content-len', 'red', 'Konten artikel masih kosong');
      else if (wordCount >= 600) addRes('readability', 'content-len', 'green', `Panjang konten sangat baik (${wordCount} kata)`);
      else if (wordCount >= 300) addRes('readability', 'content-len', 'orange', `Panjang konten cukup (${wordCount} kata), disarankan ≥ 600 kata untuk SEO mendalam`);
      else addRes('readability', 'content-len', 'red', `Konten terlalu pendek (${wordCount} kata), minimal 300 kata`);

      const paras = content.match(/<p>([\s\S]*?)<\/p>/g) || [];
      const longParas = paras.filter(p => p.split(' ').length > 150);
      if (longParas.length === 0) addRes('readability', 'para-len', 'green', 'Panjang paragraf baik (tidak ada yang > 150 kata)');
      else addRes('readability', 'para-len', 'orange', `Ada ${longParas.length} paragraf yang terlalu panjang (> 150 kata), pecah menjadi beberapa paragraf agar mudah dibaca`);

      const sentences = plainText.split(/[.!?]+/).filter(s => s.trim().length > 0);
      const longSentences = sentences.filter(s => s.trim().split(' ').length > 20);
      const longPct = sentences.length > 0 ? (longSentences.length / sentences.length) * 100 : 0;
      if (longPct <= 25) addRes('readability', 'read-sentence', 'green', `Panjang kalimat sangat baik (${longPct.toFixed(0)}% > 20 kata, maksimal 25%)`);
      else addRes('readability', 'read-sentence', 'orange', `Terlalu banyak kalimat panjang (${longPct.toFixed(0)}% > 20 kata, maksimal 25%), ringkas agar pembaca tidak lelah`);

      let transCount = 0;
      sentences.forEach(s => {
        const sl = s.toLowerCase();
        if (transWords.some(t => sl.includes(t))) transCount++;
      });
      const transPct = sentences.length > 0 ? (transCount / sentences.length) * 100 : 0;
      if (transPct >= 30) addRes('readability', 'read-trans', 'green', `Penggunaan transition words baik (${transPct.toFixed(0)}%)`);
      else addRes('readability', 'read-trans', 'orange', `Tambahkan kata penghubung/transition words (${transPct.toFixed(0)}%, disarankan ≥ 30%) seperti "oleh karena itu", "selain itu", dll`);

      if (contentLower.includes('data-type="toc"') || contentLower.includes('daftar isi') || contentLower.includes('table of content') || contentLower.includes('href="#')) {
        addRes('readability', 'read-toc', 'green', 'Table of Contents (Daftar Isi) terdeteksi untuk memudahkan navigasi pembaca');
      } else {
        addRes('readability', 'read-toc', 'orange', 'Tambahkan blok Daftar Isi (TOC) menggunakan tombol di toolbar atau ketik /toc');
      }

      if (/<h[2-3]/.test(contentLower)) addRes('readability', 'content-heading', 'green', 'Menggunakan struktur subheading (H2/H3) yang teratur');
      else addRes('readability', 'content-heading', 'orange', 'Tambahkan subheading (H2/H3) untuk membagi topik dan paragraf');

      if (/<img|type:image/.test(contentLower)) addRes('readability', 'content-image', 'green', 'Konten sudah memiliki media gambar ilustrasi');
      else addRes('readability', 'content-image', 'orange', 'Tambahkan gambar atau ilustrasi visual ke dalam konten agar lebih menarik');

      const links = contentLower.match(/href="([^"]*)"/g) || [];
      const internal = links.some(l => l.includes('href="/') || l.includes('vodatrip.id'));
      const external = links.some(l => l.includes('href="http') && !l.includes('vodatrip.id'));

      if (internal) addRes('readability', 'link-internal', 'green', 'Memiliki internal link ke halaman lain');
      else addRes('readability', 'link-internal', 'orange', 'Tambahkan internal link yang mengarah ke artikel atau paket wisata terkait');

      if (external) addRes('readability', 'link-external', 'green', 'Memiliki outbound/external link ke referensi luar');
      else addRes('readability', 'link-external', 'orange', 'Tambahkan external link ke sumber referensi terpercaya eksternal');

      const score = total > 0 ? Math.round((pts / total) * 100) : 0;
      let label = 'Buruk';
      let color = 'red';
      if (score >= 80) { label = 'Bagus'; color = 'green'; }
      else if (score >= 50) { label = 'Perlu Perbaikan'; color = 'orange'; }

      return { score, label, color, results };
    };

    // Methods
    const showToast = (msg) => {
      toastMessage.value = msg;
      setTimeout(() => { toastMessage.value = ''; }, 3500);
    };

    const fetchArticles = async () => {
      loading.value = true;
      try {
        const res = await api.get('/items/articles', {
          params: { sort: '-date_created', fields: 'id,title,slug,status,publish_date,featured_image,is_pillar,SEO,content' }
        });
        articles.value = res.data.data.map(art => {
          let seoObj = art.SEO;
          if (typeof seoObj === 'string') {
            try { seoObj = JSON.parse(seoObj); } catch(e) { seoObj = {}; }
          } else if (!seoObj) {
            seoObj = {};
          }
          art.SEO = seoObj;

          const fk = seoObj.focus_keyword || '';
          const sks = seoObj.secondary_keywords ? seoObj.secondary_keywords.split(',').map(s => s.trim()).filter(s => s) : [];
          const { score, label, color } = computeFullSeoScore(art, fk, sks, 0);

          return {
            ...art,
            computedSeoScore: score,
            computedSeoLabel: label,
            computedSeoColor: color
          };
        });
      } catch (err) {
        console.error('Error fetching articles', err);
      }
      loading.value = false;
    };

    const fetchPillars = async () => {
      try {
        const res = await api.get('/items/articles', {
          params: { filter: { is_pillar: { _eq: true } }, fields: 'id,title' }
        });
        pillarArticles.value = res.data.data;
      } catch (err) {
        console.error('Error fetching pillars', err);
      }
    };

    const createNew = (skipRecovery = false) => {
      currentArticle.value = {
        id: null,
        title: '',
        slug: '',
        content: '',
        status: 'draft',
        publish_date: new Date().toISOString().slice(0, 16),
        featured_image: null,
        is_pillar: false,
        pillar_parent: null,
        SEO: { title: '', metaDescription: '', focus_keyword: '', secondary_keywords: '' }
      };
      
      if (!skipRecovery) {
        const localBackup = localStorage.getItem('voda_article_backup_new');
        if (localBackup) {
          try {
            const parsedBackup = JSON.parse(localBackup);
            Object.assign(currentArticle.value, parsedBackup);
            showToast('⚠️ Memulihkan draf baru yang belum sempat tersimpan.');
          } catch(e) {
            localStorage.removeItem('voda_article_backup_new');
          }
        }
      }

      const fk = currentArticle.value.SEO.focus_keyword || '';
      const sk = currentArticle.value.SEO.secondary_keywords ? currentArticle.value.SEO.secondary_keywords.split(',').map(s=>s.trim()).filter(s=>s) : [];
      const kws = [];
      if (fk) kws.push(fk);
      keywordsList.value = [...kws, ...sk];
      
      ads.value = [];
      nextTick(() => {
        editor.value.commands.setContent(currentArticle.value.content || '');
        runSeoAnalysis();
      });
    };

    const handleCreateClick = () => {
      scanOfflineDrafts();
      if (offlineDrafts.value.length > 0) {
        showOfflineDraftsDialog.value = true;
      } else {
        createNew();
      }
    };

    const createNewBlank = () => {
      showOfflineDraftsDialog.value = false;
      createNew(true);
    };

    const deleteOfflineDraft = (key) => {
      localStorage.removeItem(key);
      scanOfflineDrafts();
      if (offlineDrafts.value.length === 0) {
        showOfflineDraftsDialog.value = false;
      }
    };

    const restoreOfflineDraft = (key) => {
      showOfflineDraftsDialog.value = false;
      const localBackup = localStorage.getItem(key);
      try {
        const parsedBackup = JSON.parse(localBackup);
        
        currentArticle.value = {
          id: null,
          title: '',
          slug: '',
          content: '',
          status: 'draft',
          publish_date: new Date().toISOString().slice(0, 16),
          featured_image: null,
          is_pillar: false,
          pillar_parent: null,
          SEO: { title: '', metaDescription: '', focus_keyword: '', secondary_keywords: '' }
        };
        
        Object.assign(currentArticle.value, parsedBackup);
        currentArticle.value.id = null; // Strip ID so it saves as new
        
        const fk = currentArticle.value.SEO.focus_keyword || '';
        const sk = currentArticle.value.SEO.secondary_keywords ? currentArticle.value.SEO.secondary_keywords.split(',').map(s=>s.trim()).filter(s=>s) : [];
        const kws = [];
        if (fk) kws.push(fk);
        keywordsList.value = [...kws, ...sk];
        
        ads.value = [];
        nextTick(() => {
          editor.value.commands.setContent(currentArticle.value.content || '');
          runSeoAnalysis();
        });
        
        showToast('⚠️ Draf offline dimuat sebagai artikel baru.');
        localStorage.removeItem(key);
        scanOfflineDrafts();
      } catch(e) {
        showToast('❌ Gagal memuat draf.');
      }
    };


    const editArticle = async (articleStub) => {
      try {
        const res = await api.get(`/items/articles/${articleStub.id}`, {
          params: { fields: '*' }
        });
        const art = res.data.data;
        if (!art.SEO) art.SEO = { title: '', metaDescription: '', focus_keyword: '', secondary_keywords: '' };
        else if (typeof art.SEO === 'string') {
          try { art.SEO = JSON.parse(art.SEO); } catch(e) { art.SEO = { title: '', metaDescription: '', focus_keyword: '', secondary_keywords: '' }; }
        }
        
        let featImg = art.featured_image;
        if (featImg && typeof featImg === 'object' && featImg.id) featImg = featImg.id;

        let pilParent = art.pillar_parent;
        if (pilParent && typeof pilParent === 'object' && pilParent.id) pilParent = pilParent.id;
        
        currentArticle.value = {
          ...art,
          featured_image: featImg,
          pillar_parent: pilParent,
          publish_date: art.publish_date ? art.publish_date.slice(0, 16) : ''
        };
        
        // Cek LocalStorage Fallback (Offline Backup)
        const localBackup = localStorage.getItem(`voda_article_backup_${art.id}`);
        if (localBackup) {
          try {
            const parsedBackup = JSON.parse(localBackup);
            Object.assign(currentArticle.value, parsedBackup);
            // Timpa referensi 'art' agar editor dan keywords ikut menyesuaikan
            Object.assign(art, parsedBackup);
            showToast('⚠️ Memulihkan draf lokal karena sebelumnya internet terputus.');
          } catch(e) {
            localStorage.removeItem(`voda_article_backup_${art.id}`);
          }
        }
        
        // Parse Keywords
        const fk = art.SEO.focus_keyword || '';
        const sk = art.SEO.secondary_keywords ? art.SEO.secondary_keywords.split(',').map(s=>s.trim()).filter(s=>s) : [];
        const kws = [];
        if (fk) kws.push(fk);
        keywordsList.value = [...kws, ...sk];

        // Fetch Ads
        const adsRes = await api.get('/items/ads', {
          params: { filter: { articles_id: { _eq: art.id } } }
        });
        ads.value = adsRes.data.data.map(ad => ({
          ...ad,
          image: (ad.image && typeof ad.image === 'object' && ad.image.id) ? ad.image.id : ad.image
        }));

        nextTick(() => {
          editor.value.commands.setContent(art.content || '');
          runSeoAnalysis();
          checkCannibalization();
          setTimeout(() => syncTocAndHeadings(), 300);
        });
      } catch (err) {
        console.error('Error loading article', err);
      }
    };

    const saveArticle = async () => {
      if (currentArticle.value.status === 'scheduled') {
        if (!currentArticle.value.publish_date) {
          showToast('❌ Tanggal jadwal harus diisi!');
          return;
        }
        const now = new Date();
        const pubDate = new Date(currentArticle.value.publish_date);
        if (pubDate < now) {
          showToast('❌ Tanggal jadwal tidak boleh kurang dari waktu sekarang!');
          return;
        }
      } else if (currentArticle.value.status === 'published') {
        currentArticle.value.publish_date = new Date().toISOString().slice(0, 16);
      }

      isSaving.value = true;
      try {
        const fk = keywordsList.value.length > 0 ? keywordsList.value[0] : '';
        const sk = keywordsList.value.length > 1 ? keywordsList.value.slice(1).join(', ') : '';
        currentArticle.value.SEO.focus_keyword = fk;
        currentArticle.value.SEO.secondary_keywords = sk;

        const payload = {
          title: currentArticle.value.title,
          slug: currentArticle.value.slug,
          content: currentArticle.value.content,
          status: currentArticle.value.status,
          publish_date: currentArticle.value.publish_date || null,
          featured_image: currentArticle.value.featured_image,
          is_pillar: currentArticle.value.is_pillar,
          pillar_parent: currentArticle.value.is_pillar ? null : currentArticle.value.pillar_parent,
          SEO: currentArticle.value.SEO
        };

        let articleId = currentArticle.value.id;

        if (articleId) {
          await api.patch(`/items/articles/${articleId}`, payload);
        } else {
          const res = await api.post('/items/articles', payload);
          articleId = res.data.data.id;
          currentArticle.value.id = articleId;
        }

        // Hapus backup lokal jika sukses tersimpan ke server
        if (articleId) {
          localStorage.removeItem(`voda_article_backup_${articleId}`);
        }

        // Save Ads
        await api.delete('/items/ads', { data: { query: { filter: { articles_id: { _eq: articleId } } } } }).catch(()=>console.log("no ads to del"));
        
        if (ads.value.length > 0) {
          const adsPayload = ads.value.map(ad => ({
            image: ad.image,
            description: ad.description,
            url: ad.url,
            articles_id: articleId
          }));
          await api.post('/items/ads', adsPayload);
        }

        showToast('✅ Artikel dan Iklan berhasil disimpan!');
        autoSaveStatus.value = 'saved';
        fetchArticles();
        fetchPillars();
      } catch (err) {
        console.error('Save error', err);
        showToast('❌ Gagal menyimpan artikel. Periksa koneksi atau data Anda.');
      }
      isSaving.value = false;
    };

    const autoSave = async () => {
      if (!currentArticle.value || autoSaveStatus.value !== 'unsaved') return;
      autoSaveStatus.value = 'saving';
      
      const payload = {
        title: currentArticle.value.title,
        slug: currentArticle.value.slug,
        content: currentArticle.value.content,
        status: currentArticle.value.status,
        featured_image: currentArticle.value.featured_image,
        SEO: currentArticle.value.SEO,
      };

      try {
        let savedId = currentArticle.value.id;
        if (savedId) {
          await api.patch(`/items/articles/${savedId}`, payload);
        } else {
          const res = await api.post('/items/articles', payload);
          savedId = res.data.data.id;
          currentArticle.value.id = savedId; // Update ID supaya kedepannya jadi PATCH
        }
        
        autoSaveStatus.value = 'saved';
        localStorage.removeItem(`voda_article_backup_${savedId || 'new'}`);
        
      } catch {
        autoSaveStatus.value = 'unsaved'; // Tetap unsaved jika gagal
        // Offline Fallback Backup
        const backupId = currentArticle.value.id || 'new';
        localStorage.setItem(`voda_article_backup_${backupId}`, JSON.stringify(payload));
      }
    };

    const triggerAutoSave = () => {
      if (!currentArticle.value) return;
      autoSaveStatus.value = 'unsaved';
      if (autoSaveTimer) clearTimeout(autoSaveTimer);
      autoSaveTimer = setTimeout(() => autoSave(), 30000);
    };

    watch(currentArticle, (newVal, oldVal) => {
      // Hanya trigger auto-save jika ini bukan load awal (oldVal !== null)
      if (newVal && oldVal) {
        triggerAutoSave();
      }
    }, { deep: true });

    // Duplikasi Artikel (Salin sebagai Draft Baru)
    const duplicateArticle = async (art) => {
      try {
        const res = await api.get(`/items/articles/${art.id}`, {
          params: { fields: 'title,slug,content,featured_image,is_pillar,pillar_parent,SEO' }
        });
        const src = res.data.data;
        const payload = {
          title: `${src.title} (Salinan)`,
          slug: `${src.slug}-salinan-${Date.now()}`,
          content: src.content || '',
          status: 'draft',
          featured_image: src.featured_image || null,
          is_pillar: false,
          SEO: src.SEO || {},
        };
        await api.post('/items/articles', payload);
        showToast('✅ Artikel berhasil diduplikasi sebagai Draft!');
        fetchArticles();
      } catch (err) {
        console.error('Duplicate error', err);
        showToast('❌ Gagal menduplikasi artikel.');
      }
    };

    const closeEditor = () => {
      currentArticle.value = null;
    };

    const confirmDelete = (article) => {
      articleToDelete.value = article;
      showDeleteDialog.value = true;
    };

    const executeDelete = async () => {
      if (!articleToDelete.value) return;
      try {
        await api.delete(`/items/articles/${articleToDelete.value.id}`);
        showToast('Artikel berhasil dihapus permanen!');
        fetchArticles();
      } catch (err) {
        console.error('Delete error', err);
        showToast('Gagal menghapus artikel.');
      }
      showDeleteDialog.value = false;
      articleToDelete.value = null;
    };

    const generateSlug = () => {
      if (!currentArticle.value.slug && currentArticle.value.title) {
        currentArticle.value.slug = currentArticle.value.title
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, '-')
          .replace(/(^-|-$)+/g, '');
      }
    };

    const formatDate = (dateString) => {
      if (!dateString) return '-';
      const d = new Date(dateString);
      return d.toLocaleDateString('id-ID', { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
    };

    const getImageSrc = (imgId) => {
      if (!imgId) return '';
      const id = (typeof imgId === 'object' && imgId.id) ? imgId.id : imgId;
      return `/assets/${id}?format=webp&quality=80`;
    };

    // Directus Media Library Methods
    const openMediaDialog = async (target, adIndex = -1) => {
      mediaTarget.value = target;
      if (target === 'ad') selectAdImageIndex.value = adIndex;
      selectedMediaFile.value = null;
      mediaSearchQuery.value = '';
      showMediaDialog.value = true;
      
      loadingMedia.value = true;
      try {
        const res = await api.get('/files', {
          params: {
            limit: 100,
            sort: '-created_on',
            filter: { type: { _contains: 'image' } },
            fields: 'id,title,filename_download,created_on'
          }
        });
        mediaFiles.value = res.data.data;
        if (target === 'cover' && currentArticle.value.featured_image) {
          const featId = typeof currentArticle.value.featured_image === 'object' ? currentArticle.value.featured_image.id : currentArticle.value.featured_image;
          selectedMediaFile.value = mediaFiles.value.find(f => f.id === featId) || null;
        }
      } catch (err) {
        console.error('Error loading media library', err);
        showToast('Gagal memuat koleksi Media Library Directus.');
      }
      loadingMedia.value = false;
    };

    const confirmMediaSelect = () => {
      if (!selectedMediaFile.value) return;
      const fileId = selectedMediaFile.value.id;
      if (mediaTarget.value === 'cover') {
        currentArticle.value.featured_image = fileId;
      } else if (mediaTarget.value === 'inline') {
        editor.value.chain().focus().setImage({ src: `/assets/${fileId}?format=webp&quality=80` }).run();
      } else if (mediaTarget.value === 'ad' && selectAdImageIndex.value >= 0) {
        ads.value[selectAdImageIndex.value].image = fileId;
      }
      showMediaDialog.value = false;
      selectedMediaFile.value = null;
      showToast('Gambar berhasil diterapkan!');
    };

    const handleFileUpload = async (event) => {
      const file = event.target.files[0];
      if (!file) return;
      isUploading.value = true;
      const formData = new FormData();
      formData.append('file', file);
      try {
        const res = await api.post('/files', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        const newFile = res.data.data;
        mediaFiles.value.unshift(newFile);
        selectedMediaFile.value = newFile;
        confirmMediaSelect();
      } catch (err) {
        console.error('Upload error', err);
        showToast('Gagal mengunggah gambar baru dari komputer.');
      }
      isUploading.value = false;
      if (event.target) event.target.value = '';
    };

    // Link Modal Methods
    const setLink = () => {
      if (!editor.value) return;
      const { state } = editor.value;
      const { selection } = state;
      const isActive = editor.value.isActive('link');
      const hasSelection = !selection.empty;

      if (isActive) {
        // Editing existing link
        const attrs = editor.value.getAttributes('link');
        const rel = attrs.rel || '';
        linkModal.url = attrs.href || '';
        linkModal.target = attrs.target || '_blank';
        linkModal.relNofollow = rel.includes('nofollow');
        linkModal.relNoopener = rel.includes('noopener');
        linkModal.relSponsored = rel.includes('sponsored');
        linkModal.relUgc = rel.includes('ugc');
        linkModal.isEditing = true;
      } else {
        // New link
        linkModal.url = '';
        linkModal.text = '';
        linkModal.target = '_blank';
        linkModal.relNofollow = false;
        linkModal.relNoopener = true;
        linkModal.relSponsored = false;
        linkModal.relUgc = false;
        linkModal.isEditing = false;
      }

      linkModal.hasSelection = hasSelection;
      linkModal.urlError = '';
      linkModal.showAdvanced = false;
      showLinkModal.value = true;

      // Auto-focus input after render
      setTimeout(() => {
        if (linkUrlInput.value) linkUrlInput.value.focus();
      }, 80);
    };

    const closeLinkModal = () => {
      showLinkModal.value = false;
    };

    const buildRel = () => {
      const parts = [];
      if (linkModal.relNofollow) parts.push('nofollow');
      if (linkModal.relNoopener) parts.push('noopener');
      if (linkModal.relSponsored) parts.push('sponsored');
      if (linkModal.relUgc) parts.push('ugc');
      return parts.join(' ') || undefined;
    };

    const applyLink = () => {
      const raw = linkModal.url.trim();
      if (!raw) {
        linkModal.urlError = 'URL wajib diisi.';
        return;
      }
      // Auto-add https:// if no protocol
      const url = /^https?:\/\//i.test(raw) ? raw : `https://${raw}`;

      const rel = buildRel();
      const linkAttrs = { href: url, target: linkModal.target };
      if (rel) linkAttrs.rel = rel;

      const chain = editor.value.chain().focus().extendMarkRange('link');

      if (!linkModal.hasSelection && !linkModal.isEditing && linkModal.text.trim()) {
        // Insert new text with link mark
        chain.insertContent({
          type: 'text',
          text: linkModal.text.trim(),
          marks: [{ type: 'link', attrs: linkAttrs }],
        }).run();
      } else {
        chain.setLink(linkAttrs).run();
      }

      showLinkModal.value = false;
    };

    const removeLink = () => {
      editor.value.chain().focus().extendMarkRange('link').unsetLink().run();
      showLinkModal.value = false;
    };

    // TOC insertion shortcut
    const insertToc = () => {
      editor.value.chain().focus().insertContent({ type: 'tableOfContents' }).run();
      syncTocAndHeadings();
    };

    // ===== YouTube helpers =====
    const extractYouTubeId = (url) => {
      const m = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/);
      return m ? m[1] : null;
    };

    const openYoutubeModal = () => {
      youtubeUrlVal.value = '';
      youtubeUrlError.value = '';
      showYoutubeModal.value = true;
      nextTick(() => { if (youtubeInputRef.value) youtubeInputRef.value.focus(); });
    };

    const applyYoutube = () => {
      const raw = youtubeUrlVal.value.trim();
      if (!raw) { youtubeUrlError.value = 'URL YouTube wajib diisi.'; return; }
      const videoId = extractYouTubeId(raw);
      if (!videoId) { youtubeUrlError.value = 'URL tidak valid. Contoh: https://youtu.be/dQw4w9WgXcQ'; return; }
      editor.value.chain().focus().insertContent({ type: 'youtube', attrs: { videoId } }).run();
      showYoutubeModal.value = false;
    };

    // ===== Slash Command helpers =====
    const slashMenuCommands = computed(() => [
      { id: 'p',       label: 'Paragraf',        desc: 'Teks biasa standar',                   icon: 'notes',                action: () => editor.value.chain().focus().setParagraph().run() },
      { id: 'h2',      label: 'Heading 2',        desc: 'Judul bagian utama (H2)',               icon: 'title',                action: () => editor.value.chain().focus().toggleHeading({ level: 2 }).run() },
      { id: 'h3',      label: 'Heading 3',        desc: 'Sub-bagian (H3)',                       icon: 'title',                action: () => editor.value.chain().focus().toggleHeading({ level: 3 }).run() },
      { id: 'h4',      label: 'Heading 4',        desc: 'Sub-detail (H4)',                       icon: 'title',                action: () => editor.value.chain().focus().toggleHeading({ level: 4 }).run() },
      { id: 'bullet',  label: 'Daftar Poin',      desc: 'Bullet list tidak berurutan',           icon: 'format_list_bulleted',  action: () => editor.value.chain().focus().toggleBulletList().run() },
      { id: 'ordered', label: 'Daftar Angka',     desc: 'Numbered list berurutan',               icon: 'format_list_numbered',  action: () => editor.value.chain().focus().toggleOrderedList().run() },
      { id: 'quote',   label: 'Kutipan',          desc: 'Blockquote teks kutipan',               icon: 'format_quote',          action: () => editor.value.chain().focus().toggleBlockquote().run() },
      { id: 'code',    label: 'Blok Kode',        desc: 'Code block pemrograman',                icon: 'code',                  action: () => editor.value.chain().focus().toggleCodeBlock().run() },
      { id: 'hr',      label: 'Garis Pemisah',    desc: 'Horizontal rule antar bagian',          icon: 'horizontal_rule',       action: () => editor.value.chain().focus().setHorizontalRule().run() },
      { id: 'toc',     label: 'Daftar Isi',       desc: 'TOC otomatis dari heading H2/H3',       icon: 'toc',                   action: () => insertToc() },
      { id: 'image',   label: 'Gambar',           desc: 'Pilih dari Directus Media Library',     icon: 'image',                 action: () => openMediaDialog('inline') },
      { id: 'table',   label: 'Tabel',            desc: 'Tabel 3x3 dengan header',               icon: 'table_chart',           action: () => editor.value.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run() },
      { id: 'youtube', label: 'YouTube',          desc: 'Embed video YouTube',                   icon: 'smart_display',         action: () => openYoutubeModal() },
    ]);

    const filteredSlashCommands = computed(() => {
      const q = slashQuery.value.toLowerCase().trim();
      if (!q) return slashMenuCommands.value;
      return slashMenuCommands.value.filter(c =>
        c.label.toLowerCase().includes(q) ||
        c.desc.toLowerCase().includes(q) ||
        c.id.toLowerCase().includes(q)
      );
    });

    const scrollSlashItem = () => {
      if (!slashMenuListRef.value) return;
      const el = slashMenuListRef.value.querySelector('.slash-item.active');
      if (el) el.scrollIntoView({ block: 'nearest' });
    };

    const executeSlashCommand = (cmd) => {
      if (!cmd || !editor.value) return;
      // Delete /query text before inserting block
      if (slashStartPos !== null) {
        const { selection } = editor.value.state;
        editor.value.chain().focus().deleteRange({ from: slashStartPos, to: selection.from }).run();
      }
      showSlashMenu.value = false;
      slashStartPos = null;
      nextTick(() => cmd.action());
    };

    // Ads logic
    const addAd = () => {
      ads.value.push({ url: '', description: '', image: null });
    };
    const removeAd = (index) => {
      ads.value.splice(index, 1);
    };

    // Keyword Logic
    const addKeyword = () => {
      const val = newKeyword.value.trim();
      if (val && !keywordsList.value.includes(val)) {
        keywordsList.value.push(val);
        checkCannibalization();
      }
      newKeyword.value = '';
    };
    
    const removeKeyword = (index) => {
      keywordsList.value.splice(index, 1);
      if (index === 0) checkCannibalization();
    };

    const getKeywordStatus = (kw, index) => {
      const text = `${currentArticle.value?.title || ''} ${currentArticle.value?.content || ''}`.toLowerCase();
      const kwLower = kw.toLowerCase();
      if (text.includes(kwLower)) return 'green';
      const words = kwLower.split(' ');
      if (words.some(w => text.includes(w))) return 'orange';
      return 'red';
    };

    // SEO Analyzer (Identik custom-seo-analyzer)
    const checkCannibalization = () => {
      if (cannibalTimeout) clearTimeout(cannibalTimeout);
      cannibalTimeout = setTimeout(async () => {
        const fk = keywordsList.value.length > 0 ? keywordsList.value[0] : null;
        if (!fk) {
          cannibalizedCount.value = 0;
          runSeoAnalysis();
          return;
        }
        try {
          const res = await api.get('/items/articles', {
            params: {
              filter: { SEO: { _contains: `"focus_keyword":"${fk}"` } },
              limit: 2,
              fields: 'id'
            }
          });
          const currId = currentArticle.value?.id;
          const others = res.data.data.filter(a => a.id !== currId);
          cannibalizedCount.value = others.length;
        } catch (err) {
          console.error('Cannibal check err', err);
        }
        runSeoAnalysis();
      }, 800);
    };

    watch(() => currentArticle.value?.title, () => runSeoAnalysis());
    watch(() => currentArticle.value?.slug, () => runSeoAnalysis());
    watch(() => currentArticle.value?.SEO?.title, () => runSeoAnalysis());
    watch(() => currentArticle.value?.SEO?.metaDescription, () => runSeoAnalysis());
    watch(keywordsList, () => runSeoAnalysis(), { deep: true });

    const getCharColor = (len, min, max) => {
      if (len === 0) return 'text-red';
      if (len >= min && len <= max) return 'text-green';
      return 'text-orange';
    };

    const runSeoAnalysis = () => {
      if (!currentArticle.value) return;
      const fk = keywordsList.value.length > 0 ? keywordsList.value[0] : '';
      const sks = keywordsList.value.slice(1);
      const { score, label, color, results } = computeFullSeoScore(currentArticle.value, fk, sks, cannibalizedCount.value);
      
      seoScore.value = score;
      seoResults.basic = results.basic;
      seoResults.keyword = results.keyword;
      seoResults.readability = results.readability;
    };

    const wordCount = computed(() => {
      if (!editor.value) return 0;
      return editor.value.storage.characterCount.words();
    });

    const readingTime = computed(() => {
      const wpm = 225; // rata-rata kecepatan baca (words per minute)
      const words = wordCount.value;
      return Math.ceil(words / wpm);
    });


    return {
      offlineDrafts,
      showOfflineDraftsDialog,
      handleCreateClick,
      createNewBlank,
      deleteOfflineDraft,
      restoreOfflineDraft,
      articles, loading, searchQuery, activeFilter, filteredArticles,
      currentPage, totalPages, paginatedArticles,
      currentArticle, isSaving, sidebarTab, checkTab,
      editor, pillarOptions,
      createNew, editArticle, saveArticle, closeEditor, generateSlug, formatDate, getImageSrc,
      showLeftToolbox, showRightSidebar, toolboxSearch, toolboxCategories, filteredToolboxCategories,
      showMediaDialog, mediaTarget, mediaFiles, loadingMedia, mediaSearchQuery, filteredMediaFiles, selectedMediaFile, isUploading, fileInput, openMediaDialog, confirmMediaSelect, handleFileUpload,
      selectAdImageIndex, ads, addAd, removeAd,
      seoScore, currentChecks, keywordsList, newKeyword,
      addKeyword, removeKeyword, getKeywordStatus,
      circumference, offset, scoreColor, scoreLabel,
      getCharColor, toastMessage,
      setLink, insertToc,
      showDeleteDialog, articleToDelete, confirmDelete, executeDelete,
      autoSaveStatus, duplicateArticle, wordCount, readingTime,
      showLinkModal, linkModal, linkUrlInput, closeLinkModal, applyLink, removeLink,
      showSlashMenu, slashMenuPos, slashMenuIndex, filteredSlashCommands, executeSlashCommand, slashMenuListRef,
      showYoutubeModal, youtubeUrlVal, youtubeUrlError, youtubeInputRef, openYoutubeModal, applyYoutube,
    };
  }
};
</script>

<style scoped>
.article-editor-module {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: var(--theme--background, #f8fafc);
  color: #0f172a;
  font-family: system-ui, -apple-system, 'Inter', sans-serif;
  overflow: hidden;
}

/* DASHBOARD VIEW - TABEL WORDPRESS */
.directus-nav-sidebar {
  padding: 24px 12px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.nav-section-title {
  font-size: 11px;
  font-weight: 700;
  color: var(--theme--foreground-subdued, #94a3b8);
  letter-spacing: 0.5px;
  padding: 0 12px;
}
.nav-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.nav-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 12px;
  border-radius: 6px;
  background: transparent;
  border: none;
  color: var(--theme--foreground, #334155);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s ease;
  text-align: left;
}
.nav-item:hover {
  background: var(--theme--background-subdued, #f1f5f9);
  color: var(--theme--foreground, #0f172a);
}
.nav-item.active {
  background: var(--theme--primary-subdued, #fff7ed);
  color: #EE7D0F;
  font-weight: 600;
}
.nav-item .badge {
  font-size: 12px;
  background: var(--theme--background-normal, #e2e8f0);
  padding: 2px 8px;
  border-radius: 12px;
  color: var(--theme--foreground-subdued, #64748b);
}
.nav-item.active .badge {
  background: #EE7D0F;
  color: #fff;
}
.dashboard-view {
  padding: 32px 40px;
  height: 100%;
  overflow-y: auto;
}
.dashboard-top-search {
  margin-bottom: 24px;
  max-width: 400px;
}
.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 16px;
  margin-bottom: 24px;
}
.header-title {
  display: flex;
  align-items: center;
  gap: 20px;
}
.header-title h1 {
  margin: 0;
  font-size: 28px;
  font-weight: 800;
  color: #0b2340;
}
.btn-new-custom {
  background: #EE7D0F;
  color: #fff;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 4px 12px rgba(238, 125, 15, 0.25);
  transition: all 0.2s;
  white-space: nowrap;
  flex-shrink: 0;
}
.btn-new-custom:hover {
  background: #d96b06;
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(238, 125, 15, 0.35);
}
.search-input {
  width: 320px;
}

.filter-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
  border-bottom: 1px solid #cbd5e1;
  padding-bottom: 8px;
}
.filter-btn {
  background: transparent;
  border: none;
  font-size: 14px;
  font-weight: 600;
  color: #64748b;
  cursor: pointer;
  padding: 6px 12px;
  border-radius: 6px;
  transition: all 0.2s;
}
.filter-btn:hover {
  color: #0b2340;
  background: #e2e8f0;
}
.filter-btn.active {
  color: #EE7D0F;
  background: #ffedd5;
}
.filter-btn .count {
  font-weight: normal;
  opacity: 0.8;
}

.table-responsive {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.04);
  border: 1px solid #e2e8f0;
  overflow: hidden;
}
.wp-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}
.wp-table th {
  background: #f8fafc;
  padding: 14px 16px;
  font-size: 13px;
  font-weight: 700;
  color: #334155;
  border-bottom: 2px solid #e2e8f0;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.wp-row {
  border-bottom: 1px solid #f1f5f9;
  transition: background 0.15s;
}
.wp-row:hover {
  background: #f8fafc;
}
.wp-row:hover .row-actions {
  opacity: 1;
  visibility: visible;
}
.wp-table td {
  padding: 16px;
  vertical-align: top;
  font-size: 14px;
}

.col-title {
  position: relative;
}
.title-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}
.title-text {
  font-weight: 700;
  color: #0b2340;
  cursor: pointer;
  font-size: 15px;
  line-height: 1.4;
  transition: color 0.2s;
}
.title-text:hover {
  color: #EE7D0F;
}
.pillar-badge {
  background: #ffedd5;
  color: #c2410c;
  border: 1px solid #fdba74;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
  white-space: nowrap;
}
.row-actions {
  font-size: 12px;
  color: #cbd5e1;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.2s;
  display: flex;
  gap: 6px;
  align-items: center;
}
.action-edit { color: #0284c7; font-weight: 600; cursor: pointer; }
.action-edit:hover { text-decoration: underline; }
.action-duplicate { color: #16a34a; font-weight: 600; cursor: pointer; }
.action-duplicate:hover { text-decoration: underline; }
.action-preview a { color: #0284c7; text-decoration: none; font-weight: 500; }
.action-preview a:hover { text-decoration: underline; }
.action-delete { color: #ef4444; font-weight: 500; cursor: pointer; }

/* Custom Placeholder Styles */
.tiptap p.is-editor-empty:first-child::before {
  color: #adb5bd;
  content: attr(data-placeholder);
  float: left;
  height: 0;
  pointer-events: none;
}

/* Figcaption Styles */
.tiptap figcaption {
  text-align: center;
  font-size: 0.875rem;
  color: #666;
  margin-top: 8px;
}
.tiptap figcaption.is-empty::before {
  color: #adb5bd;
  content: attr(data-placeholder);
  float: left;
  height: 0;
  pointer-events: none;
}
.action-delete:hover { text-decoration: underline; }

.kw-pill {
  background: #f1f5f9;
  color: #334155;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
  border: 1px solid #e2e8f0;
}
.text-muted { color: #94a3b8; }

.seo-indicator {
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 600;
  font-size: 13px;
}
.seo-indicator .dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
.seo-indicator.green { color: #16a34a; }
.seo-indicator.green .dot { background: #16a34a; }
.seo-indicator.orange { color: #d97706; }
.seo-indicator.orange .dot { background: #d97706; }
.seo-indicator.red { color: #dc2626; }
.seo-indicator.red .dot { background: #dc2626; }
.score-lbl { font-size: 11px; opacity: 0.8; font-weight: normal; }

.status-badge {
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  display: inline-block;
}
.status-badge.published { background: #dcfce7; color: #166534; }
.status-badge.scheduled { background: #dbeafe; color: #1e40af; }
.status-badge.draft { background: #fef9c3; color: #854d0e; }
.status-badge.archived { background: #f1f5f9; color: #475569; }

.date-text { font-weight: 600; color: #334155; font-size: 13px; }
.date-sub { font-size: 11px; color: #94a3b8; margin-top: 2px; }

.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: #64748b;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}
.empty-state p { margin-top: 12px; font-size: 15px; }
.loading-state {
  display: flex;
  justify-content: center;
  padding: 80px;
}

/* EDITOR VIEW: FULL PAGE CLEAN WORKSPACE ALA WORDPRESS GUTENBERG */
.editor-view {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  width: 100vw !important;
  height: 100vh !important;
  z-index: 150 !important;
  background: #fff !important;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
.editor-top-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 24px;
  background: #fff;
  border-bottom: 1px solid #e2e8f0;
  gap: 16px;
  z-index: 100;
  position: sticky;
  top: 0;
}
.top-bar-left {
  display: flex;
  align-items: center;
  gap: 8px;
}
.divider-vertical {
  width: 1px;
  height: 24px;
  background: #e2e8f0;
  margin: 0 8px;
}

.editor-title {
  flex: 1;
  font-size: 18px;
  font-weight: 700;
  color: #0b2340;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding: 0 12px;
}
.top-actions {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
}
:deep(.ad-image .v-button) {
  min-height: 40px;
  white-space: normal;
  height: auto;
  line-height: 1.2;
}
.btn-preview-link {
  text-decoration: none;
}
.editor-layout {
  display: flex;
  flex: 1;
  overflow: hidden;
  position: relative;
}

/* Left Toolbox Pane (Block Inserter ala Gutenberg / Elementor) */
.editor-toolbox-pane {
  width: 290px;
  background: #fff;
  border-right: 1px solid #cbd5e1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  z-index: 10;
  flex-shrink: 0;
}
.toolbox-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #e2e8f0;
}
.toolbox-title {
  font-weight: 700;
  font-size: 15px;
  color: #0b2340;
  display: flex;
  align-items: center;
  gap: 8px;
}
.toolbox-search {
  padding: 12px 16px;
  border-bottom: 1px solid #f1f5f9;
}
.toolbox-list {
  padding: 12px 16px;
  flex: 1;
  overflow-y: auto;
}
.toolbox-category {
  margin-bottom: 24px;
}
.cat-name {
  font-size: 11px;
  font-weight: 700;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 10px;
}
.cat-items {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.tool-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 10px 12px;
  border-radius: 6px;
  cursor: pointer;
  border: 1px solid transparent;
  transition: all 0.15s;
  background: #f8fafc;
}
.tool-item:hover {
  background: #fff;
  border-color: #EE7D0F;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}
.tool-icon {
  color: #0b2340;
  margin-top: 2px;
  flex-shrink: 0;
}
.tool-info {
  flex: 1;
  overflow: hidden;
}
.tool-title {
  font-size: 13px;
  font-weight: 700;
  color: #0b2340;
  margin-bottom: 2px;
}
.tool-desc {
  font-size: 11px;
  color: #64748b;
  line-height: 1.3;
}
.toolbox-empty {
  text-align: center;
  padding: 40px 20px;
  color: #64748b;
  font-size: 13px;
}

/* Main Canvas Pane (FULL PAGE WHITE WORKSPACE, WRAPPING KE BAWAH TANPA OVERFLOW KANAN) */
.editor-main-pane {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  background: #fff;
  display: flex;
  justify-content: center;
  position: relative;
  width: 100%;
}
.editor-status-bar {
  position: fixed;
  bottom: 0;
  left: 280px;
  right: 320px;
  height: 40px;
  background: #f8fafc;
  border-top: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  padding: 0 24px;
  gap: 24px;
  color: #64748b;
  font-size: 13px;
  font-weight: 500;
  z-index: 10;
}
.autosave-status {
  display: flex;
  align-items: center;
  gap: 6px;
}
.autosave-status.saved { color: #16a34a; }
.autosave-status.unsaved { color: #f59e0b; }
.autosave-status.saving { color: #3b82f6; }

.canvas-container {
  width: 100%;
  max-width: 960px;
  margin: 0 auto;
  padding: 40px 48px;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  overflow-wrap: anywhere;
  word-break: break-word;
}

/* Bubble & Floating Menu (TANPA EMOJI, BERSIH) */
.bubble-menu-box, .floating-menu-box {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px;
  background: #0f172a;
  padding: 6px 8px;
  border-radius: 8px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.25);
  border: 1px solid #334155;
  z-index: 30;
}
.bubble-menu-box button, .floating-menu-box button {
  background: transparent;
  border: none;
  color: #f8fafc;
  padding: 5px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 4px;
  transition: all 0.15s;
}
.bubble-menu-box button:hover, .floating-menu-box button:hover {
  background: #334155;
}
.bubble-menu-box button.is-active, .floating-menu-box button.is-active {
  background: #EE7D0F;
  color: #fff;
}
.bubble-menu-box .divider, .floating-menu-box .divider {
  width: 1px;
  height: 18px;
  background: #475569;
  margin: 0 4px;
}
.floating-menu-box .btn-toc {
  background: #78350f;
  color: #fde68a;
}
.floating-menu-box .btn-toc:hover {
  background: #b45309;
  color: #fff;
}
.floating-menu-box .btn-img, .floating-menu-box .btn-tbl {
  background: #075985;
  color: #bae6fd;
}
.floating-menu-box .btn-img:hover, .floating-menu-box .btn-tbl:hover {
  background: #0369a1;
  color: #fff;
}

.paper-title-input {
  width: 100%;
  border: none;
  outline: none;
  font-size: 38px;
  font-weight: 800;
  color: #0b2340;
  margin-bottom: 28px;
  font-family: inherit;
  line-height: 1.3;
  background: transparent;
  box-sizing: border-box;
}
.paper-title-input::placeholder {
  color: #cbd5e1;
}

/* Canvas Cover Image Display */
.canvas-cover-box {
  position: relative;
  width: 100%;
  min-height: 240px;
  margin-bottom: 32px;
  border-radius: 12px;
  overflow: hidden;
  background: #f1f5f9;
  border: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  justify-content: center;
}
.canvas-cover-img {
  width: 100%;
  height: auto;
  max-height: 560px;
  object-fit: contain;
  display: block;
}
.canvas-cover-actions {
  position: absolute;
  top: 16px;
  right: 16px;
  display: flex;
  gap: 8px;
  background: rgba(255, 255, 255, 0.95);
  padding: 6px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(4px);
  opacity: 0.9;
  transition: opacity 0.2s ease;
}
.canvas-cover-box:hover .canvas-cover-actions {
  opacity: 1;
}
.canvas-cover-placeholder {
  width: 100%;
  padding: 24px;
  margin-bottom: 32px;
  border: 2px dashed #cbd5e1;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  color: #64748b;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  background: #f8fafc;
  transition: all 0.2s ease;
  box-sizing: border-box;
}
.canvas-cover-placeholder:hover {
  border-color: #EE7D0F;
  color: #EE7D0F;
  background: #fffaf5;
}
.cover-placeholder-icon {
  color: inherit;
}

.paper-content {
  width: 100%;
  overflow-wrap: anywhere;
  word-wrap: break-word;
  word-break: break-word;
  font-size: 16px;
  line-height: 1.8;
  color: #1e293b;
  min-height: 600px;
  box-sizing: border-box;
}

/* TipTap Prosemirror reset & text wrapping ke bawah */
:deep(.ProseMirror) {
  outline: none;
  min-height: 450px;
  width: 100%;
  max-width: 100%;
  box-sizing: border-box;
  overflow-wrap: anywhere;
  word-break: break-word;
}
:deep(.ProseMirror *) {
  max-width: 100%;
  box-sizing: border-box;
}
:deep(.ProseMirror p) { margin: 0 0 1.2em 0; overflow-wrap: anywhere; }
:deep(.ProseMirror h2) { font-size: 24px; font-weight: 700; color: #0b2340; margin: 1.6em 0 0.6em 0; overflow-wrap: anywhere; }
:deep(.ProseMirror h3) { font-size: 20px; font-weight: 600; color: #0b2340; margin: 1.4em 0 0.6em 0; overflow-wrap: anywhere; }
:deep(.ProseMirror h4) { font-size: 17px; font-weight: 600; color: #0b2340; margin: 1.2em 0 0.5em 0; overflow-wrap: anywhere; }
:deep(.ProseMirror ul), :deep(.ProseMirror ol) { padding-left: 24px; margin: 0 0 1.2em 0; overflow-wrap: anywhere; }
:deep(.ProseMirror blockquote) {
  border-left: 4px solid #EE7D0F;
  padding: 12px 20px;
  margin: 1.5em 0;
  background: #fff7ed;
  color: #9a3412;
  font-style: italic;
  border-radius: 0 8px 8px 0;
  overflow-wrap: anywhere;
}
:deep(.ProseMirror pre), :deep(.ProseMirror code) {
  white-space: pre-wrap !important;
  word-break: break-all !important;
  overflow-wrap: anywhere !important;
  max-width: 100%;
}
:deep(.ProseMirror img) {
  max-width: 100% !important;
  height: auto !important;
  border-radius: 8px;
  margin: 1.5em 0;
  box-shadow: 0 4px 15px rgba(0,0,0,0.08);
}
:deep(.ProseMirror table) {
  border-collapse: collapse;
  table-layout: fixed !important;
  width: 100% !important;
  max-width: 100% !important;
  margin: 1.5em 0;
  word-break: break-word !important;
  overflow-wrap: anywhere !important;
}
:deep(.ProseMirror table td), :deep(.ProseMirror table th) {
  min-width: 1em;
  border: 1px solid #cbd5e1;
  padding: 10px 12px;
  vertical-align: top;
  box-sizing: border-box;
  position: relative;
  word-break: break-word;
  overflow-wrap: anywhere;
  white-space: normal;
}
:deep(.ProseMirror table th) {
  font-weight: bold;
  text-align: left;
  background: #f8fafc;
  color: #0b2340;
}

/* Right Sidebar Pane (Dokumen & SEO RankMath style) */
.editor-sidebar-pane {
  width: 380px;
  background: #fff;
  border-left: 1px solid #cbd5e1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  z-index: 10;
  flex-shrink: 0;
}
.sidebar-tabs {
  display: flex;
  border-bottom: 1px solid #cbd5e1;
  position: sticky;
  top: 0;
  background: #fff;
  z-index: 5;
}
.sidebar-tabs .tab {
  flex: 1;
  text-align: center;
  padding: 16px;
  font-weight: 700;
  cursor: pointer;
  color: #64748b;
  border-bottom: 2px solid transparent;
  font-size: 14px;
  transition: all 0.2s;
}
.sidebar-tabs .tab:hover {
  color: #0b2340;
}
.sidebar-tabs .tab.active {
  color: #EE7D0F;
  border-bottom-color: #EE7D0F;
}
.sidebar-content {
  padding: 24px;
}
.panel-section {
  margin-bottom: 28px;
}
.panel-section label {
  display: block;
  font-weight: 700;
  margin-bottom: 8px;
  font-size: 13px;
  color: #0b2340;
}
.checkbox-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
}
.image-preview-wrapper {
  position: relative;
  display: inline-block;
  width: 100%;
}
.image-preview {
  width: 100%;
  border-radius: 6px;
  border: 1px solid #cbd5e1;
  display: block;
}
.remove-image-btn {
  position: absolute;
  top: -10px;
  right: -10px;
  background: #fff !important;
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
}

.ad-item {
  background: #f8fafc;
  padding: 14px;
  border-radius: 8px;
  margin-bottom: 14px;
  border: 1px solid #cbd5e1;
}
.ad-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-weight: 700;
  font-size: 13px;
  color: #0b2340;
}
.remove-ad {
  cursor: pointer;
  color: #ef4444;
  transition: transform 0.2s;
}
.remove-ad:hover {
  transform: scale(1.1);
}
.ad-img-thumb {
  width: 100%;
  border-radius: 6px;
  cursor: pointer;
  border: 1px solid #cbd5e1;
}

/* SEO Specific */
.seo-score-header {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 24px;
  padding: 18px;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}
.score-label {
  font-size: 12px;
  color: #64748b;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.score-value {
  font-size: 22px;
  font-weight: 800;
  margin-top: 2px;
}

.tag-input-container {
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  padding: 6px;
  min-height: 44px;
  background: #fff;
  transition: border-color 0.2s;
}
.tag-input-container:focus-within {
  border-color: #EE7D0F;
}
.tags-list {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.tag {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 600;
  color: #fff;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1);
}
.tag.green { background: #16a34a; }
.tag.orange { background: #d97706; }
.tag.red { background: #dc2626; }
.tag-star { color: #fef08a; font-size: 13px; font-weight: 800; }
.tag-close { cursor: pointer; opacity: 0.8; }
.tag-close:hover { opacity: 1; }
.tag-input {
  border: none;
  outline: none;
  flex: 1;
  min-width: 120px;
  padding: 4px;
  font-size: 13px;
  background: transparent;
  color: #0f172a;
}
.tag-help {
  font-size: 11px;
  color: #64748b;
  margin-top: 6px;
  line-height: 1.4;
}

.serp-preview {
  background: #fff;
  border: 1px solid #cbd5e1;
  padding: 16px;
  border-radius: 8px;
  font-family: Arial, sans-serif;
  box-shadow: 0 2px 8px rgba(0,0,0,0.03);
}
.serp-url {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #202124;
  margin-bottom: 4px;
}
.serp-favicon {
  width: 18px;
  height: 18px;
  background: #f1f5f9;
  border: 1px solid #cbd5e1;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 800;
  color: #0b2340;
}
.serp-title {
  color: #1a0dab;
  font-size: 18px;
  margin-bottom: 4px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.serp-desc {
  color: #4d5156;
  font-size: 13px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.char-count {
  text-align: right;
  font-size: 11px;
  margin-top: 4px;
  font-weight: 600;
}
.text-green { color: #16a34a; }
.text-orange { color: #d97706; }
.text-red { color: #dc2626; }

.seo-checks {
  margin-top: 30px;
}
.check-tabs {
  display: flex;
  gap: 6px;
  margin-bottom: 16px;
}
.ctab {
  flex: 1;
  text-align: center;
  padding: 8px 12px;
  background: #f1f5f9;
  border-radius: 6px;
  font-size: 12px;
  cursor: pointer;
  font-weight: 700;
  color: #64748b;
  transition: all 0.2s;
}
.ctab:hover {
  background: #e2e8f0;
  color: #0b2340;
}
.ctab.active {
  background: #0b2340;
  color: #fff;
}
.checks-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.check-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  font-size: 13px;
  line-height: 1.5;
  background: #f8fafc;
  padding: 10px 12px;
  border-radius: 6px;
  border: 1px solid #f1f5f9;
}
.check-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
  margin-top: 5px;
}
.check-dot.green { background: #16a34a; }
.check-dot.orange { background: #d97706; }
.check-dot.red { background: #dc2626; }
.check-text {
  color: #1e293b;
  font-weight: 500;
}

/* Directus Media Library Styles */
.media-library-card {
  width: 820px;
  max-width: 95vw;
  max-height: 85vh;
  display: flex;
  flex-direction: column;
}
.media-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #cbd5e1;
  padding-bottom: 14px;
}
.btn-upload {
  background: #10b981;
  color: #fff;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  transition: background 0.2s;
  box-shadow: 0 2px 8px rgba(16, 185, 129, 0.25);
}
.btn-upload:hover {
  background: #059669;
}
.btn-upload:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.media-content {
  overflow-y: auto;
  padding: 20px;
  min-height: 420px;
}
.media-search-bar {
  margin-bottom: 20px;
}
.media-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
  gap: 16px;
}
.media-item {
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.2s;
  background: #f8fafc;
  display: flex;
  flex-direction: column;
}
.media-item:hover {
  border-color: #EE7D0F;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}
.media-item.selected {
  border-color: #EE7D0F;
  background: #fff7ed;
  box-shadow: 0 0 0 2px #EE7D0F;
}
.thumb-wrap {
  width: 100%;
  height: 120px;
  background: #cbd5e1;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.thumb-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.media-info {
  padding: 8px;
  text-align: center;
}
.media-name {
  font-size: 12px;
  font-weight: 600;
  color: #1e293b;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.media-date {
  font-size: 10px;
  color: #64748b;
  margin-top: 2px;
}
.media-loading, .media-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #64748b;
  text-align: center;
  gap: 12px;
}

.toast-notification {
  position: fixed;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%);
  background: #0f172a;
  color: #fff;
  padding: 12px 24px;
  border-radius: 8px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.3);
  font-size: 14px;
  font-weight: 600;
  z-index: 99999;
  border: 1px solid #334155;
}

.pagination-controls {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px;
  border-top: 1px solid #e2e8f0;
  background: #f8fafc;
}
.page-info {
  font-size: 14px;
  color: #64748b;
  font-weight: 500;
}

/* =========================================
   LINK MODAL
   ========================================= */
.link-modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(11, 35, 64, 0.55);
  backdrop-filter: blur(4px);
  z-index: 99999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}
.link-modal-box {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 24px 60px rgba(11, 35, 64, 0.25), 0 0 0 1px rgba(11, 35, 64, 0.08);
  width: 100%;
  max-width: 520px;
  overflow: hidden;
  animation: lm-slide-in 0.22s cubic-bezier(0.22, 1, 0.36, 1);
}
@keyframes lm-slide-in {
  from { transform: translateY(-16px) scale(0.97); opacity: 0; }
  to   { transform: translateY(0) scale(1); opacity: 1; }
}
.lm-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px 24px 18px;
  border-bottom: 1px solid #f1f5f9;
  background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
}
.lm-header-icon {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  background: linear-gradient(135deg, #EE7D0F 0%, #f59e0b 100%);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba(238, 125, 15, 0.35);
}
.lm-title {
  font-size: 16px;
  font-weight: 700;
  color: #0b2340;
  flex: 1;
  margin: 0;
}
.lm-close {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  border: none;
  background: #f1f5f9;
  color: #64748b;
  font-size: 18px;
  line-height: 1;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
  flex-shrink: 0;
}
.lm-close:hover {
  background: #fee2e2;
  color: #dc2626;
}
.lm-body {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 18px;
}
.lm-field {
  display: flex;
  flex-direction: column;
  gap: 7px;
}
.lm-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  font-weight: 700;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.4px;
}
.lm-required {
  color: #ef4444;
}
.lm-input-wrap {
  position: relative;
  border: 1.5px solid #e2e8f0;
  border-radius: 8px;
  transition: border-color 0.2s, box-shadow 0.2s;
  background: #fff;
}
.lm-input-wrap:focus-within {
  border-color: #EE7D0F;
  box-shadow: 0 0 0 3px rgba(238, 125, 15, 0.12);
}
.lm-input-wrap.error {
  border-color: #ef4444;
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.10);
}
.lm-input {
  width: 100%;
  border: none;
  outline: none;
  padding: 11px 14px;
  font-size: 14px;
  font-family: inherit;
  color: #0f172a;
  background: transparent;
  border-radius: 8px;
}
.lm-input::placeholder {
  color: #94a3b8;
}
.lm-error-text {
  font-size: 12px;
  color: #ef4444;
  font-weight: 500;
}
.lm-advanced {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  font-weight: 600;
  color: #64748b;
  cursor: pointer;
  user-select: none;
  transition: color 0.15s;
  padding: 0 2px;
}
.lm-advanced:hover {
  color: #EE7D0F;
}
.lm-advanced-panel {
  display: flex;
  flex-direction: column;
  gap: 14px;
  padding: 16px;
  background: #f8fafc;
  border-radius: 8px;
  border: 1px solid #f1f5f9;
}
.lm-radio-group {
  display: flex;
  gap: 20px;
}
.lm-radio {
  display: flex;
  align-items: center;
  gap: 7px;
  cursor: pointer;
}
.lm-radio input[type="radio"] {
  accent-color: #EE7D0F;
  width: 15px;
  height: 15px;
  cursor: pointer;
}
.lm-radio-label {
  font-size: 13px;
  font-weight: 500;
  color: #334155;
}
.lm-checkbox-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.lm-checkbox {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  cursor: pointer;
  font-size: 13px;
  color: #334155;
  font-weight: 500;
  line-height: 1.4;
}
.lm-checkbox input[type="checkbox"] {
  accent-color: #EE7D0F;
  width: 15px;
  height: 15px;
  flex-shrink: 0;
  margin-top: 2px;
  cursor: pointer;
}
.lm-checkbox small {
  color: #94a3b8;
  font-size: 11px;
  font-weight: 400;
}
.lm-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 24px;
  border-top: 1px solid #f1f5f9;
  background: #f8fafc;
  gap: 12px;
}
.lm-footer-right {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-left: auto;
}
.lm-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 9px 18px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 700;
  border: none;
  cursor: pointer;
  transition: all 0.18s;
  font-family: inherit;
}
.lm-btn-primary {
  background: linear-gradient(135deg, #EE7D0F 0%, #f59e0b 100%);
  color: #fff;
  box-shadow: 0 4px 12px rgba(238, 125, 15, 0.35);
}
.lm-btn-primary:hover {
  background: linear-gradient(135deg, #d96c00 0%, #e08c00 100%);
  box-shadow: 0 6px 16px rgba(238, 125, 15, 0.45);
  transform: translateY(-1px);
}
.lm-btn-secondary {
  background: #fff;
  color: #64748b;
  border: 1.5px solid #e2e8f0;
}
.lm-btn-secondary:hover {
  background: #f8fafc;
  border-color: #cbd5e1;
  color: #334155;
}
.lm-btn-danger {
  background: #fff;
  color: #dc2626;
  border: 1.5px solid #fecaca;
  padding-left: 14px;
}
.lm-btn-danger:hover {
  background: #fef2f2;
  border-color: #ef4444;
}
/* Link Modal Transition */
.link-modal-enter-active, .link-modal-leave-active { transition: opacity 0.2s ease; }
.link-modal-enter-from, .link-modal-leave-to { opacity: 0; }

/* =========================================
   LINK HIGHLIGHT in Editor
   ========================================= */
:deep(.ProseMirror a) {
  color: #0284c7;
  text-decoration: underline;
  text-underline-offset: 2px;
  text-decoration-color: rgba(2, 132, 199, 0.45);
  background: rgba(2, 132, 199, 0.07);
  border-radius: 3px;
  padding: 0 2px;
  cursor: pointer;
  transition: background 0.15s, color 0.15s;
}
:deep(.ProseMirror a:hover) {
  background: rgba(2, 132, 199, 0.14);
  color: #0369a1;
  text-decoration-color: rgba(2, 132, 199, 0.7);
}

/* =========================================
   SLASH COMMAND MENU
   ========================================= */
.slash-menu {
  position: fixed;
  z-index: 99998;
  background: #fff;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  box-shadow: 0 16px 48px rgba(11, 35, 64, 0.18), 0 4px 12px rgba(0,0,0,0.08);
  width: 280px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
.slash-header {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 10px 14px 8px;
  font-size: 11px;
  font-weight: 600;
  color: #94a3b8;
  text-transform: uppercase;
  letter-spacing: 0.4px;
  border-bottom: 1px solid #f1f5f9;
  background: #f8fafc;
}
.slash-list {
  max-height: 320px;
  overflow-y: auto;
  padding: 4px;
}
.slash-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 10px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.12s;
}
.slash-item:hover,
.slash-item.active {
  background: #f1f5f9;
}
.slash-item.active {
  background: linear-gradient(90deg, #fff7ed 0%, #fff 100%);
  border-left: 3px solid #EE7D0F;
}
.slash-icon {
  width: 30px;
  height: 30px;
  border-radius: 7px;
  background: #f1f5f9;
  border: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #475569;
  flex-shrink: 0;
  transition: background 0.12s;
}
.slash-item.active .slash-icon {
  background: #fff7ed;
  border-color: #fed7aa;
  color: #EE7D0F;
}
.slash-info {
  flex: 1;
  min-width: 0;
}
.slash-label {
  font-size: 13px;
  font-weight: 600;
  color: #0f172a;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.slash-desc {
  font-size: 11px;
  color: #94a3b8;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-top: 1px;
}
.slash-empty {
  padding: 16px;
  text-align: center;
  color: #94a3b8;
  font-size: 13px;
}
.slash-footer {
  padding: 7px 14px;
  font-size: 10px;
  color: #cbd5e1;
  font-weight: 600;
  border-top: 1px solid #f1f5f9;
  background: #f8fafc;
  text-align: center;
  letter-spacing: 0.2px;
}
.slash-fade-enter-active, .slash-fade-leave-active { transition: opacity 0.15s, transform 0.15s; }
.slash-fade-enter-from, .slash-fade-leave-to { opacity: 0; transform: translateY(-6px) scale(0.97); }

/* =========================================
   YOUTUBE EMBED
   ========================================= */
:deep(.youtube-nodeview) {
  margin: 1.5em 0;
  border-radius: 12px;
  overflow: hidden;
  background: #000;
  position: relative;
  user-select: none;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}
:deep(.yt-ratio-box) {
  position: relative;
  padding-bottom: 56.25%;
  height: 0;
  background: #000;
}
:deep(.yt-ratio-box iframe) {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  border: none;
  border-radius: 12px;
}
:deep(.yt-badge) {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0,0,0,0.7);
  color: #fff;
  border-radius: 6px;
  padding: 4px 10px;
  font-size: 11px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 5px;
  backdrop-filter: blur(4px);
  pointer-events: none;
}
/* YouTube in rendered HTML output */
:deep(.youtube-embed-wrapper) {
  position: relative;
  padding-bottom: 56.25%;
  height: 0;
  overflow: hidden;
  border-radius: 12px;
  margin: 1.5em 0;
  background: #000;
  box-shadow: 0 4px 20px rgba(0,0,0,0.12);
}
:deep(.youtube-embed-iframe) {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  border: none;
}
/* Floating menu YT button */
.btn-yt { color: #dc2626 !important; }
</style>
