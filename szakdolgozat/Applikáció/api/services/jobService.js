const job = require("../db/job");
const utils = require("../utils/index");

async function getJobs() {
  const res = await job.getAllJobsFromJobs();
  return res.rows;
}

async function getJob(id) {
  const res = await job.getAJobFromJobs(id);
  return res.rows;
}

async function updateJob(ID, jobMod) {
  let myString = utils.concatMyString(jobMod);

  const res = await job.updateAJobInJobs(myString, ID);

  if (res != true) {
    throw `error at: ${res.message}}`;
  }
}

module.exports = {
  getJobs,
  getJob,
  updateJob,
};
