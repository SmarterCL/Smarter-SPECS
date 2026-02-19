import { defineConfig } from 'astro/config';
import node from '@astrojs/node';

export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'standalone',
    port: 3000
  }),
  site: 'https://openspec.smarterbot.cl',
  compressHTML: true,
  build: {
    inlineStylesheets: 'auto'
  },
  vite: {
    server: {
      host: '0.0.0.0',
      port: 3000
    }
  }
});
