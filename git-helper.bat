@echo off
setlocal EnableExtensions EnableDelayedExpansion

title TokenCare Documents - Git Helper

REM ============================================================
REM TOKENCARE DOCUMENTS - GIT HELPER
REM ============================================================
REM
REM Remote Repository:
REM   https://github.com/TokenCare/Documents
REM
REM Local Repository:
REM   The Git repository on the collaborator's computer.
REM
REM Remote:
REM   origin
REM
REM Local Git Helper Activity Log:
REM   .git-helper\git-helper.log
REM
REM IMPORTANT:
REM   This script operates on the CURRENT DIRECTORY.
REM   It does NOT automatically change to the BAT file location.
REM
REM ============================================================


REM ============================================================
REM CONFIGURATION
REM ============================================================

set "REMOTE_URL=https://github.com/TokenCare/Documents.git"
set "REMOTE_WEB_URL=https://github.com/TokenCare/Documents"
set "REMOTE_NAME=origin"

set "LOCAL_DIR=%CD%"
set "LOG_DIR=%CD%\.git-helper"
set "LOG_FILE=%LOG_DIR%\git-helper.log"


REM ============================================================
REM CREATE LOCAL GIT HELPER LOG DIRECTORY
REM ============================================================

if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%" >nul 2>&1
)


REM ============================================================
REM START LOG
REM ============================================================

call :LOG "============================================================"
call :LOG "TokenCare Documents Git Helper started"
call :LOG "Current directory: %LOCAL_DIR%"


REM ============================================================
REM CHECK WHETHER GIT IS INSTALLED
REM ============================================================

where git >nul 2>&1

if errorlevel 1 (
    cls

    echo.
    echo ============================================================
    echo   ERROR - GIT IS NOT INSTALLED
    echo ============================================================
    echo.
    echo Git is required to use this helper.
    echo.
    echo Install Git for Windows from:
    echo.
    echo   https://git-scm.com/download/win
    echo.
    call :LOG "ERROR: Git is not installed"

    pause
    exit /b 1
)


REM ============================================================
REM CHECK WHETHER CURRENT DIRECTORY IS A LOCAL REPOSITORY
REM ============================================================

git rev-parse --is-inside-work-tree >nul 2>&1

if errorlevel 1 goto FIRST_TIME_SETUP


REM ============================================================
REM LOAD LOCAL REPOSITORY INFORMATION
REM ============================================================

for /f "delims=" %%R in ('git rev-parse --show-toplevel 2^>nul') do (
    set "LOCAL_REPO_ROOT=%%R"
)

for /f "delims=" %%B in ('git branch --show-current 2^>nul') do (
    set "CURRENT_BRANCH=%%B"
)

for /f "delims=" %%U in ('git remote get-url %REMOTE_NAME% 2^>nul') do (
    set "REMOTE_REPO_URL=%%U"
)

call :LOG "Local repository: %LOCAL_REPO_ROOT%"
call :LOG "Current branch: %CURRENT_BRANCH%"
call :LOG "Remote repository: %REMOTE_REPO_URL%"

goto MAIN_MENU


REM ============================================================
REM FIRST-TIME SETUP
REM ============================================================

:FIRST_TIME_SETUP

cls

echo.
echo ============================================================
echo          TOKENCARE DOCUMENTS - FIRST-TIME SETUP
echo ============================================================
echo.
echo LOCAL DIRECTORY
echo   %LOCAL_DIR%
echo.
echo This directory is NOT currently a Git repository.
echo.
echo REMOTE REPOSITORY
echo   https://github.com/TokenCare/Documents
echo.
echo ============================================================
echo.
echo   1. Clone Remote Repository Here
echo   2. Exit
echo.
echo ============================================================
echo.

set "SETUP_CHOICE="
set /p "SETUP_CHOICE=Select an option: "

if "%SETUP_CHOICE%"=="1" goto CLONE_REPOSITORY
if "%SETUP_CHOICE%"=="2" goto EXIT

echo.
echo Invalid option.
pause
goto FIRST_TIME_SETUP


REM ============================================================
REM CLONE REMOTE REPOSITORY
REM ============================================================

:CLONE_REPOSITORY

cls

