import { defineInterface } from '@directus/extensions-sdk';
import { ref, computed, watch, inject, h, defineComponent } from 'vue';

const CustomSeoAnalyzerComponent = defineComponent({
  props: {
    value: { type: Object, default: () => ({}) },
    collection: { type: String, default: '' },
    field: { type: String, default: '' },
  },
  emits: ['input'],
  setup(props, { emit }) {
    const values = inject('values', ref({}));
    const api = inject('api', null);

    const focusKeyword = ref(props.value?.focus_keyword || '');
    const secondaryKeywords = ref(props.value?.secondary_keywords || '');
    const metaTitle = ref(props.value?.title || '');
    const metaDescription = ref(props.value?.metaDescription || '');
    const duplicateCount = ref(0);

    const keywordInputText = ref('');
    const keywordsTags = ref<string[]>([]);

    function initTagsFromValue(val) {
      const tags: string[] = [];
      if (val?.focus_keyword) {
        tags.push(val.focus_keyword.trim());
      }
      if (val?.secondary_keywords) {
        const sec = val.secondary_keywords.split(',').map(s => s.trim()).filter(Boolean);
        sec.forEach(s => {
          if (!tags.includes(s)) tags.push(s);
        });
      }
      keywordsTags.value = tags;
    }

    initTagsFromValue(props.value);

    // Watch for external value changes
    watch(() => props.value, (newVal) => {
      if (newVal) {
        focusKeyword.value = newVal.focus_keyword || '';
        secondaryKeywords.value = newVal.secondary_keywords || '';
        metaTitle.value = newVal.title || '';
        metaDescription.value = newVal.metaDescription || '';
        initTagsFromValue(newVal);
      }
    }, { deep: true });

    function emitValue() {
      const mainKw = keywordsTags.value[0] || '';
      const secKws = keywordsTags.value.slice(1).join(', ');
      focusKeyword.value = mainKw;
      secondaryKeywords.value = secKws;

      emit('input', {
        focus_keyword: mainKw,
        secondary_keywords: secKws,
        title: metaTitle.value,
        metaDescription: metaDescription.value,
      });
    }

    function addTag(text: string) {
      const clean = text.trim();
      if (clean && !keywordsTags.value.some(t => t.toLowerCase() === clean.toLowerCase())) {
        keywordsTags.value.push(clean);
        emitValue();
      }
      keywordInputText.value = '';
    }

    function removeTag(index: number) {
      keywordsTags.value.splice(index, 1);
      emitValue();
    }

    const getKeywordStatus = (kwText: string, isPrimary: boolean) => {
      if (!kwText) return 'neutral';
      const cleanKw = kwText.toLowerCase().trim();
      const content = contentText.value.toLowerCase();
      const title = (metaTitle.value || itemTitle.value.value || '').toLowerCase();

      const existsInContent = content.includes(cleanKw);
      const existsInTitle = title.includes(cleanKw);

      if (!existsInContent) {
        return 'red'; // Missing in content
      }

      if (isPrimary) {
        if (existsInContent && existsInTitle) return 'green'; // Primary present in both
        return 'orange'; // Present in content but missing in title
      } else {
        return 'green'; // Secondary present in content
      }
    };

    const checkDuplicateKeyword = async (kw) => {
      if (!kw || !props.collection || !props.field || !api) {
        duplicateCount.value = 0;
        return;
      }
      try {
        const res = await api.get(`/items/${props.collection}`, {
          params: {
            filter: { [props.field]: { _contains: `"focus_keyword":"${kw}"` } },
            limit: 2
          }
        });
        const currentId = values.value?.id;
        duplicateCount.value = res.data?.data?.filter(i => i.id !== currentId).length || 0;
      } catch (e) {
        console.error('Error checking duplicate keyword', e);
      }
    };

    let kwTimer;
    watch(focusKeyword, (newKw) => {
      clearTimeout(kwTimer);
      kwTimer = setTimeout(() => {
        checkDuplicateKeyword(newKw);
      }, 800);
    }, { immediate: true });

    function stripHtml(html) {
      if (!html) return '';
      if (typeof html !== 'string') {
        try {
          return extractTextFromTiptap(html);
        } catch { return ''; }
      }
      return html.replace(/<[^>]*>/g, '').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim();
    }

    function extractTextFromTiptap(node) {
      if (!node) return '';
      let text = '';
      if (node.text) text += node.text;
      if (node.content && Array.isArray(node.content)) {
        for (const child of node.content) {
          text += ' ' + extractTextFromTiptap(child);
        }
      }
      return text.trim();
    }

    const contentText = computed(() => {
      const v = values.value;
      if (!v) return '';
      const raw = v.content;
      return stripHtml(raw);
    });

    const itemTitle = computed(() => {
      const v = values.value;
      return v?.title || v?.name || '';
    });

    // --- SEO Checks ---
    const checks = computed(() => {
      const kw = focusKeyword.value.toLowerCase().trim();
      const title = (metaTitle.value || itemTitle.value || '').toLowerCase();
      const desc = (metaDescription.value || '').toLowerCase();
      const content = contentText.value.toLowerCase();
      const wordCount = content.split(/\s+/).filter(w => w.length > 0).length;

      const v = values.value || {};
      const rawContent = typeof v.content === 'string' ? v.content : JSON.stringify(v.content || '');
      const rawContentLower = rawContent.toLowerCase();
      const slug = (v.slug || '').toLowerCase();

      const results = [];

      // 1. Focus Keyword Set
      if (!kw) {
        results.push({ id: 'kw-set', status: 'red', text: 'Focus keyword belum diisi' });
        return results;
      } else {
        results.push({ id: 'kw-set', status: 'green', text: 'Focus keyword: "' + focusKeyword.value + '"' });
      }

      // Keyword Cannibalization
      if (duplicateCount.value > 0) {
         results.push({ id: 'kw-cannibal', status: 'red', text: `Keyword Cannibalization! Focus keyword ini sudah dipakai di ${duplicateCount.value} artikel lain.` });
      } else {
         results.push({ id: 'kw-cannibal', status: 'green', text: 'Focus keyword unik (belum pernah dipakai di artikel lain)' });
      }

      // Secondary Keywords
      const secKws = secondaryKeywords.value.split(',').map(s => s.trim().toLowerCase()).filter(s => s.length > 0);
      if (secKws.length > 0) {
        let foundCount = 0;
        secKws.forEach(skw => {
           if (content.includes(skw)) foundCount++;
        });
        if (foundCount === secKws.length) {
           results.push({ id: 'sec-kw', status: 'green', text: 'Semua Secondary Keywords ditemukan di konten' });
        } else if (foundCount > 0) {
           results.push({ id: 'sec-kw', status: 'orange', text: `${foundCount} dari ${secKws.length} Secondary Keywords ditemukan di konten` });
        } else {
           results.push({ id: 'sec-kw', status: 'red', text: 'Tidak ada Secondary Keywords yang ditemukan di konten' });
        }
      } else {
        results.push({ id: 'sec-kw', status: 'orange', text: 'Tambahkan Secondary Keywords (LSI) untuk SEO yang lebih luas' });
      }

      // === KEYWORD PLACEMENT ===
      if (title.includes(kw)) {
        results.push({ id: 'kw-title', status: 'green', text: 'Focus keyword ditemukan di SEO Title' });
        if (title.startsWith(kw)) {
            results.push({ id: 'kw-title-start', status: 'green', text: 'Focus keyword berada di awal SEO Title' });
        } else {
            results.push({ id: 'kw-title-start', status: 'orange', text: 'Gunakan Focus keyword di awal SEO Title' });
        }
      } else {
        results.push({ id: 'kw-title', status: 'red', text: 'Focus keyword tidak ditemukan di SEO Title' });
      }

      if (desc.includes(kw)) {
        results.push({ id: 'kw-desc', status: 'green', text: 'Focus keyword ditemukan di Meta Description' });
      } else {
        results.push({ id: 'kw-desc', status: 'orange', text: 'Focus keyword tidak ada di Meta Description' });
      }

      if (slug) {
        const kwDashed = kw.replace(/\s+/g, '-');
        if (slug.includes(kwDashed)) {
          results.push({ id: 'kw-url', status: 'green', text: 'Focus keyword digunakan di URL (slug)' });
        } else {
          results.push({ id: 'kw-url', status: 'orange', text: 'Focus keyword tidak ditemukan di URL (slug)' });
        }
        
        if (slug.length < 75) {
          results.push({ id: 'url-length', status: 'green', text: 'URL/Slug cukup pendek dan ringkas' });
        } else {
          results.push({ id: 'url-length', status: 'orange', text: 'URL/Slug terlalu panjang, buat lebih ringkas tanpa stop words' });
        }
      }

      const first10Percent = content.split(/\s+/).slice(0, Math.max(Math.round(wordCount * 0.1), 30)).join(' ');
      if (first10Percent.includes(kw)) {
        results.push({ id: 'kw-first-para', status: 'green', text: 'Focus keyword muncul di awal konten (~10% pertama)' });
      } else {
        results.push({ id: 'kw-first-para', status: 'orange', text: 'Gunakan focus keyword di paragraf pertama/awal konten' });
      }

      // === KEYWORD DENSITY ===
      if (content.includes(kw)) {
        const count = content.split(kw).length - 1;
        const density = wordCount > 0 ? ((count / wordCount) * 100).toFixed(1) : 0;
        if (density >= 0.5 && density <= 2.5) {
          results.push({ id: 'kw-content', status: 'green', text: 'Kepadatan keyword ideal: ' + density + '% (' + count + ' kali)' });
        } else if (density > 2.5) {
          results.push({ id: 'kw-content', status: 'red', text: 'Keyword stuffing! Kepadatan keyword ' + density + '% terlalu tinggi (Maks 2.5%)' });
        } else {
          results.push({ id: 'kw-content', status: 'orange', text: 'Kepadatan keyword ' + density + '% terlalu rendah (Min 0.5%)' });
        }
      } else {
        results.push({ id: 'kw-content', status: 'red', text: 'Focus keyword tidak ditemukan di isi konten' });
      }

      // === TITLE & META TAMBAHAN ===
      const titleLen = (metaTitle.value || '').length;
      if (titleLen === 0) {
        results.push({ id: 'title-len', status: 'red', text: 'SEO Title belum diisi' });
      } else if (titleLen >= 30 && titleLen <= 60) {
        results.push({ id: 'title-len', status: 'green', text: 'SEO Title optimal (' + titleLen + '/60)' });
      } else {
        results.push({ id: 'title-len', status: 'orange', text: 'Panjang SEO Title tidak optimal (' + titleLen + '), disarankan 30-60 karakter' });
      }

      const powerWords = ['terbaik', 'rahasia', 'panduan', 'lengkap', 'mudah', 'cepat', 'gratis', 'terbaru', 'murah', 'tips', 'trik', 'terpercaya', 'top', 'rekomendasi', 'promo', 'diskon'];
      if (powerWords.some(w => title.includes(w))) {
        results.push({ id: 'title-power', status: 'green', text: 'Title mengandung Power Word/Sentiment (meningkatkan CTR)' });
      } else {
        results.push({ id: 'title-power', status: 'orange', text: 'Tambahkan Power Word (seperti "Terbaik", "Panduan", dll) pada Title' });
      }

      if (/\d/.test(title)) {
        results.push({ id: 'title-number', status: 'green', text: 'Title mengandung angka' });
      } else {
        results.push({ id: 'title-number', status: 'orange', text: 'Gunakan angka pada Title untuk CTR yang lebih baik' });
      }

      if (/[-|]/.test(title)) {
         results.push({ id: 'title-sep', status: 'green', text: 'Title menggunakan pemisah brand (| atau -)' });
      } else {
         results.push({ id: 'title-sep', status: 'orange', text: 'Gunakan pemisah seperti | atau - untuk nama brand di Title' });
      }

      const descLen = (metaDescription.value || '').length;
      if (descLen === 0) {
        results.push({ id: 'desc-len', status: 'red', text: 'Meta Description belum diisi' });
      } else if (descLen >= 120 && descLen <= 160) {
        results.push({ id: 'desc-len', status: 'green', text: 'Meta Description optimal (' + descLen + '/160)' });
      } else {
        results.push({ id: 'desc-len', status: 'orange', text: 'Panjang Meta Description tidak optimal (' + descLen + '), disarankan 120-160 karakter' });
      }

      // === LINK CHECK DETAIL ===
      // Match hrefs explicitly (internal starts with /, external starts with http but not our domain)
      const hasInternalLink = rawContentLower.includes('href="/') || rawContentLower.includes('href="http://vodatrip') || rawContentLower.includes('href="https://vodatrip');
      // A simple heuristic for external links
      const hasExternalLink = rawContentLower.includes('href="http') && !hasInternalLink;

      if (hasInternalLink) {
        results.push({ id: 'link-internal', status: 'green', text: 'Terdapat Internal Link ke halaman lain di situs ini' });
      } else {
        results.push({ id: 'link-internal', status: 'orange', text: 'Tambahkan Internal Link ke halaman lain di situs Anda' });
      }

      if (hasExternalLink) {
        results.push({ id: 'link-external', status: 'green', text: 'Terdapat Outbound/External Link ke situs referensi' });
      } else {
        results.push({ id: 'link-external', status: 'orange', text: 'Tambahkan Outbound Link ke sumber referensi eksternal (otoritatif)' });
      }

      // === STRUKTUR & READABILITY ===
      if (wordCount === 0) {
        results.push({ id: 'content-len', status: 'red', text: 'Konten masih kosong' });
      } else if (wordCount >= 600) {
        results.push({ id: 'content-len', status: 'green', text: 'Panjang konten sangat baik (' + wordCount + ' kata)' });
      } else if (wordCount >= 300) {
        results.push({ id: 'content-len', status: 'orange', text: 'Panjang konten cukup (' + wordCount + ' kata), disarankan >600 kata' });
      } else {
        results.push({ id: 'content-len', status: 'red', text: 'Konten terlalu pendek (' + wordCount + ' kata)' });
      }

      // Check Paragraph length
      let isParagraphTooLong = false;
      try {
        if (typeof v.content === 'object' && v.content?.content) {
           isParagraphTooLong = v.content.content.filter(c => c.type === 'paragraph').some(p => {
             const pText = extractTextFromTiptap(p);
             return pText.split(/\s+/).length > 150;
           });
        } else if (typeof v.content === 'string') {
           isParagraphTooLong = v.content.split(/<p>|\n\n/).some(pText => {
             return stripHtml(pText).split(/\s+/).length > 150;
           });
        }
      } catch(e) {}

      if (isParagraphTooLong) {
        results.push({ id: 'para-len', status: 'orange', text: 'Readability: Ada paragraf yang terlalu panjang (>150 kata). Pecah agar mudah dibaca.' });
      } else if (wordCount > 0) {
        results.push({ id: 'para-len', status: 'green', text: 'Readability: Panjang setiap paragraf sudah ideal (<150 kata)' });
      }

      const hasToc = rawContentLower.includes('daftar isi') || rawContentLower.includes('table of content') || rawContentLower.includes('href="#');
      if (wordCount > 600 && !hasToc) {
         results.push({ id: 'read-toc', status: 'orange', text: 'Readability: Konten cukup panjang, disarankan menambahkan Daftar Isi (Table of Contents)' });
      } else if (hasToc) {
         results.push({ id: 'read-toc', status: 'green', text: 'Readability: Daftar Isi / Table of Contents ditemukan' });
      }

      const hasSubheading = rawContentLower.includes('<h2') || rawContentLower.includes('<h3') || rawContentLower.includes('"type":"heading"');
      if (hasSubheading) {
        if (rawContentLower.includes(kw)) {
           results.push({ id: 'content-heading-kw', status: 'green', text: 'Subheading (H2/H3) mengandung focus keyword' });
        } else {
           results.push({ id: 'content-heading-kw', status: 'orange', text: 'Gunakan focus keyword di beberapa subheading (H2, H3)' });
        }
      } else {
        results.push({ id: 'content-heading', status: 'orange', text: 'Konten tidak memiliki Subheading (H2, H3)' });
      }

      // === READABILITY: SENTENCES & TRANSITION WORDS ===
      const sentences = content.split(/[.!?]+/).map(s => s.trim()).filter(s => s.split(/\s+/).length > 3);
      if (sentences.length > 0) {
         // Sentence length
         const longSentences = sentences.filter(s => s.split(/\s+/).length > 20);
         const longSentenceRatio = (longSentences.length / sentences.length) * 100;
         if (longSentenceRatio > 25) {
            results.push({ id: 'read-sentence', status: 'orange', text: `Readability: Terlalu banyak kalimat panjang (${longSentenceRatio.toFixed(1)}%). Usahakan di bawah 25%.` });
         } else {
            results.push({ id: 'read-sentence', status: 'green', text: `Readability: Panjang kalimat ideal (${longSentenceRatio.toFixed(1)}% kalimat panjang)` });
         }

         // Transition words
         const transitionWords = ['namun', 'oleh karena itu', 'selain itu', 'sehingga', 'dengan demikian', 'sementara itu', 'walaupun demikian', 'akan tetapi', 'selanjutnya', 'kemudian', 'bahkan', 'sebaliknya', 'karena itu', 'oleh sebab itu', 'tambahan pula', 'lebih lanjut', 'sebagai contoh', 'misalnya'];
         const sentencesWithTransition = sentences.filter(s => transitionWords.some(tw => s.includes(tw)));
         const transitionRatio = (sentencesWithTransition.length / sentences.length) * 100;
         
         if (transitionRatio >= 30) {
            results.push({ id: 'read-trans', status: 'green', text: `Readability: Penggunaan kata transisi sangat baik (${transitionRatio.toFixed(1)}%)` });
         } else {
            results.push({ id: 'read-trans', status: 'orange', text: `Readability: Kurang kata transisi (${transitionRatio.toFixed(1)}%). Usahakan minimal 30%.` });
         }
      }

      // === MEDIA & GAMBAR ===
      if (rawContentLower.includes('<img') || rawContentLower.includes('"type":"image"')) {
        results.push({ id: 'content-image', status: 'green', text: 'Konten menggunakan media gambar' });
        // Check alt text keyword
        if (rawContentLower.includes('alt') && rawContentLower.includes(kw)) {
            results.push({ id: 'content-image-alt', status: 'green', text: 'Atribut Alt pada gambar mengandung focus keyword' });
        } else {
            results.push({ id: 'content-image-alt', status: 'orange', text: 'Pastikan mengisi atribut Alt pada gambar dengan focus keyword' });
        }
      } else {
        results.push({ id: 'content-image', status: 'orange', text: 'Tambahkan gambar untuk membuat konten lebih menarik' });
      }

      return results;
    });

    const score = computed(() => {
      const c = checks.value;
      if (c.length === 0) return 0;
      let pts = 0;
      for (const ch of c) {
        if (ch.status === 'green') pts += 1;
        else if (ch.status === 'orange') pts += 0.5;
      }
      return Math.round((pts / c.length) * 100);
    });

    const scoreColor = computed(() => {
      if (score.value >= 80) return '#00C853';
      if (score.value >= 50) return '#FF9800';
      return '#FF5252';
    });

    const scoreLabel = computed(() => {
      if (score.value >= 80) return 'Bagus';
      if (score.value >= 50) return 'Perlu Perbaikan';
      return 'Buruk';
    });

    const activeTab = ref('basic');

    return () => {
      const statusIcon = (status) => {
        let color = '#FF5252';
        if (status === 'green') color = '#00C853';
        else if (status === 'orange') color = '#FF9800';
        return h('div', { style: 'width: 10px; height: 10px; border-radius: 50%; background: ' + color + '; flex-shrink: 0;' });
      };

      const radius = 24;
      const circumference = 2 * Math.PI * radius;
      const offset = circumference - (score.value / 100) * circumference;

      const svgScore = h('svg', { width: '76', height: '76', viewBox: '0 0 64 64', style: 'transform: rotate(-90deg); overflow: visible; flex-shrink: 0;' }, [
         h('circle', { cx: '32', cy: '32', r: radius, fill: 'none', stroke: 'var(--border-normal, #e6eaf0)', 'stroke-width': '6' }),
         h('circle', { 
             cx: '32', cy: '32', r: radius, fill: 'none', 
             stroke: scoreColor.value, 'stroke-width': '6', 
             'stroke-linecap': 'round',
             'stroke-dasharray': circumference,
             'stroke-dashoffset': offset,
             style: 'transition: stroke-dashoffset 0.8s ease-in-out;'
         }),
         h('text', {
             x: '32', y: '32',
             fill: 'var(--foreground-normal, #0B2340)',
             'font-size': '15px', 'font-weight': '700',
             'text-anchor': 'middle', 'dominant-baseline': 'central',
             transform: 'rotate(90 32 32)'
         }, score.value + '')
      ]);

      const boxStyle = 'background: var(--theme--background, var(--background-page, white)); border: 1px solid var(--theme--border-color, var(--border-normal, #e6eaf0)); border-radius: 12px; padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.02);';
      const labelStyle = 'display: block; font-size: 13px; font-weight: 600; color: var(--theme--foreground, var(--foreground-normal, #0B2340)); margin-bottom: 6px;';
      const inputStyle = 'width: 100%; padding: 10px 12px; border: 1px solid var(--theme--border-color, var(--border-normal, #e6eaf0)); border-radius: 8px; font-size: 14px; outline: none; background: var(--theme--background-subdued, var(--background-subdued, #f8fafc)); color: var(--theme--foreground, var(--foreground-normal, #0B2340)); font-family: inherit;';

      const renderTabBtn = (tabKey, title) => {
        const isActive = activeTab.value === tabKey;
        return h('button', {
          type: 'button',
          onClick: () => { activeTab.value = tabKey; },
          style: 'padding: 10px 4px; font-size: 13px; cursor: pointer; background: transparent; border: none; margin-bottom: -1px; transition: all 0.2s; ' +
            (isActive 
              ? 'color: var(--theme--primary, var(--primary)); border-bottom: 2px solid var(--theme--primary, var(--primary)); font-weight: 700;' 
              : 'color: var(--theme--foreground-subdued, var(--foreground-subdued, #64748b)); border-bottom: 2px solid transparent; font-weight: 500;'),
        }, title);
      };

      const renderCheckItem = (check) => {
        return h('div', {
          key: check.id,
          style: 'padding: 10px 14px; border-bottom: 1px solid var(--theme--border-color-subdued, var(--border-subdued, #f1f5f9)); font-size: 12px; display: flex; align-items: flex-start; gap: 10px; color: var(--theme--foreground, #5B6B80); line-height: 1.4;'
        }, [
          h('div', { style: 'margin-top: 3px;' }, [ statusIcon(check.status) ]),
          h('span', {}, check.text),
        ]);
      };

      // Filter checks by section
      const basicCheckIds = ['title-len', 'desc-len', 'title-power', 'title-number', 'title-sep', 'url-length'];
      const keywordCheckIds = ['kw-set', 'kw-cannibal', 'sec-kw', 'kw-title', 'kw-title-start', 'kw-desc', 'kw-url', 'kw-first-para', 'kw-content', 'content-heading-kw', 'content-image-alt'];
      const readabilityCheckIds = ['content-len', 'para-len', 'read-sentence', 'read-trans', 'read-toc', 'content-heading', 'content-image', 'link-internal', 'link-external'];

      const renderTabContent = () => {
        if (activeTab.value === 'basic') {
          const tLen = (metaTitle.value || '').length;
          const tPercent = Math.min(Math.round((tLen / 60) * 100), 100);
          let tColor = '#FF5252';
          if (tLen >= 30 && tLen <= 60) tColor = '#00C853';
          else if (tLen > 0) tColor = '#FF9800';

          const dLen = (metaDescription.value || '').length;
          const dPercent = Math.min(Math.round((dLen / 160) * 100), 100);
          let dColor = '#FF5252';
          if (dLen >= 120 && dLen <= 160) dColor = '#00C853';
          else if (dLen > 0) dColor = '#FF9800';

          return h('div', { style: boxStyle + ' display: flex; flex-direction: column; gap: 16px;' }, [
            h('div', {}, [
              h('label', { style: labelStyle }, 'SEO Title'),
              h('input', {
                type: 'text', value: metaTitle.value, placeholder: itemTitle.value || 'SEO Title...',
                style: inputStyle,
                onInput: (e) => { metaTitle.value = e.target.value; emitValue(); },
              }),
              h('div', { style: 'width: 100%; height: 4px; background: var(--theme--border-color, #e2e8f0); border-radius: 2px; margin-top: 6px; overflow: hidden;' }, [
                h('div', { style: 'width: ' + tPercent + '%; height: 100%; background: ' + tColor + '; transition: width 0.3s ease, background 0.3s ease;' })
              ]),
              h('div', { style: 'text-align: right; font-size: 11px; color: ' + tColor + '; margin-top: 4px; font-weight: 600;' }, tLen + '/60 karakter'),
            ]),
            h('div', {}, [
              h('label', { style: labelStyle }, 'Meta Description'),
              h('textarea', {
                value: metaDescription.value, placeholder: 'Deskripsi pencarian...', rows: 3,
                style: inputStyle + ' resize: vertical;',
                onInput: (e) => { metaDescription.value = e.target.value; emitValue(); },
              }),
              h('div', { style: 'width: 100%; height: 4px; background: var(--theme--border-color, #e2e8f0); border-radius: 2px; margin-top: 6px; overflow: hidden;' }, [
                h('div', { style: 'width: ' + dPercent + '%; height: 100%; background: ' + dColor + '; transition: width 0.3s ease, background 0.3s ease;' })
              ]),
              h('div', { style: 'text-align: right; font-size: 11px; color: ' + dColor + '; margin-top: 4px; font-weight: 600;' }, dLen + '/160 karakter'),
            ]),
            h('div', { style: 'border: 1px solid var(--theme--border-color, #f1f5f9); border-radius: 8px; overflow: hidden; margin-top: 8px;' }, [
              h('div', { style: 'padding: 10px 14px; background: var(--theme--background-subdued, #f8fafc); font-size: 12px; font-weight: 700; color: var(--theme--foreground, #0B2340); border-bottom: 1px solid var(--theme--border-color, #e6eaf0);' }, 'Evaluasi Basic Meta'),
              ...checks.value.filter(c => basicCheckIds.includes(c.id)).map(renderCheckItem)
            ])
          ]);
        }

        if (activeTab.value === 'keywords') {
          return h('div', { style: boxStyle + ' display: flex; flex-direction: column; gap: 16px;' }, [
            h('div', {}, [
              h('label', { style: labelStyle }, 'Focus & Secondary Keywords (Tekan Enter atau Koma untuk menambah)'),
              h('div', { style: 'display: flex; flex-wrap: wrap; gap: 8px; padding: 8px 12px; border: 1px solid var(--theme--border-color, #e6eaf0); border-radius: 8px; background: var(--theme--background-subdued, #f8fafc); min-height: 46px; align-items: center;' }, [
                ...keywordsTags.value.map((tag, idx) => {
                  const isPrimary = idx === 0;
                  const status = getKeywordStatus(tag, isPrimary);

                  let bg = 'rgba(255, 82, 82, 0.12)';
                  let color = '#FF5252';
                  let border = 'rgba(255, 82, 82, 0.3)';

                  if (status === 'green') {
                    bg = 'rgba(0, 200, 83, 0.12)';
                    color = '#00C853';
                    border = 'rgba(0, 200, 83, 0.3)';
                  } else if (status === 'orange') {
                    bg = 'rgba(255, 152, 0, 0.12)';
                    color = '#FF9800';
                    border = 'rgba(255, 152, 0, 0.3)';
                  }

                  return h('div', {
                    key: tag + idx,
                    style: `display: inline-flex; align-items: center; gap: 6px; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; background: ${bg}; color: ${color}; border: 1px solid ${border}; transition: all 0.2s;`
                  }, [
                    isPrimary ? h('span', { style: 'color: #f59e0b; font-size: 13px;' }, '★') : null,
                    h('span', {}, tag),
                    h('button', {
                      type: 'button',
                      onClick: () => removeTag(idx),
                      style: 'border: none; background: transparent; cursor: pointer; font-size: 14px; line-height: 1; padding: 0; color: inherit; opacity: 0.7; margin-left: 2px;'
                    }, '×')
                  ]);
                }),
                h('input', {
                  type: 'text',
                  value: keywordInputText.value,
                  placeholder: keywordsTags.value.length === 0 ? 'Ketik Focus Keyword Utama lalu tekan Enter...' : 'Tambah secondary keyword...',
                  style: 'flex: 1; min-width: 180px; border: none; outline: none; background: transparent; font-size: 13px; color: var(--theme--foreground, #0B2340); font-family: inherit;',
                  onInput: (e) => { keywordInputText.value = e.target.value; },
                  onKeydown: (e) => {
                    if (e.key === 'Enter' || e.key === ',') {
                      e.preventDefault();
                      addTag(keywordInputText.value);
                    }
                  },
                  onBlur: () => {
                    if (keywordInputText.value.trim()) {
                      addTag(keywordInputText.value);
                    }
                  }
                })
              ]),
              h('div', { style: 'font-size: 11px; color: var(--theme--foreground-subdued, #8A97A8); margin-top: 6px;' }, '★ Tag pertama (berbintang) adalah Focus Keyword Utama, tag berikutnya adalah Secondary Keywords.')
            ]),
            h('div', { style: 'border: 1px solid var(--theme--border-color, #f1f5f9); border-radius: 8px; overflow: hidden; margin-top: 8px;' }, [
              h('div', { style: 'padding: 10px 14px; background: var(--theme--background-subdued, #f8fafc); font-size: 12px; font-weight: 700; color: var(--theme--foreground, #0B2340); border-bottom: 1px solid var(--theme--border-color, #e6eaf0);' }, 'Evaluasi Kata Kunci & Penempatan'),
              ...checks.value.filter(c => keywordCheckIds.includes(c.id)).map(renderCheckItem)
            ])
          ]);
        }

        if (activeTab.value === 'readability') {
          return h('div', { style: boxStyle + ' display: flex; flex-direction: column; gap: 16px;' }, [
            h('div', { style: 'font-size: 13px; color: var(--theme--foreground-subdued, #475569); line-height: 1.5;' }, 'Keterbacaan dan struktur konten diukur secara real-time dari Editor Tiptap/HTML.'),
            h('div', { style: 'border: 1px solid var(--theme--border-color, #f1f5f9); border-radius: 8px; overflow: hidden;' }, [
              h('div', { style: 'padding: 10px 14px; background: var(--theme--background-subdued, #f8fafc); font-size: 12px; font-weight: 700; color: var(--theme--foreground, #0B2340); border-bottom: 1px solid var(--theme--border-color, #e6eaf0);' }, 'Evaluasi Keterbacaan & Tautan'),
              ...checks.value.filter(c => readabilityCheckIds.includes(c.id)).map(renderCheckItem)
            ])
          ]);
        }
      };

      return h('div', { style: 'font-family: Inter, sans-serif; display: flex; flex-direction: column; gap: 16px;' }, [
        
        // TOP SECTION: Side-by-side (SEO Status + SERP Preview)
        h('div', { style: 'display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 16px; align-items: stretch;' }, [
          
          // Left: Score & Status
          h('div', { style: boxStyle + ' padding: 20px; display: flex; flex-direction: row; align-items: center; gap: 20px;' }, [
            svgScore,
            h('div', { style: 'flex: 1;' }, [
              h('div', { style: 'font-weight: 700; font-size: 16px; color: var(--theme--foreground, #0B2340);' }, 'SEO Status: ' + scoreLabel.value),
              h('div', { style: 'font-size: 13px; color: var(--theme--foreground-subdued, #8A97A8); margin-top: 4px; line-height: 1.4;' }, checks.value.filter(c => c.status === 'green').length + ' dari ' + checks.value.length + ' kriteria terpenuhi dengan baik.'),
            ]),
          ]),

          // Right: SERP Preview
          h('div', { style: boxStyle + ' display: flex; flex-direction: column; justify-content: center;' }, [
            h('div', { style: 'font-size: 11px; font-weight: 700; color: var(--theme--foreground-subdued, #8A97A8); text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px;' }, 'Google SERP Preview'),
            h('div', { style: 'padding: 12px; background: var(--theme--background, #fff); border: 1px solid var(--theme--border-color, #f1f5f9); border-radius: 8px;' }, [
              h('div', { style: 'font-size: 11px; color: var(--theme--foreground-subdued, #202124); margin-bottom: 2px; display: flex; align-items: center; gap: 4px;' }, [
                 h('div', { style: 'width: 14px; height: 14px; background: var(--theme--border-color, #e6eaf0); border-radius: 50%;' }),
                 'vodatrip.id › artikel'
              ]),
              h('div', { style: 'font-size: 15px; color: #1a0dab; font-weight: 400; line-height: 1.3; margin-bottom: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' }, metaTitle.value || itemTitle.value || 'Judul Halaman Anda'),
              h('div', { style: 'font-size: 12px; color: var(--theme--foreground-subdued, #4d5156); line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;' }, metaDescription.value || 'Meta description akan tampil di sini. Pastikan deskripsi ini menarik untuk diklik oleh pengunjung Google.'),
            ])
          ]),
        ]),

        // SECTION TAB NAVIGATION (Underline / Highlight Style)
        h('div', { style: 'display: flex; gap: 24px; border-bottom: 1px solid var(--theme--border-color, #e2e8f0); margin-top: 4px; margin-bottom: 4px; flex-wrap: wrap;' }, [
          renderTabBtn('basic', 'Basic SEO'),
          renderTabBtn('keywords', 'Keyphrases'),
          renderTabBtn('readability', 'Readability & Content'),
        ]),

        // TAB CONTENT
        renderTabContent(),
      ]);
    };
  },
});

export default defineInterface({
  id: 'custom-seo-analyzer',
  name: 'Custom SEO Analyzer',
  description: 'Yoast/RankMath style SEO analyzer interface with SERP preview and focus keyword checklist',
  icon: 'analytics',
  component: CustomSeoAnalyzerComponent,
  types: ['json'],
  group: 'presentation',
  options: null,
});
