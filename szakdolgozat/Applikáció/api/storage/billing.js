const pool = require("./repository");

async function getOrders() {
  const res = await pool.query(`SELECT * FROM billing_info`);
  return res.rows;
}
async function getTopSixOrders() {
  const res = await pool.query(
    `SELECT * FROM billing_info ORDER BY id DESC LIMIT 6`
  );
  return res.rows;
}
//now
async function getAllSalesOfToday() {
  const res = await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 day'`
  );
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfTheWeek() {
  const res = await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 week'`
  );
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfTheMonth() {
  const res = await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 month'`
  );
  return parseInt(res.rows[0].count);
}

async function getAllMoneyOfTheMonth() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 month';`
  );
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

async function getAllMoneyOfTheWeek() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 week';`
  );
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

async function getAllMoneyOfTheDay() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 day';`
  );
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

async function getAllPackageInfosOfTheMonth() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 month';`
  );
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

//prev

async function getAllSalesOfPreviousDay() {
  const res = await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 day' ` +
      `AND created_at::date < now() - interval '1 day'`
  );
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfPreviousWeek() {
  const res = await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 week' ` +
      `AND created_at::date < now() - interval '1 week'`
  );
  return parseInt(res.rows[0].count);
}

async function getAllSalesOfPreviousMonth() {
  const res = await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 month' ` +
      `AND created_at::date < now() - interval '1 month'`
  );
  return parseInt(res.rows[0].count);
}

async function getAllMoneyOfPreviousMonth() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 month' ` +
      `AND created_at::date < now() - interval '1 month';`
  );
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

async function getAllMoneyOfPreviousWeek() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 week' ` +
      `AND created_at::date < now() - interval '1 week';`
  );
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

async function getAllMoneyOfPreviousDay() {
  const res = await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true AND created_at::date > now() - interval '2 day' ` +
      `AND created_at::date < now() - interval '1 day';`
  );
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

//funcs

function calculatePercentage(last, now) {
  let res = now - last;
  return res / (last / 100);
}

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
