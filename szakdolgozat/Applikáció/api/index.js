const dotenv = require("dotenv").config();
const express = require("express");
const config = require("./config/environtment");
const app = express();
const cors = require("cors");
const port = 4000;
const workerController = require("./controller/workerController");
const billingController = require("./controller/billingController");
const usersController = require("./controller/usersController");
const planController = require("./controller/planController");
const jobController = require("./controller/jobController");

app.use(express.json());
app.use(cors());

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  next();
});

const apiPrefix = "/api/v1";

app.get("/", (request, response) => {
  response.json({ info: "Node.js, Express, and Postgres API" });
});

//GET requests
app.get(apiPrefix + "/info/sales", billingController.getSalesInfo);
app.get(apiPrefix + "/info/billings", billingController.get);
app.get(apiPrefix + "/info/sixbillings", billingController.getTopSixOrders);

app.get(apiPrefix + "/workers", workerController.collect);
app.get(apiPrefix + "/workers/:id", workerController.get);

app.get(apiPrefix + "/users", usersController.collect);
app.get(apiPrefix + "/users/:id", usersController.get);

app.get(apiPrefix + "/plans", planController.collect);
app.get(apiPrefix + "/plans/:id", planController.get);

app.get(apiPrefix + "/jobs", jobController.collect);
app.get(apiPrefix + "/jobs/:id", jobController.get);

//PUT requests
app.put(
  apiPrefix + "/workers/update/inspection/:id",
  workerController.updateWorkerInspection
);
app.put(
  apiPrefix + "/workers/update/completed/:id",
  workerController.updateWorkerCompleted
);

app.put(apiPrefix + "/workers/update/worker/:id", workerController.update);
app.put(apiPrefix + "/users/update/user/:id", usersController.update);
app.put(apiPrefix + "/plans/update/plan/:id", planController.update);
app.put(apiPrefix + "/jobs/update/job/:id", jobController.update);

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});
