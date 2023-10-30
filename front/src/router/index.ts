import { createRouter, createWebHistory } from "vue-router";
import AllEmployeesView from "../views/AllEmployeesView.vue";
import EmployeesView from "../views/EmployeesView.vue";
import GraphView from "../views/GraphView.vue";
import HomeView from "../views/HomeView.vue";
import RegisterVue from "../views/RegisterVue.vue";
import TeamsView from "../views/TeamsView.vue";
import UserHome from "../views/UserHome.vue";
import WorkingTimeView from "../views/WorkingTimeView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: HomeView,
  },
  {
    path: "/register",
    name: "register",
    component: RegisterVue,
  },
  { path: "/user", name: "user", component: UserHome },
  {
    path: "/workingTimes/:userID",
    name: "workingTimes",
    component: WorkingTimeView,
  },
  {
    path: "/chartManager/:userID",
    name: "graph",
    component: GraphView,
  },
  {
    path: "/employees",
    name: "employees",
    component: EmployeesView,
  },
  {
    path: "/allEmployees",
    name: "allEmployees",
    component: AllEmployeesView,
  },
  {
    path: "/teams",
    name: "teams",
    component: TeamsView,
  },
];

const router = createRouter({
  history: createWebHistory(""),
  routes,
});

export default router;
