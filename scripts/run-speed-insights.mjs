import { SpeedInsights } from "@vercel/speed-insights";

(async () => {
  try {
    const url = 'https://kelmfaker.github.io/household-supplies/';
    console.log(`Running Speed Insights against: ${url}`);
    const result = await SpeedInsights({ url });
    console.log(JSON.stringify(result, null, 2));
  } catch (err) {
    console.error('Error running SpeedInsights:', err);
    process.exitCode = 1;
  }
})();
