import { readFileSync } from 'node:fs'
import { defineConfig, type Plugin } from 'vite'

// Pages are rendered from React on the server (dev) or at build time (prerender.ts);
// the browser gets plain HTML + CSS, no hydration.
function devRender(): Plugin {
  return {
    name: 'dev-render',
    configureServer(server) {
      server.middlewares.use(async (req, res, next) => {
        const url = req.url ?? '/'
        if (req.method !== 'GET' || !req.headers.accept?.includes('text/html')) return next()
        try {
          const template = await server.transformIndexHtml(url, readFileSync('index.html', 'utf8'))
          const { render } = await server.ssrLoadModule('/src/entry-server.tsx')
          const page = render(url.split('?')[0])
          res.statusCode = page.status
          res.setHeader('Content-Type', 'text/html')
          res.end(fill(template, page))
        } catch (e) {
          server.ssrFixStacktrace(e as Error)
          next(e)
        }
      })
    },
  }
}

export function fill(template: string, page: { head: string; body: string }): string {
  return template.replace('<!--head-->', page.head).replace('<!--body-->', page.body)
}

export default defineConfig({ plugins: [devRender()] })
