@echo off
chcp 65001 >nul
title 成立规模邮箱桥接服务（龙腾鑫享平台）
echo ============================================
echo  成立规模邮箱桥接服务 - 龙腾鑫享产品管理平台
echo  用于页面「录入成立规模 → 📬 从邮箱读取」
echo  请保持此窗口开启，关闭窗口即停止服务
echo ============================================
echo.
cd /d "%~dp0"

REM 优先使用 hermes venv 的 python（已装 openpyxl）
set "PYEXE=D:\Users\yangzy\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe"
if not exist "%PYEXE%" set "PYEXE=python"

REM 检查 openpyxl 依赖
"%PYEXE%" -c "import openpyxl" >nul 2>&1
if errorlevel 1 (
    echo [依赖检查] 未检测到 openpyxl，正在安装...
    "%PYEXE%" -m pip install openpyxl -i https://pypi.tuna.tsinghua.edu.cn/simple
)

"%PYEXE%" scale_bridge.py
echo.
echo 服务已停止。
pause
