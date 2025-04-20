import {createRouter, createWebHistory} from 'vue-router'
import RecordForm from './src/components/Record.vue'
import RecordList from './src/components/Records.vue'
import TradeDetail from "./src/components/TradeMutilQuery.vue";
import TradeTable from "./src/components/TradeInfo.vue";

const routes = [{path: '/', component: RecordForm}, {path: '/list', component: RecordList}, {
    path: '/trade', component: TradeTable
}, {path: '/detail', component: TradeDetail},]

const router = createRouter({
    history: createWebHistory(), routes
})

export default router
