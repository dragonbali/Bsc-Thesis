const pool = require("../config/repository");

async function getAllJobsFromJobs() {
  return await pool.query("SELECT * FROM jobs");
}

async function getAJobFromJobs(id) {
  return await pool.query("SELECT * FROM jobs WHERE id=$1", [id]);
}

async function updateAJobInJobs(myString, ID) {
  try {
    await pool.query(`UPDATE jobs SET ${myString} WHERE id=$1`, [ID]);
    console.log(`Job modified with ID: ${ID}`);
    return true;
  } catch (error) {
    console.log(error.message);
    return error;
  }
}
module.exports = {
  getAllJobsFromJobs,
  getAJobFromJobs,
  updateAJobInJobs,
};
