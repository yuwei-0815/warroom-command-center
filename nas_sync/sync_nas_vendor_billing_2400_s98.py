#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
S9.8 每日 24:00 自動排程：Synology NAS ↔ Google 雲端硬碟《廠商請款資料》三維比對與戰情室更新腳本 (Python 跨平台版)
比對維度：檔案名稱 (subFolder/fileName) + 修改日期 (st_mtime) + 檔案大小 (st_size)
"""
import base64
import json
import os
import pathlib
import urllib.request
from datetime import datetime, timezone, timedelta

TZ_TW = timezone(timedelta(hours=8))
NAS_ROOT = os.environ.get("RENDE2_NAS_VENDOR_DIR", r"\\dogreatnas.synology.me\元順工程-仁德二期\60-機電相關\廠商請款資料")
GAS_URL = os.environ.get(
    "RENDE2_GAS_WEBAPP_URL",
    "https://script.google.com/macros/s/AKfycbxRcVWuQzMEQWtGMd-PNqBr6ejcxjTvRLuxeRut38uwFFveHrPJDb6bbe3cRp4hkSXTsQ/exec",
)
MAX_UPLOAD_BYTES = 8 * 1024 * 1024


def fetch_drive_manifest():
    req = urllib.request.Request(f"{GAS_URL}?action=vendorBillingNasDiffS98&fast=1", method="GET")
    with urllib.request.urlopen(req, timeout=45) as resp:
        return json.loads(resp.read().decode("utf-8"))


def scan_nas_and_sync():
    drive_resp = fetch_drive_manifest()
    drive_map = {f["relKey"]: f for f in drive_resp.get("files", [])}
    nas_files = []
    root = pathlib.Path(NAS_ROOT)
    if root.exists():
        for p in sorted(root.rglob("*")):
            if not p.is_file() or p.suffix.lower() not in (".pdf", ".xlsx", ".xls"):
                continue
            rel = p.relative_to(root).as_posix()
            parts = rel.split("/")
            sub = parts[0] if len(parts) > 1 else "ROOT"
            st = p.stat()
            mod_ms = int(round(st.st_mtime * 1000))
            mod_tw = datetime.fromtimestamp(st.st_mtime, tz=TZ_TW).strftime("%Y-%m-%d %H:%M:%S")
            rel_key = f"{sub}/{p.name}"
            entry = {
                "relKey": rel_key,
                "subFolder": sub,
                "fileName": p.name,
                "sizeBytes": int(st.st_size),
                "modifiedMs": mod_ms,
                "modifiedTaipei": mod_tw,
            }
            dm = drive_map.get(rel_key)
            need_push = (
                dm is None
                or int(dm.get("driveSizeBytes", -1)) != int(st.st_size)
                or (mod_ms - int(dm.get("driveModifiedMs", 0))) > 2000
            )
            if need_push and st.st_size <= MAX_UPLOAD_BYTES:
                entry["base64"] = base64.b64encode(p.read_bytes()).decode("ascii")
            nas_files.append(entry)

    payload = json.dumps(
        {
            "action": "vendorBillingNasSyncPushS98",
            "nasPath": NAS_ROOT,
            "pushedAt": datetime.now(TZ_TW).strftime("%Y-%m-%d %H:%M:%S"),
            "nasFiles": nas_files,
        },
        ensure_ascii=False,
    ).encode("utf-8")
    req = urllib.request.Request(GAS_URL, data=payload, headers={"Content-Type": "application/json; charset=utf-8"}, method="POST")
    with urllib.request.urlopen(req, timeout=90) as resp:
        result = json.loads(resp.read().decode("utf-8"))
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return result


if __name__ == "__main__":
    scan_nas_and_sync()
