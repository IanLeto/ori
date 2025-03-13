<script setup>
import { ref, computed } from 'vue'
import { ElMessageBox } from 'element-plus'

// 预制交易记录数据（补充 pod_id 字段）
const tableData = ref([
  {
    time: "2024-03-13 10:00:00",
    pod_id: "pod-001",
    intf: "cpaas",
    az: "az1",
    svc_name: "poin",
    trans_type: "0922-存量信贷信息",
    trans_type_code: "0922",
    trans_channel: "1110",
    ret_code: "CFC1991",
    trans_count: 10,
    succ_count: 8,
    resp_time: 120,
    resp_count: 10,
    succ_p: 0.8
  },
  {
    time: "2024-03-13 11:00:00",
    pod_id: "pod-002",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923-信用评估",
    trans_type_code: "0923",
    trans_channel: "1120",
    ret_code: "CFC2000",
    trans_count: 5,
    succ_count: 5,
    resp_time: 95,
    resp_count: 5,
    succ_p: 1
  },
  {
    time: "2024-03-13 12:00:00",
    pod_id: "pod-003",
    intf: "cpaas",
    az: "az3",
    svc_name: "risk",
    trans_type: "0924-风险评估",
    trans_type_code: "0924",
    trans_channel: "1130",
    ret_code: "CFC1999",
    trans_count: 15,
    succ_count: 12,
    resp_time: 180,
    resp_count: 15,
    succ_p: 0.8
  }
])

// 可选维度
const dimensions = ref([
  { key: 'trans_channel', label: '交易渠道' },
  { key: 'pod_id', label: 'POD ID' },
  { key: 'trans_type', label: '交易类型' }
])

// 存储选中的维度
const selectedDimensions = ref([])

// 计算不同维度下的分组数据
const groupedData = computed(() => {
  const result = {}

  selectedDimensions.value.forEach((dim) => {
    const groups = {}
    tableData.value.forEach((item) => {
      const key = item[dim]
      if (!groups[key]) {
        groups[key] = []
      }
      groups[key].push(item)
    })
    result[dim] = groups
  })

  return result
})

// 选中的数据
const tableRefs = ref({})
const selectedRows = ref({})

const handleSelectionChange = (val, dim, key) => {
  if (!selectedRows.value[dim]) {
    selectedRows.value[dim] = {}
  }
  selectedRows.value[dim][key] = val
}

// 选中 Top3
const toggleSelection = (dim, key) => {
  if (tableRefs.value[dim] && tableRefs.value[dim][key]) {
    tableRefs.value[dim][key].clearSelection()
    tableRefs.value[dim][key].toggleRowSelection(groupedData.value[dim][key].slice(0, 3))
  }
}

// 清空选中
const clearSelection = (dim, key) => {
  if (tableRefs.value[dim] && tableRefs.value[dim][key]) {
    tableRefs.value[dim][key].clearSelection()
  }
}

</script>

<template>
  <div>
    <h2 class="text-xl font-bold my-4">📊 交易数据多维度查询</h2>

    <!-- 维度选择 -->
    <div class="mb-4">
      <h3 class="font-semibold">选择查询维度：</h3>
      <el-checkbox-group v-model="selectedDimensions">
        <el-checkbox
            v-for="dim in dimensions"
            :key="dim.key"
            :label="dim.key"
        >
          {{ dim.label }}
        </el-checkbox>
      </el-checkbox-group>
    </div>

    <!-- 动态生成多个表格 -->
    <div v-for="(groups, dim) in groupedData" :key="dim">
      <h3 class="text-lg font-semibold mt-4">
        📌 按 {{ dimensions.find(d => d.key === dim)?.label }} 分组
      </h3>

      <div v-for="(items, key) in groups" :key="key" class="mb-6 border rounded-lg p-4 shadow">
        <h4 class="font-semibold text-gray-700 mb-2">{{ key }}</h4>

        <div class="mb-2">
          <el-button @click="toggleSelection(dim, key)">Top3 选中</el-button>
          <el-button @click="clearSelection(dim, key)">清空选中</el-button>
        </div>

        <el-table
            :ref="el => (tableRefs[dim] = { ...tableRefs[dim], [key]: el })"
            :data="items"
            style="width: 100%"
            @selection-change="val => handleSelectionChange(val, dim, key)"
        >
          <el-table-column type="selection" width="55"/>
          <el-table-column prop="trans_type" label="交易类型" width="190"/>
          <el-table-column prop="trans_channel" label="交易渠道" width="140"/>
          <el-table-column prop="succ_p" label="成功率">
            <template #default="scope">
              <el-tag :type="scope.row.succ_p === 1 ? 'success' : 'warning'">
                {{ (scope.row.succ_p * 100).toFixed(2) }}%
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>

  </div>
</template>