echo.
echo ============================================================
echo          CLONE REMOTE REPOSITORY
echo ============================================================
echo.
echo REMOTE REPOSITORY:
echo   %REMOTE_WEB_URL%
echo.
echo LOCAL DIRECTORY:
echo   %LOCAL_DIR%
echo.
echo The repository will normally be created as:
echo.
echo   %LOCAL_DIR%\Documents
echo.

if exist "%LOCAL_DIR%\Documents" (
    echo WARNING:
    echo A Documents folder already exists here.
    echo.
    echo Cloning may fail if it is not empty.
    echo.
)

set "CLONE_FOLDER="
set /p "CLONE_FOLDER=Enter local folder name [Documents]: "

if "%CLONE_FOLDER%"=="" (
    set "CLONE_FOLDER=Documents"
)

echo.
echo Cloning:
echo.
echo   Remote:
echo     %REMOTE_WEB_URL%
echo.
echo   Local:
echo     %LOCAL_DIR%\%CLONE_FOLDER%
echo.

git clone "%REMOTE_URL%" "%CLONE_FOLDER%"

if errorlevel 1 (
    echo.
    echo ============================================================
    echo   ERROR - CLONING FAILED
    echo ============================================================
    echo.
    echo Possible reasons:
    echo.
    echo   - You have not accepted the GitHub invitation.
    echo   - You are not authenticated with GitHub.
    echo   - Repository path is incorrect.
    echo   - Destination folder already contains files.
    echo.
    call :LOG "ERROR: Clone failed"

    pause
    goto FIRST_TIME_SETUP
)

echo.
echo ============================================================
echo   CLONE COMPLETED SUCCESSFULLY
echo ============================================================
echo.
echo Local repository created:
echo.
echo   %LOCAL_DIR%\%CLONE_FOLDER%
echo.
echo Next step:
echo.
echo   cd %CLONE_FOLDER%
echo   git-helper.bat
echo.
echo Then use:
echo.
echo   11. Full New-Task Workflow
echo.
call :LOG "Remote repository cloned successfully"

pause
goto EXIT


REM ============================================================
REM MAIN MENU
REM ============================================================

:MAIN_MENU

cls

echo.
echo ============================================================
echo           TOKENCARE DOCUMENTS - GIT HELPER
echo ============================================================
echo.

echo ---------------- LOCAL REPOSITORY ----------------
echo.
echo Directory:
echo   %LOCAL_REPO_ROOT%
echo.
echo Current Branch:
echo   %CURRENT_BRANCH%
echo.

echo ---------------- REMOTE REPOSITORY ----------------
echo.
echo Provider:
echo   GitHub
echo.
echo Repository:
echo   TokenCare/Documents
echo.
echo Remote:
echo   %REMOTE_NAME%
echo.
echo URL:
echo   %REMOTE_WEB_URL%
echo.

echo ============================================================
echo.
echo   LOCAL REPOSITORY OPERATIONS
echo.
echo   1.  Show Local Repository Status
echo   2.  View Local Changes
echo   3.  Create Local Feature Branch
echo   4.  Stage Local Changes
echo   5.  Commit Local Changes
echo   6.  View Local Commit History
echo   7.  View Local Branches
echo.
echo   REMOTE REPOSITORY OPERATIONS
echo.
echo   8.  Sync Local MAIN with Remote MAIN
echo   9.  Pull Remote Changes to Local
echo   10. Push Local Branch to Remote
echo   11. View Local and Remote Branches
echo   12. Open Remote GitHub Repository
echo.
echo   WORKFLOW
echo.
echo   13. Full New-Task Workflow
echo.
echo   SETUP / TOOLS
echo.
echo   14. Configure Git Identity
echo   15. Open Git Helper Activity Log
echo   16. Exit
echo.
echo ============================================================
echo.

set "CHOICE="
set /p "CHOICE=Select an option: "

if "%CHOICE%"=="1" goto STATUS
if "%CHOICE%"=="2" goto VIEW_CHANGES
if "%CHOICE%"=="3" goto CREATE_BRANCH
if "%CHOICE%"=="4" goto STAGE_CHANGES
if "%CHOICE%"=="5" goto COMMIT_CHANGES
if "%CHOICE%"=="6" goto COMMIT_HISTORY
if "%CHOICE%"=="7" goto LOCAL_BRANCHES
if "%CHOICE%"=="8" goto SYNC_MAIN
if "%CHOICE%"=="9" goto PULL_REMOTE
if "%CHOICE%"=="10" goto PUSH_REMOTE
if "%CHOICE%"=="11" goto ALL_BRANCHES
if "%CHOICE%"=="12" goto OPEN_GITHUB
if "%CHOICE%"=="13" goto FULL_WORKFLOW
if "%CHOICE%"=="14" goto CONFIGURE_IDENTITY
if "%CHOICE%"=="15" goto OPEN_LOG
if "%CHOICE%"=="16" goto EXIT

