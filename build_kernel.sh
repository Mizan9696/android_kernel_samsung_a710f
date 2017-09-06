#!/bin/bash
redt=$(tput setaf 1)
redb=$(tput setab 1)
greent=$(tput setaf 2)
greenb=$(tput setab 2)
yellowt=$(tput setaf 3)
yellowb=$(tput setab 3)
bluet=$(tput setaf 4)
blueb=$(tput setab 4)
magentat=$(tput setaf 5)
magentab=$(tput setab 5)
cyant=$(tput setaf 6)
cyanb=$(tput setab 6)
whiteb=$(tput setab 7)
bold=$(tput bold)
italic=$(tput sitm)
stand=$(tput smso)
underline=$(tput smul)
normal=$(tput sgr0)
clears=$(tput clear)
export KERNELDIR=`readlink -f .`
COMMON_ARGS="-C $(pwd) O=$(pwd)/${OUT_DIR} ARCH=arm64 CROSS_COMPILE=~/kenn/aarch64-linux-android-4.9/bin/aarch64-linux-android-
OUT_DIR=${KERNELDIR}/out
export PATH=~/kenn/aarch64-linux-android-4.9/bin:$PATH

if [ ! -f $KERNELDIR/.config ];
then
    make ${COMMON_ARGS} exynos7580-a7xelte_defconfig
fi
. $KERNELDIR/.config
echo "$yellowb Clearing DTB files ..."
rm ${OUT_DIR}/arch/arm64/boot/dts/*.dtb 2>/dev/null
echo "$greenb Cross-compiling kernel ..."
cd $KERNELDIR/
make ${COMMON_ARGS}
rm -rf $KERNELDIR/BUILT_a710
mkdir -p $KERNELDIR/BUILT_a710/lib/modules
echo "$yellowb Searching for modules and moving to BUILD_a710" 
find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_a710/lib/modules/ \;
echo ""
echo "$greenb Stripping unneeded symbols and debug info from module(s)..."
${CROSS_COMPILE}strip --strip-unneeded $KERNELDIR/BUILT_a710/lib/modules/* 
mkdir -p $KERNELDIR/BUILT_a710/lib/modules/
mv ${OUT_DIR}/arch/arm64/boot/zImage $KERNELDIR/BUILT_a710/
echo ""
cd $KERNELDIR/
echo ""
echo "$clears"
	echo ""
	echo "------------------------------------------------------"
echo "$bold$stand                   BUILT_a710 is ready.                   $normal"
echo "------------------------------------------------------"
	echo ""
