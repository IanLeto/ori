import './assets/main.css'

import {createApp} from 'vue'
import App from './App.vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import router from '../router.js'

const app = createApp(App)
app.use(ElementPlus) // 注册 Element Plus 组件库
app.use(router)
app.mount('#app')
