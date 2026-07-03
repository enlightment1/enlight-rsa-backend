@echo off
title ENLIGHT RSA - CLEAN & FIX
color 0A
echo ============================================================
echo        ENLIGHT RSA - CLEAN & FIX SCRIPT
echo ============================================================
echo.

REM ---------- DELETE JUNK FILES ----------
echo [1/5] Deleting junk files...
if exist "#" del "#" >nul 2>&1
if exist "cd" del "cd" >nul 2>&1
if exist "git" del "git" >nul 2>&1
if exist "*.pyc" del *.pyc >nul 2>&1
if exist "__pycache__" rmdir /s /q "__pycache__" >nul 2>&1
if exist "*.bak" del *.bak >nul 2>&1
if exist "*.tmp" del *.tmp >nul 2>&1
echo       ✅ Junk files removed.

REM ---------- ENSURE index.html ----------
echo [2/5] Ensuring index.html exists...
if exist "index.html" (
    echo       ✅ index.html found.
) else (
    if exist "..\enlight_rsa.html" (
        echo       Copying from parent folder...
        copy /Y "..\enlight_rsa.html" "index.html" >nul
        echo       ✅ Copied.
    ) else (
        echo       ❌ No HTML file found! Place enlight_rsa.html in this folder.
        pause
        exit /b 1
    )
)

REM ---------- UPDATE BACKEND_URL ----------
echo [3/5] Updating BACKEND_URL...
powershell -Command "(Get-Content index.html) -replace 'const BACKEND_URL = .*', 'const BACKEND_URL = \"https://splendid-freedom.up.railway.app\".replace(/\/$/, \"\");' | Set-Content index.html" >nul
echo       ✅ BACKEND_URL set.

REM ---------- FIX APP.PY (MANUAL REPLACE) ----------
echo [4/5] Fixing app.py...
powershell -Command "$content = Get-Content app.py -Raw; $content = $content -replace '(from fastapi import FastAPI, HTTPException, Request, Depends, Header, UploadFile, File, Form, Query)(`nfrom fastapi\.staticfiles import StaticFiles)+', '$1`nfrom fastapi.staticfiles import StaticFiles'; $content | Set-Content app.py" >nul
powershell -Command "$content = Get-Content app.py -Raw; if ($content -notmatch 'app\.mount\(') { $content = $content -replace '(app\.add_middleware\([^)]+\)\s*)', '$1`napp.mount(\"/\", StaticFiles(directory=\".\", html=True), name=\"static\")'; $content | Set-Content app.py }" >nul
echo       ✅ app.py fixed.

REM ---------- COMMIT AND PUSH ----------
echo [5/5] Committing and pushing to GitHub...
git add -A >nul 2>&1
git commit -m "Cleanup and fix app.py" >nul 2>&1
git push origin main
echo       ✅ Pushed to GitHub.

echo.
echo ============================================================
echo        ✅ ALL DONE!
echo ============================================================
echo.
echo Now deploy from Railway dashboard:
echo   1. Go to: https://railway.com/project/04427592-3938-49b6-8359-52c0f7622f2f
echo   2. Click "Deploy" → "Deploy from GitHub"
echo   3. Select enlightment1/enlight-rsa-backend, branch main
echo   4. Click "Deploy"
echo.
echo Your app will be live at:
echo   https://splendid-freedom.up.railway.app
echo.
pause