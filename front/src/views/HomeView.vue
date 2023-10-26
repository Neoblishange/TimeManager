<script setup lang="ts">
import { ref } from "vue";
import UserAPI from "../api/user.api";
import HeaderVue from "../components/HeaderVue.vue";
import router from "../router";
import UserProvider from "../store/User.ts";

const user = new UserProvider();
const userData = ref({
  email: "",
  username: "",
});

const showPassword = ref(false);

const login = () => {
  UserAPI.getUserWithParams(userData.value.email, userData.value.username)
    .then((res) => {
      user.setID(res.data.id);
      user.setEmail(res.data.email);
      user.setUsername(res.data.username);
      user.setToken("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      user.setRoles(res.data.roles);
    })
    .then(() => {
      router.push("/user");
    });
};
</script>

<template>
  <HeaderVue />
  <div class="h-full flex justify-center items-center">
    <div class="w-[500px]">
      <div class="bg-[#fcb795] rounded-2xl border-4 border-[#fcb795]">
        <div class="p-5 bg-[#fcb795] text-white">
          <h1 class="text-2xl">Bienvenue sur Time Master</h1>
          <h3>Connectez-vous</h3>
        </div>
        <div class="flex flex-col items-center gap-6 bg-white p-5 rounded-xl">
          <div class="w-full">
            <label for="email" class="block mb-2 text-sm text-dark"
              >Email <span class="text-red-600">*</span></label
            >
            <input
              v-model="userData.email"
              type="text"
              id="email"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
              required
            />
          </div>
          <div class="w-full">
            <label for="username" class="block mb-2 text-sm text-dark"
              >Nom d'utilisateur <span class="text-red-600">*</span></label
            >
            <input
              v-model="userData.username"
              type="text"
              id="username"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
              required
            />
          </div>

          <div class="w-full">
            <label for="password" class="block mb-2 text-sm text-dark"
              >Mot de passe <span class="text-red-600">*</span></label
            >

            <div class="relative">
              <input
                :type="showPassword ? 'text' : 'password'"
                id="password"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                required
              />
              <div class="absolute right-0 top-0 p-1.5">
                <button @click="showPassword = !showPassword">
                  <svg
                    v-if="showPassword === false"
                    xmlns="http://www.w3.org/2000/svg"
                    class="icon icon-tabler icon-tabler-eye-closed"
                    width="32"
                    height="32"
                    viewBox="0 0 24 24"
                    stroke-width="1.5"
                    stroke="currentColor"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path
                      d="M21 9c-2.4 2.667 -5.4 4 -9 4c-3.6 0 -6.6 -1.333 -9 -4"
                    ></path>
                    <path d="M3 15l2.5 -3.8"></path>
                    <path d="M21 14.976l-2.492 -3.776"></path>
                    <path d="M9 17l.5 -4"></path>
                    <path d="M15 17l-.5 -4"></path>
                  </svg>
                  <svg
                    v-else
                    xmlns="http://www.w3.org/2000/svg"
                    class="icon icon-tabler icon-tabler-eye"
                    width="32"
                    height="32"
                    viewBox="0 0 24 24"
                    stroke-width="1.5"
                    stroke="currentColor"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                    <path d="M10 12a2 2 0 1 0 4 0a2 2 0 0 0 -4 0"></path>
                    <path
                      d="M21 12c-2.4 4 -5.4 6 -9 6c-3.6 0 -6.6 -2 -9 -6c2.4 -4 5.4 -6 9 -6c3.6 0 6.6 2 9 6"
                    ></path>
                  </svg>
                </button>
              </div>
            </div>
          </div>
          <button
            @click="login()"
            class="bg-[#fcb795] p-3 rounded-[30px] border-black text-white text-md shadow-2xl min-w-[150px]"
          >
            Connection
          </button>
          <p>
            Pas encore de compte ?
            <router-link
              class="underline text-[#fcb795] cursor-pointer"
              to="/register"
            >
              Le créer !
            </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
