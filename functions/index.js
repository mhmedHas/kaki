/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions


const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
*/
const { onRequest } = require("firebase-functions/v2/https");
const axios = require("axios");
const cheerio = require("cheerio");

exports.goldPrices = onRequest(async (req, res) => {
  try {
    const response = await axios.get("https://saudigoldprice.com/");
    const $ = cheerio.load(response.data);

    const goldPrices = {};

    $(".divTableRow").each((i, row) => {
      const cells = $(row).find(".divTableCell");
      if (cells.length < 3) return; // تجاهل الصفوف الغلط

      const label = cells.eq(0).text().trim();
      const sarText = cells.eq(1).text().replace(/,/g, "").trim();
      const price = parseFloat(sarText);

      if (isNaN(price)) return;

      if (label.includes("سعر جرام الذهب عيار 24")) goldPrices.g24 = price;
      else if (label.includes("سعر جرام الذهب عيار 22")) goldPrices.g22 = price;
      else if (label.includes("سعر جرام الذهب عيار 21")) goldPrices.g21 = price;
      else if (label.includes("سعر جرام الذهب عيار 18")) goldPrices.g18 = price;
    });

    res.json({
      currency: "SAR",
      ...goldPrices,
      updatedAt: new Date().toISOString(),
    });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

