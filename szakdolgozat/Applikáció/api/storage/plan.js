const pool = require("./repository");

async function setPlan(user_id, completed, items) {
  //console.log(items);
  const worker_id = await pool.query(
    `SELECT id FROM worker WHERE user_id=$1;`,
    [user_id]
  );
  let infos = {
    workerId: worker_id.rows[0].id,
    active: completed,
    planValidUntil: new Date(),
    plan_id: 1,
    first_place_booster: false,
    first_place_boosterValidUntil: new Date(),
    priority: 0,
    social_ads: false,
    social_adsValidUntil: new Date(),
  };
  for (let i = 0; i < items.length; i++) {
    const element = items[i];
    switch (element.sku) {
      case "CSOM-1":
        infos.plan_id = 2;
        infos.planValidUntil = new Date(
          infos.planValidUntil.setMonth(infos.planValidUntil.getMonth() + 3)
        );
        break;
      case "CSOM-2":
        infos.plan_id = 3;
        infos.planValidUntil = new Date(
          infos.planValidUntil.setMonth(infos.planValidUntil.getMonth() + 6)
        );
        break;
      case "CSOM-3":
        infos.plan_id = 4;
        infos.planValidUntil = new Date(
          infos.planValidUntil.setMonth(infos.planValidUntil.getMonth() + 12)
        );
        break;
      case "EXTRA-1":
        infos.first_place_booster = true;
        infos.priority = 99;
        infos.first_place_boosterValidUntil = new Date(
          infos.first_place_boosterValidUntil.setMonth(
            infos.first_place_boosterValidUntil.getMonth() +
              1 * element.quantity
          )
        );
        break;
      case "EXTRA-2":
        infos.social_ads = true;
        infos.social_adsValidUntil = new Date(
          infos.social_adsValidUntil.setMonth(
            infos.social_adsValidUntil.getMonth() + 1 * element.quantity
          )
        );
        break;
      default:
        console.error("problem in setPlan switch-case");
        break;
    }
  }

  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    try {
      client.query(
        "UPDATE worker_plan SET active=$1, plan_valid_until=$2, plan_id=$3, first_place_booster=$4, first_place_booster_valid_until=$5, social_ads=$6, social_ads_valid_until=$7 WHERE worker_id=$8",
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
      client.query(
        "UPDATE worker SET payed_plan=$1, visible=$1, highlight=$1, priority=$2 WHERE id=$3",
        [infos.active, infos.priority, infos.workerId]
      );
      client.query("COMMIT");
      console.log("Worker plan modified");
    } catch (e) {
      await client.query("ROLLBACK");
      console.log("Problem in worker plan update");
      throw e;
    }
  } finally {
    client.release();
  }
}

async function getPlans() {
  const res = await pool.query("SELECT * FROM plans");
  return res.rows;
}

async function getPlan(id) {
  const res = await pool.query("SELECT * FROM plans WHERE id=$1", [id]);
  return res.rows;
}

function updatePlan(ID, plan) {
  let size = Object.keys(plan).length;
  let myString = "";
  let i = 0;
  for (const [key, value] of Object.entries(plan)) {
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
    `UPDATE plans SET ${myString} WHERE id=$1`,
    [ID],
    (error, results) => {
      if (error) {
        throw error;
      }
      console.log(`Plan modified with ID: ${ID}`);
      return true;
    }
  );
}

module.exports = {
  setPlan,
  getPlans,
  getPlan,
  updatePlan,
};
