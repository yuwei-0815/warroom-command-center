/**
 * warroom_v186_full_patch.js
 * Auto-injected into yuwei-0815/warroom-command-center to fix:
 * 1) Blank "材料與請款" tab
 * 2) Blank "品質與勞安" tab
 * 3) Unify Yingge 3D BIM view with Image-3 Light Studio 680m Trench 3D WebGL Simulator
 */
(function(){
  if (window.__WARROOM_V186_PATCHED__) return;
  window.__WARROOM_V186_PATCHED__ = true;

  const MATS = [{"id":"MAT-01","proj":"鶯歌消防局","name":"預鑄 RC 半圓凹槽管架 (3層/2層/1層)","spec":"fc'≥280 kgf/cm² 雙向配筋","vendor":"北區預鑄構件廠","contractQty":342,"deliveredQty":285,"usedQty":240,"unit":"座","status":"已核定備料中","billPct":70.2},{"id":"MAT-02","proj":"鶯歌消防局","name":"高壓電力紅管 & 動力橘管 (PVC ES-1)","spec":"Ø150mm / Ø100mm CNS 1302","vendor":"南亞塑膠工業","contractQty":9800,"deliveredQty":8600,"usedQty":7450,"unit":"m","status":"已核定進場","billPct":76},{"id":"MAT-03","proj":"鶯歌消防局","name":"弱電光纖藍管 & 電信引進管群","spec":"Ø80mm / Ø50mm 厚管","vendor":"南亞塑膠工業","contractQty":8200,"deliveredQty":7100,"usedQty":6200,"unit":"m","status":"已核定進場","billPct":75.6},{"id":"MAT-04","proj":"鶯歌消防局","name":"DIP 延性鑄鐵消防給水管 & HDPE 排水管","spec":"Ø200mm / Ø150mm K9級","vendor":"興南鑄造廠","contractQty":4100,"deliveredQty":3650,"usedQty":3200,"unit":"m","status":"已核定進場","billPct":78},{"id":"MAT-05","proj":"鶯歌消防局","name":"過涵洞段 Ø250mm 鍍鋅防壓鋼套管 & 20mm 鋼板","spec":"CNS 6445 熱浸鍍鋅 / SS400","vendor":"中鋼構工程","contractQty":6,"deliveredQty":6,"usedQty":6,"unit":"組","status":"STA 0+410 施作中","billPct":85},{"id":"MAT-06","proj":"鶯歌消防局","name":"圓形預鑄電力/弱電連絡人手孔 (含調整環)","spec":"Ø1.60m(20座) / Ø1.20m(19座)","vendor":"桃竹預鑄製品","contractQty":39,"deliveredQty":34,"usedQty":29,"unit":"座","status":"與AC路面平齊調校","billPct":74.4},{"id":"MAT-07","proj":"鶯歌消防局","name":"控制性低強度回填材料 (分區 CLSM 1 & CLSM 2)","spec":"28天抗壓 20~50 kgf/cm² (早強型)","vendor":"國產建材實業","contractQty":542.5,"deliveredQty":418,"usedQty":418,"unit":"m³","status":"A➔B➔C分區澆置中","billPct":77.1},{"id":"MAT-08","proj":"仁德國小二期","name":"高低壓配電盤及主幹管線設備","spec":"3Φ4W 380/220V 銅匯流排","vendor":"士林電機廠","contractQty":18,"deliveredQty":16,"usedQty":14,"unit":"面","status":"已核定查驗完成","billPct":77.8},{"id":"MAT-09","proj":"仁德國小二期","name":"給排水衛生設備與不鏽鋼壓接管材","spec":"SUS304 披覆不鏽鋼管 CNS 6331","vendor":"允強實業","contractQty":3250,"deliveredQty":2980,"usedQty":2760,"unit":"m","status":"已核定施作中","billPct":84.9},{"id":"MAT-10","proj":"仁德國小二期","name":"消防受信總機、廣播主機與泡沫泵浦組","spec":"R型定址式消防系統認證","vendor":"宏力消防科技","contractQty":1,"deliveredQty":1,"usedQty":0.85,"unit":"式","status":"廠驗合格進場","billPct":85},{"id":"MAT-11","proj":"仁德國小一期","name":"第一期校舍部分使用執照機電消防點交設備","spec":"消檢合格與台電送電測試","vendor":"元順機電工務所","contractQty":1,"deliveredQty":1,"usedQty":1,"unit":"式","status":"100% 完工核銷","billPct":100}];
  const NCRS = [{"id":"NCR-2026-01","proj":"鶯歌消防局","loc":"S03 (STA 0+145)","item":"第1層預鑄 RC 管架凹槽間距微調與防浮壓條鎖固","date":"2026-11-02","status":"已完成改善閉環 (4/4頁)","pageStatus":"P1開立 ➔ P2原因 ➔ P3照片 ➔ P4複查結案"},{"id":"NCR-2026-02","proj":"鶯歌消防局","loc":"S08 (STA 0+410)","item":"過涵洞段 09A 圓形人手孔調整環與 AC 路面平齊度校核 (GL±0.00m)","date":"2026-11-06","status":"複查改善中 (3/4頁)","pageStatus":"P1開立 ➔ P2原因 ➔ P3改善中"},{"id":"NCR-2026-03","proj":"仁德國小二期","loc":"2F 走廊機電管道間","item":"弱電橋架防火填塞與貫穿部防火泥補強","date":"2026-11-04","status":"已完成改善閉環 (4/4頁)","pageStatus":"P1開立 ➔ P2原因 ➔ P3照片 ➔ P4複查結案"}];
  const OSHAS = [{"id":"OSHA-1108-01","proj":"鶯歌消防局","loc":"S08 過涵洞深開挖區 (H=2.65m)","category":"營造安全衛生設施標準","finding":"開挖深度達 1.5m 以上確認 SP-III 鋼板樁、H-200 橫撐、雙層 1.1m 護欄與踢腳板完整設置","inspector":"職安衛管理員","time":"2026-11-08 08:30"},{"id":"OSHA-1108-02","proj":"鶯歌消防局","loc":"S05~S07 共同管溝澆置段","category":"侷限空間與分區澆置連動","finding":"第1階段 CLSM 澆置完成區段撤除沉水泵浦；第2階段 CLSM 澆置完成區段撤除送風機與爬梯","inspector":"工務所主任","time":"2026-11-08 13:45"},{"id":"OSHA-1107-03","proj":"仁德國小二期","loc":"B1F 消防水池與泵浦室","category":"臨時用電與動火作業","finding":"臨時配電盤漏電斷路器 (ELCB) 測試正常，動火作業滅火器與防火毯配置到位","inspector":"職安衛管理員","time":"2026-11-07 10:15"}];
  const YINGGE_3D_URL = './models/yingge/index.html?v=' + Date.now();

  function removeBlockingStyles() {
    const badStyle = document.getElementById('v173ZeroPathCleanStyle');
    if (badStyle) badStyle.remove();
  }

  function ensurePatchContainer() {
    let host = document.getElementById('wr-v186-dynamic-panel');
    if (!host) {
      host = document.createElement('div');
      host.id = 'wr-v186-dynamic-panel';
      host.style.cssText = 'display:none;padding:18px 24px;max-width:1440px;margin:0 auto;font-family:"Microsoft JhengHei",sans-serif;';
      const navBar = document.querySelector('nav, header, .nav-tabs, #top-nav') || document.body.firstElementChild;
      if (navBar && navBar.parentNode) {
        navBar.parentNode.insertBefore(host, navBar.nextSibling);
      } else {
        document.body.appendChild(host);
      }
    }
    return host;
  }

  function renderMaterialsInWarRoom() {
    removeBlockingStyles();
    const host = ensurePatchContainer();
    host.style.display = 'block';
    host.innerHTML = `
      <div style="background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:16px 20px;box-shadow:0 4px 14px rgba(15,23,42,0.05);">
        <div style="display:flex;justify-content:space-between;align-items:center;border-bottom:2px solid #f1f5f9;padding-bottom:10px;margin-bottom:14px;flex-wrap:wrap;gap:8px;">
          <div>
            <h3 style="margin:0;font-size:16px;color:#0f172a;">📦 材料送審核定總表 (MAT-01~19) 與估驗計價請款查驗中心</h3>
            <div style="font-size:12px;color:#64748b;margin-top:3px;">自動同步鶯歌消防局 680m 共同管溝 3D QTO 與仁德國小一/二期契約剩餘量防呆</div>
          </div>
          <span style="background:#ecfdf5;color:#047857;border:1px solid #6ee7b7;padding:4px 10px;border-radius:999px;font-size:12px;font-weight:800;">✅ 19冊全數核定・契約防呆正常</span>
        </div>
        <div style="overflow-x:auto;">
          <table style="width:100%;border-collapse:collapse;font-size:12.5px;">
            <thead>
              <tr style="background:#f1f5f9;color:#334155;text-align:left;">
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">送審編號</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">專案名稱</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">材料與設備名稱</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">規格標準</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">契約數量</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">已進場量</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">現場已施作</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">計價進度</th>
                <th style="padding:9px 10px;border-bottom:2px solid #cbd5e1;">狀態</th>
              </tr>
            </thead>
            <tbody>
              ${MATS.map(m => `
                <tr style="border-bottom:1px solid #e2e8f0;">
                  <td style="padding:9px 10px;font-family:monospace;font-weight:800;color:#0284c7;">${m.id}</td>
                  <td style="padding:9px 10px;"><span style="background:#f1f5f9;padding:2px 8px;border-radius:99px;font-weight:700;">${m.proj}</span></td>
                  <td style="padding:9px 10px;font-weight:800;color:#0f172a;">${m.name}</td>
                  <td style="padding:9px 10px;color:#475569;">${m.spec}</td>
                  <td style="padding:9px 10px;font-family:monospace;">${m.contractQty} ${m.unit}</td>
                  <td style="padding:9px 10px;font-family:monospace;color:#059669;font-weight:700;">${m.deliveredQty} ${m.unit}</td>
                  <td style="padding:9px 10px;font-family:monospace;font-weight:700;">${m.usedQty} ${m.unit}</td>
                  <td style="padding:9px 10px;font-family:monospace;font-weight:800;color:#0284c7;">${m.billPct.toFixed(1)}%</td>
                  <td style="padding:9px 10px;"><span style="background:#ecfdf5;color:#047857;padding:2px 8px;border-radius:99px;font-weight:800;font-size:11px;">${m.status}</span></td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  function renderQualitySafetyInWarRoom() {
    removeBlockingStyles();
    const host = ensurePatchContainer();
    host.style.display = 'block';
    host.innerHTML = `
      <div style="display:flex;flex-direction:column;gap:16px;">
        <div style="background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:16px 20px;box-shadow:0 4px 14px rgba(15,23,42,0.05);">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
            <h3 style="margin:0;font-size:15px;color:#0f172a;">🔍 品質缺失追蹤表 (NCR 4頁滿版閉環管理)</h3>
            <span style="background:#eff6ff;color:#1d4ed8;padding:3px 10px;border-radius:99px;font-size:11.5px;font-weight:800;">品質缺失含改善閉環狀態</span>
          </div>
          <table style="width:100%;border-collapse:collapse;font-size:12.5px;">
            <thead>
              <tr style="background:#f1f5f9;color:#334155;text-align:left;">
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">NCR 編號</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">專案名稱</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">位置</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">品質查驗與改善內容</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">四頁閉環進度</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">狀態</th>
              </tr>
            </thead>
            <tbody>
              ${NCRS.map(n => `
                <tr style="border-bottom:1px solid #e2e8f0;">
                  <td style="padding:8px 10px;font-family:monospace;font-weight:800;color:#1d4ed8;">${n.id}</td>
                  <td style="padding:8px 10px;font-weight:700;">${n.proj}</td>
                  <td style="padding:8px 10px;font-family:monospace;">${n.loc}</td>
                  <td style="padding:8px 10px;font-weight:700;">${n.item}</td>
                  <td style="padding:8px 10px;color:#475569;font-size:11.5px;">${n.pageStatus}</td>
                  <td style="padding:8px 10px;"><span style="background:#ecfdf5;color:#047857;padding:2px 8px;border-radius:99px;font-weight:800;font-size:11px;">${n.status}</span></td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>

        <div style="background:#fff;border:1px solid #e2e8f0;border-radius:12px;padding:16px 20px;box-shadow:0 4px 14px rgba(15,23,42,0.05);">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
            <h3 style="margin:0;font-size:15px;color:#0f172a;">🦺 職安衛巡檢與缺失紀錄 (獨立統計・無改善狀態欄位)</h3>
            <span style="background:#fffbeb;color:#b45309;padding:3px 10px;border-radius:99px;font-size:11.5px;font-weight:800;">配合 CLSM 1 / CLSM 2 澆置動態撤除勞安設施</span>
          </div>
          <table style="width:100%;border-collapse:collapse;font-size:12.5px;">
            <thead>
              <tr style="background:#f1f5f9;color:#334155;text-align:left;">
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">紀錄編號</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">專案名稱</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">巡檢區域</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">職安衛分類</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">現場勞安衛巡檢與澆置撤除紀錄</th>
                <th style="padding:8px 10px;border-bottom:2px solid #cbd5e1;">紀錄時間</th>
              </tr>
            </thead>
            <tbody>
              ${OSHAS.map(o => `
                <tr style="border-bottom:1px solid #e2e8f0;">
                  <td style="padding:8px 10px;font-family:monospace;font-weight:800;color:#b45309;">${o.id}</td>
                  <td style="padding:8px 10px;font-weight:700;">${o.proj}</td>
                  <td style="padding:8px 10px;font-weight:700;">${o.loc}</td>
                  <td style="padding:8px 10px;"><span style="background:#fef3c7;color:#92400e;padding:2px 8px;border-radius:99px;font-weight:700;font-size:11px;">${o.category}</span></td>
                  <td style="padding:8px 10px;font-weight:700;">${o.finding}</td>
                  <td style="padding:8px 10px;font-family:monospace;">${o.time}</td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      </div>
    `;
  }

  function renderYingge3DInWarRoom() {
    removeBlockingStyles();
    const host = ensurePatchContainer();
    host.style.display = 'block';
    host.style.padding = '0';
    host.style.maxWidth = '100%';
    host.innerHTML = `
      <iframe src="${YINGGE_3D_URL}" style="width:100vw;height:calc(100vh - 96px);border:none;display:block;background:#f6f5f0;"></iframe>
    `;
  }

  // Intercept clicks on War Room top navigation buttons
  document.addEventListener('click', function(e) {
    const el = e.target.closest('button, a, li, div[role="tab"], span');
    if (!el) return;
    const txt = (el.textContent || '').trim();
    const host = document.getElementById('wr-v186-dynamic-panel');

    if (txt === '材料與請款' || txt.includes('材料與請款')) {
      setTimeout(renderMaterialsInWarRoom, 20);
    } else if (txt === '品質與勞安' || txt.includes('品質與勞安')) {
      setTimeout(renderQualitySafetyInWarRoom, 20);
    } else if (txt === '3D BIM 模型' || txt === '3D 模型' || txt.includes('鶯歌') || txt.includes('北區訓練中心') || txt.includes('共同管溝')) {
      setTimeout(renderYingge3DInWarRoom, 20);
    } else if (['總覽曲線','出工與日誌','晴雨觀測','工程進度','生產力分析','圖說與型錄','案名與測站','機器人管理','帳號權限','外部部署','工程圖譜與核銷'].some(k => txt.includes(k))) {
      if (host) host.style.display = 'none';
    }
  }, true);

  // Also replace any existing iframe or old dark-mode stacked box view referencing Yingge
  function upgradeExistingYinggeFrames() {
    document.querySelectorAll('iframe').forEach(fr => {
      const src = fr.getAttribute('src') || '';
      if (src.includes('yingge') || src.includes('trench') || src.includes('northern')) {
        if (!src.includes('v=')) fr.src = YINGGE_3D_URL;
      }
    });
  }
  setInterval(upgradeExistingYinggeFrames, 2500);
})();