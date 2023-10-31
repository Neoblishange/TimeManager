<script setup lang="ts">
import VueDatePicker from "@vuepic/vue-datepicker";
import { DateTime } from "luxon";
import moment from "moment";
import { onMounted, ref, watch } from "vue";
import WorkingTimesAPI from "../api/workingTimes.api";
import LineGraph, { LineGraphData } from "../components/graph/LineGraph.vue";

const props = defineProps<{
  state: string;
}>();

const dateValue = ref<Date[]>([
  moment().subtract(3, "days").toDate(),
  moment().toDate(),
]);

const daysBetween = (start: DateTime, end: DateTime): DateTime[] => {
  const dayNumber = moment(end.toJSDate()).diff(start.toJSDate(), "days") + 1;
  const dates = [];

  for (let i = 0; i < dayNumber; i++)
    dates.push(
      DateTime.fromJSDate(moment(start.toJSDate()).add(i, "d").toDate())
    );

  return dates;
};

const labels = ref<string[]>([]);
const hours = ref<number[]>([]);

const workingTimesData = ref<LineGraphData>({
  labels: ["1", "2", "3", "4"],
  data: {
    label: "secondes",
    values: [0, 0, 0, 0],
  },
});

const loadData = () => {
  WorkingTimesAPI.getWorkingTimesWithParams(
    moment(dateValue.value[0]).toDate(),
    moment(dateValue.value[1]).toDate()
  ).then((res) => {
    const dataset = new Map<string, number>();

    labels.value = [];
    hours.value = [];

    if (res.data.length === 0) return;

    res.data.forEach((schedule) => {
      const start = DateTime.fromISO(schedule.start as any);
      const end = DateTime.fromISO(schedule.end as any);
      const id = start.toFormat("DDD");

      const diff = end.diff(start, "seconds").get("seconds");
      const prevDuration = dataset.get(id);

      if (prevDuration) {
        dataset.set(id, prevDuration + diff);
      } else {
        dataset.set(id, diff);
      }
    });

    const start = DateTime.fromJSDate(dateValue.value[0]);
    const end = DateTime.fromJSDate(dateValue.value[1]);
    const days = daysBetween(start, end);

    for (const datetime of days) {
      const id = datetime.toFormat("DDD");
      const data = dataset.get(id);

      labels.value.push(id);
      hours.value.push(data || 0);
    }
  });
};

onMounted(() => loadData());

watch(dateValue.value, () => {
  loadData();
});

watch(labels, () => {
  workingTimesData.value = { ...workingTimesData.value, labels: labels.value };
});
watch(hours, () => {
  workingTimesData.value = {
    ...workingTimesData.value,
    data: { ...workingTimesData.value.data, values: hours.value },
  };
});
</script>

<template>
  <div class="w-full flex items-center justify-center flex-col">
    <div>
      <VueDatePicker v-model="dateValue[0]">
        <template #action-row="{ internalModelValue, selectDate }">
          <div class="action-row flex flex-col justify-center w-full">
            <p class="current-selection text-center">
              {{ moment(internalModelValue).format("DD-MM-YYYY HH:mm") }}
            </p>
            <button
              @click="selectDate"
              class="select-button bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
            >
              Valider
            </button>
          </div>
        </template>
      </VueDatePicker>
      <VueDatePicker v-model="dateValue[1]">
        <template #action-row="{ internalModelValue, selectDate }">
          <div class="action-row flex flex-col justify-center w-full">
            <p class="current-selection text-center">
              {{ moment(internalModelValue).format("DD-MM-YYYY HH:mm") }}
            </p>
            <button
              @click="selectDate"
              class="select-button bg-[#3b3fb8] p-3 rounded-[30px] text-white text-md shadow-lg"
            >
              Valider
            </button>
          </div>
        </template>
      </VueDatePicker>
    </div>
    <LineGraph v-if="props.state === 'first'" :data="workingTimesData" />
  </div>
</template>
