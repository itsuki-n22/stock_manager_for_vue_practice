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
            <v-icon v-on:click="toggleIndexBulkShipment" > mdi-format-list-text  </v-icon>
            <v-icon left v-on:click="toggleCreateBulkShipment"> mdi-card-plus </v-icon>
            <v-icon v-on:click="toggleImportBulkShipments" > mdi-file-upload  </v-icon>
            <v-icon v-on:click="downloadBulkShipments" > mdi-file-download  </v-icon>
          </v-col>
          <v-col cols="10" @submit.prevent>
            <v-form ref="searchForm">
                <v-container>
                  <v-row>
                    <v-col cols="6" md="2">
                      <v-select item-text="label" item-value="value" :items="searchTargets" label="検索対象" v-model='searchTarget'></v-select>
                    </v-col>
                    <v-col cols="6" md="2">
                      <v-select item-text="label" item-value="value" :items="status" label="状態" v-model='searchStatus'></v-select>
                    </v-col>
                    <v-col cols="12" md="8">
                      <v-text-field v-model="searchKeyword" label="検索" @change="searchBulkShipments"> 
                        <template v-slot:append-outer> <v-btn color="primary"> <v-icon>mdi-magnify</v-icon> </v-btn> </template> 
                      </v-text-field>
                    </v-col>
                  </v-row>
                </v-container>
            </v-form>
          </v-col>
        </v-row>
      </v-container>
    </div>
    <!-- 
    <v-form ref="importBulkShipmentsForm">
      <v-container v-if="importBulkShipmentsFlag === true">
        <h2> CSVで注文登録 </h2>
        <v-row>
          <v-col cols="12" md="2">
            <v-file-input
              truncate-length="5"
              accept=".csv"
              label="File input" @change="importBulkShipment"
            ></v-file-input>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    -->
    <!-- 
    <v-form ref="createForm">
      <v-container v-if="createNewBulkShipmentFlag === true">
        <h2> 注文の登録 </h2>
        <v-row>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="bulkShipment_id" v-model='newBulkShipmentNumber'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select item-text="name" item-value="id" :items="platforms" label="platform" v-model='newPlatform'></v-select></v-col>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="postal_code" v-model='newPostalCode'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select return-object item-text="label" item-value="value" :items="prefectures" label="prefecture" v-model='newPrefecture'></v-select></v-col>
          <v-col cols="12" md="4"><v-text-field :rules="nameRules" label="address" v-model='newAddress'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="customer_name" v-model='newCustomerName'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="phone_number" v-model='newPhoneNumber'></v-text-field></v-col>
          <v-col cols="12" md="1"><v-text-field  label="delivery_cost" v-model='newDeliveryCharge'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select return-object item-text="label" item-value="value" :items="status" label="status" v-model='newStatus'></v-select></v-col>
          <v-col cols="12" md="1">
            <v-btn class="mr-4" @click="createSetBulkShipment" color="primary"><v-icon>mdi-plus</v-icon></v-btn>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="2" v-for="(newBulkShipmentProduct, index) in newBulkShipmentProducts">
            <v-text-field
              v-model="newBulkShipmentProduct.product_id"
              label="product_id"
              :rules="nameRules"
            ></v-text-field>
            <v-text-field
              v-model="newBulkShipmentProduct.price"
              label="price"
            ></v-text-field>
            <v-text-field
              v-model="newBulkShipmentProduct.quantity"
              label="quantity"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="1">
            <v-btn class="mt-4" @click="addSetBulkShipment" ><v-icon>mdi-plus</v-icon></v-btn>
            <v-btn class="mt-4" @click="deleteSetBulkShipment" ><v-icon>mdi-minus</v-icon></v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <div v-if="indexBulkShipmentFlag === true">
      <v-list v-for="(bulkShipment, index) in bulkShipments" v-bind:key="bulkShipment.id">
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col cols="12" md="2"><v-text-field @change='updateBulkShipment(bulkShipment)' label="bulkShipment_id" v-model='bulkShipment.bulkShipment_number'></v-text-field></v-col>
                <v-col cols="12" md="2"><v-select return-object item-text="name" item-value="id" @change='updateBulkShipment(bulkShipment)' :items="platforms" label="platform" v-model='bulkShipment.platform'></v-select></v-col>
                <v-col v-if="bulkShipment.flag" cols="12" md="2"><v-text-field @change='updateBulkShipment(bulkShipment)' label="postal_code" v-model='bulkShipment.postal_code'></v-text-field></v-col>
                <v-col v-if="bulkShipment.flag" cols="12" md="2"><v-select return-object item-text="label" item-value="value" @change='updateBulkShipment(bulkShipment)' :items="prefectures" label="prefecture" v-model='bulkShipment.prefecture'></v-select></v-col>
                <v-col v-if="bulkShipment.flag" cols="12" md="4"><v-text-field @change='updateBulkShipment(bulkShipment)' label="address" v-model='bulkShipment.address'></v-text-field></v-col>
                <v-col cols="12" md="2"><v-text-field @change='updateBulkShipment(bulkShipment)' label="customer_name" v-model='bulkShipment.customer_name'></v-text-field></v-col>
                <v-col v-if="bulkShipment.flag" cols="12" md="2"><v-text-field @change='updateBulkShipment(bulkShipment)' label="phone_number" v-model='bulkShipment.phone_number'></v-text-field></v-col>
                <v-col v-if="bulkShipment.flag" cols="12" md="1"><v-text-field @change='updateBulkShipment(bulkShipment)' label="delivery_cost" v-model='bulkShipment.delivery_charge'></v-text-field></v-col>
                <v-col cols="12" md="2"><v-select return-object item-text="label" item-value="value" @change='updateBulkShipment(bulkShipment)' :items="status" label="status" v-model='bulkShipment.status'></v-select></v-col>
                <v-col v-if="bulkShipment.flag" cols="12" md="4"><v-text-field label="memo" @change='updateBulkShipmentMemo(bulkShipment)' v-model='bulkShipment.memo.content'></v-text-field></v-col>
                <v-col v-if="bulkShipment.flag === false" cols="12" md="3"><v-text-field label="memo" @change='updateBulkShipmentMemo(bulkShipment)' v-model='bulkShipment.memo.content'></v-text-field></v-col>
                <v-col cols="12" md="1">
                  <v-btn class="mt-4" color="" @click="toggle(index)"><v-icon> mdi-account-box </v-icon></v-btn>
                  <v-btn v-if="bulkShipment.flag" class="mt-4" color="error" @click="deleteBulkShipment(bulkShipment)"><v-icon> mdi-delete </v-icon></v-btn>
                </v-col>

              </v-row>
              <v-row align="center" v-for="(shipping_item, index) in bulkShipment.shipping_items" v-bind:key="shipping_item.id">
                <v-col cols="6" md="1">
                    <v-img size="80" :src="shipping_item.first_image_url"></v-img>
                </v-col>
                <v-col cols="6" md="3">
                  <v-text-field label="product_id" @change='updateBulkShipment(bulkShipment)' v-model='shipping_item.product_id'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-text-field label="price" @change='updateBulkShipment(bulkShipment)' v-model='shipping_item.price'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-text-field label="quantity" @change='updateBulkShipment(bulkShipment)' v-model='shipping_item.quantity'></v-text-field>
                </v-col>
                <v-col cols="6" md="2">
                  <v-select return-object @change='updateBulkShipment(bulkShipment)' :items="deliveryAgents" item-text="name" item-value="id" label="delivery_agent" v-model='shipping_item.delivery_agent'></v-select>
                </v-col>
                <v-col cols="6" md="2">
                  <v-text-field label="tracking_number" @change='updateBulkShipment(bulkShipment)' v-model='shipping_item.tracking_number'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-btn class="" @click="shippingItem(bulkShipment, shipping_item)" v-if="shipping_item.is_sent === true" color="" ><v-icon>mdi-undo</v-icon></v-btn>
                  <v-btn class="" @click="shippingItem(bulkShipment, shipping_item)" v-if="shipping_item.is_sent !== true" color="primary" ><v-icon>mdi-truck</v-icon></v-btn>
                </v-col>
                <v-col cols="3" md="1" v-if="bulkShipment.shipping_items.length === index + 1 ">
                  <v-btn class="mt-4" @click="addShippingItem(bulkShipment)" ><v-icon>mdi-plus</v-icon></v-btn>
                  <v-btn class="mt-4" v-if="index !== 0" @click="deleteShippingItem(bulkShipment)" ><v-icon>mdi-minus</v-icon></v-btn>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
          <v-list-item-action>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </div>
    -->
    <!-- 
    <v-container>
      <v-row justify="center">
        <v-dialog v-model="editBulkShipmentFlag" max-width="800px">
          <v-card>
            <v-card-title>
              <span class="headline">Edit BulkShipment</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12"><v-text-field label="ID (CODE)*" required v-model="editCode"></v-text-field></v-col>
                  <v-col cols="12"><v-text-field label="Name" required v-model="editName"></v-text-field></v-col>
                  <v-col cols="12"><v-text-field label="price*" required v-model="editPrice"></v-text-field></v-col>
                  <v-col cols="6"><v-text-field label="SKU" required v-model='editSKU["code"]'></v-text-field></v-col>
                  <v-col cols="6"><v-text-field label="ASIN" v-model='editASIN["code"]'></v-text-field></v-col>
                  <v-col cols="6"><v-text-field label="Car_id" v-model='editCarId["code"]'></v-text-field></v-col>
                  <v-col cols="6"><v-text-field label="Other_id" v-model='editOtherId["code"]'></v-text-field></v-col>
                  <v-col cols="12">
                    <v-textarea label="explain" v-model="editExplain"></v-textarea>
                  </v-col>
                </v-row>
                <v-row v-if="editIsSetFlag">
                  <v-col v-for="(set_bulkShipment,index) in editSetBulkShipments" cols="4" v-bind:key="index">
                    <v-text-field label="set_item" v-model='set_bulkShipment["code"]'></v-text-field>
                    <v-text-field label="quantity" v-model='set_bulkShipment["quantity"]'></v-text-field>
                  </v-col>
                  <v-col cols="12" md="1">
                    <v-btn class="mt-4" @click="addEditSetBulkShipment" ><v-icon>mdi-plus</v-icon></v-btn>
                    <v-btn class="mt-4" @click="deleteEditSetBulkShipment" ><v-icon>mdi-minus</v-icon></v-btn>
                  </v-col>
                </v-row>
              </v-container>
              <small>*必須</small>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="editBulkShipmentFlag = false">cancel</v-btn>
              <v-btn class="mr-4" @click="updateBulkShipment" color="primary">更新</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-row>
    </v-container>
    -->
  </div>
