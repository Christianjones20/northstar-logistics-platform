import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],

  server: {
    host: '0.0.0.0',
    port: 5173,
    allowedHosts: [
      'northstar-frontend',
      'localhost',
      '172.168.110.106'
    ]
  }
})