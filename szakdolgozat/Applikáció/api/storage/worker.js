const pool = require("./repository");

function setWorkerInspected(workerID, inspected) {
  pool.query(
    "UPDATE worker SET inspected=$1, can_issue_invoice=$1 WHERE user_id=$2",
    [inspected, workerID],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`Worker modified with ID: ${workerID}`);
      return true;
    }
  );
}
function setWorkerCompleted(ID, completed) {
  pool.query(
    "UPDATE billing_info SET completed=$1 WHERE id=$2",
    [completed, ID],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`BillingInfo modified with ID: ${ID}`);
      return true;
    }
  );
}

async function getWorkers() {
  const res = await pool.query("SELECT * FROM worker");
  return res.rows;
}

async function getWorker(id) {
  const res = await pool.query("SELECT * FROM worker WHERE id=$1", [id]);
  return res.rows;
}

function setRegNumber(user_id, number) {
  pool.query(
    "UPDATE worker SET registration_number=$1 WHERE user_id=$2",
    [number, user_id],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`Worker modified with ID: ${user_id}`);
      return true;
    }
  );
}
function updateWorker(ID, worker) {
  let size = Object.keys(worker).length;
  let myString = "";
  let i = 0;
  for (const [key, value] of Object.entries(worker)) {
    i++;
    if (i === size && typeof value === "string") {
      myString = myString.concat(`${key} = '${value}'`);
    } else {
      if (i === size && typeof value !== "string") {
        myString = myString.concat(`${key} = ${value}`);
      } else {
        if (typeof value === "string") {
          myString = myString.concat(`${key} = '${value}', `);
        } else {
          myString = myString.concat(`${key} = ${value}, `);
        }
      }
    }
  }
  pool.query(
    `UPDATE worker SET ${myString} WHERE id=$1`,
    [ID],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`Worker modified with ID: ${ID}`);
      return true;
    }
  );
}

module.exports = {
  getWorkers,
  setWorkerInspected,
  setWorkerCompleted,
  setRegNumber,
  getWorker,
  updateWorker,
};
