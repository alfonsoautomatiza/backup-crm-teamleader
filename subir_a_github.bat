@echo off
REM Deploy multilingual documentation to GitHub Pages
REM Uses single mkdocs.yml configuration for all languages

echo ========================================
echo Deploying Backup Teamleader Documentation
echo ========================================
echo ========================================
echo.
set PYTHONUTF8=1

REM Check if git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed or not in PATH!
    pause
    exit /b 1
)


echo.
echo Deploying to GitHub Pages...
echo.

echo ========================================
echo Deploying to gh-pages branch...
echo ========================================

REM GitHub sometimes closes HTTPS/2 pushes while MkDocs is uploading gh-pages.
REM Use HTTP/1.1 for this repository and retry the push once if gh-deploy fails.
git config --local http.version HTTP/1.1

REM Recreate the generated gh-pages branch from scratch.
REM This avoids publishing failures caused by stale or damaged local gh-pages objects.
git branch -D gh-pages >nul 2>&1

REM Deploy using mkdocs gh-deploy
mkdocs gh-deploy --force
if %errorlevel% neq 0 (
    echo.
    echo MkDocs deploy failed. Retrying git push for gh-pages...
    git -c http.version=HTTP/1.1 push origin gh-pages
    if %errorlevel% neq 0 (
        echo Deployment failed!
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo Deployment successful!
echo ========================================
echo.
echo Your documentation is now live at:
echo - Spanish: https://wertymsd.github.io/manual-backup-crm-teamleader/
echo.
echo Use the language flags (bandera_es.png, bandera_en.png, bandera_fr.png)
echo to switch between languages!
echo.

pause
