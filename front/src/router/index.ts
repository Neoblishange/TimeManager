import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import RegisterVue from "../views/RegisterVue.vue";
import UserHome from "../views/UserHome.vue";

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
];

const router = createRouter({
  history: createWebHistory(""),
  routes,
});

export default router;
