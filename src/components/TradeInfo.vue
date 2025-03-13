<script setup>
import {ref} from 'vue'
import {ElMessageBox} from 'element-plus'


// 预制交易记录数据
const tableData = ref([
  {
    time: "2024-03-13 10:00:00",
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

const tableRef = ref(null)
const multipleSelection = ref([])

// 切换选中状态
const toggleSelection = (rows) => {
  if (tableRef.value) {
    if (rows) {
      rows.forEach(row => {
        tableRef.value.toggleRowSelection(row)
      })
    } else {
      tableRef.value.clearSelection()
    }
  }
}

// 处理多选变化
const handleSelectionChange = (val) => {
  multipleSelection.value = val
}
const showSelectedData = () => {
  if (multipleSelection.value.length === 0) {
    ElMessageBox.alert('请先选择数据', '提示', {type: 'warning'})
    return
  }

  let content = multipleSelection.value.map(item => `
    <div style="padding: 10px; border-bottom: 1px solid #eee;">
      <p><strong>交易渠道：</strong>${item.trans_channel}</p>
      <p><strong>交易类型：</strong>${item.trans_type}</p>
      <p><strong>成功率：</strong><span style="color: ${item.succ_p === 1 ? 'green' : 'red'}">${(item.succ_p * 100).toFixed(2)}%</span></p>
    </div>
  `).join('')

  ElMessageBox({
    title: '发送至oda',
    message: `<div style="max-height: 300px; overflow-y: auto;">${content}</div>`,
    dangerouslyUseHTMLString: true,
    confirmButtonText: '确定',
    showCancelButton: true

  })
}
</script>

<template>
  <div>
    <h2>交易记录列表</h2>
    <div style="margin-top: 20px">
      <el-button @click="toggleSelection([tableData[0], tableData[1]])">
        Top3选中状
      </el-button>
      <el-button @click="toggleSelection()">清空选中</el-button>
      <el-button @click="showSelectedData" type="warning">开启交易质量监控</el-button>
    </div>
    <el-table
        ref="tableRef"
        :data="tableData"
        style="width: 100%"
        @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55"/>
      <el-table-column prop="trans_type" label="交易类型" width="190"/>
      <el-table-column prop="trans_channel" label="交易渠道" width="140"/>
      <el-table-column prop="trans_count" label="交易总次数" width="120"/>
      <el-table-column prop="succ_count" label="成功交易次数" width="120"/>
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
