#!/usr/bin/env python3
"""
Voda Tour & Event — Database Seeder
Mirip konsep Laravel: tiap entitas punya seeder class, bisa di-run terpisah.
Usage:  python3 seed.py              # run all
        python3 seed.py --table regions  # run specific
"""

import urllib.request, json, sys, os, time, base64, uuid

BASE = 'http://localhost:8055'
TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJiNDU0MjU4LTdkODEtNDBmNi1hZjgwLWFkODUwMTFmYTIwNCIsInJvbGUiOiI2N2YyOGVmZi0wODA3LTQzZWMtYWJkNi1jOGM5ZGE1ODY1NTIiLCJhcHBfYWNjZXNzIjp0cnVlLCJhZG1pbl9hY2Nlc3MiOnRydWUsImlhdCI6MTc4MzkwODk2NSwiZXhwIjoxNzgzOTA5ODY1LCJpc3MiOiJkaXJlY3R1cyJ9.9iVShDMZqDJb5t98HZK4gZUl9S1NNvqOH0qAk8GfYKI'
HEADERS = {'Authorization': f'Bearer {TOKEN}', 'Content-Type': 'application/json'}

# ─── API Helpers ───

class DirectusClient:
    def __init__(self):
        self.base = BASE
        self.headers = HEADERS

    def _request(self, method, path, data=None):
        body = json.dumps(data).encode() if data else None
        req = urllib.request.Request(f'{self.base}{path}', data=body, headers=self.headers, method=method)
        try:
            with urllib.request.urlopen(req) as r:
                raw = r.read()
                return json.loads(raw) if raw else True
        except urllib.request.HTTPError as e:
            resp = e.read().decode()
            print(f"    ⚠️  {method} {path}: {e.code}")
            return None

    def get(self, path): return self._request('GET', path)
    def post(self, path, data): return self._request('POST', path, data)
    def patch(self, path, data): return self._request('PATCH', path, data)
    def delete(self, path): return self._request('DELETE', path)

    def find_by_slug(self, collection, slug):
        """Check if record with slug exists, return first match"""
        r = self.get(f'/items/{collection}?filter[slug][_eq]={slug}&limit=1')
        if r and r.get('data') and len(r['data']) > 0:
            return r['data'][0]
        return None

    def find_by_key(self, collection, key, value):
        r = self.get(f'/items/{collection}?filter[{key}][_eq]={value}&limit=1')
        if r and r.get('data') and len(r['data']) > 0:
            return r['data'][0]
        return None

    def upsert(self, collection, data, unique_field='slug'):
        """Insert if not exists by unique_field, else skip"""
        val = data.get(unique_field)
        existing = None
        if val:
            existing = self.find_by_key(collection, unique_field, val)
        if existing:
            print(f"    ℹ️  Already exists: {collection}.{unique_field}={val} (id={existing.get('id','?')})")
            return existing
        r = self.post(f'/items/{collection}', data)
        if r and r.get('data'):
            print(f"    ✅ Created: {collection}.{unique_field}={val} (id={r['data'].get('id','?')})")
            return r['data']
        print(f"    ❌ Failed: {collection}")
        return None

    def upload_image(self, filename, data_bytes, title=None):
        """Upload file to Directus, return file UUID"""
        import base64
        b64 = base64.b64encode(data_bytes).decode()
        r = self.post('/files', {
            "filename_download": filename,
            "title": title or filename,
            "data": b"data:image/png;base64," + b64  # send as data URL
        })
        # Actually Directus uses multipart, let's try data URL approach
        # This might not work, let's try another approach
        pass

api = DirectusClient()

# ─── Generate simple SVG images as placeholders ───

def make_svg_placeholder(text, w=800, h=600, bg="#0B2340", fg="#EE7D0F"):
    """Generate a simple SVG placeholder — no external deps needed"""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}">
  <rect width="{w}" height="{h}" fill="{bg}"/>
  <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="{fg}" font-family="sans-serif" font-size="36" font-weight="bold">{text}</text>
