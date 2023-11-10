import { createRouter, createWebHistory } from "vue-router";
import UserProvider from "../store/User";
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
    needAuth: false,
  },
  {
    path: "/register",
    name: "register",
    component: RegisterVue,
    needAuth: false,
  },
  { path: "/user", name: "user", component: UserHome, needAuth: true },
  {
    path: "/workingTimes/:userID",
    name: "workingTimes",
    component: WorkingTimeView,
    needAuth: true,
  },
  {
    path: "/chartManager/:userID",
    name: "graph",
    component: GraphView,
    needAuth: true,
  },
  {
    path: "/employees",
    name: "employees",
    component: EmployeesView,
    needAuth: true,
  },
  {
    path: "/allEmployees",
    name: "allEmployees",
    component: AllEmployeesView,
    needAuth: true,
  },
  {
    path: "/teams",
    name: "teams",
    component: TeamsView,
    needAuth: true,
  },
  {
    path: "/:pathMatch(.*)*",
    name: "others",
    redirect: { name: "home" },
  },
];

const router = createRouter({
  history: createWebHistory(""),
  routes,
});

router.beforeEach((to, from, next) => {
  const current = routes.find((r) => r.name === to.name) ?? routes[0];
  const user = new UserProvider();

  if (current.needAuth !== user.isAuth()) {
    if (user.isAuth()) next("/user");
    else {
      localStorage.clear();
      next("/login");
    }
  } else {
    next();
  }
});

export default router;
