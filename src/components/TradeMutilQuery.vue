<script setup>
import { ref, computed } from "vue";

// 交易数据（接口路径维度）
const urlTableData = ref([
  { trans_type: "/api/order", trans_count: 120, succ_count: 5, resp_time: 250, succ_p: 0.96 },
  { trans_type: "/api/payment", trans_count: 200, succ_count: 10, resp_time: 180, succ_p: 0.95 },
  { trans_type: "/api/payment1", trans_count: 200, succ_count: 10, resp_time: 180, succ_p: 0.95 },
  { trans_type: "/api/payment2", trans_count: 200, succ_count: 10, resp_time: 180, succ_p: 0.95 },
  { trans_type: "/api/payment3", trans_count: 200, succ_count: 10, resp_time: 180, succ_p: 0.95 },
  { trans_type: "/api/payment4", trans_count: 200, succ_count: 10, resp_time: 180, succ_p: 0.95 },

]);

// 交易数据（Pod 维度）
const podTableData = ref([
  { trans_type: "pod-2", trans_count: 180, succ_count: 6, resp_time: 190, succ_p: 0.98 },
  { trans_type: "pod-3", trans_count: 150, succ_count: 8, resp_time: 220, succ_p: 0.97 },
  { trans_type: "pod-4", trans_count: 180, succ_count: 6, resp_time: 190, succ_p: 0.98 },
  { trans_type: "pod-6", trans_count: 150, succ_count: 8, resp_time: 220, succ_p: 0.97 },
  { trans_type: "pod-65", trans_count: 180, succ_count: 6, resp_time: 190, succ_p: 0.98 },
  { trans_type: "pod-15", trans_count: 150, succ_count: 8, resp_time: 220, succ_p: 0.97 },
  { trans_type: "pod-55", trans_count: 180, succ_count: 6, resp_time: 190, succ_p: 0.98 },
]);

// 选中的维度（默认：接口路径）
const selectedDimension = ref("1");

// 计算属性：根据选择的 radio 维度返回不同的数据
const tableData = computed(() => {
  return selectedDimension.value === "1" ? urlTableData.value : podTableData.value;
});

// 计算属性：动态改变表头名称
const dimensionLabel = computed(() => {
  return selectedDimension.value === "1" ? "交易类型（接口路径）" : "Pod 名称";
});

// 选中的行数据（用于展示聚合数据）
const selectedRow = ref(null);
const showAggregationTable = computed(() => !!selectedRow.value);

// 计算属性：第二个表格的聚合数据
const aggregatedTableData = computed(() => {
  if (!selectedRow.value) return [];

  if (selectedDimension.value === "1") {
    // 当前选中的是 URL 维度，显示该 URL 下的 Pod 维度数据
    return [
      { trans_type: "pod-1", trans_count: 80, succ_count: 3, resp_time: 200, succ_p: 0.97 },
      { trans_type: "pod-2", trans_count: 40, succ_count: 2, resp_time: 190, succ_p: 0.98 },
    ];
  } else {
    // 当前选中的是 Pod 维度，显示该 Pod 下的 URL 维度数据
    return [
      { trans_type: "/api/order", trans_count: 90, succ_count: 4, resp_time: 210, succ_p: 0.96 },
      { trans_type: "/api/payment", trans_count: 60, succ_count: 2, resp_time: 200, succ_p: 0.95 },
    ];
  }
});

// 计算属性：动态改变第二个表的表头
const aggregationLabel = computed(() => {
  return selectedDimension.value === "1" ? "Pod 名称（聚合）" : "交易类型（聚合）";
});

// 处理点击某一行的事件
const handleRowClick = (row) => {
  selectedRow.value = row;
};
</script>

<template>
  <div>
    <h2 class="text-xl font-bold my-4">📊 交易数据多维度查询</h2>

    <!-- 选择维度 -->
    <el-radio-group v-model="selectedDimension">
      <el-radio label="1">接口路径URL</el-radio>
      <el-radio label="2">上一跳</el-radio>
      <el-radio label="3">第一跳</el-radio>
      <el-radio label="2">返回码</el-radio>
      <el-radio label="2">服务名</el-radio>
      <el-radio label="2">源地址</el-radio>
      <el-radio label="2">端地址</el-radio>
      <el-radio label="2">自定义1</el-radio>
      <el-radio label="2">自定义2</el-radio>

    </el-radio-group>

    <!-- 交易数据表格 -->
    <el-table ref="tableRef" :data="tableData" style="width: 100%; margin-top: 20px;" @row-click="handleRowClick">
      <el-table-column type="selection" width="55"/>
      <el-table-column prop="trans_type" :label="dimensionLabel" width="250"/>
      <el-table-column prop="trans_count" label="交易总次数" width="120"/>
      <el-table-column prop="succ_count" label="异常交易次数" width="120"/>
      <el-table-column prop="resp_time" label="平均响应时间（毫秒）" width="150"/>
      <el-table-column prop="resp_time" label="响应数" width="150"/>
      <el-table-column prop="succ_p" label="成功率">
        <template #default="scope">
          <el-tag :type="scope.row.succ_p === 1 ? 'success' : 'warning'">
            {{ (scope.row.succ_p * 100).toFixed(2) }}%
          </el-tag>
        </template>
      </el-table-column>
    </el-table>

    <!-- 聚合数据表格（仅当选中某行时显示） -->
    <el-table v-if="showAggregationTable" :data="aggregatedTableData" style="width: 100%; margin-top: 20px;">
      <el-table-column prop="trans_type" :label="aggregationLabel" width="250"/>
      <el-table-column prop="trans_count" label="交易总次数" width="120"/>
      <el-table-column prop="succ_count" label="异常交易次数" width="120"/>
      <el-table-column prop="resp_time" label="平均响应时间（毫秒）" width="150"/>
      <el-table-column prop="resp_time" label="响应数" width="150"/>
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
