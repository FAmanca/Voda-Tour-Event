// ============================================================================
// Voda Tour & Event — Formatting Utilities
// ============================================================================

/** Format jumlah ke format Rupiah penuh (Rp 850.000). Kembalikan hubungi kami jika 0 */
export function formatPrice(amount: number): string {
  if (!amount || amount === 0) return "Hubungi Kami";
  return `Rp ${amount.toLocaleString("id-ID")}`;
}

/** Format short (850rb, 1jt, 1,5jt) */
export function formatPriceShort(amount: number): string {
  if (amount >= 1_000_000) {
    const juta = amount / 1_000_000;
    return juta % 1 === 0 ? `${juta.toFixed(0)}jt` : `${juta.toFixed(1).replace(".", ",")}jt`;
  }
  if (amount >= 1_000) {
    const rb = amount / 1_000;
    return rb % 1 === 0 ? `${rb.toFixed(0)}rb` : `${rb.toFixed(1).replace(".", ",")}rb`;
  }
  return String(amount);
}

/** Format price + optional /pax */
export function formatPriceDisplay(
  amount: number,
  opts?: { short?: boolean; perPax?: boolean }
): string {
  const prefix = "Rp ";
  const formatted = opts?.short ? formatPriceShort(amount) : amount.toLocaleString("id-ID");
  const suffix = opts?.perPax ? " /pax" : "";
  return `${prefix}${formatted}${suffix}`;
}

/** Dapatkan harga termurah dari price_tiers atau groups of price_tiers */
export function getStartingPrice(
  input: any[]
): number | null {
  if (!input || input.length === 0) return null;
  const flatTiers = input.flatMap(i => i.tiers ? i.tiers : [i]);
  // Harga termurah -- filter null (kaya "Hubungi CS")
  const prices = flatTiers.map(t => t.price_per_pax || t.price).filter((p): p is number => p !== null && p > 0);
  if (prices.length === 0) return null;
  return Math.min(...prices);
}

/** Dapatkan range harga (termurah — termahal) */
export function getPriceRange(
  input: any[]
): { min: number; max: number } | null {
  if (!input || input.length === 0) return null;
  const flatTiers = input.flatMap(i => i.tiers ? i.tiers : [i]);
  const prices = flatTiers.map(t => t.price_per_pax || t.price).filter((p): p is number => p !== null && p > 0);
  if (prices.length === 0) return null;
  return { min: Math.min(...prices), max: Math.max(...prices) };
}

/** Format ISO date ke format Indonesia (12 Januari 2026) */
export function formatDate(iso: string): string {
  try {
    const d = new Date(iso);
    return d.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "long",
      year: "numeric",
    });
  } catch {
    return iso;
  }
}

/** Format ISO ke format pendek (12 Jan 2026) */
export function formatDateShort(iso: string): string {
  try {
    const d = new Date(iso);
    return d.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "short",
      year: "numeric",
    });
  } catch {
    return iso;
  }
}

/** Relative time (2 jam lalu, 3 hari lalu) */
export function timeAgo(iso: string): string {
  const now = Date.now();
  const then = new Date(iso).getTime();
  const diff = now - then;
  const mins = Math.floor(diff / 60_000);
  if (mins < 1) return "baru saja";
  if (mins < 60) return `${mins} menit lalu`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours} jam lalu`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `${days} hari lalu`;
  return formatDateShort(iso);
}

/** Plural helper untuk count */
export function pluralize(count: number, singular: string, plural?: string): string {
  return count === 1 ? `${count} ${singular}` : `${count} ${plural || singular + "s"}`;
}

/** Strip HTML tags */
export function stripHtml(html: string): string {
  return html.replace(/<[^>]*>/g, "").trim();
}

/** Truncate text */
export function truncate(text: string, max = 120): string {
  if (text.length <= max) return text;
  return text.slice(0, max).trimEnd() + "…";
}
