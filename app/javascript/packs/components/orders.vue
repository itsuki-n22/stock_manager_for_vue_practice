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
            <v-icon v-on:click="toggleIndexOrder" > mdi-format-list-text  </v-icon>
            <v-icon left v-on:click="toggleCreateOrder"> mdi-card-plus </v-icon>
            <v-icon v-on:click="toggleImportOrders" > mdi-file-upload  </v-icon>
            <v-icon v-on:click="downloadOrders" > mdi-file-download  </v-icon>
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
                      <v-text-field v-model="searchKeyword" label="検索" @change="searchOrders"> 
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
    <v-form ref="importOrdersForm">
      <v-container v-if="importOrdersFlag === true">
        <h2> CSVで注文登録 </h2>
        <v-row>
          <v-col cols="12" md="2">
            <v-file-input
              truncate-length="5"
              accept=".csv"
              label="File input" @change="importOrder"
            ></v-file-input>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    -->
    <v-form ref="createForm">
      <v-container v-if="createNewOrderFlag === true">
        <h2> 注文の登録 </h2>
        <v-row>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="order_id" v-model='newOrderNumber'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select item-text="name" item-value="id" :items="platforms" label="platform" v-model='newPlatform'></v-select></v-col>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="postal_code" v-model='newPostalCode'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select return-object item-text="label" item-value="value" :items="prefectures" label="prefecture" v-model='newPrefecture'></v-select></v-col>
          <v-col cols="12" md="4"><v-text-field :rules="nameRules" label="address" v-model='newAddress'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="customer_name" v-model='newCustomerName'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="phone_number" v-model='newPhoneNumber'></v-text-field></v-col>
          <v-col cols="12" md="1"><v-text-field  label="delivery_cost" v-model='newDeliveryCharge'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select return-object item-text="label" item-value="value" :items="status" label="status" v-model='newStatus'></v-select></v-col>
          <v-col cols="12" md="1">
            <v-btn class="mr-4" @click="createSetOrder" color="primary"><v-icon>mdi-plus</v-icon></v-btn>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="2" v-for="(newOrderProduct, index) in newOrderProducts">
            <v-text-field
              v-model="newOrderProduct.product_id"
              label="product_id"
              :rules="nameRules"
            ></v-text-field>
            <v-text-field
              v-model="newOrderProduct.price"
              label="price"
            ></v-text-field>
            <v-text-field
              v-model="newOrderProduct.quantity"
              label="quantity"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="1">
            <v-btn class="mt-4" @click="addSetOrder" ><v-icon>mdi-plus</v-icon></v-btn>
            <v-btn class="mt-4" @click="deleteSetOrder" ><v-icon>mdi-minus</v-icon></v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <div v-if="indexOrderFlag === true">
      <v-list v-for="(order, index) in orders" v-bind:key="order.id">
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col cols="12" md="2"><v-text-field @change='updateOrder(order)' label="order_id" v-model='order.order_number'></v-text-field></v-col>
                <v-col cols="12" md="2"><v-select return-object item-text="name" item-value="id" @change='updateOrder(order)' :items="platforms" label="platform" v-model='order.platform'></v-select></v-col>
                <v-col v-if="order.flag" cols="12" md="2"><v-text-field @change='updateOrder(order)' label="postal_code" v-model='order.postal_code'></v-text-field></v-col>
                <v-col v-if="order.flag" cols="12" md="2"><v-select return-object item-text="label" item-value="value" @change='updateOrder(order)' :items="prefectures" label="prefecture" v-model='order.prefecture'></v-select></v-col>
                <v-col v-if="order.flag" cols="12" md="4"><v-text-field @change='updateOrder(order)' label="address" v-model='order.address'></v-text-field></v-col>
                <v-col cols="12" md="2"><v-text-field @change='updateOrder(order)' label="customer_name" v-model='order.customer_name'></v-text-field></v-col>
                <v-col v-if="order.flag" cols="12" md="2"><v-text-field @change='updateOrder(order)' label="phone_number" v-model='order.phone_number'></v-text-field></v-col>
                <v-col v-if="order.flag" cols="12" md="1"><v-text-field @change='updateOrder(order)' label="delivery_cost" v-model='order.delivery_charge'></v-text-field></v-col>
                <v-col cols="12" md="2"><v-select return-object item-text="label" item-value="value" @change='updateOrder(order)' :items="status" label="status" v-model='order.status'></v-select></v-col>
                <v-col v-if="order.flag" cols="12" md="4"><v-text-field label="memo" @change='updateOrderMemo(order)' v-model='order.memo.content'></v-text-field></v-col>
                <v-col v-if="order.flag === false" cols="12" md="3"><v-text-field label="memo" @change='updateOrderMemo(order)' v-model='order.memo.content'></v-text-field></v-col>
                <v-col cols="12" md="1">
                  <v-btn class="mt-4" color="" @click="toggle(index)"><v-icon> mdi-account-box </v-icon></v-btn>
                  <v-btn v-if="order.flag" class="mt-4" color="error" @click="deleteOrder(order)"><v-icon> mdi-delete </v-icon></v-btn>
                </v-col>

              </v-row>
              <v-row align="center" v-for="(shipping_item, index) in order.shipping_items" v-bind:key="shipping_item.id">
                <v-col cols="6" md="1">
                    <v-img size="80" :src="shipping_item.first_image_url"></v-img>
                </v-col>
                <v-col cols="6" md="3">
                  <v-text-field label="product_id" @change='updateOrder(order)' v-model='shipping_item.product_id'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-text-field label="price" @change='updateOrder(order)' v-model='shipping_item.price'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-text-field label="quantity" @change='updateOrder(order)' v-model='shipping_item.quantity'></v-text-field>
                </v-col>
                <v-col cols="6" md="2">
                  <v-select return-object @change='updateOrder(order)' :items="deliveryAgents" item-text="name" item-value="id" label="delivery_agent" v-model='shipping_item.delivery_agent'></v-select>
                </v-col>
                <v-col cols="6" md="2">
                  <v-text-field label="tracking_number" @change='updateOrder(order)' v-model='shipping_item.tracking_number'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-btn class="" @click="shippingItem(order, shipping_item)" v-if="shipping_item.is_sent === true" color="" ><v-icon>mdi-undo</v-icon></v-btn>
                  <v-btn class="" @click="shippingItem(order, shipping_item)" v-if="shipping_item.is_sent !== true" color="primary" ><v-icon>mdi-truck</v-icon></v-btn>
                </v-col>
                <v-col cols="3" md="1" v-if="order.shipping_items.length === index + 1 ">
                  <v-btn class="mt-4" @click="addShippingItem(order)" ><v-icon>mdi-plus</v-icon></v-btn>
                  <v-btn class="mt-4" v-if="index !== 0" @click="deleteShippingItem(order)" ><v-icon>mdi-minus</v-icon></v-btn>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
          <v-list-item-action>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </div>
    <!-- 
    <v-container>
      <v-row justify="center">
        <v-dialog v-model="editOrderFlag" max-width="800px">
          <v-card>
            <v-card-title>
              <span class="headline">Edit Order</span>
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
                  <v-col v-for="(set_order,index) in editSetOrders" cols="4" v-bind:key="index">
                    <v-text-field label="set_item" v-model='set_order["code"]'></v-text-field>
                    <v-text-field label="quantity" v-model='set_order["quantity"]'></v-text-field>
                  </v-col>
                  <v-col cols="12" md="1">
                    <v-btn class="mt-4" @click="addEditSetOrder" ><v-icon>mdi-plus</v-icon></v-btn>
                    <v-btn class="mt-4" @click="deleteEditSetOrder" ><v-icon>mdi-minus</v-icon></v-btn>
                  </v-col>
                </v-row>
              </v-container>
              <small>*必須</small>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="editOrderFlag = false">cancel</v-btn>
              <v-btn class="mr-4" @click="updateOrder" color="primary">更新</v-btn>
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
        orders: [],
        formdata: new FormData,
        searchKeyword: "",
        searchStatus: "発送待ち",
        searchTarget: "注文情報",
        newCustomerName: "",
        newPostalCode: "",
        newPrefecture: "",
        newAddress: "",
        newPhoneNumber: "",
        newOrderNumber: "",
        newPlatform: "不明",
        newDeliveryCharge: 598,
        newStatus: "注文直後",
        editOrderId: "",
        editPrice: "",
        editName: "",
        editExplain: "",
        editSKU: "",
        editASIN: "",
        editCarId: "",
        editOtherId: "",
        editCode: "",
        editSetOrders: [],
        editIsSetFlag: false,
        indexOrderFlag: true,
        editOrderFlag: false,
        createNewOrderFlag: false,
        newOrderProducts: [ {product_id: "", quantity: 1, price: 0 }],
        createNewSetOrderFlag: false,
        importOrdersFlag: false,
        nameRules: [
          v => !!v || '入力してください',
          v => (v && v.length <= 50) || '50文字以下でお願いします。',
        ],
      }
    },
    mounted(){
      axios.get(`api/orders.json`)
      .then(res => {
        this.orders = res.data;
        console.log(res)
      });
      axios.get(`api/platforms.json`)
      .then(res => {
        this.platforms = res.data;
        console.log(this.platforms)
      });
      axios.get(`api/delivery_agents.json`)
      .then(res => {
        this.deliveryAgents = res.data
        console.log(res.data)
      });
      this.hideAlert()
    },
    methods: {
      createOrder(){
        if (!this.$refs.form.validate()){
          return false
        };
        this.formdata.set('order[code]', this.newCode);
        this.formdata.set('order[name]', this.newName);
        this.formdata.set('order[price]', this.newPrice);
        this.formdata.set('order[is_set]', false);
        let config = {
          headers: {
            'content-type': 'multipart/form-data'
          }
        };
        axios.post(`api/orders/`, this.formdata, config)
        .then(res => {
          this.orders.push(res.data)
          this.$refs.form.reset()
        });
      },
      createSetOrder(){ // TODO change name
        if (!this.$refs.createForm.validate()){
          return false
        };
        this.formdata = new FormData
        this.formdata.set('order[customer_name]', this.newCustomerName);
        this.formdata.set('order[postal_code]', this.newPostalCode);
        this.formdata.set('order[prefecture]', this.newPrefecture);
        this.formdata.set('order[address]', this.newAddress);
        this.formdata.set('order[phone_number]', this.newPhoneNumber);
        this.formdata.set('order[order_number]', this.newOrderNumber);
        this.formdata.set('order[platform_id]', this.newPlatform);// plaftform を platform_idとしている
        this.formdata.set('order[delivery_charge]', this.newDeliveryCharge);
        this.formdata.set('order[status]', this.newStatus);
        this.formdata.set('shipping_items', JSON.stringify(this.newOrderProducts))
        axios.post(`api/orders.json`, this.formdata)
        .then(res => {
          this.orders.push(res.data)
          this.$refs.createForm.reset()
        })
        .catch(res => { 
          alert("セット商品のID(CODE)が間違っています。")
         })
      },
      searchOrders(){
        axios.get(`api/orders.json/?search_keyword=${this.searchKeyword}`)
        .then(res => {
          this.orders = res.data;
          console.log(res.data)
        });
      },
      downloadOrders(){
        axios.get(`api/orders.csv/?search_keyword=${this.searchKeyword}`)
        .then(res => {
          console.log(res)
        })
      },
      toggle: function(index){
        this.orders[index].flag = (this.orders[index].flag ? false : true )
      },
      toggleCreateOrder: function(index){
        this.createNewOrderFlag = (this.createNewOrderFlag ? false : true )
        this.createNewSetOrderFlag = false
        this.importOrdersFlag = false
        this.formdata = new FormData
      },
      toggleImportOrders: function(index){
        this.importOrdersFlag = (this.importOrdersFlag ? false : true )
        this.createNewSetOrderFlag = false
        this.createNewOrderFlag = false
        this.formdata = new FormData
      },
      toggleIndexOrder: function(index){
        this.indexOrderFlag = (this.indexOrderFlag ? false : true )
      },
      updateOrder(obj){
        this.formdata = new FormData
        for(let shipping_item of obj.shipping_items){
          shipping_item.delivery_agent_id = shipping_item.delivery_agent.id
        }
        this.formdata.set('order[id]', obj.id);
        this.formdata.set('order[customer_name]', obj.customer_name);
        this.formdata.set('order[postal_code]', obj.postal_code);
        this.formdata.set('order[prefecture]', obj.prefecture);
        this.formdata.set('order[address]', obj.address);
        this.formdata.set('order[phone_number]', obj.phone_number);
        this.formdata.set('order[order_number]', obj.order_number);
        this.formdata.set('order[platform_id]', obj.platform.id);// plaftform を platform_idとしている
        this.formdata.set('order[delivery_charge]', obj.delivery_charge);
        this.formdata.set('order[status]', obj.status);
        this.formdata.set('shipping_items', JSON.stringify(obj.shipping_items))
        axios.patch(`api/orders/${obj.id}.json`, this.formdata)
        .then(res => {
          var num = this.orders.findIndex(function(order){
            if (order.id === res.data.id) { return true }
          })
          this.orders[num] = res.data
          this.editOrderFlag = false
        });
      },
      updateOrderMemo(obj){
        this.formdata = new FormData
        if (obj.memo.id) {  /// update
          this.formdata.set('memo[id]', obj.memo.id );
          this.formdata.set('memo[content]', obj.memo.content);
          axios.patch(`api/order_memos/${obj.memo.id}`, this.formdata)
          .then(res => {
          });
        } else {  /// create
          this.formdata.set('order[id]', obj.id );
          this.formdata.set('memo[content]', obj.memo.content);
          axios.post(`api/order_memos/`, this.formdata)
          .then(res => {
          });
        }
      },
      deleteOrder(obj){ /// 要修正
        if (window.confirm("本当にこの注文を削除しますか?") === false ){ return true }
        this.formdata = new FormData
        axios.delete (`api/orders/${obj.id}.json`, this.formdata)
        .then(res => {
          var num = this.orders.findIndex(function(order){
            if (order.id === res.data.id) { return true }
          })
          this.orders.splice(num,1)
        });
      },
      importOrder(file) {
        this.formdata = new FormData
        this.formdata.append('csv', file)
        if ( file === null){
          return false
        };
        axios.post(`api/orders/import`, this.formdata)
        .then(res => {
        });
        this.$refs.importOrdersForm.reset();
      },
      addSetOrder(){
        this.newOrderProducts.push({product_id: "", quantity: 1, price: 0 })
      },
      deleteSetOrder(){
        this.newOrderProducts.pop()
      },
      hideAlert(){
        window.setInterval(() => {
          this.alert = false;
        }, 3000)
      },
      addShippingItem(order){
        console.log(order)
        order.shipping_items.push({product_id: "", quantity: 1, price: 0})
      },
      deleteShippingItem(order){
        if (window.confirm("本当にこの商品を削除しますか?") === false ){ return true }
        var item = order.shipping_items.pop()
        this.formdata = new FormData
        axios.delete (`api/shipping_items/${item.id}.json`, this.formdata)
        .then(res => { //要変更
          //var num = this.orders.findIndex(function(order){
          // if (order.id === res.data.id) { return true }
          //})
          //this.orders.splice(num,1)
        });
      },
      shippingItem(order, shipping_item){
        if (shipping_item.is_sent === true){
          if (window.confirm("本当にこの発送を取り消しますか?") === false ){ return true }
          shipping_item.is_sent = false; 
        } else {
          shipping_item.is_sent = true; 
        }
        this.updateOrder(order)
      },
    }
  }
</script>
<style scoped>
  .v-list:nth-child(even){
    background: #eee;
  }
</style>