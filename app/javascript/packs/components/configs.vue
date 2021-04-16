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
      <v-container class="text-center ma-3">
        <v-row>
          <v-col cols="2">
            <v-icon v-on:click="toggleStockPlace" > mdi-map-marker  </v-icon>
          </v-col>
          <v-col cols="2">
            <v-icon v-on:click="togglePlatform" > mdi-shopping  </v-icon>
          </v-col>
          <v-col cols="2">
            <v-icon v-on:click="toggleAliasIdKind" > mdi-barcode  </v-icon>
          </v-col>
          <v-col cols="2">
            <v-icon v-on:click="toggleDeliveryAgent" > mdi-truck  </v-icon>
          </v-col>
        </v-row>
      </v-container>
    </div>

    <div v-if="stockPlaceFlag === true">
      <h3 class="text-center ma-3">在庫場所</h3>
      <v-list >
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col v-for="(stockPlace, index) in hasQuantityStockPlaces" v-bind:key="stockPlace.id" cols="12" md="2">
                  <v-text-field @change='updateStockPlace(stockPlace)' label="場所" v-model='stockPlace.name'></v-text-field>
                </v-col>
                <v-spacer></v-spacer>
                <v-col cols="8" md="2"><v-form ref="createStockPlaceForm"><v-text-field outlined :rules=nameRules label="場所の追加" v-model='newStockPlaceName[true]'></v-text-field></v-form></v-col>
                <v-col cols="4" md="2">
                  <v-btn color="primary" @click='createStockPlace(true)'><v-icon>mdi-plus</v-icon></v-btn>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
        </v-list-item>
      </v-list>
      <h3 class="text-center ma-3">発送元/発送先</h3>
      <v-list >
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col v-for="(stockPlace, index) in notHasQuantityStockPlaces" v-bind:key="stockPlace.id" cols="12" md="2">
                  <v-text-field @change='updateStockPlace(stockPlace)' label="場所" v-model='stockPlace.name'></v-text-field>
                </v-col>
                <v-spacer></v-spacer>
                <v-col cols="8" md="2"><v-form ref="createStockPlaceFormWithoutQuantity"><v-text-field outlined :rules=nameRules label="場所の追加" v-model='newStockPlaceName[false]'></v-text-field></v-form></v-col>
                <v-col cols="4" md="2">
                  <v-btn color="primary" @click='createStockPlace(false)'><v-icon>mdi-plus</v-icon></v-btn>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </div>

    <div v-if="platformFlag === true">
      <h3 class="text-center ma-3">販売場所一覧</h3>
      <v-list >
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col v-for="(platform, index) in platforms" v-bind:key="platform.id" cols="12" md="6">
                  <v-row>
                    <v-col cols="12" md="5">
                      <v-text-field @change='updatePlatform(platform)' label="場所" v-model='platform.name'></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                      <v-text-field @change='updatePlatform(platform)' label="商品URL BASE" v-model='platform.url'></v-text-field>
                    </v-col>
                  </v-row>
                </v-col>
                <v-col cols="12" md="6">
                  <v-form ref="createPlatformForm">
                    <v-row>
                      <v-col cols="6" md="5">
                        <v-text-field outlined label="新規場所" v-model='newPlatformName'></v-text-field>
                      </v-col>
                      <v-col cols="6" md="5">
                        <v-text-field outlined label="URL BASE" v-model='newPlatformURL'></v-text-field>
                      </v-col>
                      <v-col cols="12" md="2">
                        <v-btn color="primary" @click='createPlatform()'><v-icon>mdi-plus</v-icon></v-btn>
                      </v-col>
                    </v-row>
                  </v-form>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </div>

    <div v-if="deliveryAgentFlag === true">
      <h3 class="text-center ma-3">配送業者一覧</h3>
      <v-list >
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col v-for="(deliveryAgent, index) in deliveryAgents" v-bind:key="deliveryAgent.id" cols="12" md="6">
                  <v-row>
                    <v-col cols="12" md="5">
                      <v-text-field @change='updateDeliveryAgent(deliveryAgent)' label="業者名" v-model='deliveryAgent.name'></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                      <v-text-field @change='updateDeliveryAgent(deliveryAgent)' label="URL BASE" v-model='deliveryAgent.track_url'></v-text-field>
                    </v-col>
                  </v-row>
                </v-col>
                <v-col cols="12" md="6">
                  <v-form ref="createDeliveryAgentForm">
                    <v-row>
                      <v-col cols="6" md="5">
                        <v-text-field outlined label="新規業者名" v-model='newDeliveryAgentName'></v-text-field>
                      </v-col>
                      <v-col cols="6" md="5">
                        <v-text-field outlined label="URL BASE" v-model='newDeliveryAgentURL'></v-text-field>
                      </v-col>
                      <v-col cols="12" md="2">
                        <v-btn color="primary" @click='createDeliveryAgent()'><v-icon>mdi-plus</v-icon></v-btn>
                      </v-col>
                    </v-row>
                  </v-form>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </div>

    <div v-if="aliasIdKindFlag === true">
      <h3 class="text-center ma-3">商品ID一覧</h3>
      <v-list >
        <v-list-item>
          <v-list-item-content>
            <v-container>
              <v-row align="center" >
                <v-col v-for="(aliasIdKind, index) in aliasIdKinds" v-bind:key="aliasIdKind.id" cols="12" md="6">
                  <v-row>
                    <v-col cols="12" md="5">
                      <v-text-field @change='updateAliasIdKind(aliasIdKind)' label="名前" v-model='aliasIdKind.name'></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6">
                      <v-text-field @change='updateAliasIdKind(aliasIdKind)' label="URL BASE" v-model='aliasIdKind.url'></v-text-field>
                    </v-col>
                  </v-row>
                </v-col>
                <v-col cols="12" md="6">
                  <v-form ref="createAliasIdKindForm">
                    <v-row>
                      <v-col cols="6" md="5">
                        <v-text-field outlined label="新しいID" v-model='newAliasIdKindName'></v-text-field>
                      </v-col>
                      <v-col cols="6" md="5">
                        <v-text-field outlined label="URL BASE" v-model='newAliasIdKindURL'></v-text-field>
                      </v-col>
                      <v-col cols="12" md="2">
                        <v-btn color="primary" @click='createAliasIdKind()'><v-icon>mdi-plus</v-icon></v-btn>
                      </v-col>
                    </v-row>
                  </v-form>
                </v-col>
              </v-row>
            </v-container>
          </v-list-item-content>
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
        alert: false,
        platforms: [],
        stockPlaces: [],
        deliveryAgents: [],
        aliasIdKinds: [],

        formdata: new FormData,
        newAliasIdKindName: "",
        newAliasIdKindURL: "",
        newAliasIdKindCode: "",
        newDeliveryAgentCode: "",
        newDeliveryAgentName: "",
        newDeliveryAgentURL: "",
        newStockPlaceURL: "",
        newStockPlaceName: {true: "", false: ""},
        newPlatformName: "",
        newPlatformURL: "",

        aliasIdKindFlag: false,
        deliveryAgentFlag: true,
        stockPlaceFlag: false,
        platformFlag: false,

        nameRules: [
          v => !!v || '入力してください',
          v => (v && v.length <= 50) || '50文字以下でお願いします。',
        ],
      }
    },
    mounted(){
      this.hideAlert()
      axios.get(`api/stock_places.json`)
      .then(res => {
        this.stockPlaces = res.data
        console.log(res.data)
      })
      axios.get(`api/delivery_agents.json`)
      .then(res => {
        this.deliveryAgents = res.data
        console.log(res.data)
      })
      axios.get(`api/platforms.json`)
      .then(res => {
        this.platforms = res.data
        console.log(res.data)
      })
      axios.get(`api/alias_id_kinds.json`)
      .then(res => {
        this.aliasIdKinds = res.data
        console.log(res.data)
      })

    },
    computed: {
      hasQuantityStockPlaces: function(){
        return  this.stockPlaces.filter(function(obj){
          if (obj.has_quantity){return obj}
        })
      },
      notHasQuantityStockPlaces: function(){
        return  this.stockPlaces.filter(function(obj){
          if (obj.has_quantity === false){return obj}
        })
      }
    },
    methods: {
      createStockPlace: function(flag){
        if (!this.$refs.createStockPlaceForm.validate() && flag ){
          return false
        } else if (!this.$refs.createStockPlaceFormWithoutQuantity.validate() && !flag ){
          return false
        };
        this.formdata = new FormData
        this.formdata.set('stock_place[name]', this.newStockPlaceName[flag]);
        this.formdata.set('stock_place[has_quantity]', flag);
        axios.post(`api/stock_places.json`, this.formdata)
        .then(res => {
          this.stockPlaces.push(res.data)
          this.$refs.createStockPlaceForm.reset()
          this.$refs.createStockPlaceFormWithoutQuantity.reset()
          console.log(res.data)
        });
      },
      updateStockPlace: function(stockPlace){
        this.formdata = new FormData
        this.formdata.set('stock_place[name]', stockPlace.name);
        this.formdata.set('stock_place[id]', stockPlace.id);
        axios.patch(`api/stock_places/${stockPlace.id}.json`, this.formdata)
        .then(res => {
          this.$refs.createStockPlaceForm.reset()
        });
      },

      createPlatform: function(){
        this.formdata = new FormData
        this.formdata.set('platform[name]', this.newPlatformName);
        this.formdata.set('platform[url]', this.newPlatformURL);
        axios.post(`api/platforms.json`, this.formdata)
        .then(res => {
          this.platforms.push(res.data)
          this.$refs.createPlatformForm.reset()
          console.log(res.data)
        });
      },
      updatePlatform: function(platform){
        this.formdata = new FormData
        this.formdata.set('platform[name]', platform.name);
        this.formdata.set('platform[url]', platform.url);
        this.formdata.set('platform[id]', platform.id);
        axios.patch(`api/platforms/${platform.id}.json`, this.formdata)
        .then(res => {
        });
      },

      createAliasIdKind: function(){
        this.formdata = new FormData
        this.formdata.set('alias_id_kind[name]', this.newAliasIdKindName);
        this.formdata.set('alias_id_kind[url]', this.newAliasIdKindURL);
        this.formdata.set('alias_id_kind[code]', this.newAliasIdKindName);
        axios.post(`api/alias_id_kinds.json`, this.formdata)
        .then(res => {
          this.aliasIdKinds.push(res.data)
          this.$refs.createAliasIdKindForm.reset()
          console.log(res.data)
        });
      },
      updateAliasIdKind: function(alias_id_kind){
        this.formdata = new FormData
        this.formdata.set('alias_id_kind[name]', alias_id_kind.name);
        this.formdata.set('alias_id_kind[url]', alias_id_kind.url);
        this.formdata.set('alias_id_kind[code]', alias_id_kind.code);
        this.formdata.set('alias_id_kind[id]', alias_id_kind.id);
        axios.patch(`api/alias_id_kinds/${alias_id_kind.id}.json`, this.formdata)
        .then(res => {
        });
      },

      createDeliveryAgent: function(){
        this.formdata = new FormData
        this.formdata.set('delivery_agent[name]', this.newDeliveryAgentName);
        this.formdata.set('delivery_agent[track_url]', this.newDeliveryAgentURL);
        axios.post(`api/delivery_agents.json`, this.formdata)
        .then(res => {
          this.deliveryAgents.push(res.data)
          this.$refs.createDeliveryAgentForm.reset()
          console.log(res.data)
        });
      },
      updateDeliveryAgent: function(delivery_agent){
        this.formdata = new FormData
        this.formdata.set('delivery_agent[name]', delivery_agent.name);
        this.formdata.set('delivery_agent[track_url]', delivery_agent.track_url);
        this.formdata.set('delivery_agent[id]', delivery_agent.id);
        axios.patch(`api/delivery_agents/${delivery_agent.id}.json`, this.formdata)
        .then(res => {
        });
      },

      toggleAliasIdKind: function(){
        this.aliasIdKindFlag = (this.aliasIdKindFlag ? false : true )
        this.deliveryAgentFlag = false
        this.platformFlag = false
        this.stockPlaceFlag = false
      },
      toggleDeliveryAgent: function(){
        this.deliveryAgentFlag = (this.deliveryAgentFlag ? false : true )
        this.aliasIdKindFlag = false
        this.platformFlag = false
        this.stockPlaceFlag = false
      },
      togglePlatform: function(){
        this.platformFlag = (this.platformFlag ? false : true )
        this.aliasIdKindFlag = false
        this.deliveryAgentFlag = false
        this.stockPlaceFlag = false
      },
      toggleStockPlace: function(){
        this.stockPlaceFlag = (this.stockPlaceFlag ? false : true )
        this.aliasIdKindFlag = false
        this.deliveryAgentFlag = false
        this.platformFlag = false
      },

      hideAlert(){
        window.setInterval(() => {
          this.alert = false;
        }, 3000)
      },

    }
  }
</script>
<style scoped>
  .col-12:nth-child(even){
  }
</style>