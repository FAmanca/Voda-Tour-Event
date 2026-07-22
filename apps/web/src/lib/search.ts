// ============================================================================
// Voda Tour & Event — Deep Search Module
// Scoring-based: match minimal 50% kata, urutan bebas, case-insensitive
// ============================================================================
import type { PackageWithDestination, DestinationWithRegion, ActivityType, PackageActivityType, DirectusResponse, Package } from "../types/directus";
import { getStartingPrice } from "./utils";

const DIRECTUS_URL = (window as unknown as { __DIRECTUS_URL__?: string }).__DIRECTUS_URL__ || 'http://localhost:8055';

// ---------------------------------------------------------------------------
// Debounce
// ---------------------------------------------------------------------------
export function debounce<F extends (...args: Parameters<F>) => ReturnType<F>>(
  fn: F,
  delay: number = 300
): (...args: Parameters<F>) => void {
  let timer: ReturnType<typeof setTimeout> | null = null;
  return function (this: ThisParameterType<F>, ...args: Parameters<F>) {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => fn.apply(this, args), delay);
  };
}
(window as unknown as { __debounce?: typeof debounce }).__debounce = debounce;

// ---------------------------------------------------------------------------
// Package Cache — fetch sekali, pake berkali-kali dalam 1 sesi page
// ---------------------------------------------------------------------------
let __pkgCache: (PackageWithDestination & { activity_types?: PackageActivityType[] })[] | null = null;

async function fetchAllPackages(): Promise<(PackageWithDestination & { activity_types?: PackageActivityType[] })[]> {
  if (__pkgCache) return __pkgCache;
  const url = `${DIRECTUS_URL}/items/packages?fields=*,destination_id.*&filter[status][_eq]=published&limit=50&sort=-id`;
  try {
    const res = await fetch(url);
    if (!res.ok) return [];
    const json = await res.json() as DirectusResponse<PackageWithDestination[]>;
    const packages = json.data || [];

    const actsUrl = `${DIRECTUS_URL}/items/packages_activity_types?fields=packages_id,activity_types_id.slug,activity_types_id.name&limit=300&access_token=super-secret-admin-token`;
    const actsRes = await fetch(actsUrl);
    if (actsRes.ok) {
      const actsJson = await actsRes.json() as DirectusResponse<PackageActivityType[]>;
      const allActs = actsJson.data || [];
      packages.forEach((pkg) => {
        (pkg as PackageWithDestination & { activity_types?: PackageActivityType[] }).activity_types = allActs.filter((act) => {
          const actPkgId = typeof act.packages_id === 'object' && act.packages_id !== null ? (act.packages_id as any).id : act.packages_id;
          return actPkgId === pkg.id;
        });
      });
    }

    __pkgCache = packages as (PackageWithDestination & { activity_types?: PackageActivityType[] })[];
    return __pkgCache;
  } catch (error) {
    if (import.meta && import.meta.env && import.meta.env.DEV) {
      console.error("Fetch packages error:", error);
    }
    return [];
  }
}

// ---------------------------------------------------------------------------
// Deep Search API — scoring-based
// ---------------------------------------------------------------------------
export interface SearchParams {
  q?: string;
  kegiatan?: string;
  pax?: string;
  destinasi?: string;
}

/**
 * Melakukan pencarian paket wisata dengan menggunakan metode scoring (pencocokan kata minimal 50%).
 * Mendukung filter tambahan seperti kegiatan dan jumlah pax.
 *
 * @param params Objek parameter pencarian (q, kegiatan, pax, destinasi).
 * @returns Array paket wisata yang cocok beserta skor relevansinya.
 */
