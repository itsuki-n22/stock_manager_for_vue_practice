<template>
  <v-card class="overflow-hidden">
    <v-app-bar
      fixed
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
        <v-icon>mdi-basket</v-icon>
      </v-btn>

      <v-btn icon href="/orders/">
        <v-icon>mdi-cube-send</v-icon>
      </v-btn>

      <v-btn icon href="/bulk_shipments/">
        <v-icon>mdi-truck</v-icon>
      </v-btn>

      <v-btn icon href="/configs/">
        <v-icon>mdi-cogs</v-icon>
      </v-btn>

      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>

    </v-app-bar>
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
