@rem **************************************************************************
@rem * @file installUbuntuOnVM.bat
@rem * @author Looi Kian Seong
@rem * @brief Install Ubuntu on Oracle VirtualBox VM
@rem * @date 2022-03-05
@rem **************************************************************************

@echo off

setlocal EnableDelayedExpansion

rem Ubuntu iso image download url
set UBUNTU_IMG_ISO_URL=https://releases.ubuntu.com/20.04.4/ubuntu-20.04.4-desktop-amd64.iso

set /A N_OF_POSITIONAL_ARGS=2
set ARGS[1]=VBOX_ABS_PATH
set ARGS[2]=STORAGE_CONTROLLER_NAME

set OPT_ARG_NAME=--isofilepath
set OPT_ARG=UBUNTU_IMG_ISO_PATH
set /A INDEX=1
:parse_args
if "%1"=="" (
	echo Missing positional argument^(s^):
	for /L %%i in (!INDEX!, 1, %N_OF_POSITIONAL_ARGS%) do echo - !ARGS[%%i]!
	exit /b 1
)

call set %%ARGS[!INDEX!]%%=%1
set /A INDEX+=1
shift
if !INDEX! lss 3 (
	goto :parse_args
)

if "%1"=="!OPT_ARG_NAME!" (
	shift
	if not "%%1"=="" (
		call set %%OPT_ARG%%=%%1
	)
)

goto :Start

:On_Error
	set ERROR_CODE=%errorlevel%
	echo ERROR
	goto :Pre_Exit

:Start
echo ===============================================================
echo             Installing Ubuntu OS on Virtual Machine            
echo ===============================================================
echo.

set ERROR_CODE=0

if not defined VBoxManage (
	echo ^>^>^> Setting environment variable ^<^<^<
	call %~dp0\setenv.bat || goto :On_Error
	echo DONE
	echo.
)

if not defined UBUNTU_IMG_ISO_PATH (
	echo No Ubuntu image iso filepath given. Downloading from %UBUNTU_IMG_ISO_URL%...
	curl --create-dirs --output %temp%\VM\Ubuntu.iso %UBUNTU_IMG_ISO_URL% || goto :On_Error
	set UBUNTU_IMG_ISO_PATH=%temp%\VM\Ubuntu.iso
	set DOWNLOADED_TEMP= 
	echo DONE
	echo.
)

echo ^>^>^> Attaching Ubuntu image iso file ^<^<^<
%VBoxManage% storageattach %VBOX_ABS_PATH% ^
	--storagectl %STORAGE_CONTROLLER_NAME% ^
	--type dvddrive ^
	--port 0 ^
	--device 0 ^
	--medium %UBUNTU_IMG_ISO_PATH% || goto :On_Error
echo DONE
echo.

echo ^>^>^> Booting VM ^<^<^<
%VBoxManage% startvm %VBOX_ABS_PATH% || goto :On_Error
echo DONE
echo.

echo WARNING -- Pressing any key here will shutdown the VM. --
echo Please COMPLETE the OS installation steps in VirtualBox GUI before pressing any key here. 
pause

call :check_is_running

if %IS_RUNNING%==1 (
	echo ^>^>^> Shutting down VM ^<^<^<
	%VBoxManage% controlvm %VBOX_ABS_PATH% acpipowerbutton || goto :On_Error
	echo DONE
	echo.
)

:wait_vm_stop
timeout /T 5 /NOBREAK
call :check_is_running
if %IS_RUNNING%==1 (
	goto :wait_vm_stop
)

echo ^>^>^> Detaching Ubuntu image iso file ^<^<^<
%VBoxManage% storageattach %VBOX_ABS_PATH% ^
	--storagectl %STORAGE_CONTROLLER_NAME% ^
	--type dvddrive ^
	--port 0 ^
	--device 0 ^
	--medium none || goto :On_Error
echo DONE
echo.

:Pre_Exit
if defined DOWNLOADED_TEMP del %temp%\VM\Ubuntu.iso

exit /b %ERROR_CODE%

:check_is_running
set /A IS_RUNNING=0
FOR /F "tokens=*" %%a in ('%VBoxManage% list runningvms -l ^| findstr %VM_NAME%.vbox') do set /A IS_RUNNING=1
exit /b 0
