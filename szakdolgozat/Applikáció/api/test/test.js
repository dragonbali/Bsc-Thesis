const utils = require("../utils/index");

describe("tests", () => {
  test("calculate Percentage  2 + 4 should return 100", () => {
    expect(utils.calculatePercentage(2, 4)).toBe(100);
  });

  test("calculate Income should return 1000", () => {
    const data = {
      rows: [
        {
          items: [
            {
              item_total: 500,
              quantity: 2,
            },
          ],
        },
      ],
    };
    expect(utils.calculateIncome(data)).toBe(1000);
  });

  test("concat obj to sting should return Hello = 'World'", () => {
    const data = {
      Hello: "World",
    };
    expect(utils.concatMyString(data)).toBe(`Hello = 'World'`);
  });
});
