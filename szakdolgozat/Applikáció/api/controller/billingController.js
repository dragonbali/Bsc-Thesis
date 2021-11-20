const billingService = require("../services/billingService");

async function getSalesInfo(request, response) {
  try {
    let rows = await billingService.getSalesInfo();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}

async function get(request, response) {
  try {
    let rows = await billingService.getOrders();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}

async function getTopSixOrders(request, response) {
  try {
    let rows = await billingService.getTopSixOrders();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}

module.exports = {
  getSalesInfo,
  get,
  getTopSixOrders,
};
