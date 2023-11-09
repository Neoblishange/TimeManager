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
  <template v-if="isAuth">
    <router-link v-if="user.isDirector()" to="/teams">
      <button
        :disabled="user.isOffline()"
        class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
      >
        Voir les équipes
      </button>
    </router-link>
    <router-link v-if="user.isDirector()" to="/allEmployees">
      <button
        :disabled="user.isOffline()"
        class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
      >
        Voir tout les employés
      </button>
    </router-link>
    <router-link v-if="user.isManager() && !user.isDirector()" to="/employees">
      <button
        :disabled="user.isOffline()"
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
        :disabled="user.isOffline()"
        class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
      >
        Graphiques
      </button>
    </router-link>

    <router-link to="/user">
      <button
        :disabled="user.isOffline()"
        class="w-[50px] h-[50px] rounded-full bg-red-600 text-lg"
      >
        {{ user.getUsername().charAt(0).toUpperCase() }}
      </button>
    </router-link>
    <button
      @click="disconnect()"
      class="bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
    >
      Déconnection
    </button>
  </template>
  <template v-else>
    <router-link to="/register">
      <button
        :disabled="user.isOffline()"
        class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-lg"
      >
        Créer un compte
      </button>
    </router-link>
    <router-link to="/">
      <button
        :disabled="user.isOffline()"
        class="bg-[#3b3fb8] p-3 rounded-[30px] border-black text-white text-md shadow-lg"
      >
        Connection
      </button>
    </router-link>
  </template>
</template>
