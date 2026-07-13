// ============================================================================
// Voda Tour & Event — Deep Search Module
// Scoring-based: match minimal 50% kata, urutan bebas, case-insensitive
// ============================================================================

var DIRECTUS_URL = window.__DIRECTUS_URL__ || 'http://localhost:8055';

// ---------------------------------------------------------------------------
// Debounce
// ---------------------------------------------------------------------------
function debounce(fn, delay) {
  if (delay === void 0) delay = 300;
  var t = null;
  return function () {
    var a = arguments, c = this;
    if (t) clearTimeout(t);
    t = setTimeout(function () { fn.apply(c, a); }, delay);
  };
}
window.__debounce = debounce;

// ---------------------------------------------------------------------------
// Package Cache — fetch sekali, pake berkali-kali dalam 1 sesi page
// ---------------------------------------------------------------------------
var __pkgCache = null;

async function fetchAllPackages() {
  if (__pkgCache) return __pkgCache;
  var url = DIRECTUS_URL + '/items/packages'
    + '?fields=*,destination_id.*,activity_types.activity_type_id.slug,activity_types.activity_type_id.name'
    + '&filter[status][_eq]=published&limit=50&sort=-id';
  try {
    var r = await fetch(url);
    if (!r.ok) return [];
    var j = await r.json();
    __pkgCache = j.data || [];
    return __pkgCache;
  } catch (e) { return []; }
}

// ---------------------------------------------------------------------------
// Deep Search API — scoring-based
// ---------------------------------------------------------------------------
async function searchApi(params) {
  if (!params) params = {};
  var q = (params.q || '').trim();
  var kegiatan = params.kegiatan || '';
  var pax = parseInt(params.pax) || 0;

  var pkgs = await fetchAllPackages();
  if (!pkgs.length) return [];

  // --- Scoring: match kata per kata, minimal 50% cocok ---
  if (q) {
    var words = q.toLowerCase().split(/\s+/).filter(Boolean);
    if (words.length) {
      var scored = pkgs.map(function (p) {
        var text = ((p.name || '') + ' ' + (p.description || '')).toLowerCase();
        var matchCount = 0;
        for (var i = 0; i < words.length; i++) {
          if (text.indexOf(words[i]) !== -1) matchCount++;
        }
        return { pkg: p, score: matchCount / words.length };
      });
      scored = scored.filter(function (s) { return s.score >= 0.5; });
      scored.sort(function (a, b) { return b.score - a.score; });
      pkgs = scored.map(function (s) { return s.pkg; });
    }
  }

  // --- Filter kegiatan (AND) ---
  if (kegiatan) {
    pkgs = pkgs.filter(function (p) {
      var acts = p.activity_types || [];
      for (var i = 0; i < acts.length; i++) {
        if (acts[i].activity_type_id && acts[i].activity_type_id.slug === kegiatan) return true;
      }
      return false;
    });
  }

  // --- Filter pax (AND) ---
  if (pax > 0) {
    pkgs = pkgs.filter(function (p) {
      var minPax = parseInt(p.min_pax) || 0;
      var maxPax = parseInt(p.max_pax) || 99999;
      return pax >= minPax && pax <= maxPax;
    });
  }

  return pkgs;
}

// ---------------------------------------------------------------------------
// Autocomplete Suggestions
// ---------------------------------------------------------------------------
async function getSuggestions(query) {
  if (!query || query.trim().length < 2) return [];
  var results = [];
  var q = encodeURIComponent(query.trim());

  try {
    var pr = await fetch(DIRECTUS_URL + '/items/packages?fields=slug,name,destination_id.name&filter[status][_eq]=published&search=' + q + '&limit=4');
    if (pr.ok) {
      var pj = await pr.json();
      (pj.data || []).forEach(function (p) {
        var d = p.destination_id && typeof p.destination_id === 'object' ? p.destination_id.name : '';
        results.push({ type: 'package', slug: p.slug, name: p.name, subtitle: d ? 'Paket di ' + d : 'Paket Wisata', url: '/paket/' + p.slug });
      });
    }
  } catch (e) {}

  try {
    var dr = await fetch(DIRECTUS_URL + '/items/destinations?fields=slug,name,region_id.name&filter[status][_eq]=published&search=' + q + '&limit=3');
    if (dr.ok) {
      var dj = await dr.json();
      (dj.data || []).forEach(function (d) {
        var r = d.region_id && typeof d.region_id === 'object' ? d.region_id.name : '';
        results.push({ type: 'destination', slug: d.slug, name: d.name, subtitle: r ? 'Destinasi di ' + r : 'Destinasi', url: '/destinasi/' + d.slug });
      });
    }
  } catch (e) {}

  results.sort(function (a, b) { return a.type === 'package' ? -1 : 1; });
  return results.slice(0, 6);
}

