// ============================================================================
// Voda Tour & Event — Directus Type Definitions
// Source of Truth: docs/database/tables/*.md
//
// Every AI agent (Claude, GPT, Codex, Gemini, Cursor) MUST reference this
// file before writing any data-fetching code or component props.
// ============================================================================

// ---------------------------------------------------------------------------
// Enums / Literal Unions
// ---------------------------------------------------------------------------

export type Status = "published" | "draft" | "archived";

// ---------------------------------------------------------------------------
// Value Objects (embedded in JSON columns)
// ---------------------------------------------------------------------------

export interface PriceTier {
  min_pax: number;
  max_pax: number;
  price_per_pax: number;       // Rupiah, per pax
  description: string | null; // e.g. "Minimal 5 orang"
}

export interface PriceTierGroup {
  table_title: string;
  tiers: PriceTier[];
}

export interface Addon {
  addon_name: string;
  price: number;
  description: string | null;
}

export interface DayActivity {
  day: number;         // 1, 2, 3...
  title: string;       // e.g. "Check-in & City Tour"
  activities: string[]; // e.g. ["08:00 — Breakfast", "09:00 — City Tour"]
}

// JSON stored in Directus as array of strings
// e.g. ["Hotel bintang 3", "Transportasi AC", "Guide lokal"]

// ---------------------------------------------------------------------------
// Directus System References
// ---------------------------------------------------------------------------

// When Directus returns a file UUID in API response, the URL is:
//   GET /assets/{uuid}?width=600&height=400&format=webp&quality=80
export type FileUuid = string;

// directus_users.id — system reference, never stored in our collections
export type UserUuid = string;

// ---------------------------------------------------------------------------
// Business Collections
// ---------------------------------------------------------------------------

export interface Region {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  image: FileUuid | null;

  // Directus system fields (auto-managed)
  status: Status;
  created_at: string;   // ISO 8601
  updated_at: string;   // ISO 8601
  deleted_at: string | null;
  created_by: UserUuid | null;
  updated_by: UserUuid | null;
}

export interface Destination {
  id: string;
  region_id: string | Region;      // string when ?fields=region_id, object when ?fields=region_id.*
  name: string;
  slug: string;
  description: string | null;
  image: FileUuid | null;
  gallery: FileUuid[] | null;      // JSON array of UUIDs

  status: Status;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  created_by: UserUuid | null;
  updated_by: UserUuid | null;
}

export interface Package {
  id: string;
  destination_id: string | Destination;
  name: string;
  slug: string;
  description: string | null;
  duration: string;                 // "2D1N", "3D2N", "Half Day", "1D"
  itinerary: DayActivity[] | null;  // JSON
  facilities: string[] | null;      // JSON array of strings
  price_tiers: PriceTierGroup[] | null;  // JSON
  addons: Addon[] | null;           // JSON
  gallery: FileUuid[] | null;

  status: Status;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  created_by: UserUuid | null;
  updated_by: UserUuid | null;
}

export interface ActivityType {
  id: string;
  name: string;       // "Private Trip", "Corporate Gathering"
  slug: string;
  description: string | null;

  status: Status;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  created_by: UserUuid | null;
  updated_by: UserUuid | null;
}

export interface PackageActivityType {
  id: string;
  package_id: string | Package;
  activity_type_id: string | ActivityType;
  created_at: string;
  updated_at: string;
}

export interface ArticleAd {
  image: string; // File UUID
  url?: string;
  title?: string;
}

export interface Article {
  id: string;
  title: string;
  slug: string;
  content: Record<string, any> | string | null;
  featured_image: FileUuid | null;
  ads: ArticleAd[] | null;
  publish_date: string | null;
  seo: Record<string, any> | null;
  
  is_pillar?: boolean;
  pillar_parent?: Record<string, any> | string | null;

  status: Status;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  created_by: UserUuid | null;
  updated_by: UserUuid | null;
}

export interface Setting {
  id: string;
  key: string;        // "site_name", "whatsapp", "email", etc.
  value: string | null;

  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  created_by: UserUuid | null;
  updated_by: UserUuid | null;
}

