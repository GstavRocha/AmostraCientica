<template>
  <v-app>
    <AppHeader />
    <div>
      <SplashScreen />
      <div v-if="!isQrReaderVisible && !isConfirmationVisible">
        <AppTipoUsuario @confirm="handleConfirm" />
      </div>
      <div v-else-if="isQrReaderVisible">
        <AppQrReader @confirm="handleQrConfirm" />
      </div>
      <div v-else-if="isConfirmationVisible">
        <ConfirmationComponent @returnToQr="showQrReader" />
      </div>
    </div>
  </v-app>
</template>

<script setup>
import { ref } from 'vue';

const isQrReaderVisible = ref(false);
const isConfirmationVisible = ref(false);

const handleConfirm = () => {
  isQrReaderVisible.value = true;
  isConfirmationVisible.value = false;
};
const handleQrConfirm = (code) => {
  console.log("QR Code confirmado:", code);
  isQrReaderVisible.value = false;
  isConfirmationVisible.value = true;
};

const showQrReader = () => {
  isQrReaderVisible.value = true;
  isConfirmationVisible.value = false;
};

</script>
