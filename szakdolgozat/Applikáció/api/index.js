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

app.get("/", (request, response) => {
  response.json({ info: "Node.js, Express, and Postgres API" });
});

app.get("/info/sales", billingController.getSalesInfo);
app.get("/info/billings", billingController.get);
app.get("/info/sixbillings", billingController.getTopSixOrders);

app.get("/workers", workerController.collect);
app.get("/workers/:id", workerController.get);

app.get("/users", usersController.collect);
app.get("/users/:id", usersController.get);

app.get("/plans", planController.collect);
app.get("/plans/:id", planController.get);

app.get("/jobs", jobController.collect);
app.get("/jobs/:id", jobController.get);

app.put(
  "/workers/update/inspection/:id",
  workerController.updateWorkerInspection
);
app.put(
  "/workers/update/completed/:id",
  workerController.updateWorkerCompleted
);

app.put("/workers/update/worker/:id", workerController.update);
app.put("/users/update/user/:id", usersController.update);
app.put("/plans/update/plan/:id", planController.update);
app.put("/jobs/update/job/:id", jobController.update);

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});
