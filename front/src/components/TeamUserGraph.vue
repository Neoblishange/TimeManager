<script setup lang="ts">
import { ref } from "vue";
import User from "../types/User";
import EmployeeGraph from "./EmployeeGraph.vue";

const props = defineProps<{
  user: User;
}>();

const modalOpen = ref(false);
const _user = { ...props.user };
</script>

<template>
  <div
    v-if="modalOpen"
    class="h-screen w-screen fixed top-0 left-0 flex items-center justify-center z-[2200]"
  >
    <div
      class="z-[2201] h-screen w-screen absolute top-0 left-0 bg-black opacity-60"
    ></div>
    <div class="z-[2210] min-w-[500px] max-w-full w-1/2 max-h-full h-3/4">
      <div
        class="bg-white p-10 flex justify-center items-center flex-col gap-6 rounded-lg relative border-4 border-[#fcb795] h-full w-full"
      >
        <div
          class="flex flex-col items-center gap-6 bg-white p-5 rounded-xl h-full w-full"
        >
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
            <EmployeeGraph state="first" :id-user="_user.id" />
          </div>
        </div>
      </div>
    </div>
  </div>

  <button @click="modalOpen = true">
    <svg
      xmlns="http://www.w3.org/2000/svg"
      class="icon icon-tabler icon-tabler-chart-histogram"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      stroke-width="2"
      stroke="currentColor"
      fill="none"
      stroke-linecap="round"
      stroke-linejoin="round"
    >
      <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
      <path d="M3 3v18h18"></path>
      <path d="M20 18v3"></path>
      <path d="M16 16v5"></path>
      <path d="M12 13v8"></path>
      <path d="M8 16v5"></path>
      <path d="M3 11c6 0 5 -5 9 -5s3 5 9 5"></path>
    </svg>
  </button>
</template>
