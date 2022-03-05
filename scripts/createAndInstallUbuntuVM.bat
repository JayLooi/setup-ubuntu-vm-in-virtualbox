@rem **************************************************************************
@rem * @file createAndInstallUbuntuVM.bat
@rem * @author Looi Kian Seong
@rem * @brief Automate process of creating VM and installing Ubuntu OS on the VM
@rem * @date 2022-03-05
@rem **************************************************************************

@echo off

goto :Start

:Pre_Start:
	exit /b 0
	
:Start
rem reset errorlevel to 0
call :Pre_Start

set CREATE_UBUNTU_VM=%~dp0\createUbuntuVM.bat
set INSTALL_UBUNTU_OS=%~dp0\installUbuntuOnVM.bat

call %CREATE_UBUNTU_VM% || goto :Pre_Exit

if not "%1"=="" (
	call %INSTALL_UBUNTU_OS% %VBOX_ABSOLUTE_PATH% %STORAGE_CONTROLLER_0% --isofilepath %1 || goto :Pre_Exit
) else (
	call %INSTALL_UBUNTU_OS% %VBOX_ABSOLUTE_PATH% %STORAGE_CONTROLLER_0% || goto :Pre_Exit
)

echo Ubuntu VM successfully setup. 

:Pre_Exit
pause
exit /b %errorlevel%
