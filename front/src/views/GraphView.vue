<script setup lang="ts">
import { ref } from "vue";
import HeaderVue from "../components/HeaderVue.vue";

const state = ref("first");

const options = [
  { value: "first", label: "Graph1" },
  { value: "second", label: "Graph2" },
  { value: "third", label: "Graph3" },
];
</script>

<template>
  <HeaderVue />
  <div class="mt-[150px] flex justify-center">
    <div class="flex justify-center gap-5">
      <template v-for="option in options">
        <button
          @click="state = option.value"
          :class="
            (state === option.value
              ? ' bg-[#3b3fb8] text-white underline-offset-4 underline '
              : ' bg-white text-[#3b3fb8] ') + ' p-3 px-5 rounded-[30px] text-md shadow-lg  '
          "
        >
          {{ option.label }}
        </button>
      </template>
    </div>
  </div>
</template>
