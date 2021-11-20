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

module.exports = {
  concatMyString,
};
