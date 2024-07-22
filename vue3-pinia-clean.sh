#!/bin/bash

# Function to create a store
create_store() {
  local store_name="$1"
  local store_file_name="$CURRENT_DIR/src/store/$store_name.js"
  local store_var_name="use${store_name^}Store"

  echo "import { defineStore } from 'pinia'

export const $store_var_name = defineStore('$store_name', {
  state: () => ({
    what: '$store_name',
  }),
  getters: {
    reversed(state) {
      return state.what.split('').reverse().join('')
    },
  },
  actions: {
    changeMsg(newMsg) {
      this.what = newMsg
    },
  },
})" > "$store_file_name"

  echo "$store_var_name"
}

# Function to create a component
create_component() {
  local component_name="$1"
  local component_file_name="$CURRENT_DIR/src/components/${component_name}.vue"

  echo "<script>
export default {
  name: '${component_name}',
  data() {
    return {
      title: '${component_name}',
    }
  },
}
</script>

<template>
{{ title }}
</template>

<style>
</style>" > "$component_file_name"
}

# Find the current directory
CURRENT_DIR="$(pwd)"

# Check if ./src is present
if [ -d "$CURRENT_DIR/src" ]; then
  # Delete App.vue if present
  if [ -f "$CURRENT_DIR/src/App.vue" ]; then
    rm "$CURRENT_DIR/src/App.vue"
  fi

  cat <<EOL > "$CURRENT_DIR/src/App.vue"
<script>
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
</style>
EOL

  # Delete HelloWorld.vue if present
  if [ -f "$CURRENT_DIR/src/components/HelloWorld.vue" ]; then
    rm "$CURRENT_DIR/src/components/HelloWorld.vue"
  fi

  # Create a new HomePage.vue file
  cat <<EOL > "$CURRENT_DIR/src/components/HomePage.vue"
<script>
import { useStore } from '@/store'

export default {
  name: 'HomePage',
  data() {
    return {
      store: this.\$store,
      allStores: Object.keys(this.\$store).reduce((acc, key) => {
        acc[key] = this.\$store[key]
        return acc
      }, {}),
    }
  },
}
</script>

<template>
  <div>
    <div v-for="(store, key) in allStores" :key="key">
      <h2>{{ key }} Store</h2>
      <p>Message: {{ store.what }}</p>
      <p>Reversed: {{ store.reversed }}</p>
    </div>
  </div>
</template>

<style>
/* Add your styles here */
</style>
EOL

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
  cat <<EOL > "$CURRENT_DIR/vite.config.js"
import { fileURLToPath, URL } from "url";
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
});
EOL

  # Delete main.js if present
  if [ -f "$CURRENT_DIR/src/main.js" ]; then
    rm "$CURRENT_DIR/src/main.js"
  fi

  # Initialize the store
  mkdir -p "$CURRENT_DIR/src/store"
  store_vars=()
  store_names=()
  store_imports=()

  while true; do
    read -p "Do you want to create a store? (yes/y/no): " create_store_answer
    if [[ "$create_store_answer" == "yes" || "$create_store_answer" == "y" ]]; then
      read -p "Enter the store name: " store_name
      store_var=$(create_store "$store_name")
      store_vars+=("$store_var")
      store_names+=("$store_name")
      store_imports+=("import { $store_var } from './store/$store_name'")
    else
      break
    fi
  done

  # Create the main.js file with the necessary imports and configurations
  {
    echo "import { createApp } from 'vue'"
    echo "import { createPinia } from 'pinia'"
    echo "import App from './App.vue'"
    echo "import './style.css'"
    echo ""
    for import_stmt in "${store_imports[@]}"; do
      echo "$import_stmt"
    done
    echo ""
    echo "const pinia = createPinia()"
    echo "const app = createApp(App)"
    echo ""
    echo "app.use(pinia)"
    echo ""
    echo "export const store = {"
    for i in "${!store_vars[@]}"; do
      echo "  ${store_names[$i]^}: ${store_vars[$i]}(),"
    done
    echo "}"
    echo ""
    echo "app.config.globalProperties.\$store = store"
    echo ""
    echo "import createRouterInstance from './router'"
    echo "const router = createRouterInstance(app)"
    echo "app.use(router)"
    echo ""
    echo "const files = import.meta.glob('./**/*.vue', { eager: true, import: 'default' });"
    echo "const componenti = Object.keys(files).reduce((componenti, filename) => ({"
    echo "  ...componenti,"
    echo "  [filename.split('/').pop().split('.')[0]]: files[filename],"
    echo "}), {});"
    echo "Object.keys(componenti).forEach(name => app.component(name, componenti[name]));"
    echo ""
    echo "app.mount('#app')"
  } > "$CURRENT_DIR/src/main.js"

  # Create the router/index.js file
  mkdir -p "$CURRENT_DIR/src/router"
  cat <<EOL > "$CURRENT_DIR/src/router/index.js"
import { createRouter, createWebHistory } from "vue-router";
import { store } from "../main"; // Import the pinia instance from main.js

const createRouterInstance = (app) => {
  const router = createRouter({
    history: createWebHistory("/"),
    routes: [
      {
        path: "/",
        component: () => import("../components/HomePage.vue"),
        meta: { requiresAuth: false },
      },
    ],
  });

  router.beforeEach((to, from, next) => {
    const isLoggedIn = store.auth?.isLoggedIn;

    if (to.matched.some((record) => record.meta.requiresAuth) && !isLoggedIn) {
      next({ path: "/login" });
    } else {
      next();
    }
  });

  return router;
};

export default createRouterInstance;
EOL

  # Create components
  while true; do
    read -p "Do you want to create a component? (yes/no): " create_component_answer
    if [[ "$create_component_answer" == "yes" || "$create_component_answer" == "y" ]]; then
      read -p "Enter the component name (e.g., Xxx): " component_name
      component_name_capitalized="${component_name^}"
      create_component "$component_name_capitalized"
      
      # Add route to router/index.js
      route_entry="      { path: '/${component_name_capitalized,,}', component: () => import('../components/${component_name_capitalized}.vue'), meta: { requiresAuth: false }, },"
      sed -i "/routes: \[/a\\$route_entry" "$CURRENT_DIR/src/router/index.js"

    else
      break
    fi
  done

else
  echo "No src directory found. You're not inside a Vue project folder."
fi