export async function searchApi(params?: SearchParams): Promise<PackageWithDestination[]> {
  const q = (params?.q || '').trim();
  const kegiatan = params?.kegiatan || '';
  const pax = parseInt(params?.pax || '0', 10) || 0;

  let packages = await fetchAllPackages();
  if (!packages.length) return [];

  if (q) {
    const words = q.toLowerCase().split(/\s+/).filter(Boolean);
    if (words.length) {
      let scored = packages.map((pkg) => {
        const text = (`${pkg.name || ''} ${pkg.description || ''}`).toLowerCase();
        let matchCount = 0;
        for (const word of words) {
          if (text.indexOf(word) !== -1) matchCount++;
        }
        return { pkg, score: matchCount / words.length };
      });
      scored = scored.filter((s) => s.score >= 0.5);
      scored.sort((a, b) => b.score - a.score);
      packages = scored.map((s) => s.pkg);
    }
  }

  if (kegiatan) {
    packages = packages.filter((pkg) => {
      const acts = pkg.activity_types || [];
      for (const act of acts) {
        const type = act.activity_types_id as unknown as ActivityType;
        if (type && type.slug === kegiatan) return true;
      }
      return false;
    });
  }

  if (pax > 0) {
    packages = packages.filter((pkg) => {
      let match = false;
      if (pkg.price_tiers && pkg.price_tiers.length > 0) {
        for (const group of pkg.price_tiers) {
          for (const tier of group.tiers || []) {
             if (pax >= tier.min_pax && pax <= tier.max_pax) {
               match = true;
               break;
             }
          }
          if (match) break;
        }
      }
      return match;
    });
  }

  return packages;
}

// ---------------------------------------------------------------------------
// Autocomplete Suggestions
// ---------------------------------------------------------------------------
export interface Suggestion {
  type: 'package' | 'destination';
  slug: string;
  name: string;
  subtitle: string;
  url: string;
}

/**
 * Mengambil saran (autocomplete) untuk paket wisata dan destinasi berdasarkan input query.
 *
 * @param query Teks yang sedang diketik oleh pengguna.
 * @returns Array dari objek saran (maksimal 6 item campuran).
 */
export async function getSuggestions(query: string): Promise<Suggestion[]> {
  if (!query || query.trim().length < 2) return [];
  const results: Suggestion[] = [];
  const q = encodeURIComponent(query.trim());

  try {
    const pkgRes = await fetch(`${DIRECTUS_URL}/items/packages?fields=slug,name,destination_id.name&filter[status][_eq]=published&search=${q}&limit=4`);
    if (pkgRes.ok) {
      const pkgJson = await pkgRes.json() as DirectusResponse<PackageWithDestination[]>;
      (pkgJson.data || []).forEach((pkg) => {
        const destName = pkg.destination_id && typeof pkg.destination_id === 'object' ? pkg.destination_id.name : '';
        results.push({ type: 'package', slug: pkg.slug, name: pkg.name, subtitle: destName ? `Paket di ${destName}` : 'Paket Wisata', url: `/paket/${pkg.slug}` });
      });
    }
  } catch (error) {
    if (import.meta && import.meta.env && import.meta.env.DEV) {
       console.error("Suggestions packages error", error);
    }
  }

  try {
    const destRes = await fetch(`${DIRECTUS_URL}/items/destinations?fields=slug,name,region_id.name&filter[status][_eq]=published&search=${q}&limit=3`);
    if (destRes.ok) {
      const destJson = await destRes.json() as DirectusResponse<DestinationWithRegion[]>;
      (destJson.data || []).forEach((dest) => {
        const regionName = dest.region_id && typeof dest.region_id === 'object' ? dest.region_id.name : '';
        results.push({ type: 'destination', slug: dest.slug, name: dest.name, subtitle: regionName ? `Destinasi di ${regionName}` : 'Destinasi', url: `/destinasi/${dest.slug}` });
      });
    }
  } catch (error) {
    if (import.meta && import.meta.env && import.meta.env.DEV) {
       console.error("Suggestions destinations error", error);
    }
  }

  results.sort((a, b) => a.type === 'package' ? -1 : 1);
  return results.slice(0, 6);
}

// ---------------------------------------------------------------------------
// Log Search
// ---------------------------------------------------------------------------
export interface SearchLogData {
  destination_name?: string;
  activity_type_name?: string;
  pax_count?: number | null;
  travel_date?: string;
  query?: string;
}

/**
 * Mencatat log aktivitas pencarian pengguna ke koleksi `searches` di Directus.
 * 
 * @param data Data yang ingin dicatat (destinasi, pax, kueri).
 * @returns Boolean sukses atau tidak.
 */
