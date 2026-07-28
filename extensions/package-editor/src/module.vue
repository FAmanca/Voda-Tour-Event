<template>
  <private-view v-if="!editingPackage" title="Daftar Paket Wisata">
    <!-- Top Action: Icon Only Plus Button -->
    <template #actions>
      <v-button icon round @click="createNewPackage" title="Buat Paket Wisata Baru">
        <v-icon name="add" />
      </v-button>
    </template>

    <!-- Left Navigation Sidebar: Filter Status -->
    <template #navigation>
      <sidebar-detail icon="filter_alt" title="Filter Status" initial-open>
        <div class="nav-filter-list">
          <div 
            class="nav-filter-item" 
            :class="{ active: statusFilter === null }"
            @click="statusFilter = null"
          >
            <v-icon name="apps" small />
            <span>Semua Paket</span>
            <span class="count">{{ packages.length }}</span>
          </div>
          <div 
            v-for="opt in statusOptions" 
            :key="opt.value"
            class="nav-filter-item" 
            :class="{ active: statusFilter === opt.value }"
            @click="statusFilter = opt.value"
          >
            <span class="status-dot" :class="opt.value"></span>
            <span>{{ opt.text }}</span>
            <span class="count">{{ getStatusCount(opt.value) }}</span>
          </div>
        </div>
      </sidebar-detail>
    </template>

    <!-- Main Dashboard Content: Search Bar & Table View -->
    <div class="dashboard-main-content">
      <div class="dashboard-top-search">
        <v-input v-model="searchQuery" placeholder="Cari nama paket wisata, destinasi, atau slug..." class="search-input-full">
          <template #prepend><v-icon name="search" /></template>
          <template #append v-if="searchQuery">
            <v-icon name="close" class="cursor-pointer text-gray-400 hover:text-gray-600" @click="searchQuery = ''" />
          </template>
        </v-input>
      </div>

      <div v-if="loadingPackages" class="loading-state">
        <v-progress-circular indeterminate />
        <span>Memuat daftar paket wisata...</span>
      </div>

      <div v-else-if="filteredPackages.length === 0" class="empty-state">
        <v-icon name="travel_explore" x-large />
        <p>Paket wisata tidak ditemukan. Klik tombol "+" di atas untuk membuat paket baru.</p>
      </div>

      <div v-else class="table-responsive-wrapper">
        <table class="package-table">
          <thead>
            <tr>
              <th width="70">Gambar</th>
              <th>Nama Paket & Slug</th>
              <th>Destinasi</th>
              <th>Durasi</th>
              <th>Harga Mulai</th>
              <th width="120">Status</th>
              <th width="100" class="text-right">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="pkg in paginatedPackages" :key="pkg.id" class="table-row" @click="editPackage(pkg)">
              <td>
                <div class="thumb-box">
                  <img v-if="pkg.image" :src="getImageSrc(pkg.image)" :alt="pkg.name" class="table-thumb" />
                  <div v-else class="thumb-placeholder"><v-icon name="image" small /></div>
                </div>
              </td>
              <td>
                <div class="pkg-title">{{ pkg.name }}</div>
                <div class="pkg-slug"><v-icon name="link" small /> /paket/{{ pkg.slug }}</div>
              </td>
              <td>
                <div class="pkg-dest">
                  <v-icon name="place" small class="text-orange" />
                  <span>{{ getDestinationName(pkg.destination_id) }}</span>
                </div>
              </td>
              <td>
                <div class="pkg-meta-badge duration">{{ pkg.duration || '-' }}</div>
              </td>
              <td>
                <div class="pkg-price">{{ formatPrice(getStartingPrice(pkg.price_tiers)) }}</div>
              </td>
              <td>
                <span class="status-badge" :class="pkg.status">{{ pkg.status }}</span>
              </td>
              <td class="text-right actions-cell" @click.stop>
                <div class="action-buttons">
                  <v-button small icon round secondary @click="editPackage(pkg)" title="Edit Paket"><v-icon name="edit" /></v-button>
                  <v-button small icon round secondary @click="confirmDelete(pkg)" title="Hapus Paket"><v-icon name="delete" class="text-red" /></v-button>
                </div>
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
    </div>
  </private-view>

  <!-- Editor View: WordPress Gutenberg / Elementor Fullscreen Takeover Mode (z-index: 150) -->
  <div v-else class="editor-view" @click="closeAllPopovers">
    <!-- Top Navigation Bar -->
    <div class="editor-top-bar" @click.stop>
      <div class="top-bar-left">
        <v-button icon round secondary @click="cancelEdit" title="Kembali ke Daftar Paket">
          <v-icon name="arrow_back" />
        </v-button>
        <span class="top-bar-title">{{ editingPackage.name || 'Paket Wisata Baru' }}</span>
      </div>
      <div class="top-bar-center">
        <span class="status-dot" :class="editingPackage.status"></span>
        <span class="breadcrumb-text">Voda Tour & Event › Paket › <strong class="text-orange">{{ editingPackage.slug || 'baru' }}</strong></span>
      </div>
      <div class="top-bar-right">
        <v-button @click="savePackage" :loading="saving"><v-icon name="check" small style="margin-right: 6px;" /> Simpan Paket Wisata</v-button>
      </div>
    </div>

    <!-- Scrollable Main Builder Pane -->
    <div class="editor-main-scroll">
      <div class="builder-canvas">
        
        <!-- 1. HERO BANNER VISUAL BUILDER -->
        <div class="package-hero-banner" :style="heroBannerStyle" @click.stop>
          <div class="hero-gradient-overlay"></div>
          <div class="hero-glow-orange"></div>
          
          <!-- Media Action Buttons di Pojok Kanan Atas Banner -->
          <div class="hero-media-actions">
            <v-button small icon round @click="openMediaDialog('cover')" title="Ganti Gambar Background Cover Banner"><v-icon name="image" /></v-button>
            <v-button small icon round secondary @click="openMediaDialog('poster')" title="Ganti Poster / Gambar Thumbnail Vertikal"><v-icon name="portrait" /></v-button>
          </div>

          <!-- Content Visual Dalam Banner -->
          <div class="hero-inline-content">
            
            <!-- Searchable Destination Dropdown -->
            <div class="dest-dropdown-wrap" @click.stop="toggleDestDropdown">
              <div class="dest-trigger">
                <v-icon name="arrow_back" small class="text-white-50" />
                <v-icon name="place" small class="text-orange" />
                <span>{{ getDestinationName(editingPackage.destination_id) }}</span>
                <v-icon name="expand_more" small class="text-white-50 ml-1" />
              </div>

              <!-- Popover Search Destinasi -->
              <div v-if="showDestDropdown" class="dest-popover" @click.stop>
                <div class="popover-search">
                  <input v-model="destSearchQuery" placeholder="Cari destinasi..." class="popover-input" ref="destInputRef" />
                </div>
                <div class="popover-list">
                  <div class="popover-item" :class="{ selected: !editingPackage.destination_id }" @click="selectDestination('')">
                    <v-icon name="close" small /> <span>-- Tanpa Destinasi --</span>
                  </div>
                  <div 
                    v-for="dest in filteredDestinations" 
                    :key="dest.id" 
                    class="popover-item"
                    :class="{ selected: editingPackage.destination_id === dest.id }"
                    @click="selectDestination(dest.id)"
                  >
                    <v-icon name="place" small class="text-orange" />
                    <span>{{ dest.name }}</span>
                  </div>
                  <div v-if="filteredDestinations.length === 0" class="popover-empty">Destinasi tidak ditemukan</div>
                </div>
              </div>
            </div>

            <!-- Judul Paket Visual Besar (40px white bold) -->
            <input 
              v-model="editingPackage.name" 
              class="hero-title-input" 
              placeholder="Ketik Nama Paket Wisata..." 
              @input="generateSlug"
            />

            <!-- Slug / URL Pill -->
            <div class="hero-slug-pill">
              <span class="slug-prefix">vodatrip.id/paket/</span>
              <input v-model="editingPackage.slug" class="slug-input" placeholder="url-slug-paket" />
            </div>

            <!-- Visual Badges Bar (Durasi, Harga Mulai, dan Status - Tanpa Max Pax) -->
            <div class="hero-badges-bar">
              <!-- Durasi Pill -->
              <div class="hero-pill">
                <v-icon name="schedule" small class="text-orange" />
                <input v-model="editingPackage.duration" placeholder="misal: 3 Hari 2 Malam" class="pill-input" />
              </div>
              
              <!-- Harga Mulai Pill (Otomatis dari tabel harga terendah) -->
              <div class="hero-pill price-pill">
                <v-icon name="local_offer" small class="text-orange" />
                <span>Mulai <strong class="text-white">{{ formatPrice(getStartingPrice(editingPackage.price_tiers)) }}</strong>/org</span>
              </div>

              <!-- Status Pill -->
              <div class="hero-pill status-pill" :class="editingPackage.status">
                <select v-model="editingPackage.status" class="status-select-clean">
                  <option value="published">Published</option>
                  <option value="draft">Draft</option>
                  <option value="archived">Archived</option>
                </select>
              </div>
            </div>

            <!-- Interactive Activity Types Chips (Kategori / Tema Wisata) -->
            <div class="hero-activity-chips-wrap">
              <span class="chips-label">Tema / Kategori Wisata:</span>
              <div class="chips-grid">
                <div 
                  v-for="act in activityTypes" 
                  :key="act.id" 
                  class="act-chip" 
                  :class="{ active: selectedActivityTypes.includes(act.id) }"
                  @click="toggleActivityType(act.id)"
                >
                  <v-icon :name="selectedActivityTypes.includes(act.id) ? 'check' : 'add'" small />
                  <span>{{ act.name }}</span>
                </div>
              </div>
            </div>

          </div>
        </div>

        <!-- 2. SECTION TENTANG PAKET INI (DESKRIPSI DENGAN TIPTAP VISUAL EDITOR) -->
        <div class="section-container" @click.stop>
          <div style="display: flex; gap: 32px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 300px;">
              <div class="section-label-top">TENTANG PAKET INI</div>
              <h2 class="section-title-frontend">{{ editingPackage.name || 'Judul Paket Wisata' }}</h2>
              <div class="orange-underline-bar"></div>
              
              <div class="tiptap-wrapper" style="margin-top: 16px;">
                <div class="tiptap-toolbar" v-if="editor">
              <v-button small icon secondary @click="editor.chain().focus().toggleBold().run()" :class="{ 'is-active': editor.isActive('bold') }" title="Bold"><v-icon name="format_bold" /></v-button>
              <v-button small icon secondary @click="editor.chain().focus().toggleItalic().run()" :class="{ 'is-active': editor.isActive('italic') }" title="Italic"><v-icon name="format_italic" /></v-button>
              <v-button small icon secondary @click="editor.chain().focus().toggleUnderline().run()" :class="{ 'is-active': editor.isActive('underline') }" title="Underline"><v-icon name="format_underlined" /></v-button>
              <span class="toolbar-sep"></span>
              <v-button small icon secondary @click="editor.chain().focus().toggleHeading({ level: 2 }).run()" :class="{ 'is-active': editor.isActive('heading', { level: 2 }) }" title="Heading 2">H2</v-button>
              <v-button small icon secondary @click="editor.chain().focus().toggleHeading({ level: 3 }).run()" :class="{ 'is-active': editor.isActive('heading', { level: 3 }) }" title="Heading 3">H3</v-button>
              <span class="toolbar-sep"></span>
              <v-button small icon secondary @click="editor.chain().focus().toggleBulletList().run()" :class="{ 'is-active': editor.isActive('bulletList') }" title="Bullet List"><v-icon name="format_list_bulleted" /></v-button>
              <v-button small icon secondary @click="editor.chain().focus().toggleOrderedList().run()" :class="{ 'is-active': editor.isActive('orderedList') }" title="Numbered List"><v-icon name="format_list_numbered" /></v-button>
              <v-button small icon secondary @click="editor.chain().focus().toggleBlockquote().run()" :class="{ 'is-active': editor.isActive('blockquote') }" title="Quote"><v-icon name="format_quote" /></v-button>
              <span class="toolbar-sep"></span>
              <v-button small icon secondary @click="editor.chain().focus().setTextAlign('left').run()" :class="{ 'is-active': editor.isActive({ textAlign: 'left' }) }" title="Align Left"><v-icon name="format_align_left" /></v-button>
              <v-button small icon secondary @click="editor.chain().focus().setTextAlign('center').run()" :class="{ 'is-active': editor.isActive({ textAlign: 'center' }) }" title="Align Center"><v-icon name="format_align_center" /></v-button>
              <span class="toolbar-sep"></span>
              <v-button small icon secondary @click="editor.chain().focus().undo().run()" title="Undo"><v-icon name="undo" /></v-button>
              <v-button small icon secondary @click="editor.chain().focus().redo().run()" title="Redo"><v-icon name="redo" /></v-button>
            </div>
            <editor-content :editor="editor" class="tiptap-content-box" />
              </div>
            </div>
            
            <div style="width: 320px; flex-shrink: 0; padding-top: 8px;">
              <div class="section-label-top" style="margin-bottom: 4px;">POSTER GAMBAR (1:1)</div>
              <p style="font-size: 13px; color: var(--theme--foreground-subdued); margin-bottom: 16px;">Tampil di sebelah teks "Tentang Paket Ini".</p>
              
              <div 
                style="width: 100%; aspect-ratio: 1/1; background: var(--theme--background-normal); border: 2px dashed var(--theme--border-color); border-radius: 12px; overflow: hidden; cursor: pointer; display: flex; align-items: center; justify-content: center; position: relative; transition: all 0.2s;"
                @click="openMediaDialog('poster')"
                onmouseover="this.style.borderColor='var(--theme--primary)'"
                onmouseout="this.style.borderColor='var(--theme--border-color)'"
              >
                <img v-if="editingPackage.poster" :src="getImageSrc(editingPackage.poster)" style="width: 100%; height: 100%; object-fit: cover;" />
                <div v-else style="display: flex; flex-direction: column; align-items: center; color: var(--theme--foreground-subdued);">
                  <v-icon name="add_photo_alternate" large />
                  <span style="margin-top: 8px; font-weight: 500;">Pilih Poster</span>
                </div>
              </div>
              <v-button v-if="editingPackage.poster" style="margin-top: 16px; width: 100%;" small secondary danger @click.stop="editingPackage.poster = null">Hapus Poster</v-button>
            </div>
          </div>
        </div>

        <!-- 3. SIDE-BY-SIDE LAYOUT: FASILITAS TERMASUK (KIRI) & RENCANA PERJALANAN / ITINERARY (KANAN) -->
        <!-- Menerapkan custom CSS Grid (.detail-grid-container) agar 100% berdampingan secara presisi -->
        <div class="section-box-tinted" @click.stop>
          <div class="section-header-center">
            <div class="section-label-top">DETAIL</div>
            <h2 class="section-title-frontend">Fasilitas & Itinerary</h2>
            <p class="section-subtitle">Jadwal perjalanan dan fasilitas selama {{ editingPackage.duration || 'tour' }}.</p>
          </div>

          <!-- Custom Grid Layout Kiri Kanan (1fr 1.5fr) -->
          <div class="detail-grid-container">
            
            <!-- KOLOM KIRI (1fr): FASILITAS TERMASUK -->
            <div class="feature-card-box">
              <h3 class="card-box-title">Fasilitas Termasuk</h3>
              
              <div class="facilities-list-frontend">
                <div v-for="(fac, fIdx) in editingPackage.facilities" :key="fIdx" class="fac-item-row">
                  <v-icon name="check_circle" class="fac-check-icon" />
                  <input v-model="editingPackage.facilities[fIdx]" class="fac-input-clean" placeholder="Rincian fasilitas (misal: Transportasi AC)..." />
                  <div class="fac-row-actions">
                    <v-button small icon round secondary @click="moveFacility(fIdx, -1)" :disabled="fIdx === 0" title="Geser ke Atas"><v-icon name="arrow_upward" /></v-button>
                    <v-button small icon round secondary @click="moveFacility(fIdx, 1)" :disabled="fIdx === editingPackage.facilities.length - 1" title="Geser ke Bawah"><v-icon name="arrow_downward" /></v-button>
                    <v-button small icon round secondary @click="removeFacility(fIdx)" title="Hapus Fasilitas"><v-icon name="delete" class="text-red" /></v-button>
                  </div>
                </div>
              </div>

              <div class="card-box-footer">
                <v-button small secondary @click="addFacility" class="btn-full-width"><span style="font-weight: 800; font-size: 14px; margin-right: 6px; color: #EE7D0F;">+</span> Tambah Fasilitas Termasuk</v-button>
              </div>
            </div>

            <!-- KOLOM KANAN (1.5fr): RENCANA PERJALANAN / ITINERARY -->
            <div class="feature-card-box">
              <h3 class="card-box-title">Rencana Perjalanan</h3>

              <!-- Timeline Vertikal Terbuka (Tanpa kotak card per hari!) -->
              <div class="timeline-open-frontend">
                <!-- Garis Vertikal Lurus -->
                <div class="timeline-vert-line"></div>

                <div class="timeline-days-list">
                  <div v-for="(day, dIdx) in editingPackage.itinerary" :key="dIdx" class="timeline-day-open">
                    
                    <!-- Day Marker Circle Oranye di Kiri -->
                    <div class="day-circle-marker">
                      {{ String(day.day || dIdx + 1).padStart(2, '0') }}
                    </div>

                    <!-- Area Konten di Kanan Marker -->
                    <div class="day-open-content">
                      <div class="day-title-row">
                        <input v-model="day.title" class="day-title-input-clean" placeholder="Judul Hari Ini (misal: Tiba di Bali & Uluwatu Sunset)..." />
                        <v-button small icon round secondary @click="removeDay(dIdx)" title="Hapus Hari Ini"><v-icon name="delete" class="text-red" /></v-button>
                      </div>

                      <!-- Bullet List Activities (Titik bullet kecil) -->
                      <ul class="activities-ul-clean">
                        <li v-for="(act, aIdx) in day.activities" :key="aIdx" class="act-li-row">
                          <span class="act-bullet-small"></span>
                          <input v-model="day.activities[aIdx]" class="act-input-clean" placeholder="Rincian kegiatan & jam (misal: 14:00 - Check-in Hotel)..." />
                          <v-button small icon round secondary @click="removeActivity(dIdx, aIdx)" title="Hapus Kegiatan"><v-icon name="close" /></v-button>
                        </li>
                      </ul>

                      <!-- Tombol Tambah Kegiatan di Bawah List Hari Ini -->
                      <div class="day-actions-row">
                        <v-button small secondary @click="addActivity(dIdx)"><span style="font-weight: 800; font-size: 14px; margin-right: 6px; color: #EE7D0F;">+</span> Tambah Kegiatan Itinerary</v-button>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="timeline-footer">
                  <v-button @click="addDay"><span style="font-weight: 800; font-size: 16px; margin-right: 6px; color: #EE7D0F;">+</span> Tambah Hari Perjalanan Baru</v-button>
                </div>
              </div>
            </div>

          </div>
        </div>

        <!-- 4. SIDE-BY-SIDE LAYOUT: TABEL HARGA PAKET -->
        <!-- Menerapkan .price-tables-grid dengan cols-1, cols-2, cols-3 agar berdampingan secara otomatis -->
        <div class="section-box-tinted" @click.stop>
          <div class="section-header-center">
            <div class="section-label-top">HARGA</div>
            <h2 class="section-title-frontend">Harga Paket & Tambahan</h2>
            <p class="section-subtitle">Harga per orang berdasarkan jumlah peserta</p>
          </div>

          <!-- Grid Tabel Harga Berdampingan (1, 2, atau 3 kolom) -->
          <div class="price-tables-grid" :class="'cols-' + Math.min(editingPackage.price_tiers.length, 3)">
            <div v-for="(group, gIdx) in editingPackage.price_tiers" :key="gIdx" class="price-group-card">
              
              <!-- Judul Tabel Harga -->
              <div class="price-group-header">
                <input v-model="group.table_title" class="price-table-title-input" placeholder="Nama Tabel Harga (misal: Harga Domestik WNI)..." />
                <v-button small icon round secondary @click="removePriceTable(gIdx)" title="Hapus Tabel Harga Ini"><v-icon name="delete" class="text-red" /></v-button>
              </div>

              <!-- Tabel Desain Persis PriceTable.astro (Header Navy #0B2340, Harga Bold Oranye) -->
              <div class="table-card-wrapper">
                <table class="custom-data-table">
                  <thead>
                    <tr>
                      <th>Jumlah Peserta (Pax)</th>
                      <th>Harga / Orang (Rp)</th>
                      <th>Keterangan</th>
                      <th width="50" class="text-right">Aksi</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(tier, tIdx) in group.tiers" :key="tIdx">
                      <td class="whitespace-nowrap">
                        <div class="pax-input-group">
                          <input type="number" v-model="tier.min_pax" class="tier-num-clean" placeholder="2" />
                          <span>-</span>
                          <input type="number" v-model="tier.max_pax" class="tier-num-clean" placeholder="5" />
                          <span>orang</span>
                        </div>
                      </td>
                      <td class="whitespace-nowrap">
                        <div class="price-input-group">
                          <span>Rp</span>
                          <input type="number" v-model="tier.price_per_pax" class="tier-price-clean" placeholder="2500000" />
                        </div>
                      </td>
                      <td>
                        <input v-model="tier.description" class="tier-desc-clean" placeholder="misal: Hotel Bintang 3" />
                      </td>
                      <td class="text-right">
                        <v-button small icon round secondary @click="removePriceTier(gIdx, tIdx)" title="Hapus Baris"><v-icon name="close" /></v-button>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <div class="table-card-footer">
                  <v-button small secondary @click="addPriceTier(gIdx)"><span style="font-weight: 800; font-size: 14px; margin-right: 6px; color: #EE7D0F;">+</span> Tambah Baris Harga (Pax)</v-button>
                </div>
              </div>
            </div>
          </div>

          <div class="add-table-btn-wrapper" v-if="editingPackage.price_tiers.length < 3">
            <v-button @click="addPriceTable"><span style="font-weight: 800; font-size: 16px; margin-right: 6px; color: #EE7D0F;">+</span> Tambah Kategori Tabel Harga (misal: WNI/WNA/Bintang 4)</v-button>
          </div>

          <!-- SUB-SECTION: FASILITAS TAMBAHAN / ADD-ONS -->
          <div class="addon-table-section">
            <h4 class="addon-section-title">Fasilitas Tambahan (Opsional / Add-ons)</h4>
            
            <div class="table-card-wrapper max-w-800">
              <table class="custom-data-table">
                <thead>
                  <tr>
                    <th>Layanan / Fasilitas Tambahan</th>
                    <th>Harga Tambahan (Rp)</th>
                    <th width="50" class="text-right">Aksi</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(addon, aIdx) in editingPackage.addons" :key="aIdx">
                    <td>
                      <input v-model="addon.addon_name" class="addon-name-input" placeholder="Nama layanan (misal: Dokumentasi Drone)..." />
                      <input v-model="addon.description" class="addon-desc-input" placeholder="Keterangan (misal: Termasuk video cinematic 1 menit)..." />
                    </td>
                    <td class="whitespace-nowrap align-top">
                      <div class="price-input-group mt-1">
                        <span>+Rp</span>
                        <input type="number" v-model="addon.price" class="tier-price-clean" placeholder="1500000" />
                      </div>
                    </td>
                    <td class="text-right align-top">
                      <v-button small icon round secondary @click="removeAddon(aIdx)" title="Hapus Add-on"><v-icon name="close" /></v-button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div class="table-card-footer">
                <v-button small secondary @click="addAddon"><span style="font-weight: 800; font-size: 14px; margin-right: 6px; color: #EE7D0F;">+</span> Tambah Layanan Add-on</v-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 5. SECTION GALERI FOTO DOKUMENTASI -->
        <div class="section-container mb-12" @click.stop>
          <div class="section-header-center mb-8">
            <div class="section-label-top">GALERI</div>
            <h2 class="section-title-frontend">Foto {{ editingPackage.name || 'Dokumentasi' }}</h2>
            <p class="section-subtitle">{{ galleryImages.length }} foto tersedia</p>
          </div>

          <div class="gallery-builder-grid">
            <div v-for="(img, idx) in galleryImages" :key="idx" class="gallery-thumb-card">
              <img :src="getImageSrc(img)" alt="Gallery Photo" />
              <div class="gallery-hover-actions">
                <v-button small icon round @click="removeGalleryImage(idx)" title="Hapus Foto dari Galeri"><v-icon name="delete" class="text-red" /></v-button>
              </div>
            </div>

            <div class="gallery-add-box" @click="openMediaDialog('gallery')" title="Klik untuk menambahkan foto ke galeri">
              <v-icon name="add_photo_alternate" large class="text-orange mb-2" />
              <span><strong style="font-size: 16px; margin-right: 4px; color: #EE7D0F;">+</strong> Tambah Foto Galeri Dokumentasi</span>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- Directus Media Library Dialog -->
  <v-dialog v-model="showMediaDialog" @esc="showMediaDialog = false">
    <v-card class="media-library-card">
      <v-card-title class="media-header">
        <span>Directus Media Library ({{ mediaTarget === 'cover' ? 'Cover Banner' : (mediaTarget === 'poster' ? 'Poster Vertikal' : 'Galeri Foto') }})</span>
        <div>
          <input type="file" ref="fileInput" @change="handleFileUpload" accept="image/*" style="display:none" />
          <button class="btn-upload" @click="$refs.fileInput.click()" :disabled="isUploading">
            <span style="font-weight: 800; font-size: 15px; margin-right: 6px; color: #EE7D0F;">+</span> {{ isUploading ? 'Mengunggah...' : 'Unggah Gambar dari Komputer' }}
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
              <img :src="`/assets/${file.id}?width=200&height=200&fit=cover`" :alt="file.title || file.filename_download" loading="lazy" />
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

  <!-- Confirm Delete Package Dialog -->
  <v-dialog v-model="showDeleteDialog" @esc="showDeleteDialog = false">
    <v-card>
      <v-card-title>Hapus Paket Wisata?</v-card-title>
      <v-card-text>
        Apakah Anda yakin ingin menghapus paket wisata <strong>{{ packageToDelete?.name }}</strong>? Tindakan ini tidak dapat dibatalkan.
      </v-card-text>
      <v-card-actions>
        <v-button secondary @click="showDeleteDialog = false">Batal</v-button>
        <v-button danger :loading="deleting" @click="executeDelete">Hapus Permanen</v-button>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import { useApi } from '@directus/extensions-sdk';
import { useEditor, EditorContent } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';
import Underline from '@tiptap/extension-underline';
import Link from '@tiptap/extension-link';
import Image from '@tiptap/extension-image';
import TextAlign from '@tiptap/extension-text-align';

export default {
  components: {
    EditorContent
  },
  setup() {
    const api = useApi();
    
    // State Collections
    const packages = ref([]);
    const destinations = ref([]);
    const activityTypes = ref([]);
    
    // Dashboard Filter & Search
    const loadingPackages = ref(false);
    const searchQuery = ref('');
    const statusFilter = ref(null);
    const statusOptions = [
      { text: 'Published', value: 'published' },
      { text: 'Draft', value: 'draft' },
      { text: 'Archived', value: 'archived' }
    ];

    // Editing State
    const editingPackage = ref(null);
    const saving = ref(false);

    // Destination Search Popover State
    const showDestDropdown = ref(false);
    const destSearchQuery = ref('');
    const destInputRef = ref(null);

    // M2M relations state
    const originalGalleryIds = ref([]);
    const galleryImages = ref([]);
    
    const originalActivityTypeIds = ref([]);
    const selectedActivityTypes = ref([]);

    // Media Library Dialog State
    const showMediaDialog = ref(false);
    const mediaTarget = ref(null);
    const mediaFiles = ref([]);
    const loadingMedia = ref(false);
    const mediaSearchQuery = ref('');
    const selectedMediaFile = ref(null);
    const isUploading = ref(false);
    const fileInput = ref(null);

    // Delete Dialog State
    const showDeleteDialog = ref(false);
    const packageToDelete = ref(null);
    const deleting = ref(false);

    // TipTap Editor Setup
    const editor = useEditor({
      content: '',
      extensions: [
        StarterKit,
        Underline,
        Link.configure({ openOnClick: false }),
        Image,
        TextAlign.configure({ types: ['heading', 'paragraph'] })
      ],
      onUpdate: () => {
        if (editingPackage.value && editor.value) {
          editingPackage.value.description = editor.value.getHTML();
        }
      }
    });

    watch(() => editingPackage.value?.description, (newVal) => {
      if (editor.value && editor.value.getHTML() !== newVal) {
        editor.value.commands.setContent(newVal || '');
      }
    });

    // Fetch Methods
    const fetchPackages = async () => {
      loadingPackages.value = true;
      try {
        const res = await api.get('/items/packages', {
          params: {
            fields: ['*'],
            sort: '-id',
            limit: -1
          }
        });
        packages.value = res.data.data || [];
      } catch (err) {
        console.error('Gagal memuat daftar paket:', err);
      } finally {
        loadingPackages.value = false;
      }
    };

    const fetchDependencies = async () => {
      try {
        const [destRes, actRes] = await Promise.all([
          api.get('/items/destinations', { params: { limit: -1, sort: 'name' } }),
          api.get('/items/activity_types', { params: { limit: -1, sort: 'name' } })
        ]);
        destinations.value = destRes.data.data || [];
        activityTypes.value = actRes.data.data || [];
      } catch (err) {
        console.error('Gagal memuat dependensi destinasi/kategori:', err);
      }
    };

    onMounted(() => {
      fetchPackages();
      fetchDependencies();
    });

    // Dashboard Computeds & Helpers
    const currentPage = ref(1);
    const itemsPerPage = ref(10);
    watch([searchQuery, statusFilter], () => { currentPage.value = 1; });

    const filteredPackages = computed(() => {
      return packages.value.filter(p => {
        const matchSearch = (p.name?.toLowerCase() || '').includes(searchQuery.value.toLowerCase()) ||
                            (p.slug?.toLowerCase() || '').includes(searchQuery.value.toLowerCase());
        const matchStatus = !statusFilter.value || p.status === statusFilter.value;
        return matchSearch && matchStatus;
      });
    });

    const totalPages = computed(() => Math.ceil(filteredPackages.value.length / itemsPerPage.value) || 1);
    const paginatedPackages = computed(() => {
      const start = (currentPage.value - 1) * itemsPerPage.value;
      return filteredPackages.value.slice(start, start + itemsPerPage.value);
    });

    const getStatusCount = (status) => {
      return packages.value.filter(p => p.status === status).length;
    };

    const getDestinationName = (id) => {
      if (!id) return 'Pilih Destinasi';
      const destId = typeof id === 'object' ? id.id : id;
      const dest = destinations.value.find(d => d.id === destId);
      return dest ? dest.name : 'Destinasi #' + destId;
    };

    const filteredDestinations = computed(() => {
      if (!destSearchQuery.value) return destinations.value;
      const q = destSearchQuery.value.toLowerCase();
      return destinations.value.filter(d => (d.name?.toLowerCase() || '').includes(q));
    });

    const toggleDestDropdown = () => {
      showDestDropdown.value = !showDestDropdown.value;
      if (showDestDropdown.value) {
        destSearchQuery.value = '';
        nextTick(() => {
          if (destInputRef.value) destInputRef.value.focus();
        });
      }
    };

    const selectDestination = (id) => {
      editingPackage.value.destination_id = id;
      showDestDropdown.value = false;
    };

    const closeAllPopovers = () => {
      showDestDropdown.value = false;
    };

    const getImageSrc = (id) => {
      if (!id) return '';
      const fileId = typeof id === 'object' ? id.id : id;
      return `/assets/${fileId}?width=100&height=100&fit=cover`;
    };

    const getStartingPrice = (priceTiers) => {
      if (!priceTiers || !Array.isArray(priceTiers) || priceTiers.length === 0) return 0;
      let min = Infinity;
      for (const group of priceTiers) {
        if (group.tiers && Array.isArray(group.tiers)) {
          for (const t of group.tiers) {
            const p = Number(t.price_per_pax) || 0;
            if (p > 0 && p < min) min = p;
          }
        }
      }
      return min === Infinity ? 0 : min;
    };

    const formatPrice = (val) => {
      if (!val || val === 0) return 'Hubungi Kami';
      return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', maximumFractionDigits: 0 }).format(val);
    };

    const formatDate = (dateStr) => {
      if (!dateStr) return '';
      return new Date(dateStr).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' });
    };

    // Hero Style
    const heroBannerStyle = computed(() => {
      if (editingPackage.value?.image) {
        const fileId = typeof editingPackage.value.image === 'object' ? editingPackage.value.image.id : editingPackage.value.image;
        return { backgroundImage: `url(/assets/${fileId})`, backgroundSize: 'cover', backgroundPosition: 'center' };
      }
      return { background: '#0b2340' };
    });

    // Create & Edit Logic
    const createNewPackage = () => {
      editingPackage.value = {
        name: '',
        slug: '',
        destination_id: '',
        status: 'draft',
        duration: '3 Hari 2 Malam',
        max_participants: null,
        description: '',
        facilities: ['Transportasi AC berstandar pariwisata', 'Akomodasi hotel bintang sesuai pilihan', 'Tiket masuk seluruh objek wisata', 'Air mineral & snack selama perjalanan'],
        itinerary: [
          { day: 1, title: 'Kedatangan & Check-in Hotel', activities: ['Penjemputan di Bandara / Stasiun oleh tim Voda Tour', 'Makan siang di restoran lokal', 'Check-in hotel dan istirahat sore', 'Makan malam selamat datang (Welcome Dinner)'] },
          { day: 2, title: 'Tour Destinasi Utama & Sunset', activities: ['Sarapan pagi di hotel', 'Mengunjungi objek wisata pilihan 1', 'Makan siang berwisata kuliner', 'Menikmati sunset dan foto bersama'] }
        ],
        price_tiers: [
          {
            table_title: 'Harga Paket Domestik (WNI)',
            tiers: [
              { min_pax: 2, max_pax: 3, price_per_pax: 2850000, description: 'Hotel Bintang 3' },
              { min_pax: 4, max_pax: 6, price_per_pax: 2450000, description: 'Hotel Bintang 3' },
              { min_pax: 7, max_pax: 12, price_per_pax: 2150000, description: 'Hotel Bintang 3' }
            ]
          }
        ],
        addons: [
          { addon_name: 'Dokumentasi Drone & DSLR Profesional', price: 1500000, description: 'Termasuk editing video cinematic 1 menit & seluruh file asli' },
          { addon_name: 'Upgrade Kamar Hotel Bintang 4', price: 350000, description: 'Harga per kamar per malam' }
        ],
        image: null,
        poster: null
      };
      originalGalleryIds.value = [];
      galleryImages.value = [];
      originalActivityTypeIds.value = [];
      selectedActivityTypes.value = [];
      if (editor.value) editor.value.commands.setContent(editingPackage.value.description);
    };

    const editPackage = async (pkg) => {
      try {
        const res = await api.get(`/items/packages/${pkg.id}`, {
          params: {
            fields: ['*', 'gallery.*', 'activity_types.*']
          }
        });
        const data = res.data.data;
        
        editingPackage.value = {
          ...data,
          facilities: Array.isArray(data.facilities) ? data.facilities : [],
          itinerary: Array.isArray(data.itinerary) ? data.itinerary : [],
          price_tiers: Array.isArray(data.price_tiers) ? data.price_tiers : [],
          addons: Array.isArray(data.addons) ? data.addons : []
        };

        const gal = data.gallery || [];
        originalGalleryIds.value = gal.map(g => g.directus_files_id?.id || g.directus_files_id || g);
        galleryImages.value = [...originalGalleryIds.value];

        const act = data.activity_types || [];
        originalActivityTypeIds.value = act.map(a => a.activity_type_id?.id || a.activity_type_id || a);
        selectedActivityTypes.value = [...originalActivityTypeIds.value];

        if (editor.value) editor.value.commands.setContent(editingPackage.value.description || '');
      } catch (err) {
        console.error('Gagal memuat detail paket wisata:', err);
      }
    };

    const cancelEdit = () => {
      editingPackage.value = null;
      showDestDropdown.value = false;
    };

    const generateSlug = () => {
      if (editingPackage.value && editingPackage.value.name) {
        editingPackage.value.slug = editingPackage.value.name
          .toLowerCase()
          .replace(/[^a-z0-9 -]/g, '')
          .replace(/\s+/g, '-')
          .replace(/-+/g, '-');
      }
    };

    const toggleActivityType = (actId) => {
      const idx = selectedActivityTypes.value.indexOf(actId);
      if (idx > -1) {
        selectedActivityTypes.value.splice(idx, 1);
      } else {
        selectedActivityTypes.value.push(actId);
      }
    };

    // Save Package Logic
    const savePackage = async () => {
      if (!editingPackage.value.name) {
        alert('Judul Paket Wisata wajib diisi!');
        return;
      }
      if (!editingPackage.value.slug) generateSlug();

      saving.value = true;
      try {
        const payload = {
          name: editingPackage.value.name,
          slug: editingPackage.value.slug,
          destination_id: editingPackage.value.destination_id || null,
          status: editingPackage.value.status || 'draft',
          duration: editingPackage.value.duration || '',
          max_participants: null,
          description: editingPackage.value.description || '',
          facilities: editingPackage.value.facilities || [],
          itinerary: editingPackage.value.itinerary || [],
          price_tiers: editingPackage.value.price_tiers || [],
          addons: editingPackage.value.addons || [],
          image: editingPackage.value.image || null,
          poster: editingPackage.value.poster || null
        };

        let pkgId = editingPackage.value.id;
        if (pkgId) {
          await api.patch(`/items/packages/${pkgId}`, payload);
        } else {
          const createRes = await api.post('/items/packages', payload);
          pkgId = createRes.data.data.id;
        }

        // Sync Gallery (M2M packages_files)
        const currentGalRes = await api.get(`/items/packages_files`, { params: { filter: { packages_id: { _eq: pkgId } } } });
        const currentGal = currentGalRes.data.data || [];
        const galToDelete = currentGal.filter(g => !galleryImages.value.includes(g.directus_files_id)).map(g => g.id);
        const existingGalFiles = currentGal.map(g => g.directus_files_id);
        const galToAdd = galleryImages.value.filter(fid => !existingGalFiles.includes(fid)).map((fid) => ({
          packages_id: pkgId,
          directus_files_id: fid
        }));

        if (galToDelete.length > 0) await api.delete(`/items/packages_files`, { data: galToDelete });
        if (galToAdd.length > 0) await api.post(`/items/packages_files`, galToAdd);

        // Sync Activity Types (M2M packages_activity_types)
        const currentActRes = await api.get(`/items/packages_activity_types`, { params: { filter: { packages_id: { _eq: pkgId } } } });
        const currentAct = currentActRes.data.data || [];
        const actToDelete = currentAct.filter(a => !selectedActivityTypes.value.includes(a.activity_types_id)).map(a => a.id);
        const existingActIds = currentAct.map(a => a.activity_types_id);
        const actToAdd = selectedActivityTypes.value.filter(id => !existingActIds.includes(id)).map(id => ({
          packages_id: pkgId,
          activity_types_id: id
        }));

        if (actToDelete.length > 0) await api.delete(`/items/packages_activity_types`, { data: actToDelete });
        if (actToAdd.length > 0) await api.post(`/items/packages_activity_types`, actToAdd);

        await fetchPackages();
        cancelEdit();
      } catch (err) {
        console.error('Gagal menyimpan paket wisata:', err);
        alert('Gagal menyimpan paket wisata. Periksa koneksi atau validasi form.');
      } finally {
        saving.value = false;
      }
    };

    // Delete Package Logic
    const confirmDelete = (pkg) => {
      packageToDelete.value = pkg;
      showDeleteDialog.value = true;
    };

    const executeDelete = async () => {
      if (!packageToDelete.value) return;
      deleting.value = true;
      try {
        await api.delete(`/items/packages/${packageToDelete.value.id}`);
        showDeleteDialog.value = false;
        packageToDelete.value = null;
        await fetchPackages();
      } catch (err) {
        console.error('Gagal menghapus paket:', err);
        alert('Gagal menghapus paket wisata.');
      } finally {
        deleting.value = false;
      }
    };

    // Facilities Actions
    const addFacility = () => editingPackage.value.facilities.push('');
    const removeFacility = (idx) => editingPackage.value.facilities.splice(idx, 1);
    const moveFacility = (idx, dir) => {
      const arr = editingPackage.value.facilities;
      const targetIdx = idx + dir;
      if (targetIdx >= 0 && targetIdx < arr.length) {
        [arr[idx], arr[targetIdx]] = [arr[targetIdx], arr[idx]];
      }
    };

    // Itinerary Actions
    const addDay = () => editingPackage.value.itinerary.push({ day: editingPackage.value.itinerary.length + 1, title: '', activities: [''] });
    const removeDay = (idx) => {
      editingPackage.value.itinerary.splice(idx, 1);
      editingPackage.value.itinerary.forEach((d, i) => d.day = i + 1);
    };
    const addActivity = (dayIdx) => editingPackage.value.itinerary[dayIdx].activities.push('');
    const removeActivity = (dayIdx, actIdx) => editingPackage.value.itinerary[dayIdx].activities.splice(actIdx, 1);

    // Price Tiers Actions
    const addPriceTable = () => editingPackage.value.price_tiers.push({ table_title: '', tiers: [{ min_pax: 2, max_pax: 5, price_per_pax: 2000000, description: '' }] });
    const removePriceTable = (idx) => editingPackage.value.price_tiers.splice(idx, 1);
    const addPriceTier = (groupIndex) => editingPackage.value.price_tiers[groupIndex].tiers.push({ min_pax: 1, max_pax: 2, price_per_pax: 0, description: '' });
    const removePriceTier = (gIdx, tIdx) => editingPackage.value.price_tiers[gIdx].tiers.splice(tIdx, 1);

    // Addons Actions
    const addAddon = () => editingPackage.value.addons.push({ addon_name: '', price: 0, description: '' });
    const removeAddon = (idx) => editingPackage.value.addons.splice(idx, 1);

    // Media Library Methods
    const openMediaDialog = async (target) => {
      mediaTarget.value = target;
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
        mediaFiles.value = res.data.data || [];
      } catch (err) {
        console.error('Gagal memuat media library:', err);
      } finally {
        loadingMedia.value = false;
      }
    };
    
    const confirmMediaSelect = () => {
      if (!selectedMediaFile.value) return;
      const file = selectedMediaFile.value;
      if (mediaTarget.value === 'cover') {
        editingPackage.value.image = file.id;
      } else if (mediaTarget.value === 'poster') {
        editingPackage.value.poster = file.id;
      } else if (mediaTarget.value === 'gallery') {
        if (!galleryImages.value.includes(file.id)) {
          galleryImages.value.push(file.id);
        }
      }
      showMediaDialog.value = false;
    };

    const filteredMediaFiles = computed(() => {
      if (!mediaSearchQuery.value) return mediaFiles.value;
      const q = mediaSearchQuery.value.toLowerCase();
      return mediaFiles.value.filter(f => 
        (f.title?.toLowerCase() || '').includes(q) || 
        (f.filename_download?.toLowerCase() || '').includes(q)
      );
    });

    const handleFileUpload = async (event) => {
      const files = event.target.files;
      if (!files || files.length === 0) return;
      const file = files[0];
      
      const formData = new FormData();
      formData.append('title', file.name.replace(/\.[^/.]+$/, ''));
      formData.append('file', file);

      isUploading.value = true;
      try {
        const res = await api.post('/files', formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        const uploadedFile = res.data.data;
        mediaFiles.value.unshift(uploadedFile);
        selectedMediaFile.value = uploadedFile;
        confirmMediaSelect();
      } catch (err) {
        console.error('Upload error', err);
        alert('Gagal mengunggah gambar dari komputer.');
      } finally {
        isUploading.value = false;
        if (fileInput.value) fileInput.value.value = '';
      }
    };

    const removeGalleryImage = (idx) => {
      galleryImages.value.splice(idx, 1);
    };

    return {
      packages, filteredPackages, loadingPackages, searchQuery, statusFilter, statusOptions, getStatusCount,
      currentPage, totalPages, paginatedPackages,
      destinations, activityTypes, getDestinationName, getImageSrc, getStartingPrice, formatPrice, formatDate,
      editingPackage, editPackage, createNewPackage, cancelEdit, savePackage, saving, generateSlug,
      toggleActivityType, selectedActivityTypes, heroBannerStyle,
      showDestDropdown, destSearchQuery, destInputRef, filteredDestinations, toggleDestDropdown, selectDestination, closeAllPopovers,
      addFacility, removeFacility, moveFacility,
      addDay, removeDay, addActivity, removeActivity,
      addPriceTable, removePriceTable, addPriceTier, removePriceTier,
      addAddon, removeAddon,
      showMediaDialog, mediaTarget, mediaFiles, loadingMedia, mediaSearchQuery, filteredMediaFiles,
      selectedMediaFile, isUploading, fileInput, openMediaDialog, confirmMediaSelect, handleFileUpload,
      galleryImages, removeGalleryImage,
      showDeleteDialog, packageToDelete, confirmDelete, executeDelete, deleting,
      editor
    };
  }
};
</script>

<style scoped>
/* DASHBOARD STYLES (TABLE VIEW ALA ARTIKEL) */
.nav-filter-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 8px 0;
}
.nav-filter-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  border-radius: 6px;
  cursor: pointer;
  color: #475569;
  font-weight: 500;
  font-size: 14px;
  transition: all 0.15s ease;
}
.nav-filter-item:hover {
  background: #f1f5f9;
  color: #0b2340;
}
.nav-filter-item.active {
  background: rgba(238, 125, 15, 0.1);
  color: #EE7D0F;
  font-weight: 600;
}
.nav-filter-item .count {
  margin-left: auto;
  background: #e2e8f0;
  color: #64748b;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
}
.nav-filter-item.active .count {
  background: #EE7D0F;
  color: #fff;
}
.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
.status-dot.published { background: #00C853; }
.status-dot.draft { background: #FF9800; }
.status-dot.archived { background: #94a3b8; }

.dashboard-main-content {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.dashboard-top-search {
  width: 100%;
}
.search-input-full {
  width: 100%;
}

.loading-state, .empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  color: #64748b;
  gap: 16px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.table-responsive-wrapper {
  background: #fff;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  overflow-x: auto;
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
}
.package-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}
.package-table th {
  background: #f8fafc;
  padding: 14px 16px;
  font-weight: 600;
  font-size: 13px;
  color: #475569;
  border-bottom: 2px solid #e2e8f0;
}
.package-table td {
  padding: 16px;
  border-bottom: 1px solid #f1f5f9;
  vertical-align: middle;
}
.package-table tbody tr {
  cursor: pointer;
  transition: background 0.15s ease;
}
.package-table tbody tr:hover {
  background: #f8fafc;
}
.thumb-box {
  width: 50px;
  height: 50px;
  border-radius: 8px;
  overflow: hidden;
  background: #f1f5f9;
  display: flex;
  align-items: center;
  justify-content: center;
}
.table-thumb {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.thumb-placeholder {
  color: #94a3b8;
}
.pkg-title {
  font-weight: 700;
  font-size: 15px;
  color: #0b2340;
  margin-bottom: 4px;
}
.pkg-slug {
  font-size: 12px;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 4px;
}
.pkg-dest {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 500;
  color: #334155;
}
.text-orange { color: #EE7D0F; }
.text-red { color: #ef4444; }

.pkg-meta-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 3px 8px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}
.pkg-meta-badge.duration { background: rgba(238, 125, 15, 0.1); color: #EE7D0F; }

.pkg-price {
  font-weight: 700;
  color: #0b2340;
  font-size: 14px;
}

.status-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
}
.status-badge.published { background: rgba(0, 200, 83, 0.15); color: #00C853; }
.status-badge.draft { background: rgba(255, 152, 0, 0.15); color: #FF9800; }
.status-badge.archived { background: #e2e8f0; color: #64748b; }

.action-buttons {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
}

/* EDITOR VIEW: WORDPRESS GUTENBERG / ELEMENTOR FULLSCREEN TAKEOVER MODE (z-index: 150) */
.editor-view {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  width: 100vw !important;
  height: 100vh !important;
  z-index: 150 !important;
  background: #f8fafc !important;
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
  z-index: 10;
  flex-shrink: 0;
}
.top-bar-left, .top-bar-center, .top-bar-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.top-bar-title {
  font-weight: 700;
  font-size: 16px;
  color: #0b2340;
}
.breadcrumb-text {
  font-size: 14px;
  color: #64748b;
}

/* Scrollable Main Builder Pane */
.editor-main-scroll {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding-bottom: 120px;
}
.builder-canvas {
  max-width: 1140px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 0;
}

/* 1. HERO BANNER VISUAL BUILDER (PERSIS FRONTEND PACKAGEHERO.ASTRO) */
.package-hero-banner {
  position: relative;
  min-height: 420px;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  overflow: hidden;
  background: #0b2340;
}
.hero-gradient-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to right, rgba(11,35,64,0.95) 0%, rgba(11,35,64,0.7) 60%, rgba(11,35,64,0.15) 100%);
  z-index: 1;
}
.hero-glow-orange {
  position: absolute;
  top: -60px;
  right: -30px;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background: rgba(238, 125, 15, 0.15);
  filter: blur(60px);
  z-index: 2;
  pointer-events: none;
}
.hero-media-actions {
  position: absolute;
  top: 20px;
  right: 20px;
  display: flex;
  gap: 10px;
  z-index: 10;
}
.hero-inline-content {
  position: relative;
  z-index: 5;
  padding: 48px 40px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  max-width: 800px;
}

/* Searchable Destination Dropdown Popover */
.dest-dropdown-wrap {
  position: relative;
  width: fit-content;
}
.dest-trigger {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: rgba(255,255,255,0.7);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  padding: 4px 10px;
  border-radius: 6px;
  transition: all 0.2s ease;
  background: rgba(255,255,255,0.05);
}
.dest-trigger:hover {
  color: #fff;
  background: rgba(255,255,255,0.15);
}
.dest-popover {
  position: absolute;
  top: 100%;
  left: 0;
  margin-top: 6px;
  width: 260px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
  border: 1px solid #cbd5e1;
  z-index: 50;
  overflow: hidden;
}
.popover-search {
  padding: 8px;
  border-bottom: 1px solid #e2e8f0;
  background: #f8fafc;
}
.popover-input {
  width: 100%;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  padding: 6px 10px;
  font-size: 13px;
  outline: none;
  color: #0b2340;
  box-sizing: border-box;
}
.popover-input:focus { border-color: #EE7D0F; }
.popover-list {
  max-height: 220px;
  overflow-y: auto;
}
.popover-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  font-size: 13px;
  color: #334155;
  cursor: pointer;
  transition: background 0.15s ease;
}
.popover-item:hover { background: #f1f5f9; }
.popover-item.selected {
  background: rgba(238, 125, 15, 0.1);
  color: #EE7D0F;
  font-weight: 700;
}
.popover-empty {
  padding: 16px;
  text-align: center;
  font-size: 12px;
  color: #94a3b8;
}

.hero-title-input {
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  color: #fff;
  font-family: var(--font-display, sans-serif);
  font-size: 38px;
  font-weight: 800;
  line-height: 1.2;
  width: 100%;
  outline: none;
  padding-bottom: 4px;
  transition: border-color 0.2s;
  box-sizing: border-box;
}
.hero-title-input:focus { border-color: #EE7D0F; }
.hero-title-input::placeholder { color: rgba(255,255,255,0.4); }

.hero-slug-pill {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  color: rgba(255,255,255,0.8);
  margin-top: -8px;
}
.slug-prefix { opacity: 0.6; }
.slug-input {
  background: rgba(255,255,255,0.1);
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 4px;
  color: #EE7D0F;
  font-weight: 600;
  padding: 2px 8px;
  outline: none;
}

.hero-badges-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 4px;
}
.hero-pill {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.15);
  backdrop-filter: blur(8px);
  padding: 6px 14px;
  border-radius: 50px;
  color: #fff;
  font-size: 13px;
  font-weight: 500;
  border: 1px solid rgba(255,255,255,0.2);
}
.price-pill {
  background: rgba(238, 125, 15, 0.25);
  border-color: rgba(238, 125, 15, 0.4);
  color: #fdba74;
}
.pill-input {
  background: transparent;
  border: none;
  color: #fff;
  font-weight: 600;
  outline: none;
  width: 140px;
}
.pill-input::placeholder { color: rgba(255,255,255,0.5); }
.status-pill { padding: 4px 12px; }
.status-select-clean {
  background: transparent;
  border: none;
  color: #fff;
  font-weight: 700;
  text-transform: uppercase;
  outline: none;
  cursor: pointer;
}
.status-select-clean option { background: #0b2340; color: #fff; }

.hero-activity-chips-wrap {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 4px;
}
.chips-label {
  font-size: 11px;
  color: rgba(255,255,255,0.6);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
}
.chips-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.act-chip {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 5px 12px;
  border-radius: 50px;
  background: rgba(238, 125, 15, 0.15);
  border: 1px solid rgba(238, 125, 15, 0.3);
  color: #fdba74;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}
.act-chip:hover { background: rgba(238, 125, 15, 0.25); }
.act-chip.active {
  background: #EE7D0F;
  border-color: #EE7D0F;
  color: #fff;
  font-weight: 700;
}

/* GENERAL SECTION STYLES (100% STANDARD CSS MIRRORING FRONTEND) */
.section-container {
  padding: 64px 40px;
  background: #fff;
  border-bottom: 1px solid #f1f5f9;
}
.section-box-tinted {
  padding: 64px 40px;
  background: #f8fafc;
  border-top: 1px solid #e2e8f0;
  border-bottom: 1px solid #e2e8f0;
}
.section-label-top {
  font-size: 11px;
  font-weight: 700;
  color: #EE7D0F;
  text-transform: uppercase;
  letter-spacing: 2px;
  display: block;
  margin-bottom: 6px;
}
.section-title-frontend {
  font-family: var(--font-display, sans-serif);
  font-size: 28px;
  font-weight: 800;
  color: #0b2340;
  margin: 0;
  line-height: 1.3;
}
.section-header-center {
  text-align: center;
  margin-bottom: 36px;
}
.section-subtitle {
  color: #64748b;
  font-size: 14px;
  margin-top: 6px;
  margin-bottom: 0;
}
.orange-underline-bar {
  width: 40px;
  height: 4px;
  background: #EE7D0F;
  border-radius: 999px;
  margin-top: 12px;
}

/* TipTap Visual Editor */
.tiptap-wrapper {
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  overflow: hidden;
  max-width: 800px;
  margin-top: 24px;
  background: #fff;
}
.tiptap-toolbar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 6px;
  padding: 10px 14px;
  background: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}
.toolbar-sep {
  width: 1px;
  height: 20px;
  background: #cbd5e1;
  margin: 0 4px;
}
.is-active {
  background: #EE7D0F !important;
  color: #fff !important;
}
.tiptap-content-box {
  padding: 24px;
  min-height: 180px;
  font-size: 15px;
  line-height: 1.7;
  color: #334155;
}
:deep(.ProseMirror) {
  outline: none;
  min-height: 160px;
  overflow-wrap: break-word;
  word-wrap: break-word;
}
:deep(.ProseMirror h2) { font-size: 20px; font-weight: bold; color: #0b2340; margin: 16px 0 8px; }
:deep(.ProseMirror h3) { font-size: 17px; font-weight: bold; color: #0b2340; margin: 12px 0 6px; }
:deep(.ProseMirror ul), :deep(.ProseMirror ol) { padding-left: 20px; margin: 10px 0; }
:deep(.ProseMirror blockquote) { border-left: 4px solid #EE7D0F; padding-left: 14px; color: #64748b; font-style: italic; margin: 12px 0; }

/* 3. SIDE-BY-SIDE GRID LAYOUT (1fr 1.5fr) FOR FASILITAS & ITINERARY */
.detail-grid-container {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 32px;
  align-items: start;
  max-width: 1100px;
  margin: 0 auto;
}
@media (max-width: 1024px) {
  .detail-grid-container {
    grid-template-columns: 1fr;
  }
}

.feature-card-box {
  background: #ffffff;
  border-radius: 16px;
  padding: 24px 28px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
  border: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
}
.card-box-title {
  font-family: var(--font-display, sans-serif);
  font-size: 20px;
  font-weight: 700;
  color: #0b2340;
  margin-top: 0;
  margin-bottom: 20px;
}
.card-box-footer {
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px solid #f1f5f9;
}
.btn-full-width {
  width: 100%;
  display: flex;
  justify-content: center;
}

/* FASILITAS LIST STYLES */
.facilities-list-frontend {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.fac-item-row {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 8px 0;
  border-bottom: 1px dashed #e2e8f0;
}
.fac-check-icon {
  color: #EE7D0F;
  flex-shrink: 0;
  margin-top: 4px;
}
.fac-input-clean {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 14px;
  color: #334155;
  outline: none;
  font-weight: 500;
  line-height: 1.5;
  box-sizing: border-box;
}
.fac-row-actions {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* RENCANA PERJALANAN / ITINERARY (OPEN VERTICAL TIMELINE ALA FRONTEND - NO CARD BOX!) */
.timeline-open-frontend {
  position: relative;
  padding-left: 8px;
}
.timeline-vert-line {
  position: absolute;
  left: 27px;
  top: 16px;
  bottom: 60px;
  width: 2px;
  background: #cbd5e1;
  z-index: 1;
}
.timeline-days-list {
  display: flex;
  flex-direction: column;
  gap: 32px;
}
.timeline-day-open {
  position: relative;
  padding-left: 56px;
  z-index: 2;
}
.day-circle-marker {
  position: absolute;
  left: 8px;
  top: 0;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: #EE7D0F;
  color: #fff;
  font-weight: 800;
  font-size: 13px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 10px rgba(238, 125, 15, 0.25);
}
.day-open-content {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.day-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.day-title-input-clean {
  font-family: var(--font-display, sans-serif);
  font-size: 18px;
  font-weight: 700;
  color: #0b2340;
  border: none;
  background: transparent;
  width: 100%;
  outline: none;
  box-sizing: border-box;
}
.activities-ul-clean {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding-left: 0;
  margin: 0;
  list-style: none;
}
.act-li-row {
  display: flex;
  align-items: flex-start;
  gap: 10px;
}
.act-bullet-small {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #94a3b8;
  flex-shrink: 0;
  margin-top: 8px;
}
.act-input-clean {
  flex: 1;
  border: none;
  background: transparent;
  font-size: 14px;
  color: #475569;
  outline: none;
  line-height: 1.5;
  box-sizing: border-box;
}
.day-actions-row {
  margin-top: 4px;
}
.timeline-footer {
  margin-top: 32px;
  padding-top: 16px;
  border-top: 1px solid #f1f5f9;
  display: flex;
  justify-content: center;
}

/* 4. SIDE-BY-SIDE GRID LAYOUT FOR PRICE TABLES */
.price-tables-grid {
  display: grid;
  gap: 24px;
  align-items: start;
  max-width: 1100px;
  margin: 0 auto;
}
.price-tables-grid.cols-1 {
  grid-template-columns: 1fr;
  max-width: 800px;
}
.price-tables-grid.cols-2 {
  grid-template-columns: 1fr 1fr;
}
.price-tables-grid.cols-3 {
  grid-template-columns: 1fr 1fr 1fr;
}
@media (max-width: 900px) {
  .price-tables-grid.cols-2, .price-tables-grid.cols-3 {
    grid-template-columns: 1fr;
  }
}

.price-group-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.price-group-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}
.price-table-title-input {
  font-size: 16px;
  font-weight: 700;
  color: #0b2340;
  border: none;
  background: transparent;
  outline: none;
  width: 100%;
}
.table-card-wrapper {
  overflow: hidden;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 2px 8px rgba(0,0,0,0.02);
  background: #ffffff;
}
.table-card-footer {
  padding: 12px;
  background: #f8fafc;
  border-top: 1px solid #f1f5f9;
  display: flex;
  justify-content: center;
}
.add-table-btn-wrapper {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}

/* CUSTOM DATA TABLE (NAVY HEADER #0B2340) */
.custom-data-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}
.custom-data-table thead tr {
  background: #0b2340;
  color: #ffffff;
  font-size: 13px;
  font-weight: 600;
}
.custom-data-table th {
  padding: 12px 16px;
}
.custom-data-table tbody tr {
  border-top: 1px solid #f1f5f9;
  transition: background 0.15s;
}
.custom-data-table tbody tr:hover {
  background: #f8fafc;
}
.custom-data-table td {
  padding: 12px 16px;
  vertical-align: middle;
}
.whitespace-nowrap { white-space: nowrap; }

.pax-input-group, .price-input-group {
  display: flex;
  align-items: center;
  gap: 6px;
}
.tier-num-clean {
  width: 45px;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  padding: 4px;
  text-align: center;
  font-size: 13px;
  outline: none;
  box-sizing: border-box;
}
.tier-num-clean:focus { border-color: #EE7D0F; }

.tier-price-clean {
  width: 110px;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  padding: 4px 8px;
  font-size: 13px;
  font-weight: 700;
  color: #EE7D0F;
  outline: none;
  box-sizing: border-box;
}
.tier-price-clean:focus { border-color: #EE7D0F; }

.tier-desc-clean {
  width: 100%;
  border: 1px solid #cbd5e1;
  border-radius: 4px;
  padding: 4px 8px;
  font-size: 13px;
  outline: none;
  box-sizing: border-box;
}
.tier-desc-clean:focus { border-color: #EE7D0F; }

/* ADDONS SECTION */
.addon-table-section {
  max-width: 800px;
  margin: 48px auto 0;
  padding-top: 32px;
  border-top: 1px solid #cbd5e1;
}
.addon-section-title {
  font-size: 16px;
  font-weight: 700;
  color: #0b2340;
  margin-bottom: 12px;
  text-align: center;
}
.addon-name-input {
  font-weight: 600;
  color: #0b2340;
  width: 100%;
  border: none;
  background: transparent;
  outline: none;
  margin-bottom: 4px;
  font-size: 14px;
  box-sizing: border-box;
}
.addon-desc-input {
  color: #64748b;
  font-size: 13px;
  width: 100%;
  border: none;
  background: transparent;
  outline: none;
  box-sizing: border-box;
}
.max-w-800 { max-width: 800px; margin: 0 auto; }
.mt-1 { margin-top: 4px; }
.mb-8 { margin-bottom: 32px; }
.mb-12 { margin-bottom: 48px; }

/* 5. GALERI BUILDER GRID */
.gallery-builder-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 16px;
  max-width: 1000px;
  margin: 0 auto;
}
.gallery-thumb-card {
  position: relative;
  aspect-ratio: 1;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #e2e8f0;
  background: #f8fafc;
}
.gallery-thumb-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.gallery-hover-actions {
  position: absolute;
  inset: 0;
  background: rgba(11,35,64,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s ease;
}
.gallery-thumb-card:hover .gallery-hover-actions { opacity: 1; }

.gallery-add-box {
  aspect-ratio: 1;
  border: 2px dashed #cbd5e1;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #64748b;
  font-weight: 600;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s ease;
  background: #f8fafc;
}
.gallery-add-box:hover {
  border-color: #EE7D0F;
  color: #EE7D0F;
  background: rgba(238, 125, 15, 0.05);
}

/* MEDIA LIBRARY DIALOG STYLES */
.media-library-card {
  width: 800px;
  max-width: 90vw;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
}
.media-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  border-bottom: 1px solid #e2e8f0;
}
.btn-upload {
  background: #0b2340;
  color: #fff;
  border: none;
  padding: 8px 16px;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 600;
  font-size: 13px;
}
.btn-upload:hover { background: #1e293b; }
.btn-upload:disabled { opacity: 0.5; cursor: not-allowed; }

.media-content {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
}
.media-search-bar {
  margin-bottom: 20px;
}
.media-loading, .media-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #64748b;
  gap: 12px;
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
  transition: all 0.15s ease;
  background: #f8fafc;
}
.media-item:hover { border-color: #94a3b8; transform: translateY(-2px); }
.media-item.selected {
  border-color: #EE7D0F;
  box-shadow: 0 0 0 3px rgba(238, 125, 15, 0.2);
}
.thumb-wrap {
  aspect-ratio: 1;
  overflow: hidden;
  background: #eee;
}
.thumb-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.media-info {
  padding: 6px 8px;
}
.media-name {
  font-size: 12px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.media-date {
  font-size: 10px;
  color: #94a3b8;
}

/* BULLETPROOF BUTTON AUTO-WIDTH RULES (Prevent text clipping in Directus SDK v-button) */
:deep(.v-button) {
  width: auto !important;
  min-width: fit-content !important;
  overflow: visible !important;
  white-space: nowrap !important;
}
:deep(.v-button.icon) {
  width: 36px !important;
  min-width: 36px !important;
  height: 36px !important;
  padding: 0 !important;
}
:deep(.v-button.small.icon) {
  width: 28px !important;
  min-width: 28px !important;
  height: 28px !important;
  padding: 0 !important;
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
</style>
