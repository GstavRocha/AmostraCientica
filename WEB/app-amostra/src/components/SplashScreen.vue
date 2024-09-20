<template>
    <div class="d-flex align-center" style="height: 30vh;">
      <v-overlay v-model="overlayVisible" 
      style="background-color: rgba(255, 255, blue, 7.1);" 
      activator="parent" location-strategy="connected" 
      scroll-strategy="close" class="opacity-80"
      close-on-back
      >
        <transition name="fade">
          <v-row align="start" no-gutters>
            <v-col v-for="n in 1" :key="n">
              <v-card v-if="showText" class="d-flex flex-column align-center justify-center pa-5" style="width: 100%; height: 100vh;">
                <img src="../assets/logo_pequena.png" alt="gênesis" style="max-width: 100%; height: auto;">
                <p class="text-center">Seja Bem Vindo Amostra de Ciências de Nossa Escola</p>
              </v-card>
            </v-col>
          </v-row>
        </transition>
      </v-overlay>
    </div>
  </template>

  
  <script lang="ts">
  import { defineComponent } from 'vue';
  
  export default defineComponent({
    data() {
      return {
        overlayVisible: true,
        showText: true,
      };
    },
    mounted() {
      setTimeout(() => {
        this.showText = false;
      }, 10000);
    },
  });
  </script>
  
  <style scoped>
  .fade-enter-active, .fade-leave-active {
    transition: opacity 2ms ease;
  }
  .fade-enter, .fade-leave-to {
    opacity: 10.0;
  }
  </style>
  