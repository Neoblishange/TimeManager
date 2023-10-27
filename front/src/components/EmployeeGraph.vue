<script setup lang="ts">
import moment from "moment";
import { onMounted, ref } from "vue";
import WorkingTimesAPI from "../api/workingTimes.api";
import LineGraph, { LineGraphData } from "../components/graph/LineGraph.vue";
import WorkingTime from "../types/WorkingTimes";

const props = defineProps<{
  state: string;
}>();

const workingTimesData = ref<LineGraphData>({
  labels: [
    moment().format("DD/MM"),
    moment().subtract(1, "d").format("DD/MM"),
    moment().subtract(2, "d").format("DD/MM"),
    moment().subtract(3, "d").format("DD/MM"),
  ],
  data: {
    label: "Heures",
    values: [0, 0, 0, 0],
  },
});

const summarizeWorkingTime = (times: WorkingTime[]) => {
  let sum = 0;

  for (const time of times) {
    sum += Math.abs(moment(time.start).diff(moment(time.end), "minutes"));
  }

  return Math.round(sum / 60);
};

const loadData = () => {
  WorkingTimesAPI.getWorkingTimesWithParams(
    moment().subtract(3, "days").toDate(),
    moment().toDate()
  )
    .then((res) => {
      const daysRaw = res.data;
      const timesPerDays = [
        daysRaw.filter((d) => moment(d.start).isSame(moment(), "day")),
        daysRaw.filter((d) =>
          moment(d.start).isSame(moment().subtract(1, "day"), "day")
        ),
        daysRaw.filter((d) =>
          moment(d.start).isSame(moment().subtract(2, "day"), "day")
        ),
        daysRaw.filter((d) =>
          moment(d.start).isSame(moment().subtract(3, "day"), "day")
        ),
      ];
      return timesPerDays;
    })
    .then((times) => [
      summarizeWorkingTime(times[0]),
      summarizeWorkingTime(times[1]),
      summarizeWorkingTime(times[2]),
      summarizeWorkingTime(times[3]),
    ])
    .then((times) => {
      workingTimesData.value = {
        ...workingTimesData.value,
        data: { values: times, label: workingTimesData.value.data.label },
      };
    });
};

onMounted(() => loadData());
</script>

<template>
  <LineGraph v-if="props.state === 'first'" :data="workingTimesData" />
</template>
