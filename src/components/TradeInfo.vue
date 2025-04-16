<script setup>
import { ref, onMounted, computed, reactive } from 'vue'
import { ElMessageBox, ElMessage, ElNotification } from 'element-plus'
import * as echarts from 'echarts'

// 数据结构定义
const createTransInfo = ref({
  cluster: '',
  trans_type: {
    '0922': {
      name: '存量信贷信息',
      service_codes: ['poin', 'credit'],
      custom_dimensions: [] // 添加自定义维度数组
    },
    '0923': {
      name: '信用评估',
      service_codes: ['credit', 'risk'],
      custom_dimensions: []
    },
    '0924': {
      name: '风险分析',
      service_codes: ['risk', 'poin'],
      custom_dimensions: []
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
    custom_dimensions: [], // 添加自定义维度数组
    timestamp: new Date().toISOString(),
    success_rate: 0.85,
    total_transactions: 100,
    successful_transactions: 85
  },
  {
    cluster: 'cluster-02',
    trans_type: '0924',
    service_codes: ['risk', 'poin'],
    custom_dimensions: [],
    timestamp: new Date().toISOString(),
    success_rate: 0.92,
    total_transactions: 120,
    successful_transactions: 110
  }
])

// 服务编码映射
const serviceCodeMap = reactive({
  'poin': 'AAAAA',
  'credit': 'S-ffF',
  'risk': 'CCCAAAA'
})

// 自定义维度弹窗数据
const dimensionDialogVisible = ref(false)
const newDimensionName = ref('')
const newDimensionValues = ref([])
const newDimensionValueInput = ref('')
const editingDimensions = ref([])

// 告警设置弹窗数据
const alarmDialogVisible = ref(false)
const currentAlarmTransType = ref('')
const alarmThreshold = ref(0.9)
const alarmDescription = ref('')

// 服务编码编辑相关状态
const editingRow = ref(null) // 正在编辑的行
const newServiceCode = ref('') // 新添加的服务编码

// 按trans_type维度处理数据
const transTypeStatistics = computed(() => {
  const stats = {}
  tableData.value.forEach(item => {
    if (!stats[item.trans_type]) {
      stats[item.trans_type] = {
        name: createTransInfo.value.trans_type[item.trans_type].name,
        total_transactions: 0,
        successful_transactions: 0,
        service_codes: new Set(),
        custom_dimensions: item.custom_dimensions || [] // 添加自定义维度
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

// 开始编辑服务编码
const startEditServiceCodes = (row) => {
  editingRow.value = row;
  newServiceCode.value = '';
}

// 结束编辑服务编码
const endEditServiceCodes = () => {
  // 更新 createTransInfo 中的配置
  if (editingRow.value && editingRow.value.trans_type) {
    const transType = editingRow.value.trans_type;
    createTransInfo.value.trans_type[transType].service_codes = [...editingRow.value.service_codes];

    // 更新 tableData 中对应的记录
    tableData.value.forEach(item => {
      if (item.trans_type === transType) {
        item.service_codes = [...editingRow.value.service_codes];
      }
    });
  }

  editingRow.value = null;
}

// 删除服务编码
const removeServiceCode = (row, code) => {
  const index = row.service_codes.indexOf(code);
  if (index > -1) {
    row.service_codes.splice(index, 1);
  }
}

// 添加服务编码
const addServiceCode = (row) => {
  if (!newServiceCode.value) {
    ElMessage.warning('请输入服务编码');
    return;
  }

  if (!row.service_codes.includes(newServiceCode.value)) {
    // 如果添加的服务编码不在映射表中，自动添加
    if (!serviceCodeMap[newServiceCode.value]) {
      serviceCodeMap[newServiceCode.value] = newServiceCode.value;
    }

    row.service_codes.push(newServiceCode.value);
    newServiceCode.value = '';
  } else {
    ElMessage.warning('该服务编码已存在');
  }
}

// 打开自定义维度弹窗
const openDimensionDialog = () => {
  dimensionDialogVisible.value = true;
  newDimensionName.value = '';
  newDimensionValues.value = [];
  newDimensionValueInput.value = '';

  // 获取已有维度
  editingDimensions.value = [];
  Object.values(createTransInfo.value.trans_type).forEach(type => {
    if (type.custom_dimensions) {
      type.custom_dimensions.forEach(dim => {
        if (!editingDimensions.value.find(d => d.name === dim.name)) {
          editingDimensions.value.push({ ...dim });
        }
      });
    }
  });
}



// 删除现有维度值
const removeExistingDimensionValue = (dimensionIndex, valueIndex) => {
  editingDimensions.value[dimensionIndex].values.splice(valueIndex, 1);
}


// 添加新维度
const addNewDimension = () => {
  if (!newDimensionName.value.trim()) {
    ElMessage.warning('维度名称不能为空');
    return;
  }

  editingDimensions.value.push({
    name: newDimensionName.value,
    values: [...newDimensionValues.value]
  });

  newDimensionName.value = '';
  newDimensionValues.value = [];
}

// 删除维度
const removeDimension = (index) => {
  editingDimensions.value.splice(index, 1);
}

// 确认自定义维度设置
const confirmDimensionSetting = () => {
  // 更新所有交易类型的自定义维度
  Object.keys(createTransInfo.value.trans_type).forEach(transType => {
    createTransInfo.value.trans_type[transType].custom_dimensions = [...editingDimensions.value];
  });

  // 更新数据列表中的自定义维度
  tableData.value.forEach(item => {
    item.custom_dimensions = [...editingDimensions.value];
  });

  ElNotification({
    title: '自定义维度设置成功',
    message: `已添加 ${editingDimensions.value.length} 个自定义维度`,
    type: 'success'
  });

  dimensionDialogVisible.value = false;
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
    <el-row :gutter="20" style="margin-bottom: 20px;">
      <el-col :span="24" style="display: flex; justify-content: flex-end;">
        <el-button
            type="primary"
            @click="openDimensionDialog"
            style="margin-right: 10px;">
          添加自定义维度
        </el-button>
      </el-col>
    </el-row>

    <el-table :data="transTypeStatistics" stripe>
      <el-table-column prop="name" label="交易类型" width="180">
        <template #default="scope">
          {{ scope.row.name }}
        </template>
      </el-table-column>

      <el-table-column label="服务编码" min-width="380">
        <template #default="scope">
          <div v-if="editingRow && editingRow.trans_type === scope.row.trans_type">
            <!-- 编辑模式 -->
            <div style="margin-bottom: 10px;">
              <el-tag
                  v-for="code in editingRow.service_codes"
                  :key="code"
                  type="info"
                  closable
                  @close="removeServiceCode(editingRow, code)"
                  style="margin-right: 5px; margin-bottom: 5px;"
              >
                {{ serviceCodeMap[code] || code }}
              </el-tag>
            </div>
            <div style="display: flex; align-items: center;">
              <el-input
                  v-model="newServiceCode"
                  placeholder="输入服务编码"
                  style="width: 150px; margin-right: 10px;"
                  @keyup.enter="addServiceCode(editingRow)"
              ></el-input>
              <el-button type="success" size="small" @click="addServiceCode(editingRow)">添加</el-button>
              <el-button type="primary" size="small" @click="endEditServiceCodes" style="margin-left: 10px;">完成</el-button>
            </div>
          </div>
          <div v-else>
            <!-- 显示模式 -->
            <div>
              <el-tag
                  v-for="code in scope.row.service_codes"
                  :key="code"
                  type="info"
                  style="margin-right: 5px; margin-bottom: 5px;"
              >
                {{ serviceCodeMap[code] || code }}
              </el-tag>
              <el-button
                  type="primary"
                  size="small"
                  icon="Edit"
                  circle
                  @click="startEditServiceCodes(scope.row)"
                  style="margin-left: 5px;"
              ></el-button>
            </div>
          </div>
        </template>
      </el-table-column>

      <!-- 自定义维度列 -->
      <el-table-column
          v-for="dimension in editingDimensions"
          :key="dimension.name"
          :label="dimension.name"
          min-width="150">
        <template #default="scope">
          <el-select v-model="scope.row.selectedValues" multiple collapse-tags
                     :placeholder="`选择${dimension.name}`" style="width: 100%;"
                     allow-create filterable>
            <el-option v-for="value in dimension.values" :key="value" :label="value" :value="value">
            </el-option>
          </el-select>
        </template>
      </el-table-column>

      <el-table-column label="交易总数" prop="total_transactions" width="120">
      </el-table-column>

      <el-table-column label="成功率" width="120">
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

    <!-- 自定义维度设置弹窗 -->
    <el-dialog
        v-model="dimensionDialogVisible"
        title="设置自定义维度"
        width="700px"
    >
      <!-- 现有维度列表 -->
      <div v-if="editingDimensions.length > 0" style="margin-bottom: 20px;">
        <h3>现有维度</h3>
        <el-card v-for="(dimension, dimIndex) in editingDimensions" :key="dimension.name"
                 style="margin-bottom: 15px;">
          <template #header>
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <span>{{ dimension.name }}</span>
              <el-button type="danger" size="small" @click="removeDimension(dimIndex)">
                删除维度
              </el-button>
            </div>
          </template>
          <div style="margin-bottom: 10px;">
            <el-tag
                v-for="(value, valIndex) in dimension.values"
                :key="value"
                closable
                @close="removeExistingDimensionValue(dimIndex, valIndex)"
                style="margin-right: 5px; margin-bottom: 5px;"
            >
              {{ value }}
            </el-tag>
          </div>
        </el-card>
      </div>

      <!-- 添加新维度 -->
      <el-divider>添加新维度</el-divider>

      <el-form>
        <el-form-item label="维度名称">
          <el-input v-model="newDimensionName" placeholder="例如: 地域、渠道"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="success" @click="addNewDimension">添加此维度</el-button>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dimensionDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmDimensionSetting">
          确 定
        </el-button>
      </template>
    </el-dialog>

    <div ref="chartRef" style="width: 100%; height: 400px; margin-top: 20px;"></div>
  </div>
</template>

<style scoped>
.transaction-management {
  padding: 20px;
}
</style>
