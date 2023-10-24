<template>
  <div
    class="fixed top-0 w-full bg-[#fcb795] h-[100px] p-5 border-b-2 border-gray-200 flex items-center justify-between"
  >

  <router-link to="/">
    <p class="text-[#3b3fb8] text-2xl font-extrabold">Time Master</p>
  </router-link>
    <div class="flex gap-3">
      <router-link to="/register">
        <button
          class="bg-white p-3 rounded-[30px] border-[#3b3fb8] text-[#3b3fb8] text-md shadow-2xl"
        >
          Créer un compte
        </button>
      </router-link>
      <router-link to="/">
        <button
          class="bg-[#3b3fb8] p-3 rounded-[30px] border-black text-white text-md shadow-2xl"
        >
          Connection
        </button>
      </router-link>
    </div>
  </div>
</template>

<script setup>
import UserProvider from '@/store/User.ts';


const user = new UserProvider()

console.log("user",user);

</script>
