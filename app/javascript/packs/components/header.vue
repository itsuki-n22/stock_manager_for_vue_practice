<template>
  <v-card class="mb-1">
    <v-toolbar
      color="green"
      dark
    >
      <v-app-bar-nav-icon></v-app-bar-nav-icon>

      <v-toolbar-title>stock</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn icon href="/users/">
        <v-icon>mdi-account</v-icon>
      </v-btn>

      <v-btn icon href="/products/">
        <v-icon>mdi-square</v-icon>
      </v-btn>

      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>

    </v-toolbar>

  </v-card>
</template>
<script>
  export default {
    data () {
      return {
      }
    },
  }
</script>