</svg>'''.encode()

def upload_placeholder(name, label):
    """Upload SVG placeholder to Directus via base64 data URL"""
    svg_bytes = make_svg_placeholder(label)
    b64 = base64.b64encode(svg_bytes).decode()
    payload = {
        "filename_download": f"{name}.svg",
        "title": label,
        "type": "image/svg+xml",
        "data": b64
    }
    r = api.post('/files', payload)
    if r and r.get('data'):
        fid = r['data']['id']
        print(f"    ✅ Uploaded image: {name}.svg (id={fid})")
        return fid
    print(f"    ❌ Upload failed: {name}")
    return None

# ─── SEEDERS ───

def seed_regions():
    print("\n🌍 Seeding regions...")
    regions = [
        {"name": "Bandung", "slug": "bandung", "description": "Kota kembang dengan udara sejuk, pegunungan, dan kuliner terkenal. Destinasi favorit untuk liburan keluarga dan gathering perusahaan."},
        {"name": "Bali", "slug": "bali", "description": "Pulau Dewata dengan pantai eksotis, budaya kaya, dan resor mewah. Cocok untuk private trip dan corporate event."},
        {"name": "Yogyakarta", "slug": "yogyakarta", "description": "Kota budaya dengan candi megah, keraton, dan panorama alam yang memukau. Destinasi edukatif dan rekreatif."},
        {"name": "Kepulauan Seribu", "slug": "kepulauan-seribu", "description": "Gugusan pulau eksotis di utara Jakarta. Surga snorkeling, diving, dan island camping."},
        {"name": "Lombok", "slug": "lombok", "description": "Pantai pasir putih, Gunung Rinjani, dan budaya Sasak yang autentik. Alternatif tenang selain Bali."},
    ]
    for r in regions:
        api.upsert('regions', {**r, "status": "published"})

def seed_destinations():
    print("\n🏝️ Seeding destinations...")
    dests = [
        # Bandung
        {"name": "Lembang", "slug": "lembang", "region_slug": "bandung", "description": "Kawasan wisata pegunungan di utara Bandung dengan udaranya yang sejuk, perkebunan stroberi, dan berbagai destinasi foto instagramable. Cocok untuk family gathering dan outbound."},
        {"name": "Kawah Putih Ciwidey", "slug": "kawah-putih", "region_slug": "bandung", "description": "Danau kawah belerang dengan pemandangan surreal di ketinggian 2.400 mdpl. Spot foto favorit dan destinasi wisata alam utama di Bandung Selatan."},
        {"name": "Tangkuban Perahu", "slug": "tangkuban-perahu", "region_slug": "bandung", "description": "Gunung api aktif dengan kawah raksasa yang bisa dikunjungi. Legenda Sangkuriang melekat erat dengan destinasi ikonik ini."},
        # Bali
        {"name": "Ubud", "slug": "ubud", "region_slug": "bali", "description": "Pusat seni dan budaya Bali dengan sawah terasering, hutan monyet, dan galeri seni. Surga untuk retreat dan creative gathering."},
        {"name": "Seminyak", "slug": "seminyak", "region_slug": "bali", "description": "Kawasan pantai barat Bali dengan sunset spektakuler, beach club, dan restoran mewah. Cocok untuk corporate event dan private trip."},
        {"name": "Nusa Dua", "slug": "nusa-dua", "region_slug": "bali", "description": "Kawasan resor tepi pantai dengan fasilitas meeting room lengkap dan pantai pribadi. Ideal untuk konferensi dan gathering eksklusif."},
        # Yogyakarta
        {"name": "Candi Borobudur", "slug": "borobudur", "region_slug": "yogyakarta", "description": "Candi Buddha terbesar di dunia, warisan UNESCO. Destinasi spiritual dan edukatif dengan panorama sunrise yang legendaris."},
        {"name": "Pantai Parangtritis", "slug": "parangtritis", "region_slug": "yogyakarta", "description": "Pantai selatan yang legendaris dengan pasir hitam, gumuk pasir, dan sunset memukau. Cocok untuk outbound dan gathering."},
        {"name": "Kota Gede", "slug": "kota-gede", "region_slug": "yogyakarta", "description": "Kawasan sejarah dengan arsitektur kolonial dan pengrajin perak. Destinasi wisata heritage dan belanja oleh-oleh."},
        # Kepulauan Seribu
        {"name": "Pulau Macan", "slug": "pulau-macan", "region_slug": "kepulauan-seribu", "description": "Resor eko-trendy dengan villa terapung, snorkeling, dan yoga retreat. Destinasi favorit untuk private trip dan team building."},
        {"name": "Pulau Pari", "slug": "pulau-pari", "region_slug": "kepulauan-seribu", "description": "Pulau dengan pasir putih, laguna biru, dan spot snorkeling terbaik. Cocok untuk budget trip dan gathering santai."},
        {"name": "Pulau Ayer", "slug": "pulau-ayer", "region_slug": "kepulauan-seribu", "description": "Pulau resor dengan water sports lengkap dan akomodasi nyaman. Ideal untuk weekend getaway dan family gathering."},
        # Lombok
        {"name": "Senggigi", "slug": "senggigi", "region_slug": "lombok", "description": "Kawasan wisata pantai utama Lombok dengan sunset indah, pasir putih, dan fasilitas lengkap. Pilihan tepat untuk relaksasi."},
        {"name": "Gili Trawangan", "slug": "gili-trawangan", "region_slug": "lombok", "description": "Pulau tropis tanpa kendaraan bermotor dengan kehidupan malam, snorkeling, dan diving kelas dunia."},
    ]
    
    for d in dests:
        region = api.find_by_slug('regions', d.pop('region_slug'))
        if region:
            d['region_id'] = region['id']
            api.upsert('destinations', {**d, "status": "published"})

def seed_activity_types():
    print("\n🏷️ Seeding activity types...")
    types = [
        {"name": "Private Trip", "slug": "private-trip", "description": "Perjalanan pribadi untuk individu, pasangan, atau kelompok kecil dengan itinerary fleksibel."},
        {"name": "Corporate Gathering", "slug": "corporate-gathering", "description": "Acara perusahaan, gathering tahunan, outing, dan perayaan kantor dengan konsep terpadu."},
        {"name": "Team Building", "slug": "team-building", "description": "Program seru untuk memperkuat kerjasama tim, kepemimpinan, dan komunikasi antar karyawan."},
        {"name": "Family Vacation", "slug": "family-vacation", "description": "Liburan keluarga dengan aktivitas ramah anak dan orang tua. Momen kebersamaan yang berharga."},
        {"name": "Outbound", "slug": "outbound", "description": "Aktivitas outdoor menantang untuk kelompok: flying fox, rafting, paintball, dan games seru."},
    ]
    for t in types:
        api.upsert('activity_types', {**t, "status": "published"})

def seed_packages():
    print("\n📦 Seeding packages...")
    packages = [
        {
            "name": "Bandung Family Getaway",
            "slug": "bandung-family-getaway",
            "dest_slug": "lembang",
            "duration": "3 Hari 2 Malam",
            "description": "Liburan keluarga seru di Lembang, Bandung. Kunjungi Farmhouse, Floating Market, dan Observatory. Nikmati udara sejuk dan kuliner khas Bandung.",
            "itinerary": [
                {"day": 1, "title": "Perjalanan ke Bandung", "activities": ["Berangkat dari Jakarta pagi hari", "Check-in hotel di Lembang", "Makan siang di rumah makan khas Sunda", "Kunjungan ke Farmhouse Lembang", "Malam bebas di area hotel"]},
                {"day": 2, "title": "Wisata Alam", "activities": ["Sarapan di hotel", "Kunjungan ke Floating Market Lembang", "Makan siang", "Observatorium Bosscha", "Belanja oleh-oleh di factory outlet"]},
                {"day": 3, "title": "Pulang", "activities": ["Sarapan dan check-out", "Mampir ke kawah putih (opsional)", "Perjalanan kembali ke Jakarta"]}
            ],
            "price_tiers": [
                {"min_pax": 10, "max_pax": 15, "price_per_pax": 1250000, "description": "Minimal 10 orang"},
                {"min_pax": 16, "max_pax": 25, "price_per_pax": 1050000, "description": "Untuk grup sedang"},
                {"min_pax": 26, "max_pax": 40, "price_per_pax": 850000, "description": "Untuk grup besar"}
            ],
            "facilities": ["Hotel bintang 3 (twin share)", "Transportasi AC", "Makan 3 kali sehari", "Tour guide profesional", "Dokumentasi", "Asuransi perjalanan"],
            "activity_slugs": ["family-vacation", "outbound"]
        },
        {
            "name": "Bali Corporate Retreat",
            "slug": "bali-corporate-retreat",
            "dest_slug": "nusa-dua",
            "duration": "4 Hari 3 Malam",
            "description": "Corporate retreat eksklusif di kawasan Nusa Dua Bali. Fasilitas meeting lengkap, team building di pantai, dan networking dinner yang berkesan.",
            "itinerary": [
                {"day": 1, "title": "Arrival & Welcome Dinner", "activities": ["Sambutan di bandara", "Check-in resor Nusa Dua", "Welcome dinner di tepi pantai", "Ice breaking session"]},
                {"day": 2, "title": "Meeting & Team Building", "activities": ["Sarapan", "Morning meeting session", "Makan siang", "Team building games di pantai", "Gala dinner"]},
                {"day": 3, "title": "Outbound & Relax", "activities": ["Sarapan", "Outbound activities", "Makan siang", "Free time / spa", "Sunset cruise opsional"]},
                {"day": 4, "title": "Check-out", "activities": ["Sarapan", "Check-out", "City tour Singaraja (opsional)", "Transfer ke bandara"]}
            ],
            "price_tiers": [
                {"min_pax": 20, "max_pax": 30, "price_per_pax": 3500000, "description": "Paket standard"},
                {"min_pax": 31, "max_pax": 50, "price_per_pax": 2900000, "description": "Paket medium"},
                {"min_pax": 51, "max_pax": 100, "price_per_pax": 2500000, "description": "Paket besar"}
            ],
            "facilities": ["Resor bintang 4", "Meeting room full set", "Transportasi bus AC", "Makan prasmanan", "Dokumentasi tim", "Souvenir", "Asuransi"],
            "activity_slugs": ["corporate-gathering", "team-building"]
        },
        {
            "name": "Yogyakarta Heritage Explorer",
            "slug": "yogya-heritage-explorer",
            "dest_slug": "borobudur",
            "duration": "3 Hari 2 Malam",
            "description": "Jelajahi keajaiban Candi Borobudur dan destinasi budaya Yogyakarta. Cocok untuk private trip dan family vacation dengan nuansa edukatif.",
            "itinerary": [
                {"day": 1, "title": "Arrival & Malioboro", "activities": ["Tiba di Yogyakarta", "Check-in hotel", "Makan siang gudeg", "Jalan-jalan Malioboro", "Malam bebas"]},
                {"day": 2, "title": "Borobudur Sunrise", "activities": ["Sunrise di Candi Borobudur", "Sarapan", "Kunjungan Candi Mendut & Pawon", "Makan siang", "Keraton Yogyakarta", "Ramayana ballet opsional"]},
                {"day": 3, "title": "Goa & Pulang", "activities": ["Sarapan", "Kunjungan Goa Jomblang", "Makan siang", "Belanja batik", "Perjalanan pulang"]}
            ],
            "price_tiers": [
                {"min_pax": 4, "max_pax": 8, "price_per_pax": 1850000, "description": "Small group"},
                {"min_pax": 9, "max_pax": 15, "price_per_pax": 1550000, "description": "Medium group"},
                {"min_pax": 16, "max_pax": 30, "price_per_pax": 1200000, "description": "Large group"}
            ],
            "facilities": ["Hotel bintang 3", "Transportasi + driver", "Makan 3 kali sehari", "Tiket masuk candi", "Tour guide heritage", "Dokumentasi"],
            "activity_slugs": ["private-trip", "family-vacation"]
        },
        {
            "name": "Pulau Seribu Island Camp",
            "slug": "pulau-seribu-island-camp",
            "dest_slug": "pulau-macan",
            "duration": "2 Hari 1 Malam",
            "description": "Pengalaman island camping di Pulau Macan, Kepulauan Seribu. Snorkeling, kayaking, dan barbecue di tepi pantai. Cocok untuk team building seru!",
            "itinerary": [
                {"day": 1, "title": "Island Adventure", "activities": ["Berangkat dari Marina Ancol", "Snorkeling di spot terbaik", "Makan siang seafood", "Check-in villa/apung", "Kayaking & banana boat", "BBQ dinner & api unggun"]},
                {"day": 2, "title": "Relax & Pulang", "activities": ["Sarapan di pulau", "Snorkeling lagi", "Makan siang", "Check-out", "Kembali ke Jakarta"]}
            ],
            "price_tiers": [
                {"min_pax": 10, "max_pax": 20, "price_per_pax": 950000, "description": "Weekday"},
                {"min_pax": 10, "max_pax": 20, "price_per_pax": 1250000, "description": "Weekend"}
            ],
            "facilities": ["Transportasi speedboat", "Akomodasi villa apung", "Makan 3 kali + BBQ", "Peralatan snorkeling", "Dokumentasi", "Guide lokal"],
            "activity_slugs": ["team-building", "outbound"]
        },
        {
            "name": "Lombok Sunset Bliss",
            "slug": "lombok-sunset-bliss",
            "dest_slug": "senggigi",
            "duration": "4 Hari 3 Malam",
            "description": "Nikmati keindahan Lombok dari Senggigi hingga Gili Trawangan. Pasir putih, sunset spektakuler, dan kehidupan bawah laut memukau.",
            "itinerary": [
                {"day": 1, "title": "Arrival Senggigi", "activities": ["Tiba di Lombok", "Check-in hotel Senggigi", "Makan siang", "Santai di pantai", "Sunset dinner"]},
                {"day": 2, "title": "Gili Trawangan", "activities": ["Sarapan", "Speedboat ke Gili T", "Snorkeling & diving", "Makan siang di pulau", "Cycling keliling pulau", "Kembali ke Senggigi"]},
                {"day": 3, "title": "Eksplorasi Lombok", "activities": ["Sarapan", "Kunjungan Desa Sade (Sasak)", "Makan siang", "Pura Lingsar", "Belanja kerajinan lokal"]},
                {"day": 4, "title": "Check-out", "activities": ["Sarapan", "Check-out", "Mataram city tour", "Transfer ke bandara"]}
            ],
            "price_tiers": [
                {"min_pax": 6, "max_pax": 10, "price_per_pax": 2750000, "description": "Small group"},
                {"min_pax": 11, "max_pax": 20, "price_per_pax": 2250000, "description": "Medium group"},
                {"min_pax": 21, "max_pax": 35, "price_per_pax": 1850000, "description": "Large group"}
            ],
            "facilities": ["Hotel bintang 4", "Transportasi + speedboat", "Makan 3 kali", "Peralatan snorkeling", "Tour guide", "Dokumentasi"],
            "activity_slugs": ["private-trip", "family-vacation"]
        },
        {
            "name": "Team Building Bandung Outbound",
            "slug": "bandung-outbound-team",
            "dest_slug": "lembang",
            "duration": "2 Hari 1 Malam",
            "description": "Program team building seru di Lembang dengan berbagai aktivitas outbound: flying fox, paintball, rafting, dan games kolaboratif.",
            "itinerary": [
                {"day": 1, "title": "Arrival & Outbound", "activities": ["Tiba di lokasi outbound", "Ice breaking & team formation", "Flying fox & high rope", "Makan siang", "Paintball tournament", "Makan malam & api unggun"]},
                {"day": 2, "title": "Rafting & Pulang", "activities": ["Sarapan", "Rafting di sungai Citari", "Makan siang", "Penutupan & awarding", "Perjalanan pulang"]}
            ],
            "price_tiers": [
                {"min_pax": 20, "max_pax": 35, "price_per_pax": 650000, "description": "Paket standard"},
                {"min_pax": 36, "max_pax": 50, "price_per_pax": 550000, "description": "Paket medium"}
            ],
            "facilities": ["Lokasi outbound profesional", "Instruktur berpengalaman", "Makan 3 kali", "Peralatan outbound lengkap", "Dokumentasi", "Sertifikat"],
            "activity_slugs": ["team-building", "outbound", "corporate-gathering"]
        }
    ]

    for p in packages:
        act_slugs = p.pop('activity_slugs')
        dest = api.find_by_slug('destinations', p.pop('dest_slug'))
        if not dest:
            print(f"    ⚠️  Destinasi not found for {p['slug']}, skipping")
            continue
        p['destination_id'] = dest['id']
        
        created = api.upsert('packages', {**p, "status": "published"}, unique_field='slug')
        if created:
            pkg_id = created['id']
            # Link activity types via junction table
            for slug in act_slugs:
                at = api.find_by_slug('activity_types', slug)
                if at:
                    # Check if junction already exists
                    exists = api.get(f"/items/packages_activity_types?filter[package_id][_eq]={pkg_id}&filter[activity_type_id][_eq]={at['id']}")
                    if exists and exists.get('data') and len(exists['data']) > 0:
                        print(f"    ℹ️  Junction already exists: {p['slug']} → {slug}")
                    else:
                        api.post('/items/packages_activity_types', {
                            "package_id": pkg_id,
                            "activity_type_id": at['id']
                        })
                        print(f"    ✅ Linked: {p['slug']} ↔ {slug}")

def seed_settings():
    print("\n⚙️ Seeding settings...")
    settings = [
        {"key": "site_name", "value": "Voda Tour & Event", "description": "Nama situs"},
        {"key": "site_description", "value": "Perjalanan Berkesan, Momen Tak Terlupakan — Voda Tour & Event adalah mitra perjalanan wisata, gathering, dan event organizer terpercaya di Indonesia.", "description": "Deskripsi situs untuk SEO"},
        {"key": "wa_number", "value": "6281234567890", "description": "Nomor WhatsApp bisnis"},
        {"key": "email", "value": "info@vodaevent.id", "description": "Email kontak"},
        {"key": "phone", "value": "(021) 1234-5678", "description": "Nomor telepon kantor"},
        {"key": "address", "value": "Jl. Contoh No. 123, Jakarta Selatan, Indonesia", "description": "Alamat kantor"},
        {"key": "instagram", "value": "https://instagram.com/vodatour.event", "description": "Akun Instagram"},
        {"key": "facebook", "value": "https://facebook.com/vodatour.event", "description": "Akun Facebook"},
        {"key": "youtube", "value": "https://youtube.com/@vodatour.event", "description": "Akun YouTube"},
    ]
    for s in settings:
        api.upsert('settings', s, unique_field='key')

# ─── Upload placeholder images ───

def seed_images():
    print("\n🖼️ Uploading placeholder images...")
    # For regions
    for name, label in [("bandung", "Bandung"), ("bali", "Bali"), ("yogyakarta", "Yogyakarta"), 
                         ("kepulauan-seribu", "Kepulauan Seribu"), ("lombok", "Lombok")]:
        fid = upload_placeholder(f"region-{name}", label)
        if fid:
            region = api.find_by_slug('regions', name)
            if region:
                api.patch(f'/items/regions/{region["id"]}', {"image": fid})
                print(f"    ✅ Set region image: {name}")

    # For destinations
    for name, label in [("lembang", "Lembang"), ("kawah-putih", "Kawah Putih"),
                         ("tangkuban-perahu", "Tangkuban Perahu"), ("ubud", "Ubud"),
                         ("seminyak", "Seminyak"), ("nusa-dua", "Nusa Dua"),
                         ("borobudur", "Borobudur"), ("parangtritis", "Parangtritis"),
                         ("kota-gede", "Kota Gede"), ("pulau-macan", "Pulau Macan"),
                         ("pulau-pari", "Pulau Pari"), ("pulau-ayer", "Pulau Ayer"),
                         ("senggigi", "Senggigi"), ("gili-trawangan", "Gili Trawangan")]:
        fid = upload_placeholder(f"dest-{name}", label)
        if fid:
            dest = api.find_by_slug('destinations', name)
            if dest:
                api.patch(f'/items/destinations/{dest["id"]}', {"image": fid})
                print(f"    ✅ Set destination image: {name}")

# ─── MAIN ───

def run_all():
    print("=" * 60)
    print("VODA TOUR & EVENT — DATABASE SEEDER")
    print("=" * 60)
    seed_regions()
    time.sleep(0.5)
    seed_destinations()
    time.sleep(0.5)
    seed_activity_types()
    time.sleep(0.5)
    seed_packages()
    time.sleep(0.5)
    seed_settings()
    time.sleep(0.5)
    seed_images()
    print("\n" + "=" * 60)
    print("✅ SEEDING COMPLETE!")
    print("=" * 60)

if __name__ == '__main__':
    run_all()
