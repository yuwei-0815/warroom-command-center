# ==============================================================================
# S9.9 Daily 24:00 Schedule: Synology NAS <-> Google Drive Vendor Billing 3-Tuple Sync
# Dimensions: (1) File Name  (2) Modified Time (<=2s)  (3) File Size (Bytes)
# Saved with UTF-8 BOM + CRLF + ExecutionPolicy/302-Redirect Safe Wrapper for Windows 10
# ==============================================================================
param(
    [string]$NasRoot = "",
    [string]$LocalDriveMirrorRoot = "",
    [string]$GasWebAppUrl = "https://script.google.com/macros/s/AKfycbxRcVWuQzMEQWtGMd-PNqBr6ejcxjTvRLuxeRut38uwFFveHrPJDb6bbe3cRp4hkSXTsQ/exec",
    [int]$MaxInlineUploadBytes = 8388608,
    [switch]$Scheduled,
    [switch]$RegisterTask
)

$ErrorActionPreference = "Continue"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$DefaultNasSub = (-join ([char[]]@(0x5143,0x9806,0x5DE5,0x7A0B,0x002D,0x4EC1,0x5FB7,0x4E8C,0x671F,0x005C,0x0036,0x0030,0x002D,0x6A5F,0x96FB,0x76F8,0x95DC,0x005C,0x5EE0,0x5546,0x8ACB,0x6B3E,0x8CC7,0x6599)))
if ([string]::IsNullOrWhiteSpace($NasRoot)) {
    $NasRoot = "\\dogreatnas.synology.me\" + $DefaultNasSub
}

