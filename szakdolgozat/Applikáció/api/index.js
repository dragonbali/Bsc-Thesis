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
app.get("/salesinfo", billingController.getSalesInfo);
app.get("/billinginfo", billingController.get);
app.get("/sixbillinginfo", billingController.getTopSixOrders);

app.get("/workers", workerController.collect);
app.get("/worker", workerController.get);

app.get("/users", usersController.collect);
app.get("/user", usersController.get);

app.get("/plans", planController.collect);
app.get("/plan", planController.get);

app.get("/jobs", jobController.collect);
app.get("/job", jobController.get);

app.put("/update-inspection", workerController.updateWorkerInspection);
app.put("/update-completed", workerController.updateWorkerCompleted);

app.put("/update-regnumber", workerController.setRegNumber);

app.put("/update-worker", workerController.update);
app.put("/update-user", usersController.update);
app.put("/update-plan", planController.update);
app.put("/update-job", jobController.update);

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});
