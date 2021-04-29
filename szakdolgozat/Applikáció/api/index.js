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
app.get("/billinginfo", billingController.getOrders);
app.get("/sixbillinginfo", billingController.getTopSixOrders);
app.get("/workers", workerController.getWorkers);
app.get("/worker", workerController.getWorker);
app.get("/users", usersController.getUsers);
app.get("/user", usersController.getUser);
app.get("/plans", planController.getPlans);
app.get("/plan", planController.getPlan);
app.get("/jobs", jobController.getJobs);
app.get("/job", jobController.getJob);
app.put("/update-inspection", workerController.updateWorkerInspection);
app.put("/update-completed", workerController.updateWorkerCompleted);
app.put("/update-regnumber", workerController.setRegNumber);
app.put("/update-worker", workerController.updateWorker);
app.put("/update-user", usersController.updateUser);
app.put("/update-plan", planController.updatePlan);
app.put("/update-job", jobController.updateJob);

app.listen(port, () => {
  console.log(`App running on port ${port}.`);
});
