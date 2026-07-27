<template>
  <div class="package-editor-module">
    <!-- Dashboard View -->
    <div v-if="!editingPackage" class="dashboard-view">
      <div class="dashboard-header">
        <h1>Packages</h1>
        <div class="header-actions">
          <v-input v-model="searchQuery" placeholder="Search packages..." class="search-input">
            <template #prepend><v-icon name="search" /></template>
          </v-input>
          <v-select v-model="statusFilter" :items="statusOptions" placeholder="Filter Status" class="status-select" />
        </div>
      </div>
      
      <div v-if="loadingPackages" class="loading-state">
        <v-progress-circular indeterminate />
      </div>
      
      <div v-else-if="packages.length === 0" class="empty-state">
        <v-notice type="info">No packages found.</v-notice>
      </div>

      <div v-else class="package-grid">
        <div v-for="pkg in filteredPackages" :key="pkg.id" class="package-card" @click="editPackage(pkg)">
          <div class="card-image-wrap">
            <img v-if="pkg.image" :src="getFileUrl(pkg.image)" class="card-image" />
            <div v-else class="card-image-placeholder"><v-icon name="image" /></div>
            <div class="status-badge" :class="pkg.status">{{ pkg.status }}</div>
            <div class="duration-badge">{{ pkg.duration }}</div>
          </div>
          <div class="card-content">
            <h3>{{ pkg.name }}</h3>
            <p class="destination"><v-icon name="place" small /> {{ getDestinationName(pkg.destination_id) }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Editor View -->
    <div v-else class="editor-view">
      <!-- Top Bar -->
      <div class="editor-top-bar">
        <v-button secondary @click="cancelEdit">Back to Dashboard</v-button>
        <div class="top-bar-title">{{ editingPackage.name || 'Untitled Package' }}</div>
        <v-button @click="savePackage" :loading="saving">Simpan Paket</v-button>
      </div>

      <div class="editor-content-wrapper">
        <!-- Hero Section -->
        <div class="hero-section" @click="openMediaPicker('cover')">
          <img v-if="editingPackage.image" :src="getFileUrl(editingPackage.image)" class="hero-bg" />
          <div v-else class="hero-bg placeholder">Click to add cover image</div>
          <div class="hero-gradient"></div>
          <div class="hero-content" @click.stop>
            <input v-model="editingPackage.name" class="hero-title-input" placeholder="Package Name" />
            
            <div class="hero-badges">
              <div class="badge-input">
                <v-icon name="schedule" small />
                <input v-model="editingPackage.duration" placeholder="Duration (e.g. 3D2N)" />
              </div>
              <div class="badge-input">
                <v-icon name="group" small />
                <input type="number" v-model="editingPackage.max_participants" placeholder="Max Pax" />
              </div>
            </div>
            
            <div class="hero-controls">
              <v-select v-model="editingPackage.destination_id" :items="destinationOptions" placeholder="Select Destination" />
              <v-select v-model="editingPackage.status" :items="statusOptions" placeholder="Status" />
              <v-select v-model="selectedActivityTypes" :items="activityTypeOptions" multiple placeholder="Activity Types" />
              <v-button secondary @click="openMediaPicker('poster')">
                <v-icon name="image" left /> {{ editingPackage.poster ? 'Change Poster' : 'Set Poster' }}
              </v-button>
            </div>
          </div>
        </div>

        <div class="main-content-layout">
          <!-- Left Column -->
          <div class="left-column">
            <section class="editor-section">
              <h2>Description</h2>
              <v-textarea v-model="editingPackage.description" placeholder="Package Description (HTML allowed)" rows="6" />
            </section>

            <section class="editor-section">
              <h2>Facilities</h2>
              <div class="facilities-list">
                <div v-for="(facility, index) in editingPackage.facilities" :key="index" class="facility-item">
                  <v-icon name="check_circle" class="check-icon" />
                  <input v-model="editingPackage.facilities[index]" placeholder="Facility detail" />
                  <div class="item-actions">
                    <v-button icon @click="moveFacility(index, -1)" :disabled="index === 0"><v-icon name="arrow_upward" /></v-button>
                    <v-button icon @click="moveFacility(index, 1)" :disabled="index === editingPackage.facilities.length - 1"><v-icon name="arrow_downward" /></v-button>
                    <v-button icon danger @click="removeFacility(index)"><v-icon name="delete" /></v-button>
                  </div>
                </div>
                <v-button secondary @click="addFacility">Add Facility</v-button>
              </div>
            </section>
          </div>

          <!-- Right Column -->
          <div class="right-column">
            <section class="editor-section">
              <h2>Itinerary Timeline</h2>
              <div class="timeline">
                <div v-for="(day, dayIndex) in editingPackage.itinerary" :key="dayIndex" class="timeline-day">
                  <div class="day-badge">{{ day.day }}</div>
                  <div class="day-content">
                    <div class="day-header">
                      <input v-model="day.title" class="day-title-input" placeholder="Day Title" />
                      <v-button icon danger @click="removeDay(dayIndex)"><v-icon name="delete" /></v-button>
                    </div>
                    <div class="activities-list">
                      <div v-for="(act, actIndex) in day.activities" :key="actIndex" class="activity-item">
                        <div class="activity-bullet"></div>
                        <input v-model="day.activities[actIndex]" placeholder="Activity detail" />
                        <v-button icon small @click="removeActivity(dayIndex, actIndex)"><v-icon name="close" /></v-button>
                      </div>
                      <v-button secondary small @click="addActivity(dayIndex)">+ Add Activity</v-button>
                    </div>
                  </div>
                </div>
                <v-button secondary @click="addDay">Add Day</v-button>
              </div>
            </section>
          </div>
        </div>

        <!-- Price Tables Section -->
        <section class="editor-section full-width">
          <h2>Price Tables</h2>
          <div v-for="(group, gIndex) in editingPackage.price_tiers" :key="gIndex" class="price-table-group">
            <div class="table-group-header">
              <input v-model="group.table_title" class="table-title-input" placeholder="Table Title" />
              <v-button icon danger @click="removePriceTable(gIndex)"><v-icon name="delete" /></v-button>
            </div>
            <table class="price-table">
              <thead>
                <tr>
                  <th>Min Pax</th>
                  <th>Max Pax</th>
                  <th>Harga/Orang</th>
                  <th>Keterangan</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(tier, tIndex) in group.tiers" :key="tIndex">
                  <td><input type="number" v-model="tier.min_pax" /></td>
                  <td><input type="number" v-model="tier.max_pax" /></td>
                  <td><input type="number" v-model="tier.price_per_pax" /></td>
                  <td><input v-model="tier.description" placeholder="Optional info" /></td>
                  <td><v-button icon danger small @click="removePriceTier(gIndex, tIndex)"><v-icon name="close" /></v-button></td>
                </tr>
              </tbody>
            </table>
            <v-button secondary small @click="addPriceTier(gIndex)">Add Row</v-button>
          </div>
          <v-button secondary @click="addPriceTable" v-if="editingPackage.price_tiers.length < 3">Add Price Table</v-button>
        </section>

        <!-- Add-ons Section -->
        <section class="editor-section full-width">
          <h2>Add-ons</h2>
          <table class="price-table">
            <thead>
              <tr>
                <th>Nama Add-on</th>
                <th>Harga</th>
                <th>Keterangan</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(addon, aIndex) in editingPackage.addons" :key="aIndex">
                <td><input v-model="addon.addon_name" /></td>
                <td><input type="number" v-model="addon.price" /></td>
                <td><input v-model="addon.description" /></td>
                <td><v-button icon danger small @click="removeAddon(aIndex)"><v-icon name="close" /></v-button></td>
              </tr>
            </tbody>
          </table>
          <v-button secondary small @click="addAddon">Add Add-on</v-button>
        </section>

        <!-- Gallery Section -->
        <section class="editor-section full-width">
          <h2>Gallery</h2>
          <div class="gallery-grid">
            <div v-for="(img, idx) in galleryImages" :key="idx" class="gallery-item">
              <img :src="getFileUrl(img)" />
              <div class="gallery-overlay">
                <v-button icon danger @click="removeGalleryImage(idx)"><v-icon name="delete" /></v-button>
              </div>
            </div>
            <div class="gallery-add" @click="openMediaPicker('gallery')">
              <v-icon name="add_photo_alternate" large />
              <span>Add Image</span>
            </div>
          </div>
        </section>
      </div>
    </div>

    <!-- Media Picker Dialog -->
    <v-dialog v-model="mediaPickerOpen" @esc="mediaPickerOpen = false">
      <v-card>
        <v-card-title>Select Media</v-card-title>
        <v-card-text>
          <div class="media-picker-content">
            <div class="media-grid">
              <div v-for="file in mediaFiles" :key="file.id" class="media-item" @click="selectMedia(file)">
                <img :src="getFileUrl(file.id)" />
              </div>
            </div>
          </div>
        </v-card-text>
        <v-card-actions>
          <v-button secondary @click="mediaPickerOpen = false">Cancel</v-button>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
import { useApi } from '@directus/extensions-sdk';

export default {
  setup() {
    const api = useApi();
    
    const packages = ref([]);
    const destinations = ref([]);
    const activityTypes = ref([]);
    
    const loadingPackages = ref(false);
    const searchQuery = ref('');
    const statusFilter = ref(null);
    const statusOptions = [
      { text: 'Published', value: 'published' },
      { text: 'Draft', value: 'draft' },
      { text: 'Archived', value: 'archived' }
    ];

    const editingPackage = ref(null);
    const saving = ref(false);

    // M2M relations state
    const originalGalleryIds = ref([]);
    const galleryImages = ref([]);
    
    const originalActivityTypeIds = ref([]);
    const selectedActivityTypes = ref([]);

    // Media Picker
    const mediaPickerOpen = ref(false);
    const mediaPickerTarget = ref(null); // 'cover', 'poster', 'gallery'
    const mediaFiles = ref([]);

    const fetchPackages = async () => {
      loadingPackages.value = true;
      try {
        const res = await api.get('/items/packages', {
          params: {
            fields: ['*'],
            limit: -1
          }
        });
        packages.value = res.data.data;
      } catch (err) {
        console.error(err);
      } finally {
        loadingPackages.value = false;
      }
    };

    const fetchDependencies = async () => {
      try {
        const [destRes, actRes, filesRes] = await Promise.all([
          api.get('/items/destinations', { params: { limit: -1 } }),
          api.get('/items/activity_types', { params: { limit: -1 } }),
          api.get('/files', { params: { limit: 100, sort: '-created_on', filter: { type: { _contains: 'image' } } } })
        ]);
        destinations.value = destRes.data.data;
        activityTypes.value = actRes.data.data;
        mediaFiles.value = filesRes.data.data;
      } catch (err) {
        console.error(err);
      }
    };

    onMounted(() => {
      fetchPackages();
      fetchDependencies();
    });

    const filteredPackages = computed(() => {
      return packages.value.filter(p => {
        const matchSearch = p.name?.toLowerCase().includes(searchQuery.value.toLowerCase());
        const matchStatus = !statusFilter.value || p.status === statusFilter.value;
        return matchSearch && matchStatus;
      });
    });

    const getDestinationName = (id) => {
      const dest = destinations.value.find(d => d.id === id);
      return dest ? dest.name : 'Unknown';
    };

    const destinationOptions = computed(() => {
      return destinations.value.map(d => ({ text: d.name, value: d.id }));
    });

    const activityTypeOptions = computed(() => {
      return activityTypes.value.map(a => ({ text: a.name, value: a.id }));
    });

    const getFileUrl = (id) => `/assets/${id}`;

    // Editing Logic
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
          facilities: data.facilities || [],
          itinerary: data.itinerary || [],
          price_tiers: data.price_tiers || [],
          addons: data.addons || []
        };

        const gal = data.gallery || [];
        originalGalleryIds.value = gal.map(g => g.directus_files_id);
        galleryImages.value = [...originalGalleryIds.value];

        const act = data.activity_types || [];
        originalActivityTypeIds.value = act.map(a => a.activity_type_id);
        selectedActivityTypes.value = [...originalActivityTypeIds.value];

      } catch (err) {
        console.error("Failed to load package details", err);
      }
    };

    const cancelEdit = () => {
      editingPackage.value = null;
    };

    const savePackage = async () => {
      saving.value = true;
      try {
        const pkgId = editingPackage.value.id;
        
        const payload = {
          name: editingPackage.value.name,
          destination_id: editingPackage.value.destination_id,
          status: editingPackage.value.status,
          duration: editingPackage.value.duration,
          max_participants: parseInt(editingPackage.value.max_participants) || null,
          description: editingPackage.value.description,
          facilities: editingPackage.value.facilities,
          itinerary: editingPackage.value.itinerary,
          price_tiers: editingPackage.value.price_tiers,
          addons: editingPackage.value.addons,
          image: editingPackage.value.image,
          poster: editingPackage.value.poster
        };

        await api.patch(`/items/packages/${pkgId}`, payload);

        // Sync Gallery
        const currentGalRes = await api.get(`/items/packages_files`, { params: { filter: { packages_id: { _eq: pkgId } } } });
        const currentGal = currentGalRes.data.data;
        const galToDelete = currentGal.filter(g => !galleryImages.value.includes(g.directus_files_id)).map(g => g.id);
        const existingGalFiles = currentGal.map(g => g.directus_files_id);
        const galToAdd = galleryImages.value.filter(fid => !existingGalFiles.includes(fid)).map((fid, idx) => ({
          packages_id: pkgId,
          directus_files_id: fid,
          sort: idx + 1
        }));

        if (galToDelete.length > 0) await api.delete(`/items/packages_files`, { data: galToDelete });
        if (galToAdd.length > 0) await api.post(`/items/packages_files`, galToAdd);

        // Sync Activity Types
        const currentActRes = await api.get(`/items/packages_activity_types`, { params: { filter: { package_id: { _eq: pkgId } } } });
        const currentAct = currentActRes.data.data;
        const actToDelete = currentAct.filter(a => !selectedActivityTypes.value.includes(a.activity_type_id)).map(a => a.id);
        const existingActIds = currentAct.map(a => a.activity_type_id);
        const actToAdd = selectedActivityTypes.value.filter(aid => !existingActIds.includes(aid)).map(aid => ({
          package_id: pkgId,
          activity_type_id: aid
        }));

        if (actToDelete.length > 0) await api.delete(`/items/packages_activity_types`, { data: actToDelete });
        if (actToAdd.length > 0) await api.post(`/items/packages_activity_types`, actToAdd);

        fetchPackages();
        cancelEdit();
      } catch (err) {
        console.error("Save failed", err);
        alert("Failed to save package");
      } finally {
        saving.value = false;
      }
    };

    const addFacility = () => editingPackage.value.facilities.push('');
    const removeFacility = (idx) => editingPackage.value.facilities.splice(idx, 1);
    const moveFacility = (idx, dir) => {
      const arr = editingPackage.value.facilities;
      const targetIdx = idx + dir;
      if (targetIdx >= 0 && targetIdx < arr.length) {
        [arr[idx], arr[targetIdx]] = [arr[targetIdx], arr[idx]];
      }
    };

    const addDay = () => editingPackage.value.itinerary.push({ day: editingPackage.value.itinerary.length + 1, title: '', activities: [] });
    const removeDay = (idx) => {
      editingPackage.value.itinerary.splice(idx, 1);
      editingPackage.value.itinerary.forEach((d, i) => d.day = i + 1);
    };
    const addActivity = (dayIdx) => editingPackage.value.itinerary[dayIdx].activities.push('');
    const removeActivity = (dayIdx, actIdx) => editingPackage.value.itinerary[dayIdx].activities.splice(actIdx, 1);

    const addPriceTable = () => editingPackage.value.price_tiers.push({ table_title: '', tiers: [] });
    const removePriceTable = (idx) => editingPackage.value.price_tiers.splice(idx, 1);
    const addPriceTier = (groupIndex) => editingPackage.value.price_tiers[groupIndex].tiers.push({ min_pax: 1, max_pax: 2, price_per_pax: 0, description: '' });
    const removePriceTier = (gIdx, tIdx) => editingPackage.value.price_tiers[gIdx].tiers.splice(tIdx, 1);

    const addAddon = () => editingPackage.value.addons.push({ addon_name: '', price: 0, description: '' });
    const removeAddon = (idx) => editingPackage.value.addons.splice(idx, 1);

    const openMediaPicker = (target) => {
      mediaPickerTarget.value = target;
      mediaPickerOpen.value = true;
    };
    
    const selectMedia = (file) => {
      if (mediaPickerTarget.value === 'cover') {
        editingPackage.value.image = file.id;
      } else if (mediaPickerTarget.value === 'poster') {
        editingPackage.value.poster = file.id;
      } else if (mediaPickerTarget.value === 'gallery') {
        galleryImages.value.push(file.id);
      }
      mediaPickerOpen.value = false;
    };

    const removeGalleryImage = (idx) => {
      galleryImages.value.splice(idx, 1);
    };

    return {
      packages, filteredPackages, loadingPackages, searchQuery, statusFilter, statusOptions,
      getDestinationName, getFileUrl, destinationOptions, activityTypeOptions,
      editingPackage, editPackage, cancelEdit, savePackage, saving,
      addFacility, removeFacility, moveFacility,
      addDay, removeDay, addActivity, removeActivity,
      addPriceTable, removePriceTable, addPriceTier, removePriceTier,
      addAddon, removeAddon,
      mediaPickerOpen, mediaFiles, openMediaPicker, selectMedia,
      galleryImages, removeGalleryImage, selectedActivityTypes
    };
  }
};
</script>

