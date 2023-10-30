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

const formatTime = (secondes: number): string => {
  const hours = Math.floor(secondes / 3600);
  const minutes = Math.floor((secondes % 3600) / 60);
  const secs = secondes % 60;

  const hoursStr = hours.toString().padStart(2, "0");
  const minutesStr = minutes.toString().padStart(2, "0");
  const secsStr = secs.toString().padStart(2, "0");

  return `${hoursStr}:${minutesStr}:${secsStr}`;
};

const chartOptions = computed(() => {
  return {
    responsive: true,
    plugins: {
      legend: {
        display: true,
      },
      tooltip: {
        callbacks: {
          label: (context: any) => {
            if (context.parsed.y !== null) {
              return formatTime(context.parsed.y);
            }
            return "";
          },
        },
      },
    },
  };
});
</script>

<template>
  <Line id="first" :options="chartOptions" :data="chartDataFirst" />
</template>
