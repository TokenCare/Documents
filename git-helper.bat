```bat
@echo off
setlocal EnableExtensions EnableDelayedExpansion

title TokenCare Documents - Git Helper

REM ============================================================
REM TokenCare Documents - Git Helper
REM ============================================================
REM Repository:
REM   https://github.com/TokenCare/Documents
REM
REM IMPORTANT:
REM   This script operates on the CURRENT DIRECTORY.
REM
REM Example:
REM   C:\Projects\TokenCare\Documents> git-helper.bat
REM
REM Log:
REM   .git-helper\git-helper.log
REM ============================================================

set "REPO_URL=https://github.com/TokenCare/Documents.git"
set "CURRENT_DIR=%CD%"
set "LOG_DIR=%CD%\.git-helper"
set "LOG_FILE=%LOG_DIR%\git-helper.log"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1

call :LOG "============================================================"
call :LOG "Git Helper started"
call :LOG "Current directory: %CURRENT_DIR%"

REM ============================================================
REM Check Git
REM ============================================================

where git >nul 2>&1

if errorlevel 1 (
    cls
    echo.
    echo ============================================================
    echo   ERROR: Git is not installed
    echo ============================================================
    echo.
    echo Please install Git for Windows:
    echo.
    echo   https://git-scm.com/download/win
    echo.
    call :LOG "ERROR: Git is not installed"
    pause
    exit /b 1
)

REM ============================================================
REM Check Git repository
REM ============================================================

git rev-parse --is-inside-work-tree >nul 2>&1

if errorlevel 1 (
    cls
    echo.
    echo ============================================================
    echo   ERROR: CURRENT DIRECTORY IS NOT A GIT REPOSITORY
    echo ============================================================
    echo.
    echo Current directory:
    echo   %CURRENT_DIR%
    echo.
    echo If this is the first setup, clone the repository:
    echo.
    echo   git clone %REPO_URL%
    echo.
    echo Then enter the Documents directory and run this script.
    echo.
    call :LOG "ERROR: Current directory is not a Git repository"
    pause
    exit /b 1
)

REM ============================================================
REM Repository information
REM ============================================================

for /f "delims=" %%R in ('git rev-parse --show-toplevel 2^>nul') do set "REPO_ROOT=%%R"

for /f "delims=" %%B in ('git branch --show-current 2^>nul') do set "CURRENT_BRANCH=%%B"

call :LOG "Repository root: %REPO_ROOT%"
call :LOG "Current branch: %CURRENT_BRANCH%"

REM ============================================================
REM MAIN MENU
REM ============================================================

:MENU

cls

echo.
echo ============================================================
echo          TOKENCARE DOCUMENTS - GIT HELPER
echo ============================================================
echo.
echo Current directory:
echo   %CURRENT_DIR%
echo.
echo Repository:
echo   %REPO_ROOT%
echo.
echo Current branch:
echo   %CURRENT_BRANCH%
echo.
echo ============================================================
echo.
echo   1.  Check Git Status
echo   2.  Sync MAIN
echo   3.  Create New Branch
echo   4.  Add Changes
echo   5.  Commit Changes
echo   6.  Push Current Branch
echo   7.  Pull Current Branch
echo   8.  View Changes
echo   9.  View Branches
echo   10. View Commit History
echo   11. Full New-Task Workflow
echo   12. Configure Git Identity
echo   13. Open GitHub Repository
echo   14. Open Git Log
echo   15. Exit
echo.
echo ============================================================
echo.

set "CHOICE="
set /p "CHOICE=Select an option: "

if "%CHOICE%"=="1" goto STATUS
if "%CHOICE%"=="2" goto SYNC_MAIN
if "%CHOICE%"=="3" goto CREATE_BRANCH
if "%CHOICE%"=="4" goto ADD_CHANGES
if "%CHOICE%"=="5" goto COMMIT_CHANGES
if "%CHOICE%"=="6" goto PUSH_BRANCH
if "%CHOICE%"=="7" goto PULL_CURRENT
if "%CHOICE%"=="8" goto VIEW_CHANGES
if "%CHOICE%"=="9" goto VIEW_BRANCHES
if "%CHOICE%"=="10" goto HISTORY
if "%CHOICE%"=="11" goto FULL_WORKFLOW
if "%CHOICE%"=="12" goto CONFIGURE_IDENTITY
if "%CHOICE%"=="13" goto OPEN_GITHUB
if "%CHOICE%"=="14" goto OPEN_LOG
if "%CHOICE%"=="15" goto EXIT

echo.
echo Invalid option.
pause
goto MENU


REM ============================================================
REM 1. STATUS
REM ============================================================

:STATUS

cls

echo ============================================================
echo   GIT STATUS
echo ============================================================
echo.

git status

call :LOG "Checked Git status"

echo.
pause
goto MENU


REM ============================================================
REM 2. SYNC MAIN
REM ============================================================

:SYNC_MAIN

cls

echo ============================================================
echo   SYNC MAIN
echo ============================================================
echo.

for /f "delims=" %%B in ('git branch --show-current 2^>nul') do set "CURRENT_BRANCH=%%B"

if not "%CURRENT_BRANCH%"=="main" (

    echo Current branch:
    echo   %CURRENT_BRANCH%
    echo.
    echo You are not currently on MAIN.
    echo This operation will switch to MAIN.
    echo.

    git status --porcelain

    if not errorlevel 1 (
        echo.
        echo ERROR:
        echo You have uncommitted changes.
        echo.
        echo Commit or safely store your changes before
        echo switching to MAIN.
        echo.

        call :LOG "Sync MAIN blocked: uncommitted changes exist"

        pause
        goto MENU
    )

    git checkout main

    if errorlevel 1 (
        echo.
        echo Failed to switch to MAIN.
        call :LOG "ERROR: Failed to checkout MAIN"
        pause
        goto MENU
    )
)

echo.
echo Pulling latest MAIN from GitHub...
echo.

git pull origin main

if errorlevel 1 (
    echo.
    echo ERROR: Failed to synchronize MAIN.
    call :LOG "ERROR: git pull origin main failed"
) else (
    echo.
    echo MAIN synchronized successfully.
    call :LOG "MAIN synchronized successfully"
)

set "CURRENT_BRANCH=main"

echo.
pause
goto MENU


REM ============================================================
REM 3. CREATE NEW BRANCH
REM ============================================================

:CREATE_BRANCH

cls

echo ============================================================
echo   CREATE NEW BRANCH
echo ============================================================
echo.

echo Current branch:
echo   %CURRENT_BRANCH%
echo.

echo Recommended branch names:
echo.
echo   docs/fhir
echo   docs/abdm
echo   docs/architecture
echo   docs/api
echo   docs/healthcare-workflow
echo   fix/fhir-document
echo   update/readme
echo.

set "BRANCH_NAME="
set /p "BRANCH_NAME=Enter new branch name: "

if "%BRANCH_NAME%"=="" (
    echo.
    echo Branch name cannot be empty.
    pause
    goto MENU
)

echo.
echo Creating branch:
echo   %BRANCH_NAME%
echo.

git checkout -b "%BRANCH_NAME%"

if errorlevel 1 (
    echo.
    echo ERROR: Could not create branch.
    call :LOG "ERROR: Failed to create branch %BRANCH_NAME%"
) else (
    set "CURRENT_BRANCH=%BRANCH_NAME%"
    echo.
    echo Branch created successfully.
    echo Current branch:
    echo   %CURRENT_BRANCH%
    call :LOG "Created branch: %BRANCH_NAME%"
)

echo.
pause
goto MENU


REM ============================================================
REM 4. ADD CHANGES
REM ============================================================

:ADD_CHANGES

cls

echo ============================================================
echo   ADD CHANGES
echo ============================================================
echo.

echo Current branch:
echo   %CURRENT_BRANCH%
echo.

echo Current changes:
echo.

git status --short

echo.
echo ============================================================
echo   1. Add ALL changes
echo   2. Add a specific file
echo   3. Cancel
echo ============================================================
echo.

set "ADD_CHOICE="
set /p "ADD_CHOICE=Select: "

if "%ADD_CHOICE%"=="1" goto ADD_ALL
if "%ADD_CHOICE%"=="2" goto ADD_FILE
if "%ADD_CHOICE%"=="3" goto MENU

goto ADD_CHANGES


:ADD_ALL

echo.
echo Adding all changes...
echo.

git add .

if errorlevel 1 (
    echo ERROR: Failed to stage changes.
    call :LOG "ERROR: git add . failed"
) else (
    echo.
    echo All changes staged successfully.
    call :LOG "Staged all changes"
)

echo.
git status --short

echo.
pause
goto MENU


:ADD_FILE

echo.
set "FILE_NAME="
set /p "FILE_NAME=Enter file path: "

if "%FILE_NAME%"=="" goto ADD_CHANGES

git add "%FILE_NAME%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to stage file.
    call :LOG "ERROR: Failed to stage %FILE_NAME%"
) else (
    echo.
    echo File staged:
    echo   %FILE_NAME%
    call :LOG "Staged file: %FILE_NAME%"
)

echo.
git status --short

echo.
pause
goto MENU


REM ============================================================
REM 5. COMMIT
REM ============================================================

:COMMIT_CHANGES

cls

echo ============================================================
echo   COMMIT CHANGES
echo ============================================================
echo.

echo Current branch:
echo   %CURRENT_BRANCH%
echo.

echo Staged changes:
echo.

git diff --cached --stat

echo.

git diff --cached --quiet

if not errorlevel 1 (
    echo No staged changes found.
    echo.
    echo Use option 4 to add changes first.
    call :LOG "Commit skipped: no staged changes"
    pause
    goto MENU
)

set "COMMIT_MESSAGE="
set /p "COMMIT_MESSAGE=Enter commit message: "

if "%COMMIT_MESSAGE%"=="" (
    echo.
    echo Commit message cannot be empty.
    pause
    goto MENU
)

echo.
echo Creating commit...
echo.

git commit -m "%COMMIT_MESSAGE%"

if errorlevel 1 (
    echo.
    echo ERROR: Commit failed.
    call :LOG "ERROR: Commit failed: %COMMIT_MESSAGE%"
) else (
    echo.
    echo Commit created successfully.
    call :LOG "Created commit: %COMMIT_MESSAGE%"
)

echo.
pause
goto MENU


REM ============================================================
REM 6. PUSH
REM ============================================================

:PUSH_BRANCH

cls

echo ============================================================
echo   PUSH CURRENT BRANCH
echo ============================================================
echo.

echo Current branch:
echo   %CURRENT_BRANCH%
echo.

if "%CURRENT_BRANCH%"=="main" (

    echo WARNING:
    echo You are currently on MAIN.
    echo.
    echo Team members should normally push a feature branch
    echo and create a Pull Request instead.
    echo.

    set "CONFIRM_PUSH="
    set /p "CONFIRM_PUSH=Push to MAIN anyway? (Y/N): "

    if /I not "!CONFIRM_PUSH!"=="Y" (
        echo.
        echo Push cancelled.
        call :LOG "Push to MAIN cancelled"
        pause
        goto MENU
    )
)

echo.
echo Pushing branch to GitHub...
echo.

git push -u origin "%CURRENT_BRANCH%"

if errorlevel 1 (
    echo.
    echo ERROR: Push failed.
    call :LOG "ERROR: Push failed for %CURRENT_BRANCH%"
) else (
    echo.
    echo Push completed successfully.
    call :LOG "Pushed branch: %CURRENT_BRANCH%"
)

echo.
pause
goto MENU


REM ============================================================
REM 7. PULL CURRENT BRANCH
REM ============================================================

:PULL_CURRENT

cls

echo ============================================================
echo   PULL CURRENT BRANCH
echo ============================================================
echo.

echo Current branch:
echo   %CURRENT_BRANCH%
echo.

echo Current local changes:
git status --short

echo.
set "CONFIRM_PULL="
set /p "CONFIRM_PULL=Pull latest changes? (Y/N): "

if /I not "%CONFIRM_PULL%"=="Y" goto MENU

echo.
git pull origin "%CURRENT_BRANCH%"

if errorlevel 1 (
    echo.
    echo ERROR: Pull failed.
    call :LOG "ERROR: Pull failed for %CURRENT_BRANCH%"
) else (
    echo.
    echo Pull completed successfully.
    call :LOG "Pulled branch: %CURRENT_BRANCH%"
)

echo.
pause
goto MENU


REM ============================================================
REM 8. VIEW CHANGES
REM ============================================================

:VIEW_CHANGES

cls

echo ============================================================
echo   VIEW CHANGES
echo ============================================================
echo.

echo ---------------- UNSTAGED CHANGES ----------------
echo.

git diff

echo.
echo ---------------- STAGED CHANGES ----------------
echo.

git diff --cached

echo.
pause
goto MENU


REM ============================================================
REM 9. VIEW BRANCHES
REM ============================================================

:VIEW_BRANCHES

cls

echo ============================================================
echo   BRANCHES
echo ============================================================
echo.

echo ---------------- LOCAL BRANCHES ----------------
echo.

git branch

echo.
echo ---------------- REMOTE BRANCHES ----------------
echo.

git branch -r

echo.
pause
goto MENU


REM ============================================================
REM 10. HISTORY
REM ============================================================

:HISTORY

cls

echo ============================================================
echo   COMMIT HISTORY
echo ============================================================
echo.

git log --oneline --graph --decorate -20

echo.
pause
goto MENU


REM ============================================================
REM 11. FULL WORKFLOW
REM ============================================================

:FULL_WORKFLOW

cls

echo ============================================================
echo   TOKENCARE - FULL NEW TASK WORKFLOW
echo ============================================================
echo.

echo This workflow will:
echo.
echo   1. Check for uncommitted changes
echo   2. Switch to MAIN
echo   3. Pull latest MAIN
echo   4. Create a new branch
echo   5. Let you edit your documents
echo   6. Stage your changes
echo   7. Commit your changes
echo   8. Push your branch
echo.
echo After this, create a Pull Request on GitHub.
echo.
pause


REM ------------------------------------------------------------
REM Check for local changes
REM ------------------------------------------------------------

git status --porcelain

if not errorlevel 1 (
    echo.
    echo ========================================================
    echo ERROR: You have uncommitted changes.
    echo ========================================================
    echo.
    echo Finish your current work before starting a new task.
    echo.

    call :LOG "Full workflow blocked: uncommitted changes"

    pause
    goto MENU
)


REM ------------------------------------------------------------
REM Step 1 - MAIN
REM ------------------------------------------------------------

echo.
echo [1/7] Switching to MAIN...
echo.

git checkout main

if errorlevel 1 (
    echo ERROR: Could not switch to MAIN.
    call :LOG "ERROR: Full workflow failed to checkout MAIN"
    pause
    goto MENU
)

set "CURRENT_BRANCH=main"


REM ------------------------------------------------------------
REM Step 2 - Pull
REM ------------------------------------------------------------

echo.
echo [2/7] Pulling latest MAIN...
echo.

git pull origin main

if errorlevel 1 (
    echo ERROR: Could not pull MAIN.
    call :LOG "ERROR: Full workflow failed to pull MAIN"
    pause
    goto MENU
)


REM ------------------------------------------------------------
REM Step 3 - Branch
REM ------------------------------------------------------------

echo.
echo [3/7] Creating task branch...
echo.

echo Examples:
echo   docs/fhir
echo   docs/abdm
echo   docs/api
echo   docs/architecture
echo.

set "BRANCH_NAME="
set /p "BRANCH_NAME=Enter branch name: "

if "%BRANCH_NAME%"=="" goto MENU

git checkout -b "%BRANCH_NAME%"

if errorlevel 1 (
    echo.
    echo ERROR: Could not create branch.
    call :LOG "ERROR: Full workflow failed to create %BRANCH_NAME%"
    pause
    goto MENU
)

set "CURRENT_BRANCH=%BRANCH_NAME%"

call :LOG "Full workflow created branch: %BRANCH_NAME%"


REM ------------------------------------------------------------
REM Step 4 - Edit
REM ------------------------------------------------------------

echo.
echo [4/7] EDIT YOUR DOCUMENTS
echo.
echo Current directory:
echo   %CURRENT_DIR%
echo.
echo Make your changes using VS Code or another editor.
echo.
echo When finished, return here and press ENTER.
echo.

pause


REM ------------------------------------------------------------
REM Step 5 - Add
REM ------------------------------------------------------------

echo.
echo [5/7] STAGING CHANGES
echo.

git status --short

echo.
set "CONFIRM_ADD="
set /p "CONFIRM_ADD=Stage ALL displayed changes? (Y/N): "

if /I not "%CONFIRM_ADD%"=="Y" (
    echo.
    echo Workflow stopped before staging.
    call :LOG "Full workflow stopped before staging"
    pause
    goto MENU
)

git add .

if errorlevel 1 (
    echo.
    echo ERROR: Failed to stage changes.
    call :LOG "ERROR: Full workflow git add failed"
    pause
    goto MENU
)


REM ------------------------------------------------------------
REM Step 6 - Commit
REM ------------------------------------------------------------

echo.
echo [6/7] CREATING COMMIT
echo.

git diff --cached --quiet

if not errorlevel 1 (
    echo.
    echo No staged changes found.
    echo.
    call :LOG "Full workflow stopped: no staged changes"
    pause
    goto MENU
)

set "COMMIT_MESSAGE="
set /p "COMMIT_MESSAGE=Enter commit message: "

if "%COMMIT_MESSAGE%"=="" goto MENU

git commit -m "%COMMIT_MESSAGE%"

if errorlevel 1 (
    echo.
    echo ERROR: Commit failed.
    call :LOG "ERROR: Full workflow commit failed"
    pause
    goto MENU
)


REM ------------------------------------------------------------
REM Step 7 - Push
REM ------------------------------------------------------------

echo.
echo [7/7] PUSHING BRANCH
echo.

git push -u origin "%CURRENT_BRANCH%"

if errorlevel 1 (
    echo.
    echo ERROR: Push failed.
    call :LOG "ERROR: Full workflow push failed"
    pause
    goto MENU
)

call :LOG "Full workflow completed: %CURRENT_BRANCH%"


REM ------------------------------------------------------------
REM Finished
REM ------------------------------------------------------------

echo.
echo ============================================================
echo   WORKFLOW COMPLETED SUCCESSFULLY
echo ============================================================
echo.
echo Branch:
echo   %CURRENT_BRANCH%
echo.
echo Next step:
echo.
echo   Open GitHub and create a Pull Request:
echo.
echo   %CURRENT_BRANCH%  -^>  main
echo.
echo Repository:
echo   https://github.com/TokenCare/Documents
echo.
echo ============================================================
echo.

pause
goto MENU


REM ============================================================
REM 12. CONFIGURE GIT IDENTITY
REM ============================================================

:CONFIGURE_IDENTITY

cls

echo ============================================================
echo   CONFIGURE GIT IDENTITY
echo ============================================================
echo.

echo Current Git name:
git config --global user.name

echo.
echo Current Git email:
git config --global user.email

echo.
echo Enter a value only if you want to change it.
echo.

set "GIT_NAME="
set /p "GIT_NAME=Git user name: "

if not "%GIT_NAME%"=="" (
    git config --global user.name "%GIT_NAME%"
)

set "GIT_EMAIL="
set /p "GIT_EMAIL=Git email: "

if not "%GIT_EMAIL%"=="" (
    git config --global user.email "%GIT_EMAIL%"
)

call :LOG "Git identity configuration updated"

echo.
echo Current configuration:
echo.

echo Name:
git config --global user.name

echo.
echo Email:
git config --global user.email

echo.
pause
goto MENU


REM ============================================================
REM 13. OPEN GITHUB
REM ============================================================

:OPEN_GITHUB

start "" "https://github.com/TokenCare/Documents"

call :LOG "Opened GitHub repository"

echo.
echo GitHub repository opened.
echo.

pause
goto MENU


REM ============================================================
REM 14. OPEN LOG
REM ============================================================

:OPEN_LOG

if not exist "%LOG_FILE%" (
    echo Git Helper Log > "%LOG_FILE%"
)

start "" notepad "%LOG_FILE%"

goto MENU


REM ============================================================
REM LOG FUNCTION
REM ============================================================

:LOG

set "LOG_MESSAGE=%~1"

>>"%LOG_FILE%" echo [%date% %time%] %LOG_MESSAGE%

exit /b 0


REM ============================================================
REM 15. EXIT
REM ============================================================

:EXIT

call :LOG "Git Helper exited"

cls

echo.
echo ============================================================
echo       TOKENCARE DOCUMENTS - GIT HELPER
echo ============================================================
echo.
echo Goodbye.
echo.

endlocal
exit /b 0
```
