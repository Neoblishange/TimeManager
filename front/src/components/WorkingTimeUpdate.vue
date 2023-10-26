<template>
  <div
    class="h-screen w-screen fixed top-0 left-0 flex items-center justify-center z-[2200]"
  >
    <div
      class="z-[2201] h-screen w-screen absolute top-0 left-0 bg-black opacity-60"
    ></div>
    <div class="z-[2210]">
      <div
        class="bg-white p-10 flex justify-center items-center flex-col gap-6 rounded-lg relative border-4 border-[#fcb795]"
      >
        <div class="absolute top-5 right-5">
          <button @click="$emit('close')">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="icon icon-tabler icon-tabler-x"
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
              <path d="M18 6l-12 12"></path>
              <path d="M6 6l12 12"></path>
            </svg>
          </button>
        </div>
        <div class="mt-4">Modifier une plage horaire</div>
        <div class="w-full flex flex-row gap-2 max-w-[300px]">
          <vue-tailwind-datepicker
            v-model="dateValue"
            as-single
            use-range
            :shortcuts="false"
          />
        </div>

        <button
          @click="update()"
          class="bg-[#3b3fb8] p-3 rounded-[30px] border-black text-white text-md shadow-2xl"
        >
          Modifier
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import moment from "moment";
import { ref } from "vue";
import VueTailwindDatepicker from "vue-tailwind-datepicker";
import WorkingTimesAPI from "../api/workingTimes.api";
import WorkingTime from "../types/WorkingTimes";

const emits = defineEmits<{
  update: [];
  close: [];
}>();

const props = defineProps<{
  time: WorkingTime;
}>();

const dateValue = ref([
  moment(props.time.start).format("YYYY-MM-DD HH:mm:ss"),
  moment(props.time.end).format("YYYY-MM-DD HH:mm:ss"),
]);

const update = () => {
  WorkingTimesAPI.update({
    ...props.time,
    start: new Date(dateValue.value[0]),
    end: new Date(dateValue.value[1]),
  }).then(() => {
    emits("update");
    emits("close");
  });
};
</script>
