
if [ $build_sdcard -eq 1 ]
then
	echo '*********************************************************************************************'
	echo '************************        building SD card image             **************************'
	echo '*********************************************************************************************'

	temp=$(losetup -f)
	loop_dev_1=${temp:5}
	loop_dev_2='loop'$((${temp:9}+1))

	if ! [ -d ${result_p} ]
	then
		echo -e "${COLOR_ERR}The output files are not exixted. Please launch auto_build.sh first.${COLOR_RST}"
		exit 0
	fi

	cd ${result_p}

	if ! [ -f ${sdcard_img} ]
	then
		sudo rm -rf ${sdcard_img}
	fi

	if ! [ -f ${mnt1} ]
	then
		sudo rm -rf ${mnt1}
	fi

	if ! [ -f ${mnt2} ]
	then
		sudo rm -rf ${mnt2}
	fi

	echo ""	
	echo "step1: create dummy sd_card.img filename................."

	dd if=/dev/zero of=./${sdcard_img} bs=$sd_card_size count=1

	#----------- partition SDCard -------------
	echo ""	
	echo "step2: partition the sd_card.img file................."
	(echo n; echo p; echo 1; echo $first_offset_sectors; echo "+"$first_partitionMB"M"; echo t; echo c; echo n; echo p; echo 2; echo " "; echo " "; echo w) | sudo fdisk ./${sdcard_img}

	sudo fdisk -l ./${sdcard_img}

	#----------- mount partitions -------------
	echo ""	
	echo "step3: mount the partitions on loop devices..............."
	echo first_offset: $first_offset
	echo second_offset: $second_offset
	echo loop_dev_1: $loop_dev_1
	echo loop_dev_2: $loop_dev_2

	sudo losetup /dev/${loop_dev_1} ./${sdcard_img} -o $first_offset --sizelimit ${first_partition}
	sudo losetup /dev/${loop_dev_2} ./${sdcard_img} -o $second_offset

	#----------- format partitions -------------
	echo ""	
	echo "step4: format the partitions................"
	sudo mkfs.vfat /dev/${loop_dev_1}
	sudo mkfs.ext4 /dev/${loop_dev_2}
		
	#----------- create partitions and directories -------------
	echo ""	
	echo "step5:create and mount directories and partititions.........."
	mkdir -p ${mnt1}
	mkdir -p ${mnt2}
	sudo mount -o loop,offset=$first_offset,sizelimit=$first_partition ${sdcard_img} ${mnt1}
	sudo mount -o loop,offset=$second_offset ${sdcard_img} ${mnt2}
		
	#----------- copy files for emmcmntp1 -------------
	echo ""	
	echo "step6: copy files for emmcmntp1................ "
	sudo cp ${at91bootstrap_resF} ${mnt1}
	sudo cp ${u_boot_resF} ${mnt1}
	sudo cp ${u_boot_env_resF} ${mnt1}
	sudo cp ${kernel_resF} ${mnt1}
	sudo cp ${dtb_resF} ${mnt1}

	#----------- copy built rootfs for emmcmntp2 -------------
	echo ""	
	echo "step7: copy built rootfs for emmcmntp2................"	
	echo copy minimal root file system......
	sudo tar -C ${mnt2} -xvf ${rfs_resF}
	cd ..
	
	#----------- copy applications ---------------------------
	echo ""
	echo "step 8: copy applications to root fs
	sudo cp ${result_p}/app/* ${result_p}/{mnt2}/opt/

	#----------- umount and finish -------------
	echo ""	
	echo "step9: unmounting partititions............"

	sudo umount /dev/${loop_dev_1}
	sudo umount /dev/${loop_dev_2}
	sudo losetup -d /dev/${loop_dev_1}
	sudo losetup -d /dev/${loop_dev_2}

	echo ""
	echo "######## END part2: creating SDCard ###########"
	echo ""

	cd ..

fi

