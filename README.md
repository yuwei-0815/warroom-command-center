# 元順營造｜營建工務智慧戰情室 (S2 即時同步正式版)

## 架構升級重點
1. **雙核心即時中樞**：即時串聯雲端硬碟 `00-工務系統與LINE_BOT中樞\工務云` 與 `Line BOT(易興)`，移除舊版硬編碼人數與日期鎖死。
2. **四大指定 Excel / 雲端資料夾深度遞迴同步**：
   - `01-仁德國小(第二期)\出貨單`（含收貨單歸檔與 GMT 日期字串污染自動清洗）
   - `01-仁德國小(第二期)\材料查驗`（遞迴掃描 `E` / `WP` / `F` / `LV` 四大系統子資料夾與《二期機電標單》）
   - `01-仁德國小(第二期)\60-機電相關\D04 -不合格報告及改善追蹤表(施工)`（內建零相依 `.xlsx` OpenXML 解析器直接讀取 `NCR統計表.xlsx` 施工 NCR 與監造缺失）
   - `01-仁德國小(第二期)\60-機電相關\廠商請款資料`（遞迴掃描 `115.01~115.10` 月份子夾與 `00-待簽核請款單`）
3. **四重無死角連線機制**：`google.script.run` ➔ `GAS CORS JSON` ➔ `GAS JSONP 跨域穿透` ➔ `GitHub Actions / 同站雙快照 (data/warroom_live_snapshot.json & data/warroom-state.json)`。
4. **檔案瘦身與模型升級**：二期 3D BIM 模型升級至最新 `V198`，並消除重複雙份模型檔冗餘（減少逾 2.2MB 體積）。

## 部署方式
1. 將根目錄檔案（含 `index.html`、`rende2-bim-model.html`、`yingge-3d-model.html`、`data/`、`.github/workflows/realtime-sync.yml`）上傳或推送至 `yuwei-0815/warroom-command-center` 之 `main` 分支。
2. 開啟 Google Apps Script 主控機器人專案，新增指令碼檔案貼上 `gas_backend/S2_WarRoom_RealtimeDriveExcelSync.gs`，重新部署為網頁應用程式（執行身分：我；存取權限：所有人）。
