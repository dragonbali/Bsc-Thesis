const users = require("../model/users");
const utils = require("../utils/index");

async function getUsers() {
  const res = await users.getAllUsers();
  return res.rows;
}

async function getUser(id) {
  const res = await users.getAUserById(id);
  return res.rows;
}

async function updateUser(ID, user) {
  let myString = utils.concatMyString(user);

  const res = await users.updateAUserInUsers(myString, ID);

  if (res != true) {
    throw `error at: ${res.message}}`;
  }
}

module.exports = {
  getUsers,
  getUser,
  updateUser,
};
