#!/bin/bash

# -------------------------------------------------------------------------------------------------
# build and copy applciation
# -------------------------------------------------------------------------------------------------
echo '*********************************************************************************************'
echo '************************         building applications             **************************'
echo '*********************************************************************************************'
if [ $build_app -eq 1 ]
then
	if ! [ -d "./app" ] 
	then
		mkdir -p app
	fi
	cd app
	if ! [ -d "./helloworld" ] 
	then
	git clone git://github.com/s887432/helloworld.git
	fi
	cd helloworld
	make
	cp helloworld ./../../${result_p}/app
	cd ../../
fi