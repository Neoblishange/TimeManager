<script setup lang="ts">
import router from "../router";
import UserProvider from "../store/User";

const user = new UserProvider();
const isAuth = user.isAuth();

const disconnect = () => {
  user.disconnect();
  router.push("/");
};
</script>

<template>
  <div
    class="fixed top-0 w-full bg-[#fcb795] h-[100px] p-5 border-b-2 border-gray-200 flex items-center justify-between z-[2000]"
  >
    <router-link :to="user.isAuth() ? '/user' : '/'">
      <p class="text-[#3b3fb8] text-2xl font-extrabold">Time Master</p>
    </router-link>
    <div v-if="isAuth" class="flex items-center gap-3">
      <router-link v-if="user.isDirector()" to="/teams">
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
        >
          Voir les équipes
        </button>
      </router-link>
      <router-link v-if="user.isDirector()" to="/allEmployees">
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
        >
          Voir tout les employés
        </button>
      </router-link>
      <router-link
        v-if="user.isManager() && !user.isDirector()"
        to="/employees"
      >
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
        >
          Voir les employés
        </button>
      </router-link>

      <router-link :to="'/workingTimes/' + user.getID()">
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
        >
          Temps de travail
        </button>
      </router-link>

      <router-link :to="'/chartManager/' + user.getID()">
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
        >
          Graphiques
        </button>
      </router-link>

      <router-link to="/user">
        <button class="w-[50px] h-[50px] rounded-full bg-red-600 text-lg">
          {{ user.getUsername().charAt(0).toUpperCase() }}
        </button>
      </router-link>
      <button
        @click="disconnect()"
        class="bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
      >
        Déconnection
      </button>
    </div>
    <div v-else class="flex items-center gap-3">
      <router-link to="/register">
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
        >
          Créer un compte
        </button>
      </router-link>
      <router-link to="/">
        <button
          class="bg-[#3b3fb8] p-3 rounded-[30px] border-black text-white text-md shadow-lg"
        >
          Connection
        </button>
      </router-link>
    </div>
  </div>
</template>
