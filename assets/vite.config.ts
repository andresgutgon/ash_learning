import { resolve } from 'node:path'

import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { defineConfig, type ConfigEnv } from 'vite'

import vitexPlugin from '../deps/vitex/priv/vitejs/vitePlugin.js'

const isSSR = process.env.VITE_SSR === 'true'
const input: Record<string, string> = isSSR ? { ssr: './js/ssr.tsx' } : { app: './js/app.tsx' }

function buildDevDomains() {
  const host = process.env.PHX_HOST

  if (!host) {
    throw new Error('PHX_HOST is not set in .env.development.')
  }

  return {
    dockerHost: 'host.docker.internal',
    host,
    viteHost: `vite.${host}`,
    main: `https://${host}`,
    app: `https://app.${host}`,
    wildcard: new RegExp(`^https://[a-zA-Z0-9-]+\\.${host.replace('.', '\\.')}$`),
  }
}

/**
 * Vite runs under Traefik in development inside Docker.
 */
function buildDevServerUrl(isDev: boolean) {
  if (!isDev) return undefined

  const domains = buildDevDomains()
  return {
    host: true, // listen on all interfaces inside Docker
    port: 5173,
    allowedHosts: [domains.host, domains.viteHost, domains.dockerHost],
    hmr: {
      protocol: 'wss',
      host: domains.viteHost,
    },
    cors: {
      origin: [domains.main, domains.app, domains.wildcard],
      credentials: true,
    },
  }
}

export default defineConfig(({ mode }: ConfigEnv) => {
  const isProd = mode === 'production'
  const isDev = mode === 'development'

  return {
    publicDir: 'static',
    plugins: [react(), tailwindcss(), vitexPlugin({ inertiaSSREntrypoint: './js/ssr.tsx' })],
    resolve: {
      alias: {
        '@': resolve(__dirname, './js'),
      },
    },
    server: buildDevServerUrl(isDev),
    build: {
      target: 'esnext',
      sourcemap: isDev && !isSSR,
      minify: isProd && !isSSR,
      ssr: isSSR,
      emptyOutDir: isSSR,
      polyfillDynamicImport: !isSSR,
      outDir: isSSR ? '../priv/ssr-js' : '../priv/static',
      manifest: !isSSR ? 'assets/vite_manifest.json' : false,
      rollupOptions: {
        external: ['fonts/*', 'images/*'],
        input,
        output: {
          entryFileNames: isSSR ? '[name].js' : 'assets/[name].[hash].js',
          chunkFileNames: 'assets/[name].[hash].js',
          assetFileNames: 'assets/[name].[hash][extname]',
        },
      },
    },
  }
})
