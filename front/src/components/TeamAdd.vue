<script setup lang="ts">
import { onMounted, ref } from "vue";
import teamsAPI from "../api/teams.api";
import UserAPI from "../api/user.api";
import User from "../types/User";

const emits = defineEmits<{
  onCreate: [];
}>();

const modalOpen = ref(false);
const formData = ref({ name: "", managerID: "" });

const addTeam = () => {
  teamsAPI
    .createTeam(formData.value.name, formData.value.managerID)
    .then(() => {
      formData.value = { name: "", managerID: "" };
      modalOpen.value = false;
      emits("onCreate");
    });
};

const managers = ref<User[]>([]);

const loadData = () => {
  UserAPI.getAllManagers().then((res) => {
    managers.value = res.data;
  });
};

onMounted(() => {
  loadData();
});
</script>

<template>
  <button
    @click="modalOpen = true"
    class="bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
  >
    Ajouter une équipe
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
            <div class="w-full">
              <label
                for="managers"
                class="block mb-2 text-sm font-medium text-gray-900 dark:text-white"
                >Manager d'équipe</label
              >
              <select
                v-model="formData.managerID"
                id="managers"
                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
              >
                <option v-for="manager in managers" :value="manager.id">
                  {{ manager.username }}
                </option>
              </select>
            </div>
          </div>
          <button
            class="bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
            @click="addTeam()"
          >
            Ajouter l'équipe
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
