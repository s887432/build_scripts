#!/bin/bash

# -------------------------------------------------------------------------------------------------
# update and patch WILC drivers
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '************************          patching WILC driver             **************************'
echo '*********************************************************************************************'
if [ $patch_wilcdriver -eq 1 ]
then
	if ! [ -d "./wilc_driver" ] 
	then
		git clone https://github.com/linux4wilc/driver.git wilc_driver
	fi
	if ! [ -d "./wilc_firmware" ] 
	then
		git clone https://github.com/linux4wilc/firmware.git wilc_firmware
	fi
fi
