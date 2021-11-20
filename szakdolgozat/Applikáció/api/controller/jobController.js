const jobService = require("../services/jobService");

async function collect(request, response) {
  try {
    let rows = await jobService.getJobs();
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find jobs",
      error: err.toString(),
    });
  }
}
async function get(request, response) {
  const id = parseInt(request.params.id);
  try {
    let rows = await jobService.getJob(id);
    response.status(201).json({ message: "successful query", rows });
  } catch (err) {
    response.status(500).json({
      message: "could not find job",
      error: err.toString(),
    });
  }
}

async function update(request, response) {
  const id = parseInt(request.params.id);
  const job = request.body;
  try {
    await jobService.updateJob(id, job);
    response.status(201).json({
      message: "updated job successfully",
    });
  } catch (err) {
    response.status(500).json({
      message: "could not update job",
      error: err.toString(),
    });
  }
}

module.exports = {
  collect,
  get,
  update,
};
