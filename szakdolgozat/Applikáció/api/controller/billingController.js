const db = require("../storage/billing");

async function getSalesInfo(request, response) {
  try {
    let rows = await db.getSalesInfo();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}

async function getOrders(request, response) {
  try {
    let rows = await db.getOrders();
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
    let rows = await db.getTopSixOrders();
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
  getOrders,
  getTopSixOrders,
};