<style scoped>
.package-editor-module {
  padding: 24px;
  background: var(--background-page, #f4f6f8);
  min-height: 100%;
  font-family: var(--family-sans, sans-serif);
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.header-actions {
  display: flex;
  gap: 16px;
}

.search-input { width: 300px; }
.status-select { width: 150px; }

.package-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.package-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}

.package-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.1);
}

.card-image-wrap {
  position: relative;
  height: 180px;
  background: #eee;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card-image-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #aaa;
}

.status-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
  text-transform: uppercase;
  background: rgba(0,0,0,0.6);
  color: white;
}
.status-badge.published { background: #27ae60; }
.status-badge.draft { background: #f39c12; }
.status-badge.archived { background: #7f8c8d; }

.duration-badge {
  position: absolute;
  bottom: 12px;
  left: 12px;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  background: rgba(255,255,255,0.9);
  color: #0b2340;
  font-weight: 600;
}

.card-content {
  padding: 16px;
}

.card-content h3 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #0b2340;
}

.destination {
  margin: 0;
  font-size: 14px;
  color: #666;
  display: flex;
  align-items: center;
  gap: 4px;
}

.editor-top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  background: white;
  padding: 16px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.top-bar-title {
  font-size: 18px;
  font-weight: bold;
  color: #0b2340;
}

.editor-content-wrapper {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 24px rgba(0,0,0,0.05);
}

.hero-section {
  position: relative;
  height: 400px;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  cursor: pointer;
  background: #0b2340;
}

.hero-bg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.hero-bg.placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255,255,255,0.5);
  font-size: 18px;
}

