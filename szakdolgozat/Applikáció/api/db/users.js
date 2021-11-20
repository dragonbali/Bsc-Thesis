const pool = require("./repository");

async function getAllUsers() {
  return await pool.query("SELECT * FROM users");
}

async function getAUserById(id) {
  return await pool.query("SELECT * FROM users WHERE id=$1", [id]);
}

async function updateAUserInUsers(myString, ID) {
  try {
    pool.query(`UPDATE users SET ${myString} WHERE id=$1`, [ID]);
    console.log(`User modified with ID: ${ID}`);
    return true;
  } catch (error) {
    console.log(error.message);
    return error;
  }
}

module.exports = {
  getAllUsers,
  getAUserById,
  updateAUserInUsers,
};