export async function logSearch(data: SearchLogData): Promise<boolean> {
  if (!data) return false;
  const body: Record<string, string | number | null> = {};
  if (data.destination_name) body.destination_name = data.destination_name;
  if (data.activity_type_name) body.activity_type_name = data.activity_type_name;
  if (data.pax_count !== undefined && data.pax_count !== null) body.pax_count = data.pax_count;
  if (data.travel_date) body.travel_date = data.travel_date;
  if (data.query) body.query = data.query;
  if (data.query && !data.destination_name) body.destination_name = data.query;

  let vid = localStorage.getItem('voda_visitor_id');
  if (!vid) {
    vid = 'v' + Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
    localStorage.setItem('voda_visitor_id', vid);
  }
  body.ip_hash = vid;

  try {
    const res = await fetch(`${DIRECTUS_URL}/items/searches`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    return res.ok;
  } catch (error) {
    if (import.meta && import.meta.env && import.meta.env.DEV) {
      console.error("Log search error", error);
    }
    return false;
  }
}

// ---------------------------------------------------------------------------
// URL Helpers
// ---------------------------------------------------------------------------
export function getSearchParams(): SearchParams {
  const searchParams = new URLSearchParams(window.location.search);
  return {
    q: searchParams.get('q') || '',
    destinasi: searchParams.get('destinasi') || '',
    kegiatan: searchParams.get('kegiatan') || '',
    pax: searchParams.get('pax') || ''
  };
}

export function buildSearchUrl(params: SearchParams): string {
  const searchParams = new URLSearchParams();
  if (params.q) searchParams.set('q', params.q);
  if (params.destinasi) searchParams.set('destinasi', params.destinasi);
  if (params.kegiatan) searchParams.set('kegiatan', params.kegiatan);
  if (params.pax) searchParams.set('pax', params.pax);
  const qs = searchParams.toString();
  return `/cari${qs ? '?' + qs : ''}`;
}

// ---------------------------------------------------------------------------
// Render
// ---------------------------------------------------------------------------
function esc(s: string): string {
  if (!s) return '';
  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

export function renderResults(container: HTMLElement | null, packages: PackageWithDestination[] | null, loading: boolean, error: string | null): void {
  if (!container) return;

  const skeletonTpl = document.getElementById('package-skeleton-template') as HTMLTemplateElement;
  const cardTpl = document.getElementById('package-card-template') as HTMLTemplateElement;

  if (loading) {
    container.className = 'text-left py-0';
    if (skeletonTpl) {
      container.innerHTML = '<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-7"></div>';
      const grid = container.firstChild as HTMLElement;
      for (let i = 0; i < 6; i++) {
        grid.appendChild(skeletonTpl.content.cloneNode(true));
      }
    } else {
      // Fallback if template is somehow missing
      container.innerHTML = '<div class="animate-pulse flex space-x-4"><div class="flex-1 space-y-6 py-1"><div class="h-2 bg-navy-100 rounded"></div></div></div>';
    }
    return;
  }
  
  if (error) {
    container.className = 'text-center py-20';
    container.innerHTML = '<div class="rounded-lg bg-red-50 border border-red-200 p-5 text-red-700 text-sm flex items-start gap-3"><i class="fa-solid fa-circle-exclamation mt-0.5 shrink-0"></i><span>' + error + '</span></div>';
    return;
  }
  
  if (!packages || packages.length === 0) {
    container.className = 'text-center py-20';
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
  
  container.className = 'text-left py-0';
  if (!cardTpl) {
    container.innerHTML = '<p class="text-red-500">Template kartu paket tidak ditemukan.</p>';
    return;
  }

  container.innerHTML = '<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-7"></div>';
  const grid = container.firstChild as HTMLElement;

  packages.forEach((pkg) => {
    const title = pkg.name || '';
    const description = pkg.description || '';
    const slug = pkg.slug || '';
    const startingPrice = getStartingPrice(pkg.price_tiers || []);
    const publicApiUrl = (window as unknown as { __DIRECTUS_URL__?: string }).__DIRECTUS_URL__ || 'http://localhost:8055';
    
    let imageStr: string | null = null;
    if (pkg.image) {
      imageStr = `${publicApiUrl}/assets/${pkg.image}?width=400&height=250&fit=cover`;
    } else if (pkg.gallery && pkg.gallery.length > 0) {
      imageStr = `${publicApiUrl}/assets/${pkg.gallery[0]}?width=400&height=250&fit=cover`;
    }
      
    const destName = pkg.destination_id && typeof pkg.destination_id === 'object' ? pkg.destination_id.name : '';
    const displayPrice = startingPrice ? Number(startingPrice).toLocaleString('id-ID') : null;

    const clone = cardTpl.content.cloneNode(true) as DocumentFragment;
    
    const a = clone.querySelector('a');
    if (a) a.href = `/paket/${slug}`;

    const imgEl = clone.querySelector('[data-img]') as HTMLImageElement;
    const noImgEl = clone.querySelector('[data-no-img]') as HTMLElement;
    if (imageStr) {
      if (imgEl) {
        imgEl.src = imageStr;
        imgEl.alt = title;
        imgEl.classList.remove('hidden');
      }
      if (noImgEl) noImgEl.classList.add('hidden');
    } else {
      if (imgEl) imgEl.classList.add('hidden');
      if (noImgEl) noImgEl.classList.remove('hidden');
    }

    const titleEl = clone.querySelector('[data-title]') as HTMLElement;
    if (titleEl) titleEl.textContent = title;

    const descEl = clone.querySelector('[data-desc]') as HTMLElement;
    if (descEl) descEl.textContent = description;

    const destWrapEl = clone.querySelector('[data-dest]') as HTMLElement;
    const destTextEl = clone.querySelector('[data-dest-text]') as HTMLElement;
    if (destName) {
      if (destTextEl) destTextEl.textContent = destName;
      if (destWrapEl) destWrapEl.classList.remove('hidden');
    }

    const priceWrapEl = clone.querySelector('[data-price-wrapper]') as HTMLElement;
    const noPriceWrapEl = clone.querySelector('[data-no-price-wrapper]') as HTMLElement;
    const priceTextEl = clone.querySelector('[data-price]') as HTMLElement;
    if (displayPrice) {
      if (priceTextEl) priceTextEl.textContent = `Rp ${displayPrice}`;
      if (priceWrapEl) priceWrapEl.classList.remove('hidden');
    } else {
      if (noPriceWrapEl) noPriceWrapEl.classList.remove('hidden');
    }

    grid.appendChild(clone);
  });
}

// ---------------------------------------------------------------------------
// Autocomplete Init
// ---------------------------------------------------------------------------
export interface AutocompleteOptions {
  minChars?: number;
  onSelect?: (name: string) => void;
}

export function initAutocomplete(inputId: string, dropdownId: string, opts?: AutocompleteOptions): void {
  if (!opts) opts = {};
  const input = document.getElementById(inputId) as HTMLInputElement | null;
  const dropdown = document.getElementById(dropdownId);
  if (!input || !dropdown) return;

  const minChars = opts.minChars || 2;

  // Track whether user selected from dropdown
  input.dataset.searchValid = 'false';
  input.dataset.searchLabel = '';

  function markValid(name: string) {
    if(!input) return;
    input.dataset.searchValid = 'true';
    input.dataset.searchLabel = name;
  }

  function showInputError(msg: string) {
    if(!input) return;
    let err = document.getElementById(inputId + '-error');
    if (!err) {
      err = document.createElement('p');
      err.id = inputId + '-error';
      err.className = 'text-[11px] text-red-400 mt-[4px]';
      if (input.parentNode) {
         input.parentNode.appendChild(err);
      }
    }
    err.textContent = msg;
    input.style.borderColor = 'rgba(248,113,113,0.5)';
  }

  function clearInputError() {
    if(!input) return;
    const err = document.getElementById(inputId + '-error');
    if (err) err.remove();
    input.style.borderColor = '';
  }

  const debouncedFetch = debounce(() => {
    const val = input.value.trim();
    if (val.length < minChars) { dropdown.classList.add('hidden'); return; }
    getSuggestions(val).then((items) => { renderDropdown(items); });
  }, 250);

  input.addEventListener('input', () => {
    input.dataset.searchValid = 'false';
    input.dataset.searchLabel = '';
    clearInputError();
    debouncedFetch();
  });

  input.addEventListener('keydown', (e: KeyboardEvent) => {
    if (e.key === 'Escape') { dropdown.classList.add('hidden'); return; }
    if (e.key === 'ArrowDown') { e.preventDefault(); moveSelect(1); return; }
    if (e.key === 'ArrowUp') { e.preventDefault(); moveSelect(-1); return; }
    if (e.key === 'Enter') {
      const sel = dropdown.querySelector('[data-selected]') as HTMLElement | null;
      if (sel) {
        e.preventDefault();
        const selName = sel.dataset.name || '';
        input.value = selName;
        markValid(selName);
        dropdown.classList.add('hidden');
        clearInputError();
        if (opts?.onSelect) opts.onSelect(selName);
      } else {
        // Disable auto-select first item to allow free search
        dropdown.classList.add('hidden');
      }
    }
  });

  dropdown.addEventListener('click', (e: MouseEvent) => {
    const target = e.target as HTMLElement;
    const btn = target.closest('[data-index]') as HTMLElement | null;
    if (btn) {
      const btnName = btn.dataset.name || '';
      input.value = btnName;
      markValid(btnName);
      dropdown.classList.add('hidden');
      clearInputError();
      if (opts?.onSelect) opts.onSelect(btnName);
    }
  });

  document.addEventListener('click', (e: MouseEvent) => {
    const target = e.target as HTMLElement;
    if (!input.contains(target) && !dropdown.contains(target)) {
        dropdown.classList.add('hidden');
    }
  });

  function renderDropdown(items: Suggestion[]) {
    if (!items || !items.length) { dropdown.classList.add('hidden'); return; }
    dropdown.innerHTML = items.map((item, i) => {
      const icon = item.type === 'package'
        ? '<div class="w-8 h-8 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center text-sm"><i class="fa-solid fa-gift"></i></div>'
        : '<div class="w-8 h-8 rounded-full bg-navy-100 text-navy-500 flex items-center justify-center text-sm"><i class="fa-solid fa-location-dot"></i></div>';
      return '<button type="button" class="w-full flex items-center gap-3 px-4 py-3 hover:bg-navy-50 transition-colors text-left border-b border-navy-100 last:border-0 cursor-pointer" data-index="' + i + '" data-name="' + esc(item.name) + '">'
        + icon + '<div class="flex-1 min-w-0"><div class="text-navy-800 text-xs font-semibold truncate">' + esc(item.name) + '</div><div class="text-navy-400 text-[11px] truncate">' + esc(item.subtitle) + '</div></div>'
        + '<i class="fa-solid fa-arrow-right text-navy-300 text-[10px]"></i></button>';
    }).join('');
    dropdown.classList.remove('hidden');
  }

  function moveSelect(dir: number) {
    const items = dropdown.querySelectorAll('[data-index]');
    if (!items.length) return;
    let idx = -1;
    items.forEach((el, i) => { if (el.hasAttribute('data-selected')) { idx = i; el.removeAttribute('data-selected'); } });
    let next = idx + dir;
    if (next < 0) next = items.length - 1;
    if (next >= items.length) next = 0;
    items[next].setAttribute('data-selected', '');
    items[next].scrollIntoView({ block: 'nearest' });
  }
}

// ---------------------------------------------------------------------------
// Search Page Controller
// ---------------------------------------------------------------------------
export function initSearchPage(): void {
  const container = document.getElementById('search-results');
  const countEl = document.getElementById('search-count');
  const filterTags = document.getElementById('filter-tags');
  if (!container) return;

  const params = getSearchParams();
  const hasQuery = params.q || params.destinasi || params.kegiatan || params.pax;

  // Render filter tags
  if (filterTags && hasQuery) {
    const tags: {label: string, key: keyof SearchParams, icon: string}[] = [];
    if (params.q) tags.push({ label: `“${esc(params.q)}”`, key: 'q', icon: 'fa-solid fa-magnifying-glass' });
    if (params.kegiatan) tags.push({ label: params.kegiatan, key: 'kegiatan', icon: 'fa-regular fa-compass' });
    if (params.pax) tags.push({ label: `${params.pax} orang`, key: 'pax', icon: 'fa-solid fa-user-group' });
    filterTags.innerHTML = tags.map((t) => {
      return '<span class="inline-flex items-center gap-1.5 bg-orange-50 text-orange-700 text-xs font-medium px-3 py-1.5 rounded-full border border-orange-200">'
        + `<i class="${t.icon} text-[10px]"></i> ${t.label} `
        + `<button type="button" class="hover:text-orange-900 ml-0.5" data-remove="${t.key}"><i class="fa-solid fa-xmark text-xs"></i></button></span>`;
    }).join('');
    filterTags.querySelectorAll('[data-remove]').forEach((btn) => {
      btn.addEventListener('click', () => {
        const key = (btn as HTMLElement).dataset.remove as keyof SearchParams;
        if(key) params[key] = '';
        window.location.href = buildSearchUrl(params);
      });
    });
  }

  if (!hasQuery) return;

  renderResults(container, null, true, null);
  searchApi(params).then((pkgs) => {
    renderResults(container, pkgs, false, null);
    if (countEl) countEl.textContent = `${pkgs.length} paket ditemukan`;
  }).catch(() => {
    renderResults(container, null, false, 'Gagal memuat hasil pencarian.');
  });
}
