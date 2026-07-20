<template>
  <div class="article-editor-module" style="padding: var(--content-padding); height: 100%; box-sizing: border-box; overflow-y: auto;">
    <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
      <h1 style="margin: 0; font-size: 24px; font-weight: 700; color: var(--foreground-normal);">Tulis Artikel Baru</h1>
      <v-button @click="saveArticle" :loading="isSaving" icon="check">Simpan Artikel</v-button>
    </header>

    <div v-if="saveSuccess" style="margin-bottom: 24px;">
      <v-notice type="success">Artikel berhasil disimpan!</v-notice>
    </div>

    <div v-if="saveError" style="margin-bottom: 24px;">
      <v-notice type="danger">{{ saveError }}</v-notice>
    </div>

    <div class="split-layout" style="display: flex; gap: 24px; align-items: flex-start;">
      <!-- Left Column: Editor -->
      <div class="editor-column" style="flex: 1; background: var(--background-page); border: 1px solid var(--border-normal); border-radius: var(--border-radius); padding: 24px;">
        <div style="margin-bottom: 20px;">
          <label style="display: block; margin-bottom: 8px; font-weight: 600;">Judul Artikel</label>
          <v-input v-model="article.title" placeholder="Masukkan judul..." />
        </div>

        <div style="margin-bottom: 20px;">
          <label style="display: block; margin-bottom: 8px; font-weight: 600;">Slug</label>
          <v-input v-model="article.slug" placeholder="url-artikel-anda" />
        </div>

        <div style="margin-bottom: 20px;">
          <label style="display: block; margin-bottom: 8px; font-weight: 600;">Image ID (dari File Library)</label>
          <v-input v-model="article.featured_image" placeholder="ID gambar (UUID)" />
        </div>

        <div style="margin-bottom: 20px;">
          <label style="display: block; margin-bottom: 8px; font-weight: 600;">Konten</label>
          <div class="tiptap-container" style="border: 1px solid var(--border-normal); border-radius: var(--border-radius); padding: 16px; min-height: 400px; background: var(--background-normal);">
            <editor-content :editor="editor" />
          </div>
        </div>
      </div>

      <!-- Right Column: SEO Analyzer -->
      <div class="seo-column" style="width: 400px; flex-shrink: 0; background: var(--background-page); border: 1px solid var(--border-normal); border-radius: var(--border-radius); padding: 24px;">
        <h2 style="margin: 0 0 16px 0; font-size: 18px; font-weight: 700;">SEO Analyzer</h2>
        
        <div style="margin-bottom: 16px;">
          <label style="display: block; margin-bottom: 8px; font-weight: 600;">Focus Keyword</label>
          <v-input v-model="article.focus_keyword" placeholder="Kata kunci utama..." />
        </div>

        <div style="margin-bottom: 16px;">
          <label style="display: block; margin-bottom: 8px; font-weight: 600;">Meta Description</label>
          <v-textarea v-model="article.metaDescription" placeholder="Deskripsi meta untuk pencarian..." />
        </div>

        <!-- SERP Preview -->
        <div style="margin-bottom: 24px; padding: 16px; background: white; border: 1px solid #dfe1e5; border-radius: 8px;">
          <div style="font-size: 12px; color: #202124; margin-bottom: 2px;">vodatrip.id › artikel › {{ article.slug || 'slug' }}</div>
          <div style="font-size: 18px; color: #1a0dab; font-weight: 400; line-height: 1.3; margin-bottom: 4px;">{{ article.title || 'Judul Artikel Anda' }}</div>
          <div style="font-size: 13px; color: #4d5156; line-height: 1.5;">{{ article.metaDescription || 'Tambahkan meta description untuk melihat preview di sini...' }}</div>
        </div>

        <!-- Checklist -->
        <div class="seo-checklist">
          <div v-for="check in checks" :key="check.id" style="margin-bottom: 8px; font-size: 14px; display: flex; align-items: flex-start; gap: 8px;">
            <span style="margin-top: 2px;">{{ check.status === 'green' ? '✅' : check.status === 'orange' ? '⚠️' : '❌' }}</span>
            <span>{{ check.text }}</span>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script>
import { useApi } from '@directus/extensions-sdk';
import { ref, computed, onBeforeUnmount } from 'vue';
import { useEditor, EditorContent } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';

