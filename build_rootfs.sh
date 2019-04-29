#!/bin/bash

# -------------------------------------------------------------------------------------------------
# build and copy buildroot
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '************************        building root filesystem           **************************'
echo '*********************************************************************************************'
if [ $build_rootfs -eq 1 ]
then
	if ! [ -d "./buildroot-at91" ]
	then
		git clone https://github.com/linux4sam/buildroot-at91.git
		git clone https://github.com/linux4sam/buildroot-external-microchip.git
		cd buildroot-at91
		BR2_EXTERNAL=../buildroot-external-microchip/ make sama5d27_som1_ek_headless_defconfig
		cd ..

		# copy patches
		# TODO...
	fi
	
	cd buildroot-at91
	make -j8
	cd ..
fi
if [ -d "./buildroot-at91" ] 
	then
	echo 'Copy '${rfs_resF}' to '${result_p}
	cp ./buildroot-at91/output/images/${rfs_resF} ${result_p}
else
	echo -e "${COLOR_ERR}buildroot-at91 is not existed. please enable build_rootfs.${COLOR_RST}"
fi
# -------------------------------------------------------------------------------------------------

