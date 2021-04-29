const pool = require("./repository");

async function getUsers() {
  const res = await pool.query("SELECT * FROM users");
  return res.rows;
}

async function getUser(id) {
  const res = await pool.query("SELECT * FROM users WHERE id=$1", [id]);
  return res.rows;
}

function updateUser(ID, user) {
  let size = Object.keys(user).length;
  let myString = "";
  let i = 0;
  for (const [key, value] of Object.entries(user)) {
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
    `UPDATE users SET ${myString} WHERE id=$1`,
    [ID],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`User modified with ID: ${ID}`);
      return true;
    }
  );
}

module.exports = {
  getUsers,
  getUser,
  updateUser,
};
