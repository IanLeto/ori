<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const records = ref([])

onMounted(async () => {
  try {
    const response = await axios.get('http://localhost:1918/v1/record')
    if (response.data.Code === 200) {
      records.value = response.data.Data.items
    } else {
      console.error('获取数据失败:', response.data.Message)
      alert('获取数据失败,请重试')
    }
  } catch (error) {
    console.error('请求失败:', error)
    alert('获取数据失败,请重试')
  }
})



onMounted(async () => {
  // 获取数据的代码保持不变
})

const deleteRecord = async (id) => {
  try {
    const response = await axios.delete(`http://localhost:1918/v1/record?id=${id}`)
    if (response.data.Code === 200) {
      records.value = records.value.filter(record => record.id !== id)
      console.log('删除成功')
    } else {
      console.error('删除失败:', response.data.Message)
      alert('删除失败,请重试')
    }
  } catch (error) {
    console.error('请求失败:', error)
    alert('删除失败,请重试')
  }
}

</script>

<template>
  <div>
    <h2>Record 列表</h2>
    <el-table :data="records" style="width: 100%">
      <el-table-column prop="title" label="标题" />
      <el-table-column prop="weight" label="体重" />
      <el-table-column prop="is_fuck" label="是否启用">
        <template #default="scope">
          <el-tag :type="scope.row.is_fuck ? 'success' : 'danger'">
            {{ scope.row.is_fuck ? '是' : '否' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="cost" label="成本" />
      <el-table-column prop="dev" label="开发者" />
      <el-table-column prop="coding" label="编码格式" />
      <el-table-column prop="social" label="社交信息" />
      <el-table-column prop="create_time" label="创建时间">
        <template #default="scope">
          {{ new Date(scope.row.create_time * 1000).toLocaleString() }}
        </template>

      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <el-button type="danger" @click="deleteRecord(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>