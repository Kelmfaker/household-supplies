const fs = require('fs');
const path = require('path');
const PDFDocument = require('pdfkit');
const sharp = require('sharp');

const captionsPath = path.join(__dirname, 'play_console_screenshots_captions.json');
const screenshotsDir = path.join(process.cwd(), 'screenshots');
const outPath = path.join(process.cwd(), 'play-console-screenshots.pdf');

if (!fs.existsSync(captionsPath)) {
  console.error('captions JSON not found:', captionsPath);
  process.exit(1);
}

const captions = JSON.parse(fs.readFileSync(captionsPath, 'utf8'));

if (!fs.existsSync(screenshotsDir)) {
  console.error('screenshots folder not found. Capture screenshots into ./screenshots');
  process.exit(2);
}

(async function () {
  const doc = new PDFDocument({ autoFirstPage: false });
  const out = fs.createWriteStream(outPath);
  doc.pipe(out);

  for (const item of captions) {
    const file = path.join(screenshotsDir, item.file);
    if (!fs.existsSync(file)) {
      console.warn('Missing screenshot, skipping:', file);
      continue;
    }

    // Use sharp to get metadata and convert to JPEG to embed
    try {
      const buffer = await sharp(file).jpeg({ quality: 80 }).toBuffer();
      const metadata = await sharp(buffer).metadata();

      // Add a page sized to the image (A4 fallback if huge)
      const pageWidth = Math.min(metadata.width, 1200);
      const pageHeight = Math.round((metadata.height / metadata.width) * pageWidth) + 120; // extra for caption

      doc.addPage({ size: [pageWidth, pageHeight] });
      doc.image(buffer, 0, 0, { width: pageWidth });

      // Caption
      doc.fontSize(12).fillColor('black');
      doc.text(item.caption || '', 10, pageWidth > 800 ? pageWidth - 20 : pageHeight - 100, {
        width: pageWidth - 20,
        align: 'left'
      });
    } catch (err) {
      console.error('Error processing', file, err);
    }
  }

  doc.end();
  out.on('finish', () => {
    console.log('PDF generated at', outPath);
  });
})();