// ---------------------------------------------------------------------------
// Log Search
// ---------------------------------------------------------------------------
async function logSearch(data) {
  if (!data) return false;
  var body = {};
  if (data.destination_name) body.destination_name = data.destination_name;
  if (data.activity_type_name) body.activity_type_name = data.activity_type_name;
  if (data.pax_count) body.pax_count = data.pax_count;
  if (data.travel_date) body.travel_date = data.travel_date;
  if (data.query) body.query = data.query;
  if (data.query && !data.destination_name) body.destination_name = data.query;

  var vid = localStorage.getItem('voda_visitor_id');
  if (!vid) {
    vid = 'v' + Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
    localStorage.setItem('voda_visitor_id', vid);
  }
  body.ip_hash = vid;

  try {
    var r = await fetch(DIRECTUS_URL + '/items/searches', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
    return r.ok;
  } catch (e) { return false; }
}

// ---------------------------------------------------------------------------
// URL Helpers
// ---------------------------------------------------------------------------
function getSearchParams() {
  var sp = new URLSearchParams(window.location.search);
  return { q: sp.get('q') || '', destinasi: sp.get('destinasi') || '', kegiatan: sp.get('kegiatan') || '', pax: sp.get('pax') || '' };
}

function buildSearchUrl(params) {
  var sp = new URLSearchParams();
  if (params.q) sp.set('q', params.q);
  if (params.destinasi) sp.set('destinasi', params.destinasi);
  if (params.kegiatan) sp.set('kegiatan', params.kegiatan);
  if (params.pax) sp.set('pax', params.pax);
  var qs = sp.toString();
  return '/cari' + (qs ? '?' + qs : '');
}

// ---------------------------------------------------------------------------
// Render
// ---------------------------------------------------------------------------
function esc(s) {
  if (!s) return '';
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function rp(num) {
  return 'Rp' + Number(num).toLocaleString('id-ID');
}

function renderResults(container, packages, loading, error) {
  if (!container) return;
  if (loading) {
    container.innerHTML = '<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">'
      + Array(6).fill(0).map(function () { return '<div class="rounded-xl bg-navy-50 animate-pulse h-[280px]"></div>'; }).join('') + '</div>';
    return;
  }
  if (error) {
    container.innerHTML = '<div class="rounded-lg bg-red-50 border border-red-200 p-5 text-red-700 text-sm flex items-center gap-3"><i class="fa-solid fa-circle-exclamation"></i><span>' + error + '</span></div>';
    return;
  }
  if (!packages || packages.length === 0) {
    container.innerHTML = ''
      + '<div class="text-center py-16 max-w-md mx-auto">'
      + '<div class="w-20 h-20 rounded-full bg-navy-50 flex items-center justify-center mx-auto mb-5">'
      + '<i class="fa-regular fa-face-frown text-3xl text-navy-300"></i></div>'
      + '<h3 class="font-[family-name:var(--font-display)] text-navy-600 text-xl font-semibold">Paket Tidak Ditemukan</h3>'
      + '<p class="text-navy-400 text-sm mt-2 leading-relaxed">'
      + 'Coba hilangkan beberapa filter atau cari dengan kata yang lebih umum. Contoh: cari "<strong>bandung</strong>" saja, atau "<strong>outbound</strong>" tanpa filter kegiatan.</p>'
      + '<div class="flex flex-wrap justify-center gap-3 mt-6">'
      + '<a href="/paket" class="inline-flex items-center gap-2 text-orange-500 text-sm font-semibold no-underline hover:underline"><i class="fa-solid fa-gift"></i>Lihat Semua Paket</a>'
      + '<a href="/destinasi" class="inline-flex items-center gap-2 text-navy-500 text-sm font-semibold no-underline hover:underline"><i class="fa-solid fa-location-dot"></i>Jelajahi Destinasi</a>'
      + '</div></div>';
    return;
  }
  container.innerHTML = '<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">'
    + packages.map(function (pkg) {
        var dname = pkg.destination_id && typeof pkg.destination_id === 'object' ? pkg.destination_id.name : '';
        var sprice = pkg.price_tiers && pkg.price_tiers.length
          ? Math.min.apply(Math, pkg.price_tiers.map(function (t) { return t.price_per_pax; })) : null;
        var imgHtml = (!pkg.gallery || !pkg.gallery[0])
          ? '<div class="w-full h-full flex items-center justify-center bg-navy-100 text-navy-300"><i class="fa-regular fa-image text-3xl"></i></div>'
          : '<img src="' + DIRECTUS_URL + '/assets/' + pkg.gallery[0] + '?width=600&height=400&fit=cover&format=webp&quality=85" alt="' + esc(pkg.name) + '" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110" loading="lazy" />';
        return '<a href="/paket/' + pkg.slug + '" class="group block bg-white rounded-xl shadow-sm overflow-hidden no-underline hover:shadow-md transition-all duration-300 hover:-translate-y-1">'
          + '<div class="aspect-[16/10] overflow-hidden bg-navy-100">' + imgHtml + '</div>'
          + '<div class="p-4">'
          + '<h3 class="font-[family-name:var(--font-display)] text-navy-800 text-sm font-semibold group-hover:text-orange-500 transition-colors line-clamp-2">' + esc(pkg.name) + '</h3>'
          + (dname ? '<p class="text-navy-400 text-xs mt-1"><i class="fa-solid fa-location-dot text-orange-400 text-[10px] mr-1"></i>' + esc(dname) + '</p>' : '')
          + '<div class="flex items-center justify-between mt-2.5 pt-2.5 border-t border-navy-100">'
          + '<span class="text-navy-400 text-xs"><i class="fa-regular fa-clock mr-1"></i>' + esc(pkg.duration || '') + '</span>'
          + (sprice ? '<span class="text-orange-600 text-xs font-bold">' + rp(sprice) + '</span>' : '<span class="text-orange-500 text-xs font-semibold group-hover:translate-x-0.5 transition-transform">Detail <i class="fa-solid fa-arrow-right text-[10px]"></i></span>')
          + '</div></div></a>';
      }).join('') + '</div>';
}

// ---------------------------------------------------------------------------
// Autocomplete Init
// ---------------------------------------------------------------------------
function initAutocomplete(inputId, dropdownId, opts) {
  if (!opts) opts = {};
  var input = document.getElementById(inputId);
  var dropdown = document.getElementById(dropdownId);
  if (!input || !dropdown) return;

  var minChars = opts.minChars || 2;
  var debouncedFetch = window.__debounce(function () {
    var val = input.value.trim();
    if (val.length < minChars) { dropdown.classList.add('hidden'); return; }
    getSuggestions(val).then(function (items) { renderDropdown(items); });
  }, 250);

  input.addEventListener('input', debouncedFetch);
  input.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') { dropdown.classList.add('hidden'); return; }
    if (e.key === 'ArrowDown') { e.preventDefault(); moveSelect(1); return; }
    if (e.key === 'ArrowUp') { e.preventDefault(); moveSelect(-1); return; }
    if (e.key === 'Enter') {
      var sel = dropdown.querySelector('[data-selected]');
      if (sel) { e.preventDefault(); input.value = sel.dataset.name; dropdown.classList.add('hidden'); input.focus(); }
    }
  });
  dropdown.addEventListener('click', function (e) {
    var btn = e.target.closest('[data-index]');
    if (btn) { input.value = btn.dataset.name; dropdown.classList.add('hidden'); input.focus(); }
  });
  document.addEventListener('click', function (e) {
    if (!input.contains(e.target) && !dropdown.contains(e.target)) dropdown.classList.add('hidden');
  });

  function renderDropdown(items) {
    if (!items || !items.length) { dropdown.classList.add('hidden'); return; }
    dropdown.innerHTML = items.map(function (item, i) {
      var icon = item.type === 'package'
        ? '<div class="w-8 h-8 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center text-sm"><i class="fa-solid fa-gift"></i></div>'
        : '<div class="w-8 h-8 rounded-full bg-navy-100 text-navy-500 flex items-center justify-center text-sm"><i class="fa-solid fa-location-dot"></i></div>';
      return '<button type="button" class="w-full flex items-center gap-3 px-4 py-3 hover:bg-navy-50 transition-colors text-left border-b border-navy-100 last:border-0 cursor-pointer" data-index="' + i + '" data-name="' + esc(item.name) + '">'
        + icon + '<div class="flex-1 min-w-0"><div class="text-navy-800 text-xs font-semibold truncate">' + esc(item.name) + '</div><div class="text-navy-400 text-[11px] truncate">' + esc(item.subtitle) + '</div></div>'
        + '<i class="fa-solid fa-arrow-right text-navy-300 text-[10px]"></i></button>';
    }).join('');
    dropdown.classList.remove('hidden');
  }

  function moveSelect(dir) {
    var items = dropdown.querySelectorAll('[data-index]');
    if (!items.length) return;
    var idx = -1;
    items.forEach(function (el, i) { if (el.hasAttribute('data-selected')) { idx = i; el.removeAttribute('data-selected'); } });
    var next = idx + dir;
    if (next < 0) next = items.length - 1;
    if (next >= items.length) next = 0;
    items[next].setAttribute('data-selected', '');
    items[next].scrollIntoView({ block: 'nearest' });
  }
}

