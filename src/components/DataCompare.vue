<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>数据结构变化对比工具</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      padding: 20px;
      background-color: #f7f9fc;
    }
    h2 {
      text-align: center;
    }
    .container {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
    textarea {
      width: 100%;
      height: 150px;
      padding: 10px;
      font-size: 14px;
      resize: vertical;
      box-sizing: border-box;
      border-radius: 5px;
      border: 1px solid #ccc;
    }
    button {
      padding: 10px;
      font-size: 16px;
      cursor: pointer;
      border-radius: 5px;
      background-color: #4CAF50;
      color: white;
      border: none;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 8px;
      text-align: left;
      word-break: break-all;
    }
    th {
      background-color: #f2f2f2;
    }
    @media (max-width: 600px) {
      th, td {
        font-size: 12px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <h2>数据结构变化对比工具</h2>
  <label>转换前的数据结构 (JSON格式)：</label>
  <textarea id="beforeData" placeholder='例如：{"id":1,"name":"张三","age":25}'></textarea>

  <label>转换后的数据结构 (JSON格式)：</label>
  <textarea id="afterData" placeholder='例如：{"userId":1,"fullName":"张三","userAge":25,"status":"active"}'></textarea>

  <button onclick="showComparison()">展示对比</button>

  <div id="comparisonResult"></div>
</div>

<script>
  function showComparison() {
    const before = JSON.parse(document.getElementById('beforeData').value);
    const after = JSON.parse(document.getElementById('afterData').value);
    let keys = Array.from(new Set([...Object.keys(before), ...Object.keys(after)]));

    let table = '<table><tr><th>字段</th><th>转换前</th><th>转换后</th></tr>';
    keys.forEach(key => {
      let beforeVal = before[key] !== undefined ? JSON.stringify(before[key]) : '<i style="color:#999;">（无此字段）</i>';
      let afterVal = after[key] !== undefined ? JSON.stringify(after[key]) : '<i style="color:#999;">（无此字段）</i>';
      let highlight = beforeVal !== afterVal ? 'style="background-color:#fffae6;"' : '';
      table += `<tr ${highlight}><td>${key}</td><td>${beforeVal}</td><td>${afterVal}</td></tr>`;
    });
    table += '</table>';

    document.getElementById('comparisonResult').innerHTML = table;
  }
</script>
</body>
</html>