.hero-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(to right, rgba(11,35,64,0.95), rgba(11,35,64,0.7), rgba(11,35,64,0.15));
}

.hero-content {
  position: relative;
  padding: 40px;
  z-index: 10;
  cursor: default;
}

.hero-title-input {
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  color: white;
  font-size: 48px;
  font-weight: bold;
  width: 100%;
  margin-bottom: 16px;
  outline: none;
  transition: border-color 0.2s;
}
.hero-title-input:focus {
  border-color: #EE7D0F;
}

.hero-badges {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
}

.badge-input {
  display: flex;
  align-items: center;
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(4px);
  padding: 6px 12px;
  border-radius: 20px;
  color: white;
  gap: 8px;
}

.badge-input input {
  background: transparent;
  border: none;
  color: white;
  outline: none;
  width: 100px;
}
.badge-input input::placeholder { color: rgba(255,255,255,0.7); }

.hero-controls {
  display: flex;
  gap: 16px;
  align-items: center;
  background: rgba(255,255,255,0.9);
  padding: 12px;
  border-radius: 8px;
  flex-wrap: wrap;
}

.main-content-layout {
  display: flex;
  gap: 32px;
  padding: 32px;
}
.left-column { width: 60%; }
.right-column { width: 40%; }

.editor-section {
  margin-bottom: 40px;
}
.editor-section.full-width {
  padding: 0 32px 32px;
}

