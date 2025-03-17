<script setup>
import { reactive,onMounted } from 'vue'
import axios from 'axios'

// 定义表单数据的初始值
const defaultFormData = {
  title: '',
  weight: null,
  is_fuck: false,
  vol1: '',
  vol2: '',
  vol3: '',
  vol4: '',
  content: '',
  cost: null,
  retire: null,
  dev: '',
  coding: '',
  social: ''
}

const form = reactive({ ...defaultFormData })
onMounted(async () => {
  try {
    const response = await axios.get('http://localhost:1918/v1/record', {
      params: {
        region: 'win',
        start_time: '1740326400'
      },
      headers: {
        'Content-Type': 'application/json'
      }
    })

    if (response.data.Code === 200) {
      const firstItem = response.data.Data.items[0]
      Object.assign(form, firstItem)
    }
  } catch (error) {
    console.error('请求失败:', error)
  }
})

// 提交表单（仅打印数据）
// 提交表单并保存数据
const submitForm = async () => {
  try {
    const response = await axios.post('http://localhost:1918/v1/record', form)
    if (response.data.Code === 200) {
      console.log('数据保存成功')
      alert('数据已成功保存')
      resetForm() // 保存成功后重置表单
    } else {
      console.error('数据保存失败:', response.data.Message)
      alert('数据保存失败,请重试')
    }
  } catch (error) {
    console.error('请求失败:', error)
    alert('数据保存失败,请重试')
  }
}

const updateForm = async () => {
  try {
    const response = await axios.put('http://localhost:1918/v1/record', form)
    if (response.data.Code === 200) {
      console.log('数据保存成功')
      alert('数据已成功保存')
      resetForm() // 保存成功后重置表单
    } else {
      console.error('数据保存失败:', response.data.Message)
      alert('数据保存失败,请重试')
    }
  } catch (error) {
    console.error('请求失败:', error)
    alert('数据保存失败,请重试')
  }
}

// 重置表单
const resetForm = () => {
  Object.assign(form, defaultFormData)
}
</script>

<template>
  <el-form :model="form" label-width="120px" style="max-width: 600px">
    <el-form-item label="名称">
      <el-input v-model="form.title" />
    </el-form-item>

    <el-form-item label="体重">
      <el-input-number v-model="form.weight" :min="0" />
    </el-form-item>

    <el-form-item label="是否启用">
      <el-switch v-model="form.is_fuck" />
    </el-form-item>

    <el-form-item label="体积参数">
      <el-input v-model="form.vol1" placeholder="vol1" />
      <el-input v-model="form.vol2" placeholder="vol2" />
      <el-input v-model="form.vol3" placeholder="vol3" />
      <el-input v-model="form.vol4" placeholder="vol4" />
    </el-form-item>

    <el-form-item label="内容描述">
      <el-input v-model="form.content" type="textarea" />
    </el-form-item>

    <el-form-item label="成本">
      <el-input-number v-model="form.cost" :min="0" />
    </el-form-item>

    <el-form-item label="退役时间">
      <el-date-picker v-model="form.retire" type="year" placeholder="选择年份" />
    </el-form-item>

    <el-form-item label="开发者">
      <el-input v-model="form.dev" />
    </el-form-item>

    <el-form-item label="编码格式">
      <el-select v-model="form.coding" placeholder="选择编码">
        <el-option label="UTF-8" value="UTF-8" />
        <el-option label="ASCII" value="ASCII" />
        <el-option label="GBK" value="GBK" />
      </el-select>
    </el-form-item>

    <el-form-item label="社交信息">
      <el-input v-model="form.social" />
    </el-form-item>

    <el-form-item>
      <el-button type="primary" @click="submitForm">提交</el-button>
      <el-button type="primary" @click="updateForm">修改</el-button>
      <el-button type="danger" @click="resetForm">重置</el-button>
    </el-form-item>
  </el-form>
</template>