echo.
echo Invalid option.
pause
goto MAIN_MENU


REM ============================================================
REM 1 - LOCAL REPOSITORY STATUS
REM ============================================================

:STATUS

cls

echo.
echo ============================================================
echo       LOCAL REPOSITORY STATUS
echo ============================================================
echo.

git status

call :LOG "Viewed local repository status"

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 2 - VIEW LOCAL CHANGES
REM ============================================================

:VIEW_CHANGES

cls

echo.
echo ============================================================
echo             LOCAL CHANGES
echo ============================================================
echo.

echo ---------------- UNSTAGED CHANGES ----------------
echo.

git diff

echo.
echo ---------------- STAGED CHANGES ----------------
echo.

git diff --cached

call :LOG "Viewed local changes"

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 3 - CREATE LOCAL FEATURE BRANCH
REM ============================================================

:CREATE_BRANCH

cls

echo.
echo ============================================================
echo          CREATE LOCAL FEATURE BRANCH
echo ============================================================
echo.

echo Current branch:
echo   %CURRENT_BRANCH%
echo.

echo Recommended names:
echo.
echo   docs/fhir
echo   docs/abdm
echo   docs/api
echo   docs/architecture
echo   docs/healthcare-workflow
echo   fix/fhir-document
echo   update/readme
echo.

set "BRANCH_NAME="
set /p "BRANCH_NAME=Enter new branch name: "

if "%BRANCH_NAME%"=="" goto MAIN_MENU

git checkout -b "%BRANCH_NAME%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to create local branch.
    call :LOG "ERROR: Failed to create branch %BRANCH_NAME%"
) else (
    set "CURRENT_BRANCH=%BRANCH_NAME%"

    echo.
    echo Local branch created:
    echo   %CURRENT_BRANCH%

    call :LOG "Created local branch: %BRANCH_NAME%"
)

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 4 - STAGE LOCAL CHANGES
REM ============================================================

:STAGE_CHANGES

cls

echo.
echo ============================================================
echo            STAGE LOCAL CHANGES
echo ============================================================
echo.

git status --short

echo.
echo ============================================================
echo   1. Stage ALL changes
echo   2. Stage a specific file
echo   3. Cancel
echo ============================================================
echo.

set "STAGE_CHOICE="
set /p "STAGE_CHOICE=Select: "

if "%STAGE_CHOICE%"=="1" goto STAGE_ALL
if "%STAGE_CHOICE%"=="2" goto STAGE_FILE
if "%STAGE_CHOICE%"=="3" goto MAIN_MENU

goto STAGE_CHANGES


:STAGE_ALL

echo.
echo Staging all local changes...
echo.

git add .

if errorlevel 1 (
    echo ERROR: Failed to stage changes.
    call :LOG "ERROR: Failed to stage all changes"
) else (
    echo.
    echo All changes staged.
    call :LOG "Staged all local changes"
)

echo.
git status --short

pause
goto MAIN_MENU


:STAGE_FILE

echo.
set "FILE_NAME="
set /p "FILE_NAME=Enter file path: "

if "%FILE_NAME%"=="" goto STAGE_CHANGES

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
pause
goto MAIN_MENU


REM ============================================================
REM 5 - COMMIT LOCAL CHANGES
REM ============================================================

:COMMIT_CHANGES

cls

echo.
echo ============================================================
echo          COMMIT LOCAL CHANGES
echo ============================================================
echo.

echo Local branch:
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
    echo Stage changes first using option 4.
    call :LOG "Commit skipped: no staged changes"
    pause
    goto MAIN_MENU
)

set "COMMIT_MESSAGE="
set /p "COMMIT_MESSAGE=Enter commit message: "

if "%COMMIT_MESSAGE%"=="" goto MAIN_MENU

echo.
git commit -m "%COMMIT_MESSAGE%"

