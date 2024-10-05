<template>
  <div class="qr-reader-container">
    <p class="text-center text-h5"> Aponte para o QR</p>
    <br/>
    <qrcode-stream
      :constraints="selectedConstraints"
      @detect="onDetect"
      @error="onError"
      @camera-on="onCameraReady"
    />
    <div class="qr-overlay">
      <div class="qr-border"></div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
import { QrcodeStream } from 'vue-qrcode-reader';

const result = ref('')
const error = ref('')
const selectedConstraints = ref({ facingMode: 'environment' })
function onCameraReady() {
  error.value = ''
}

function onDetect(detectedCodes) {
  if (detectedCodes.length > 0) {
    const code = detectedCodes[0].rawValue
    result.value = code
    console.log("Código detectado:", code)
    alert("OK: " + code)
    emit('qrConfirmed', code);
  }
}

function onError(){
  error.value = `Algo errado com a camera`
}
</script>
<style>
.qr-reader-container {
  position: relative;
  width: 100%;
  height: 100%;
}

.qr-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.qr-border {
  position: absolute;
  top: 60%;
  left: 50%;
  width: 200px;
  height: 200px;
  transform: translate(-50%, -50%);
  border: 5px solid rgb(38, 0, 255);
  box-shadow: 0 0 10px 5px rgba(0, 81, 255, 0.5);
  border-radius: 10px;
}
</style>
