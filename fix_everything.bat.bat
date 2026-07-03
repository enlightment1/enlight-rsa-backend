@echo off
title ENLIGHT RSA - FIX EVERYTHING
color 0A
echo ============================================================
echo        ENLIGHT RSA - FIX EVERYTHING SCRIPT
echo ============================================================
echo.

REM ---------- STEP 1: COPY HTML FILE ----------
echo [1/6] Copying HTML file...
if exist "index.html" (
    echo       ✅ index.html already exists.
) else (
    if exist "..\enlight_rsa.html" (
        echo       Copying from parent folder...
        copy /Y "..\enlight_rsa.html" "index.html" >nul
        echo       ✅ Copied successfully.
    ) else (
        echo       ❌ No HTML file found!
        echo       Please place enlight_rsa.html in this folder.
        pause
        exit /b 1
    )
)

REM ---------- STEP 2: UPDATE BACKEND_URL ----------
echo [2/6] Updating BACKEND_URL...
powershell -Command "(Get-Content index.html) -replace 'const BACKEND_URL = .*', 'const BACKEND_URL = \"https://splendid-freedom.up.railway.app\".replace(/\/$/, \"\");' | Set-Content index.html" >nul
echo       ✅ BACKEND_URL set to https://splendid-freedom.up.railway.app

REM ---------- STEP 3: FIX APP.PY ----------
echo [3/6] Fixing app.py...
powershell -Command "$content = Get-Content app.py -Raw; $content = $content -replace '(from fastapi import FastAPI,.*?)(\s+)(from fastapi\.staticfiles import .*?)?', '$1'; $content = $content -replace '(from fastapi import FastAPI,.*)', '$1`nfrom fastapi.staticfiles import StaticFiles'; $content = $content -replace '(app\.add_middleware\([^)]+\)\s*)', '$1`napp.mount(\"/\", StaticFiles(directory=\".\", html=True), name=\"static\")'; $content | Set-Content app.py" >nul
echo       ✅ app.py fixed and ready.

REM ---------- STEP 4: GIT ADD & COMMIT ----------
echo [4/6] Adding files to Git...
git add -A >nul 2>&1
echo       ✅ Files added.

REM ---------- STEP 5: COMMIT & PUSH ----------
echo [5/6] Committing and pushing to GitHub...
git commit -m "ENLIGHT RSA - Full deployment with frontend" >nul 2>&1
git push origin main
echo       ✅ Pushed to GitHub successfully.

REM ---------- STEP 6: DEPLOY TO RAILWAY ----------
echo [6/6] Deploying to Railway...
railway up

echo.
echo ============================================================
echo        ✅ ALL DONE!
echo ============================================================
echo.
echo Your app is live at:
echo   https://splendid-freedom.up.railway.app
echo.
echo API Health Check:
echo   https://splendid-freedom.up.railway.app/api/health
echo.
echo Admin Login:
echo   Email: zwanelwazi04@gmail.com
echo   Password: [anything] + 0639264528LwaziZwane
echo.
echo If the CLI timed out, deploy manually:
echo   1. Go to: https://railway.com/project/04427592-3938-49b6-8359-52c0f7622f2f
echo   2. Click "Deploy" → "Deploy from GitHub"
echo   3. Select enlightment1/enlight-rsa-backend, branch main
echo   4. Click "Deploy"
echo.
pause