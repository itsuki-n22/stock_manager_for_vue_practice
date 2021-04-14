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
                      <v-select item-text="name" item-value="name" :items="phases" label="状態" v-model='searchStatus'></v-select>
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
    <v-form ref="createForm">
      <v-container v-if="createNewBulkShipmentFlag === true">
        <h2> 発送の登録 </h2>
        <v-row>
          <v-col cols="12" md="2"><v-text-field :rules="nameRules" label="発送名" v-model='newName'></v-text-field></v-col>
          <v-col cols="12" md="2"><v-select item-text="name" item-value="id" :items="deliveryAgents" label="配送業者" v-model='newDeliveryAgent'></v-select></v-col>
          <v-col cols="6" md="2"><v-select item-text="name" item-value="id" :items="stockPlaces" label="出発地" v-model='newDeparture'></v-select></v-col>
          <v-col cols="6" md="2"><v-select item-text="name" item-value="id" :items="stockPlaces" label="到着地" v-model='newDestination'></v-select></v-col>
          <v-col cols="12" md="2"><v-text-field label="追跡番号 number" v-model='newTrackingNumber'></v-text-field></v-col>
          <v-col cols="6" md="1"><v-text-field  label="送料" v-model='newDeliveryCharge'></v-text-field></v-col>
          <v-col cols="6" md="1">
            <v-btn class="mr-4" @click="createBulkShipment" color="primary"><v-icon>mdi-plus</v-icon></v-btn>
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
                <v-col cols="12" md="4"><v-text-field @change='updateBulkShipment(bulkShipment)' label="bulkShipment_id" v-model='bulkShipment.name'></v-text-field></v-col>
                <v-col cols="6" md="2"><v-select item-text="name" item-value="id" :items="stockPlaces" label="出発地" v-model='bulkShipment.from'></v-select></v-col>
                <v-col cols="6" md="2"><v-select item-text="name" item-value="id" :items="stockPlaces" label="到着地" v-model='bulkShipment.to'></v-select></v-col>
                <v-col cols="12" md="2"><v-select item-text="name" item-value="id" @change='updateBulkShipment(bulkShipment)' :items="deliveryAgents" label="配送業者" v-model='bulkShipment.delivery_agent_id'></v-select></v-col>
                <v-col cols="12" md="2"><v-text-field @change='updateBulkShipment(bulkShipment)' label="追跡番号" v-model='bulkShipment.tracking_number'></v-text-field></v-col>

              </v-row>
              <v-row align="center" >
                <v-col cols="6" md="3">
                  <v-menu v-model="bulkShipment.ship_date_flag"
                    :close-on-content-click="false"
                    :nudge-right="40"
                    transition="scale-transition"
                    offset-y
                    min-width="auto"
                  >
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field
                        v-model="bulkShipment.ship_date"
                        label="発送日"
                        prepend-icon="mdi-calendar"
                        readonly
                        v-bind="attrs"
                        v-on="on"
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      no-title
                      v-model="bulkShipment.ship_date"
                      @input="bulkShipment.ship_date_flag = false"
                      @change="updateBulkShipment(bulkShipment)"
                    ></v-date-picker>
                  </v-menu>
                </v-col>
                <v-col cols="6" md="3">
                  <v-menu v-model="bulkShipment.arrived_date_flag"
                    :close-on-content-click="false"
                    :nudge-right="40"
                    transition="scale-transition"
                    offset-y
                    min-width="auto"
                  >
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field
                        v-model="bulkShipment.arrived_date"
                        label="到着日"
                        prepend-icon="mdi-calendar"
                        readonly
                        v-bind="attrs"
                        v-on="on"
                      ></v-text-field>
                    </template>
                    <v-date-picker
                      no-title
                      v-model="bulkShipment.arrived_date"
                      @input="bulkShipment.arrived_date_flag = false"
                      @change="updateBulkShipment(bulkShipment)"
                    ></v-date-picker>
                  </v-menu>
                </v-col>
                <v-col cols="3" md="2"><v-text-field @change='updateBulkShipment(bulkShipment)' label="送料" v-model='bulkShipment.delivery_charge'></v-text-field></v-col>
                <v-col cols="6" md="3"><v-select color="#BBDEFB" solo background-color="#BBDEFB" item-text="name" item-value="name" :items="phases" label="状態" v-model='bulkShipment.phase'></v-select></v-col>
                <v-col cols="3" md="1" mb-4>
                  <v-btn @click="toggle(index)"><v-icon> mdi-details </v-icon></v-btn>
                </v-col>

              </v-row>
              <v-row align="center" v-if="bulkShipment.flag">
                <v-col cols="12" md="2">
                  <h3>商品を追加する</h3>
                </v-col>
                <v-col cols="6" md="3">
                  <v-text-field label="product_id" v-model='bulkShipment["newProductId"]'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-text-field label="price" v-model='bulkShipment["newPrice"]'></v-text-field>
                </v-col>
                <v-col cols="3" md="1">
                  <v-text-field label="quantity" v-model='bulkShipment["newQuantity"]'></v-text-field>
                </v-col>
                <v-col cols="12" md="1">
                  <v-btn class="" @click="addShippingItem(bulkShipment)" color="primary" ><v-icon>mdi-plus</v-icon></v-btn>
                </v-col>
                <v-col cols="6" md="3">
                  <h3>この注文を削除する</h3>
                </v-col>
                <v-col cols="6" md="1">
                  <v-btn v-if="bulkShipment.flag" color="error" @click="deleteBulkShipment(bulkShipment)"><v-icon> mdi-delete </v-icon></v-btn>
                </v-col>
              </v-row>

              <v-row v-if="bulkShipment.flag"><v-col>
              <v-row align="center" v-for="(shipping_item, index) in bulkShipment.shipping_items" v-bind:key="shipping_item.id">
                <v-spacer />
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
                <v-col cols="3" md="1">
                  <v-btn class="mt-4" @click="deleteShippingItem(bulkShipment, shipping_item.id)" ><v-icon>mdi-delete</v-icon></v-btn>
                </v-col>
                <v-spacer />
              </v-row>
              </v-col></v-row>
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
        stockPlaces: [],
        phases: [],
        searchTargets: [
          "注文情報",  
          "商品・追跡番号",  
        ],
        deliveryAgents: [
        ],
        today: new Date().toISOString().substr(0, 10),
        alert: false,
        bulkShipments: [],
        formdata: new FormData,
        searchKeyword: "",
        searchStatus: "発送待ち",
        shipDateFlag: false,
        newDeparture: "",
        newDestination: "",
        newDeliveryAgent: "",
        newPostalCode: "",
        newName: "",
        newTrackingNumber: "",
        newBulkShipmentNumber: "",
        newPlatform: "不明",
        newDeliveryCharge: 0,
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
      axios.get(`api/bulk_shipments.json`)
      .then(res => { //TODO 要修正
        //let tmp = res.data
        //this.bulkShipments = Object.fromEntries(
        //  Object.entries(tmp)
        //  .map(([ key, val ]) => {
        //    if (key.match(/_date/) ){
        //      return [key, this.today]
        //    } else {
        //      return [key, val]
        //    }
        //  })
        //);
        this.bulkShipments = res.data
        console.log(this.bulkShipments)
        console.log(res.data)
      })
      axios.get(`api/bulk_shipments/phases.json`)
      .then(res => {
        this.phases = res.data.phases
        console.log(this.phases)
      })
      axios.get(`api/stock_places.json`)
      .then(res => {
        this.stockPlaces = res.data
      })
      axios.get(`api/delivery_agents.json`)
      .then(res => {
        this.deliveryAgents = res.data
      })
      console.log(this.stockPlaces)
    },
    methods: {
      createBulkShipment(){
        if (!this.$refs.createForm.validate()){
          return false
        };
        this.formdata = new FormData
        this.formdata.set('bulk_shipment[name]', this.newName);
        this.formdata.set('bulk_shipment[delivery_agent_id]', this.newDeliveryAgent);
        this.formdata.set('bulk_shipment[tracking_number]', this.newTrackingNumber);
        this.formdata.set('bulk_shipment[from]', this.newDeparture);
        this.formdata.set('bulk_shipment[delivery_charge]', this.newDeliveryCharge);
        this.formdata.set('bulk_shipment[to]', this.newDestination);
        axios.post(`api/bulk_shipments.json`, this.formdata)
        .then(res => {
          this.bulkShipments.push(res.data)
          this.$refs.createForm.reset()
          console.log(res.data)
        });
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
        console.log(obj)
        this.formdata = new FormData
        this.formdata.set('bulk_shipment[id]', obj.id);
        this.formdata.set('bulk_shipment[arrived_date]', obj.arrived_date);
        this.formdata.set('bulk_shipment[delivery_agent_id]', obj.delivery_agent_id); // TODO 要修正
        this.formdata.set('bulk_shipment[delivery_charge]', obj.delivery_charge);
        this.formdata.set('bulk_shipment[from]', obj.from);
        this.formdata.set('bulk_shipment[to]', obj.to);
        this.formdata.set('bulk_shipment[name]', obj.name);
        this.formdata.set('bulk_shipment[phase]', obj.phase);
        this.formdata.set('bulk_shipment[ship_date]', obj.ship_date);
        this.formdata.set('bulk_shipment[tracking_number]', obj.tracking_number);
        if (obj.shipping_items){
          this.formdata.set('shipping_items', JSON.stringify(obj.shipping_items))
        }
        axios.patch(`api/bulk_shipments/${obj.id}.json`, this.formdata)
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
        axios.delete (`api/bulk_shipments/${obj.id}.json`, this.formdata)
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
      addShippingItem(bulkShipment){ // TODO 同じ商品が重複しないように
        console.log(bulkShipment)
        if (!bulkShipment.shipping_items) {bulkShipment["shipping_items"] = []}
        bulkShipment.shipping_items.push({
          product_id: bulkShipment.newProductId,
          quantity: bulkShipment.newQuantity,
          price: bulkShipment.newPrice
        })
        this.updateBulkShipment(bulkShipment)
      },
      deleteShippingItem(bulkShipment, shipping_item_id){
        if (window.confirm("本当にこの商品を削除しますか?") === false ){ return true }
        this.formdata = new FormData
        axios.delete (`api/bulk_shipping_items/${shipping_item_id}.json`, this.formdata)
        .then(res => { 
          console.log(res.status)
          if (res.status === 204){
            var num = bulkShipment.shipping_items.findIndex(function(item){
              if (item.id === shipping_item_id) { return true }
            })
            bulkShipment.shipping_items.splice(num,1)
          }
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