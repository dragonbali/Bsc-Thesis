const db = require("../storage/plan");

async function collect(request, response) {
  try {
    let rows = await db.getPlans();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find plans",
      error: err.toString(),
    });
  }
}
async function get(request, response) {
  const id = parseInt(request.query.id);
  try {
    let rows = await db.getPlan(id);
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find plan",
      error: err.toString(),
    });
  }
}

function update(request, response) {
  const id = parseInt(request.query.id);
  const plan = request.body;
  try {
    db.updatePlan(id, plan);
    response.status(201).json({
      message: "updated plan successfully",
    });
  } catch (err) {
    response.status(500).json({
      message: "could not update plan",
      error: err.toString(),
    });
  }
}

module.exports = {
  collect,
  get,
  update,
};
