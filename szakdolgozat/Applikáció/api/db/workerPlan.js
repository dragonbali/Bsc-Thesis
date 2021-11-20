const pool = require("./repository");

async function UpdateWorkerPlanAndWorker(infos) {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    try {
      await client.query(
        `UPDATE worker_plan SET ` +
          `active=$1, ` +
          `plan_valid_until=$2, ` +
          `plan_id=$3, ` +
          `first_place_booster=$4, ` +
          `first_place_booster_valid_until=$5, ` +
          `social_ads=$6, ` +
          `social_ads_valid_until=$7 ` +
          `WHERE worker_id=$8`,
        [
          infos.active,
          infos.planValidUntil,
          infos.plan_id,
          infos.first_place_booster,
          infos.first_place_boosterValidUntil,
          infos.social_ads,
          infos.social_adsValidUntil,
          infos.workerId,
        ]
      );
      await client.query(
        `UPDATE worker SET ` +
          `payed_plan=$1, ` +
          `visible=$1, ` +
          `highlight=$1, ` +
          `priority=$2 ` +
          `WHERE id=$3`,
        [infos.active, infos.priority, infos.workerId]
      );
      await client.query("COMMIT");
      console.log("Worker plan modified");
      return true;
    } catch (error) {
      await client.query("ROLLBACK");
      console.log("Problem in worker plan update");
      console.log(error.message);
      return error;
    }
  } finally {
    client.release();
  }
}

module.exports = {
  UpdateWorkerPlanAndWorker,
};