.editor-section h2 {
  font-size: 20px;
  color: #0b2340;
  margin-bottom: 16px;
  padding-bottom: 8px;
  border-bottom: 2px solid #f0f0f0;
}

.facilities-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.facility-item {
  display: flex;
  align-items: center;
  gap: 12px;
  background: #f9f9f9;
  padding: 8px 16px;
  border-radius: 6px;
}
.facility-item .check-icon {
  color: #EE7D0F;
}
.facility-item input {
  flex: 1;
  border: none;
  background: transparent;
  outline: none;
  font-size: 15px;
}
.item-actions {
  display: flex;
  gap: 4px;
}

.timeline {
  display: flex;
  flex-direction: column;
  gap: 24px;
  position: relative;
}
.timeline::before {
  content: '';
  position: absolute;
  left: 15px;
  top: 10px;
  bottom: 40px;
  width: 2px;
  background: #e0e0e0;
  z-index: 0;
}

.timeline-day {
  display: flex;
  gap: 16px;
  position: relative;
  z-index: 1;
}

.day-badge {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #EE7D0F;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  flex-shrink: 0;
}

.day-content {
  flex: 1;
  background: #f9f9f9;
  padding: 16px;
  border-radius: 8px;
}

.day-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
}
.day-title-input {
  font-weight: bold;
  font-size: 16px;
  border: none;
  background: transparent;
  outline: none;
  width: 100%;
}

