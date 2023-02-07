#!/bin/bash

# Find the current directory
CURRENT_DIR="$(pwd)"

# Check if ./src is present
if [ -d "$CURRENT_DIR/src" ]; then
  # Delete App.vue if present
  if [ -f "$CURRENT_DIR/src/App.vue" ]; then
    rm "$CURRENT_DIR/src/App.vue"
  fi

  echo "<script>
import HomePage from '@/components/HomePage.vue'
export default {
  components: {
    HomePage
  },
  data() {
    return {
      
    }
  },
}
</script>

<template>
  <HomePage/>
</template>

<style scoped>
</style>" > "$CURRENT_DIR/src/App.vue"

  # Delete HelloWorld.vue if present
  if [ -f "$CURRENT_DIR/src/components/HelloWorld.vue" ]; then
    rm "$CURRENT_DIR/src/components/HelloWorld.vue"
  fi

  # Create a new HomePage.vue file
  echo "
<script >
import { useStore } from '@/store'
export default {
  name: 'HomePage',
  data() {
    return {
      text: 'Here we go!',
      store: useStore(),
    }
  },
}
</script>

<template>
 {{ text }}
 <br/>
 store msg: {{ this.store.msg }}
 <br/>
 store getter reversed(): {{ this.store.reversed }}
</template>

<style>
</style>" > "$CURRENT_DIR/src/components/HomePage.vue"

  # Delete logo.png if present
  if [ -f "$CURRENT_DIR/src/assets/logo.png" ]; then
    rm "$CURRENT_DIR/src/assets/logo.png"
  fi

  # Delete vite.svg if present
  if [ -f "$CURRENT_DIR/public/vite.svg" ]; then
    rm "$CURRENT_DIR/public/vite.svg"
  fi
  # Delete vue.svg if present
  if [ -f "$CURRENT_DIR/src/assets/vue.svg" ]; then
    rm "$CURRENT_DIR/src/assets/vue.svg"
  fi

  # Delete vite.config.js if present
  if [ -f "$CURRENT_DIR/vite.config.js" ]; then
    rm "$CURRENT_DIR/vite.config.js"
  fi

  # Create a new vite.config.js file
  echo 'import { fileURLToPath, URL } from "url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
});' > "$CURRENT_DIR/vite.config.js"

  # Delete main.js if present
  if [ -f "$CURRENT_DIR/src/main.js" ]; then
    rm "$CURRENT_DIR/src/main.js"
  fi

  # Create a new main.js file
  echo "import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
const pinia = createPinia()
const app = createApp(App)

app.use(pinia)
app.mount('#app')
" > "$CURRENT_DIR/src/main.js"

 # Create a pinia store file
 mkdir "$CURRENT_DIR/src/store"
 touch "$CURRENT_DIR/src/store/index.js"
  
    # Create a new index.js file
    echo "import { defineStore } from 'pinia'

export const useStore = defineStore('store', {
  state: () => ({
    msg: 'Hello from Pinia!',
  }),
  getters: {
    reversed(state) {
      return state.msg.split('').reverse().join('')
    },
  },
  actions: {
    changeMsg(newMsg) {
      this.msg = newMsg
    },
  },
})" > "$CURRENT_DIR/src/store/index.js"


else
  echo "No src directory found. You're not inside a Vue project folder."
fi


