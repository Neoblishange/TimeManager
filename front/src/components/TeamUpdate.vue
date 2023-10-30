<script setup lang="ts">
import { onMounted, ref, watch } from "vue";
import TeamsAPI from "../api/teams.api";
import UserAPI from "../api/user.api";
import User from "../types/User";

const emits = defineEmits<{
  onCreate: [];
}>();

const props = defineProps<{
  id: string;
}>();

const modalOpen = ref(false);
const formData = ref({ name: "", id: "" });
const employeeID = ref<string>("");

const teamUsers = ref<User[]>([]);
const employees = ref<User[]>([]);

const updateTeam = () => {
  TeamsAPI.changeTeamName(formData.value.name, formData.value.id).then(() => {
    formData.value = { name: "", id: "" };
    modalOpen.value = false;
    emits("onCreate");
  });
};

const loadData = () => {
  TeamsAPI.getTeamWithID(props.id).then((res) => {
    formData.value.name = res.data.name;
    formData.value.id = res.data.id;
  });
  TeamsAPI.teamUsers(props.id).then((res) => (teamUsers.value = res.data));
  UserAPI.getAllEmployee().then((res) => (employees.value = res.data));
};

onMounted(() => {
  loadData();
});

watch(employeeID, () => {
  if (employeeID.value.length > 5) {
    TeamsAPI.addUserToTeam(employeeID.value, props.id).then(() => {
      loadData();
      employeeID.value = "";
    });
  }
});
</script>

<template>
  <button @click="modalOpen = true">
    <svg
      xmlns="http://www.w3.org/2000/svg"
      class="icon icon-tabler icon-tabler-edit"
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
        d="M7 7h-1a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-1"
      ></path>
      <path
        d="M20.385 6.585a2.1 2.1 0 0 0 -2.97 -2.97l-8.415 8.385v3h3l8.385 -8.415z"
      ></path>
      <path d="M16 5l3 3"></path>
    </svg>
  </button>
  <div
    v-if="modalOpen"
    class="h-screen w-screen fixed top-0 left-0 flex items-center justify-center z-[2200]"
  >
    <div
      class="z-[2201] h-screen w-screen absolute top-0 left-0 bg-black opacity-60"
    ></div>
    <div class="z-[2210]">
      <div
        class="bg-white p-10 flex justify-center items-center flex-col gap-6 rounded-lg relative border-4 border-[#fcb795]"
      >
        <div class="flex flex-col items-center gap-6 bg-white p-5 rounded-xl">
          <div class="absolute top-5 right-5">
            <button @click="modalOpen = false">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="icon icon-tabler icon-tabler-x"
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
                <path d="M18 6l-12 12"></path>
                <path d="M6 6l12 12"></path>
              </svg>
            </button>
          </div>

          <div class="w-full flex flex-col items-center gap-6">
            <div class="w-full">
              Employées dans cette équipe

              <div class="w-full">
                <label for="employees" class="block mb-2 text-sm text-dark"
                  >Employé à ajouter</label
                >
                <select
                  v-model="employeeID"
                  id="employees"
                  class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                >
                  <option v-for="employee in employees" :value="employee.id">
                    {{ employee.username }}
                  </option>
                </select>
              </div>
              <div v-if="teamUsers.length === 0">
                Il n'y a pas d'utilisateurs dans cette équipe
              </div>
              <div v-for="user in teamUsers" class="flex flex-row">
                <button>
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
                {{ user.username }}
              </div>
            </div>
            <div class="w-full">
              <label for="name" class="block mb-2 text-sm text-dark"
                >Nom de l'équipe <span class="text-red-600">*</span></label
              >
              <input
                v-model="formData.name"
                type="text"
                id="name"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
                required
              />
            </div>
          </div>
          <button
            class="bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
            @click="updateTeam()"
          >
            Modifier l'équipe
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
