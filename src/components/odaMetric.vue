<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

// 定义响应式数据
const userList = ref([])
const dialogVisible = ref(false)
const currentUser = ref({
  id: '',
  username: '',
  email: '',
  status: true
})

// 获取用户列表
const fetchUserList = async () => {
  try {
    const response = await axios.get('http://localhost:1918/v1/users')
    if (response.data.Code === 200) {
      userList.value = response.data.Data.items
    } else {
      ElMessage.error(response.data.Message || '获取用户列表失败')
    }
  } catch (error) {
    console.error('请求失败:', error)
    ElMessage.error('获取用户列表失败')
  }
}

// 删除用户
const deleteUser = async (id) => {
  try {
    const response = await axios.delete(`http://localhost:1918/v1/users?id=${id}`)
    if (response.data.Code === 200) {
      userList.value = userList.value.filter(user => user.id !== id)
      ElMessage.success('删除成功')
    } else {
      ElMessage.error(response.data.Message || '删除失败')
    }
  } catch (error) {
    console.error('请求失败:', error)
    ElMessage.error('删除失败')
  }
}

// 打开新增/编辑弹窗
const openDialog = (user = null) => {
  if (user) {
    currentUser.value = { ...user }
  } else {
    currentUser.value = {
      id: '',
      username: '',
      email: '',
      status: true
    }
  }
  dialogVisible.value = true
}

// 提交用户信息
const submitUser = async () => {
  try {
    const url = currentUser.value.id
        ? `http://localhost:1918/v1/users/${currentUser.value.id}`
        : 'http://localhost:1918/v1/users'

    const method = currentUser.value.id ? 'put' : 'post'

    const response = await axios[method](url, currentUser.value)

    if (response.data.Code === 200) {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      fetchUserList()
    } else {
      ElMessage.error(response.data.Message || '操作失败')
    }
  } catch (error) {
    console.error('请求失败:', error)
    ElMessage.error('操作失败')
  }
}

// 组件挂载时获取数据
onMounted(() => {
  fetchUserList()
})
</script>

<template>
  <div class="user-management">
    <el-button type="primary" @click="openDialog()">新增用户</el-button>

    <el-table :data="userList" stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="180" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="email" label="邮箱" />
      <el-table-column prop="status" label="状态">
        <template #default="scope">
          {{ scope.row.status ? '启用' : '禁用' }}
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <el-button size="small" @click="openDialog(scope.row)">编辑</el-button>
          <el-button size="small" type="danger" @click="deleteUser(scope.row.id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog
        v-model="dialogVisible"
        :title="currentUser.id ? '编辑用户' : '新增用户'"
    >
      <el-form :model="currentUser" label-width="120px">
        <el-form-item label="用户名">
          <el-input v-model="currentUser.username" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="currentUser.email" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="currentUser.status" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitUser">提交</el-button>
          <el-button @click="dialogVisible = false">取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<style scoped>
.user-management {
  padding: 20px;
}
</style>
