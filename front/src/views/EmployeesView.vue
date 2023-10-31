<script setup lang="ts">
import { onMounted, ref, watch } from "vue";
import TeamsAPI from "../api/teams.api";
import UserAPI from "../api/user.api";
import HeaderVue from "../components/HeaderVue.vue";
import TeamUpdate from "../components/TeamUpdate.vue";
import UserProvider from "../store/User";
import EUserRole from "../types/EUserRole";
import Team from "../types/Team";
import User from "../types/User";

const user = new UserProvider();

const team = ref<Team | undefined>();
const teamUser = ref<User[]>([]);
const teamName = ref("");
const employeeWithoutTeam = ref<User[]>([]);
const createTeam = () => {
  TeamsAPI.createTeam(teamName.value, user.getID()).then(() => {
    user.reload();
  });
};

onMounted(() => {
  loadData();
});

watch(team, () => {
  loadData();
});

const loadData = () => {
  UserAPI.getUserWithID(user.getID()).then(
    (res) => (team.value = res.data.team)
  );
  UserAPI.getAllEmployeeWithoutTeam().then(
    (res) => (employeeWithoutTeam.value = res.data)
  );
  if (team.value?.id) {
    TeamsAPI.teamUsers(team.value?.id ?? "").then(
      (res) => (teamUser.value = res.data)
    );
  }
};

const deleteUserFromTeam = (id: string) => {
  TeamsAPI.removeUserToTeam(id).then(() => {
    loadData();
  });
};

const tableHeaders = ["Username", "Email", "Rôle"];
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
        <div v-else>
          Votre équipe : {{ team.name }}

          <TeamUpdate :id="team.id" @on-create="loadData()" />

          <div class="w-full flex items-center justify-center">
            <table
              class="w-full table-auto mt-10 border-separate border-spacing-x-2 border-spacing-y-5"
            >
              <thead>
                <tr>
                  <td
                    v-for="header in tableHeaders"
                    class="text-center justify-center text-lg font-bold border border-slate-600"
                  >
                    {{ header }}
                  </td>
                  <td></td>
                </tr>
              </thead>
              <tbody>
                <template v-for="(_user, index) in teamUser">
                  <tr
                    :class="
                      'my-10 ' +
                      (index % 2 === 0 ? ' bg-orange-100 ' : ' bg-blue-100 ')
                    "
                  >
                    <td class="text-center py-2 px-10">
                      {{ _user.username }}
                    </td>
                    <td class="text-center py-2 px-10">
                      {{ _user.email }}
                    </td>
                    <td class="text-center py-2 px-10">
                      <div v-if="_user.roles.includes(EUserRole.DIRECTOR)">
                        Directeur
                      </div>
                      <div
                        v-else-if="_user.roles.includes(EUserRole.MANAGER)"
                        class="flex flex-row"
                      >
                        Manager
                      </div>
                      <div v-else class="flex flex-row">Employée</div>
                    </td>
                    <td>
                      <button
                        @click="deleteUserFromTeam(_user.id)"
                        v-if="_user.id !== user.getID()"
                      >
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
                          <path
                            stroke="none"
                            d="M0 0h24v24H0z"
                            fill="none"
                          ></path>
                          <path d="M4 7l16 0"></path>
                          <path d="M10 11l0 6"></path>
                          <path d="M14 11l0 6"></path>
                          <path
                            d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12"
                          ></path>
                          <path
                            d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3"
                          ></path>
                        </svg>
                      </button>
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
