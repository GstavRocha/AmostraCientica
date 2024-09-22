<template>
    <v-card>
      <!-- Seu código de verificação de usuário -->
      <v-btn @click="confirmUser">Confirmar</v-btn>
    </v-card>
  </template>
  
  <script setup lang="ts">
  import { defineEmits } from 'vue'
  
  const emit = defineEmits()
  
  function confirmUser() {
    // Lógica para validar os dados do usuário
    // Se os dados forem válidos, emita o evento
    emit('confirm')
  }
  </script>
  


<!-- 

<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" sm="8" md="6" lg="4">
        <v-card class="mx-auto">
          <v-card-title>Selecione seu tipo</v-card-title>
          <v-card-text>
            <v-radio-group v-model="selectedType" @change="handleTypeChange">
              <v-radio label="Visitante" value="visitor"></v-radio>
              <v-radio label="Estudante" value="student"></v-radio>
              <v-radio label="Professor" value="teacher"></v-radio>
            </v-radio-group>

            <v-form v-if="isVisitor">
              <v-text-field label="Nome Completo" v-model="visitor.name" required></v-text-field>
              <v-text-field label="Email" v-model="visitor.email" required></v-text-field>
              <v-text-field label="Nome do Aluno" v-model="visitor.studentName" required></v-text-field>
              <v-btn @click="confirmVisitor">Confirmar</v-btn>
            </v-form>

            <v-form v-if="isStudent">
              <v-text-field label="Nome Completo" v-model="student.name" required></v-text-field>
              <v-text-field label="Turma" v-model="student.class" required></v-text-field>
              <v-text-field label="Nome do Trabalho" v-model="student.workName" required></v-text-field>
              <v-text-field label="Nome do Professor Orientador" v-model="student.advisorName" required></v-text-field>
              <v-btn @click="confirmStudent">Confirmar</v-btn>
            </v-form>

            <v-form v-if="isTeacher">
              <v-text-field label="Nome do Professor" v-model="teacher.name" required></v-text-field>
              <v-text-field label="Email Institucional" v-model="teacher.email" required></v-text-field>
              <v-text-field label="Turma que Orienta" v-model="teacher.class" required></v-text-field>
              <v-btn @click="confirmTeacher">Confirmar</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      selectedType: null,
      visitor: {
        name: '',
        email: '',
        studentName: '',
      },
      student: {
        name: '',
        class: '',
        workName: '',
        advisorName: '',
      },
      teacher: {
        name: '',
        email: '',
        class: '',
      },
    };
  },
  computed: {
    isVisitor() {
      return this.selectedType === 'visitor';
    },
    isStudent() {
      return this.selectedType === 'student';
    },
    isTeacher() {
      return this.selectedType === 'teacher';
    },
  },
  methods: {
    handleTypeChange() {
      // Limpar campos ao mudar de opção
      this.visitor = { name: '', email: '', studentName: '' };
      this.student = { name: '', class: '', workName: '', advisorName: '' };
      this.teacher = { name: '', email: '', class: '' };
    },
    confirmVisitor() {
      console.log('Visitante:', this.visitor);
      // Lógica para checar os dados do visitante
    },
    confirmStudent() {
      console.log('Estudante:', this.student);
      // Lógica para checar os dados do estudante
    },
    confirmTeacher() {
      console.log('Professor:', this.teacher);
      // Lógica para checar os dados do professor
    },
  },
};
</script>

<style scoped>
.mx-auto {
  max-width: 400px; /* Você pode ajustar conforme necessário */
}
</style> -->
