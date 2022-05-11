// Linux4Sam 2022.04

git clone git://git.yoctoproject.org/poky -b dunfell
git clone git://git.openembedded.org/meta-openembedded -b dunfell
git clone git://github.com/aws/meta-aws -b dunfell
git clone git://github.com/linux4sam/meta-atmel.git -b dunfell
cd poky
export TEMPLATECONF=${TEMPLATECONF:-../meta-atmel/conf}
source oe-init-build-env build-microchip
MACHINE=sama7g5ek-sd bitbake microchip-headless-image
MACHINE=sama7g5ek-emmc bitbake microchip-headless-image
