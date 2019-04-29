#!/bin/bash

# -------------------------------------------------------------------------------------------------
# build and copy u-boot
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '************************            building kernel                **************************'
echo '*********************************************************************************************'

if [ $build_kernel -eq 1 ]
then
	if ! [ -d "./linux-at91" ]
	then
		echo 'downloading kernel source code from github ...'
		git clone git://github.com/linux4sam/linux-at91.git
		cd linux-at91		
		make sama5_defconfig
		cd ..
		# copy patches
		if [ patch_wilcdriver -eq 1 ]
		then
			rm -rf linux-at91/drivers/staging/wilc1000/*
			cp wilc_driver/wilc/* linux-1t91/drivers/staging/wilc1000
		fi
	fi

	cd linux-at91
	echo 'making kernel image ...'
	make -j8
	cd ..

#	echo 'downloading device tree overlay files from github ...'
#	git clone git://github.com/linux4sam/dt-overlay-at91.git
#	export KERNEL_DIR=$PWD/linux-at91
#	cd dt-overlay-at91
#	make sama5d27_som1_ek_dtbos
#	make sama5d27_som1_ek.itb
#	cd ..	
fi
if [ -d "./linux-at91" ]
then
	echo 'Copy '${kernel_resF}' to '${result_p}
	echo 'Copy '${dtb_resF}' to '${result_p}
	#cp dt-overlay-at91/${itb_resF} ./${result_p}
	cp linux-at91/arch/arm/boot/${kernel_resF} ./${result_p}
	cp linux-at91/arch/arm/boot/dts/${dtb_resF} ./${result_p}
else
	echo -e "${COLOR_ERR}linux-at91 is not existed. please enable build_kernel.${COLOR_RST}"
fi
# -------------------------------------------------------------------------------------------------