if errorlevel 1 (
    echo.
    echo ERROR: Commit failed.
    call :LOG "ERROR: Commit failed"
) else (
    echo.
    echo Local commit created successfully.
    call :LOG "Created local commit: %COMMIT_MESSAGE%"
)

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 6 - LOCAL COMMIT HISTORY
REM ============================================================

:COMMIT_HISTORY

cls

echo.
echo ============================================================
echo           LOCAL COMMIT HISTORY
echo ============================================================
echo.

git log --oneline --graph --decorate -20

call :LOG "Viewed local commit history"

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 7 - LOCAL BRANCHES
REM ============================================================

:LOCAL_BRANCHES

cls

echo.
echo ============================================================
echo              LOCAL BRANCHES
echo ============================================================
echo.

git branch

call :LOG "Viewed local branches"

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 8 - SYNC LOCAL MAIN WITH REMOTE MAIN
REM ============================================================

:SYNC_MAIN

cls

echo.
echo ============================================================
echo       SYNC LOCAL MAIN WITH REMOTE MAIN
echo ============================================================
echo.

echo This operation will:
echo.
echo   Remote MAIN
echo       ↓
echo   Local MAIN
echo.
echo.

if not "%CURRENT_BRANCH%"=="main" (

    echo Current local branch:
    echo   %CURRENT_BRANCH%
    echo.

    git status --porcelain

    if not errorlevel 1 (
        echo ERROR:
        echo Local changes exist.
        echo.
        echo Commit or safely store them before switching to MAIN.
        call :LOG "Sync MAIN blocked by local changes"
        pause
        goto MAIN_MENU
    )

    git checkout main

    if errorlevel 1 (
        echo ERROR: Could not switch to local MAIN.
        call :LOG "ERROR: Failed to checkout local MAIN"
        pause
        goto MAIN_MENU
    )

    set "CURRENT_BRANCH=main"
)

echo Pulling Remote MAIN...
echo.

git pull %REMOTE_NAME% main

if errorlevel 1 (
    echo.
    echo ERROR: Failed to synchronize Local MAIN.
    call :LOG "ERROR: Failed to sync Local MAIN with Remote MAIN"
) else (
    echo.
    echo Local MAIN is synchronized with Remote MAIN.
    call :LOG "Synchronized Local MAIN with Remote MAIN"
)

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 9 - PULL REMOTE CHANGES TO LOCAL
REM ============================================================

:PULL_REMOTE

cls

echo.
echo ============================================================
echo       PULL REMOTE CHANGES TO LOCAL
echo ============================================================
echo.

echo Direction:
echo.
echo   REMOTE
echo      ↓
echo   LOCAL
echo.

echo Current local branch:
echo   %CURRENT_BRANCH%
echo.

git status --short

echo.
set "CONFIRM_PULL="
set /p "CONFIRM_PULL=Pull Remote changes to Local? (Y/N): "

if /I not "%CONFIRM_PULL%"=="Y" goto MAIN_MENU

echo.
git pull %REMOTE_NAME% "%CURRENT_BRANCH%"

if errorlevel 1 (
    echo.
    echo ERROR: Pull failed.
    call :LOG "ERROR: Pull failed"
) else (
    echo.
    echo Remote changes pulled successfully.
    call :LOG "Pulled Remote changes to Local"
)

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 10 - PUSH LOCAL BRANCH TO REMOTE
REM ============================================================

:PUSH_REMOTE

cls

echo.
echo ============================================================
echo       PUSH LOCAL BRANCH TO REMOTE
echo ============================================================
echo.

echo Direction:
echo.
echo   LOCAL
echo      ↓
echo   REMOTE
echo.

echo Local branch:
echo   %CURRENT_BRANCH%
echo.

if "%CURRENT_BRANCH%"=="main" (

    echo WARNING:
    echo You are trying to push directly to MAIN.
    echo.
    echo Recommended team workflow:
    echo.
    echo   Local Feature Branch
    echo          ↓
    echo   Remote Feature Branch
    echo          ↓
    echo   Pull Request
    echo          ↓
    echo   Remote MAIN
    echo.

    set "CONFIRM_MAIN_PUSH="
    set /p "CONFIRM_MAIN_PUSH=Push Local MAIN directly to Remote MAIN? (Y/N): "

    if /I not "!CONFIRM_MAIN_PUSH!"=="Y" (
        call :LOG "Direct push to Remote MAIN cancelled"
        goto MAIN_MENU
    )
)

echo.
git push -u %REMOTE_NAME% "%CURRENT_BRANCH%"

