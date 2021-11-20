const billing = require("../model/billingInfo");

async function getOrders() {
  const res = await billing.getAllFromBillingInfo();
  return res.rows;
}

async function getTopSixOrders() {
  const res = await billing.getTopSixOrdersFromBillingInfo();
  return res.rows;
}

/*--NOW--*/
//sales
async function getAllSalesOfToday() {
  const res = await billing.getAllSalesOfTodayFromBillingInfo();
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfTheWeek() {
  const res = await billing.getAllSalesOfTheWeekFromBillingInfo();
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfTheMonth() {
  const res = await billing.getAllSalesOfTheMonthFromBillingInfo();
  return parseInt(res.rows[0].count);
}

//money
async function getAllMoneyOfTheMonth() {
  const res = await billing.getAllMoneyOfTheMonthFromBillingInfo();
  return calculateIncome(res);
}

async function getAllMoneyOfTheWeek() {
  const res = await billing.getAllMoneyOfTheWeekFromBillingInfo();
  return calculateIncome(res);
}

async function getAllMoneyOfTheDay() {
  const res = await billing.getAllMoneyOfTheDayFromBillingInfo();
  return calculateIncome(res);
}

//packages
async function getAllPackageInfosOfTheMonth() {
  const res = await billing.getAllPackageInfosOfTheMonthFromBillingInfo();
  let counter3Month = 0;
  let counter6Month = 0;
  let counter12Month = 0;

  for (let i = 0; i < res.rows.length; i++) {
    const element = res.rows[i];
    if (element.items[0].sku === "CSOM-1") {
      counter3Month++;
    }
    if (element.items[0].sku === "CSOM-2") {
      counter6Month++;
    }
    if (element.items[0].sku === "CSOM-3") {
      counter12Month++;
    }
  }

  const packages = {
    threeMonth: counter3Month,
    sixMonth: counter6Month,
    twelveMonth: counter12Month,
  };
  return packages;
}

/*--PREVIOUS--*/
//sales
async function getAllSalesOfPreviousDay() {
  const res = await billing.getAllSalesOfPreviousDayFromBillingInfo();
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfPreviousWeek() {
  const res = await billing.getAllSalesOfPreviousWeekFromBillingInfo();
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfPreviousMonth() {
  const res = await billing.getAllSalesOfPreviousMonthFromBillingInfo();
  return parseInt(res.rows[0].count);
}

//money
async function getAllMoneyOfPreviousMonth() {
  const res = await billing.getAllMoneyOfPreviousMonthFromBillingInfo();
  return calculateIncome(res);
}

async function getAllMoneyOfPreviousWeek() {
  const res = await billing.getAllMoneyOfPreviousWeekFromBillingInfo();
  return calculateIncome(res);
}

async function getAllMoneyOfPreviousDay() {
  const res = await billing.getAllMoneyOfPreviousDayFromBillingInfo();
  return calculateIncome(res);
}

//functions
function calculateIncome(res) {
  let income = 0;
  for (let i = 0; i < res.rows.length; i++) {
    const element = res.rows[i];
    for (let j = 0; j < element.items.length; j++) {
      const oneItem = element.items[j];
      income += oneItem.item_total * oneItem.quantity;
    }
  }
  return income;
}

function calculatePercentage(last, now) {
  let res = now - last;
  return res / (last / 100);
}

//wrap all info into an object
async function getSalesInfo() {
  const res = {
    month: {
      quantity: await getAllSalesOfTheMonth(),
      money: await getAllMoneyOfTheMonth(),
      moneyPercent: calculatePercentage(
        await getAllMoneyOfPreviousMonth(),
        await getAllMoneyOfTheMonth()
      ),
      quantityPercent: calculatePercentage(
        await getAllSalesOfPreviousMonth(),
        await getAllSalesOfTheMonth()
      ),
      package: {
        threeMonth: (await getAllPackageInfosOfTheMonth()).threeMonth,
        sixMonth: (await getAllPackageInfosOfTheMonth()).sixMonth,
        twelveMonth: (await getAllPackageInfosOfTheMonth()).twelveMonth,
      },
    },
    week: {
      quantity: await getAllSalesOfTheWeek(),
      money: await getAllMoneyOfTheWeek(),
      moneyPercent: calculatePercentage(
        await getAllMoneyOfPreviousWeek(),
        await getAllMoneyOfTheWeek()
      ),
      quantityPercent: calculatePercentage(
        await getAllSalesOfPreviousWeek(),
        await getAllSalesOfTheWeek()
      ),
    },
    day: {
      quantity: await getAllSalesOfToday(),
      money: await getAllMoneyOfTheDay(),
      moneyPercent: calculatePercentage(
        await getAllMoneyOfPreviousDay(),
        await getAllMoneyOfTheDay()
      ),
      quantityPercent: calculatePercentage(
        await getAllSalesOfPreviousDay(),
        await getAllSalesOfToday()
      ),
    },
  };
  return res;
}

module.exports = {
  getSalesInfo,
  getOrders,
  getTopSixOrders,
};
