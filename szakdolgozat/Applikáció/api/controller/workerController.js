const workerService = require("../services/workerService");
const planService = require("../services/planService");

async function updateWorkerInspection(request, response) {
  const id = parseInt(request.params.id);
  const inspected = request.body.inspected;
  try {
    await workerService.setWorkerInspected(id, inspected);
    response.status(201).json({
      message: "updated worker inspection successfully",
    });
  } catch (err) {
    response.status(500).json({
      message: "could not update worker",
      error: err.toString(),
    });
  }
}

async function updateWorkerCompleted(request, response) {
  const id = parseInt(request.params.id);
  const user_id = request.body.user_id;
  const completed = request.body.completed;
  const items = request.body.items;
  try {
    await workerService.setWorkerCompleted(id, completed);
    await planService.setPlan(user_id, completed, items);
    response.status(201).json({
      message: "updated worker inspection successfully",
    });
  } catch (err) {
    response.status(500).json({
      message: "could not update worker",
      error: err.toString(),
    });
  }
}

async function collect(request, response) {
  try {
    let rows = await workerService.getWorkers();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}
async function get(request, response) {
  const id = parseInt(request.params.id);
  try {
    let rows = await workerService.getWorker(id);
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}

async function update(request, response) {
  const id = parseInt(request.params.id);
  const worker = request.body;
  try {
    await workerService.updateWorker(id, worker);
    response.status(201).json({
      message: "updated worker successfully",
    });
  } catch (err) {
    response.status(500).json({
      message: "could not update worker",
      error: err.toString(),
    });
  }
}

module.exports = {
  updateWorkerInspection,
  updateWorkerCompleted,
  collect,
  get,
  update,
};
