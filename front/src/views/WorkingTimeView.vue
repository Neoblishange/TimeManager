<template>
  <HeaderVue />
  <div class="mt-[150px] flex justify-center items-center flex-col gap-6">
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
import WorkingTimesAPI from "../api/workingTimes.api";
import HeaderVue from "../components/HeaderVue.vue";
import WorkingTimes from "../types/WorkingTimes";

const workingTimes = ref<WorkingTimes[]>([]);

onMounted(() => {
  WorkingTimesAPI.list().then((res) => (workingTimes.value = res.data));
});
</script>