// ---------------------------------------------------------------------------
// Search Page Controller
// ---------------------------------------------------------------------------
function initSearchPage() {
  var container = document.getElementById('search-results');
  var countEl = document.getElementById('search-count');
  var filterTags = document.getElementById('filter-tags');
  if (!container) return;

  var params = getSearchParams();
  var hasQuery = params.q || params.destinasi || params.kegiatan || params.pax;

  // Render filter tags
  if (filterTags && hasQuery) {
    var tags = [];
    if (params.q) tags.push({ label: '\u201c' + esc(params.q) + '\u201d', key: 'q', icon: 'fa-solid fa-magnifying-glass' });
    if (params.kegiatan) tags.push({ label: params.kegiatan, key: 'kegiatan', icon: 'fa-regular fa-compass' });
    if (params.pax) tags.push({ label: params.pax + ' orang', key: 'pax', icon: 'fa-solid fa-user-group' });
    filterTags.innerHTML = tags.map(function (t) {
      return '<span class="inline-flex items-center gap-1.5 bg-orange-50 text-orange-700 text-xs font-medium px-3 py-1.5 rounded-full border border-orange-200">'
        + '<i class="' + t.icon + ' text-[10px]"></i> ' + t.label + ' '
        + '<button type="button" class="hover:text-orange-900 ml-0.5" data-remove="' + t.key + '"><i class="fa-solid fa-xmark text-xs"></i></button></span>';
    }).join('');
    filterTags.querySelectorAll('[data-remove]').forEach(function (btn) {
      btn.addEventListener('click', function () {
        params[btn.dataset.remove] = '';
        window.location.href = buildSearchUrl(params);
      });
    });
  }

  if (!hasQuery) return;

  renderResults(container, null, true, null);
  searchApi(params).then(function (pkgs) {
    renderResults(container, pkgs, false, null);
    if (countEl) countEl.textContent = pkgs.length + ' paket ditemukan';
  }).catch(function () {
    renderResults(container, null, false, 'Gagal memuat hasil pencarian.');
  });
}

// ---------------------------------------------------------------------------
// Export
// ---------------------------------------------------------------------------
export {
  searchApi,
  getSuggestions,
  logSearch,
  getSearchParams,
  buildSearchUrl,
  renderResults,
  initAutocomplete,
  initSearchPage,
};