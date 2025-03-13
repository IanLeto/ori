<script setup>
import {ref} from 'vue'
import recordFrom from './Record.vue'
import tradeInfo from "./TradeInfo.vue";
// 计数器的响应式数据
const count = ref(0)
</script>

<template>
  <div>
    <recordFrom></recordFrom>
    <!-- Element Plus 输入框 -->
    <el-input v-model="count" placeholder="请输入数字"></el-input>
  </div>
</template>

<style scoped>
h2 {
  margin-bottom: 10px;
}
</style>
