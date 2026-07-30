import { defineModule } from '@directus/extensions-sdk';
import ModuleComponent from './module.vue';

export default defineModule({
  id: 'package-editor',
  name: 'Package Builder',
  icon: 'dashboard_customize',
  routes: [
    {
      path: '',
      component: ModuleComponent,
    },
  ],
});
