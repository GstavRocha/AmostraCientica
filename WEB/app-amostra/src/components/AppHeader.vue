<template>
    <v-container>
       <v-toolbar class="max-auto">
            <v-img src="../assets/marca.png" height="50"/>
            <v-menu>
            <template v-slot:activator="{ props }">
              <v-btn
                icon="mdi-dots-vertical"
                variant="text"
                v-bind="props"
              ></v-btn>
            </template>

            <v-list>
              <v-list-item 
              v-for="(item, i) in items" :key="i"
              @click="goToLink(item.link)"
              >
                <v-list-item-title>{{ item.title }}</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>

       </v-toolbar>
  </v-container>
</template>

<script>
const whastappdev = 'gustavoRocha'
  export default {
    data: () => ({
      items: [
        { title: 'whatsapp Escolar',link:'https://wa.me/message/R6RUHSRWIYSDA1'},
        { title: 'Meet Suport(apenas no dia do evento)',link: 'https://meet.google.com/jee-anwg-cru' },
        { title: 'Email', link:'suport@genesiscolegioecurso.com.br' },
        { title: 'GestãoTi whastapp', link: 'numerodotelefone' },
      ],
    }),
    methods: {
        goToLink(link) {
            window.open(link,'_blank');
        }
    }
  }
</script>