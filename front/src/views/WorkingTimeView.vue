<template>
  <HeaderVue />
  <div class="mt-[150px] flex justify-center items-center flex-col gap-6">
    <div>Ajouter une plage horaire</div>
    <div class="w-full flex flex-row gap-2 max-w-[300px]">
      <vue-tailwind-datepicker
        v-model="dateValue"
        as-single
        use-range
        :shortcuts="false"
      />
      <button @click="addWorkingTimes()">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="icon icon-tabler icon-tabler-plus"
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
          <path d="M12 5l0 14"></path>
          <path d="M5 12l14 0"></path>
        </svg>
      </button>
    </div>
    <div>Temps de travail</div>
    <div class="flex flex-col gap-2 min-w-[300px]">
      <div v-for="(time, index) in workingTimes">
        <div :key="index">
          {{
            "pour le " +
            moment(time.start).format("dd/mm/YYYY - hh:mm:ss") +
            " jusqu'à " +
            moment(time.end).format("hh:mm:ss")
          }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import moment from "moment";
import { onMounted, ref } from "vue";
import VueTailwindDatepicker from "vue-tailwind-datepicker";
import WorkingTimesAPI from "../api/workingTimes.api";
import HeaderVue from "../components/HeaderVue.vue";
import WorkingTimes from "../types/WorkingTimes";

const dateValue = ref([]);
const workingTimes = ref<WorkingTimes[]>([]);

const loadData = () => {
  WorkingTimesAPI.getWorkingTimes().then(
    (res) => (workingTimes.value = res.data)
  );
};

const addWorkingTimes = () => {
  WorkingTimesAPI.create(
    new Date(dateValue.value[0]),
    new Date(dateValue.value[1])
  ).then(() => {
    loadData();
  });
};

onMounted(() => {
  loadData();
});
</script>
