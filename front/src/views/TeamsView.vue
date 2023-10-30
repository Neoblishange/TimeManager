<script setup lang="ts">
import { onMounted, ref } from "vue";
import teamsAPI from "../api/teams.api";
import HeaderVue from "../components/HeaderVue.vue";
import TeamAdd from "../components/TeamAdd.vue";
import TeamUpdate from "../components/TeamUpdate.vue";
import Team from "../types/Team";

const teams = ref<Team[]>([]);

onMounted(() => {
  loadData();
});

const loadData = () => {
  teamsAPI.getAllTeams().then((res) => (teams.value = res.data));
};

const deleteTeam = (team: Team) => {
  teamsAPI.deleteTeam(team.id).then(() => {
    loadData();
  });
};
</script>

<template>
  <HeaderVue />

  <div class="mt-[150px] flex w-full justify-center flex-col items-center">
    <TeamAdd @on-create="loadData()" />
    <div>Les équipes</div>
    <div class="flex flex-col gap-2 min-w-[300px] w-1/2">
      <table class="w-full">
        <thead>
          <tr>
            <td>
              <div class="w-full flex flex-row items-center justify-center">
                Nom
              </div>
            </td>
            <td>
              <div class="w-full flex flex-row items-center justify-center">
                Manager
              </div>
            </td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <template v-for="team in teams">
            <tr>
              <td>
                {{ team.name }}
              </td>
              <td>
                {{ team.manager.username }}
              </td>
              <td>
                <TeamUpdate @on-create="loadData()" :id="team.id" />
                <button @click="deleteTeam(team)">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="icon icon-tabler icon-tabler-trash"
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
                    <path d="M4 7l16 0"></path>
                    <path d="M10 11l0 6"></path>
                    <path d="M14 11l0 6"></path>
                    <path
                      d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12"
                    ></path>
                    <path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3"></path>
                  </svg>
                </button>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>
  </div>
</template>
