@echo off


rem Machine configurations
set VM_NAME=Ubuntu-Test
set OS_TYPE="Ubuntu (64-bit)"
set BASE_FOLDER="D:\VM\Machines"
set NUM_OF_CPU=1
set MEMORY_SIZE=4096
set VRAM_SIZE=16
set PARAVIRT=kvm
set GRAPHICS_CONT=vmsvga
set X2APIC=on
set RTC_USE_UTC=on
set USB_OHCI=on
set NIC1=bridged
set BRIDGE_ADAPTER1="Intel(R) Wi-Fi 6 AX201 160MHz"
set BOOT_DEV_1=dvd
set BOOT_DEV_2=disk
set BOOT_DEV_3=none
set BOOT_DEV_4=none
set VBOX_ABS_PATH="%BASE_FOLDER%\%VM_NAME%\%VM_NAME%.vbox"


rem Storage Controller configurations
set CONTROLLER_0_NAME=IDE
set CONTROLLER_0_SYSTEM_BUS=ide
set CONTROLLER_0_BOOTABLE=on
set CONTROLLER_0_PORT_COUNT=2
set CONTROLLER_1_NAME=SATA
set CONTROLLER_1_SYSTEM_BUS=sata
set CONTROLLER_1_BOOTABLE=on
set CONTROLLER_1_PORT_COUNT=1


rem Hard disk configurations
set HARD_DISK_NAME=%VM_NAME%
set HARD_DISK_PATH="%BASE_FOLDER%\%VM_NAME%\%HARD_DISK_NAME%.vdi"
set HARD_DISK_SIZE=10240
set HARD_DISK_VARIANT=Standard
