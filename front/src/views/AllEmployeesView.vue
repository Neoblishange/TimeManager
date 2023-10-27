<script setup lang="ts">
import EmployeeAdd from "../components/EmployeeAdd.vue";
import HeaderVue from "../components/HeaderVue.vue";
</script>

<template>
  <HeaderVue />
  

  <div class="mt-[150px] flex justify-center flex-col items-center">
    <div class="flex max-w-[300px] w-full justify-center flex-col">
      <EmployeeAdd />
      </div>
  </div>
</template>
