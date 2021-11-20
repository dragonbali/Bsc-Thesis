const worker = require("../model/worker");
const workerPlan = require("../model/workerPlan");
const plans = require("../model/plans");
const utils = require("../utils/index");

async function setPlan(user_id, completed, items) {
  const worker_id = await worker.getWorkerByUserId(user_id);
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
  const res = await workerPlan.UpdateWorkerPlanAndWorker(infos);

  if (res != true) {
    throw `error at: ${res.message}}`;
  }
}

async function getPlans() {
  const res = await plans.getAllFromPlans();
  return res.rows;
}

async function getPlan(id) {
  const res = await plans.getAPlanById(id);
  return res.rows;
}

async function updatePlan(ID, plan) {
  let myString = utils.concatMyString(plan);

  const res = await plans.updateAPlanInPlans(myString, ID);

  if (res != true) {
    throw `error at: ${res.message}}`;
  }
}

module.exports = {
  setPlan,
  getPlans,
  getPlan,
  updatePlan,
};
