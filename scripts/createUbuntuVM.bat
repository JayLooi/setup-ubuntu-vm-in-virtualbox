@rem **************************************************************************
@rem * @file createUbuntuVM.bat
@rem * @author Looi Kian Seong
@rem * @brief Create an Ubuntu VM on Oracle VirtualBox
@rem * @date 2022-03-05
@rem **************************************************************************

@echo off

setlocal

goto :Start

:On_Error
	echo ERROR
	goto :Pre_Exit

:Start
echo ===============================================================
echo              Start creating Ubuntu Virtual Machine             
echo ===============================================================
echo.

if not defined VBoxManage (
	echo ^>^>^> Setting environment variable ^<^<^<
	call %~dp0\setenv.bat || goto :On_Error
	echo DONE
	echo.
)

echo ^>^>^> Reading configurations ^<^<^<
call %~dp0\config.bat || goto :On_Error
echo DONE
echo.

echo ^>^>^> Creating Ubuntu VM ^<^<^<
%VBoxManage% createvm ^
	--name %VM_NAME% ^
	--ostype %OS_TYPE% ^
	--basefolder %BASE_FOLDER% ^
	--register || goto :On_Error
echo DONE
echo.

echo ^>^>^> Setting VM configurations ^<^<^<
%VBoxManage% modifyvm %VBOX_ABS_PATH% ^
	--cpus %NUM_OF_CPU% ^
	--memory %MEMORY_SIZE% ^
	--vram %VRAM_SIZE% ^
	--paravirtprovider %PARAVIRT% ^
	--graphicscontroller %GRAPHICS_CONT% ^
	--x2apic %X2APIC% ^
	--rtcuseutc %RTC_USE_UTC% ^
	--usbohci %USB_OHCI% ^
	--nic1 %NIC1% ^
	--bridgeadapter1 %BRIDGE_ADAPTER1% ^
	--boot1 %BOOT_DEV_1% ^
	--boot2 %BOOT_DEV_2% ^
	--boot3 %BOOT_DEV_3% ^
	--boot4 %BOOT_DEV_4% || goto :On_Error
echo DONE
echo.

echo ^>^>^> Creating virtual hard disk ^<^<^<
%VBoxManage% createmedium ^
	--filename %HARD_DISK_PATH% ^
	--size %HARD_DISK_SIZE% ^
	--variant %HARD_DISK_VARIANT% || goto :On_Error
echo DONE
echo.

echo ^>^>^> Creating storage controller 0 ^<^<^<
%VBoxManage% storagectl %VBOX_ABS_PATH% ^
	--name %CONTROLLER_0_NAME% ^
	--add %CONTROLLER_0_SYSTEM_BUS% ^
	--bootable %CONTROLLER_0_BOOTABLE% ^
	--portcount %CONTROLLER_0_PORT_COUNT% || goto :On_Error
echo DONE
echo.

echo ^>^>^> Creating storage controller 1 ^<^<^<
%VBoxManage% storagectl %VBOX_ABS_PATH% ^
	--name %CONTROLLER_1_NAME% ^
	--add %CONTROLLER_1_SYSTEM_BUS% ^
	--bootable %CONTROLLER_1_BOOTABLE% ^
	--portcount %CONTROLLER_1_PORT_COUNT% || goto :On_Error
echo DONE
echo.

echo ^>^>^> Attaching virtual hard disk to controller ^<^<^<
%VBoxManage% storageattach %VBOX_ABS_PATH% ^
	--storagectl %CONTROLLER_1_NAME% ^
	--type hdd ^
	--port 0 ^
	--device 0 ^
	--medium %HARD_DISK_PATH% || goto :On_Error
echo DONE
echo.

:Pre_Exit
if %errorlevel%==0 (
	endlocal ^
		&& set VBOX_ABSOLUTE_PATH=%VBOX_ABS_PATH% ^
		&& set STORAGE_CONTROLLER_0=%CONTROLLER_0_NAME% ^
		&& set STORAGE_CONTROLLER_1=%CONTROLLER_1_NAME%
)

exit /b %errorlevel%
