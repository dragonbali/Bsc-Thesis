function concatMyString(jobMod) {
  let size = Object.keys(jobMod).length;
  let myString = "";
  let i = 0;
  for (const [key, value] of Object.entries(jobMod)) {
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
  return myString;
}

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

module.exports = {
  concatMyString,
  calculateIncome,
  calculatePercentage,
};
