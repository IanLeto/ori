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



</script>

<template>
  <div>
    <h2 class="text-xl font-bold my-4">📊 交易数据多维度查询</h2>
    <el-radio v-model="radio" label="1"> 接口路径url</el-radio>
    <el-radio v-model="radio" label="2">Pod名称</el-radio>

    <el-table
        ref="tableRef"
        :data="tableData"
        style="width: 100%"
        @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55"/>
      <el-table-column prop="trans_type" label="交易类型（接口路径）" width="600"/>
      <el-table-column prop="trans_count" label="交易总次数" width="120"/>
      <el-table-column prop="succ_count" label="异常交易次数" width="120"/>
      <el-table-column prop="resp_time" label="平均响应时间（毫秒）" width="150"/>
      <el-table-column prop="succ_p" label="成功率">
        <template #default="scope">
          <el-tag :type="scope.row.succ_p === 1 ? 'success' : 'warning'">
            {{ (scope.row.succ_p * 100).toFixed(2) }}%
          </el-tag>
        </template>
      </el-table-column>
    </el-table>

  </div>
</template>
