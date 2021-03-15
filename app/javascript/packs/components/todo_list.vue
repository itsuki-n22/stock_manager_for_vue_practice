<template>
  <div>
    <v-form ref="form">
      <v-icon left v-on:click="toggleCreateTodo"> mdi-pencil </v-icon>
      <v-container v-if="createNewTodoFlag === true">
        <v-row>
          <v-col
            cols="12"
            md="4"
          >
            <v-text-field
              v-model="newTitle"
              label="title"
              :rules="nameRules"
              required
            ></v-text-field>
          </v-col>
          <v-col
            cols="12"
            md="7"
          >
            <v-text-field
              v-model="newBody"
              label="body"
            ></v-text-field>
          </v-col>
          <v-col
            cols="12"
            md="1"
          >
            <v-btn
              class="mr-4"
              @click="createTodo"
            >
              submit
            </v-btn>
          </v-col>

        </v-row>
      </v-container>
    </v-form>
    <v-icon v-on:click="toggleIndexTodo" > mdi-format-list-text  </v-icon>
    <v-list v-if="indexTodoFlag === true">
      <v-list v-for="(todo,index) in todos" v-bind:key="todo.id">
        <v-list-item v-on:click="toggle(index)">
          <v-list-item-content>
            <v-list-item-title>
            {{ todo.title }} 
            </v-list-item-title>
            <v-list-item-subtitle v-if="todo.flag === true "> {{ todo.body }} </v-list-item-subtitle>
          </v-list-item-content>
          <v-list-item-content>
            <v-icon v-on:click="deleteTodo(todo)"> mdi-delete</v-icon>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-list>
  </div>
</template>
<script>
  import axios from 'axios';
  axios.defaults.baseURL = '../';
  export default {
    data () {
      return {
        user_id: location.pathname.split("/")[2],
        todos: [],
        newTitle: "",
        newBody: "",
        createNewTodoFlag: false,
        indexTodoFlag: true,
        nameRules: [
          v => !!v || '入力してください',
          v => (v && v.length <= 50) || '50文字以下でお願いします。',
        ],
      }
    },
    mounted(){
      axios.get(`api/todos/?user_id=${this.user_id}`)
      .then(res => {
        this.todos = res.data;
      });
    },
    methods: {
      createTodo(){
        if (!this.$refs.form.validate()){
          return false
        };
        axios.post(`api/todos/`, { user_id: this.user_id, title: this.newTitle, body: this.newBody })
        .then(res => {
          this.todos.push(res.data)
        });
      },
      getTodo(id){
        axios.get(`api/todos/?user_id=${hoge}`)
        .then(res => {
          this.title = res.data.title;
          this.body = res.data.body;
        });
      },
      toggle: function(index){
        this.todos[index].flag = (this.todos[index].flag ? false : true )
      },
      toggleCreateTodo: function(index){
        this.createNewTodoFlag = (this.createNewTodoFlag ? false : true )
      },
      toggleIndexTodo: function(index){
        this.indexTodoFlag = (this.indexTodoFlag ? false : true )
      },
      deleteTodo(obj){
        axios.delete(`api/todos/${obj.id}`)
        .then(res => {
          var num = this.todos.findIndex(function(todo){
            if (todo.id === res.data.id) { return true }
          })
          this.todos.splice(num,1)
          
        });
      },
    }
  }
</script>