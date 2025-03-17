<script setup>
import {onMounted, ref} from 'vue'
import {ElMessageBox} from 'element-plus'

import * as echarts from 'echarts';


// 预制交易记录数据
const tableData = ref([
  {
    time: "2024-03-13 10:00:00",
    intf: "cpaas",
    az: "az1",
    svc_name: "poin",
    trans_type: "0922-存量信贷信息/spay/pan/usc-ACCAAA",
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
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
  },
  {
    time: "2024-03-13 11:00:00",
    intf: "cpaas",
    az: "az2",
    svc_name: "credit",
    trans_type: "0923- spay/pan/usc-ACCAAA",
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
const chartRef = ref(null)
const rawData = [
  [100, 302, 301, 334, 390, 330, 320,100, 302, 301, 334, 390, 330, 320], // 第一个系列的数据
  [320, 132, 101, 134, 90, 230, 210,320, 132, 101, 134, 90, 230, 210]   // 第二个系列的数据
];
// 计算总值（避免负数）
const totalData = [];
for (let i = 0; i < rawData[0].length; ++i) {
  let sum = 0;
  for (let j = 0; j < rawData.length; ++j) {
    sum += rawData[j][i];
  }
  totalData.push(sum);
}

// 颜色数组（黄色和红色）
const colors =  ['#FF5733','#FFC300'];
const series = ['连路数', '异常数'].map((name, sid) => {
  return {
    name,
    type: 'bar',
    stack: 'total',
    barWidth: '50%',
    data: rawData[sid],
    itemStyle: {
      color: colors[sid] // 每个 series 赋予不同的颜色
    }
  };
});
const initChart = () => {
  const chartDom = chartRef.value;

  const myChart = echarts.init(chartDom)
  myChart.setOption({
    legend: {
      selectedMode: false
    },
    xAxis: {
      type: 'category',
      data: ['时间段1', '时间段2', '时间段3', '时间段T', '时间段F', '时间段S', '时间段S2','时间段1', '时间段2', '时间段3', '时间段T', '时间段F', '时间段S', '时间段S2']
    },
    yAxis: {
      type: 'value'
    },
    series: series
  })
}
onMounted(() => {
  initChart()
})
const showSelectedData = () => {
  if (multipleSelection.value.length === 0) {
    ElMessageBox.alert('请先选择数据', '提示', {type: 'warning'})
    return
  }

  let content = multipleSelection.value.map(item => `
    <div style="padding: 10px; border-bottom: 1px solid #eee;">
<!--      <p><strong>交易渠道：</strong>${item.trans_channel}</p>-->
      <p><strong>交易类型：</strong>${item.trans_type}</p>
      <p><strong>成功率：</strong><span style="color: ${item.succ_p === 1 ? 'green' : 'red'}">${(item.succ_p * 100).toFixed(2)}%</span></p>
    </div>
  `).join('')

  ElMessageBox({
    title: '开启交易质量监控',
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
        全选
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
    <div style="display: flex; flex-direction: column; width: 100%; align-items: center; gap: 20px;">

      <!-- 并列的 el-descriptions，设置固定宽度与对齐 -->
      <div ref="chartRef" style="width: 100%; max-width: 1200px; height: 400px; margin-top: 20px;"></div>
      <div style="display: flex; width: 100%; max-width: 1200px; gap: 20px;">
        <el-descriptions title="交易信息" border :column="1" style="flex: 1;">
          <el-descriptions-item label="交易总数">1000</el-descriptions-item>
          <el-descriptions-item label="成功交易数">950</el-descriptions-item>
          <el-descriptions-item label="失败交易数">50</el-descriptions-item>
          <el-descriptions-item label="未知交易数">12</el-descriptions-item>
        </el-descriptions>

        <el-descriptions title="异常统计" border :column="1" style="flex: 1;">
          <el-descriptions-item label="异常总数" label-width="80px">
            <span style="font-size: 20px; font-weight: bold;">50</span>
          </el-descriptions-item>
          <el-descriptions-item label="异常总数" label-width="80px">
            <span style="font-size: 20px; font-weight: bold;">50</span>
          </el-descriptions-item>
          <el-descriptions-item label="异常总数" label-width="80px">
            <span style="font-size: 20px; font-weight: bold;">50</span>
          </el-descriptions-item>
          <el-descriptions-item label="异常总数" label-width="80px">
            <span style="font-size: 20px; font-weight: bold;">50</span>
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- ECharts 绑定的 div，确保与上面 descriptions 对齐 -->


    </div>


  </div>

</template>


