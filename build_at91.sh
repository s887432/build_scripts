#!/bin/bash

# -------------------------------------------------------------------------------------------------
# build and copy buildroot
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '************************       building at91bootstrapt             **************************'
echo '*********************************************************************************************'

if [ $build_bootstrap -eq 1 ]
then
	if ! [ -d "./at91bootstrap" ] 
	then
		git clone git://github.com/linux4sam/at91bootstrap.git
		cd at91bootstrap
		make mrproper
		make sama5d27_som1_eksd1_uboot_defconfig
		cd ..
	fi

	cd at91bootstrap	
	make -j8
	cd ..
fi
if [ -d "./at91bootstrap" ] 
	then
	echo 'Copy '${at91bootstrap_resF}' to '${result_p}
	cp ./at91bootstrap/binaries/${at91bootstrap_resF} ${result_p}
else
	echo -e "${COLOR_ERR}at91bootstrap is not existed. please enable build_bootstrap.${COLOR_RST}"
fi
# -------------------------------------------------------------------------------------------------
