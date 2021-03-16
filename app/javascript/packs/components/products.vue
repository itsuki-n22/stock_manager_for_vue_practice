<template>
  <div>
    <v-form ref="form">
      <v-icon left v-on:click="toggleCreateProduct"> mdi-pencil </v-icon>
      <v-container v-if="createNewProductFlag === true">
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="newCode"
              label="code"
              :rules="nameRules"
              required
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="newName"
              label="name" ></v-text-field>
          </v-col>
          <v-col cols="12" md="3">
            <v-text-field
              v-model="newPrice"
              label="price"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="1">
            <v-btn class="mr-4" @click="createProduct" > submit </v-btn>
          </v-col>

        </v-row>
      </v-container>
    </v-form>
    <v-icon v-on:click="toggleIndexProduct" > mdi-format-list-text  </v-icon>
    <div v-if="indexProductFlag === true">
      <v-list v-for="(product,index) in products" v-bind:key="product.id">
        <v-list-item >
          <v-list-item-avatar v-on:click="toggle(index)">
            <v-img src=""></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-container>
              <v-row>
                <v-col cols="12" md="4"> {{ product.code }} </v-col>
                <v-col cols="12" md="4"> {{ product.name }} </v-col>
                <v-col cols="12" md="4"> {{ product.price }} </v-col>
              </v-row>
            </v-container>
            <v-list-item-subtitle v-if="product.flag === true "> {{ product.explain }} </v-list-item-subtitle>
          </v-list-item-content>
          <v-list-item-action>
            <v-btn icon>
            <v-icon v-on:click="updateProduct(product)"> mdi-square-edit-outline</v-icon>
            </v-btn icon>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </div>
  </div>
</template>
<script>
  import axios from 'axios';
  axios.defaults.baseURL = '../';
  export default {
    data () {
      return {
        products: [],
        createNewProductFlag: false,
        newPrice: "",
        newName: "",
        newCode: "",
        indexProductFlag: true,
        nameRules: [
          v => !!v || '入力してください',
          v => (v && v.length <= 50) || '50文字以下でお願いします。',
        ],
      }
    },
    mounted(){
      axios.get(`api/products/`)
      .then(res => {
        this.products = res.data;
      });
    },
    methods: {
      createProduct(){
        if (!this.$refs.form.validate()){
          return false
        };
        axios.post(`api/products/`, { code: this.newCode, name: this.newName, price: this.newPrice })
        .then(res => {
          this.products.push(res.data)
        });
      },
      getProduct(id){
        axios.get(`api/products/`)
        .then(res => {
          this.title = res.data.title;
          this.body = res.data.body;
        });
      },
      toggle: function(index){
        this.products[index].flag = (this.products[index].flag ? false : true )
      },
      toggleCreateProduct: function(index){
        this.createNewProductFlag = (this.createNewProductFlag ? false : true )
      },
      toggleIndexProduct: function(index){
        this.indexProductFlag = (this.indexProductFlag ? false : true )
      },
      updateProduct(obj){
        axios.patch(`api/products/${obj.id}`)
        .then(res => {
          var num = this.products.findIndex(function(product){
            //if (product.id === res.data.id) { return true }
          })
          //this.products(num) = res.data
        });
      },
    }
  }
</script>