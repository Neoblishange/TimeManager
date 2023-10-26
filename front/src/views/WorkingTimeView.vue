<script setup lang="ts">
import moment from "moment";
import { onMounted, ref } from "vue";
import VueTailwindDatepicker from "vue-tailwind-datepicker";
import WorkingTimesAPI from "../api/workingTimes.api";
import HeaderVue from "../components/HeaderVue.vue";
import WorkingTimesUpdate from "../components/WorkingTimeUpdate.vue";
import WorkingTime from "../types/WorkingTimes";

const dateValue = ref([]);
const workingTimes = ref<WorkingTime[]>([]);
const modalUpdate = ref(false);
const timeUpdate = ref<WorkingTime>();

const deleteTime = (time: WorkingTime) => {
  WorkingTimesAPI.delete(time).then(() => {
    loadData();
  });
};

const showUpdate = (time: WorkingTime) => {
  timeUpdate.value = time;
  modalUpdate.value = true;
};

const closeUpdate = () => {
  timeUpdate.value = undefined;
  modalUpdate.value = false;
};

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

const onUpdate = () => {
  loadData();
};

onMounted(() => {
  loadData();
});
</script>

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
    <div class="flex flex-col gap-2 min-w-[300px] w-1/2">
      <table class="w-full">
        <thead>
          <tr>
            <td>
              <div class="w-full flex flex-row items-center justify-center">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="icon icon-tabler icon-tabler-brackets-contain-start"
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
                  <path d="M9 4h-4v16h4"></path>
                  <path d="M18 16h-.01"></path>
                  <path d="M14 16h-.01"></path>
                  <path d="M10 16h-.01"></path>
                </svg>
                Début
              </div>
            </td>
            <td>
              <div class="w-full flex flex-row items-center justify-center">
                Fin
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="icon icon-tabler icon-tabler-brackets-contain-end"
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
                  <path d="M14 4h4v16h-4"></path>
                  <path d="M5 16h.01"></path>
                  <path d="M9 16h.01"></path>
                  <path d="M13 16h.01"></path>
                </svg>
              </div>
            </td>
            <td></td>
          </tr>
        </thead>
        <tbody>
          <template v-for="time in workingTimes">
            <tr>
              <td>
                {{ moment(time.start).format("dddd DD MMMM YYYY - HH:mm:ss") }}
              </td>
              <td>
                {{ moment(time.end).format("dddd DD MMMM YYYY - HH:mm:ss") }}
              </td>
              <td>
                <button @click="showUpdate(time)">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="icon icon-tabler icon-tabler-edit"
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
                    <path
                      d="M7 7h-1a2 2 0 0 0 -2 2v9a2 2 0 0 0 2 2h9a2 2 0 0 0 2 -2v-1"
                    ></path>
                    <path
                      d="M20.385 6.585a2.1 2.1 0 0 0 -2.97 -2.97l-8.415 8.385v3h3l8.385 -8.415z"
                    ></path>
                    <path d="M16 5l3 3"></path>
                  </svg>
                </button>
                <button @click="deleteTime(time)">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="icon icon-tabler icon-tabler-trash"
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
                    <path d="M4 7l16 0"></path>
                    <path d="M10 11l0 6"></path>
                    <path d="M14 11l0 6"></path>
                    <path
                      d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12"
                    ></path>
                    <path d="M9 7v-3a1 1 0 0 1 1 -1h4a1 1 0 0 1 1 1v3"></path>
                  </svg>
                </button>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>
  </div>

  <div v-if="modalUpdate === true && timeUpdate">
    <WorkingTimesUpdate
      @update="onUpdate()"
      @close="closeUpdate"
      :time="timeUpdate"
    />
    <div></div>
  </div>
</template>
