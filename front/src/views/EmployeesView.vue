<script setup lang="ts">
import HeaderVue from "../components/HeaderVue.vue";
</script>

<template>
  <HeaderVue />

  <div class="mt-[150px] flex justify-center flex-col items-center">
    <div class="flex max-w-[300px] w-full justify-center flex-col">
      <div class="w-full">
        <label for="username" class="block mb-2 text-sm text-dark"
          >Nom d'utilisateur <span class="text-red-600">*</span></label
        >
        <input
          type="text"
          id="username"
          class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
          required
        />
      </div>
    </div>
  </div>
</template>
