const planService = require("../services/planService");

async function collect(request, response) {
  try {
    let rows = await planService.getPlans();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find plans",
      error: err.toString(),
    });
  }
}
async function get(request, response) {
  const id = parseInt(request.params.id);
  try {
    let rows = await planService.getPlan(id);
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find plan",
      error: err.toString(),
    });
  }
}

async function update(request, response) {
  const id = parseInt(request.params.id);
  const plan = request.body;
  try {
    await planService.updatePlan(id, plan);
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
