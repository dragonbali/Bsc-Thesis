const pool = require("./repository");

async function getWorkerByUserId(user_id) {
  return await pool.query(`SELECT id FROM worker WHERE user_id=$1;`, [user_id]);
}

async function updateInspectedAndCanIssueInvoiceInWorker(workerID, inspected) {
  try {
    await pool.query(
      "UPDATE worker SET inspected=$1, can_issue_invoice=$1 WHERE user_id=$2",
      [inspected, workerID]
    );
    console.log(`Worker modified with ID: ${workerID}`);
    return true;
  } catch (error) {
    console.log(error.message);
    return error;
  }
}

async function getAllWorkers() {
  return await pool.query("SELECT * FROM worker");
}

async function getAWorkerById(id) {
  return await pool.query("SELECT * FROM worker WHERE id=$1", [id]);
}

async function updateAWorkerByWorkerId(myString, ID) {
  try {
    await pool.query(`UPDATE worker SET ${myString} WHERE id=$1`, [ID]);
    console.log(`worker modified with ID: ${ID}`);
    return true;
  } catch (error) {
    console.log(error.message);
    return error;
  }
}

module.exports = {
  getWorkerByUserId,
  updateInspectedAndCanIssueInvoiceInWorker,
  getAllWorkers,
  getAWorkerById,
  updateAWorkerByWorkerId,
};
