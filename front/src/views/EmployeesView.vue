<script setup lang="ts">
import { ref } from "vue";
import TeamsAPI from "../api/teams.api";
import HeaderVue from "../components/HeaderVue.vue";
import UserProvider from "../store/User";
import Team from "../types/Team";

const user = new UserProvider();

const team = ref<Team | undefined>(user.getTeam());
const teamName = ref("");

const createTeam = () => {
  TeamsAPI.createTeam(teamName.value, user.getID()).then(() => {
    user.reload();
  });
};
</script>

<template>
  <HeaderVue />

  <div class="mt-[150px] flex justify-center flex-col items-center">
    <div class="flex max-w-[300px] w-full justify-center flex-col">
      <div class="w-full">
        <div
          v-if="team === undefined"
          class="w-full flex flex-col items-center justify-center"
        >
          Vous n'avez pas encore d'équipe
          <div class="w-full my-10">
            <label for="name" class="block mb-2 text-sm text-dark"
              >Nom d'équipe <span class="text-red-600">*</span></label
            >
            <input
              v-model="teamName"
              type="text"
              id="name"
              class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
              required
            />
          </div>
          <button
            @click="createTeam"
            class="bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
          >
            Créer une équipe
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
