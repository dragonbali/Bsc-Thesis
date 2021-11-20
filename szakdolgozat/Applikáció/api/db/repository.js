const config = require("../config/environtment");
const Pool = require("pg").Pool;
var types = require("pg").types;
var Moment = require("moment");

const pool = new Pool(config.postgres);

var parseDate = function parseDate(val) {
  return val === null ? null : Moment(val).format("YYYY-MM-DD");
};
var DATATYPE_DATE = 1082;
types.setTypeParser(DATATYPE_DATE, function (val) {
  return val === null ? null : parseDate(val);
});

module.exports = pool;