</template>
<script>
  import axios from 'axios';
  axios.defaults.baseURL = '../';
  export default {
    data () {
      return {
        platforms: [],
        status: [
          "注文直後",  
          "入金待ち",  
          "発送待ち",  
          "配送済み",   
          "キャンセル",
        ],
        searchTargets: [
          "注文情報",  
          "商品・追跡番号",  
        ],
        deliveryAgents: [
        ],
        prefectures: [
          '北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県',
          '茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県',
          '新潟県','富山県','石川県','福井県','山梨県','長野県',
          '岐阜県','静岡県','愛知県','三重県',
          '滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県',
          '鳥取県','島根県','岡山県','広島県','山口県',
          '徳島県','香川県','愛媛県','高知県',
          '福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県',
          '鹿児島県',
          '沖縄県'
        ],
        alert: false,
        bulkShipments: [],
        formdata: new FormData,
        searchKeyword: "",
        searchStatus: "発送待ち",
        searchTarget: "注文情報",
        newCustomerName: "",
        newPostalCode: "",
        newPrefecture: "",
        newAddress: "",
        newPhoneNumber: "",
        newBulkShipmentNumber: "",
        newPlatform: "不明",
        newDeliveryCharge: 598,
        newStatus: "注文直後",
        editBulkShipmentId: "",
        editPrice: "",
        editName: "",
        editExplain: "",
        editSKU: "",
        editASIN: "",
        editCarId: "",
        editOtherId: "",
        editCode: "",
        editSetBulkShipments: [],
        editIsSetFlag: false,
        indexBulkShipmentFlag: true,
        editBulkShipmentFlag: false,
        createNewBulkShipmentFlag: false,
        newBulkShipmentProducts: [ {product_id: "", quantity: 1, price: 0 }],
        createNewSetBulkShipmentFlag: false,
        importBulkShipmentsFlag: false,
        nameRules: [
          v => !!v || '入力してください',
          v => (v && v.length <= 50) || '50文字以下でお願いします。',
        ],
      }
    },
    mounted(){
      this.hideAlert()
    },
    methods: {
      createBulkShipment(){
        if (!this.$refs.form.validate()){
          return false
        };
        this.formdata.set('bulkShipment[code]', this.newCode);
        this.formdata.set('bulkShipment[name]', this.newName);
        this.formdata.set('bulkShipment[price]', this.newPrice);
        this.formdata.set('bulkShipment[is_set]', false);
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.post(`api/bulkShipments/`, this.formdata, config)
        .then(res => {
          this.bulkShipments.push(res.data)
          this.$refs.form.reset()
        });
      },
      createSetBulkShipment(){ // TODO change name
        if (!this.$refs.createForm.validate()){
          return false
        };
        this.formdata = new FormData
        this.formdata.set('bulkShipment[customer_name]', this.newCustomerName);
        this.formdata.set('bulkShipment[postal_code]', this.newPostalCode);
        this.formdata.set('bulkShipment[prefecture]', this.newPrefecture);
        this.formdata.set('bulkShipment[address]', this.newAddress);
        this.formdata.set('bulkShipment[phone_number]', this.newPhoneNumber);
        this.formdata.set('bulkShipment[bulkShipment_number]', this.newBulkShipmentNumber);
        this.formdata.set('bulkShipment[platform_id]', this.newPlatform);// plaftform を platform_idとしている
        this.formdata.set('bulkShipment[delivery_charge]', this.newDeliveryCharge);
        this.formdata.set('bulkShipment[status]', this.newStatus);
        this.formdata.set('shipping_items', JSON.stringify(this.newBulkShipmentProducts))
        axios.post(`api/bulkShipments.json`, this.formdata)
        .then(res => {
          this.bulkShipments.push(res.data)
          this.$refs.createForm.reset()
        })
        .catch(res => { 
          alert("セット商品のID(CODE)が間違っています。")
         })
      },
      searchBulkShipments(){
        axios.get(`api/bulkShipments.json/?search_keyword=${this.searchKeyword}`)
        .then(res => {
          this.bulkShipments = res.data;
          console.log(res.data)
        });
      },
      downloadBulkShipments(){
        axios.get(`api/bulkShipments.csv/?search_keyword=${this.searchKeyword}`)
        .then(res => {
          console.log(res)
        })
      },
      toggle: function(index){
        this.bulkShipments[index].flag = (this.bulkShipments[index].flag ? false : true )
      },
      toggleCreateBulkShipment: function(index){
        this.createNewBulkShipmentFlag = (this.createNewBulkShipmentFlag ? false : true )
        this.createNewSetBulkShipmentFlag = false
        this.importBulkShipmentsFlag = false
        this.formdata = new FormData
      },
      toggleImportBulkShipments: function(index){
        this.importBulkShipmentsFlag = (this.importBulkShipmentsFlag ? false : true )
        this.createNewSetBulkShipmentFlag = false
        this.createNewBulkShipmentFlag = false
        this.formdata = new FormData
      },
      toggleIndexBulkShipment: function(index){
        this.indexBulkShipmentFlag = (this.indexBulkShipmentFlag ? false : true )
      },
      updateBulkShipment(obj){
        this.formdata = new FormData
        for(let shipping_item of obj.shipping_items){
          shipping_item.delivery_agent_id = shipping_item.delivery_agent.id
        }
        this.formdata.set('bulkShipment[id]', obj.id);
        this.formdata.set('bulkShipment[customer_name]', obj.customer_name);
        this.formdata.set('bulkShipment[postal_code]', obj.postal_code);
        this.formdata.set('bulkShipment[prefecture]', obj.prefecture);
        this.formdata.set('bulkShipment[address]', obj.address);
        this.formdata.set('bulkShipment[phone_number]', obj.phone_number);
        this.formdata.set('bulkShipment[bulkShipment_number]', obj.bulkShipment_number);
        this.formdata.set('bulkShipment[platform_id]', obj.platform.id);// plaftform を platform_idとしている
        this.formdata.set('bulkShipment[delivery_charge]', obj.delivery_charge);
        this.formdata.set('bulkShipment[status]', obj.status);
        this.formdata.set('shipping_items', JSON.stringify(obj.shipping_items))
        axios.patch(`api/bulkShipments/${obj.id}.json`, this.formdata)
        .then(res => {
          var num = this.bulkShipments.findIndex(function(bulkShipment){
            if (bulkShipment.id === res.data.id) { return true }
          })
          this.bulkShipments[num] = res.data
          this.editBulkShipmentFlag = false
        });
      },
      updateBulkShipmentMemo(obj){
        this.formdata = new FormData
        if (obj.memo.id) {  /// update
          this.formdata.set('memo[id]', obj.memo.id );
          this.formdata.set('memo[content]', obj.memo.content);
          axios.patch(`api/bulkShipment_memos/${obj.memo.id}`, this.formdata)
          .then(res => {
          });
        } else {  /// create
          this.formdata.set('bulkShipment[id]', obj.id );
          this.formdata.set('memo[content]', obj.memo.content);
          axios.post(`api/bulkShipment_memos/`, this.formdata)
          .then(res => {
          });
        }
      },
      deleteBulkShipment(obj){ /// 要修正
        if (window.confirm("本当にこの注文を削除しますか?") === false ){ return true }
        this.formdata = new FormData
        axios.delete (`api/bulkShipments/${obj.id}.json`, this.formdata)
        .then(res => {
          var num = this.bulkShipments.findIndex(function(bulkShipment){
            if (bulkShipment.id === res.data.id) { return true }
          })
          this.bulkShipments.splice(num,1)
        });
      },
      importBulkShipment(file) {
        this.formdata = new FormData
        this.formdata.append('csv', file)
        if ( file === null){
          return false
        };
        axios.post(`api/bulkShipments/import`, this.formdata)
        .then(res => {
        });
        this.$refs.importBulkShipmentsForm.reset();
      },
      addSetBulkShipment(){
        this.newBulkShipmentProducts.push({product_id: "", quantity: 1, price: 0 })
      },
      deleteSetBulkShipment(){
        this.newBulkShipmentProducts.pop()
      },
      hideAlert(){
        window.setInterval(() => {
          this.alert = false;
        }, 3000)
      },
      addShippingItem(bulkShipment){
        console.log(bulkShipment)
        bulkShipment.shipping_items.push({product_id: "", quantity: 1, price: 0})
      },
      deleteShippingItem(bulkShipment){
        if (window.confirm("本当にこの商品を削除しますか?") === false ){ return true }
        var item = bulkShipment.shipping_items.pop()
        this.formdata = new FormData
        axios.delete (`api/shipping_items/${item.id}.json`, this.formdata)
        .then(res => { //要変更
          //var num = this.bulkShipments.findIndex(function(bulkShipment){
          // if (bulkShipment.id === res.data.id) { return true }
          //})
          //this.bulkShipments.splice(num,1)
        });
      },
      shippingItem(bulkShipment, shipping_item){
        if (shipping_item.is_sent === true){
          if (window.confirm("本当にこの発送を取り消しますか?") === false ){ return true }
          shipping_item.is_sent = false; 
        } else {
          shipping_item.is_sent = true; 
        }
        this.updateBulkShipment(bulkShipment)
      },
    }
  }
</script>
<style scoped>
  .v-list:nth-child(even){
    background: #eee;
  }
</style>