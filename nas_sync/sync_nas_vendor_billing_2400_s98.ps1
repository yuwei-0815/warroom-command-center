# ==============================================================================
# S9.8 每日 24:00 自動排程：Synology NAS ↔ Google 雲端硬碟《廠商請款資料》三維同步腳本
# 比對維度：1. 檔案名稱 (SubFolder/Name)  2. 修改日期 (LastWriteTimeUtc)  3. 檔案大小 (Length)
# 同步完成後自動推送三維比對結果至 GAS 雲端核心並熱更新工務戰情室！
# ==============================================================================
param(
    [string]$NasRoot = "\\dogreatnas.synology.me\元順工程-仁德二期\60-機電相關\廠商請款資料",
    [string]$LocalDriveMirrorRoot = "",
    [string]$GasWebAppUrl = "https://script.google.com/macros/s/AKfycbxRcVWuQzMEQWtGMd-PNqBr6ejcxjTvRLuxeRut38uwFFveHrPJDb6bbe3cRp4hkSXTsQ/exec",
    [int]$MaxInlineUploadBytes = 8388608
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "[S9.8 24:00 排程] 啟動《廠商請款資料》NAS × 雲端硬碟三維比對 (檔名 × 修改日期 × 檔案大小)..."

# 1. 若本機掛載 Google Drive Desktop，優先執行雙向實體檔案三維同步 (檔名 + 修改時間誤差>2秒 + 檔案大小)
if ($LocalDriveMirrorRoot -and (Test-Path -LiteralPath $LocalDriveMirrorRoot) -and (Test-Path -LiteralPath $NasRoot)) {
    $nasFiles = Get-ChildItem -LiteralPath $NasRoot -Recurse -File | Where-Object { $_.Extension -match '\.(pdf|xlsx|xls)$' }
    foreach ($nf in $nasFiles) {
        $rel = $nf.FullName.Substring($NasRoot.Length).TrimStart('\', '/')
        $dstPath = Join-Path $LocalDriveMirrorRoot $rel
        $dstDir = Split-Path $dstPath -Parent
        if (-not (Test-Path -LiteralPath $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
        $needCopy = $false
        if (-not (Test-Path -LiteralPath $dstPath)) {
            $needCopy = $true
        } else {
            $df = Get-Item -LiteralPath $dstPath
            $timeDiffSec = [Math]::Abs(($nf.LastWriteTimeUtc - $df.LastWriteTimeUtc).TotalSeconds)
            if ($nf.Length -ne $df.Length -or ($nf.LastWriteTimeUtc -gt $df.LastWriteTimeUtc.AddSeconds(2))) {
                $needCopy = $true
            }
        }
        if ($needCopy) {
            Copy-Item -LiteralPath $nf.FullName -Destination $dstPath -Force
            (Get-Item -LiteralPath $dstPath).LastWriteTimeUtc = $nf.LastWriteTimeUtc
            Write-Host "  [NAS ➔ 雲端鏡像] 已同步更新: $rel ($($nf.Length) Bytes)"
        }
    }
}

# 2. 向 GAS 取得目前雲端硬碟 (1GdwccNDwPL9X1JZFgxODseQifHessr4M) 三維清單
$driveManifestResp = Invoke-RestMethod -Method Get -Uri ($GasWebAppUrl + "?action=vendorBillingNasDiffS98&fast=1") -TimeoutSec 45
$driveMap = @{}
if ($driveManifestResp -and $driveManifestResp.files) {
    foreach ($df in $driveManifestResp.files) {
        $driveMap[$df.relKey] = $df
    }
}

# 3. 掃描 NAS 端所有請款檔案之 (子夾/檔名, 修改日期EpochMs, 檔案大小Bytes)，對差異或新增檔案附帶 Base64 自動上傳雲端
$nasManifest = @()
if (Test-Path -LiteralPath $NasRoot) {
    $allNas = Get-ChildItem -LiteralPath $NasRoot -Recurse -File | Where-Object { $_.Extension -match '\.(pdf|xlsx|xls)$' }
    foreach ($f in $allNas) {
        $relPath = $f.FullName.Substring($NasRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $parts = $relPath.Split('/')
        $subFolder = if ($parts.Length -gt 1) { $parts[0] } else { "ROOT" }
        $epochMs = [int64]([DateTimeOffset]$f.LastWriteTimeUtc).ToUnixTimeMilliseconds()
        $twTime = $f.LastWriteTimeUtc.AddHours(8).ToString("yyyy-MM-dd HH:mm:ss")
        $item = @{
            relKey = "$subFolder/$($f.Name)"
            subFolder = $subFolder
            fileName = $f.Name
            sizeBytes = [int64]$f.Length
            modifiedMs = $epochMs
            modifiedTaipei = $twTime
        }
        $dMatch = $driveMap[$item.relKey]
        $isDiffOrNew = (-not $dMatch) -or ([int64]$dMatch.driveSizeBytes -ne [int64]$f.Length) -or (($epochMs - [int64]$dMatch.driveModifiedMs) -gt 2000)
        if ($isDiffOrNew -and $f.Length -le $MaxInlineUploadBytes) {
            $item.base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName))
        }
        $nasManifest += $item
    }
}

# 4. 推送 NAS 三維清冊至 GAS 執行雙向對帳、寫入《工務云》並即時熱更新戰情室
$payload = @{
    action = "vendorBillingNasSyncPushS98"
    nasPath = $NasRoot
    pushedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    nasFiles = $nasManifest
} | ConvertTo-Json -Depth 6 -Compress

$syncRes = Invoke-RestMethod -Method Post -Uri $GasWebAppUrl -Body ([System.Text.Encoding]::UTF8.GetBytes($payload)) -ContentType "application/json; charset=utf-8" -TimeoutSec 90
Write-Host ("[S9.8 完成] 總檔案: {0} | 三維一致: {1} | 差異/同步: {2} | 戰情室已熱更新: {3}" -f $syncRes.totalFiles, $syncRes.matched3TupleCount, $syncRes.syncedCount, $syncRes.checkedAt)
