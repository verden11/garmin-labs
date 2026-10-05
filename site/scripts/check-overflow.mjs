// No horizontal scroll on phones: loads each page in headless Chrome with phone emulation (320, 360, 375, 414 px wide) and
// reports any page wider than the viewport and the outermost elements sticking out. Exit code 1 on any overflow.
// SHOTS=<dir> also saves a phone screenshot of each page and width.
// Usage (from site/, after npm run build):
//   (cd dist && python3 -m http.server 8765 &) ; node scripts/check-overflow.mjs http://127.0.0.1:8765 / /heroset/ /heroset/support/ ...
// A plain `chrome --headless --window-size=375,...` screenshot is NOT a phone view: headless keeps a ~500 px minimum layout
// width and crops, so it shows overflow that is not there. This script uses device emulation instead (Chrome DevTools protocol).
import { spawn } from 'node:child_process';
import { writeFileSync } from 'node:fs';
const CH = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const [base, ...paths] = process.argv.slice(2);
const chrome = spawn(CH, ['--headless=new', '--remote-debugging-port=9333', '--user-data-dir=/tmp/ovf-prof', '--hide-scrollbars', 'about:blank'], { stdio: 'ignore' });
await new Promise(r => setTimeout(r, 2500));
const ver = await (await fetch('http://127.0.0.1:9333/json/version')).json();
const ws = new WebSocket(ver.webSocketDebuggerUrl); await new Promise(r => ws.onopen = r);
let id = 0; const pending = new Map();
ws.onmessage = m => { const d = JSON.parse(m.data); if (d.id && pending.has(d.id)) { pending.get(d.id)(d); pending.delete(d.id); } };
const send = (method, params = {}, sessionId) => new Promise(r => { const i = ++id; pending.set(i, r); ws.send(JSON.stringify({ id: i, method, params, sessionId })); });
const { result: { targetId } } = await send('Target.createTarget', { url: 'about:blank' });
const { result: { sessionId } } = await send('Target.attachToTarget', { targetId, flatten: true });
// Elements past the right edge (left-hand overflow, like the off-screen skip link, does not scroll); only the outermost ones.
const probe = `(() => { const W = document.documentElement.clientWidth; const out = [];
  for (const el of document.querySelectorAll('body *')) { const r = el.getBoundingClientRect(); if (r.width && r.right > W + 0.5) {
    const p = el.parentElement; const pr = p ? p.getBoundingClientRect() : null;
    if (!pr || !(pr.right > W + 0.5)) out.push(el.tagName.toLowerCase() + (el.className && typeof el.className === 'string' ? '.' + el.className.trim().split(/\\s+/).join('.') : '') + ' L' + Math.round(r.left) + ' R' + Math.round(r.right) + ' "' + (el.textContent||'').trim().slice(0, 40) + '"'); } }
  return JSON.stringify({ W, sw: document.documentElement.scrollWidth, out: out.slice(0, 8) }); })()`;
let bad = 0;
for (const w of [320, 360, 375, 414]) {
  await send('Emulation.setDeviceMetricsOverride', { width: w, height: 800, deviceScaleFactor: 2, mobile: true }, sessionId);
  for (const p of paths) {
    await send('Page.navigate', { url: base + p }, sessionId); await new Promise(r => setTimeout(r, 700));
    const res = await send('Runtime.evaluate', { expression: probe, returnByValue: true }, sessionId);
    const v = JSON.parse(res.result.result.value);
    if (process.env.SHOTS) {
      const sh = await send('Page.captureScreenshot', { format: 'png', clip: { x: 0, y: 0, width: w, height: 800, scale: 1 } }, sessionId);
      writeFileSync(process.env.SHOTS + '/' + w + (p.replace(/\//g, '_') || '_') + '.png', Buffer.from(sh.result.data, 'base64'));
    }
    if (v.sw > v.W || v.out.length) { bad++; console.log(`${w}px ${p}: scrollWidth ${v.sw} > ${v.W}`); v.out.forEach(o => console.log('   ' + o)); }
  }
}
console.log(bad ? `${bad} page/width combinations overflow` : 'no horizontal overflow at 320/360/375/414');
ws.close(); chrome.kill();
process.exit(bad ? 1 : 0);