export default {
  components: {
    EditorContent,
  },
  setup() {
    const api = useApi();
    
    const article = ref({
      title: '',
      slug: '',
      featured_image: '',
      content: '',
      focus_keyword: '',
      metaDescription: ''
    });

    const isSaving = ref(false);
    const saveSuccess = ref(false);
    const saveError = ref('');

    const editor = useEditor({
      content: '<p>Tulis konten artikel di sini...</p>',
      extensions: [StarterKit],
      onUpdate: () => {
        article.value.content = editor.value.getHTML();
      },
    });

    onBeforeUnmount(() => {
      if (editor.value) {
        editor.value.destroy();
      }
    });

    // Strip HTML for word count and keyword checking
    const contentText = computed(() => {
      const html = article.value.content || '';
      return html.replace(/<[^>]*>/g, '').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim();
    });

    const checks = computed(() => {
      const kw = (article.value.focus_keyword || '').toLowerCase().trim();
      const title = (article.value.title || '').toLowerCase();
      const desc = (article.value.metaDescription || '').toLowerCase();
      const content = contentText.value.toLowerCase();
      const wordCount = content.split(/\s+/).filter(w => w.length > 0).length;

      const results = [];

      // Keyword
      if (!kw) {
        results.push({ id: 'kw-set', status: 'red', text: 'Focus keyword belum diisi' });
      } else {
        results.push({ id: 'kw-set', status: 'green', text: `Focus keyword: "${kw}"` });
      }

      if (kw && title.includes(kw)) {
        results.push({ id: 'kw-title', status: 'green', text: 'Keyword ada di Judul' });
      } else if (kw) {
        results.push({ id: 'kw-title', status: 'red', text: 'Keyword TIDAK ada di Judul' });
      }

      if (kw && desc.includes(kw)) {
        results.push({ id: 'kw-desc', status: 'green', text: 'Keyword ada di Meta Description' });
      } else if (kw) {
        results.push({ id: 'kw-desc', status: 'orange', text: 'Keyword tidak ada di Meta Description' });
      }

      // Title Length
      const titleLen = title.length;
      if (titleLen === 0) results.push({ id: 't-len', status: 'red', text: 'Judul kosong' });
      else if (titleLen < 30) results.push({ id: 't-len', status: 'orange', text: 'Judul terlalu pendek' });
      else if (titleLen > 60) results.push({ id: 't-len', status: 'orange', text: 'Judul terlalu panjang' });
      else results.push({ id: 't-len', status: 'green', text: 'Panjang judul optimal' });

      // Desc Length
      const descLen = desc.length;
      if (descLen === 0) results.push({ id: 'd-len', status: 'red', text: 'Meta Desc kosong' });
      else if (descLen < 120) results.push({ id: 'd-len', status: 'orange', text: 'Meta Desc terlalu pendek' });
      else if (descLen > 160) results.push({ id: 'd-len', status: 'orange', text: 'Meta Desc terlalu panjang' });
      else results.push({ id: 'd-len', status: 'green', text: 'Panjang Meta Desc optimal' });

      // Word Count
      if (wordCount < 300) results.push({ id: 'w-len', status: 'orange', text: `Konten terlalu pendek (${wordCount} kata)` });
      else results.push({ id: 'w-len', status: 'green', text: `Panjang konten sangat baik (${wordCount} kata)` });

      return results;
    });

    async function saveArticle() {
      isSaving.value = true;
      saveSuccess.value = false;
      saveError.value = '';

      try {
        // Asumsi nama collection adalah 'articles' (bisa disesuaikan)
        // Kita juga bisa menggunakan form/post payload yang sesuai dengan skema
        const payload = {
          title: article.value.title,
          slug: article.value.slug,
          content: article.value.content,
          featured_image: article.value.featured_image || null,
          focus_keyword: article.value.focus_keyword,
          metaDescription: article.value.metaDescription
        };

        // WARNING: Ensure you have an 'articles' collection or change this path
        await api.post('/items/articles', payload);
        saveSuccess.value = true;
        
        // Reset form or redirect (optional)
      } catch (err) {
        saveError.value = err?.response?.data?.errors?.[0]?.message || err.message || 'Terjadi kesalahan';
      } finally {
        isSaving.value = false;
      }
    }

    return {
      article,
      editor,
      checks,
      isSaving,
      saveSuccess,
      saveError,
      saveArticle
    };
  }
};
</script>

<style>
/* Remove focus ring from tiptap editor */
.ProseMirror:focus {
  outline: none;
}
.ProseMirror {
  min-height: 360px;
}
.ProseMirror p {
  margin-bottom: 1em;
}
</style>
