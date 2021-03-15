<template>
    <div id ="app"> 
      <Header />
      <!-- <router-view/> -->
     </div>
</template>

<script>
import Header from './packs/components/header.vue'
export default {
  data: function () {
    return {
    }
  },
  components: {
    Header
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>