.activities-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.activity-item {
  display: flex;
  align-items: center;
  gap: 8px;
}
.activity-bullet {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #0b2340;
}
.activity-item input {
  flex: 1;
  border: none;
  background: transparent;
  outline: none;
  font-size: 14px;
}

.price-table-group {
  margin-bottom: 32px;
}
.table-group-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 12px;
}
.table-title-input {
  font-size: 18px;
  font-weight: bold;
  border: none;
  background: transparent;
  outline: none;
  color: #0b2340;
}
.price-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 12px;
}
.price-table th {
  background: #0b2340;
  color: white;
  text-align: left;
  padding: 12px;
  font-weight: 500;
}
.price-table td {
  padding: 12px;
  border-bottom: 1px solid #eee;
}
.price-table tbody tr:nth-child(even) {
  background: #fcfcfc;
}
.price-table input {
  width: 100%;
  border: 1px solid transparent;
  padding: 4px 8px;
  border-radius: 4px;
  outline: none;
}
.price-table input:focus {
  border-color: #EE7D0F;
}
.price-table td:nth-child(3) input {
  color: #EE7D0F;
  font-weight: bold;
}

.gallery-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 16px;
}
.gallery-item {
  position: relative;
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
}
.gallery-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.gallery-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s;
}
.gallery-item:hover .gallery-overlay {
  opacity: 1;
}
.gallery-add {
  aspect-ratio: 1;
  border: 2px dashed #ccc;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #888;
  cursor: pointer;
  transition: all 0.2s;
}
.gallery-add:hover {
  border-color: #EE7D0F;
  color: #EE7D0F;
}

.media-picker-content {
  max-height: 60vh;
  overflow-y: auto;
}
.media-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  gap: 12px;
}
.media-item {
  aspect-ratio: 1;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 2px solid transparent;
}
.media-item:hover {
  border-color: #EE7D0F;
}
.media-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
