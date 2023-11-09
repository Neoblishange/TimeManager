import "@vuepic/vue-datepicker/dist/main.css";
import axios from "axios";
import { createApp } from "vue";
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";
import App from "./App.vue";
import "./index.css";
import router from "./router";

const instance = axios.create();

instance.interceptors.request.use((config) => {
  console.log("axios default action ?");

  return config;
});

const app = createApp(App);

app.use(Toast, {});
app.use(router).mount("#app");
