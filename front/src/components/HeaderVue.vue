<script setup lang="ts">
import { ref } from "vue";
import UserProvider from "../store/User";
import HeaderItemsVue from "./HeaderItemsVue.vue";

const isBurgerOpen = ref(false);
const user = new UserProvider();
</script>

<template>
  <div
    class="fixed top-0 w-full bg-[#fcb795] h-[100px] p-5 border-b-2 border-gray-200 flex items-center justify-between z-[2000]"
  >
    <router-link :to="user.isAuth() ? '/user' : '/'">
      <p class="text-[#3b3fb8] text-2xl font-extrabold">Time Master</p>
    </router-link>
    <div class="md:flex hidden items-center gap-3 flex-row">
      <header-items-vue />
    </div>
    <div class="flex md:hidden">
      <button @click="isBurgerOpen = true">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="text-[#fff] icon icon-tabler icon-tabler-menu-2"
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
          <path d="M4 6l16 0"></path>
          <path d="M4 12l16 0"></path>
          <path d="M4 18l16 0"></path>
        </svg>
      </button>
    </div>
    <div
      v-if="isBurgerOpen"
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
              <button @click="isBurgerOpen = false">
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
            <div class="flex items-center gap-3 flex-col">
              <header-items-vue />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
