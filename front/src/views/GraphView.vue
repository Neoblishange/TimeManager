<script setup lang="ts">
import { ref } from "vue";
import EmployeeGraph from "../components/EmployeeGraph.vue";
import HeaderVue from "../components/HeaderVue.vue";
import UserProvider from "../store/User";

const user = new UserProvider();

const state = ref("first");

const options = [{ value: "first", label: "Évolution des heures" }];

if (user.isManager() || user.isDirector())
  options.push(
    ...[
      { value: "second", label: "Heures par jours" },
      { value: "third", label: "Graph3" },
    ]
  );
</script>

<template>
  <HeaderVue />
  <div class="mt-[150px] flex justify-center flex-col items-center">
    <div class="flex justify-center gap-5">
      <template v-for="option in options">
        <button
          @click="state = option.value"
          :class="
            (state === option.value
              ? ' bg-[#3b3fb8] text-white underline-offset-4 underline '
              : ' bg-white text-[#3b3fb8] ') +
            ' p-3 px-5 rounded-[30px] text-md shadow-lg  '
          "
        >
          {{ option.label }}
        </button>
      </template>
    </div>
    <div class="w-full max-w-[600px] h-full max-h-[300px] mt-10">
      <EmployeeGraph :state="state" />
    </div>
  </div>
</template>
