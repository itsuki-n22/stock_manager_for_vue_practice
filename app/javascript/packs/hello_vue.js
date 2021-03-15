
 import Vue from 'vue'
 import Vuetify from "vuetify"; // 追加
 import "vuetify/dist/vuetify.min.css"; // 追加
 import hoge from '../app.vue'

 Vue.use(Vuetify); // 追加
 const vuetify = new Vuetify(); // 追加

 document.addEventListener('DOMContentLoaded', () => {
   const app = new Vue({
     vuetify,
     el: '#hello',
     data: {
       message: "Can you say hello?"
     },
     components: { hoge }
   })
 })



// If the project is using turbolinks, install 'vue-turbolinks':
//
// yarn add vue-turbolinks
//
// Then uncomment the code block below:
//
// import TurbolinksAdapter from 'vue-turbolinks'
// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// Vue.use(TurbolinksAdapter)
//
// document.addEventListener('turbolinks:load', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: () => {
//       return {
//         message: "Can you say hello?"
//       }
//     },
//     components: { App }
//   })
// })
