import lighthouse from 'lighthouse';
import { launch } from 'chrome-launcher';

const url = 'https://kelmfaker.github.io/household-supplies/';

(async () => {
  const chrome = await launch({ chromeFlags: ['--headless', '--no-sandbox'] });
  try {
    const opts = { port: chrome.port };
    console.log(`Running Lighthouse on ${url}...`);
    const runnerResult = await lighthouse(url, opts);
    const report = runnerResult.lhr;
    if (!report.categories) {
      console.log('Full Lighthouse report object:');
      console.log(JSON.stringify(report, null, 2));
      throw new Error('Lighthouse report missing categories — the URL may be unreachable or returned non-HTML.');
    }
    console.log('Lighthouse scores:');
    console.log('Performance:', report.categories.performance.score * 100);
    console.log('Accessibility:', report.categories.accessibility.score * 100);
    console.log('Best Practices:', report.categories['best-practices'].score * 100);
    console.log('SEO:', report.categories.seo.score * 100);
    console.log('PWA:', report.categories.pwa.score * 100);
  } catch (err) {
    console.error('Lighthouse run failed:', err);
  } finally {
    await chrome.kill();
  }
})();
