
#!/bin/bash

# -------------------------------------------------------------------------------------------------
# build and copy u-boot
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '************************            building u-boot                **************************'
echo '*********************************************************************************************'

if [ $build_uboot -eq 1 ]
then
	if ! [ -d "./u-boot-at91" ] 
	then
		git clone git://github.com/linux4sam/u-boot-at91.git
		cd u-boot-at91
		make sama5d27_som1_ek_mmc1_defconfig
		cd ..
	fi

	cd u-boot-at91
	make -j8
	cd ..
fi
if [ -d "./u-boot-at91" ] 
then
	echo 'Copy '${u_boot_resF}' to '${result_p}
	cp u-boot-at91/${u_boot_resF} ./${result_p}
else
	echo -e "${COLOR_ERR}u-boot-at91 is not existed. please enable build_uboot.${COLOR_RST}"
fi
# -------------------------------------------------------------------------------------------------
