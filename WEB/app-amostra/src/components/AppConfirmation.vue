<template>
    <div class="confirmation-container">
      <v-btn icon class="like-button" @click="onLike">
        <v-icon>mdi-thumb-up</v-icon>
      </v-btn>
      <v-btn class="back-button" @click="onBack">Voltar</v-btn>
    </div>
  </template>
  
  <script setup>
  const onLike = () => {
    console.log('Like button clicked');
  };
  
  const onBack = () => {
    // Emitindo o evento para voltar ao QR Reader
    emit('returnToQr');
  };
  </script>
  
  <style scoped>
  .confirmation-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh; /* Ocupa toda a altura da tela */
  padding: 20px; /* Espaçamento interno */
  background-color: #f5f5f5; /* Cor de fundo suave */
}

.like-button {
  background-color: #007bff; /* Cor azul para o botão */
  color: white;
  width: 70px; /* Largura do botão */
  height: 70px; /* Altura do botão */
  border-radius: 50%; /* Forma circular */
  margin-bottom: 20px; /* Espaço entre o botão de like e o botão de voltar */
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-button {
  background-color: transparent;
  color: #007bff; /* Cor azul para o texto */
  border: 2px solid #007bff; /* Borda azul */
  padding: 10px 20px;
  border-radius: 5px; /* Bordas arredondadas */
  cursor: pointer;
  transition: background-color 0.3s, color 0.3s;
}

.back-button:hover {
  background-color: #007bff;
  color: white; /* Muda a cor de fundo e do texto no hover */
}

  </style>
  