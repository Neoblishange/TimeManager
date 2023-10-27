<script setup lang="ts">
export interface LineGraphData {
  labels: string[];
  data: {
    label: string;
    values: number[];
  };
}

import {
CategoryScale,
Chart as ChartJS,
Filler,
Legend,
LineElement,
LinearScale,
PointElement,
RadialLinearScale,
Title,
Tooltip,
} from "chart.js";
import { computed } from "vue";

import { Line } from "vue-chartjs";

const props = defineProps<{
  data: LineGraphData;
}>();

ChartJS.register(
  RadialLinearScale,
  Filler,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

const chartDataFirst = computed(() => ({
  labels: props.data.labels,
  datasets: [
    {
      label: props.data.data.label,
      backgroundColor: ["#FCB795", "#3B3FB8"],
      data: props.data.data.values,
    },
  ],
}));
</script>

<template>
  <Line
    id="first"
    :options="{
      responsive: true,
    }"
    :data="chartDataFirst"
  />
</template>
