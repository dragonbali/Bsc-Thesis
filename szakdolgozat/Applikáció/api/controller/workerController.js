const db = require("../storage/worker");
const planService = require("../storage/plan");

function setRegNumber(request, response) {
  const user_id = parseInt(request.query.id);
  const registration_number = request.body.registration_number;
  try {
    db.setRegNumber(user_id, registration_number);
    response.status(201).json({
      message: "updated worker registration_number successfully",
    });
  } catch (err) {
    response.status(500).json({
      message: "could not update worker registration_number",
      error: err.toString(),
    });
  }
}

function updateWorkerInspection(request, response) {
  const id = parseInt(request.query.id);
  const inspected = request.body.inspected;
  try {
    db.setWorkerInspected(id, inspected);
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

function updateWorkerCompleted(request, response) {
  const id = parseInt(request.query.id);
  const user_id = request.body.user_id;
  const completed = request.body.completed;
  const items = request.body.items;
  try {
    db.setWorkerCompleted(id, completed);
    planService.setPlan(user_id, completed, items);
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

async function getWorkers(request, response) {
  try {
    let rows = await db.getWorkers();
    response.status(201).json({ message: "lekerdezes sikeres", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}
async function getWorker(request, response) {
  const id = parseInt(request.query.id);
  try {
    let rows = await db.getWorker(id);
    response.status(201).json({ message: "lekerdezes sikeres", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find billing info",
      error: err.toString(),
    });
  }
}

function updateWorker(request, response) {
  const id = parseInt(request.query.id);
  const worker = request.body;
  try {
    db.updateWorker(id, worker);
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
  getWorkers,
  getWorker,
  setRegNumber,
  updateWorker,
};
