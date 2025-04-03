<template>
  <div>
    <h2>节点管理</h2>

    <!-- 搜索栏 -->
    <el-form :inline="true" class="mb-4">
      <el-form-item label="关键词">
        <el-input v-model="keyword" placeholder="搜索名称/内容" clearable />
      </el-form-item>
      <el-form-item label="状态">
        <el-select v-model="status" placeholder="全部" clearable>
          <el-option label="全部" value="" />
          <el-option label="New" value="New" />
          <el-option label="Doing" value="Doing" />
          <el-option label="Done" value="Done" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="fetchNodes">搜索</el-button>
      </el-form-item>
    </el-form>

    <!-- 节点列表 -->
    <el-table :data="nodes" style="width: 100%" v-loading="loading">
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="status" label="状态">
        <template #default="scope">
          <el-tag :type="statusTagType(scope.row.status)">
            {{ scope.row.status }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="note" label="备注" />
      <el-table-column prop="region" label="区域" />
      <el-table-column prop="done" label="完成">
        <template #default="scope">
          <el-tag :type="scope.row.done ? 'success' : 'danger'">
            {{ scope.row.done ? '是' : '否' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template #default="scope">
          <el-button type="danger" size="small" @click="deleteNode(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <el-pagination
        class="mt-4"
        background
        layout="prev, pager, next"
        :current-page="page"
        :page-size="pageSize"
        :total="total"
        @current-change="handlePageChange"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

// 状态
const nodes = ref([])
const loading = ref(false)
const page = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 搜索条件
const keyword = ref('')
const status = ref('')

// 区域（可动态传入）
const region = 'prod'

// 获取节点列表
const fetchNodes = async () => {
  loading.value = true
  try {
    const response = await axios.get('http://localhost:1918/v2/node/list', {
      params: {
        region,
        keyword: keyword.value,
        status: status.value,
        page: page.value,
        page_size: pageSize.value,
        parent_id: 0
      }
    })

    if (response.data.code === 0) {
      nodes.value = response.data.data.list
      total.value = response.data.data.total
    } else {
      console.error('获取失败:', response.data.message)
      alert('获取失败，请重试')
    }
  } catch (err) {
    console.error('请求异常:', err)
    alert('网络异常，请稍后再试')
  } finally {
    loading.value = false
  }
}

// 删除节点
const deleteNode = async (id) => {
  try {
    const response = await axios.delete('http://localhost:1918/v2/node', {
      data: {
        id,
        region
      }
    })
    if (response.data.code === 0) {
      nodes.value = nodes.value.filter(node => node.id !== id)
      total.value--
      console.log('删除成功')
    } else {
      alert('删除失败：' + response.data.message)
    }
  } catch (err) {
    console.error('删除异常:', err)
    alert('删除失败，请重试')
  }
}

// 分页切换
const handlePageChange = (newPage) => {
  page.value = newPage
  fetchNodes()
}

// 状态 tag 风格
const statusTagType = (status) => {
  switch (status) {
    case 'New': return 'info'
    case 'Doing': return 'warning'
    case 'Done': return 'success'
    default: return ''
  }
}

// 初始加载
onMounted(() => {
  fetchNodes()
})
</script>

<style scoped>
.mb-4 {
  margin-bottom: 16px;
}
.mt-4 {
  margin-top: 16px;
}
</style>
