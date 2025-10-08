const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const captionsPath = path.join(__dirname, 'play_console_screenshots_captions.json');
const screenshotsDir = path.join(process.cwd(), 'screenshots');

if (!fs.existsSync(captionsPath)) {
  console.error('captions JSON not found:', captionsPath);
  process.exit(1);
}

const captions = JSON.parse(fs.readFileSync(captionsPath, 'utf8'));
if (!fs.existsSync(screenshotsDir)) fs.mkdirSync(screenshotsDir);

(async () => {
  for (const item of captions) {
    const filename = item.file;
    const caption = item.caption || '';
    const svg = `
      <svg width="1200" height="700" xmlns="http://www.w3.org/2000/svg">
        <rect width="100%" height="100%" fill="#0f172a" />
        <rect x="40" y="40" width="1120" height="620" rx="12" fill="#111827" stroke="#374151" stroke-width="2" />
        <text x="60" y="110" font-size="36" fill="#ffffff" font-family="Arial, Helvetica, sans-serif">${escapeHtml(item.step + '. ' + caption)}</text>
        <text x="60" y="160" font-size="18" fill="#9ca3af" font-family="Arial, Helvetica, sans-serif">Placeholder screenshot for step ${item.step}</text>
        <rect x="60" y="200" width="1080" height="380" rx="8" fill="#1f2937" />
        <text x="80" y="260" font-size="24" fill="#cbd5e1" font-family="Arial, Helvetica, sans-serif">This is a generated placeholder image. Replace with real Play Console screenshot.</text>
      </svg>
    `;

    const outPath = path.join(screenshotsDir, filename);
    try {
      await sharp(Buffer.from(svg)).png().toFile(outPath);
      console.log('Wrote placeholder:', outPath);
    } catch (err) {
      console.error('Error writing', outPath, err);
    }
  }
})();

function escapeHtml(s) {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}
