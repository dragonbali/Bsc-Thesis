import React from "react";

import async from "../components/Async";

import { List, ShoppingCart, Sliders } from "react-feather";

// Dashboard components
const Default = async(() => import("../pages/statistics"));

const Orders = async(() => import("../pages/orders/Orders"));

// Tables components
const WorkerTable = async(() => import("../pages/tables/WorkerTable"));
const EditWorker = async(() => import("../pages/tables/EditWorker"));
const UsersTable = async(() => import("../pages/tables/UsersTable"));
const EditUser = async(() => import("../pages/tables/EditUser"));
const PlansTable = async(() => import("../pages/tables/PlansTable"));
const EditPlan = async(() => import("../pages/tables/EditPlan"));
const JobsTable = async(() => import("../pages/tables/JobsTable"));
const EditJob = async(() => import("../pages/tables/EditJob"));

const dashboardsRoutes = {
  id: "Alap adatok",
  path: "/dashboard",
  icon: <Sliders />,
  containsHome: true,
  children: null,
  component: Default,
};

const orderRoutes = {
  id: "Megrendelések",
  path: "/orders",
  icon: <ShoppingCart />,
  component: Orders,
  children: null,
};

const formsRoutes = {
  id: "Táblák",
  path: "/forms",
  icon: <List />,
  children: [
    {
      path: "/tables/workers/table",
      name: "Workers",
      component: WorkerTable,
    },
    {
      path: "/tables/users/table",
      name: "Users",
      component: UsersTable,
    },
    {
      path: "/tables/plans/table",
      name: "Plans",
      component: PlansTable,
    },
    {
      path: "/tables/jobs/table",
      name: "Jobs",
      component: JobsTable,
    },
  ],
  component: null,
};

const tablesRoutes = {
  id: "Tables",
  path: "/tables",
  icon: <List />,
  children: [
    {
      path: "/workers/:id",
      name: "Edit Worker",
      component: EditWorker,
    },
    {
      path: "/users/:id",
      name: "Edit User",
      component: EditUser,
    },
    {
      path: "/plans/:id",
      name: "Edit Plan",
      component: EditPlan,
    },
    {
      path: "/jobs/:id",
      name: "Edit Job",
      component: EditJob,
    },
  ],
  component: null,
};

// Routes using the Dashboard layout
export const dashboardLayoutRoutes = [
  dashboardsRoutes,
  orderRoutes,
  formsRoutes,
  tablesRoutes,
];

// Routes visible in the sidebar
export const sidebarRoutes = [dashboardsRoutes, orderRoutes, formsRoutes];