if errorlevel 1 (
    echo.
    echo ERROR: Push failed.
    call :LOG "ERROR: Failed to push local branch"
) else (
    echo.
    echo Local branch pushed to Remote successfully.
    call :LOG "Pushed local branch %CURRENT_BRANCH% to Remote"
)

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 11 - LOCAL AND REMOTE BRANCHES
REM ============================================================

:ALL_BRANCHES

cls

echo.
echo ============================================================
echo         LOCAL AND REMOTE BRANCHES
echo ============================================================
echo.

echo ---------------- LOCAL BRANCHES ----------------
echo.

git branch

echo.
echo ---------------- REMOTE BRANCHES ----------------
echo.

git branch -r

call :LOG "Viewed Local and Remote branches"

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 12 - OPEN REMOTE GITHUB REPOSITORY
REM ============================================================

:OPEN_GITHUB

start "" "%REMOTE_WEB_URL%"

call :LOG "Opened Remote GitHub repository"

echo.
echo Remote GitHub repository opened in browser.
echo.

pause
goto MAIN_MENU


REM ============================================================
REM 13 - FULL NEW-TASK WORKFLOW
REM ============================================================

:FULL_WORKFLOW

cls

echo.
echo ============================================================
echo          FULL NEW-TASK WORKFLOW
echo ============================================================
echo.

echo This workflow follows the recommended team process:
echo.
echo   Remote MAIN
echo       ↓
echo   Local MAIN
echo       ↓
echo   Local Feature Branch
echo       ↓
echo   Edit Documents
echo       ↓
echo   Local Commit
echo       ↓
echo   Remote Feature Branch
echo       ↓
echo   Pull Request
echo       ↓
echo   Remote MAIN
echo.
echo ============================================================
echo.

pause


REM ------------------------------------------------------------
REM Check local changes
REM ------------------------------------------------------------

git status --porcelain

if not errorlevel 1 (

    echo.
    echo ERROR:
    echo You already have local uncommitted changes.
    echo.
    echo Finish the current work before starting a new task.

    call :LOG "Full workflow blocked by existing local changes"

    pause
    goto MAIN_MENU
)


REM ------------------------------------------------------------
REM Step 1 - Local MAIN
REM ------------------------------------------------------------

echo.
echo [1/7] Switching Local Repository to MAIN...
echo.

git checkout main

if errorlevel 1 (
    echo ERROR: Could not switch to Local MAIN.
    call :LOG "ERROR: Full workflow could not checkout MAIN"
    pause
    goto MAIN_MENU
)

set "CURRENT_BRANCH=main"


REM ------------------------------------------------------------
REM Step 2 - Remote MAIN → Local MAIN
REM ------------------------------------------------------------

echo.
echo [2/7] Synchronizing Remote MAIN → Local MAIN...
echo.

git pull %REMOTE_NAME% main

if errorlevel 1 (
    echo.
    echo ERROR: Could not synchronize MAIN.
    call :LOG "ERROR: Full workflow could not sync MAIN"
    pause
    goto MAIN_MENU
)


REM ------------------------------------------------------------
REM Step 3 - Create Local Feature Branch
REM ------------------------------------------------------------

echo.
echo [3/7] Creating Local Feature Branch...
echo.

echo Examples:
echo.
echo   docs/fhir
echo   docs/abdm
echo   docs/api
echo   docs/architecture
echo.

set "BRANCH_NAME="
set /p "BRANCH_NAME=Enter feature branch name: "

if "%BRANCH_NAME%"=="" goto MAIN_MENU

git checkout -b "%BRANCH_NAME%"

if errorlevel 1 (
    echo.
    echo ERROR: Could not create feature branch.
    call :LOG "ERROR: Could not create feature branch"
    pause
    goto MAIN_MENU
)

set "CURRENT_BRANCH=%BRANCH_NAME%"

call :LOG "Created feature branch: %BRANCH_NAME%"


REM ------------------------------------------------------------
REM Step 4 - Edit documents
REM ------------------------------------------------------------

echo.
echo [4/7] EDIT YOUR DOCUMENTS
echo.
echo Local Repository:
echo   %LOCAL_REPO_ROOT%
echo.
echo Make your changes using VS Code or another editor.
echo.
echo When finished, return here and press ENTER.
echo.

pause


