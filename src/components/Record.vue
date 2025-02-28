<script setup>
import { reactive } from 'vue'

// 定义表单数据
const form = reactive({
  name: '',
  weight: null,
  is_active: false, // 修改字段名，避免不适用的词汇
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
})

// 提交表单（仅打印数据）
const submitForm = () => {
  console.log('提交的数据:', form)
  alert('数据已提交（仅控制台可见）')
}

// 重置表单
const resetForm = () => {
  Object.assign(form, {
    name: '',
    weight: null,
    is_active: false,
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
  })
}
</script>

<template>
  <el-form :model="form" label-width="120px" style="max-width: 600px">
    <el-form-item label="名称">
      <el-input v-model="form.name" />
    </el-form-item>

    <el-form-item label="权重">
      <el-input-number v-model="form.weight" :min="0" />
    </el-form-item>

    <el-form-item label="是否启用">
      <el-switch v-model="form.is_active" />
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
      <el-button type="danger" @click="resetForm">重置</el-button>
    </el-form-item>
  </el-form>
</template>
