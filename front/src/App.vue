<script setup lang="ts">
import { onBeforeMount, onBeforeUnmount, ref, watch } from "vue";
import { useToast } from "vue-toastification";
import OffLineRequests from "./api/fetcher/offLineRequests";
import UserProvider from "./store/User";

const isOnline = ref(true);
const user = new UserProvider();

const updateOnlineStatus = (e: any) => {
  const { type } = e;
  isOnline.value = type === "online";
};

onBeforeMount(() => {
  window.addEventListener("online", updateOnlineStatus);
  window.addEventListener("offline", updateOnlineStatus);
});
onBeforeUnmount(() => {
  window.removeEventListener("online", updateOnlineStatus);
  window.removeEventListener("offline", updateOnlineStatus);
});

watch(isOnline, () => {
  user.setOnlineStatus(isOnline.value);
  if (isOnline.value === true) {
    useToast().info("Vous êtes re-connecté");
    OffLineRequests.push();
  } else {
    useToast().error("Vous êtes hors connexion");
  }
});
</script>

<template>
  <div class="h-screen w-screen relative">
    <router-view />
  </div>
</template>