REM ------------------------------------------------------------
REM Step 5 - Stage Local Changes
REM ------------------------------------------------------------

echo.
echo [5/7] STAGING LOCAL CHANGES
echo.

git status --short

echo.

set "CONFIRM_STAGE="
set /p "CONFIRM_STAGE=Stage ALL changes? (Y/N): "

if /I not "%CONFIRM_STAGE%"=="Y" (
    call :LOG "Full workflow stopped before staging"
    goto MAIN_MENU
)

git add .

if errorlevel 1 (
    echo.
    echo ERROR: Failed to stage changes.
    call :LOG "ERROR: Full workflow staging failed"
    pause
    goto MAIN_MENU
)


REM ------------------------------------------------------------
REM Step 6 - Local Commit
REM ------------------------------------------------------------

echo.
echo [6/7] CREATING LOCAL COMMIT
echo.

git diff --cached --quiet

if not errorlevel 1 (
    echo.
    echo No staged changes found.
    call :LOG "Full workflow stopped: no staged changes"
    pause
    goto MAIN_MENU
)

set "COMMIT_MESSAGE="
set /p "COMMIT_MESSAGE=Enter commit message: "

if "%COMMIT_MESSAGE%"=="" goto MAIN_MENU

git commit -m "%COMMIT_MESSAGE%"

if errorlevel 1 (
    echo.
    echo ERROR: Commit failed.
    call :LOG "ERROR: Full workflow commit failed"
    pause
    goto MAIN_MENU
)


REM ------------------------------------------------------------
REM Step 7 - Local Feature Branch → Remote
REM ------------------------------------------------------------

echo.
echo [7/7] PUSHING LOCAL FEATURE BRANCH → REMOTE
echo.

git push -u %REMOTE_NAME% "%CURRENT_BRANCH%"

if errorlevel 1 (
    echo.
    echo ERROR: Push failed.
    call :LOG "ERROR: Full workflow push failed"
    pause
    goto MAIN_MENU
)

call :LOG "Full workflow completed successfully"


REM ------------------------------------------------------------
REM Completed
REM ------------------------------------------------------------

echo.
echo ============================================================
echo              WORKFLOW COMPLETED
echo ============================================================
echo.
echo Local Branch:
echo   %CURRENT_BRANCH%
echo.
echo Remote Branch:
echo   %REMOTE_NAME%/%CURRENT_BRANCH%
echo.
echo ============================================================
echo.
echo NEXT STEP:
echo.
echo Open GitHub and create a Pull Request:
echo.
echo   %CURRENT_BRANCH%  --->  main
echo.
echo Remote Repository:
echo   %REMOTE_WEB_URL%
echo.
echo ============================================================
echo.

pause
goto MAIN_MENU


REM ============================================================
REM 14 - CONFIGURE GIT IDENTITY
REM ============================================================

:CONFIGURE_IDENTITY

cls

echo.
echo ============================================================
echo            GIT IDENTITY CONFIGURATION
echo ============================================================
echo.

echo Current Git user name:
echo.
git config --global user.name

echo.
echo Current Git email:
echo.
git config --global user.email

echo.
echo Leave blank to keep the existing value.
echo.

set "GIT_NAME="
set /p "GIT_NAME=Enter Git user name: "

if not "%GIT_NAME%"=="" (
    git config --global user.name "%GIT_NAME%"
)

set "GIT_EMAIL="
set /p "GIT_EMAIL=Enter Git email: "

if not "%GIT_EMAIL%"=="" (
    git config --global user.email "%GIT_EMAIL%"
)

call :LOG "Git identity configuration updated"

echo.
echo Updated configuration:
echo.

echo Name:
git config --global user.name

echo.
echo Email:
git config --global user.email

echo.
pause
goto MAIN_MENU


REM ============================================================
REM 15 - OPEN GIT HELPER ACTIVITY LOG
REM ============================================================

:OPEN_LOG

if not exist "%LOG_FILE%" (
    echo TokenCare Documents - Git Helper Activity Log > "%LOG_FILE%"
)

start "" notepad "%LOG_FILE%"

goto MAIN_MENU


REM ============================================================
REM LOG FUNCTION
REM ============================================================

:LOG

set "LOG_MESSAGE=%~1"

>>"%LOG_FILE%" echo [%date% %time%] %LOG_MESSAGE%

exit /b 0


REM ============================================================
REM 16 - EXIT
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