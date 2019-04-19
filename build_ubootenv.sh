#!/bin/bash

# -------------------------------------------------------------------------------------------------
# build and copy u-boot environment setting
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '*******************       building u-boot enviroment variables        ***********************'
echo '*********************************************************************************************'
if [ $build_ubootenv -eq 1 ]
then
	if ! [ -d "./uboot-env" ]
	then
		mkdir -p uboot-env
	fi
	
	cd uboot-env
	if [ -f "./u-boot-env.txt" ]
	then
		rm u-boot-env.txt
	fi
	touch u-boot-env.txt
	## create the boot enviroment source code file
	## but in this solution, the created boot enviroment binary is not used, because the u-boot cannot read from SDHC1
	## so, in the uboot the following values are set as the default values, when the binary is not found 

	echo "arch=arm" >>u-boot-env.txt
	echo "baudrate=115200" >>u-boot-env.txt
	echo "board=sama5d27_som1_ek" >>u-boot-env.txt
	echo "board_name=sama5d27_som1_ek" >>u-boot-env.txt
	echo "bootargs=console=ttyS0,115200 earlyprintk root=/dev/mmcblk1p2 rw rootwait" >>u-boot-env.txt
	echo "bootcmd=fatload mmc 1 0x21000000 ${dtb_resF}; fatload mmc 1:1 0x22000000 ${kernel_resF}; bootz 0x22000000 - 0x21000000" >>u-boot-env.txt
	echo "bootdelay=1" >>u-boot-env.txt
	echo "cpu=armv7" >>u-boot-env.txt
	echo "ethaddr=54:10:ec:33:d1:a7" >>u-boot-env.txt
	echo "fdtcontroladdr=27b56488" >>u-boot-env.txt
	echo "soc=at91" >>u-boot-env.txt
	echo "stderr=serial@f8020000" >>u-boot-env.txt
	echo "stdin=serial@f8020000" >>u-boot-env.txt
	echo "stdout=serial@f80200009" >>u-boot-env.txt
	echo "vendor=atmel" >>u-boot-env.txt

	## create bin-version of u-boot-env.txt
	if [ -f ${u_boot_env_resF} ] 
	then
		rm ./${u_boot_env_resF}
	fi

	mkenvimage -s 0x2000 -o ./${u_boot_env_resF} ./u-boot-env.txt
	cd ..
fi
	
if [ -f "./uboot-env/"${u_boot_env_resF} ] 
	then
	cp ./uboot-env/${u_boot_env_resF} ./${result_p}
else
	printf "\E[0;41m"
	echo './uboot-env/'${u_boot_env_resF} ' is not existed. please enable build_ubootenv'
	printf "\E[0m"
	printf "\E[0m"
fi
# -------------------------------------------------------------------------------------------------
