import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import RegisterVue from "../views/RegisterVue.vue";
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
];

const router = createRouter({
  history: createWebHistory(""),
  routes,
});

export default router;
