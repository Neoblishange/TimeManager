<script setup lang="ts">
import { onMounted, ref } from "vue";
import TeamsAPI from "../api/teams.api";
import HeaderVue from "../components/HeaderVue.vue";
import TeamAdd from "../components/TeamAdd.vue";
import TeamUpdate from "../components/TeamUpdate.vue";
import Team from "../types/Team";

const teams = ref<Team[]>([]);

onMounted(() => {
  loadData();
});

const loadData = () => {
  TeamsAPI.getAllTeams().then((res) => (teams.value = res.data));
};

const deleteTeam = (team: Team) => {
  TeamsAPI.deleteTeam(team.id).then(() => {
    loadData();
  });
};

const headers = ["Nom", "Manager"];
</script>

<template>
  <HeaderVue />

  <div class="mt-[150px] flex w-full justify-center flex-col items-center">
    <TeamAdd @on-create="loadData()" />
    <div>Les équipes</div>
    <div class="flex flex-col gap-2 min-w-[300px] w-1/2">
      <table
        class="w-full table-auto mt-10 border-separate border-spacing-x-2 border-spacing-y-5"
      >
        <thead>
          <tr>
            <td
              v-for="header in headers"
              class="text-center justify-center text-lg font-bold border border-slate-600"
            >
              {{ header }}
            </td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <template v-for="(team, index) in teams">
            <tr
              :class="
                'my-10 ' +
                (index % 2 === 0 ? ' bg-orange-100 ' : ' bg-blue-100 ')
              "
            >
              <td class="text-center py-2 px-10">
                {{ team.name }}
              </td>
              <td class="text-center py-2 px-10">
                {{ team.manager.username }}
              </td>
              <td class="text-center py-2 px-2 ">
                <TeamUpdate @on-create="loadData()" :id="team.id" />
                <button @click="deleteTeam(team)" class="hover:bg-red-400">
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
