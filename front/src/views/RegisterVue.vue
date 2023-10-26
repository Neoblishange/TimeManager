<script setup lang="ts">
import { ref } from "vue";
import UserAPI from "../api/user.api";
import HeaderVue from "../components/HeaderVue.vue";
import router from "../router";
import UserProvider from "../store/User";

const formStep = ref(0);
const MAX_STEP = ref(2);
const showPassword = ref(false);
const showConfirmation = ref(false);
const formData = ref({ email: "", username: "" });
const user = new UserProvider();

const prevStep = () => {
  if (formStep.value > 0) formStep.value--;
};

const nextStep = () => {
  if (formStep.value < MAX_STEP.value) formStep.value++;
};

const register = () => {
  UserAPI.createUser(formData.value.email, formData.value.username)
    .then((res) => {
      user.setEmail(res.data.email);
      user.setUsername(res.data.username);
      user.setID(res.data.id);
      user.setToken("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      user.setRoles(res.data.roles)
    })
    .then(() => router.push("/user"));
};
</script>

<template>
  <HeaderVue />

  <div class="h-full flex justify-center items-center">
    <div class="w-[500px]">
      <div class="bg-[#fcb795] rounded-2xl border-4 border-[#fcb795]">
        <div class="p-5 bg-[#fcb795] text-white">
          <h1 class="text-2xl">Bienvenue sur Time Master</h1>
          <h3>Créer votre compte</h3>
        </div>
        <div class="flex flex-col items-center gap-6 bg-white p-5 rounded-xl">
          <div
            v-if="formStep === 0"
            class="w-full flex flex-col items-center gap-6"
          >
            <span class="underline">Informations utilisateurs :</span>
            <div class="w-full">
              <label for="username" class="block mb-2 text-sm text-dark"
                >Nom d'utilisateur <span class="text-red-600">*</span></label
              >
              <input
                v-model="formData.username"
                type="text"
                id="username"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                required
              />
            </div>
            <div class="w-full flex flex-col">
              <label for="type"
                >Type de compte <span class="text-red-600">*</span></label
              >
              <div class="flex items-center ml-5">
                <input
                  checked
                  id="employee"
                  type="radio"
                  value=""
                  name="default-radio"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500"
                />
                <label for="employee" class="ml-2 text-gray-900">Employé</label>
              </div>
              <div class="flex items-center ml-5">
                <input
                  id="manager"
                  type="radio"
                  value=""
                  name="default-radio"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500"
                />
                <label for="manager" class="ml-2 text-gray-900">Manager</label>
              </div>
              <div class="flex items-center ml-5">
                <input
                  id="director"
                  type="radio"
                  value=""
                  name="default-radio"
                  class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500"
                />
                <label for="director" class="ml-2 text-gray-900"
                  >Directeur</label
                >
              </div>
            </div>
          </div>
          <div
            v-else-if="formStep === 1"
            class="w-full flex flex-col items-center"
          >
            <span class="underline">Informations confidentielles :</span>
            <div class="w-full">
              <label for="email" class="block mb-2 text-sm text-dark"
                >Email <span class="text-red-600">*</span></label
              >
              <input
                v-model="formData.email"
                type="text"
                id="email"
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

            <div class="w-full">
              <label for="password" class="block mb-2 text-sm text-dark"
                >Confirmation <span class="text-red-600">*</span></label
              >

              <div class="relative">
                <input
                  :type="showConfirmation ? 'text' : 'password'"
                  id="password"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                  required
                />
                <div class="absolute right-0 top-0 p-1.5">
                  <button @click="showConfirmation = !showConfirmation">
                    <svg
                      v-if="showConfirmation === false"
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
          </div>

          <div class="flex gap-2">
            <button
              v-if="formStep != 0"
              class="bg-[#fcb795] p-3 rounded-[30px] border-black text-white text-md shadow-2xl min-w-[150px]"
              @click="prevStep()"
              :disabled="formStep === 0"
            >
              Précédent
            </button>

            <button
              v-if="formStep < MAX_STEP - 1"
              class="bg-[#fcb795] p-3 rounded-[30px] border-black text-white text-md shadow-2xl min-w-[150px]"
              @click="nextStep()"
              :disabled="formStep >= MAX_STEP"
            >
              Suivant
            </button>

            <button
              v-if="formStep === MAX_STEP - 1"
              @click="register()"
              class="bg-[#fcb795] p-3 rounded-[30px] border-black text-white text-md shadow-2xl min-w-[150px]"
            >
              Connection
            </button>
          </div>
          <p>
            Déjà un compte ?
            <router-link class="underline text-[#fcb795] cursor-pointer" to="/">
              Se connecter !
            </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
