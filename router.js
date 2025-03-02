import { createRouter, createWebHistory } from 'vue-router'
import RecordForm from './src/components/Record.vue'
import RecordList from './src/components/Records.vue'

const routes = [
    { path: '/', component: RecordForm },
    { path: '/list', component: RecordList }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router