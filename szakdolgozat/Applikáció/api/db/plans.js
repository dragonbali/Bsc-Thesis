const pool = require("../config/repository");

async function getAllFromPlans() {
  return await pool.query("SELECT * FROM plans");
}

async function getAPlanById(id) {
  return await pool.query("SELECT * FROM plans WHERE id=$1", [id]);
}

async function updateAPlanInPlans(myString, ID) {
  try {
    await pool.query(`UPDATE plans SET ${myString} WHERE id=$1`, [ID]);
    console.log(`Plan modified with ID: ${ID}`);
    return true;
  } catch (error) {
    console.log(error.message);
    return error;
  }
}

module.exports = {
  getAllFromPlans,
  getAPlanById,
  updateAPlanInPlans,
};
