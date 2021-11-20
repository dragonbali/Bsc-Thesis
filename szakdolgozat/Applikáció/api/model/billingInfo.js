const pool = require("./repository");

async function getAllFromBillingInfo() {
  return await pool.query(`SELECT * FROM billing_info`);
}

async function getTopSixOrdersFromBillingInfo() {
  return await pool.query(
    `SELECT * FROM billing_info ORDER BY id DESC LIMIT 6`
  );
}

async function updateCompletedInInBillingInfoByWorkerId(ID, completed) {
  try {
    await pool.query("UPDATE billing_info SET completed=$1 WHERE id=$2", [
      completed,
      ID,
    ]);
    console.log(`BillingInfo modified with ID: ${ID}`);
    return true;
  } catch (error) {
    console.log(error.message);
    return error;
  }
}

//sales NOW
async function getAllSalesOfTodayFromBillingInfo() {
  return await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 day'`
  );
}

async function getAllSalesOfTheWeekFromBillingInfo() {
  return await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 week'`
  );
}

async function getAllSalesOfTheMonthFromBillingInfo() {
  return await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 month'`
  );
}

//money NOW
async function getAllMoneyOfTheMonthFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 month';`
  );
}

async function getAllMoneyOfTheWeekFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 week';`
  );
}

async function getAllMoneyOfTheDayFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 day';`
  );
}

//packages NOW
async function getAllPackageInfosOfTheMonthFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '1 month';`
  );
}

//sales PREVIOUS
async function getAllSalesOfPreviousDayFromBillingInfo() {
  return await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 day' ` +
      `AND created_at::date < now() - interval '1 day'`
  );
}
async function getAllSalesOfPreviousWeekFromBillingInfo() {
  return await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 week' ` +
      `AND created_at::date < now() - interval '1 week'`
  );
}

async function getAllSalesOfPreviousMonthFromBillingInfo() {
  return await pool.query(
    `SELECT COUNT(*) FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 month' ` +
      `AND created_at::date < now() - interval '1 month'`
  );
}

//money PREVIOUS
async function getAllMoneyOfPreviousMonthFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 month' ` +
      `AND created_at::date < now() - interval '1 month';`
  );
}

async function getAllMoneyOfPreviousWeekFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true ` +
      `AND created_at::date > now() - interval '2 week' ` +
      `AND created_at::date < now() - interval '1 week';`
  );
}

async function getAllMoneyOfPreviousDayFromBillingInfo() {
  return await pool.query(
    `SELECT payment_prep_request->'items' "items" FROM billing_info ` +
      `WHERE completed=true AND created_at::date > now() - interval '2 day' ` +
      `AND created_at::date < now() - interval '1 day';`
  );
}

module.exports = {
  getAllFromBillingInfo,
  getTopSixOrdersFromBillingInfo,
  updateCompletedInInBillingInfoByWorkerId,
  getAllSalesOfTodayFromBillingInfo,
  getAllSalesOfTheWeekFromBillingInfo,
  getAllSalesOfTheMonthFromBillingInfo,
  getAllMoneyOfTheMonthFromBillingInfo,
  getAllMoneyOfTheWeekFromBillingInfo,
  getAllMoneyOfTheDayFromBillingInfo,
  getAllPackageInfosOfTheMonthFromBillingInfo,
  getAllSalesOfPreviousDayFromBillingInfo,
  getAllSalesOfPreviousWeekFromBillingInfo,
  getAllSalesOfPreviousMonthFromBillingInfo,
  getAllMoneyOfPreviousMonthFromBillingInfo,
  getAllMoneyOfPreviousWeekFromBillingInfo,
  getAllMoneyOfPreviousDayFromBillingInfo,
};
