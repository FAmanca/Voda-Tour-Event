import { defineModule } from '@directus/extensions-sdk';
import ModuleComponent from './module.vue';

export default defineModule({
  id: 'article-editor',
  name: 'Artikel Editor',
  icon: 'edit_document',
  routes: [
    {
      path: '',
      component: ModuleComponent,
    },
  ],
});
