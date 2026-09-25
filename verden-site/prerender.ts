import { mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { dirname } from 'node:path'
import { fill } from './vite.config.ts'
// @ts-ignore built by `vite build --ssr` just before this runs
import { render, routes } from './.ssr/entry-server.js'
import { studio } from './src/site.ts'

const template = readFileSync('dist/index.html', 'utf8')
const write = (file: string, url: string) => {
  mkdirSync(dirname(file), { recursive: true })
  writeFileSync(file, fill(template, render(url)))
}

for (const url of routes as string[]) write(`dist${url}index.html`, url)
write('dist/404.html', '/404')

const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${(routes as string[]).map((url) => `  <url><loc>${studio.origin}${url}</loc></url>`).join('\n')}
</urlset>
`
writeFileSync('dist/sitemap.xml', sitemap)

rmSync('.ssr', { recursive: true })
console.log(`prerendered ${routes.length} pages + 404 + sitemap`)
