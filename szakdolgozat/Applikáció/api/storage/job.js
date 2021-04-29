const pool = require("./repository");

async function getJobs() {
  const res = await pool.query("SELECT * FROM jobs");
  return res.rows;
}

async function getJob(id) {
  const res = await pool.query("SELECT * FROM jobs WHERE id=$1", [id]);
  return res.rows;
}

function updateJob(ID, job) {
  console.log(job);
  let size = Object.keys(job).length;
  let myString = "";
  let i = 0;
  for (const [key, value] of Object.entries(job)) {
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
  console.log(myString);
  pool.query(
    `UPDATE jobs SET ${myString} WHERE id=$1`,
    [ID],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`Job modified with ID: ${ID}`);
      return true;
    }
  );
}

module.exports = {
  getJobs,
  getJob,
  updateJob,
};
