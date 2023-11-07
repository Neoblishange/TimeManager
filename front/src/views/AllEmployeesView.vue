<script setup lang="ts">
import { onMounted, ref } from "vue";
import UserAPI from "../api/user.api";
import EmployeeAdd from "../components/EmployeeAdd.vue";
import HeaderVue from "../components/HeaderVue.vue";
import TeamUserGraph from "../components/TeamUserGraph.vue";
import UserProvider from "../store/User";
import EUserRole from "../types/EUserRole";
import User from "../types/User";

const users = ref<User[]>([]);

const user = new UserProvider();

const loadData = () => {
  UserAPI.getAllUsers().then((res) => (users.value = res.data));
};

onMounted(() => {
  loadData();
});

const deleteUser = (id: string) => {
  UserAPI.deleteUser(id).then(() => loadData());
};

const makeManager = (id: string) =>
  UserAPI.setManagerUser(id).then(() => loadData());
const makeEmployee = (id: string) =>
  UserAPI.setEmployeeUser(id).then(() => loadData());

const tableHeaders = ["Username", "Email", "Équipe", "Rôle"];
</script>

<template>
  <HeaderVue />

  <div class="mt-[150px] flex justify-center flex-col items-center">
    <div class="flex max-w-[300px] w-full justify-center flex-col items-center">
      <EmployeeAdd @on-create="loadData()" />
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
            <template v-for="(_user, index) in users">
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
                  {{ _user.team?.name ?? "Pas équipe" }}
                </td>
                <td class="text-center py-2 px-10">
                  <div v-if="_user.roles.includes(EUserRole.DIRECTOR)">
                    Directeur
                  </div>
                  <div
                    v-else-if="_user.roles.includes(EUserRole.MANAGER)"
                    class="flex flex-row"
                  >
                    <button @click="makeEmployee(_user.id)">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="icon icon-tabler icon-tabler-arrow-badge-down"
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
                        <path d="M17 13v-6l-5 4l-5 -4v6l5 4z"></path>
                      </svg>
                    </button>
                    Manager
                  </div>
                  <div v-else class="flex flex-row">
                    <button @click="makeManager(_user.id)">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="icon icon-tabler icon-tabler-arrow-badge-up-filled"
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
                        <path
                          d="M11.375 6.22l-5 4a1 1 0 0 0 -.375 .78v6l.006 .112a1 1 0 0 0 1.619 .669l4.375 -3.501l4.375 3.5a1 1 0 0 0 1.625 -.78v-6a1 1 0 0 0 -.375 -.78l-5 -4a1 1 0 0 0 -1.25 0z"
                          stroke-width="0"
                          fill="currentColor"
                        ></path>
                      </svg>
                    </button>
                    Employée
                  </div>
                </td>
                <td class="text-center py-2 px-2 hover:bg-red-400">
                  
                  <TeamUserGraph :user="_user" />
                  <button
                    @click="deleteUser(_user.id)"
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
  </div>
</template>
