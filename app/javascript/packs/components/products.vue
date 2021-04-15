<template>
  <div class="mt-16">
    <v-alert
      dense
      text
      outlined
      type="success"
      v-if="alert"
    >
      success
    </v-alert>
    <div class="mb-4">
      <v-container>
        <v-row>
          <v-col cols="2">
            <v-icon v-on:click="toggleIndexProduct" > mdi-format-list-text  </v-icon>
            <v-icon left v-on:click="toggleCreateProduct"> mdi-card-plus </v-icon>
            <v-icon left v-on:click="toggleCreateSetProduct"> mdi-expand-all </v-icon>
            <v-icon v-on:click="toggleImportProducts" > mdi-file-upload  </v-icon>
            <v-icon v-on:click="downloadProducts" > mdi-file-download  </v-icon>
          </v-col>
          <v-col cols="10" @submit.prevent>
            <v-form ref="searchForm">
              <v-text-field v-model="searchKeyword" label="検索" @change="searchProducts"> 
                <template v-slot:append-outer> <v-btn color="primary"> <v-icon>mdi-magnify</v-icon> </v-btn> </template> 
              </v-text-field>
            </v-form>
          </v-col>
        </v-row>
      </v-container>
    </div>
    <v-form ref="importProductsForm">
      <v-container v-if="importProductsFlag === true">
        <h2> CSVで商品登録 </h2>
        <v-row>
          <v-col cols="12" md="2">
            <v-file-input
              truncate-length="5"
              accept=".csv"
              label="File input" @change="importProduct"
            ></v-file-input>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <v-form ref="createSetForm">
      <v-container v-if="createNewSetProductFlag === true">
        <h2> セット商品の登録 </h2>
        <v-row>
          <v-col cols="12" md="3">
            <v-text-field
              v-model="newSetCode"
              label="code"
              :rules="nameRules"
              required
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="newSetName"
              label="name" ></v-text-field>
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
            <v-btn class="mr-4" @click="createSetProduct" color="primary"><v-icon>mdi-plus</v-icon></v-btn>
          </v-col>

        </v-row>
        <v-row>
          <v-col cols="12" md="2" v-for="(newSetProduct, index) in newSetProducts">
            <v-text-field
              v-model="newSetProduct.code"
              label="code"
              :rules="nameRules"
            ></v-text-field>
            <v-text-field
              v-model="newSetProduct.quantity"
              label="quantity"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="1">
            <v-btn class="mt-4" @click="addSetProduct" ><v-icon>mdi-plus</v-icon></v-btn>
            <v-btn class="mt-4" @click="deleteSetProduct" ><v-icon>mdi-minus</v-icon></v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <v-form ref="form">
      <v-container v-if="createNewProductFlag === true">
        <h2> 単一商品の登録 </h2>
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
            <v-btn class="mr-4" @click="createProduct" color="primary"><v-icon>mdi-plus</v-icon></v-btn>
          </v-col>

        </v-row>
      </v-container>
    </v-form>
    <div v-if="indexProductFlag === true">
      <v-list v-for="(product,index) in products" v-bind:key="product.id">
        <v-list-item>
          <v-list-item-avatar tile size="80" v-on:click="toggle(index)">
            <v-img :src="product.first_image_url"></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col cols="12" md="3">
                  <v-badge content="set" v-if="product.is_set === true">
                    <div class="font-weight-bold">{{ product.code }} </div>
                  </v-badge>
                  <div class="font-weight-bold" v-if="product.is_set !== true">{{ product.code }} </div>
                  <div v-for="(value,alias_id,index) in sorted_alias_ids(product.alias_id)">
                    {{ alias_id + ": " + value["code"] }}
                  </div>
                </v-col>
                <v-col cols="12" md="1"><v-text-field disabled filled label='RMB' v-model='product.price'></v-text-field> </v-col>
                <v-col cols="12" md="5" >
                  <v-text-field @change='updateProductName(product)' label="name" v-model='product.name'></v-text-field>
                  <v-text-field label="memo" @change='updateProductMemo(product)' v-model='product.memo.content'></v-text-field>
                </v-col>
                
                <v-col cols="12" md="3">
                  <v-row>
                    <v-col cols="4" v-for="(stock, place, index) in sorted_stocks(product.stocks)" :key="index">
                      <v-text-field v-if="product.is_set !== true" @change='updateStock(stock)' :label="place" v-model='product.stocks[place]["quantity"]'></v-text-field> 
                      <v-text-field disabled v-if="product.is_set === true" :label="place" v-model='product.stocks[place]["quantity"]'></v-text-field> 
                    </v-col>
                  </v-row>
                </v-col>
               
              </v-row>
            </v-container>
            <v-list-item-subtitle v-if="product.flag === true " style="white-space:pre-wrap;">
              <v-container>
                <v-row align="center" v-if="product.is_set === false ">
                  <v-col cols="12" md="5">{{ product.explain }}</v-col>
                  <v-col cols="6" md="1">
                    <v-btn color="secondary">
                      <v-icon v-on:click="editProduct(product)"> mdi-square-edit-outline</v-icon>
                    </v-btn>
                  </v-col>
                  <v-col v-for="(image_url, num) in product.image_urls" v-bind:key="num" cols="6" md="2">
                    <v-card>
                      <v-layout justify-center>
                        <img :src="image_url" width="100%">
                      </v-layout>
                    </v-card>
                  </v-col>
                </v-row>
                <v-row align="center" v-if="product.is_set === true ">
                  <v-col cols="12" md="5">{{ product.explain }}</v-col>
                  <v-col cols="6" md="1">
                    <v-btn color="secondary">
                      <v-icon v-on:click="editProduct(product)"> mdi-square-edit-outline</v-icon>
                    </v-btn>
                  </v-col>
                  <v-col v-for="(set_product, num) in product.set_products" v-bind:key="num" cols="12" md="2">
                    <v-card>
                      <v-container><v-row>
                        <v-col cols="auto">
                          <v-avatar tile size="80">
                            <v-img :src="set_product.first_image_url"></v-img>
                          </v-avatar>
                        </v-col>
                        <v-col cols="auto">
                          <p>{{ set_product.code }} </p>
                          <p v-for="stock_place in sorted_stock_places">
                            {{ stock_place + ":" + set_product.stocks[stock_place]["quantity"] }}
                          </p>
                        </v-col>
                      </v-row></v-container>
                    </v-card>
                  </v-col>
                </v-row>
              </v-container>
            </v-list-item-subtitle>
          </v-list-item-content>
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
                  <v-col cols="12"><v-text-field label="ID (CODE)*" required v-model="editCode"></v-text-field></v-col>
                  <v-col cols="12"><v-text-field label="Name" required v-model="editName"></v-text-field></v-col>
                  <v-col cols="12"><v-text-field label="price*" required v-model="editPrice"></v-text-field></v-col>
                  <v-col cols="6" v-for="alias_id_kind in sorted_alias_id_kind">
                    <v-text-field :label="alias_id_kind" required v-model='editAliasIds[alias_id_kind]["code"]'></v-text-field>
                  </v-col>
                  <v-col cols="12">
                    <v-textarea label="explain" v-model="editExplain"></v-textarea>
                  </v-col>
                </v-row>
                <v-row v-if="editIsSetFlag">
                  <v-col v-for="(set_product,index) in editSetProducts" cols="4" v-bind:key="index">
                    <v-text-field label="set_item" v-model='set_product["code"]'></v-text-field>
                    <v-text-field label="quantity" v-model='set_product["quantity"]'></v-text-field>
                  </v-col>
                  <v-col cols="12" md="1">
                    <v-btn class="mt-4" @click="addEditSetProduct" ><v-icon>mdi-plus</v-icon></v-btn>
                    <v-btn class="mt-4" @click="deleteEditSetProduct" ><v-icon>mdi-minus</v-icon></v-btn>
                  </v-col>
                </v-row>
              </v-container>
              <small>*必須</small>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="editProductFlag = false">cancel</v-btn>
              <v-btn class="mr-4" @click="updateProduct" color="primary">更新</v-btn>
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
        alert: false,
        products: [],
        formdata: new FormData,
        newPrice: "",
        searchKeyword: "",
        newName: "",
        newCode: "",
        editProductId: "",
        editPrice: "",
        editName: "",
        editExplain: "",
        editSKU: "",
        editASIN: "",
        editCarId: "",
        editOtherId: "",
        editCode: "",
        editImages: [],
        editSetProducts: [],
        editIsSetFlag: false,
        indexProductFlag: true,
        editProductFlag: false,
        createNewProductFlag: false,
        newSetName: "",
        newSetCode: "",
        newSetProducts: [ {code: "", quantity: 1 }],
        createNewSetProductFlag: false,
        importProductsFlag: false,
        sorted_stock_places: [],
        sorted_alias_id_kind: [],
        editAliasIds: {},
        nameRules: [
          v => !!v || '入力してください',
          v => (v && v.length <= 50) || '50文字以下でお願いします。',
        ],
      }
    },
    mounted(){
      this.hideAlert()

      axios.get(`api/products.json`)
      .then(res => {
        this.products = res.data;
        console.log(this.products)
      });

      axios.get(`api/stock_places.json`)
      .then(res => {
        this.sorted_stock_places = res.data.map( (obj) => obj.name)
      })

      axios.get(`api/alias_id_kinds.json`)
      .then(res => {
        this.sorted_alias_id_kind = res.data.map( (obj) => obj.name)
        let editAliasIds = {} /// editAliasIdsの設定
        this.sorted_alias_id_kind.forEach(function(alias_id_kind){ // foreach内でthis.editAliasIdsを参照できない
          editAliasIds[alias_id_kind] = ""
        })
        this.editAliasIds = editAliasIds
      })
    },
    computed: {
    },
    methods: {
      sorted_stocks: function(obj){
        let sorted_stocks = {}
        this.sorted_stock_places.forEach(function(stock_place){
          sorted_stocks[stock_place] = {}
          sorted_stocks[stock_place]["id"] = obj[stock_place]["id"]
          sorted_stocks[stock_place]["quantity"] = obj[stock_place]["quantity"]
          sorted_stocks[stock_place]["stock_place_id"] = obj[stock_place]["stock_place_id"]
        })
        return sorted_stocks
      },
      sorted_alias_ids: function(obj){
        let sorted_alias_ids = {}
        this.sorted_alias_id_kind.forEach(function(alias_id){
          sorted_alias_ids[alias_id] = {}
          sorted_alias_ids[alias_id]["id"] = obj[alias_id]["id"]
          sorted_alias_ids[alias_id]["code"] = obj[alias_id]["code"]
          sorted_alias_ids[alias_id]["alias_id_kind_id"] = obj[alias_id]["alias_id_kind_id"]
          sorted_alias_ids[alias_id]["name"] = obj[alias_id]["name"]
        })
        return sorted_alias_ids
      },
      createProduct(){
        if (!this.$refs.form.validate()){
          return false
        };
        this.formdata.set('product[code]', this.newCode);
        this.formdata.set('product[name]', this.newName);
        this.formdata.set('product[price]', this.newPrice);
        this.formdata.set('product[is_set]', false);
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.post(`api/products/`, this.formdata, config)
        .then(res => {
          this.products.push(res.data)
          this.$refs.form.reset()
          console.log(res)
        });
      },
      createSetProduct(){
        if (!this.$refs.createSetForm.validate()){
          return false
        };
        this.formdata.set('product[code]', this.newCode);
        this.formdata.set('product[name]', this.newName);
        this.formdata.set('product[price]', 0);
        this.formdata.set('product[is_set]', true);
        this.formdata.set('set_products', JSON.stringify(this.newSetProducts))
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.post(`api/products/`, this.formdata, config)
        .then(res => {
          this.products.push(res.data)
          this.$refs.createSetForm.reset()
        })
        .catch(res => { 
          alert("セット商品のID(CODE)が間違っています。")
         })
      },
      searchProducts(){
        axios.get(`api/products.json/?search_keyword=${this.searchKeyword}`)
        .then(res => {
          this.products = res.data;
          console.log(res.data)
        });
      },
      downloadProducts(){
        axios.get(`api/products.csv/?search_keyword=${this.searchKeyword}`)
        .then(res => {
          var csv = res.data
          let blob = new Blob([csv],{type: "text/csv"})
          let link = document.createElement("a")
          link.href = window.URL.createObjectURL(blob)
          link.download = "result.csv"
          link.click()
        })
      },
      toggle: function(index){
        this.products[index].flag = (this.products[index].flag ? false : true )
      },
      toggleCreateProduct: function(index){
        this.createNewProductFlag = (this.createNewProductFlag ? false : true )
        this.createNewSetProductFlag = false
        this.importProductsFlag = false
        this.formdata = new FormData
      },
      toggleImportProducts: function(index){
        this.importProductsFlag = (this.importProductsFlag ? false : true )
        this.createNewSetProductFlag = false
        this.createNewProductFlag = false
        this.formdata = new FormData
      },
      toggleCreateSetProduct: function(index){
        this.createNewSetProductFlag = (this.createNewSetProductFlag ? false : true )
        this.createNewProductFlag = false
        this.importProductsFlag = false
        this.formdata = new FormData
      },
      toggleIndexProduct: function(index){
        this.indexProductFlag = (this.indexProductFlag ? false : true )
      },
      editProduct(product){
        this.formdata = new FormData
        this.editProductFlag = true
        this.editProductId = product.id
        this.editCode = product.code
        this.editPrice = product.price
        this.editName = product.name
        this.editExplain = product.explain

        let aliasIdsTmp = {} // this.sorted_~ 内で this.editAliasIdsは参照できない
        Object.entries(this.sorted_alias_id_kind).forEach(function(alias_id){
          aliasIdsTmp[alias_id[1]] = product["alias_id"][alias_id[1]] // TODO
        })
        this.editAliasIds = aliasIdsTmp

        if (product.is_set === true) {
          this.editIsSetFlag = true
          this.editSetProducts = [];
          for(let setProduct of product.set_products){
            this.editSetProducts.push(setProduct) 
          }
        } else {
          this.editIsSetFlag = false
        }
      },
      updateProductName(obj){
        this.formdata = new FormData
        this.formdata.set('product[id]', obj.id);
        this.formdata.set('product[name]', obj.name);
        if (obj.is_set === true) {
          this.formdata.set('set_products', JSON.stringify(obj.set_products))
        }
        axios.patch(`api/products/${obj.id}`, this.formdata)
        .then(res => {
          var num = this.products.findIndex(function(product){
            if (product.id === res.data.id) { return true }
          })
          this.products[num] = res.data
          this.editProductFlag = false
        });
      },
      updateProduct(){
        if (!this.$refs.form.validate()){
          return false
        };
        this.formdata.set('product[id]', this.editProductId);
        this.formdata.set('product[code]', this.editCode);
        this.formdata.set('product[name]', this.editName);
        this.formdata.set('product[price]', this.editPrice);
        this.formdata.set('product[explain]', this.editExplain);

        let sorted_alias_id_kind = this.sorted_alias_id_kind // TODO this要不要
        for (let i = 0; i < sorted_alias_id_kind.length; i++) {
          this.formdata.set('alias_ids['+ sorted_alias_id_kind[i] + ']', JSON.stringify(this.editAliasIds[sorted_alias_id_kind[i]]))
        }

        if (this.editIsSetFlag === true) {
          this.formdata.set('set_products', JSON.stringify(this.editSetProducts))
        }
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
      updateProductMemo(obj){
        this.formdata = new FormData
        if (obj.memo.id) {  /// update
          this.formdata.set('memo[id]', obj.memo.id );
          this.formdata.set('memo[content]', obj.memo.content);
          axios.patch(`api/product_memos/${obj.memo.id}`, this.formdata)
          .then(res => {
          });
        } else {  /// create
          this.formdata.set('product[id]', obj.id );
          this.formdata.set('memo[content]', obj.memo.content);
          axios.post(`api/product_memos/`, this.formdata)
          .then(res => {
          });
        }
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
      importProduct(file) {
        this.formdata = new FormData
        this.formdata.append('csv', file)
        if ( file === null){
          return false
        };
        axios.post(`api/products/import`, this.formdata)
        .then(res => {
        });
        this.$refs.importProductsForm.reset();
      },
      setImage: function(files) {
        this.formdata.delete('images[]')
        for(let file of files){
          this.formdata.append('images[]', file)
        }
      },
      addSetProduct(){
        this.newSetProducts.push({code: "", quantity: 1})
      },
      deleteSetProduct(){
        this.newSetProducts.pop()
      },
      addEditSetProduct(){
        this.editSetProducts.push({code: "", quantity: 1})
      },
      deleteEditSetProduct(){
        this.editSetProducts.pop()
      },
      hideAlert(){
        window.setInterval(() => {
          this.alert = false;
        }, 3000)
      }
    }
  }
</script>