# Auto-detect Google Drive for Desktop local mount if $LocalDriveMirrorRoot is omitted
if ([string]::IsNullOrWhiteSpace($LocalDriveMirrorRoot)) {
    $Rel1 = (-join ([char[]]@(0x6211,0x7684,0x96F2,0x7AEF,0x786C,0x789F,0x005C,0x004C,0x0049,0x004E,0x0045,0x0020,0x0042,0x004F,0x0054,0x005C,0x0030,0x0031,0x002D,0x4EC1,0x5FB7,0x570B,0x5C0F,0x0028,0x7B2C,0x4E8C,0x671F,0x0029,0x005C,0x0036,0x0030,0x002D,0x6A5F,0x96FB,0x76F8,0x95DC,0x005C,0x5EE0,0x5546,0x8ACB,0x6B3E,0x8CC7,0x6599)))
    $Rel2 = (-join ([char[]]@(0x004C,0x0049,0x004E,0x0045,0x0020,0x0042,0x004F,0x0054,0x005C,0x0030,0x0031,0x002D,0x4EC1,0x5FB7,0x570B,0x5C0F,0x0028,0x7B2C,0x4E8C,0x671F,0x0029,0x005C,0x0036,0x0030,0x002D,0x6A5F,0x96FB,0x76F8,0x95DC,0x005C,0x5EE0,0x5546,0x8ACB,0x6B3E,0x8CC7,0x6599)))
    foreach ($drv in @("G:\", "H:\", "I:\", "D:\", "E:\", "C:\")) {
        $cand1 = Join-Path $drv $Rel1
        $cand2 = Join-Path $drv $Rel2
        if (Test-Path -LiteralPath $cand1) { $LocalDriveMirrorRoot = $cand1; break }
        if (Test-Path -LiteralPath $cand2) { $LocalDriveMirrorRoot = $cand2; break }
    }
}

$ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$LogFile = Join-Path $ScriptDir "sync_nas_vendor_billing_2400.log"
function Write-SyncLog([string]$Msg) {
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $line = "[$ts] $Msg"
    Write-Host $line
    try { [System.IO.File]::AppendAllText($LogFile, ($line + [Environment]::NewLine), [System.Text.Encoding]::UTF8) } catch {}
}

# Optional: Auto-register daily 24:00 (00:00) Windows Scheduled Task
if ($RegisterTask) {
    $SelfPs1 = Join-Path $ScriptDir "sync_nas_vendor_billing_2400_s98.ps1"
    if ($MyInvocation.MyCommand.Path) { $SelfPs1 = $MyInvocation.MyCommand.Path }
    $TaskName = "Rende2_VendorBilling_NAS_Sync_2400"
    $TaskCmd = "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$SelfPs1`" -Scheduled"
    Write-SyncLog "[S9.9 Schedule] Registering daily 00:00 (24:00) Windows Task: $TaskName"
    & schtasks.exe /Create /TN $TaskName /TR $TaskCmd /SC DAILY /ST 00:00 /F | Out-Host
}

# Safe HTTP GET & POST helpers for Google Apps Script (/exec 302 redirect -> script.googleusercontent.com)
function Invoke-GasGetJson([string]$Url, [int]$TimeoutSec = 45) {
    $req = [System.Net.HttpWebRequest]::Create($Url)
    $req.Method = "GET"
    $req.AllowAutoRedirect = $true
    $req.Timeout = $TimeoutSec * 1000
    $req.UserAgent = "Rende2-NAS-Sync-S99/1.0"
    $resp = $req.GetResponse()
    try {
        $sr = New-Object System.IO.StreamReader($resp.GetResponseStream(), [System.Text.Encoding]::UTF8)
        $raw = $sr.ReadToEnd()
        $sr.Close()
    } finally {
        $resp.Close()
    }
    if ($raw -and $raw.TrimStart().StartsWith("{")) {
        return ($raw | ConvertFrom-Json)
    }
    return $null
}

function Invoke-GasPostJson302Safe([string]$Url, [string]$JsonBody, [int]$TimeoutSec = 90) {
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($JsonBody)
    $req = [System.Net.HttpWebRequest]::Create($Url)
    $req.Method = "POST"
    $req.AllowAutoRedirect = $false
    $req.ContentType = "text/plain; charset=utf-8"
    $req.ContentLength = $bodyBytes.Length
    $req.Timeout = $TimeoutSec * 1000
    $req.UserAgent = "Rende2-NAS-Sync-S99/1.0"
    $reqStream = $req.GetRequestStream()
    $reqStream.Write($bodyBytes, 0, $bodyBytes.Length)
    $reqStream.Close()

    $redirectUrl = $null
    $directText = $null
    try {
        $resp = [System.Net.HttpWebResponse]$req.GetResponse()
        $code = [int]$resp.StatusCode
        if ($code -ge 300 -and $code -lt 400) {
            $redirectUrl = $resp.Headers["Location"]
        } else {
            $sr = New-Object System.IO.StreamReader($resp.GetResponseStream(), [System.Text.Encoding]::UTF8)
            $directText = $sr.ReadToEnd()
            $sr.Close()
        }
        $resp.Close()
    } catch [System.Net.WebException] {
        $wResp = [System.Net.HttpWebResponse]$_.Exception.Response
        if ($wResp -ne $null) {
            $code = [int]$wResp.StatusCode
            if ($code -ge 300 -and $code -lt 400) {
                $redirectUrl = $wResp.Headers["Location"]
            }
            $wResp.Close()
        } else {
            throw
        }
    }

    if ($redirectUrl) {
        return (Invoke-GasGetJson -Url $redirectUrl -TimeoutSec $TimeoutSec)
    }
    if ($directText -and $directText.TrimStart().StartsWith("{")) {
        return ($directText | ConvertFrom-Json)
    }
    return $null
}

Write-SyncLog "[S9.9 24:00 Sync] Starting NAS x Google Drive Vendor Billing 3-Tuple Check..."
Write-SyncLog ("  NAS Path   : " + $NasRoot)
Write-SyncLog ("  Local Mirror: " + $(if ($LocalDriveMirrorRoot) { $LocalDriveMirrorRoot } else { "(Using Cloud GAS Bridge)" }))

$nasReachable = $false
try { $nasReachable = Test-Path -LiteralPath $NasRoot } catch { $nasReachable = $false }

# 1. Local Google Drive Desktop <-> NAS bidirectional sync (if both mounted locally)
$localCopiedCount = 0
if ($nasReachable -and $LocalDriveMirrorRoot -and (Test-Path -LiteralPath $LocalDriveMirrorRoot)) {
    $nasFilesLocal = Get-ChildItem -LiteralPath $NasRoot -Recurse -File | Where-Object { $_.Extension -match '\.(pdf|xlsx|xls)$' }
    foreach ($nf in $nasFilesLocal) {
        $rel = $nf.FullName.Substring($NasRoot.Length).TrimStart('\', '/')
        $dstPath = Join-Path $LocalDriveMirrorRoot $rel
        $dstDir = Split-Path $dstPath -Parent
        if (-not (Test-Path -LiteralPath $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
        $needCopy = $false
        if (-not (Test-Path -LiteralPath $dstPath)) {
            $needCopy = $true
        } else {
            $df = Get-Item -LiteralPath $dstPath
            $tDiff = [Math]::Abs(($nf.LastWriteTimeUtc - $df.LastWriteTimeUtc).TotalSeconds)
            if (($nf.Length -ne $df.Length) -or ($tDiff -gt 2 -and $nf.LastWriteTimeUtc -gt $df.LastWriteTimeUtc)) {
                $needCopy = $true
            }
        }
        if ($needCopy) {
            Copy-Item -LiteralPath $nf.FullName -Destination $dstPath -Force
            try { (Get-Item -LiteralPath $dstPath).LastWriteTimeUtc = $nf.LastWriteTimeUtc } catch {}
            $localCopiedCount++
            Write-SyncLog ("  [NAS -> Drive Mirror] Synced: " + $rel + " (" + $nf.Length + " B)")
        }
    }
    # Reverse check: Drive Mirror -> NAS for newly uploaded cloud files
    $drvFilesLocal = Get-ChildItem -LiteralPath $LocalDriveMirrorRoot -Recurse -File | Where-Object { $_.Extension -match '\.(pdf|xlsx|xls)$' }
    foreach ($df2 in $drvFilesLocal) {
        $rel2 = $df2.FullName.Substring($LocalDriveMirrorRoot.Length).TrimStart('\', '/')
        $nasDst = Join-Path $NasRoot $rel2
        $nasDstDir = Split-Path $nasDst -Parent
        if (-not (Test-Path -LiteralPath $nasDst)) {
            if (-not (Test-Path -LiteralPath $nasDstDir)) { New-Item -ItemType Directory -Path $nasDstDir -Force | Out-Null }
            Copy-Item -LiteralPath $df2.FullName -Destination $nasDst -Force
            try { (Get-Item -LiteralPath $nasDst).LastWriteTimeUtc = $df2.LastWriteTimeUtc } catch {}
            $localCopiedCount++
            Write-SyncLog ("  [Drive Mirror -> NAS] Synced: " + $rel2 + " (" + $df2.Length + " B)")
        }
    }
}

# 2. Fetch Cloud Drive (1GdwccNDwPL9X1JZFgxODseQifHessr4M) 3-Tuple manifest from GAS
$driveManifestResp = $null
try {
    $driveManifestResp = Invoke-GasGetJson -Url ($GasWebAppUrl + "?action=vendorBillingNasDiffS98&fast=1&t=" + [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()) -TimeoutSec 45
    if (-not $driveManifestResp) {
        $null = Invoke-GasGetJson -Url ($GasWebAppUrl + "?action=hotReload&force=1") -TimeoutSec 30
        $driveManifestResp = Invoke-GasGetJson -Url ($GasWebAppUrl + "?action=vendorBillingNasDiffS98&fast=1") -TimeoutSec 45
    }
} catch {
    Write-SyncLog ("  [WARN] Cloud manifest GET note: " + $_.Exception.Message)
}

$driveMap = @{}
if ($driveManifestResp -and $driveManifestResp.files) {
    foreach ($dfItem in $driveManifestResp.files) {
        if ($dfItem.relKey) { $driveMap[[string]$dfItem.relKey] = $dfItem }
    }
    Write-SyncLog ("  [Cloud Manifest] Loaded " + $driveMap.Count + " files from Google Drive.")
}

# 3. Scan NAS 3-Tuple (SubFolder/FileName, ModifiedEpochMs, SizeBytes)
$nasManifest = @()
$epochZero = New-Object DateTime(1970, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
if ($nasReachable) {
    $allNas = Get-ChildItem -LiteralPath $NasRoot -Recurse -File | Where-Object { $_.Extension -match '\.(pdf|xlsx|xls)$' }
    foreach ($f in $allNas) {
        $relPath = $f.FullName.Substring($NasRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $parts = $relPath.Split('/')
        $subFolder = if ($parts.Length -gt 1) { $parts[0] } else { "ROOT" }
        $epochMs = [int64][Math]::Round(($f.LastWriteTimeUtc - $epochZero).TotalMilliseconds)
        $twTime = $f.LastWriteTimeUtc.AddHours(8).ToString("yyyy-MM-dd HH:mm:ss")
        $rKey = "$subFolder/$($f.Name)"
        $item = @{
            relKey = $rKey
            subFolder = $subFolder
            fileName = $f.Name
            sizeBytes = [int64]$f.Length
            modifiedMs = $epochMs
            modifiedTaipei = $twTime
        }
        $dMatch = $driveMap[$rKey]
        $isDiffOrNew = (-not $dMatch) -or ([int64]$dMatch.driveSizeBytes -ne [int64]$f.Length) -or (($epochMs - [int64]$dMatch.driveModifiedMs) -gt 2000)
        if ($isDiffOrNew -and $f.Length -le $MaxInlineUploadBytes) {
            $item.base64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($f.FullName))
        }
        $nasManifest += $item
    }
    Write-SyncLog ("  [NAS Scan] Scanned " + $nasManifest.Count + " files from Synology NAS.")
} else {
    Write-SyncLog "  [NAS Notice] Synology NAS UNC path is not reachable from current network; running cloud-side 3-tuple verification."
}

# 4. Push 3-Tuple Manifest to GAS & Trigger War Room Live Hot-Update
$syncRes = $null
try {
    if ($nasReachable -and $nasManifest.Count -gt 0) {
        $payloadJson = @{
            action = "vendorBillingNasSyncPushS98"
            nasPath = $NasRoot
            pushedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            nasFiles = $nasManifest
        } | ConvertTo-Json -Depth 6 -Compress
        $syncRes = Invoke-GasPostJson302Safe -Url $GasWebAppUrl -JsonBody $payloadJson -TimeoutSec 90
    } else {
        $syncRes = Invoke-GasGetJson -Url ($GasWebAppUrl + "?action=vendorBillingNasDiffS98&force=1") -TimeoutSec 60
    }
} catch {
    Write-SyncLog ("  [ERROR] Cloud sync push warning: " + $_.Exception.Message)
}

if ($syncRes -and $syncRes.totalFiles) {
    Write-SyncLog ("[S9.9 Completed] Total=" + $syncRes.totalFiles + " | 3-Tuple Matched=" + $syncRes.matched3TupleCount + " | Synced=" + ($syncRes.syncedCount + $localCopiedCount) + " | Anomalies=" + $syncRes.anomalyCount + " | WarRoom Updated=" + $syncRes.checkedAt)
} else {
    Write-SyncLog ("[S9.9 Local Check Completed] Local Mirror Synced=" + $localCopiedCount + " | Log saved to: " + $LogFile)
}

if (-not $Scheduled) {
    Write-Host ""
    $null = Read-Host "Press Enter to close window"
}
