<template>
  <div>
    <div class="mb-4">
      <v-icon left v-on:click="toggleCreateProduct"> mdi-card-plus </v-icon>
      <v-icon v-on:click="toggleIndexProduct" > mdi-format-list-text  </v-icon>
    </div>
    <v-form ref="form">
      <v-container v-if="createNewProductFlag === true">
        <v-row>
          <v-col cols="12" md="2">
            <v-text-field
              v-model="newCode"
              label="code"
              :rules="nameRules"
              required
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newName"
              label="name" ></v-text-field>
          </v-col>
          <v-col cols="12" md="1">
            <v-text-field
              v-model.number="newPrice"
              label="price"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="2">
            <v-file-input
              multiple
              truncate-length="5"
              accept="image/*"
              label="File input" @change="setImage"
            ></v-file-input>
          </v-col>
          <v-col cols="12" md="1">
            <v-btn class="mr-4" @click="createProduct" ><v-icon>mdi-plus</v-icon></v-btn>
          </v-col>

        </v-row>
      </v-container>
    </v-form>
    <div v-if="indexProductFlag === true">
      <v-list v-for="(product,index) in products" v-bind:key="product.id">
        <v-list-item >
          <v-list-item-avatar tile size="80" v-on:click="toggle(index)">
            <v-img :src="product.first_image_url"></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-container>
              <v-row align="center">
                <v-col cols="12" md="3"> {{ product.code }} </v-col>
                <v-col cols="12" md="1"> {{ product.price + " RMB" }} </v-col>
                <v-col cols="12" md="5"> {{ product.name }} </v-col>
                <v-col cols="4" md="1"><v-text-field @change='updateStock(product.stocks["office"])' label="office" v-model='product.stocks["office"]["quantity"]'></v-text-field> </v-col>
                <v-col cols="4" md="1"><v-text-field @change='updateStock(product.stocks["fba"])' label="fba" v-model='product.stocks["fba"]["quantity"]'></v-text-field> </v-col>
                <v-col cols="4" md="1"><v-text-field @change='updateStock(product.stocks["china"])' label="china" v-model='product.stocks["china"]["quantity"]'></v-text-field> </v-col>
              </v-row>
            </v-container>
            <v-list-item-subtitle v-if="product.flag === true " style="white-space:pre;">
              <v-container>
                <v-row align="center">
                  <v-col cols="12" md="6">{{ product.explain }}</v-col>
                  <v-col v-for="(image_url, num) in product.image_urls" v-bind:key="num" cols="6" md="1">
                    <v-list-item-avatar tile size="80" v-on:click="toggle(index)">
                      <v-img :src="image_url"></v-img>
                    </v-list-item-avatar>
                  </v-col>
                </v-row>
              </v-container>
            </v-list-item-subtitle>
          </v-list-item-content>
          <v-list-item-action>
            <v-btn icon>
            <v-icon v-on:click="editProduct(product)"> mdi-square-edit-outline</v-icon>
            </v-btn icon>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </div>
    <v-container>
      <v-row justify="center">
        <v-dialog v-model="editProductFlag" max-width="800px">
          <v-card>
            <v-card-title>
              <span class="headline">Edit Product</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12"><v-text-field label="Product ID (CODE)*" required v-model="editCode"></v-text-field></v-col>
                  <v-col cols="12"><v-text-field label="Product Name" required v-model="editName"></v-text-field></v-col>
                  <v-col cols="12"><v-text-field label="Product price*" required v-model="editPrice"></v-text-field></v-col>
                  <v-col cols="12">
                    <v-textarea label="explain" v-model="editExplain"></v-textarea>
                  </v-col>
                </v-row>
              </v-container>
              <small>*必須</small>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="editProductFlag = false"> X </v-btn>
              <v-btn color="blue darken-1" text @click="updateProduct"> Save </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-row>
    </v-container>
  </div>
</template>
<script>
  import axios from 'axios';
  axios.defaults.baseURL = '../';
  export default {
    data () {
      return {
        products: [],
        formdata: new FormData,
        newPrice: "",
        newName: "",
        newCode: "",
        editProductId: "",
        editPrice: "",
        editName: "",
        editExplain: "",
        editCode: "",
        editImages: [],
        indexProductFlag: true,
        editProductFlag: false,
        createNewProductFlag: false,
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
        this.formdata.set('code', this.newCode);
        this.formdata.set('name', this.newName);
        this.formdata.set('price', this.newPrice);
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.post(`api/products/`, this.formdata, config)
        .then(res => {
          this.products.push(res.data)
          this.$refs.form.reset()
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
      editProduct(obj){
        this.formdata = new FormData
        this.editProductFlag = true
        this.editProductId = obj.id
        this.editCode = obj.code
        this.editPrice = obj.price
        this.editName = obj.name
        this.editExplain = obj.explain
      },
      updateProduct(){
        if (!this.$refs.form.validate()){
          return false
        };
        this.formdata.set('id', this.editProductId);
        this.formdata.set('code', this.editCode);
        this.formdata.set('name', this.editName);
        this.formdata.set('price', this.editPrice);
        this.formdata.set('explain', this.editExplain);
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.patch(`api/products/${this.editProductId}`, this.formdata, config)
        .then(res => {
          var num = this.products.findIndex(function(product){
            if (product.id === res.data.id) { return true }
          })
          this.products[num] = res.data
          this.editProductFlag = false
        });
      },
      updateStock(obj){
        if (!this.$refs.form.validate()){
          return false
        };
        this.formdata = new FormData
        this.formdata.set('id', obj.id );
        this.formdata.set('quantity', obj.quantity);
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.patch(`api/stocks/${obj.id}`, this.formdata, config)
        .then(res => {
        });
      },
      setImage: function(files) {
        this.formdata.delete('images[]')
        for(let file of files){
          this.formdata.append('images[]', file)
        }
      },
    }
  }
</script>