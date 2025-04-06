<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessageBox, ElMessage, ElNotification } from 'element-plus'
import * as echarts from 'echarts'

// 数据结构定义
const createTransInfo = ref({
  cluster: '',
  trans_type: {
    '0922': {
      name: '存量信贷信息',
      service_codes: ['poin', 'credit']
    },
    '0923': {
      name: '信用评估',
      service_codes: ['credit', 'risk']
    },
    '0924': {
      name: '风险分析',
      service_codes: ['risk', 'poin']
    }
  },
  interval: 5
})

// 数据列表
const tableData = ref([
  {
    cluster: 'cluster-01',
    trans_type: '0922',
    service_codes: ['poin', 'credit'],
    timestamp: new Date().toISOString(),
    success_rate: 0.85,
    total_transactions: 100,
    successful_transactions: 85
  },
  {
    cluster: 'cluster-02',
    trans_type: '0924',
    service_codes: ['risk', 'poin'],
    timestamp: new Date().toISOString(),
    success_rate: 0.92,
    total_transactions: 120,
    successful_transactions: 110
  }
])

// 服务编码映射
const serviceCodeMap = {
  'poin': '积分服务',
  'credit': '信贷服务',
  'risk': '风险服务'
}

// 告警设置弹窗数据
const alarmDialogVisible = ref(false)
const currentAlarmTransType = ref('')
const alarmThreshold = ref(0.9)
const alarmDescription = ref('')

// 按trans_type维度处理数据
const transTypeStatistics = computed(() => {
  const stats = {}
  tableData.value.forEach(item => {
    if (!stats[item.trans_type]) {
      stats[item.trans_type] = {
        name: createTransInfo.value.trans_type[item.trans_type].name,
        total_transactions: 0,
        successful_transactions: 0,
        service_codes: new Set()
      }
    }

    stats[item.trans_type].total_transactions += item.total_transactions
    stats[item.trans_type].successful_transactions += item.successful_transactions

    item.service_codes.forEach(code => {
      stats[item.trans_type].service_codes.add(code)
    })
  })

  return Object.entries(stats).map(([key, value]) => ({
    trans_type: key,
    ...value,
    service_codes: Array.from(value.service_codes),
    success_rate: value.successful_transactions / value.total_transactions
  }))
})

// 保存交易类型配置
const saveTransTypeConfig = (transType) => {
  ElMessageBox.confirm(
      `确认保存交易类型 "${createTransInfo.value.trans_type[transType].name}" 的配置?`,
      '保存确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }
  ).then(() => {
    ElMessage.success(`交易类型 "${createTransInfo.value.trans_type[transType].name}" 配置已保存`)
  }).catch(() => {
    ElMessage.info('已取消保存')
  })
}

// 打开告警设置弹窗
const openAlarmSettingDialog = (transType) => {
  currentAlarmTransType.value = transType
  alarmThreshold.value = 0.9
  alarmDescription.value = ''
  alarmDialogVisible.value = true
}

// 确认告警设置
const confirmAlarmSetting = () => {
  if (alarmThreshold.value <= 0 || alarmThreshold.value > 1) {
    ElMessage.error('时间间隔必须在0-1之间')
    return
  }

  ElNotification({
    title: '告警设置成功',
    message: `交易类型 "${createTransInfo.value.trans_type[currentAlarmTransType.value].name}" 时间间隔设置为 ${(alarmThreshold.value * 100).toFixed(2)}%`,
    type: 'success'
  })

  alarmDialogVisible.value = false
}

// 图表初始化函数
const chartRef = ref(null)
const initChart = () => {
  const chartDom = chartRef.value
  const myChart = echarts.init(chartDom)

  const option = {
    title: { text: '交易类型成功率分析' },
    tooltip: { trigger: 'axis' },
    xAxis: {
      type: 'category',
      data: transTypeStatistics.value.map(item => item.name)
    },
    yAxis: {
      type: 'value',
      min: 0,
      max: 1,
      axisLabel: {
        formatter: '{value%}'
      }
    },
    series: [{
      name: '成功率',
      type: 'bar',
      data: transTypeStatistics.value.map(item => item.success_rate),
      itemStyle: {
        color: (params) => {
          return params.value > 0.9 ? '#67C23A' : '#F56C6C'
        }
      }
    }]
  }

  myChart.setOption(option)
}

onMounted(initChart)
</script>

<template>
  <div class="transaction-management">
    <el-form :model="createTransInfo" label-width="120px">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="集群">
            <el-select v-model="createTransInfo.cluster" placeholder="选择集群">
              <el-option label="集群-01" value="cluster-01"></el-option>
              <el-option label="集群-02" value="cluster-02"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="监控间隔">
            <el-input-number
                v-model="createTransInfo.interval"
                :min="1"
                :max="60"
            ></el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

    <el-table :data="transTypeStatistics" stripe>
      <el-table-column prop="name" label="交易类型" width="200">
        <template #default="scope">
          {{ scope.row.name }}
        </template>
      </el-table-column>

      <el-table-column label="服务编码" width="300">
        <template #default="scope">
          <el-tag
              v-for="code in scope.row.service_codes"
              :key="code"
              type="info"
              style="margin-right: 5px;"
          >
            {{ serviceCodeMap[code] }}
          </el-tag>
        </template>
      </el-table-column>

      <el-table-column label="交易总数" prop="total_transactions" width="150">
      </el-table-column>

      <el-table-column label="成功率" width="200">
        <template #default="scope">
          <el-tag :type="scope.row.success_rate > 0.9 ? 'success' : 'danger'">
            {{ (scope.row.success_rate * 100).toFixed(2) }}%
          </el-tag>
        </template>
      </el-table-column>

      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button-group>
            <el-button
                type="primary"
                size="small"
                @click="saveTransTypeConfig(scope.row.trans_type)"
            >
              保存
            </el-button>
            <el-button
                type="warning"
                size="small"
                @click="openAlarmSettingDialog(scope.row.trans_type)"
            >
              设置告警
            </el-button>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>

    <!-- 告警设置弹窗 -->
    <el-dialog
        v-model="alarmDialogVisible"
        :title="`设置 ${createTransInfo.trans_type[currentAlarmTransType]?.name || ''} 时间间隔`"
        width="400px"
    >
      <el-form label-width="120px">
        <el-form-item label="时间间隔">
          <el-input-number
              v-model="alarmThreshold"
              :precision="2"
              :step="0.01"
              :min="0"
              :max="1"
          >
            <template #append>%</template>
          </el-input-number>
        </el-form-item>

        <el-form-item label="告警说明">
          <el-input
              v-model="alarmDescription"
              type="textarea"
              placeholder="请输入告警详细说明(可选)"
              :rows="3"
          ></el-input>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="alarmDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmAlarmSetting">
          确 定
        </el-button>
      </template>
    </el-dialog>

    <div ref="chartRef" style="width: 100%; height: 400px;"></div>
  </div>
</template>

<style scoped>
.transaction-management {
  padding: 20px;
}
</style>