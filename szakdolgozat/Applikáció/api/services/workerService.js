const worker = require("../db/worker");
const billing = require("../db/billingInfo");
const utils = require("../utils/index");

async function setWorkerInspected(workerID, inspected) {
  const res = await worker.updateInspectedAndCanIssueInvoiceInWorker(
    workerID,
    inspected
  );

  if (res != true) {
    throw `error at: ${res.message}}, Inspected and Can Issue Invoice Update`;
  }
}
async function setWorkerCompleted(ID, completed) {
  const res = await billing.updateCompletedInInBillingInfoByWorkerId(
    ID,
    completed
  );

  if (res != true) {
    throw `error at: ${res.message}}, Completed status Update`;
  }
}

async function getWorkers() {
  const res = await worker.getAllWorkers();
  return res.rows;
}

async function getWorker(id) {
  const res = await worker.getAWorkerById(id);
  return res.rows;
}

async function updateWorker(ID, workerMod) {
  let myString = utils.concatMyString(workerMod);

  const res = await worker.updateAWorkerByWorkerId(myString, ID);

  if (res != true) {
    throw `error at: ${res.message}}`;
  }
}

module.exports = {
  getWorkers,
  setWorkerInspected,
  setWorkerCompleted,
  getWorker,
  updateWorker,
};