export interface Search {
  id: string;
  destination_name: string | null;   // "Lembang"
  region_name: string | null;        // "Bandung"
  activity_type_name: string | null; // "Private Trip"
  pax_count: number | null;
  travel_date: string | null;        // "2026-08-15"
  ip_hash: string | null;            // SHA-256 first 16 chars (anonim)
  created_at: string;
}

// ---------------------------------------------------------------------------
// Directus API Response Wrapper
// ---------------------------------------------------------------------------

export interface DirectusResponse<T> {
  data: T;
  meta?: {
    total_count: number;
    filter_count: number;
  };
}

// ---------------------------------------------------------------------------
// Convenience Type Aliases (nested relations)
// ---------------------------------------------------------------------------

/** Destination with region relation expanded */
export type DestinationWithRegion = Destination & { region_id: { name: string } };

/** Package with destination relation expanded */
export type PackageWithDestination = Package & { destination_id: { name: string } };

// ---------------------------------------------------------------------------
// Frontend-specific: Component Props
// ---------------------------------------------------------------------------

// --- Layout ---

export interface HeaderProps {
  active?: "beranda" | "paket" | "gathering" | "destinasi" | "tentang" | "kontak";
  settings: { whatsapp: string; phone: string };
}

export interface FooterProps {
  settings: Record<string, string>;
}

// --- Landing Page ---

export interface HeroProps {
  eyebrow?: string;
  headline: string;
  subheadline: string;
  primaryCta?: { text: string; href: string };
  secondaryCta?: { text: string; href: string };
  destinations: DestinationWithRegion[];
  activityTypes: ActivityType[];
  settings: Record<string, string>;
  gradientClass?: string;
}

export interface SearchCardProps {
  destinations: DestinationWithRegion[];
  activityTypes: ActivityType[];
}

export interface FeatureStripProps {
  features: { icon: string; title: string; description: string }[];
}

export interface SectionHeaderProps {
  eyebrow: string;
  title: string;
  description?: string;
  cta?: { text: string; href: string };
  layout?: "default" | "split";
}

export interface PackageCardProps {
  package: PackageWithDestination;
  gradientClass?: string;
}

export interface StatsBarProps {
  stats: { icon: string; value: string; label: string }[];
  testimonial?: {
    quote: string;
    name: string;
    company: string;
    avatar?: string;
    rating: number;
  };
}

export interface CTABandProps {
  heading?: string;
  description?: string;
  ctaLabel?: string;
  ctaUrl?: string;
  features?: { icon: string; label: string }[];
}

// --- Detail Pages ---

export interface DestinasiHeaderProps {
  destination: Destination;
  packageCount: number;
}

export interface ItineraryTimelineProps {
  itinerary: DayActivity[];
}

export interface PriceTableProps {
  priceTiers: PriceTierGroup[];
  activePax?: number | null;
}

export interface GallerySectionProps {
  images: string[];
  columns?: 2 | 3 | 4;
  masonry?: boolean;
}

// --- Search ---

export interface SearchFormProps {
  destinations: DestinationWithRegion[];
  activityTypes: ActivityType[];
  initialValues?: {
    q?: string;
    activityType?: string;
    paxCount?: number;
    travelDate?: string;
  };
}

export interface SearchResultProps {
  packages: PackageWithDestination[];
  searchParams: SearchFormProps["initialValues"];
  loading?: boolean;
  error?: string | null;
}

// --- Shared / Utility ---

export interface IconBadgeProps {
  icon: string;
  size?: "sm" | "md" | "lg";
  shape?: "circle" | "rounded-square";
  variant?: "navy" | "outline" | "glass";
}

export interface PriceDisplayProps {
  amount: number;
  prefix?: string;
  format?: "short" | "full";
  perPax?: boolean;
  size?: "sm" | "md" | "lg";
}

export interface WaButtonProps {
  phone: string;
  message?: string;
  label?: string;
  variant?: "primary" | "outline" | "pill";
  fullWidth?: boolean;
  icon?: boolean;
}

export interface SkeletonCardProps {
  variant?: "package" | "destinasi" | "feature";
}

// ---------------------------------------------------------------------------
// API Helpers
// ---------------------------------------------------------------------------

// Astro generates this type for environment variables
// Set in apps/web/.env or deployment environment
export interface Env {
  DIRECTUS_URL: string;   // Default: http://localhost:8055
  SITE_URL?: string;      // Default: http://localhost:4321
}
