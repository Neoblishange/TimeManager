<script setup lang="ts">
import { ref } from "vue";
import UserAPI from "../api/user.api";
import HeaderVue from "../components/HeaderVue.vue";
import router from "../router";
import UserProvider from "../store/User";

const user = new UserProvider();

console.log("user",user.getID());

const userData = ref({
  email: "",
  username: "",
});

const deleteAccount = () =>
  UserAPI.deleteUser().then(() => {
    user.disconnect();
    router.push("/");
  });

const saveAccount = () => UserAPI.updateUser(userData.value.email, userData.value.username);
</script>

<template>
  <HeaderVue />
  <div class="mt-[150px] flex justify-center items-center flex-col gap-6">
    <div>Modifier ses informations</div>
    <div class="flex flex-col gap-2 min-w-[300px]">
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

      <button
        class="bg-[#3b3fb8] p-3 rounded-[30px] border-black text-white text-md shadow-2xl"
        @click="saveAccount()"
      >
        Sauvegarder
      </button>
    </div>

    <button
      class="mt-20 bg-white p-3 rounded-[30px] border-red-500 border-2 text-red-500 text-md shadow-2xl"
      @click="deleteAccount()"
    >
      Supprimer son compte
    </button>
  </div>
</template>
